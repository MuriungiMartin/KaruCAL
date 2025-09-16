#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 10145 "E-Invoice Mgt."
{
    Permissions = TableData "Sales Invoice Header"=rimd,
                  TableData "Sales Cr.Memo Header"=rimd;

    trigger OnRun()
    begin
    end;

    var
        Customer: Record Customer;
        GLSetup: Record "General Ledger Setup";
        CompanyInfo: Record "Company Information";
        SourceCodeSetup: Record "Source Code Setup";
        DocNameSpace: Text;
        Text000: label 'Dear customer, please find invoice number %1 in the attachment.';
        Text001: label 'E-Document %1 has been sent.';
        Text002: label 'One or more invoices have already been sent.\Do you want to continue?';
        Text004: label 'Dear customer, please find credit memo number %1 in the attachment.';
        Text005: label 'Invoice no. %1.';
        Text006: label 'Credit memo no. %1.';
        Export: Boolean;
        Text007: label 'You cannot perform this action on a deleted document.';
        Text008: label '&Request Stamp,&Send,Request Stamp &and Send';
        Text009: label 'Cannot find a valid PAC web service for the action %1.\You must specify web service details for the combination of the %1 action and the %2 and %3 that you have selected in the %4 window.';
        Text010: label 'You cannot choose the action %1 when the document status is %2.';
        EDocAction: Option "Request Stamp",Send,Cancel;
        Text011: label 'There is no electronic stamp for document no. %1.\Do you want to continue?';
        MethodType: Option "Request Stamp",Cancel;
        Text012: label 'Cannot contact the PAC. You must specify a value for the %1 field in the %2 window for the PAC that you selected in the %3 window. ';
        Text013: label 'Request Stamp,Send,Cancel';
        Text014: label 'You cannot perform this action because the %1 field in the %2 window is set to %3.';
        Text015: label 'Do you want to cancel the electronic document?';
        Text016: label 'The SMTP mail system returned the following error: %1.';
        FileDialogTxt: label 'Import electronic invoice';
        ImportFailedErr: label 'The import failed. The XML document is not a valid electronic invoice.';
        WebClientErr: label 'The import is not supported on the webclient.';


    procedure RequestStampDocument(var RecRef: RecordRef)
    var
        Selection: Integer;
        ElectronicDocumentStatus: Option;
    begin
        // Called from Send Action
        Export := false;
        GetCompanyInfo;
        GetGLSetup;
        SourceCodeSetup.Get;
        Selection := StrMenu(Text008,3);

        ElectronicDocumentStatus := RecRef.Field(10030).Value;

        case Selection of
          1:// Request Stamp
            begin
              EDocActionValidation(Edocaction::"Request Stamp",ElectronicDocumentStatus);
              RequestStamp(RecRef);
            end;
          2:// Send
            begin
              EDocActionValidation(Edocaction::Send,ElectronicDocumentStatus);
              Send(RecRef);
            end;
          3:// Request Stamp and Send
            begin
              EDocActionValidation(Edocaction::"Request Stamp",ElectronicDocumentStatus);
              RequestStamp(RecRef);
              Commit;
              ElectronicDocumentStatus := RecRef.Field(10030).Value;
              EDocActionValidation(Edocaction::Send,ElectronicDocumentStatus);
              Send(RecRef);
            end;
        end;
    end;


    procedure CancelDocument(var RecRef: RecordRef)
    var
        SalesInvHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        ServiceInvHeader: Record "Service Invoice Header";
        ServiceCrMemoHeader: Record "Service Cr.Memo Header";
    begin
        if not Confirm(Text015,false) then
          exit;
        Export := false;
        GetCompanyInfo;
        GetGLSetup;
        SourceCodeSetup.Get;

        case RecRef.Number of
          Database::"Sales Invoice Header":
            begin
              RecRef.SetTable(SalesInvHeader);
              EDocActionValidation(Edocaction::Cancel,SalesInvHeader."Electronic Document Status");
              CancelESalesInvoice(SalesInvHeader);
            end;
          Database::"Sales Cr.Memo Header":
            begin
              RecRef.SetTable(SalesCrMemoHeader);
              EDocActionValidation(Edocaction::Cancel,SalesCrMemoHeader."Electronic Document Status");
              CancelESalesCrMemo(SalesCrMemoHeader);
            end;
          Database::"Service Invoice Header":
            begin
              RecRef.SetTable(ServiceInvHeader);
              EDocActionValidation(Edocaction::Cancel,ServiceInvHeader."Electronic Document Status");
              CancelEServiceInvoice(ServiceInvHeader);
            end;
          Database::"Service Cr.Memo Header":
            begin
              RecRef.SetTable(ServiceCrMemoHeader);
              EDocActionValidation(Edocaction::Cancel,ServiceCrMemoHeader."Electronic Document Status");
              CancelEServiceCrMemo(ServiceCrMemoHeader);
            end;
        end;
    end;


    procedure EDocActionValidation("Action": Option "Request Stamp",Send,Cancel;Status: Option " ","Stamp Received",Sent,Canceled,"Stamp Request Error","Cancel Error") Selection: Integer
    var
        TempSalesInvoiceHeader: Record "Sales Invoice Header" temporary;
    begin
        TempSalesInvoiceHeader."Electronic Document Status" := Status;

        if Action = Action::"Request Stamp" then
          if Status in [Status::"Stamp Received",Status::Sent,Status::"Cancel Error",Status::Canceled] then
            Error(Text010,SelectStr(Action + 1,Text013),TempSalesInvoiceHeader."Electronic Document Status");

        if Action = Action::Send then
          if Status in [Status::" ",Status::Canceled,Status::"Cancel Error",Status::"Stamp Request Error"] then
            Error(Text010,SelectStr(Action + 1,Text013),TempSalesInvoiceHeader."Electronic Document Status");

        if Action = Action::Cancel then
          if Status in [Status::" ",Status::Canceled,Status::"Stamp Request Error"] then
            Error(Text010,SelectStr(Action + 1,Text013),TempSalesInvoiceHeader."Electronic Document Status");
    end;


    procedure EDocPrintValidation(EDocStatus: Option " ","Stamp Received",Sent,Canceled,"Stamp Request Error","Cancel Error";DocNo: Code[20])
    begin
        GLSetup.Get;
        if (GLSetup."PAC Environment" <> GLSetup."pac environment"::Disabled) and
           (EDocStatus in [Edocstatus::" ",Edocstatus::Canceled,Edocstatus::"Cancel Error",Edocstatus::"Stamp Request Error"])
        then
          if not Confirm(StrSubstNo(Text011,DocNo)) then
            Error('');
    end;

    local procedure RequestStamp(var DocumentHeaderRecordRef: RecordRef)
    var
        TempDocumentHeader: Record UnknownRecord10002 temporary;
        TempDocumentLine: Record UnknownRecord10003 temporary;
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        ServiceInvoiceHeader: Record "Service Invoice Header";
        ServiceCrMemoHeader: Record "Service Cr.Memo Header";
        TempBlobOriginalString: Record TempBlob;
        TempBlobDigitalStamp: Record TempBlob;
        XMLDOMManagement: Codeunit "XML DOM Management";
        OutStrOriginalDoc: OutStream;
        OutStrSignedDoc: OutStream;
        XMLDoc: dotnet XmlDocument;
        XMLDocResult: dotnet XmlDocument;
        Environment: dotnet Environment;
        OriginalString: Text;
        SignedString: Text;
        Certificate: Text;
        Response: Text;
        DateTimeFirstReqSent: Text[50];
        CertificateSerialNo: Text[250];
        SubTotal: Decimal;
        RetainAmt: Decimal;
        AmountInclVAT: Decimal;
    begin
        Export := true;

        case DocumentHeaderRecordRef.Number of
          Database::"Sales Invoice Header":
            begin
              DocumentHeaderRecordRef.SetTable(SalesInvoiceHeader);
              CreateAbstractDocument(SalesInvoiceHeader,TempDocumentHeader,TempDocumentLine);
              ValidateSalesInvoice(SalesInvoiceHeader);
              DateTimeFirstReqSent := GetDateTimeOfFirstReqSalesInv(SalesInvoiceHeader);
              CalcSalesInvLineTotal(SubTotal,RetainAmt,TempDocumentHeader."No.");
              SalesInvoiceHeader.CalcFields("Amount Including VAT");
              TempDocumentHeader."Amount Including VAT" := SalesInvoiceHeader."Amount Including VAT";
            end;
          Database::"Sales Cr.Memo Header":
            begin
              DocumentHeaderRecordRef.SetTable(SalesCrMemoHeader);
              CreateAbstractDocument(SalesCrMemoHeader,TempDocumentHeader,TempDocumentLine);
              ValidateSalesCrMemo(SalesCrMemoHeader);
              DateTimeFirstReqSent := GetDateTimeOfFirstReqSalesCr(SalesCrMemoHeader);
              CalcSalesCrMemoLineTotal(SubTotal,RetainAmt,TempDocumentHeader."No.");
              SalesCrMemoHeader.CalcFields("Amount Including VAT");
              TempDocumentHeader."Amount Including VAT" := SalesCrMemoHeader."Amount Including VAT";
            end;
          Database::"Service Invoice Header":
            begin
              DocumentHeaderRecordRef.SetTable(ServiceInvoiceHeader);
              CreateAbstractDocument(ServiceInvoiceHeader,TempDocumentHeader,TempDocumentLine);
              ValidateServiceInvoice(ServiceInvoiceHeader);
              DateTimeFirstReqSent := GetDateTimeOfFirstReqServInv(ServiceInvoiceHeader);
              CalcServiceInvLineTotal(SubTotal,RetainAmt,AmountInclVAT,TempDocumentHeader."No.");
              TempDocumentHeader."Amount Including VAT" := AmountInclVAT;
            end;
          Database::"Service Cr.Memo Header":
            begin
              DocumentHeaderRecordRef.SetTable(ServiceCrMemoHeader);
              CreateAbstractDocument(ServiceCrMemoHeader,TempDocumentHeader,TempDocumentLine);
              ValidateServiceCrMemo(ServiceCrMemoHeader);
              DateTimeFirstReqSent := GetDateTimeOfFirstReqServCr(ServiceCrMemoHeader);
              CalcServiceCrMemoLineTotal(SubTotal,RetainAmt,AmountInclVAT,TempDocumentHeader."No.");
              TempDocumentHeader."Amount Including VAT" := AmountInclVAT;
            end;
        end;

        GetCustomer(TempDocumentHeader."Bill-to/Pay-To No.");

        // Create Digital Stamp
        CreateOriginalStr(TempDocumentHeader,TempDocumentLine,DateTimeFirstReqSent,SubTotal,RetainAmt,
          DocumentHeaderRecordRef.Number in [Database::"Sales Cr.Memo Header",Database::"Service Cr.Memo Header"],
          TempBlobOriginalString);
        OriginalString := TempBlobOriginalString.ReadAsText(Environment.NewLine,Textencoding::MSDos);
        CreateDigitalSignature(OriginalString,SignedString,CertificateSerialNo,Certificate);
        TextToBlob(TempBlobDigitalStamp,SignedString);

        // Create Original XML
        CreateXMLDocument(
          TempDocumentHeader,TempDocumentLine,DateTimeFirstReqSent,SignedString,Certificate,CertificateSerialNo,SubTotal,RetainAmt,
          DocumentHeaderRecordRef.Number in [Database::"Sales Cr.Memo Header",Database::"Service Cr.Memo Header"],XMLDoc);

        case DocumentHeaderRecordRef.Number of
          Database::"Sales Invoice Header":
            with SalesInvoiceHeader do begin
              "Original String" := TempBlobOriginalString.Blob;
              "Digital Stamp SAT" := TempBlobDigitalStamp.Blob;
              "Certificate Serial No." := CertificateSerialNo;
              "Original Document XML".CreateOutstream(OutStrOriginalDoc);
              "Signed Document XML".CreateOutstream(OutStrSignedDoc);
              XMLDoc.Save(OutStrOriginalDoc);
              Modify;
            end;
          Database::"Sales Cr.Memo Header":
            with SalesCrMemoHeader do begin
              "Original String" := TempBlobOriginalString.Blob;
              "Digital Stamp SAT" := TempBlobDigitalStamp.Blob;
              "Certificate Serial No." := CertificateSerialNo;
              "Original Document XML".CreateOutstream(OutStrOriginalDoc);
              "Signed Document XML".CreateOutstream(OutStrSignedDoc);
              XMLDoc.Save(OutStrOriginalDoc);
              Modify;
            end;
          Database::"Service Invoice Header":
            with ServiceInvoiceHeader do begin
              "Original String" := TempBlobOriginalString.Blob;
              "Digital Stamp SAT" := TempBlobDigitalStamp.Blob;
              "Certificate Serial No." := CertificateSerialNo;
              "Original Document XML".CreateOutstream(OutStrOriginalDoc);
              "Signed Document XML".CreateOutstream(OutStrSignedDoc);
              XMLDoc.Save(OutStrOriginalDoc);
              Modify;
            end;
          Database::"Service Cr.Memo Header":
            with ServiceCrMemoHeader do begin
              "Original String" := TempBlobOriginalString.Blob;
              "Digital Stamp SAT" := TempBlobDigitalStamp.Blob;
              "Certificate Serial No." := CertificateSerialNo;
              "Original Document XML".CreateOutstream(OutStrOriginalDoc);
              "Signed Document XML".CreateOutstream(OutStrSignedDoc);
              XMLDoc.Save(OutStrOriginalDoc);
              Modify;
            end;
        end;

        Commit;

        Response := InvokeMethod(XMLDoc,Methodtype::"Request Stamp");

        // For Test Mocking
        if not GLSetup."Sim. Request Stamp" then begin
          XMLDOMManagement.LoadXMLDocumentFromText(Response,XMLDocResult);
          XMLDocResult.Save(OutStrSignedDoc);
        end;

        case DocumentHeaderRecordRef.Number of
          Database::"Sales Invoice Header":
            begin
              ProcessResponseESalesInvoice(SalesInvoiceHeader,Edocaction::"Request Stamp");
              SalesInvoiceHeader.Modify;
              DocumentHeaderRecordRef.GetTable(SalesInvoiceHeader);
            end;
          Database::"Sales Cr.Memo Header":
            begin
              ProcessResponseESalesCrMemo(SalesCrMemoHeader,Edocaction::"Request Stamp");
              SalesCrMemoHeader.Modify;
              DocumentHeaderRecordRef.GetTable(SalesCrMemoHeader);
            end;
          Database::"Service Invoice Header":
            begin
              ProcessResponseEServiceInvoice(ServiceInvoiceHeader,Edocaction::"Request Stamp",AmountInclVAT);
              ServiceInvoiceHeader.Modify;
              DocumentHeaderRecordRef.GetTable(ServiceInvoiceHeader);
            end;
          Database::"Service Cr.Memo Header":
            begin
              ProcessResponseEServiceCrMemo(ServiceCrMemoHeader,Edocaction::"Request Stamp",AmountInclVAT);
              ServiceCrMemoHeader.Modify;
              DocumentHeaderRecordRef.GetTable(ServiceCrMemoHeader);
            end;
        end;
    end;

    local procedure Send(var DocumentHeaderRecordRef: RecordRef)
    var
        SalesInvHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        ServiceInvHeader: Record "Service Invoice Header";
        ServiceCrMemoHeader: Record "Service Cr.Memo Header";
    begin
        case DocumentHeaderRecordRef.Number of
          Database::"Sales Invoice Header":
            begin
              DocumentHeaderRecordRef.SetTable(SalesInvHeader);
              SendESalesInvoice(SalesInvHeader);
            end;
          Database::"Sales Cr.Memo Header":
            begin
              DocumentHeaderRecordRef.SetTable(SalesCrMemoHeader);
              SendESalesCrMemo(SalesCrMemoHeader);
            end;
          Database::"Service Invoice Header":
            begin
              DocumentHeaderRecordRef.SetTable(ServiceInvHeader);
              SendEServiceInvoice(ServiceInvHeader);
            end;
          Database::"Service Cr.Memo Header":
            begin
              DocumentHeaderRecordRef.SetTable(ServiceCrMemoHeader);
              SendEServiceCrMemo(ServiceCrMemoHeader);
            end;
        end;
    end;

    local procedure SendESalesInvoice(var SalesInvHeader: Record "Sales Invoice Header")
    var
        TempBlob: Record TempBlob;
        ReportSelection: Record "Report Selections";
        SalesInvHeaderLoc: Record "Sales Invoice Header";
        DocumentHeaderRef: RecordRef;
        XMLInstream: InStream;
        FileNameEdoc: Text;
        PDFFileName: Text;
    begin
        GetCustomer(SalesInvHeader."Bill-to Customer No.");
        Customer.TestField("E-Mail");
        if SalesInvHeader."No. of E-Documents Sent" <> 0 then
          if not Confirm(Text002) then
            Error('');

        // Export XML
        SalesInvHeader.CalcFields("Signed Document XML");
        TempBlob.Blob := SalesInvHeader."Signed Document XML";
        TempBlob.Blob.CreateInstream(XMLInstream);
        FileNameEdoc := SalesInvHeader."No." + '.xml';

        if GLSetup."Send PDF Report" then begin
          DocumentHeaderRef.GetTable(SalesInvHeader);
          ReportSelection.SetRange(Usage,ReportSelection.Usage::"S.Invoice");
          PDFFileName := SaveAsPDFOnServer(DocumentHeaderRef,GetReportNo(ReportSelection));
        end;

        // Reset No. Printed
        SalesInvHeaderLoc.Get(SalesInvHeader."No.");
        SalesInvHeaderLoc."No. Printed" := SalesInvHeader."No. Printed";
        SalesInvHeaderLoc.Modify;

        // Send Email with Attachments
        SendEmail(Customer."E-Mail",StrSubstNo(Text005,SalesInvHeader."No."),
          StrSubstNo(Text000,SalesInvHeader."No."),FileNameEdoc,PDFFileName,GLSetup."Send PDF Report",XMLInstream);

        SalesInvHeaderLoc.Get(SalesInvHeader."No.");
        SalesInvHeaderLoc."No. of E-Documents Sent" := SalesInvHeaderLoc."No. of E-Documents Sent" + 1;
        if not SalesInvHeaderLoc."Electronic Document Sent" then
          SalesInvHeaderLoc."Electronic Document Sent" := true;
        SalesInvHeaderLoc."Electronic Document Status" := SalesInvHeaderLoc."electronic document status"::Sent;
        SalesInvHeaderLoc."Date/Time Sent" := FormatDateTime(CurrentDatetime);
        SalesInvHeaderLoc.Modify;

        Message(Text001,SalesInvHeader."No.");
    end;

    local procedure SendESalesCrMemo(var SalesCrMemoHeader: Record "Sales Cr.Memo Header")
    var
        TempBlob: Record TempBlob;
        ReportSelection: Record "Report Selections";
        SalesCrMemoHeaderLoc: Record "Sales Cr.Memo Header";
        DocumentHeaderRef: RecordRef;
        XMLInstream: InStream;
        FileNameEdoc: Text;
        PDFFileName: Text;
    begin
        GetCustomer(SalesCrMemoHeader."Bill-to Customer No.");
        Customer.TestField("E-Mail");
        if SalesCrMemoHeader."No. of E-Documents Sent" <> 0 then
          if not Confirm(Text002) then
            Error('');
        // Export XML
        SalesCrMemoHeader.CalcFields("Signed Document XML");
        TempBlob.Blob := SalesCrMemoHeader."Signed Document XML";
        TempBlob.Blob.CreateInstream(XMLInstream);
        FileNameEdoc := SalesCrMemoHeader."No." + '.xml';

        if GLSetup."Send PDF Report" then begin
          DocumentHeaderRef.GetTable(SalesCrMemoHeader);
          ReportSelection.SetRange(Usage,ReportSelection.Usage::"S.Cr.Memo");
          PDFFileName := SaveAsPDFOnServer(DocumentHeaderRef,GetReportNo(ReportSelection));
        end;

        // Reset No. Printed
        SalesCrMemoHeaderLoc.Get(SalesCrMemoHeader."No.");
        SalesCrMemoHeaderLoc."No. Printed" := SalesCrMemoHeader."No. Printed";
        SalesCrMemoHeaderLoc.Modify;

        // Send Email with Attachments
        SendEmail(Customer."E-Mail",StrSubstNo(Text006,SalesCrMemoHeader."No."),
          StrSubstNo(Text004,SalesCrMemoHeader."No."),FileNameEdoc,PDFFileName,GLSetup."Send PDF Report",XMLInstream);

        SalesCrMemoHeaderLoc.Get(SalesCrMemoHeader."No.");
        SalesCrMemoHeaderLoc."No. of E-Documents Sent" := SalesCrMemoHeaderLoc."No. of E-Documents Sent" + 1;
        if not SalesCrMemoHeaderLoc."Electronic Document Sent" then
          SalesCrMemoHeaderLoc."Electronic Document Sent" := true;
        SalesCrMemoHeaderLoc."Electronic Document Status" := SalesCrMemoHeaderLoc."electronic document status"::Sent;
        SalesCrMemoHeaderLoc."Date/Time Sent" := FormatDateTime(CurrentDatetime);
        SalesCrMemoHeaderLoc.Modify;

        Message(Text001,SalesCrMemoHeader."No.");
    end;

    local procedure SendEServiceInvoice(var ServiceInvoiceHeader: Record "Service Invoice Header")
    var
        TempBlob: Record TempBlob;
        ReportSelection: Record "Report Selections";
        ServiceInvoiceHeaderLoc: Record "Service Invoice Header";
        DocumentHeaderRef: RecordRef;
        XMLInstream: InStream;
        FileNameEdoc: Text;
        PDFFileName: Text;
    begin
        GetCustomer(ServiceInvoiceHeader."Bill-to Customer No.");
        Customer.TestField("E-Mail");
        if ServiceInvoiceHeader."No. of E-Documents Sent" <> 0 then
          if not Confirm(Text002) then
            Error('');
        // Export XML
        ServiceInvoiceHeader.CalcFields("Signed Document XML");
        TempBlob.Blob := ServiceInvoiceHeader."Signed Document XML";
        TempBlob.Blob.CreateInstream(XMLInstream);
        FileNameEdoc := ServiceInvoiceHeader."No." + '.xml';

        if GLSetup."Send PDF Report" then begin
          DocumentHeaderRef.GetTable(ServiceInvoiceHeader);
          ReportSelection.SetRange(Usage,ReportSelection.Usage::"SM.Invoice");
          PDFFileName := SaveAsPDFOnServer(DocumentHeaderRef,GetReportNo(ReportSelection));
        end;

        // Reset No. Printed
        ServiceInvoiceHeaderLoc.Get(ServiceInvoiceHeader."No.");
        ServiceInvoiceHeaderLoc."No. Printed" := ServiceInvoiceHeader."No. Printed";
        ServiceInvoiceHeaderLoc.Modify;

        // Send Email with Attachments
        SendEmail(Customer."E-Mail",StrSubstNo(Text005,ServiceInvoiceHeader."No."),
          StrSubstNo(Text000,ServiceInvoiceHeader."No."),FileNameEdoc,PDFFileName,GLSetup."Send PDF Report",XMLInstream);

        ServiceInvoiceHeaderLoc.Get(ServiceInvoiceHeader."No.");
        ServiceInvoiceHeaderLoc."No. of E-Documents Sent" := ServiceInvoiceHeaderLoc."No. of E-Documents Sent" + 1;
        if not ServiceInvoiceHeaderLoc."Electronic Document Sent" then
          ServiceInvoiceHeaderLoc."Electronic Document Sent" := true;
        ServiceInvoiceHeaderLoc."Electronic Document Status" := ServiceInvoiceHeaderLoc."electronic document status"::Sent;
        ServiceInvoiceHeaderLoc."Date/Time Sent" := FormatDateTime(CurrentDatetime);
        ServiceInvoiceHeaderLoc.Modify;

        Message(Text001,ServiceInvoiceHeader."No.");
    end;

    local procedure SendEServiceCrMemo(var ServiceCrMemoHeader: Record "Service Cr.Memo Header")
    var
        TempBlob: Record TempBlob;
        ReportSelection: Record "Report Selections";
        ServiceCrMemoHeaderLoc: Record "Service Cr.Memo Header";
        DocumentHeaderRef: RecordRef;
        XMLInstream: InStream;
        FileNameEdoc: Text;
        PDFFileName: Text;
    begin
        GetCustomer(ServiceCrMemoHeader."Bill-to Customer No.");
        Customer.TestField("E-Mail");
        if ServiceCrMemoHeader."No. of E-Documents Sent" <> 0 then
          if not Confirm(Text002) then
            Error('');
        // Export XML
        ServiceCrMemoHeader.CalcFields("Signed Document XML");
        TempBlob.Blob := ServiceCrMemoHeader."Signed Document XML";
        TempBlob.Blob.CreateInstream(XMLInstream);
        FileNameEdoc := ServiceCrMemoHeader."No." + '.xml';

        if GLSetup."Send PDF Report" then begin
          DocumentHeaderRef.GetTable(ServiceCrMemoHeader);
          ReportSelection.SetRange(Usage,ReportSelection.Usage::"SM.Credit Memo");
          PDFFileName := SaveAsPDFOnServer(DocumentHeaderRef,GetReportNo(ReportSelection));
        end;

        // Reset No. Printed
        ServiceCrMemoHeaderLoc.Get(ServiceCrMemoHeader."No.");
        ServiceCrMemoHeaderLoc."No. Printed" := ServiceCrMemoHeader."No. Printed";
        ServiceCrMemoHeaderLoc.Modify;

        // Send Email with Attachments
        SendEmail(Customer."E-Mail",StrSubstNo(Text006,ServiceCrMemoHeader."No."),
          StrSubstNo(Text004,ServiceCrMemoHeader."No."),FileNameEdoc,PDFFileName,GLSetup."Send PDF Report",XMLInstream);

        ServiceCrMemoHeaderLoc.Get(ServiceCrMemoHeader."No.");
        ServiceCrMemoHeaderLoc."No. of E-Documents Sent" := ServiceCrMemoHeaderLoc."No. of E-Documents Sent" + 1;
        if not ServiceCrMemoHeaderLoc."Electronic Document Sent" then
          ServiceCrMemoHeaderLoc."Electronic Document Sent" := true;
        ServiceCrMemoHeaderLoc."Electronic Document Status" := ServiceCrMemoHeaderLoc."electronic document status"::Sent;
        ServiceCrMemoHeaderLoc."Date/Time Sent" := FormatDateTime(CurrentDatetime);
        ServiceCrMemoHeaderLoc.Modify;

        Message(Text001,ServiceCrMemoHeader."No.");
    end;

    local procedure CancelESalesInvoice(var SalesInvHeader: Record "Sales Invoice Header")
    var
        TempBlob: Record TempBlob;
        XMLDOMManagement: Codeunit "XML DOM Management";
        XMLDoc: dotnet XmlDocument;
        XMLCurrNode: dotnet XmlNode;
        XMLNewChild: dotnet XmlNode;
        Response: Text;
        OutStr: OutStream;
        CancelDateTime: Text[50];
    begin
        if SalesInvHeader."Source Code" = SourceCodeSetup."Deleted Document" then
          Error(Text007);

        // Create instance
        if IsNull(XMLDoc) then
          XMLDoc := XMLDoc.XmlDocument;

        DocNameSpace := 'http://www.sat.gob.mx/cfd/3';
        XMLDOMManagement.LoadXMLDocumentFromText('<?xml version="1.0" encoding="UTF-8" ?> <CancelaCFD /> ',XMLDoc);
        XMLCurrNode := XMLDoc.DocumentElement;
        AddElement(XMLCurrNode,'Cancelacion','','',XMLNewChild);
        XMLCurrNode := XMLNewChild;
        with SalesInvHeader do begin
          CancelDateTime := FormatDateTime(CurrentDatetime);
          AddAttribute(XMLDoc,XMLCurrNode,'Fecha',CancelDateTime);
          "Date/Time Canceled" := CancelDateTime;
          AddAttribute(XMLDoc,XMLCurrNode,'RfcEmisor',CompanyInfo."RFC No.");
          AddElement(XMLCurrNode,'Folios','','',XMLNewChild);
          XMLCurrNode := XMLNewChild;
          AddElement(XMLCurrNode,'Folio','','',XMLNewChild);
          XMLCurrNode := XMLNewChild;
          AddAttribute(XMLDoc,XMLCurrNode,'FechaTimbrado',"Date/Time Stamped");
          AddAttribute(XMLDoc,XMLCurrNode,'UUID',"Fiscal Invoice Number PAC");
          "Original Document XML".CreateOutstream(OutStr);
          XMLDoc.Save(OutStr);
        end;

        Response := InvokeMethod(XMLDoc,Methodtype::Cancel);

        // For Test Mocking
        if not GLSetup."Sim. Request Stamp" then begin
          TextToBlob(TempBlob,Response);
          SalesInvHeader."Signed Document XML" := TempBlob.Blob;
        end;

        SalesInvHeader.Modify;
        ProcessResponseESalesInvoice(SalesInvHeader,Edocaction::Cancel);
        SalesInvHeader.Modify;
    end;

    local procedure CancelESalesCrMemo(var SalesCrMemoHeader: Record "Sales Cr.Memo Header")
    var
        TempBlob: Record TempBlob;
        XMLDOMManagement: Codeunit "XML DOM Management";
        XMLDoc: dotnet XmlDocument;
        XMLCurrNode: dotnet XmlNode;
        XMLNewChild: dotnet XmlNode;
        Response: Text;
        OutStr: OutStream;
        CancelDateTime: Text[50];
    begin
        if SalesCrMemoHeader."Source Code" = SourceCodeSetup."Deleted Document" then
          Error(Text007);

        // Create instance
        if IsNull(XMLDoc) then
          XMLDoc := XMLDoc.XmlDocument;

        DocNameSpace := 'http://www.sat.gob.mx/cfd/3';
        XMLDOMManagement.LoadXMLDocumentFromText('<?xml version="1.0" encoding="UTF-8" ?> <CancelaCFD /> ',XMLDoc);
        XMLCurrNode := XMLDoc.DocumentElement;
        AddElement(XMLCurrNode,'Cancelacion','','',XMLNewChild);
        XMLCurrNode := XMLNewChild;
        with SalesCrMemoHeader do begin
          CancelDateTime := FormatDateTime(CurrentDatetime);
          AddAttribute(XMLDoc,XMLCurrNode,'Fecha',CancelDateTime);
          "Date/Time Canceled" := CancelDateTime;
          AddAttribute(XMLDoc,XMLCurrNode,'RfcEmisor',CompanyInfo."RFC No.");
          AddElement(XMLCurrNode,'Folios','','',XMLNewChild);
          XMLCurrNode := XMLNewChild;
          AddElement(XMLCurrNode,'Folio','','',XMLNewChild);
          XMLCurrNode := XMLNewChild;
          AddAttribute(XMLDoc,XMLCurrNode,'FechaTimbrado',"Date/Time Stamped");
          AddAttribute(XMLDoc,XMLCurrNode,'UUID',"Fiscal Invoice Number PAC");
          "Original Document XML".CreateOutstream(OutStr);
          XMLDoc.Save(OutStr);
        end;

        Response := InvokeMethod(XMLDoc,Methodtype::Cancel);

        // For Test Mocking
        if not GLSetup."Sim. Request Stamp" then begin
          TextToBlob(TempBlob,Response);
          SalesCrMemoHeader."Signed Document XML" := TempBlob.Blob;
        end;

        SalesCrMemoHeader.Modify;
        ProcessResponseESalesCrMemo(SalesCrMemoHeader,Edocaction::Cancel);
        SalesCrMemoHeader.Modify;
    end;

    local procedure CancelEServiceInvoice(var ServiceInvHeader: Record "Service Invoice Header")
    var
        TempBlob: Record TempBlob;
        XMLDOMManagement: Codeunit "XML DOM Management";
        XMLDoc: dotnet XmlDocument;
        XMLCurrNode: dotnet XmlNode;
        XMLNewChild: dotnet XmlNode;
        Response: Text;
        OutStr: OutStream;
        CancelDateTime: Text[50];
    begin
        if ServiceInvHeader."Source Code" = SourceCodeSetup."Deleted Document" then
          Error(Text007);

        // Create instance
        if IsNull(XMLDoc) then
          XMLDoc := XMLDoc.XmlDocument;

        DocNameSpace := 'http://www.sat.gob.mx/cfd/3';
        XMLDOMManagement.LoadXMLDocumentFromText('<?xml version="1.0" encoding="UTF-8" ?> <CancelaCFD /> ',XMLDoc);
        XMLCurrNode := XMLDoc.DocumentElement;
        AddElement(XMLCurrNode,'Cancelacion','','',XMLNewChild);
        XMLCurrNode := XMLNewChild;
        with ServiceInvHeader do begin
          CancelDateTime := FormatDateTime(CurrentDatetime);
          AddAttribute(XMLDoc,XMLCurrNode,'Fecha',CancelDateTime);
          "Date/Time Canceled" := CancelDateTime;
          AddAttribute(XMLDoc,XMLCurrNode,'RfcEmisor',CompanyInfo."RFC No.");
          AddElement(XMLCurrNode,'Folios','','',XMLNewChild);
          XMLCurrNode := XMLNewChild;
          AddElement(XMLCurrNode,'Folio','','',XMLNewChild);
          XMLCurrNode := XMLNewChild;
          AddAttribute(XMLDoc,XMLCurrNode,'FechaTimbrado',"Date/Time Stamped");
          AddAttribute(XMLDoc,XMLCurrNode,'UUID',"Fiscal Invoice Number PAC");
          "Original Document XML".CreateOutstream(OutStr);
          XMLDoc.Save(OutStr);
        end;

        Response := InvokeMethod(XMLDoc,Methodtype::Cancel);

        // For Test Mocking
        if not GLSetup."Sim. Request Stamp" then begin
          TextToBlob(TempBlob,Response);
          ServiceInvHeader."Signed Document XML" := TempBlob.Blob;
        end;
        ServiceInvHeader.Modify;
        ProcessResponseEServiceInvoice(ServiceInvHeader,Edocaction::Cancel,0);
        ServiceInvHeader.Modify;
    end;

    local procedure CancelEServiceCrMemo(var ServiceCrMemoHeader: Record "Service Cr.Memo Header")
    var
        TempBlob: Record TempBlob;
        XMLDOMManagement: Codeunit "XML DOM Management";
        XMLDoc: dotnet XmlDocument;
        XMLCurrNode: dotnet XmlNode;
        XMLNewChild: dotnet XmlNode;
        Response: Text;
        OutStr: OutStream;
        CancelDateTime: Text[50];
    begin
        if ServiceCrMemoHeader."Source Code" = SourceCodeSetup."Deleted Document" then
          Error(Text007);

        // Create instance
        if IsNull(XMLDoc) then
          XMLDoc := XMLDoc.XmlDocument;

        DocNameSpace := 'http://www.sat.gob.mx/cfd/3';
        XMLDOMManagement.LoadXMLDocumentFromText('<?xml version="1.0" encoding="UTF-8" ?> <CancelaCFD /> ',XMLDoc);
        XMLCurrNode := XMLDoc.DocumentElement;
        AddElement(XMLCurrNode,'Cancelacion','','',XMLNewChild);
        XMLCurrNode := XMLNewChild;
        with ServiceCrMemoHeader do begin
          CancelDateTime := FormatDateTime(CurrentDatetime);
          AddAttribute(XMLDoc,XMLCurrNode,'Fecha',CancelDateTime);
          "Date/Time Canceled" := CancelDateTime;
          AddAttribute(XMLDoc,XMLCurrNode,'RfcEmisor',CompanyInfo."RFC No.");
          AddElement(XMLCurrNode,'Folios','','',XMLNewChild);
          XMLCurrNode := XMLNewChild;
          AddElement(XMLCurrNode,'Folio','','',XMLNewChild);
          XMLCurrNode := XMLNewChild;
          AddAttribute(XMLDoc,XMLCurrNode,'FechaTimbrado',"Date/Time Stamped");
          AddAttribute(XMLDoc,XMLCurrNode,'UUID',"Fiscal Invoice Number PAC");
          "Original Document XML".CreateOutstream(OutStr);
          XMLDoc.Save(OutStr);
        end;

        Response := InvokeMethod(XMLDoc,Methodtype::Cancel);

        // For Test Mocking
        if not GLSetup."Sim. Request Stamp" then begin
          TextToBlob(TempBlob,Response);
          ServiceCrMemoHeader."Signed Document XML" := TempBlob.Blob;
        end;
        ServiceCrMemoHeader.Modify;
        ProcessResponseEServiceCrMemo(ServiceCrMemoHeader,Edocaction::Cancel,0);
        ServiceCrMemoHeader.Modify;
    end;

    local procedure ProcessResponseESalesInvoice(var SalesInvoiceHeader: Record "Sales Invoice Header";"Action": Option)
    var
        TempBlob: Record TempBlob;
        PACWebService: Record UnknownRecord10000;
        XMLDOMManagement: Codeunit "XML DOM Management";
        XMLDoc: dotnet XmlDocument;
        XMLDocResult: dotnet XmlDocument;
        XMLCurrNode: dotnet XmlNode;
        XMLDOMNamedNodeMap: dotnet XmlNamedNodeMap;
        XMLDOMNodeList: dotnet XmlNodeList;
        NamespaceManager: dotnet XmlNamespaceManager;
        OutStr: OutStream;
        InStr: InStream;
        NodeCount: Integer;
        Counter: Integer;
        QRCodeInput: Text[95];
        ErrorDescription: Text[250];
    begin
        GetGLSetup;
        GetCompanyInfo;
        GetCustomer(SalesInvoiceHeader."Bill-to Customer No.");

        // Process Response and Load back to header the Signed XML if you get one...
        if IsNull(XMLDocResult) then
          XMLDocResult := XMLDocResult.XmlDocument;

        SalesInvoiceHeader.CalcFields("Signed Document XML");
        SalesInvoiceHeader."Signed Document XML".CreateInstream(InStr);
        XMLDOMManagement.LoadXMLDocumentFromInStream(InStr,XMLDocResult);
        Clear(SalesInvoiceHeader."Signed Document XML");
        XMLCurrNode := XMLDocResult.SelectSingleNode('Resultado');

        XMLDOMNamedNodeMap := XMLCurrNode.Attributes;
        XMLCurrNode := XMLDOMNamedNodeMap.GetNamedItem('IdRespuesta');

        PACWebService.Get(GLSetup."PAC Code");
        SalesInvoiceHeader."PAC Web Service Name" := PACWebService.Name;

        if XMLCurrNode.Value <> '1' then begin
          SalesInvoiceHeader."Error Code" := XMLCurrNode.Value;
          XMLCurrNode := XMLDOMNamedNodeMap.GetNamedItem('Descripcion');
          ErrorDescription := XMLCurrNode.Value;
          XMLCurrNode := XMLDOMNamedNodeMap.GetNamedItem('Detalle');
          if not IsNull(XMLCurrNode) then
            ErrorDescription := ErrorDescription + ': ' + XMLCurrNode.Value;
          if StrLen(ErrorDescription) > 250 then
            ErrorDescription := CopyStr(ErrorDescription,1,247) + '...';
          SalesInvoiceHeader."Error Description" := ErrorDescription;
          case Action of
            Edocaction::"Request Stamp":
              SalesInvoiceHeader."Electronic Document Status" := SalesInvoiceHeader."electronic document status"::"Stamp Request Error";
            Edocaction::Cancel:
              begin
                SalesInvoiceHeader."Electronic Document Status" := SalesInvoiceHeader."electronic document status"::"Cancel Error";
                SalesInvoiceHeader."Date/Time Canceled" := '';
              end;
          end;
          exit;
        end;

        SalesInvoiceHeader."Error Code" := '';
        SalesInvoiceHeader."Error Description" := '';
        if Action = Edocaction::Cancel then begin
          SalesInvoiceHeader."Electronic Document Status" := SalesInvoiceHeader."electronic document status"::Canceled;
          exit;
        end;
        XMLCurrNode := XMLDocResult.SelectSingleNode('Resultado');
        XMLDOMNodeList := XMLCurrNode.ChildNodes;
        NodeCount := XMLDOMNodeList.Count;

        Clear(XMLDoc);
        XMLDoc := XMLDoc.XmlDocument;
        for Counter := 0 to (NodeCount - 1) do begin
          XMLCurrNode := XMLDOMNodeList.Item(Counter);
          XMLDoc.AppendChild(XMLDoc.ImportNode(XMLCurrNode,true));
        end;

        SalesInvoiceHeader."Signed Document XML".CreateOutstream(OutStr);
        XMLDoc.Save(OutStr);

        NamespaceManager := NamespaceManager.XmlNamespaceManager(XMLDoc.NameTable);
        NamespaceManager.AddNamespace('cfdi','http://www.sat.gob.mx/cfd/3');
        NamespaceManager.AddNamespace('tfd','http://www.sat.gob.mx/TimbreFiscalDigital');
        XMLCurrNode := XMLDoc.SelectSingleNode('cfdi:Comprobante/cfdi:Complemento/tfd:TimbreFiscalDigital',NamespaceManager);
        XMLDOMNamedNodeMap := XMLCurrNode.Attributes;

        XMLCurrNode := XMLDOMNamedNodeMap.GetNamedItem('FechaTimbrado');
        SalesInvoiceHeader."Date/Time Stamped" := XMLCurrNode.Value;

        XMLCurrNode := XMLDOMNamedNodeMap.GetNamedItem('UUID');
        SalesInvoiceHeader."Fiscal Invoice Number PAC" := XMLCurrNode.Value;

        XMLCurrNode := XMLDOMNamedNodeMap.GetNamedItem('noCertificadoSAT');
        SalesInvoiceHeader."Certificate Serial No." := XMLCurrNode.Value;

        XMLCurrNode := XMLDOMNamedNodeMap.GetNamedItem('selloSAT');

        Clear(OutStr);
        SalesInvoiceHeader."Digital Stamp PAC".CreateOutstream(OutStr);
        OutStr.WriteText(XMLCurrNode.Value);
        // Certificate Serial
        SalesInvoiceHeader."Electronic Document Status" := SalesInvoiceHeader."electronic document status"::"Stamp Received";

        // Create QRCode
        SalesInvoiceHeader.CalcFields("Amount Including VAT");
        QRCodeInput := CreateQRCodeInput(CompanyInfo."RFC No.",Customer."RFC No.",SalesInvoiceHeader."Amount Including VAT",
            Format(SalesInvoiceHeader."Fiscal Invoice Number PAC"));
        CreateQRCode(QRCodeInput,TempBlob);
        SalesInvoiceHeader."QR Code" := TempBlob.Blob;
    end;

    local procedure ProcessResponseESalesCrMemo(var SalesCrMemoHeader: Record "Sales Cr.Memo Header";"Action": Option)
    var
        TempBlob: Record TempBlob;
        PACWebService: Record UnknownRecord10000;
        XMLDOMManagement: Codeunit "XML DOM Management";
        XMLDoc: dotnet XmlDocument;
        XMLCurrNode: dotnet XmlNode;
        XMLDOMNamedNodeMap: dotnet XmlNamedNodeMap;
        XMLDOMNodeList: dotnet XmlNodeList;
        NamespaceManager: dotnet XmlNamespaceManager;
        OutStr: OutStream;
        InStr: InStream;
        NodeCount: Integer;
        Counter: Integer;
        QRCodeInput: Text[95];
        ErrorDescription: Text[250];
    begin
        GetGLSetup;
        GetCompanyInfo;
        GetCustomer(SalesCrMemoHeader."Bill-to Customer No.");

        // Process Response and Load back to header the Signed XML if you get one...
        if IsNull(XMLDoc) then
          XMLDoc := XMLDoc.XmlDocument;

        SalesCrMemoHeader.CalcFields("Signed Document XML");
        SalesCrMemoHeader."Signed Document XML".CreateInstream(InStr);
        XMLDOMManagement.LoadXMLDocumentFromInStream(InStr,XMLDoc);
        Clear(SalesCrMemoHeader."Signed Document XML");
        XMLCurrNode := XMLDoc.SelectSingleNode('Resultado');

        XMLDOMNamedNodeMap := XMLCurrNode.Attributes;
        XMLCurrNode := XMLDOMNamedNodeMap.GetNamedItem('IdRespuesta');

        PACWebService.Get(GLSetup."PAC Code");
        SalesCrMemoHeader."PAC Web Service Name" := PACWebService.Name;

        if XMLCurrNode.Value <> '1' then begin
          SalesCrMemoHeader."Error Code" := XMLCurrNode.Value;
          XMLCurrNode := XMLDOMNamedNodeMap.GetNamedItem('Descripcion');
          ErrorDescription := XMLCurrNode.Value;
          XMLCurrNode := XMLDOMNamedNodeMap.GetNamedItem('Detalle');
          if not IsNull(XMLCurrNode) then
            ErrorDescription := ErrorDescription + ': ' + XMLCurrNode.Value;
          if StrLen(ErrorDescription) > 250 then
            ErrorDescription := CopyStr(ErrorDescription,1,247) + '...';
          SalesCrMemoHeader."Error Description" := ErrorDescription;

          case Action of
            Edocaction::"Request Stamp":
              SalesCrMemoHeader."Electronic Document Status" := SalesCrMemoHeader."electronic document status"::"Stamp Request Error";
            Edocaction::Cancel:
              begin
                SalesCrMemoHeader."Electronic Document Status" := SalesCrMemoHeader."electronic document status"::"Cancel Error";
                SalesCrMemoHeader."Date/Time Canceled" := '';
              end;
          end;
          exit;
        end;

        SalesCrMemoHeader."Error Code" := '';
        SalesCrMemoHeader."Error Description" := '';
        if Action = Edocaction::Cancel then begin
          SalesCrMemoHeader."Electronic Document Status" := SalesCrMemoHeader."electronic document status"::Canceled;
          exit;
        end;
        XMLCurrNode := XMLDoc.SelectSingleNode('Resultado');
        XMLDOMNodeList := XMLCurrNode.ChildNodes;
        NodeCount := XMLDOMNodeList.Count;
        Clear(XMLDoc);
        XMLDoc := XMLDoc.XmlDocument;

        for Counter := 0 to (NodeCount - 1) do begin
          XMLCurrNode := XMLDOMNodeList.Item(Counter);
          XMLDoc.AppendChild(XMLDoc.ImportNode(XMLCurrNode,true));
        end;

        SalesCrMemoHeader."Signed Document XML".CreateOutstream(OutStr);
        XMLDoc.Save(OutStr);

        NamespaceManager := NamespaceManager.XmlNamespaceManager(XMLDoc.NameTable);
        NamespaceManager.AddNamespace('cfdi','http://www.sat.gob.mx/cfd/3');
        NamespaceManager.AddNamespace('tfd','http://www.sat.gob.mx/TimbreFiscalDigital');
        XMLCurrNode := XMLDoc.SelectSingleNode('cfdi:Comprobante/cfdi:Complemento/tfd:TimbreFiscalDigital',NamespaceManager);
        XMLDOMNamedNodeMap := XMLCurrNode.Attributes;

        XMLCurrNode := XMLDOMNamedNodeMap.GetNamedItem('FechaTimbrado');
        SalesCrMemoHeader."Date/Time Stamped" := XMLCurrNode.Value;

        XMLCurrNode := XMLDOMNamedNodeMap.GetNamedItem('UUID');
        SalesCrMemoHeader."Fiscal Invoice Number PAC" := XMLCurrNode.Value;

        XMLCurrNode := XMLDOMNamedNodeMap.GetNamedItem('noCertificadoSAT');
        SalesCrMemoHeader."Certificate Serial No." := XMLCurrNode.Value;

        XMLCurrNode := XMLDOMNamedNodeMap.GetNamedItem('selloSAT');

        Clear(OutStr);
        SalesCrMemoHeader."Digital Stamp PAC".CreateOutstream(OutStr);
        OutStr.WriteText(XMLCurrNode.Value);
        // Certificate Serial
        SalesCrMemoHeader."Electronic Document Status" := SalesCrMemoHeader."electronic document status"::"Stamp Received";

        // Create QRCode
        SalesCrMemoHeader.CalcFields("Amount Including VAT");
        QRCodeInput := CreateQRCodeInput(CompanyInfo."RFC No.",Customer."RFC No.",SalesCrMemoHeader."Amount Including VAT",
            Format(SalesCrMemoHeader."Fiscal Invoice Number PAC"));
        CreateQRCode(QRCodeInput,TempBlob);
        SalesCrMemoHeader."QR Code" := TempBlob.Blob;
    end;

    local procedure ProcessResponseEServiceInvoice(var ServInvoiceHeader: Record "Service Invoice Header";"Action": Option;AmountInclVAT: Decimal)
    var
        TempBlob: Record TempBlob;
        PACWebService: Record UnknownRecord10000;
        XMLDOMManagement: Codeunit "XML DOM Management";
        XMLDoc: dotnet XmlDocument;
        XMLCurrNode: dotnet XmlNode;
        XMLDOMNamedNodeMap: dotnet XmlNamedNodeMap;
        XMLDOMNodeList: dotnet XmlNodeList;
        NamespaceManager: dotnet XmlNamespaceManager;
        OutStr: OutStream;
        InStr: InStream;
        NodeCount: Integer;
        Counter: Integer;
        QRCodeInput: Text[95];
        ErrorDescription: Text[250];
    begin
        GetGLSetup;
        GetCompanyInfo;
        GetCustomer(ServInvoiceHeader."Bill-to Customer No.");

        // Process Response and Load back to header the Signed XML if you get one...
        if IsNull(XMLDoc) then
          XMLDoc := XMLDoc.XmlDocument;

        ServInvoiceHeader.CalcFields("Signed Document XML");
        ServInvoiceHeader."Signed Document XML".CreateInstream(InStr);
        XMLDOMManagement.LoadXMLDocumentFromInStream(InStr,XMLDoc);
        Clear(ServInvoiceHeader."Signed Document XML");
        XMLCurrNode := XMLDoc.SelectSingleNode('Resultado');

        XMLDOMNamedNodeMap := XMLCurrNode.Attributes;
        XMLCurrNode := XMLDOMNamedNodeMap.GetNamedItem('IdRespuesta');

        PACWebService.Get(GLSetup."PAC Code");
        ServInvoiceHeader."PAC Web Service Name" := PACWebService.Name;

        if XMLCurrNode.Value <> '1' then begin
          ServInvoiceHeader."Error Code" := XMLCurrNode.Value;
          XMLCurrNode := XMLDOMNamedNodeMap.GetNamedItem('Descripcion');
          ErrorDescription := XMLCurrNode.Value;
          XMLCurrNode := XMLDOMNamedNodeMap.GetNamedItem('Detalle');
          if not IsNull(XMLCurrNode) then
            ErrorDescription := ErrorDescription + ': ' + XMLCurrNode.Value;
          if StrLen(ErrorDescription) > 250 then
            ErrorDescription := CopyStr(ErrorDescription,1,247) + '...';
          ServInvoiceHeader."Error Description" := ErrorDescription;

          case Action of
            Edocaction::"Request Stamp":
              ServInvoiceHeader."Electronic Document Status" := ServInvoiceHeader."electronic document status"::"Stamp Request Error";
            Edocaction::Cancel:
              begin
                ServInvoiceHeader."Electronic Document Status" := ServInvoiceHeader."electronic document status"::"Cancel Error";
                ServInvoiceHeader."Date/Time Canceled" := '';
              end;
          end;
          exit;
        end;

        ServInvoiceHeader."Error Code" := '';
        ServInvoiceHeader."Error Description" := '';
        if Action = Edocaction::Cancel then begin
          ServInvoiceHeader."Electronic Document Status" := ServInvoiceHeader."electronic document status"::Canceled;
          exit;
        end;
        XMLCurrNode := XMLDoc.SelectSingleNode('Resultado');
        XMLDOMNodeList := XMLCurrNode.ChildNodes;
        NodeCount := XMLDOMNodeList.Count;
        Clear(XMLDoc);
        XMLDoc := XMLDoc.XmlDocument;

        for Counter := 0 to (NodeCount - 1) do begin
          XMLCurrNode := XMLDOMNodeList.Item(Counter);
          XMLDoc.AppendChild(XMLDoc.ImportNode(XMLCurrNode,true));
        end;

        ServInvoiceHeader."Signed Document XML".CreateOutstream(OutStr);
        XMLDoc.Save(OutStr);

        NamespaceManager := NamespaceManager.XmlNamespaceManager(XMLDoc.NameTable);
        NamespaceManager.AddNamespace('cfdi','http://www.sat.gob.mx/cfd/3');
        NamespaceManager.AddNamespace('tfd','http://www.sat.gob.mx/TimbreFiscalDigital');
        XMLCurrNode := XMLDoc.SelectSingleNode('cfdi:Comprobante/cfdi:Complemento/tfd:TimbreFiscalDigital',NamespaceManager);
        XMLDOMNamedNodeMap := XMLCurrNode.Attributes;

        XMLCurrNode := XMLDOMNamedNodeMap.GetNamedItem('FechaTimbrado');
        ServInvoiceHeader."Date/Time Stamped" := XMLCurrNode.Value;

        XMLCurrNode := XMLDOMNamedNodeMap.GetNamedItem('UUID');
        ServInvoiceHeader."Fiscal Invoice Number PAC" := XMLCurrNode.Value;

        XMLCurrNode := XMLDOMNamedNodeMap.GetNamedItem('noCertificadoSAT');
        ServInvoiceHeader."Certificate Serial No." := XMLCurrNode.Value;

        XMLCurrNode := XMLDOMNamedNodeMap.GetNamedItem('selloSAT');

        Clear(OutStr);
        ServInvoiceHeader."Digital Stamp PAC".CreateOutstream(OutStr);
        OutStr.WriteText(XMLCurrNode.Value);
        // Certiificate Serial
        ServInvoiceHeader."Electronic Document Status" := ServInvoiceHeader."electronic document status"::"Stamp Received";

        // Create QRCode
        QRCodeInput := CreateQRCodeInput(CompanyInfo."RFC No.",Customer."RFC No.",AmountInclVAT,
            Format(ServInvoiceHeader."Fiscal Invoice Number PAC"));
        CreateQRCode(QRCodeInput,TempBlob);
        ServInvoiceHeader."QR Code" := TempBlob.Blob;
    end;

    local procedure ProcessResponseEServiceCrMemo(var ServCrMemoHeader: Record "Service Cr.Memo Header";"Action": Option;AmountInclVAT: Decimal)
    var
        TempBlob: Record TempBlob;
        PACWebService: Record UnknownRecord10000;
        XMLDOMManagement: Codeunit "XML DOM Management";
        XMLDoc: dotnet XmlDocument;
        XMLCurrNode: dotnet XmlNode;
        XMLDOMNamedNodeMap: dotnet XmlNamedNodeMap;
        XMLDOMNodeList: dotnet XmlNodeList;
        NamespaceManager: dotnet XmlNamespaceManager;
        OutStr: OutStream;
        InStr: InStream;
        NodeCount: Integer;
        Counter: Integer;
        QRCodeInput: Text[95];
        ErrorDescription: Text[250];
    begin
        GetGLSetup;
        GetCompanyInfo;
        GetCustomer(ServCrMemoHeader."Bill-to Customer No.");

        // Process Response and Load back to header the Signed XML if you get one...
        if IsNull(XMLDoc) then
          XMLDoc := XMLDoc.XmlDocument;

        ServCrMemoHeader.CalcFields("Signed Document XML");
        ServCrMemoHeader."Signed Document XML".CreateInstream(InStr);
        XMLDOMManagement.LoadXMLDocumentFromInStream(InStr,XMLDoc);
        Clear(ServCrMemoHeader."Signed Document XML");
        XMLCurrNode := XMLDoc.SelectSingleNode('Resultado');

        XMLDOMNamedNodeMap := XMLCurrNode.Attributes;
        XMLCurrNode := XMLDOMNamedNodeMap.GetNamedItem('IdRespuesta');

        PACWebService.Get(GLSetup."PAC Code");
        ServCrMemoHeader."PAC Web Service Name" := PACWebService.Name;

        if XMLCurrNode.Value <> '1' then begin
          ServCrMemoHeader."Error Code" := XMLCurrNode.Value;
          XMLCurrNode := XMLDOMNamedNodeMap.GetNamedItem('Descripcion');
          ErrorDescription := XMLCurrNode.Value;
          XMLCurrNode := XMLDOMNamedNodeMap.GetNamedItem('Detalle');
          if not IsNull(XMLCurrNode) then
            ErrorDescription := ErrorDescription + ': ' + XMLCurrNode.Value;
          if StrLen(ErrorDescription) > 250 then
            ErrorDescription := CopyStr(ErrorDescription,1,247) + '...';
          ServCrMemoHeader."Error Description" := ErrorDescription;

          case Action of
            Edocaction::"Request Stamp":
              ServCrMemoHeader."Electronic Document Status" := ServCrMemoHeader."electronic document status"::"Stamp Request Error";
            Edocaction::Cancel:
              begin
                ServCrMemoHeader."Electronic Document Status" := ServCrMemoHeader."electronic document status"::"Cancel Error";
                ServCrMemoHeader."Date/Time Canceled" := '';
              end;
          end;
          exit;
        end;

        ServCrMemoHeader."Error Code" := '';
        ServCrMemoHeader."Error Description" := '';
        if Action = Edocaction::Cancel then begin
          ServCrMemoHeader."Electronic Document Status" := ServCrMemoHeader."electronic document status"::Canceled;
          exit;
        end;
        XMLCurrNode := XMLDoc.SelectSingleNode('Resultado');
        XMLDOMNodeList := XMLCurrNode.ChildNodes;
        NodeCount := XMLDOMNodeList.Count;
        Clear(XMLDoc);
        XMLDoc := XMLDoc.XmlDocument;

        for Counter := 0 to (NodeCount - 1) do begin
          XMLCurrNode := XMLDOMNodeList.Item(Counter);
          XMLDoc.AppendChild(XMLDoc.ImportNode(XMLCurrNode,true));
        end;

        ServCrMemoHeader."Signed Document XML".CreateOutstream(OutStr);
        XMLDoc.Save(OutStr);

        NamespaceManager := NamespaceManager.XmlNamespaceManager(XMLDoc.NameTable);
        NamespaceManager.AddNamespace('cfdi','http://www.sat.gob.mx/cfd/3');
        NamespaceManager.AddNamespace('tfd','http://www.sat.gob.mx/TimbreFiscalDigital');
        XMLCurrNode := XMLDoc.SelectSingleNode('cfdi:Comprobante/cfdi:Complemento/tfd:TimbreFiscalDigital',NamespaceManager);
        XMLDOMNamedNodeMap := XMLCurrNode.Attributes;

        XMLCurrNode := XMLDOMNamedNodeMap.GetNamedItem('FechaTimbrado');
        ServCrMemoHeader."Date/Time Stamped" := XMLCurrNode.Value;

        XMLCurrNode := XMLDOMNamedNodeMap.GetNamedItem('UUID');
        ServCrMemoHeader."Fiscal Invoice Number PAC" := XMLCurrNode.Value;

        XMLCurrNode := XMLDOMNamedNodeMap.GetNamedItem('noCertificadoSAT');
        ServCrMemoHeader."Certificate Serial No." := XMLCurrNode.Value;

        XMLCurrNode := XMLDOMNamedNodeMap.GetNamedItem('selloSAT');

        Clear(OutStr);
        ServCrMemoHeader."Digital Stamp PAC".CreateOutstream(OutStr);
        OutStr.WriteText(XMLCurrNode.Value);
        // Certificate Serial
        ServCrMemoHeader."Electronic Document Status" := ServCrMemoHeader."electronic document status"::"Stamp Received";

        // Create QRCode
        QRCodeInput := CreateQRCodeInput(CompanyInfo."RFC No.",Customer."RFC No.",AmountInclVAT,
            Format(ServCrMemoHeader."Fiscal Invoice Number PAC"));
        CreateQRCode(QRCodeInput,TempBlob);
        ServCrMemoHeader."QR Code" := TempBlob.Blob;
    end;

    local procedure ValidateSalesInvoice(var SalesInvoiceHeader: Record "Sales Invoice Header")
    begin
        with SalesInvoiceHeader do begin
          if "Source Code" = SourceCodeSetup."Deleted Document" then
            Error(Text007);
          TestField("Bill-to Address");
          TestField("Bill-to Post Code");
          TestField("No.");
          TestField("Document Date");
          TestField("Payment Terms Code");
        end;
    end;

    local procedure ValidateSalesCrMemo(var SalesCrMemoHeader: Record "Sales Cr.Memo Header")
    begin
        with SalesCrMemoHeader do begin
          if "Source Code" = SourceCodeSetup."Deleted Document" then
            Error(Text007);
          TestField("Bill-to Address");
          TestField("Bill-to Post Code");
          TestField("No.");
          TestField("Document Date");
          TestField("Payment Terms Code");
        end;
    end;

    local procedure ValidateServiceInvoice(var ServiceInvoiceHeader: Record "Service Invoice Header")
    begin
        with ServiceInvoiceHeader do begin
          if "Source Code" = SourceCodeSetup."Deleted Document" then
            Error(Text007);
          TestField("Bill-to Address");
          TestField("Bill-to Post Code");
          TestField("No.");
          TestField("Document Date");
          TestField("Payment Terms Code");
        end;
    end;

    local procedure ValidateServiceCrMemo(var ServiceCrMemoHeader: Record "Service Cr.Memo Header")
    begin
        with ServiceCrMemoHeader do begin
          if "Source Code" = SourceCodeSetup."Deleted Document" then
            Error(Text007);
          TestField("Bill-to Address");
          TestField("Bill-to Post Code");
          TestField("No.");
          TestField("Document Date");
          TestField("Payment Terms Code");
        end;
    end;

    local procedure CreateXMLDocument(var TempDocumentHeader: Record UnknownRecord10002 temporary;var TempDocumentLine: Record UnknownRecord10003 temporary;DateTimeFirstReqSent: Text[50];SignedString: Text;Certificate: Text;CertificateSerialNo: Text[250];SubTotal: Decimal;RetainAmt: Decimal;IsCredit: Boolean;var XMLDoc: dotnet XmlDocument)
    var
        XMLCurrNode: dotnet XmlNode;
        XMLNewChild: dotnet XmlNode;
    begin
        InitXML(XMLDoc,XMLCurrNode);
        with TempDocumentHeader do begin
          AddAttribute(XMLDoc,XMLCurrNode,'version','3.2');
          AddAttribute(XMLDoc,XMLCurrNode,'folio',"No.");
          AddAttribute(XMLDoc,XMLCurrNode,'fecha',DateTimeFirstReqSent);

          AddAttribute(XMLDoc,XMLCurrNode,'sello',SignedString);
          AddAttribute(XMLDoc,XMLCurrNode,'certificado',Certificate);
          AddAttribute(XMLDoc,XMLCurrNode,'formaDePago',GetPmtTermCode("Payment Terms Code"));
          AddAttribute(XMLDoc,XMLCurrNode,'noCertificado',CertificateSerialNo);
          AddAttribute(XMLDoc,XMLCurrNode,'subTotal',FormatAmount(SubTotal));
          if "Currency Code" <> '' then begin
            AddAttribute(XMLDoc,XMLCurrNode,'TipoCambio',FormatAmount(1 / "Currency Factor"));
            AddAttribute(XMLDoc,XMLCurrNode,'Moneda',"Currency Code");
          end;
          AddAttribute(XMLDoc,XMLCurrNode,'total',FormatAmount("Amount Including VAT"));
          if IsCredit then
            AddAttribute(XMLDoc,XMLCurrNode,'tipoDeComprobante','egreso')
          else
            AddAttribute(XMLDoc,XMLCurrNode,'tipoDeComprobante','ingreso');
          AddAttribute(XMLDoc,XMLCurrNode,'metodoDePago',"Payment Method Code");
          AddAttribute(XMLDoc,XMLCurrNode,'LugarExpedicion',CompanyInfo.City);
          if CompanyInfo."Bank Account No." <> '' then
            AddAttribute(XMLDoc,XMLCurrNode,'NumCtaPago',GetBankAccountLastFourChars(CompanyInfo."Bank Account No."));

          // Emisor
          WriteCompanyInfo(XMLDoc,XMLCurrNode);

          // Receptor
          XMLCurrNode := XMLCurrNode.ParentNode;
          XMLCurrNode := XMLCurrNode.ParentNode;
          AddElementCFDI(XMLCurrNode,'Receptor','',DocNameSpace,XMLNewChild);
          XMLCurrNode := XMLNewChild;
          AddAttribute(XMLDoc,XMLCurrNode,'rfc',Customer."RFC No.");
          AddAttribute(XMLDoc,XMLCurrNode,'nombre',"Bill-to/Pay-To Name");

          // Receptor->Domicilio
          AddElementCFDI(XMLCurrNode,'Domicilio','',DocNameSpace,XMLNewChild);
          XMLCurrNode := XMLNewChild;
          AddAttribute(XMLDoc,XMLCurrNode,'calle',"Bill-to/Pay-To Address");
          AddAttribute(XMLDoc,XMLCurrNode,'colonia',"Bill-to/Pay-To County");
          AddAttribute(XMLDoc,XMLCurrNode,'localidad',"Bill-to/Pay-To City");
          AddAttribute(XMLDoc,XMLCurrNode,'pais',Customer."Country/Region Code");
          AddAttribute(XMLDoc,XMLCurrNode,'codigoPostal',"Bill-to/Pay-To Post Code");

          // Conceptos
          XMLCurrNode := XMLCurrNode.ParentNode;
          XMLCurrNode := XMLCurrNode.ParentNode;
          AddElementCFDI(XMLCurrNode,'Conceptos','',DocNameSpace,XMLNewChild);
          XMLCurrNode := XMLNewChild;

          // Conceptos->Concepto
          TempDocumentLine.Reset;
          TempDocumentLine.SetRange("Document No.","No.");
          TempDocumentLine.SetFilter(Type,'<>%1',TempDocumentLine.Type::" ");
          if TempDocumentLine.FindSet then
            repeat
              AddElementCFDI(XMLCurrNode,'Concepto','',DocNameSpace,XMLNewChild);
              XMLCurrNode := XMLNewChild;
              AddAttribute(XMLDoc,XMLCurrNode,'cantidad',Format(TempDocumentLine.Quantity,0,9));
              AddAttribute(XMLDoc,XMLCurrNode,'unidad',TempDocumentLine."Unit of Measure Code");
              AddAttribute(XMLDoc,XMLCurrNode,'noIdentificacion',TempDocumentLine."No.");
              AddAttribute(XMLDoc,XMLCurrNode,'descripcion',TempDocumentLine.Description);
              AddAttribute(XMLDoc,XMLCurrNode,'valorUnitario',FormatAmount(TempDocumentLine."Unit Price/Direct Unit Cost"));
              AddAttribute(
                XMLDoc,XMLCurrNode,'importe',FormatAmount(TempDocumentLine.Quantity * TempDocumentLine."Unit Price/Direct Unit Cost"));
              XMLCurrNode := XMLCurrNode.ParentNode;
            until TempDocumentLine.Next = 0;

          // Impuestos
          XMLCurrNode := XMLCurrNode.ParentNode;
          AddElementCFDI(XMLCurrNode,'Impuestos','',DocNameSpace,XMLNewChild);
          XMLCurrNode := XMLNewChild;
          if IsCredit then
            AddAttribute(XMLDoc,XMLCurrNode,'totalImpuestosRetenidos',FormatAmount(RetainAmt))
          else
            AddAttribute(XMLDoc,XMLCurrNode,'totalImpuestosTrasladados',FormatAmount(RetainAmt));

          // Impuestos->Traslados/Retenciones
          if IsCredit then
            AddElementCFDI(XMLCurrNode,'Retenciones','',DocNameSpace,XMLNewChild)
          else
            AddElementCFDI(XMLCurrNode,'Traslados','',DocNameSpace,XMLNewChild);
          XMLCurrNode := XMLNewChild;

          if TempDocumentLine.FindSet then
            repeat
              if IsCredit then
                AddElementCFDI(XMLCurrNode,'Retencion','',DocNameSpace,XMLNewChild)
              else
                AddElementCFDI(XMLCurrNode,'Traslado','',DocNameSpace,XMLNewChild);
              XMLCurrNode := XMLNewChild;
              AddAttribute(XMLDoc,XMLCurrNode,'impuesto','IVA');
              if not IsCredit then
                AddAttribute(XMLDoc,XMLCurrNode,'tasa',FormatAmount(TempDocumentLine."VAT %"));
              AddAttribute(XMLDoc,XMLCurrNode,'importe',
                FormatAmount(TempDocumentLine."Amount Including VAT" - TempDocumentLine.Amount));
              XMLCurrNode := XMLCurrNode.ParentNode;
            until TempDocumentLine.Next = 0;
        end;
    end;


    procedure CreateOriginalStr(var TempDocumentHeader: Record UnknownRecord10002 temporary;var TempDocumentLine: Record UnknownRecord10003 temporary;DateTimeFirstReqSent: Text;SubTotal: Decimal;RetainAmt: Decimal;IsCredit: Boolean;var TempBlob: Record TempBlob)
    var
        BlobManagement: Codeunit "Blob Management";
    begin
        with TempDocumentHeader do begin
          BlobManagement.Init;
          BlobManagement.Write('||' + '3.2' + '|');
          BlobManagement.Write(DateTimeFirstReqSent + '|');
          if IsCredit then
            BlobManagement.Write(Format('egreso') + '|')
          else
            BlobManagement.Write(Format('ingreso') + '|');
          BlobManagement.Write(GetPmtTermCode("Payment Terms Code") + '|');

          if not Export then begin
            GetCompanyInfo;
            GetCustomer("Bill-to/Pay-To No.");
          end;

          BlobManagement.Write(FormatAmount(SubTotal) + '|');
          if "Currency Code" <> '' then begin
            BlobManagement.Write(FormatAmount(1 / "Currency Factor") + '|');
            BlobManagement.Write("Currency Code" + '|');
          end;
          BlobManagement.Write(FormatAmount("Amount Including VAT") + '|');
          BlobManagement.Write("Payment Method Code" + '|');
          BlobManagement.Write(RemoveInvalidChars(CompanyInfo.City) + '|');  // LugarExpedicion

          if CompanyInfo."Bank Account No." <> '' then
            BlobManagement.Write(RemoveInvalidChars(GetBankAccountLastFourChars(CompanyInfo."Bank Account No.")) + '|');    // NumCtaPago

          BlobManagement.Write(CompanyInfo."RFC No." + '|');
          BlobManagement.Write(RemoveInvalidChars(CompanyInfo.Name) + '|');
          BlobManagement.Write(RemoveInvalidChars(CompanyInfo.Address) + '|');
          BlobManagement.Write(RemoveInvalidChars(CompanyInfo.County) + '|');
          BlobManagement.Write(RemoveInvalidChars(CompanyInfo.City) + '|');
          BlobManagement.Write(RemoveInvalidChars(CompanyInfo.City) + '|');
          BlobManagement.Write(RemoveInvalidChars(CompanyInfo.County) + '|');
          BlobManagement.Write(RemoveInvalidChars(CompanyInfo."Country/Region Code") + '|');
          BlobManagement.Write(RemoveInvalidChars(CompanyInfo."Post Code") + '|');
          BlobManagement.Write(RemoveInvalidChars(CompanyInfo.Address) + '|');
          BlobManagement.Write(RemoveInvalidChars(CompanyInfo.County) + '|');
          BlobManagement.Write(RemoveInvalidChars(CompanyInfo.City) + '|');
          BlobManagement.Write(RemoveInvalidChars(CompanyInfo.County) + '|');
          BlobManagement.Write(RemoveInvalidChars(CompanyInfo."Country/Region Code") + '|');
          BlobManagement.Write(RemoveInvalidChars(CompanyInfo."Post Code") + '|');
          BlobManagement.Write(RemoveInvalidChars(CompanyInfo."Tax Scheme") + '|');

          BlobManagement.Write(Customer."RFC No." + '|');
          BlobManagement.Write(RemoveInvalidChars("Bill-to/Pay-To Name") + '|');
          BlobManagement.Write(RemoveInvalidChars("Bill-to/Pay-To Address") + '|');
          BlobManagement.Write(RemoveInvalidChars("Bill-to/Pay-To County") + '|');
          BlobManagement.Write(RemoveInvalidChars("Bill-to/Pay-To City") + '|');
          BlobManagement.Write(RemoveInvalidChars(Customer."Country/Region Code") + '|');
          BlobManagement.Write(RemoveInvalidChars("Bill-to/Pay-To Post Code") + '|');

          TempDocumentLine.SetRange("Document No.","No.");
          TempDocumentLine.SetFilter(Type,'<>%1',TempDocumentLine.Type::" ");
          if TempDocumentLine.FindSet then
            repeat
              BlobManagement.Write(Format(TempDocumentLine.Quantity,0,9) + '|');
              BlobManagement.Write(TempDocumentLine."Unit of Measure Code" + '|');
              BlobManagement.Write(TempDocumentLine."No." + '|');
              BlobManagement.Write(RemoveInvalidChars(TempDocumentLine.Description) + '|');
              BlobManagement.Write(FormatAmount(TempDocumentLine."Unit Price/Direct Unit Cost") + '|');
              BlobManagement.Write(FormatAmount(TempDocumentLine.Quantity * TempDocumentLine."Unit Price/Direct Unit Cost") + '|');
            until TempDocumentLine.Next = 0;

          if TempDocumentLine.FindSet then
            repeat
              BlobManagement.Write('IVA' + '|');
              if not IsCredit then
                BlobManagement.Write(FormatAmount(TempDocumentLine."VAT %") + '|');
              BlobManagement.Write(FormatAmount(TempDocumentLine."Amount Including VAT" - TempDocumentLine.Amount) + '|');
            until TempDocumentLine.Next = 0;

          BlobManagement.Write(FormatAmount(RetainAmt) + '||');
          BlobManagement.Get(TempBlob);
        end;
    end;

    local procedure CreateDigitalSignature(OriginalString: Text;var SignedString: Text;var SerialNoOfCertificateUsed: Text[250];var Certificate: Text)
    var
        EInvoiceObjectFactory: Codeunit "E-Invoice Object Factory";
        ISignatureProvider: dotnet ISignatureProvider;
    begin
        GetGLSetup;
        if not GLSetup."Sim. Signature" then begin
          EInvoiceObjectFactory.GetSignatureProvider(ISignatureProvider);
          SignedString := ISignatureProvider.SignData(OriginalString,GLSetup."SAT Certificate Thumbprint");
          Certificate := ISignatureProvider.LastUsedCertificate;
          SerialNoOfCertificateUsed := ISignatureProvider.LastUsedCertificateSerialNo;
        end else begin
          SignedString := OriginalString;
          Certificate := '';
          SerialNoOfCertificateUsed := '';
        end;
    end;

    local procedure SaveAsPDFOnServer(DocumentHeaderRef: RecordRef;ReportNo: Integer): Text
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        ServiceInvoiceHeader: Record "Service Invoice Header";
        ServiceCrMemoHeader: Record "Service Cr.Memo Header";
        FileManagement: Codeunit "File Management";
        DestinationFilePath: Text;
    begin
        DestinationFilePath := FileManagement.GetDirectoryName(FileManagement.ServerTempFileName(''));
        DestinationFilePath := DelChr(DestinationFilePath,'>','\');
        DestinationFilePath += '\';
        case DocumentHeaderRef.Number of
          Database::"Sales Invoice Header":
            begin
              DocumentHeaderRef.SetTable(SalesInvoiceHeader);
              SalesInvoiceHeader.SetRecfilter;
              DestinationFilePath += SalesInvoiceHeader."No." + '.pdf';
              Report.SaveAsPdf(ReportNo,DestinationFilePath,SalesInvoiceHeader);
            end;
          Database::"Sales Cr.Memo Header":
            begin
              DocumentHeaderRef.SetTable(SalesCrMemoHeader);
              SalesCrMemoHeader.SetRecfilter;
              DestinationFilePath += SalesCrMemoHeader."No." + '.pdf';
              Report.SaveAsPdf(ReportNo,DestinationFilePath,SalesCrMemoHeader);
            end;
          Database::"Service Invoice Header":
            begin
              DocumentHeaderRef.SetTable(ServiceInvoiceHeader);
              ServiceInvoiceHeader.SetRecfilter;
              DestinationFilePath += ServiceInvoiceHeader."No." + '.pdf';
              Report.SaveAsPdf(ReportNo,DestinationFilePath,ServiceInvoiceHeader);
            end;
          Database::"Service Cr.Memo Header":
            begin
              DocumentHeaderRef.SetTable(ServiceCrMemoHeader);
              ServiceCrMemoHeader.SetRecfilter;
              DestinationFilePath += ServiceCrMemoHeader."No." + '.pdf';
              Report.SaveAsPdf(ReportNo,DestinationFilePath,ServiceCrMemoHeader);
            end;
        end;
        exit(DestinationFilePath);
    end;

    local procedure SendEmail(SendToAddress: Text;Subject: Text;MessageBody: Text;FilePathEDoc: Text;PDFFilePath: Text;SendPDF: Boolean;XMLInstream: InStream)
    var
        SMTPMail: Codeunit "SMTP Mail";
        SendOK: Boolean;
    begin
        GetGLSetup;
        if GLSetup."Sim. Send" then
          exit;

        SMTPMail.CreateMessage(CompanyInfo.Name,CompanyInfo."E-Mail",SendToAddress,Subject,MessageBody,true);

        SMTPMail.AddAttachmentStream(XMLInstream,FilePathEDoc);
        if SendPDF then
          SMTPMail.AddAttachment(PDFFilePath,'');

        SendOK := SMTPMail.TrySend;

        if SendPDF then
          DeleteServerFile(PDFFilePath);

        if not SendOK then
          Error(StrSubstNo(Text016,SMTPMail.GetLastSendMailErrorText));
    end;


    procedure ImportElectronicInvoice(var PurchaseHeader: Record "Purchase Header")
    var
        FileManagement: Codeunit "File Management";
        XMLDOMManagement: Codeunit "XML DOM Management";
        XMLDoc: dotnet XmlDocument;
        Node: dotnet XmlNode;
        NodeList: dotnet XmlNodeList;
        NamespaceManager: dotnet XmlNamespaceManager;
        ServerFileName: Text;
        ClientFileName: Text;
    begin
        if FileManagement.IsWebClient then
          Error(WebClientErr);

        ClientFileName := FileManagement.OpenFileDialog(FileDialogTxt,'',FileManagement.GetToFilterText('','.xml'));
        if ClientFileName = '' then
          exit;

        ServerFileName := FileManagement.UploadFileSilent(ClientFileName);

        XMLDOMManagement.LoadXMLDocumentFromFile(ServerFileName,XMLDoc);

        NamespaceManager := NamespaceManager.XmlNamespaceManager(XMLDoc.NameTable);
        NamespaceManager.AddNamespace('cfdi','http://www.sat.gob.mx/cfd/3');
        NamespaceManager.AddNamespace('tfd','http://www.sat.gob.mx/TimbreFiscalDigital');

        // Import UUID
        NodeList := XMLDoc.DocumentElement.SelectNodes('//cfdi:Complemento/tfd:TimbreFiscalDigital',NamespaceManager);
        if NodeList.Count <> 0 then begin
          Node := NodeList.Item(0);
          PurchaseHeader.Validate("Fiscal Invoice Number PAC",Node.Attributes.GetNamedItem('UUID').Value);
          PurchaseHeader.Modify(true);
        end else
          Error(ImportFailedErr);
    end;

    local procedure WriteCompanyInfo(var XMLDoc: dotnet XmlDocument;var XMLCurrNode: dotnet XmlNode)
    var
        XMLNewChild: dotnet XmlNode;
    begin
        with CompanyInfo do begin
          // Emisor
          AddElementCFDI(XMLCurrNode,'Emisor','',DocNameSpace,XMLNewChild);
          XMLCurrNode := XMLNewChild;
          AddAttribute(XMLDoc,XMLCurrNode,'rfc',"RFC No.");
          AddAttribute(XMLDoc,XMLCurrNode,'nombre',Name);

          // Emisor->DomicilioFiscal
          AddElementCFDI(XMLCurrNode,'DomicilioFiscal','',DocNameSpace,XMLNewChild);
          XMLCurrNode := XMLNewChild;
          AddAttribute(XMLDoc,XMLCurrNode,'calle',Address);
          AddAttribute(XMLDoc,XMLCurrNode,'colonia',County);
          AddAttribute(XMLDoc,XMLCurrNode,'localidad',City);
          AddAttribute(XMLDoc,XMLCurrNode,'municipio',City);
          AddAttribute(XMLDoc,XMLCurrNode,'estado',County);
          AddAttribute(XMLDoc,XMLCurrNode,'pais',"Country/Region Code");
          AddAttribute(XMLDoc,XMLCurrNode,'codigoPostal',"Post Code");

          // Emisor->ExpedidoEn
          XMLCurrNode := XMLCurrNode.ParentNode;
          AddElementCFDI(XMLCurrNode,'ExpedidoEn','',DocNameSpace,XMLNewChild);
          XMLCurrNode := XMLNewChild;
          AddAttribute(XMLDoc,XMLCurrNode,'calle',Address);
          AddAttribute(XMLDoc,XMLCurrNode,'colonia',County);
          AddAttribute(XMLDoc,XMLCurrNode,'localidad',City);
          AddAttribute(XMLDoc,XMLCurrNode,'estado',County);
          AddAttribute(XMLDoc,XMLCurrNode,'pais',"Country/Region Code");
          AddAttribute(XMLDoc,XMLCurrNode,'codigoPostal',"Post Code");

          // PM 3.2 RegimenFiscal
          XMLCurrNode := XMLCurrNode.ParentNode;
          AddElementCFDI(XMLCurrNode,'RegimenFiscal','',DocNameSpace,XMLNewChild);
          XMLCurrNode := XMLNewChild;
          AddAttribute(XMLDoc,XMLCurrNode,'Regimen',"Tax Scheme");
        end;
    end;

    local procedure InitXML(var XMLDoc: dotnet XmlDocument;var XMLCurrNode: dotnet XmlNode)
    var
        XMLDOMManagement: Codeunit "XML DOM Management";
    begin
        // Create instance
        if IsNull(XMLDoc) then
          XMLDoc := XMLDoc.XmlDocument;

        // Root element
        DocNameSpace := 'http://www.sat.gob.mx/cfd/3';
        XMLDOMManagement.LoadXMLDocumentFromText('<?xml version="1.0" encoding="UTF-8" ?> ' +
          '<cfdi:Comprobante xmlns:cfdi="http://www.sat.gob.mx/cfd/3" xmlns="" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" ' +
          'xsi:schemaLocation="http://www.sat.gob.mx/cfd/3 http://www.sat.gob.mx/sitio_internet/cfd/3/cfdv32.xsd"></cfdi:Comprobante>',
          XMLDoc);

        XMLCurrNode := XMLDoc.DocumentElement;
    end;

    local procedure AddElementCFDI(var XMLNode: dotnet XmlNode;NodeName: Text;NodeText: Text;NameSpace: Text;var CreatedXMLNode: dotnet XmlNode): Boolean
    var
        NewChildNode: dotnet XmlNode;
    begin
        NodeName := 'cfdi:' + NodeName;
        NewChildNode := XMLNode.OwnerDocument.CreateNode('element',NodeName,NameSpace);
        if IsNull(NewChildNode) then
          exit(false);

        if NodeText <> '' then
          NewChildNode.Value := RemoveInvalidChars(NodeText);
        XMLNode.AppendChild(NewChildNode);
        CreatedXMLNode := NewChildNode;
        exit(true);
    end;

    local procedure AddElement(var XMLNode: dotnet XmlNode;NodeName: Text;NodeText: Text;NameSpace: Text;var CreatedXMLNode: dotnet XmlNode): Boolean
    var
        NewChildNode: dotnet XmlNode;
    begin
        NewChildNode := XMLNode.OwnerDocument.CreateNode('element',NodeName,NameSpace);
        if IsNull(NewChildNode) then
          exit(false);

        if NodeText <> '' then
          NewChildNode.Value := RemoveInvalidChars(NodeText);
        XMLNode.AppendChild(NewChildNode);
        CreatedXMLNode := NewChildNode;
        exit(true);
    end;

    local procedure AddAttribute(var XMLDomDocParam: dotnet XmlDocument;var XMLDomNode: dotnet XmlNode;AttribName: Text;AttribValue: Text): Boolean
    var
        XMLDomAttribute: dotnet XmlAttribute;
    begin
        XMLDomAttribute := XMLDomDocParam.CreateAttribute(AttribName);
        if IsNull(XMLDomAttribute) then
          exit(false);

        if AttribValue <> '' then begin
          XMLDomAttribute.Value := RemoveInvalidChars(AttribValue);
          XMLDomNode.Attributes.SetNamedItem(XMLDomAttribute);
        end;
        Clear(XMLDomAttribute);
        exit(true);
    end;

    local procedure GetPmtTermCode(PmtTermCode: Code[10]) PmtTermText: Text
    begin
        if PmtTermCode <> '' then
          PmtTermText := 'Parcialidad 1 de ' + PmtTermCode
        else
          PmtTermText := 'Pago en una sola exhibicion';
    end;

    local procedure FormatAmount(InAmount: Decimal): Text
    begin
        exit(Format(Abs(InAmount),0,9));
    end;

    local procedure RemoveInvalidChars(PassedStr: Text): Text
    begin
        PassedStr := DelChr(PassedStr,'=','|');
        PassedStr := RemoveExtraWhiteSpaces(PassedStr);
        exit(PassedStr);
    end;

    local procedure GetReportNo(var ReportSelection: Record "Report Selections"): Integer
    begin
        ReportSelection.SetFilter("Report ID",'<>0');
        if ReportSelection.FindFirst then
          exit(ReportSelection."Report ID");
        exit(0);
    end;

    local procedure FormatDateTime(DateTime: DateTime): Text[50]
    begin
        exit(Format(DateTime,0,'<Year4>-<Month,2>-<Day,2>T<Hours24,2>:<Minutes,2>:<Seconds,2>'));
    end;

    local procedure FormatAsDateTime(DocDate: Date;DocTime: Time): Text[50]
    begin
        exit(FormatDateTime(CreateDatetime(DocDate,DocTime)));
    end;

    local procedure GetGLSetup()
    begin
        GLSetup.Get;
        GLSetup.TestField("SAT Certificate Thumbprint");
    end;

    local procedure GetCompanyInfo()
    begin
        CompanyInfo.Get;
        CompanyInfo.TestField(Name);
        CompanyInfo.TestField("RFC No.");
        CompanyInfo.TestField(Address);
        CompanyInfo.TestField(City);
        CompanyInfo.TestField("Country/Region Code");
        CompanyInfo.TestField("Post Code");
        CompanyInfo.TestField("E-Mail");
        CompanyInfo.TestField("Tax Scheme");
    end;

    local procedure GetCustomer(CustomerNo: Code[20])
    begin
        Customer.Get(CustomerNo);
        Customer.TestField("RFC No.");
        Customer.TestField("Country/Region Code");
    end;

    local procedure GetBankAccountLastFourChars(BankAccountNo: Text): Text[4]
    begin
        BankAccountNo := DelChr(BankAccountNo,'=',' ');
        exit(CopyStr(BankAccountNo,StrLen(BankAccountNo) - 3))
    end;

    local procedure CalcSalesInvLineTotal(var SubTotal: Decimal;var RetainAmt: Decimal;DocumentNo: Code[20])
    var
        SalesInvoiceLine: Record "Sales Invoice Line";
    begin
        SalesInvoiceLine.Reset;
        SalesInvoiceLine.SetRange("Document No.",DocumentNo);
        SalesInvoiceLine.SetFilter(Type,'<>%1',SalesInvoiceLine.Type::" ");
        if SalesInvoiceLine.FindSet then
          repeat
            SalesInvoiceLine.TestField(Description);
            SubTotal := SubTotal + (SalesInvoiceLine.Quantity * SalesInvoiceLine."Unit Price");
            RetainAmt := RetainAmt + (SalesInvoiceLine."Amount Including VAT" - SalesInvoiceLine.Amount);
          until SalesInvoiceLine.Next = 0;
    end;

    local procedure CalcSalesCrMemoLineTotal(var SubTotal: Decimal;var RetainAmt: Decimal;DocumentNo: Code[20])
    var
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
    begin
        SalesCrMemoLine.Reset;
        SalesCrMemoLine.SetRange("Document No.",DocumentNo);
        SalesCrMemoLine.SetFilter(Type,'<>%1',SalesCrMemoLine.Type::" ");
        if SalesCrMemoLine.FindSet then
          repeat
            SalesCrMemoLine.TestField(Description);
            SubTotal := SubTotal + (SalesCrMemoLine.Quantity * SalesCrMemoLine."Unit Price");
            RetainAmt := RetainAmt + (SalesCrMemoLine."Amount Including VAT" - SalesCrMemoLine.Amount);
          until SalesCrMemoLine.Next = 0;
    end;

    local procedure CalcServiceInvLineTotal(var SubTotal: Decimal;var RetainAmt: Decimal;var AmontInclVAT: Decimal;DocumentNo: Code[20])
    var
        ServiceInvoiceLine: Record "Service Invoice Line";
    begin
        ServiceInvoiceLine.Reset;
        ServiceInvoiceLine.SetRange("Document No.",DocumentNo);
        ServiceInvoiceLine.SetFilter(Type,'<>%1',ServiceInvoiceLine.Type::" ");
        if ServiceInvoiceLine.FindSet then
          repeat
            ServiceInvoiceLine.TestField(Description);
            SubTotal := SubTotal + (ServiceInvoiceLine.Quantity * ServiceInvoiceLine."Unit Price");
            RetainAmt := RetainAmt + (ServiceInvoiceLine."Amount Including VAT" - ServiceInvoiceLine.Amount);
            AmontInclVAT := AmontInclVAT + ServiceInvoiceLine."Amount Including VAT";
          until ServiceInvoiceLine.Next = 0;
    end;

    local procedure CalcServiceCrMemoLineTotal(var SubTotal: Decimal;var RetainAmt: Decimal;var AmontInclVAT: Decimal;DocumentNo: Code[20])
    var
        ServiceCrMemoLine: Record "Service Cr.Memo Line";
    begin
        ServiceCrMemoLine.Reset;
        ServiceCrMemoLine.SetRange("Document No.",DocumentNo);
        ServiceCrMemoLine.SetFilter(Type,'<>%1',ServiceCrMemoLine.Type::" ");
        if ServiceCrMemoLine.FindSet then
          repeat
            ServiceCrMemoLine.TestField(Description);
            SubTotal := SubTotal + (ServiceCrMemoLine.Quantity * ServiceCrMemoLine."Unit Price");
            RetainAmt := RetainAmt + (ServiceCrMemoLine."Amount Including VAT" - ServiceCrMemoLine.Amount);
            AmontInclVAT := AmontInclVAT + ServiceCrMemoLine."Amount Including VAT";
          until ServiceCrMemoLine.Next = 0;
    end;

    local procedure RemoveExtraWhiteSpaces(StrParam: Text) StrReturn: Text
    var
        Cntr1: Integer;
        Cntr2: Integer;
        WhiteSpaceFound: Boolean;
    begin
        StrParam := DelChr(StrParam,'<>',' ');
        WhiteSpaceFound := false;
        Cntr2 := 1;
        for Cntr1 := 1 to StrLen(StrParam) do
          if StrParam[Cntr1] <> ' ' then begin
            WhiteSpaceFound := false;
            StrReturn[Cntr2] := StrParam[Cntr1];
            Cntr2 += 1;
          end else
            if not WhiteSpaceFound then begin
              WhiteSpaceFound := true;
              StrReturn[Cntr2] := StrParam[Cntr1];
              Cntr2 += 1;
            end;
    end;

    local procedure InvokeMethod(var XMLDoc: dotnet XmlDocument;MethodType: Option "Request Stamp",Cancel): Text
    var
        PACWebService: Record UnknownRecord10000;
        PACWebServiceDetail: Record UnknownRecord10001;
        EInvoiceObjectFactory: Codeunit "E-Invoice Object Factory";
        IWebServiceInvoker: dotnet IWebServiceInvoker;
    begin
        GetGLSetup;
        if GLSetup."Sim. Request Stamp" then
          exit;
        if GLSetup."PAC Environment" = GLSetup."pac environment"::Disabled then
          Error(Text014,GLSetup.FieldCaption("PAC Environment"),GLSetup.TableCaption,GLSetup."PAC Environment");

        EInvoiceObjectFactory.GetWebServiceInvoker(IWebServiceInvoker);

        // Depending on the chosen service provider, this section needs to be modified.
        // The parameters for the invoked method need to be added in the correct order.
        case MethodType of
          Methodtype::"Request Stamp":
            begin
              if not PACWebServiceDetail.Get(GLSetup."PAC Code",GLSetup."PAC Environment",PACWebServiceDetail.Type::"Request Stamp") then begin
                PACWebServiceDetail.Type := PACWebServiceDetail.Type::"Request Stamp";
                Error(Text009,PACWebServiceDetail.Type,GLSetup.FieldCaption("PAC Code"),
                  GLSetup.FieldCaption("PAC Environment"),GLSetup.TableCaption);
              end;
              IWebServiceInvoker.AddParameter(XMLDoc.InnerXml);
              IWebServiceInvoker.AddParameter(false);
            end;
          Methodtype::Cancel:
            begin
              if not PACWebServiceDetail.Get(GLSetup."PAC Code",GLSetup."PAC Environment",PACWebServiceDetail.Type::Cancel) then
                begin
                PACWebServiceDetail.Type := PACWebServiceDetail.Type::Cancel;
                Error(Text009,PACWebServiceDetail.Type,GLSetup.FieldCaption("PAC Code"),
                  GLSetup.FieldCaption("PAC Environment"),GLSetup.TableCaption);
              end;
              IWebServiceInvoker.AddParameter(XMLDoc.InnerXml);
            end;
        end;

        PACWebService.Get(GLSetup."PAC Code");
        if PACWebService."Certificate Thumbprint" = '' then
          Error(Text012,PACWebService.FieldCaption("Certificate Thumbprint"),PACWebService.TableCaption,GLSetup.TableCaption);

        exit(IWebServiceInvoker.InvokeMethod(PACWebServiceDetail.Address,
            PACWebServiceDetail."Method Name",PACWebService."Certificate Thumbprint"));
    end;

    local procedure GetQRCode(QRCodeInput: Text[95]) QRCodeFileName: Text
    var
        EInvoiceObjectFactory: Codeunit "E-Invoice Object Factory";
        IBarCodeProvider: dotnet IBarcodeProvider;
    begin
        EInvoiceObjectFactory.GetBarCodeProvider(IBarCodeProvider);
        QRCodeFileName := IBarCodeProvider.GetBarcode(QRCodeInput);
    end;

    local procedure CreateQRCodeInput(IssuerRFC: Text;CustomerRFC: Text;Amount: Decimal;UUID: Text) QRCodeInput: Text[95]
    begin
        QRCodeInput :=
          '?re=' +
          CopyStr(IssuerRFC,1,13) +
          '&rr=' +
          CopyStr(CustomerRFC,1,13) +
          '&tt=' +
          ConvertStr(Format(Amount,0,'<Integer,10><Filler Character,0><Decimals,7>'),',','.') +
          '&id=' +
          CopyStr(Format(UUID),1,36);
    end;

    local procedure GetDateTimeOfFirstReqSalesInv(var SalesInvoiceHeader: Record "Sales Invoice Header"): Text[50]
    begin
        if SalesInvoiceHeader."Date/Time First Req. Sent" <> '' then
          exit(SalesInvoiceHeader."Date/Time First Req. Sent");

        SalesInvoiceHeader."Date/Time First Req. Sent" := FormatAsDateTime(SalesInvoiceHeader."Document Date",Time);
        exit(SalesInvoiceHeader."Date/Time First Req. Sent");
    end;

    local procedure GetDateTimeOfFirstReqSalesCr(var SalesCrMemoHeader: Record "Sales Cr.Memo Header"): Text[50]
    begin
        if SalesCrMemoHeader."Date/Time First Req. Sent" <> '' then
          exit(SalesCrMemoHeader."Date/Time First Req. Sent");

        SalesCrMemoHeader."Date/Time First Req. Sent" := FormatAsDateTime(SalesCrMemoHeader."Document Date",Time);
        exit(SalesCrMemoHeader."Date/Time First Req. Sent");
    end;

    local procedure GetDateTimeOfFirstReqServInv(var ServiceInvoiceHeader: Record "Service Invoice Header"): Text[50]
    begin
        if ServiceInvoiceHeader."Date/Time First Req. Sent" <> '' then
          exit(ServiceInvoiceHeader."Date/Time First Req. Sent");

        ServiceInvoiceHeader."Date/Time First Req. Sent" := FormatAsDateTime(ServiceInvoiceHeader."Document Date",Time);
        exit(ServiceInvoiceHeader."Date/Time First Req. Sent");
    end;

    local procedure GetDateTimeOfFirstReqServCr(var ServiceCrMemoHeader: Record "Service Cr.Memo Header"): Text[50]
    begin
        if ServiceCrMemoHeader."Date/Time First Req. Sent" <> '' then
          exit(ServiceCrMemoHeader."Date/Time First Req. Sent");

        ServiceCrMemoHeader."Date/Time First Req. Sent" := FormatAsDateTime(ServiceCrMemoHeader."Document Date",Time);
        exit(ServiceCrMemoHeader."Date/Time First Req. Sent");
    end;

    local procedure DeleteServerFile(ServerFileName: Text)
    begin
        if Erase(ServerFileName) then;
    end;

    local procedure CreateQRCode(QRCodeInput: Text[95];var TempBLOB: Record TempBlob)
    var
        FileManagement: Codeunit "File Management";
        QRCodeFileName: Text;
    begin
        Clear(TempBLOB);
        QRCodeFileName := GetQRCode(QRCodeInput);
        FileManagement.BLOBImportFromServerFile(TempBLOB,QRCodeFileName);
        DeleteServerFile(QRCodeFileName);
    end;

    local procedure TextToBlob(var TempBlob: Record TempBlob;Content: Text)
    var
        OutStream: OutStream;
        BigString: BigText;
    begin
        Clear(TempBlob);
        BigString.AddText(Content);
        TempBlob.Blob.CreateOutstream(OutStream);
        BigString.Write(OutStream);
    end;


    procedure CreateAbstractDocument(DocumentHeaderVariant: Variant;var TempDocumentHeader: Record UnknownRecord10002 temporary;var TempDocumentLine: Record UnknownRecord10003 temporary)
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesInvoiceLine: Record "Sales Invoice Line";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        ServiceInvoiceHeader: Record "Service Invoice Header";
        ServiceInvoiceLine: Record "Service Invoice Line";
        ServiceCrMemoHeader: Record "Service Cr.Memo Header";
        ServiceCrMemoLine: Record "Service Cr.Memo Line";
        DataTypeManagement: Codeunit "Data Type Management";
        RecRef: RecordRef;
    begin
        DataTypeManagement.GetRecordRef(DocumentHeaderVariant,RecRef);
        case RecRef.Number of
          Database::"Sales Invoice Header":
            begin
              RecRef.SetTable(SalesInvoiceHeader);
              TempDocumentHeader.TransferFields(SalesInvoiceHeader);
              TempDocumentHeader.Insert;

              SalesInvoiceLine.Reset;
              SalesInvoiceLine.SetRange("Document No.",SalesInvoiceHeader."No.");
              SalesInvoiceLine.SetFilter(Type,'<>%1',SalesInvoiceLine.Type::" ");
              if SalesInvoiceLine.FindSet then
                repeat
                  TempDocumentLine.TransferFields(SalesInvoiceLine);
                  TempDocumentLine.Insert;
                until SalesInvoiceLine.Next = 0;
            end;
          Database::"Sales Cr.Memo Header":
            begin
              RecRef.SetTable(SalesCrMemoHeader);
              TempDocumentHeader.TransferFields(SalesCrMemoHeader);
              TempDocumentHeader.Insert;

              SalesCrMemoLine.Reset;
              SalesCrMemoLine.SetRange("Document No.",SalesCrMemoHeader."No.");
              SalesCrMemoLine.SetFilter(Type,'<>%1',SalesCrMemoLine.Type::" ");
              if SalesCrMemoLine.FindSet then
                repeat
                  TempDocumentLine.TransferFields(SalesCrMemoLine);
                  TempDocumentLine.Insert;
                until SalesCrMemoLine.Next = 0;
            end;
          Database::"Service Invoice Header":
            begin
              RecRef.SetTable(ServiceInvoiceHeader);
              TempDocumentHeader.TransferFields(ServiceInvoiceHeader);
              TempDocumentHeader.Insert;

              ServiceInvoiceLine.Reset;
              ServiceInvoiceLine.SetRange("Document No.",ServiceInvoiceHeader."No.");
              ServiceInvoiceLine.SetFilter(Type,'<>%1',ServiceInvoiceLine.Type::" ");
              if ServiceInvoiceLine.FindSet then
                repeat
                  TempDocumentLine.TransferFields(ServiceInvoiceLine);
                  TempDocumentLine.Insert;
                until ServiceInvoiceLine.Next = 0;
            end;
          Database::"Service Cr.Memo Header":
            begin
              RecRef.SetTable(ServiceCrMemoHeader);
              TempDocumentHeader.TransferFields(ServiceCrMemoHeader);
              TempDocumentHeader.Insert;

              ServiceCrMemoLine.Reset;
              ServiceCrMemoLine.SetRange("Document No.",ServiceCrMemoHeader."No.");
              ServiceCrMemoLine.SetFilter(Type,'<>%1',ServiceCrMemoLine.Type::" ");
              if ServiceCrMemoLine.FindSet then
                repeat
                  TempDocumentLine.TransferFields(ServiceCrMemoLine);
                  TempDocumentLine.Insert;
                until ServiceCrMemoLine.Next = 0;
            end;
        end;
    end;
}

