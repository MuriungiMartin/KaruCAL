#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 6702 "O365 Contact Sync. Helper"
{

    trigger OnRun()
    begin
    end;

    var
        O365SyncManagement: Codeunit "O365 Sync. Management";
        CountryRegionNotFoundErr: label 'The Exchange Country/Region cannot be found in your company.';
        CreateExchangeContactTxt: label 'Create exchange contact.';
        CreateNavContactTxt: label 'Create contact. - %1', Comment='%1 = The contact';
        UniqueCompanyNameErr: label 'The Exchange Company Name is not unique in your company.';
        TransferExchangetoNavErr: label 'Failed to transfer the contact from Exchange to your company.';


    procedure GetO365Contacts(ExchangeSync: Record "Exchange Sync";var TempContact: Record Contact temporary)
    var
        ExchangeContact: Record "Exchange Contact";
        Counter: Integer;
    begin
        TempContact.Reset;
        TempContact.DeleteAll;

        ExchangeContact.SetFilter(EMailAddress1,'<>%1','');
        if ExchangeContact.FindSet then
          repeat
            Counter := Counter + 1;
            Clear(TempContact);
            TempContact.Init;
            TempContact."No." := StrSubstNo('%1',Counter);
            TempContact.Type := TempContact.Type::Person;

            if not TransferExchangeContactToNavContactNoValidate(ExchangeSync,ExchangeContact,TempContact) then
              LogFailure(ExchangeSync,TransferExchangetoNavErr,ExchangeContact.EMailAddress1)
            else
              TempContact.Insert; // Do not run the trigger so we preserve the dates.

          until (ExchangeContact.Next = 0);

        Clear(ExchangeContact);
    end;

    [TryFunction]

    procedure TransferExchangeContactToNavContact(var ExchangeContact: Record Contact;var NavContact: Record Contact;ExchangeSync: Record "Exchange Sync")
    begin
        NavContact.Type := NavContact.Type::Person;

        // Map the ExchangeContact.CompanyName to NavContact.CompanyNo if possible
        if not ValidateCompanyName(ExchangeContact,NavContact) then
          LogFailure(ExchangeSync,NavContact.FieldCaption("Company Name"),ExchangeContact."E-Mail");

        TransferContactNameInfo(ExchangeContact,NavContact,ExchangeSync);

        TransferCommonContactInfo(ExchangeContact,NavContact,ExchangeSync);
    end;

    [TryFunction]

    procedure TransferBookingContactToNavContact(var ExchangeContact: Record Contact;var NavContact: Record Contact)
    var
        ExchangeSync: Record "Exchange Sync";
    begin
        ExchangeSync.Get(UserId);

        // Map the ExchangeContact.CompanyName to NavContact.CompanyNo if possible
        if ExchangeContact."Company Name" <> '' then begin
          if not ValidateCompanyName(ExchangeContact,NavContact) then
            LogFailure(ExchangeSync,NavContact.FieldCaption("Company Name"),ExchangeContact."E-Mail");
        end else
          TransferContactNameInfo(ExchangeContact,NavContact,ExchangeSync);

        TransferCommonContactInfo(ExchangeContact,NavContact,ExchangeSync);
    end;


    procedure ProcessNavContactRecordSet(var Contact: Record Contact;var TempContact: Record Contact temporary;var ExchangeSync: Record "Exchange Sync")
    var
        ExchangeContact: Record "Exchange Contact";
        LocalExchangeContact: Record "Exchange Contact";
        found: Boolean;
    begin
        if Contact.FindSet then begin
          repeat
            found := false;
            TempContact.Reset;
            TempContact.SetRange("E-Mail",Contact."E-Mail");
            if TempContact.FindFirst then begin
              found := true;
              TempContact.Delete;
            end;

            Clear(ExchangeContact);
            ExchangeContact.Init;

            if not TransferNavContactToExchangeContact(Contact,ExchangeContact) then
              O365SyncManagement.LogActivityFailed(ExchangeSync.RecordId,ExchangeSync."User ID",
                CreateExchangeContactTxt,ExchangeContact.EMailAddress1)
            else
              if found then
                ExchangeContact.Modify
              else begin
                Clear(LocalExchangeContact);
                LocalExchangeContact.Init;
                LocalExchangeContact.SetFilter(EMailAddress1,'=%1',Contact."E-Mail");
                if LocalExchangeContact.FindFirst then
                  O365SyncManagement.LogActivityFailed(ExchangeSync.RecordId,ExchangeSync."User ID",
                    CreateExchangeContactTxt,ExchangeContact.EMailAddress1)
                else
                  ExchangeContact.Insert
              end;

          until Contact.Next = 0;
        end;
    end;

    [TryFunction]
    local procedure TransferExchangeContactToNavContactNoValidate(ExchangeSync: Record "Exchange Sync";var ExchangeContact: Record "Exchange Contact";var NavContact: Record Contact)
    var
        DateFilterCalc: Codeunit "DateFilter-Calc";
        ExchContDateTimeUtc: DateTime;
    begin
        if not SetFirstName(ExchangeContact,NavContact) then
          LogFailure(ExchangeSync,NavContact.FieldCaption("First Name"),ExchangeContact.EMailAddress1);

        if not SetMiddleName(ExchangeContact,NavContact) then
          LogFailure(ExchangeSync,NavContact.FieldCaption("Middle Name"),ExchangeContact.EMailAddress1);

        if not SetSurName(ExchangeContact,NavContact) then
          LogFailure(ExchangeSync,NavContact.FieldCaption(Surname),ExchangeContact.EMailAddress1);

        if not SetInitials(ExchangeContact,NavContact) then
          LogFailure(ExchangeSync,NavContact.FieldCaption(Initials),ExchangeContact.EMailAddress1);

        if not SetPostCode(ExchangeContact,NavContact) then
          LogFailure(ExchangeSync,NavContact.FieldCaption("Post Code"),ExchangeContact.EMailAddress1);

        if not SetEmail(ExchangeContact,NavContact) then
          LogFailure(ExchangeSync,NavContact.FieldCaption("E-Mail"),ExchangeContact.EMailAddress1);

        if not SetEmail2(ExchangeContact,NavContact) then
          LogFailure(ExchangeSync,NavContact.FieldCaption("E-Mail 2"),ExchangeContact.EMailAddress1);

        if not SetCompanyName(ExchangeContact,NavContact) then
          LogFailure(ExchangeSync,NavContact.FieldCaption("Company Name"),ExchangeContact.EMailAddress1);

        if not SetHomePage(ExchangeContact,NavContact) then
          LogFailure(ExchangeSync,NavContact.FieldCaption("Home Page"),ExchangeContact.EMailAddress1);

        if not SetPhoneNo(ExchangeContact,NavContact) then
          LogFailure(ExchangeSync,NavContact.FieldCaption("Phone No."),ExchangeContact.EMailAddress1);

        if not SetMobilePhoneNo(ExchangeContact,NavContact) then
          LogFailure(ExchangeSync,NavContact.FieldCaption("Mobile Phone No."),ExchangeContact.EMailAddress1);

        if not SetFaxNo(ExchangeContact,NavContact) then
          LogFailure(ExchangeSync,NavContact.FieldCaption("Fax No."),ExchangeContact.EMailAddress1);

        if not SetCity(ExchangeContact,NavContact) then
          LogFailure(ExchangeSync,NavContact.FieldCaption(City),ExchangeContact.EMailAddress1);

        if not SetCounty(ExchangeContact,NavContact) then
          LogFailure(ExchangeSync,NavContact.FieldCaption(County),ExchangeContact.EMailAddress1);

        if not SetNavContactAddresses(NavContact,ExchangeContact) then
          LogFailure(ExchangeSync,NavContact.FieldCaption(Address),ExchangeContact.EMailAddress1);

        ExchContDateTimeUtc := DateFilterCalc.ConvertToUtcDateTime(ExchangeContact.LastModifiedTime);
        NavContact."Last Date Modified" := Dt2Date(ExchContDateTimeUtc);
        NavContact."Last Time Modified" := Dt2Time(ExchContDateTimeUtc);

        // NOTE, we are using "Name 2" as the datatype is large enough to accomodate Exchange data type.
        if not SetRegion(ExchangeContact,NavContact) then
          LogFailure(ExchangeSync,NavContact.FieldCaption("Country/Region Code"),ExchangeContact.EMailAddress1);

        if not SetJobTitle(ExchangeContact,NavContact) then
          LogFailure(ExchangeSync,NavContact.FieldCaption("Job Title"),ExchangeContact.EMailAddress1);
    end;

    [TryFunction]

    procedure TransferNavContactToExchangeContact(var NavContact: Record Contact;var ExchangeContact: Record "Exchange Contact")
    begin
        ExchangeContact.Validate(EMailAddress1,NavContact."E-Mail");
        if NavContact.Type = NavContact.Type::Person then
          ExchangeContact.Validate(GivenName,NavContact."First Name");
        if NavContact.Type = NavContact.Type::Company then
          ExchangeContact.Validate(GivenName,CopyStr(NavContact."Company Name",1,30));
        ExchangeContact.Validate(MiddleName,NavContact."Middle Name");
        ExchangeContact.Validate(Surname,NavContact.Surname);
        ExchangeContact.Validate(Initials,NavContact.Initials);
        ExchangeContact.Validate(PostalCode,NavContact."Post Code");
        ExchangeContact.Validate(EMailAddress2,NavContact."E-Mail 2");
        ExchangeContact.Validate(CompanyName,NavContact."Company Name");
        ExchangeContact.Validate(BusinessHomePage,NavContact."Home Page");
        ExchangeContact.Validate(BusinessPhone1,NavContact."Phone No.");
        ExchangeContact.Validate(MobilePhone,NavContact."Mobile Phone No.");
        ExchangeContact.Validate(BusinessFax,NavContact."Fax No.");
        ValidateExchangeContactAddress(ExchangeContact,NavContact);
        ExchangeContact.Validate(City,NavContact.City);
        ExchangeContact.Validate(State,NavContact.County);
        ExchangeContact.Validate(Region,NavContact."Country/Region Code");
        ExchangeContact.Validate(JobTitle,NavContact."Job Title");
    end;

    [TryFunction]
    local procedure SetNavContactAddresses(var NavContact: Record Contact;var ExchangeContact: Record "Exchange Contact")
    var
        LineFeed: Char;
        LocalStreet: Text;
        LineFeedPos: Integer;
        CarriageReturn: Char;
        CarriageReturnPos: Integer;
    begin
        // Split ExchangeContact.Street into NavContact.Address and Address2.
        LineFeed := 10;
        CarriageReturn := 13;
        LocalStreet := ExchangeContact.Street;
        LineFeedPos := StrPos(LocalStreet,Format(LineFeed));
        CarriageReturnPos := StrPos(LocalStreet,Format(CarriageReturn));
        if LineFeedPos > 0 then begin
          if CarriageReturnPos = 0 then
            // Exchange has a bug when editing from OWA where the Carriage Return is ommitted.
            NavContact.Address := CopyStr(LocalStreet,1,LineFeedPos - 1)
          else
            NavContact.Address := CopyStr(LocalStreet,1,LineFeedPos - 2);
          LocalStreet := CopyStr(LocalStreet,LineFeedPos + 1);
          LineFeedPos := StrPos(LocalStreet,Format(LineFeed));
          CarriageReturnPos := StrPos(LocalStreet,Format(CarriageReturn));
          if LineFeedPos > 0 then begin
            if CarriageReturnPos = 0 then
              LocalStreet := CopyStr(LocalStreet,1,LineFeedPos - 1)
            else
              LocalStreet := CopyStr(LocalStreet,1,LineFeedPos - 2);
            NavContact."Address 2" := CopyStr(LocalStreet,1,StrLen(LocalStreet));
          end else
            NavContact."Address 2" := CopyStr(LocalStreet,1,StrLen(LocalStreet));
        end else
          NavContact.Address := CopyStr(LocalStreet,1,50);
    end;

    [TryFunction]
    local procedure SetFirstName(var ExchangeContact: Record "Exchange Contact";var NavContact: Record Contact)
    begin
        NavContact."First Name" := ExchangeContact.GivenName;
    end;

    [TryFunction]
    local procedure SetMiddleName(var ExchangeContact: Record "Exchange Contact";var NavContact: Record Contact)
    begin
        NavContact."Middle Name" := ExchangeContact.MiddleName;
    end;

    [TryFunction]
    local procedure SetSurName(var ExchangeContact: Record "Exchange Contact";var NavContact: Record Contact)
    begin
        NavContact.Surname := ExchangeContact.Surname;
    end;

    [TryFunction]
    local procedure SetInitials(var ExchangeContact: Record "Exchange Contact";var NavContact: Record Contact)
    begin
        NavContact.Initials := ExchangeContact.Initials;
    end;

    [TryFunction]
    local procedure SetPostCode(var ExchangeContact: Record "Exchange Contact";var NavContact: Record Contact)
    begin
        NavContact."Post Code" := ExchangeContact.PostalCode;
    end;

    [TryFunction]
    local procedure SetEmail(var ExchangeContact: Record "Exchange Contact";var NavContact: Record Contact)
    begin
        NavContact."E-Mail" := ExchangeContact.EMailAddress1;
    end;

    [TryFunction]
    local procedure SetEmail2(var ExchangeContact: Record "Exchange Contact";var NavContact: Record Contact)
    begin
        NavContact."E-Mail 2" := ExchangeContact.EMailAddress2;
    end;

    [TryFunction]
    local procedure SetCompanyName(var ExchangeContact: Record "Exchange Contact";var NavContact: Record Contact)
    begin
        NavContact."Company Name" := ExchangeContact.CompanyName;
    end;

    [TryFunction]
    local procedure SetHomePage(var ExchangeContact: Record "Exchange Contact";var NavContact: Record Contact)
    begin
        NavContact."Home Page" := ExchangeContact.BusinessHomePage;
    end;

    [TryFunction]
    local procedure SetPhoneNo(var ExchangeContact: Record "Exchange Contact";var NavContact: Record Contact)
    begin
        NavContact."Phone No." := ExchangeContact.BusinessPhone1;
    end;

    [TryFunction]
    local procedure SetMobilePhoneNo(var ExchangeContact: Record "Exchange Contact";var NavContact: Record Contact)
    begin
        NavContact."Mobile Phone No." := ExchangeContact.MobilePhone;
    end;

    [TryFunction]
    local procedure SetFaxNo(var ExchangeContact: Record "Exchange Contact";var NavContact: Record Contact)
    begin
        NavContact."Fax No." := ExchangeContact.BusinessFax;
    end;

    [TryFunction]
    local procedure SetCity(var ExchangeContact: Record "Exchange Contact";var NavContact: Record Contact)
    begin
        NavContact.City := ExchangeContact.City;
    end;

    [TryFunction]
    local procedure SetCounty(var ExchangeContact: Record "Exchange Contact";var NavContact: Record Contact)
    begin
        NavContact.County := ExchangeContact.State;
    end;

    [TryFunction]
    local procedure SetRegion(var ExchangeContact: Record "Exchange Contact";var NavContact: Record Contact)
    begin
        NavContact."Name 2" := ExchangeContact.Region;
    end;

    [TryFunction]
    local procedure SetJobTitle(var ExchangeContact: Record "Exchange Contact";var NavContact: Record Contact)
    begin
        NavContact."Job Title" := ExchangeContact.JobTitle;
    end;

    [TryFunction]
    local procedure ValidateCompanyName(ExchangeContact: Record Contact;var NavContact: Record Contact)
    var
        LocalContact: Record Contact;
    begin
        // Map Exchange.CompanyName to NavContact.Company.No
        if ExchangeContact."Company Name" <> '' then begin
          LocalContact.SetRange("Company Name",ExchangeContact."Company Name");
          LocalContact.SetRange(Type,LocalContact.Type::Company);
          if LocalContact.Count <> 1 then
            Error(UniqueCompanyNameErr);

          if LocalContact.FindFirst then
            if LocalContact."Company Name" <> NavContact."Company Name" then
              NavContact.Validate("Company No.",LocalContact."No.");
        end;
    end;

    [TryFunction]
    local procedure ValidateCountryRegion(ExchangeContact: Record Contact;var NavContact: Record Contact)
    var
        LocalCountryRegion: Record "Country/Region";
    begin
        // Map Exchange.Region to NavContact."Country/Region Code"
        // NOTE, we are using "Name 2" as the datatype is large enough to accomodate Exchange data type.
        if ExchangeContact."Name 2" <> '' then
          if StrLen(ExchangeContact."Name 2") <= 10 then
            if LocalCountryRegion.Get(ExchangeContact."Name 2") then
              NavContact.Validate("Country/Region Code",CopyStr(ExchangeContact."Name 2",1,10))
            else
              ValidateCountryRegionByName(ExchangeContact."Name 2",NavContact)
          else
            ValidateCountryRegionByName(ExchangeContact."Name 2",NavContact);
    end;

    local procedure ValidateCountryRegionByName(Country: Text[50];var NavContact: Record Contact)
    var
        LocalCountryRegion: Record "Country/Region";
    begin
        LocalCountryRegion.SetRange(Name,Country);
        if LocalCountryRegion.FindFirst then
          NavContact.Validate("Country/Region Code",LocalCountryRegion.Code)
        else
          Error(CountryRegionNotFoundErr);
    end;

    local procedure ValidateExchangeContactAddress(var ExchangeContact: Record "Exchange Contact";var NavContact: Record Contact)
    var
        CrLf: Text[2];
        LocalStreet: Text;
    begin
        // Concatenate NavContact.Address & Address2 into ExchangeContact.Street
        CrLf[1] := 13;
        CrLf[2] := 10;
        LocalStreet := NavContact.Address + CrLf + NavContact."Address 2" + CrLf;
        ExchangeContact.Validate(Street,CopyStr(LocalStreet,1,104));
    end;

    [TryFunction]
    local procedure ValidateFirstName(ExchangeContact: Record Contact;var NavContact: Record Contact)
    begin
        NavContact.Validate("First Name",ExchangeContact."First Name");
    end;

    [TryFunction]
    local procedure ValidateMiddleName(ExchangeContact: Record Contact;var NavContact: Record Contact)
    begin
        NavContact.Validate("Middle Name",ExchangeContact."Middle Name");
    end;

    [TryFunction]
    local procedure ValidateSurname(ExchangeContact: Record Contact;var NavContact: Record Contact)
    begin
        NavContact.Validate(Surname,ExchangeContact.Surname);
    end;

    [TryFunction]
    local procedure ValidateInitials(ExchangeContact: Record Contact;var NavContact: Record Contact)
    begin
        NavContact.Validate(Initials,ExchangeContact.Initials);
    end;

    [TryFunction]
    local procedure ValidateEmail(ExchangeContact: Record Contact;var NavContact: Record Contact)
    begin
        NavContact.Validate("E-Mail",ExchangeContact."E-Mail");
    end;

    [TryFunction]
    local procedure ValidateEmail2(ExchangeContact: Record Contact;var NavContact: Record Contact)
    begin
        NavContact.Validate("E-Mail 2",ExchangeContact."E-Mail 2");
    end;

    [TryFunction]
    local procedure ValidateHomePage(ExchangeContact: Record Contact;var NavContact: Record Contact)
    begin
        NavContact.Validate("Home Page",ExchangeContact."Home Page");
    end;

    [TryFunction]
    local procedure ValidatePhoneNo(ExchangeContact: Record Contact;var NavContact: Record Contact)
    begin
        NavContact.Validate("Phone No.",ExchangeContact."Phone No.");
    end;

    [TryFunction]
    local procedure ValidateMobilePhoneNo(ExchangeContact: Record Contact;var NavContact: Record Contact)
    begin
        NavContact.Validate("Mobile Phone No.",ExchangeContact."Mobile Phone No.");
    end;

    [TryFunction]
    local procedure ValidateFaxNo(ExchangeContact: Record Contact;var NavContact: Record Contact)
    begin
        NavContact.Validate("Fax No.",ExchangeContact."Fax No.");
    end;

    [TryFunction]
    local procedure ValidateAddress(ExchangeContact: Record Contact;var NavContact: Record Contact)
    begin
        NavContact.Validate(Address,ExchangeContact.Address);
    end;

    [TryFunction]
    local procedure ValidateAddress2(ExchangeContact: Record Contact;var NavContact: Record Contact)
    begin
        NavContact.Validate("Address 2",ExchangeContact."Address 2");
    end;

    [TryFunction]
    local procedure ValidateCity(ExchangeContact: Record Contact;var NavContact: Record Contact)
    begin
        NavContact.Validate(City,ExchangeContact.City);
    end;

    [TryFunction]
    local procedure ValidatePostCode(ExchangeContact: Record Contact;var NavContact: Record Contact)
    begin
        NavContact.Validate("Post Code",ExchangeContact."Post Code");
    end;

    [TryFunction]
    local procedure ValidateCounty(ExchangeContact: Record Contact;var NavContact: Record Contact)
    begin
        NavContact.Validate(County,ExchangeContact.County);
    end;

    [TryFunction]
    local procedure ValidateJobTitle(ExchangeContact: Record Contact;var NavContact: Record Contact)
    begin
        NavContact.Validate("Job Title",ExchangeContact."Job Title");
    end;

    [TryFunction]
    local procedure TransferContactNameInfo(var ExchangeContact: Record Contact;var NavContact: Record Contact;ExchangeSync: Record "Exchange Sync")
    begin
        if not ValidateFirstName(ExchangeContact,NavContact) then
          LogFailure(ExchangeSync,NavContact.FieldCaption("First Name"),ExchangeContact."E-Mail");

        if not ValidateMiddleName(ExchangeContact,NavContact) then
          LogFailure(ExchangeSync,NavContact.FieldCaption("Middle Name"),ExchangeContact."E-Mail");

        if not ValidateSurname(ExchangeContact,NavContact) then
          LogFailure(ExchangeSync,NavContact.FieldCaption(Surname),ExchangeContact."E-Mail");

        if not ValidateInitials(ExchangeContact,NavContact) then
          LogFailure(ExchangeSync,NavContact.FieldCaption(Initials),ExchangeContact."E-Mail");
    end;

    [TryFunction]
    local procedure TransferCommonContactInfo(var ExchangeContact: Record Contact;var NavContact: Record Contact;ExchangeSync: Record "Exchange Sync")
    begin
        if not ValidateEmail(ExchangeContact,NavContact) then
          LogFailure(ExchangeSync,NavContact.FieldCaption("E-Mail"),ExchangeContact."E-Mail");

        if not ValidateEmail2(ExchangeContact,NavContact) then
          LogFailure(ExchangeSync,NavContact.FieldCaption("E-Mail 2"),ExchangeContact."E-Mail");

        if not ValidateHomePage(ExchangeContact,NavContact) then
          LogFailure(ExchangeSync,NavContact.FieldCaption("Home Page"),ExchangeContact."E-Mail");

        if not ValidatePhoneNo(ExchangeContact,NavContact) then
          LogFailure(ExchangeSync,NavContact.FieldCaption("Phone No."),ExchangeContact."E-Mail");

        if not ValidateMobilePhoneNo(ExchangeContact,NavContact) then
          LogFailure(ExchangeSync,NavContact.FieldCaption("Mobile Phone No."),ExchangeContact."E-Mail");

        if not ValidateFaxNo(ExchangeContact,NavContact) then
          LogFailure(ExchangeSync,NavContact.FieldCaption("Fax No."),ExchangeContact."E-Mail");

        if not ValidateAddress(ExchangeContact,NavContact) then
          LogFailure(ExchangeSync,NavContact.FieldCaption(Address),ExchangeContact."E-Mail");

        if not ValidateAddress2(ExchangeContact,NavContact) then
          LogFailure(ExchangeSync,NavContact.FieldCaption("Address 2"),ExchangeContact."E-Mail");

        if not ValidateCity(ExchangeContact,NavContact) then
          LogFailure(ExchangeSync,NavContact.FieldCaption(City),ExchangeContact."E-Mail");

        if not ValidatePostCode(ExchangeContact,NavContact) then
          LogFailure(ExchangeSync,NavContact.FieldCaption("Post Code"),ExchangeContact."E-Mail");

        if not ValidateCounty(ExchangeContact,NavContact) then
          LogFailure(ExchangeSync,NavContact.FieldCaption(County),ExchangeContact."E-Mail");

        NavContact.Validate("Last Date Modified",ExchangeContact."Last Date Modified");
        NavContact.Validate("Last Time Modified",ExchangeContact."Last Time Modified");

        if not ValidateCountryRegion(ExchangeContact,NavContact) then
          LogFailure(ExchangeSync,NavContact.FieldCaption("Country/Region Code"),ExchangeContact."E-Mail");

        if not ValidateJobTitle(ExchangeContact,NavContact) then
          LogFailure(ExchangeSync,NavContact.FieldCaption("Job Title"),ExchangeContact."E-Mail");
    end;

    local procedure LogFailure(ExchangeSync: Record "Exchange Sync";FieldCaption: Text;Identifier: Text)
    var
        Message: Text;
    begin
        Message := StrSubstNo(CreateNavContactTxt,FieldCaption);
        O365SyncManagement.LogActivityFailed(ExchangeSync.RecordId,ExchangeSync."User ID",Message,Identifier);
    end;
}

