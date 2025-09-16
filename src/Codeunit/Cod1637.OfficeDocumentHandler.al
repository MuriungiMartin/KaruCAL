#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1637 "Office Document Handler"
{
    TableNo = "Office Add-in Context";

    trigger OnRun()
    begin
        RedirectToDocument(Rec);
    end;

    var
        DocDoesNotExistMsg: label 'Cannot find a document with the number %1.', Comment='%1=The document number the hyperlink is attempting to open.';


    procedure RedirectToDocument(TempOfficeAddinContext: Record "Office Add-in Context" temporary)
    var
        TempOfficeDocumentSelection: Record "Office Document Selection" temporary;
        DocMatch: Text;
        DocNo: Code[20];
    begin
        DocMatch := TempOfficeAddinContext."Regular Expression Match" + '|';
        repeat
          TempOfficeAddinContext."Regular Expression Match" := CopyStr(DocMatch,1,StrPos(DocMatch,'|') - 1);
          DocMatch := CopyStr(DocMatch,StrPos(DocMatch,'|') + 1);
          CollectDocumentMatches(TempOfficeDocumentSelection,DocNo,TempOfficeAddinContext);
        until StrPos(DocMatch,'|') = 0;

        case TempOfficeDocumentSelection.Count of
          0:
            begin
              TempOfficeAddinContext."Document No." := DocNo;
              Page.Run(Page::"Office Doc Selection Dlg");
            end;
          1:
            OpenIndividualDocument(TempOfficeAddinContext,TempOfficeDocumentSelection);
          else // More than one document match, must have user pick
            Page.Run(Page::"Office Document Selection",TempOfficeDocumentSelection);
        end;
    end;


    procedure ShowDocumentSelection(DocSeries: Integer;DocType: Integer)
    var
        TempOfficeDocumentSelection: Record "Office Document Selection" temporary;
    begin
        with TempOfficeDocumentSelection do
          case DocSeries of
            Series::Sales:
              GetSalesDocuments(TempOfficeDocumentSelection,DocSeries,DocType);
            Series::Purchase:
              GetPurchaseDocuments(TempOfficeDocumentSelection,DocSeries,DocType);
          end;
        Page.Run(Page::"Office Document Selection",TempOfficeDocumentSelection);
    end;


    procedure HandleSalesCommand(Customer: Record Customer;TempOfficeAddinContext: Record "Office Add-in Context" temporary)
    var
        OfficeMgt: Codeunit "Office Management";
        OutlookCommand: dotnet OutlookCommand;
    begin
        case TempOfficeAddinContext.Command of
          OutlookCommand.NewSalesCreditMemo:
            Customer.CreateAndShowNewCreditMemo;
          OutlookCommand.NewSalesInvoice:
            if not OfficeMgt.CheckForExistingInvoice(Customer."No.") then
              Customer.CreateAndShowNewInvoice;
          OutlookCommand.NewSalesQuote:
            Customer.CreateAndShowNewQuote;
          OutlookCommand.NewSalesOrder:
            Customer.CreateAndShowNewOrder;
        end;
    end;


    procedure HandlePurchaseCommand(Vendor: Record Vendor;TempOfficeAddinContext: Record "Office Add-in Context" temporary)
    var
        OutlookCommand: dotnet OutlookCommand;
    begin
        case TempOfficeAddinContext.Command of
          OutlookCommand.NewPurchaseCreditMemo:
            Vendor.CreateAndShowNewCreditMemo;
          OutlookCommand.NewPurchaseInvoice:
            Vendor.CreateAndShowNewInvoice;
          OutlookCommand.NewPurchaseOrder:
            Vendor.CreateAndShowNewPurchaseOrder;
        end;
    end;


    procedure OpenIndividualDocument(TempOfficeAddinContext: Record "Office Add-in Context" temporary;TempOfficeDocumentSelection: Record "Office Document Selection" temporary)
    begin
        case TempOfficeDocumentSelection.Series of
          TempOfficeDocumentSelection.Series::Sales:
            OpenIndividualSalesDocument(TempOfficeAddinContext,TempOfficeDocumentSelection);
          TempOfficeDocumentSelection.Series::Purchase:
            OpenIndividualPurchaseDocument(TempOfficeAddinContext,TempOfficeDocumentSelection);
        end;
    end;

    local procedure CollectDocumentMatches(var TempOfficeDocumentSelection: Record "Office Document Selection" temporary;var DocNo: Code[20];TempOfficeAddinContext: Record "Office Add-in Context" temporary)
    var
        DocNos: dotnet String;
        Separator: dotnet String;
    begin
        // We'll either have a document number already, or we'll need to process the RegularExpressionMatch
        // to derive the document number.
        if (TempOfficeAddinContext."Document No." = '') and (TempOfficeAddinContext."Regular Expression Match" <> '') then begin
          // Try to set DocNo by checking Expression for Window Title Key Words
          if not ExpressionContainsSeriesTitle(TempOfficeAddinContext."Regular Expression Match",DocNo,TempOfficeDocumentSelection) then
            // Last attempt, look for key English terms:  Quote, Order, Invoice, and Credit Memo
            ExpressionContainsKeyWords(TempOfficeAddinContext."Regular Expression Match",DocNo,TempOfficeDocumentSelection)
        end else
          if TempOfficeAddinContext."Document No." <> '' then begin
            DocNos := TempOfficeAddinContext."Document No.";
            Separator := '|';
            foreach DocNo in DocNos.Split(Separator.ToCharArray) do
              with TempOfficeDocumentSelection do begin
                SetSalesDocumentMatchRecord(DocNo,"document type"::Order,TempOfficeDocumentSelection);
                SetSalesDocumentMatchRecord(DocNo,"document type"::Quote,TempOfficeDocumentSelection);
                SetSalesDocumentMatchRecord(DocNo,"document type"::Invoice,TempOfficeDocumentSelection);
                SetSalesDocumentMatchRecord(DocNo,"document type"::"Credit Memo",TempOfficeDocumentSelection);

                SetPurchDocumentMatchRecord(DocNo,"document type"::Invoice,TempOfficeDocumentSelection);
                SetPurchDocumentMatchRecord(DocNo,"document type"::"Credit Memo",TempOfficeDocumentSelection);
                SetPurchDocumentMatchRecord(DocNo,"document type"::Order,TempOfficeDocumentSelection);
              end;
          end;
    end;

    local procedure CreateDocumentMatchRecord(var TempOfficeDocumentSelection: Record "Office Document Selection" temporary;Series: Option;DocType: Option;DocNo: Code[20];Posted: Boolean;DocDate: Date)
    begin
        TempOfficeDocumentSelection.Init;
        TempOfficeDocumentSelection.Validate("Document No.",DocNo);
        TempOfficeDocumentSelection.Validate("Document Date",DocDate);
        TempOfficeDocumentSelection.Validate("Document Type",DocType);
        TempOfficeDocumentSelection.Validate(Series,Series);
        TempOfficeDocumentSelection.Validate(Posted,Posted);
        if not TempOfficeDocumentSelection.Insert then;
    end;

    local procedure DocumentDoesNotExist(DocumentNo: Text[250])
    begin
        Message(DocDoesNotExistMsg,DocumentNo);
    end;

    local procedure ExpressionContainsKeyWords(Expression: Text[250];var DocNo: Code[20];var TempOfficeDocumentSelection: Record "Office Document Selection" temporary): Boolean
    var
        DummySalesHeader: Record "Sales Header";
        HyperlinkManifest: Codeunit "Hyperlink Manifest";
    begin
        with DummySalesHeader do
          case true of
            GetDocumentNumber(Expression,Format("document type"::Quote),DocNo):
              SetSalesDocumentMatchRecord(DocNo,"document type"::Quote,TempOfficeDocumentSelection);
            GetDocumentNumber(Expression,Format("document type"::Order),DocNo):
              begin
                SetSalesDocumentMatchRecord(DocNo,"document type"::Order,TempOfficeDocumentSelection);
                SetPurchDocumentMatchRecord(DocNo,"document type"::Order,TempOfficeDocumentSelection);
              end;
            GetDocumentNumber(Expression,Format("document type"::Invoice),DocNo):
              begin
                SetSalesDocumentMatchRecord(DocNo,"document type"::Invoice,TempOfficeDocumentSelection);
                SetPurchDocumentMatchRecord(DocNo,"document type"::Invoice,TempOfficeDocumentSelection);
              end;
            GetDocumentNumber(Expression,Format("document type"::"Credit Memo"),DocNo):
              begin
                SetSalesDocumentMatchRecord(DocNo,"document type"::"Credit Memo",TempOfficeDocumentSelection);
                SetPurchDocumentMatchRecord(DocNo,"document type"::"Credit Memo",TempOfficeDocumentSelection);
              end;
            GetDocumentNumber(Expression,HyperlinkManifest.GetAcronymForPurchaseOrder,DocNo):
              SetPurchDocumentMatchRecord(DocNo,TempOfficeDocumentSelection."document type"::Order,TempOfficeDocumentSelection);
            else
              exit(false);
          end;
        exit(true);
    end;

    local procedure ExpressionContainsSeriesTitle(Expression: Text[250];var DocNo: Code[20];var TempOfficeDocumentSelection: Record "Office Document Selection" temporary): Boolean
    var
        HyperlinkManifest: Codeunit "Hyperlink Manifest";
    begin
        with HyperlinkManifest do
          case true of
            GetDocumentNumber(Expression,GetNameForPurchaseCrMemo,DocNo):
              SetPurchDocumentMatchRecord(DocNo,TempOfficeDocumentSelection."document type"::"Credit Memo",TempOfficeDocumentSelection);
            GetDocumentNumber(Expression,GetNameForPurchaseInvoice,DocNo):
              SetPurchDocumentMatchRecord(DocNo,TempOfficeDocumentSelection."document type"::Invoice,TempOfficeDocumentSelection);
            GetDocumentNumber(Expression,GetNameForPurchaseOrder,DocNo):
              SetPurchDocumentMatchRecord(DocNo,TempOfficeDocumentSelection."document type"::Order,TempOfficeDocumentSelection);
            GetDocumentNumber(Expression,GetNameForSalesCrMemo,DocNo):
              SetSalesDocumentMatchRecord(DocNo,TempOfficeDocumentSelection."document type"::"Credit Memo",TempOfficeDocumentSelection);
            GetDocumentNumber(Expression,GetNameForSalesInvoice,DocNo):
              SetSalesDocumentMatchRecord(DocNo,TempOfficeDocumentSelection."document type"::Invoice,TempOfficeDocumentSelection);
            GetDocumentNumber(Expression,GetNameForSalesOrder,DocNo):
              SetSalesDocumentMatchRecord(DocNo,TempOfficeDocumentSelection."document type"::Order,TempOfficeDocumentSelection);
            GetDocumentNumber(Expression,GetNameForSalesQuote,DocNo):
              SetSalesDocumentMatchRecord(DocNo,TempOfficeDocumentSelection."document type"::Quote,TempOfficeDocumentSelection);
            else
              exit(false);
          end;
        exit(true);
    end;

    local procedure GetDocumentNumber(Expression: Text[250];Keyword: Text;var DocNo: Code[20]) IsMatch: Boolean
    var
        HyperlinkManifest: Codeunit "Hyperlink Manifest";
        DocNoRegEx: dotnet Regex;
    begin
        DocNoRegEx := DocNoRegEx.Regex(StrSubstNo('(?i)(%1)[\#:\s]*(%2)',Keyword,HyperlinkManifest.GetNumberSeriesRegex));
        IsMatch := DocNoRegEx.IsMatch(Expression);
        if IsMatch then
          DocNo := DocNoRegEx.Replace(Expression,'$2');
    end;

    local procedure GetSalesDocuments(var TempOfficeDocumentSelection: Record "Office Document Selection" temporary;Series: Integer;DocType: Integer)
    var
        SalesHeader: Record "Sales Header";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
    begin
        // Unposted
        SalesHeader.SetRange("Document Type",DocType);
        if SalesHeader.FindSet then
          repeat
            CreateDocumentMatchRecord(TempOfficeDocumentSelection,Series,DocType,
              SalesHeader."No.",false,SalesHeader."Document Date");
          until SalesHeader.Next = 0;

        // Posted Invoices
        if DocType = TempOfficeDocumentSelection."document type"::Invoice then
          if SalesInvoiceHeader.FindSet then
            repeat
              CreateDocumentMatchRecord(TempOfficeDocumentSelection,Series,DocType,
                SalesInvoiceHeader."No.",true,SalesInvoiceHeader."Document Date");
            until SalesInvoiceHeader.Next = 0;

        // Posted Credit Memos
        if DocType = TempOfficeDocumentSelection."document type"::"Credit Memo" then
          if SalesCrMemoHeader.FindSet then
            repeat
              CreateDocumentMatchRecord(TempOfficeDocumentSelection,Series,DocType,
                SalesCrMemoHeader."No.",true,SalesCrMemoHeader."Document Date");
            until SalesCrMemoHeader.Next = 0;
    end;

    local procedure GetPurchaseDocuments(var TempOfficeDocumentSelection: Record "Office Document Selection" temporary;Series: Integer;DocType: Integer)
    var
        PurchaseHeader: Record "Purchase Header";
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
    begin
        // Unposted
        PurchaseHeader.SetRange("Document Type",DocType);
        if PurchaseHeader.FindSet then
          repeat
            CreateDocumentMatchRecord(TempOfficeDocumentSelection,Series,DocType,
              PurchaseHeader."No.",false,PurchaseHeader."Document Date");
          until PurchaseHeader.Next = 0;

        // Posted Invoices
        if DocType = TempOfficeDocumentSelection."document type"::Invoice then
          if PurchInvHeader.FindSet then
            repeat
              CreateDocumentMatchRecord(TempOfficeDocumentSelection,Series,DocType,
                PurchInvHeader."No.",true,PurchInvHeader."Document Date");
            until PurchInvHeader.Next = 0;

        // Posted Credit Memos
        if DocType = TempOfficeDocumentSelection."document type"::"Credit Memo" then
          if PurchCrMemoHdr.FindSet then
            repeat
              CreateDocumentMatchRecord(TempOfficeDocumentSelection,Series,DocType,
                PurchCrMemoHdr."No.",true,PurchCrMemoHdr."Document Date");
            until PurchCrMemoHdr.Next = 0;
    end;

    local procedure OpenIndividualSalesDocument(TempOfficeAddinContext: Record "Office Add-in Context" temporary;TempOfficeDocumentSelection: Record "Office Document Selection" temporary)
    var
        SalesHeader: Record "Sales Header";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
    begin
        with TempOfficeDocumentSelection do
          if not Posted then
            if SalesHeader.Get("Document Type","Document No.") then
              case SalesHeader."Document Type" of
                SalesHeader."document type"::Quote:
                  Page.Run(Page::"Sales Quote",SalesHeader);
                SalesHeader."document type"::Order:
                  Page.Run(Page::"Sales Order",SalesHeader);
                SalesHeader."document type"::Invoice:
                  Page.Run(Page::"Sales Invoice",SalesHeader);
                SalesHeader."document type"::"Credit Memo":
                  Page.Run(Page::"Sales Credit Memo",SalesHeader);
              end else // No SalesHeader record found
              DocumentDoesNotExist(TempOfficeAddinContext."Document No.")
          else begin
            if "Document Type" = "document type"::Invoice then
              if SalesInvoiceHeader.Get("Document No.") then
                Page.Run(Page::"Posted Sales Invoice",SalesInvoiceHeader);
            if "Document Type" = "document type"::"Credit Memo" then
              if SalesCrMemoHeader.Get("Document No.") then
                Page.Run(Page::"Posted Sales Credit Memo",SalesCrMemoHeader);
          end;
    end;

    local procedure OpenIndividualPurchaseDocument(TempOfficeAddinContext: Record "Office Add-in Context" temporary;TempOfficeDocumentSelection: Record "Office Document Selection" temporary)
    var
        PurchaseHeader: Record "Purchase Header";
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
    begin
        with TempOfficeDocumentSelection do
          if not Posted then
            if PurchaseHeader.Get("Document Type","Document No.") then
              case PurchaseHeader."Document Type" of
                PurchaseHeader."document type"::Invoice:
                  Page.Run(Page::"Purchase Invoice",PurchaseHeader);
                PurchaseHeader."document type"::"Credit Memo":
                  Page.Run(Page::"Purchase Credit Memo",PurchaseHeader);
                PurchaseHeader."document type"::Order:
                  Page.Run(Page::"Purchase Order",PurchaseHeader);
              end else // No PurchaseHeader record found
              DocumentDoesNotExist(TempOfficeAddinContext."Document No.")
          else begin
            if "Document Type" = "document type"::Invoice then
              if PurchInvHeader.Get("Document No.") then
                Page.Run(Page::"Posted Purchase Invoice",PurchInvHeader);
            if "Document Type" = "document type"::"Credit Memo" then
              if PurchCrMemoHdr.Get("Document No.") then
                Page.Run(Page::"Posted Purchase Credit Memo",PurchCrMemoHdr);
          end;
    end;

    local procedure SetSalesDocumentMatchRecord(DocNo: Code[20];DocType: Integer;var TempOfficeDocumentSelection: Record "Office Document Selection" temporary)
    var
        SalesHeader: Record "Sales Header";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
    begin
        with TempOfficeDocumentSelection do begin
          if SalesHeader.Get(DocType,DocNo) then
            CreateDocumentMatchRecord(TempOfficeDocumentSelection,Series::Sales,DocType,DocNo,false,SalesHeader."Document Date");
          if SalesInvoiceHeader.Get(DocNo) and (DocType = "document type"::Invoice) then
            CreateDocumentMatchRecord(TempOfficeDocumentSelection,Series::Sales,DocType,DocNo,true,SalesInvoiceHeader."Document Date");
          if SalesCrMemoHeader.Get(DocNo) and (DocType = "document type"::"Credit Memo") then
            CreateDocumentMatchRecord(TempOfficeDocumentSelection,Series::Sales,DocType,DocNo,true,SalesCrMemoHeader."Document Date");
        end;
    end;

    local procedure SetPurchDocumentMatchRecord(DocNo: Code[20];DocType: Integer;var TempOfficeDocumentSelection: Record "Office Document Selection" temporary)
    var
        PurchaseHeader: Record "Purchase Header";
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
    begin
        with TempOfficeDocumentSelection do begin
          if PurchaseHeader.Get(DocType,DocNo) then
            CreateDocumentMatchRecord(TempOfficeDocumentSelection,Series::Purchase,DocType,DocNo,false,PurchaseHeader."Document Date");
          if PurchInvHeader.Get(DocNo) and (DocType = "document type"::Invoice) then
            CreateDocumentMatchRecord(TempOfficeDocumentSelection,Series::Purchase,DocType,DocNo,true,PurchInvHeader."Document Date");
          if PurchCrMemoHdr.Get(DocNo) and (DocType = "document type"::"Credit Memo") then
            CreateDocumentMatchRecord(TempOfficeDocumentSelection,Series::Purchase,DocType,DocNo,true,PurchCrMemoHdr."Document Date");
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnNewInvoice(var Rec: Record "Sales Header";RunTrigger: Boolean)
    var
        TempOfficeAddinContext: Record "Office Add-in Context" temporary;
        OfficeMgt: Codeunit "Office Management";
    begin
        if OfficeMgt.IsAvailable and (Rec."Document Type" = Rec."document type"::Invoice) then begin
          OfficeMgt.GetContext(TempOfficeAddinContext);
          if TempOfficeAddinContext.IsAppointment then
            CreateOfficeInvoiceRecord(TempOfficeAddinContext."Item ID",Rec."No.",false);
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Invoice Header", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnPostInvoice(var Rec: Record "Sales Invoice Header";RunTrigger: Boolean)
    var
        TempOfficeAddinContext: Record "Office Add-in Context" temporary;
        OfficeMgt: Codeunit "Office Management";
    begin
        if OfficeMgt.IsAvailable then begin
          OfficeMgt.GetContext(TempOfficeAddinContext);
          if TempOfficeAddinContext.IsAppointment then
            CreateOfficeInvoiceRecord(TempOfficeAddinContext."Item ID",Rec."No.",true);
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterDeleteEvent', '', false, false)]
    local procedure OnDeleteInvoice(var Rec: Record "Sales Header";RunTrigger: Boolean)
    var
        TempOfficeAddinContext: Record "Office Add-in Context" temporary;
        OfficeInvoice: Record "Office Invoice";
        OfficeMgt: Codeunit "Office Management";
    begin
        if OfficeMgt.IsAvailable and (Rec."Document Type" = Rec."document type"::Invoice) then begin
          OfficeMgt.GetContext(TempOfficeAddinContext);
          if TempOfficeAddinContext.IsAppointment then begin
            if OfficeInvoice.Get(TempOfficeAddinContext."Item ID",Rec."No.",false) then
              OfficeInvoice.Delete;
          end;
        end;
    end;

    local procedure CreateOfficeInvoiceRecord(ItemID: Text[250];DocNo: Code[20];Posted: Boolean)
    var
        OfficeInvoice: Record "Office Invoice";
    begin
        OfficeInvoice.Init;
        OfficeInvoice."Item ID" := ItemID;
        OfficeInvoice."Document No." := DocNo;
        OfficeInvoice.Posted := Posted;
        if not OfficeInvoice.Insert then
          OfficeInvoice.Modify;
    end;
}

