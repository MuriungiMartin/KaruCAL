#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 6704 "Booking Customer Sync."
{

    trigger OnRun()
    var
        LocalBookingSync: Record "Booking Sync";
    begin
        LocalBookingSync.SetRange("Sync Customers",true);
        LocalBookingSync.SetRange(Enabled,true);
        if LocalBookingSync.FindFirst then
          if not TrySync(LocalBookingSync) then
            O365SyncManagement.LogActivityFailed(LocalBookingSync.RecordId,LocalBookingSync."User ID",SyncFailureTxt,GetLastErrorText);
    end;

    var
        TempContact: Record Contact temporary;
        O365SyncManagement: Codeunit "O365 Sync. Management";
        O365ContactSyncHelper: Codeunit "O365 Contact Sync. Helper";
        SyncFailureTxt: label 'Failed to synchronize Booking customers.';
        ProcessExchangeContactsMsg: label 'Processing contacts from Exchange.';
        ProcessNavContactsMsg: label 'Processing contacts in your company.';
        CreateNavContactTxt: label 'Create contact in your company.';

    [TryFunction]
    local procedure TrySync(LocalBookingSync: Record "Booking Sync")
    begin
        O365SyncManagement.SyncBookingCustomers(LocalBookingSync);
    end;


    procedure GetRequestParameters(var BookingSync: Record "Booking Sync"): Text
    var
        LocalCustomer: Record Customer;
        FilterPage: FilterPageBuilder;
        FilterText: Text;
        CustomerTxt: Text;
    begin
        FilterText := BookingSync.GetCustomerFilter;

        CustomerTxt := LocalCustomer.TableCaption;
        FilterPage.PageCaption := CustomerTxt;
        FilterPage.AddTable(CustomerTxt,Database::Customer);

        if FilterText <> '' then
          FilterPage.SetView(CustomerTxt,FilterText);

        FilterPage.AddField(CustomerTxt,LocalCustomer.City);
        FilterPage.AddField(CustomerTxt,LocalCustomer.County);
        FilterPage.AddField(CustomerTxt,LocalCustomer."Post Code");
        FilterPage.AddField(CustomerTxt,LocalCustomer."Country/Region Code");
        FilterPage.AddField(CustomerTxt,LocalCustomer."Salesperson Code");
        FilterPage.AddField(CustomerTxt,LocalCustomer."Currency Code");

        if FilterPage.RunModal then
          FilterText := FilterPage.GetView(CustomerTxt);

        if FilterText <> '' then begin
          BookingSync.SaveCustomerFilter(FilterText);
          BookingSync.Modify(true);
        end;

        exit(FilterText);
    end;


    procedure SyncRecords(var BookingSync: Record "Booking Sync")
    var
        ExchangeSync: Record "Exchange Sync";
    begin
        ExchangeSync.Get(UserId);
        O365ContactSyncHelper.GetO365Contacts(ExchangeSync,TempContact);

        O365SyncManagement.ShowProgress(ProcessNavContactsMsg);
        ProcessNavContacts(BookingSync);

        O365SyncManagement.ShowProgress(ProcessExchangeContactsMsg);
        ProcessExchangeContacts(BookingSync);

        O365SyncManagement.CloseProgress;
        BookingSync."Last Customer Sync" := CreateDatetime(Today,Time);
        BookingSync.Modify(true);
    end;

    local procedure ProcessExchangeContacts(var BookingSync: Record "Booking Sync")
    begin
        TempContact.Reset;
        TempContact.SetLastDateTimeFilter(BookingSync."Last Customer Sync");

        ProcessExchangeContactRecordSet(TempContact,BookingSync);
    end;

    local procedure ProcessExchangeContactRecordSet(var LocalContact: Record Contact;BookingSync: Record "Booking Sync")
    var
        ContactBusinessRelation: Record "Contact Business Relation";
        ExchangeSync: Record "Exchange Sync";
        Contact: Record Contact;
        CompanyContact: Record Contact;
        CompanyFound: Boolean;
        ContactNo: Text;
    begin
        ExchangeSync.Get(UserId);

        if LocalContact.FindSet then begin
          repeat
            CompanyFound := false;
            ContactNo := '';
            Contact.Reset;
            Clear(Contact);
            Contact.SetRange("Search E-Mail",UpperCase(LocalContact."E-Mail"));
            if Contact.FindFirst then begin
              ContactNo := Contact."No.";
              if Contact.Type = Contact.Type::Company then
                CompanyFound := true;
            end;

            if not O365ContactSyncHelper.TransferBookingContactToNavContact(LocalContact,Contact) then
              O365SyncManagement.LogActivityFailed(ExchangeSync.RecordId,ExchangeSync."User ID",CreateNavContactTxt,LocalContact."E-Mail")
            else
              if not CompanyFound and (ContactNo <> '') then begin
                Contact."No." := CopyStr(ContactNo,1,20);
                Contact.Modify(true);
                if Contact."Company No." = '' then begin
                  Contact.Validate(Type,Contact.Type::Company);
                  Contact.TypeChange;
                  Contact.Modify;
                  Contact.SetHideValidationDialog(true);
                  Contact.CreateCustomer(BookingSync."Customer Template Code");
                end else begin
                  CompanyContact.SetRange("No.",Contact."Company No.");
                  if CompanyContact.FindFirst then begin
                    ContactBusinessRelation.SetRange("Contact No.",CompanyContact."Company No.");
                    if not ContactBusinessRelation.FindFirst then begin
                      CompanyContact.SetHideValidationDialog(true);
                      CompanyContact.CreateCustomer(BookingSync."Customer Template Code");
                      CompanyContact.Modify(true);
                    end;
                  end;
                end;
              end else
                if CompanyFound then begin
                  Contact."No." := CopyStr(ContactNo,1,20);
                  Contact.Modify(true);
                  ContactBusinessRelation.SetRange("Contact No.",Contact."Company No.");
                  if not ContactBusinessRelation.FindFirst then begin
                    Contact.SetHideValidationDialog(true);
                    Contact.CreateCustomer(BookingSync."Customer Template Code");
                    Contact.Modify(true);
                  end;
                end else begin
                  Contact."No." := '';
                  Contact.Validate(Type,Contact.Type::Company);
                  Contact.Insert(true);
                  Contact.SetHideValidationDialog(true);
                  Contact.CreateCustomer(BookingSync."Customer Template Code");
                end;

          until (LocalContact.Next = 0)
        end;
    end;

    local procedure ProcessNavContacts(BookingSync: Record "Booking Sync")
    var
        Contact: Record Contact;
    begin
        BuildNavContactFilter(Contact,BookingSync);
        Contact.SetLastDateTimeFilter(BookingSync."Last Customer Sync");

        ProcessNavContactRecordSet(Contact);
    end;

    local procedure ProcessNavContactRecordSet(var Contact: Record Contact)
    var
        ExchangeSync: Record "Exchange Sync";
        O365ContactSyncHelper: Codeunit "O365 Contact Sync. Helper";
    begin
        ExchangeSync.Get(UserId);
        O365ContactSyncHelper.ProcessNavContactRecordSet(Contact,TempContact,ExchangeSync);
    end;

    local procedure BuildNavContactFilter(var Contact: Record Contact;var BookingSync: Record "Booking Sync")
    var
        Customer: Record Customer;
        ContactBusinessRelation: Record "Contact Business Relation";
        CompanyFilter: Text;
        CustomerFilter: Text;
    begin
        Customer.SetView(BookingSync.GetCustomerFilter);

        if Customer.FindSet then
          repeat
            CustomerFilter += Customer."No." + '|';
          until Customer.Next = 0;
        CustomerFilter := DelChr(CustomerFilter,'>','|');

        ContactBusinessRelation.SetRange("Link to Table",ContactBusinessRelation."link to table"::Customer);
        ContactBusinessRelation.SetFilter("No.",CustomerFilter);
        if ContactBusinessRelation.FindSet then
          repeat
            CompanyFilter += ContactBusinessRelation."Contact No." + '|';
          until ContactBusinessRelation.Next = 0;

        CompanyFilter := DelChr(CompanyFilter,'>','|');
        Contact.SetFilter("Company No.",CompanyFilter);
        Contact.SetFilter("E-Mail",'<>%1','');
        Contact.SetRange(Type,Contact.Type::Company);
    end;
}

