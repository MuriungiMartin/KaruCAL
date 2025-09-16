#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 431 "IC Outbox Export"
{
    TableNo = "IC Outbox Transaction";

    trigger OnRun()
    var
        ICOutBoxTrans: Record "IC Outbox Transaction";
    begin
        if not Confirm(Text003,false) then
          exit;
        CompanyInfo.Get;
        ICOutBoxTrans.Copy(Rec);
        ICOutBoxTrans.SetRange("Line Action","line action"::"Send to IC Partner");
        UpdateICStatus(ICOutBoxTrans);
        SendToExternalPartner(ICOutBoxTrans);
        SendToInternalPartner(ICOutBoxTrans);
        ICOutBoxTrans.SetRange("Line Action","line action"::"Return to Inbox");
        ReturnToInbox(ICOutBoxTrans);
        CancelTrans(ICOutBoxTrans);
    end;

    var
        Text001: label 'Intercompany transactions from %1.';
        Text002: label 'Attached to this mail is an xml file containing one or more intercompany transactions from %1 (%2 %3).';
        Text003: label 'Do you want to complete line actions?';
        CompanyInfo: Record "Company Information";
        ICInboxOutboxMgt: Codeunit ICInboxOutboxMgt;
        FileMgt: Codeunit "File Management";

    local procedure SendToExternalPartner(var ICOutboxTrans: Record "IC Outbox Transaction")
    var
        ICPartner: Record "IC Partner";
        MailHandler: Codeunit Mail;
        ICOutboxExportXML: XmlPort "IC Outbox Imp/Exp";
        Ostr: OutStream;
        OFile: File;
        FileName: Text;
        ICPartnerFilter: Text[1024];
        i: Integer;
        ToName: Text[100];
        CcName: Text[100];
    begin
        ICPartner.SetFilter("Inbox Type",'<>%1',ICPartner."inbox type"::Database);
        ICPartnerFilter := ICOutboxTrans.GetFilter("IC Partner Code");
        if ICPartnerFilter <> '' then
          ICPartner.SetFilter(Code,ICPartnerFilter);
        if ICPartner.Find('-') then
          repeat
            ICOutboxTrans.SetRange("IC Partner Code",ICPartner.Code);
            if ICOutboxTrans.Find('-') then begin
              if ICPartner."Inbox Type" = ICPartner."inbox type"::"File Location" then begin
                ICPartner.TestField(Blocked,false);
                ICPartner.TestField("Inbox Details");
                i := 1;
                while i <> 0 do begin
                  FileName :=
                    StrSubstNo('%1\%2_%3_%4.xml',ICPartner."Inbox Details",ICPartner.Code,ICOutboxTrans."Transaction No.",i);
                  if Exists(FileName) then
                    i := i + 1
                  else
                    i := 0;
                end;
              end else begin
                OFile.CreateTempfile;
                FileName := StrSubstNo('%1.%2.xml',OFile.Name,ICPartner.Code);
                OFile.Close;
              end;
              OFile.Create(FileName);
              OFile.CreateOutstream(Ostr);
              ICOutboxExportXML.SetICOutboxTrans(ICOutboxTrans);
              ICOutboxExportXML.SetDestination(Ostr);
              ICOutboxExportXML.Export;
              OFile.Close;
              Clear(Ostr);
              Clear(ICOutboxExportXML);
              FileName := FileMgt.DownloadTempFile(FileName);
              if ICPartner."Inbox Type" = ICPartner."inbox type"::Email then begin
                ICPartner.TestField(Blocked,false);
                ICPartner.TestField("Inbox Details");
                ToName := ICPartner."Inbox Details";
                if StrPos(ToName,';') > 0 then begin
                  CcName := CopyStr(ToName,StrPos(ToName,';') + 1);
                  ToName := CopyStr(ToName,1,StrPos(ToName,';') - 1);
                  if StrPos(CcName,';') > 0 then
                    CcName := CopyStr(CcName,1,StrPos(CcName,';') - 1);
                end;
                MailHandler.NewMessage(
                  ToName,CcName,'',
                  StrSubstNo(Text001,CompanyInfo.Name),
                  StrSubstNo(
                    Text002,CompanyInfo.Name,CompanyInfo.FieldCaption("IC Partner Code"),CompanyInfo."IC Partner Code"),
                  FileName,false);
              end;
              ICOutboxTrans.Find('-');
              repeat
                ICInboxOutboxMgt.MoveOutboxTransToHandledOutbox(ICOutboxTrans);
              until ICOutboxTrans.Next = 0;
            end;
          until ICPartner.Next = 0;
        ICOutboxTrans.SetRange("IC Partner Code");
        if ICPartnerFilter <> '' then
          ICOutboxTrans.SetFilter("IC Partner Code",ICPartnerFilter);
    end;

    local procedure SendToInternalPartner(var ICOutboxTrans: Record "IC Outbox Transaction")
    var
        Company: Record Company;
        ICPartner: Record "IC Partner";
        MoveICTransToPartnerCompany: Report "Move IC Trans. to Partner Comp";
    begin
        if ICOutboxTrans.Find('-') then
          repeat
            ICPartner.Get(ICOutboxTrans."IC Partner Code");
            ICPartner.TestField(Blocked,false);
            if ICPartner."Inbox Type" = ICPartner."inbox type"::Database then begin
              ICPartner.TestField("Inbox Details");
              Company.Get(ICPartner."Inbox Details");
              ICOutboxTrans.SetRange("Transaction No.",ICOutboxTrans."Transaction No.");
              MoveICTransToPartnerCompany.SetTableview(ICOutboxTrans);
              MoveICTransToPartnerCompany.UseRequestPage := false;
              MoveICTransToPartnerCompany.Run;
              ICOutboxTrans.SetRange("Transaction No.");
              if ICOutboxTrans."Line Action" = ICOutboxTrans."line action"::"Send to IC Partner" then
                ICInboxOutboxMgt.MoveOutboxTransToHandledOutbox(ICOutboxTrans);
            end;
          until ICOutboxTrans.Next = 0;
    end;

    local procedure ReturnToInbox(var ICOutboxTrans: Record "IC Outbox Transaction")
    var
        ICPartner: Record "IC Partner";
        MoveICTransToPartnerCompany: Report "Move IC Trans. to Partner Comp";
    begin
        if ICOutboxTrans.Find('-') then
          repeat
            if ICPartner.Get(ICOutboxTrans."IC Partner Code") then
              ICPartner.TestField(Blocked,false);
            MoveICTransToPartnerCompany.RecreateInboxTrans(ICOutboxTrans);
            ICOutboxTrans.Delete(true);
          until ICOutboxTrans.Next = 0;
    end;

    local procedure CancelTrans(var ICOutboxTrans: Record "IC Outbox Transaction")
    begin
        ICOutboxTrans.SetRange("Line Action",ICOutboxTrans."line action"::Cancel);
        if ICOutboxTrans.Find('-') then
          repeat
            ICInboxOutboxMgt.MoveOutboxTransToHandledOutbox(ICOutboxTrans);
          until ICOutboxTrans.Next = 0;
    end;

    local procedure UpdateICStatus(var ICOutboxTransaction: Record "IC Outbox Transaction")
    var
        PurchHeader: Record "Purchase Header";
        SalesHeader: Record "Sales Header";
    begin
        if ICOutboxTransaction.FindSet then
          repeat
            if ICOutboxTransaction."Source Type" = ICOutboxTransaction."source type"::"Purchase Document" then
              case ICOutboxTransaction."Document Type" of
                ICOutboxTransaction."document type"::Order:
                  if PurchHeader.Get(PurchHeader."document type"::Order,ICOutboxTransaction."Document No.") then begin
                    PurchHeader.Validate("IC Status",PurchHeader."ic status"::Sent);
                    PurchHeader.Modify;
                  end;
                ICOutboxTransaction."document type"::"Return Order":
                  if PurchHeader.Get(PurchHeader."document type"::"Return Order",ICOutboxTransaction."Document No.") then begin
                    PurchHeader.Validate("IC Status",PurchHeader."ic status"::Sent);
                    PurchHeader.Modify;
                  end;
              end
            else
              if ICOutboxTransaction."Source Type" = ICOutboxTransaction."source type"::"Sales Document" then
                case ICOutboxTransaction."Document Type" of
                  ICOutboxTransaction."document type"::Order:
                    if SalesHeader.Get(SalesHeader."document type"::Order,ICOutboxTransaction."Document No.") then begin
                      SalesHeader.Validate("IC Status",SalesHeader."ic status"::Sent);
                      SalesHeader.Modify;
                    end;
                  ICOutboxTransaction."document type"::"Return Order":
                    if SalesHeader.Get(SalesHeader."document type"::"Return Order",ICOutboxTransaction."Document No.") then begin
                      SalesHeader.Validate("IC Status",SalesHeader."ic status"::Sent);
                      SalesHeader.Modify;
                    end;
                end;
          until ICOutboxTransaction.Next = 0
    end;
}

