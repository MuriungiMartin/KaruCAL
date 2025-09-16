#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 6703 "Exchange Contact Sync."
{

    trigger OnRun()
    var
        LocalExchangeSync: Record "Exchange Sync";
    begin
        LocalExchangeSync.SetRange(Enabled,true);
        if LocalExchangeSync.FindSet then
          repeat
            if not TrySync(LocalExchangeSync) then
              with O365SyncManagement do
                LogActivityFailed(LocalExchangeSync.RecordId,LocalExchangeSync."User ID",JobFailureTxt,GetLastErrorText);
          until LocalExchangeSync.Next = 0;
    end;

    var
        TempContact: Record Contact temporary;
        O365SyncManagement: Codeunit "O365 Sync. Management";
        O365ContactSyncHelper: Codeunit "O365 Contact Sync. Helper";
        SkipDateFilters: Boolean;
        JobFailureTxt: label 'Failed to synchronize contact records.';
        CreateNavContactTxt: label 'Create contact in your company.';
        ProcessExchangeContactsMsg: label 'Processing contacts from Exchange.';
        ProcessNavContactsMsg: label 'Processing contacts in your company.';

    [TryFunction]
    local procedure TrySync(LocalExchangeSync: Record "Exchange Sync")
    begin
        O365SyncManagement.SyncExchangeContacts(LocalExchangeSync,false);
    end;


    procedure GetRequestParameters(var ExchangeSync: Record "Exchange Sync"): Text
    var
        LocalContact: Record Contact;
        FilterPage: FilterPageBuilder;
        FilterText: Text;
        ContactTxt: Text;
    begin
        FilterText := ExchangeSync.GetSavedFilter;

        ContactTxt := LocalContact.TableCaption;
        FilterPage.PageCaption := ContactTxt;
        FilterPage.AddTable(ContactTxt,Database::Contact);

        if FilterText <> '' then
          FilterPage.SetView(ContactTxt,FilterText);

        FilterPage.AddField(ContactTxt,LocalContact."Territory Code");
        FilterPage.AddField(ContactTxt,LocalContact."Company No.");
        FilterPage.AddField(ContactTxt,LocalContact."Salesperson Code");
        FilterPage.AddField(ContactTxt,LocalContact.City);
        FilterPage.AddField(ContactTxt,LocalContact.County);
        FilterPage.AddField(ContactTxt,LocalContact."Post Code");
        FilterPage.AddField(ContactTxt,LocalContact."Country/Region Code");

        if FilterPage.RunModal then
          FilterText := FilterPage.GetView(ContactTxt);

        if FilterText <> '' then begin
          ExchangeSync.SaveFilter(FilterText);
          ExchangeSync.Modify(true);
        end;

        exit(FilterText);
    end;


    procedure GetRequestParametersFullSync(var ExchangeSync: Record "Exchange Sync")
    begin
        SkipDateFilters := true;

        GetRequestParameters(ExchangeSync);
    end;


    procedure SyncRecords(var ExchangeSync: Record "Exchange Sync";FullSync: Boolean)
    begin
        SkipDateFilters := FullSync;
        O365ContactSyncHelper.GetO365Contacts(ExchangeSync,TempContact);

        O365SyncManagement.ShowProgress(ProcessNavContactsMsg);
        ProcessNavContacts(ExchangeSync,TempContact,SkipDateFilters);

        O365SyncManagement.ShowProgress(ProcessExchangeContactsMsg);
        ProcessExchangeContacts(ExchangeSync,TempContact,SkipDateFilters);

        O365SyncManagement.CloseProgress;
        ExchangeSync."Last Sync Date Time" := CreateDatetime(Today,Time);
        ExchangeSync.Modify(true);
    end;

    local procedure ProcessExchangeContacts(var ExchangeSync: Record "Exchange Sync";var TempContact: Record Contact temporary;SkipDateFilters: Boolean)
    begin
        TempContact.Reset;
        if not SkipDateFilters then
          TempContact.SetLastDateTimeFilter(ExchangeSync."Last Sync Date Time");

        ProcessExchangeContactRecordSet(TempContact,ExchangeSync);
    end;

    local procedure ProcessExchangeContactRecordSet(var LocalContact: Record Contact;var ExchangeSync: Record "Exchange Sync")
    var
        Contact: Record Contact;
        found: Boolean;
        ContactNo: Text;
    begin
        if LocalContact.FindSet then
          repeat
            found := false;
            ContactNo := '';
            Contact.Reset;
            Clear(Contact);
            Contact.SetRange("Search E-Mail",UpperCase(LocalContact."E-Mail"));
            if Contact.FindFirst then begin
              found := true;
              ContactNo := Contact."No.";
            end;

            if not O365ContactSyncHelper.TransferExchangeContactToNavContact(LocalContact,Contact,ExchangeSync) then
              O365SyncManagement.LogActivityFailed(ExchangeSync.RecordId,ExchangeSync."User ID",
                CreateNavContactTxt,LocalContact."E-Mail")
            else
              if found then begin
                Contact."No." := CopyStr(ContactNo,1,20);
                Contact.Modify(true);
              end else begin
                Contact."No." := '';
                Contact.Insert(true);
              end;
          until (LocalContact.Next = 0)
    end;

    local procedure ProcessNavContacts(var ExchangeSync: Record "Exchange Sync";var TempContact: Record Contact temporary;SkipDateFilters: Boolean)
    var
        Contact: Record Contact;
    begin
        SetContactFilter(Contact,ExchangeSync);
        if not SkipDateFilters then
          Contact.SetLastDateTimeFilter(ExchangeSync."Last Sync Date Time");

        O365ContactSyncHelper.ProcessNavContactRecordSet(Contact,TempContact,ExchangeSync);
    end;

    local procedure SetContactFilter(var Contact: Record Contact;var ExchangeSync: Record "Exchange Sync")
    begin
        Contact.SetView(ExchangeSync.GetSavedFilter);
        Contact.SetRange(Type,Contact.Type::Person);
        Contact.SetFilter("E-Mail",'<>%1','');
    end;
}

