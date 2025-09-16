#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 260 "Document-Mailing"
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    var
        ReportSelections: Record "Report Selections";
    begin
        ReportSelections.SendEmailInBackground(Rec);
    end;

    var
        EmailSubjectCapTxt: label '%1 - %2 %3', Comment='%1 = Customer Name. %2 = Document Type %3 = Invoice No.';
        ReportAsPdfFileNameMsg: label 'Sales %1 %2.pdf', Comment='%1 = Document Type %2 = Invoice No.';
        EmailSubjectPluralCapTxt: label '%1 - %2', Comment='%1 = Customer Name. %2 = Document Type in plural form';
        ReportAsPdfFileNamePluralMsg: label 'Sales %1.pdf', Comment='%1 = Document Type in plural form';
        JobsReportAsPdfFileNameMsg: label '%1 %2.pdf', Comment='%1 = Document Type %2 = Job Number';
        PdfFileNamePluralMsg: label '%1.pdf', Comment='%1 = Document Type in plural form';


    procedure EmailFile(AttachmentFilePath: Text[250];AttachmentFileName: Text[250];HtmlBodyFilePath: Text[250];PostedDocNo: Code[20];ToEmailAddress: Text[250];EmailDocName: Text[150];HideDialog: Boolean;ReportUsage: Integer)
    var
        O365EmailSetup: Record "O365 Email Setup";
        TempEmailItem: Record "Email Item" temporary;
        CompanyInformation: Record "Company Information";
        ReportSelections: Record "Report Selections";
        OfficeMgt: Codeunit "Office Management";
    begin
        if AttachmentFileName = '' then
          if PostedDocNo = '' then begin
            if ReportUsage = ReportSelections.Usage::"P.Order" then
              AttachmentFileName := StrSubstNo(PdfFileNamePluralMsg,EmailDocName)
            else
              AttachmentFileName := StrSubstNo(ReportAsPdfFileNamePluralMsg,EmailDocName);
          end else
            case ReportUsage of
              ReportSelections.Usage::JQ,ReportSelections.Usage::"P.Order":
                AttachmentFileName := StrSubstNo(JobsReportAsPdfFileNameMsg,EmailDocName,PostedDocNo);
              else
                AttachmentFileName := StrSubstNo(ReportAsPdfFileNameMsg,EmailDocName,PostedDocNo)
            end;

        CompanyInformation.Get;
        with TempEmailItem do begin
          "Send to" := ToEmailAddress;
          if ReportUsage = ReportSelections.Usage::"S.Invoice" then begin
            "Send CC" := O365EmailSetup.GetCCAddressesFromO365EmailSetup;
            "Send BCC" := O365EmailSetup.GetBCCAddressesFromO365EmailSetup;
          end;
          if PostedDocNo = '' then
            Subject :=
              CopyStr(
                StrSubstNo(EmailSubjectPluralCapTxt,CompanyInformation.Name,EmailDocName),1,MaxStrLen(Subject))
          else
            Subject :=
              CopyStr(
                StrSubstNo(EmailSubjectCapTxt,CompanyInformation.Name,EmailDocName,PostedDocNo),1,MaxStrLen(Subject));
          "Attachment File Path" := AttachmentFilePath;
          "Attachment Name" := AttachmentFileName;
          if HtmlBodyFilePath <> '' then begin
            Validate("Plaintext Formatted",false);
            Validate("Body File Path",HtmlBodyFilePath);
          end;
          if OfficeMgt.AttachAvailable then
            OfficeMgt.AttachDocument(AttachmentFilePath,AttachmentFileName,GetBodyText)
          else
            Send(HideDialog);
        end;
    end;


    procedure EmailFileWithSubject(AttachmentFilePath: Text;AttachmentFileName: Text;HtmlBodyFilePath: Text;EmailSubject: Text;ToEmailAddress: Text;HideDialog: Boolean): Boolean
    var
        TempEmailItem: Record "Email Item" temporary;
    begin
        with TempEmailItem do begin
          "Send to" := CopyStr(ToEmailAddress,1,MaxStrLen("Send to"));
          Subject := CopyStr(EmailSubject,1,MaxStrLen(Subject));
          "Attachment File Path" := CopyStr(AttachmentFilePath,1,MaxStrLen("Attachment File Path"));
          "Attachment Name" := CopyStr(AttachmentFileName,1,MaxStrLen("Attachment Name"));

          Validate("Plaintext Formatted",false);
          Validate("Body File Path",CopyStr(HtmlBodyFilePath,1,MaxStrLen("Body File Path")));

          exit(Send(HideDialog));
        end;
    end;


    procedure GetToAddressFromCustomer(BillToCustomerNo: Code[20]): Text[250]
    var
        Customer: Record Customer;
        ToAddress: Text;
    begin
        if Customer.Get(BillToCustomerNo) then
          ToAddress := Customer."E-Mail";

        exit(ToAddress);
    end;


    procedure GetToAddressFromVendor(BuyFromVendorNo: Code[20]): Text[250]
    var
        Vendor: Record Vendor;
        ToAddress: Text;
    begin
        if Vendor.Get(BuyFromVendorNo) then
          ToAddress := Vendor."E-Mail";

        exit(ToAddress);
    end;
}

