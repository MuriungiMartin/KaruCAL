#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 249 "VAT Registration Log Mgt."
{
    Permissions = TableData "VAT Registration Log"=rimd;

    trigger OnRun()
    begin
    end;

    var
        ValidPathTxt: label 'descendant::vat:valid', Locked=true;
        NamePathTxt: label 'descendant::vat:name', Locked=true;
        AddressPathTxt: label 'descendant::vat:address', Locked=true;


    procedure LogCustomer(Customer: Record Customer)
    var
        VATRegistrationLog: Record "VAT Registration Log";
        CountryCode: Code[10];
    begin
        CountryCode := GetCountryCode(Customer."Country/Region Code");
        if not IsEUCountry(CountryCode) then
          exit;

        InsertVATRegistrationLog(
          Customer."VAT Registration No.",CountryCode,VATRegistrationLog."account type"::Customer,Customer."No.");
    end;


    procedure LogVendor(Vendor: Record Vendor)
    var
        VATRegistrationLog: Record "VAT Registration Log";
        CountryCode: Code[10];
    begin
        CountryCode := GetCountryCode(Vendor."Country/Region Code");
        if not IsEUCountry(CountryCode) then
          exit;

        InsertVATRegistrationLog(
          Vendor."VAT Registration No.",CountryCode,VATRegistrationLog."account type"::Vendor,Vendor."No.");
    end;


    procedure LogContact(Contact: Record Contact)
    var
        VATRegistrationLog: Record "VAT Registration Log";
        CountryCode: Code[10];
    begin
        CountryCode := GetCountryCode(Contact."Country/Region Code");
        if not IsEUCountry(CountryCode) then
          exit;

        InsertVATRegistrationLog(
          Contact."VAT Registration No.",CountryCode,VATRegistrationLog."account type"::Contact,Contact."No.");
    end;


    procedure LogVerification(var VATRegistrationLog: Record "VAT Registration Log";XMLDoc: dotnet XmlDocument;Namespace: Text)
    var
        XMLDOMMgt: Codeunit "XML DOM Management";
        FoundXmlNode: dotnet XmlNode;
    begin
        if not XMLDOMMgt.FindNodeWithNamespace(XMLDoc.DocumentElement,ValidPathTxt,'vat',Namespace,FoundXmlNode) then
          exit;

        case Lowercase(FoundXmlNode.InnerText) of
          'true':
            begin
              VATRegistrationLog."Entry No." := 0;
              VATRegistrationLog.Status := VATRegistrationLog.Status::Valid;
              VATRegistrationLog."Verified Date" := CurrentDatetime;
              VATRegistrationLog."User ID" := UserId;

              XMLDOMMgt.FindNodeWithNamespace(XMLDoc.DocumentElement,NamePathTxt,'vat',Namespace,FoundXmlNode);
              VATRegistrationLog."Verified Name" :=
                CopyStr(FoundXmlNode.InnerText,1,MaxStrLen(VATRegistrationLog."Verified Name"));
              XMLDOMMgt.FindNodeWithNamespace(XMLDoc.DocumentElement,AddressPathTxt,'vat',Namespace,FoundXmlNode);
              VATRegistrationLog."Verified Address" :=
                CopyStr(FoundXmlNode.InnerText,1,MaxStrLen(VATRegistrationLog."Verified Address"));

              VATRegistrationLog.Insert(true);
            end;
          'false':
            begin
              VATRegistrationLog."Entry No." := 0;
              VATRegistrationLog."Verified Date" := CurrentDatetime;
              VATRegistrationLog.Status := VATRegistrationLog.Status::Invalid;
              VATRegistrationLog."User ID" := UserId;
              VATRegistrationLog."Verified Name" := '';
              VATRegistrationLog."Verified Address" := '';

              VATRegistrationLog.Insert(true);
            end;
        end;
    end;

    local procedure LogUnloggedVATRegistrationNumbers()
    var
        Customer: Record Customer;
        Vendor: Record Vendor;
        Contact: Record Contact;
        VATRegistrationLog: Record "VAT Registration Log";
    begin
        Customer.SetFilter("VAT Registration No.",'<>%1','');
        if Customer.FindSet then
          repeat
            VATRegistrationLog.SetRange("VAT Registration No.",Customer."VAT Registration No.");
            if VATRegistrationLog.IsEmpty then
              LogCustomer(Customer);
          until Customer.Next = 0;

        Vendor.SetFilter("VAT Registration No.",'<>%1','');
        if Vendor.FindSet then
          repeat
            VATRegistrationLog.SetRange("VAT Registration No.",Vendor."VAT Registration No.");
            if VATRegistrationLog.IsEmpty then
              LogVendor(Vendor);
          until Vendor.Next = 0;

        Contact.SetFilter("VAT Registration No.",'<>%1','');
        if Contact.FindSet then
          repeat
            VATRegistrationLog.SetRange("VAT Registration No.",Contact."VAT Registration No.");
            if VATRegistrationLog.IsEmpty then
              LogContact(Contact);
          until Contact.Next = 0;

        Commit;
    end;

    local procedure InsertVATRegistrationLog(VATRegNo: Text[20];CountryCode: Code[10];AccountType: Option;AccountNo: Code[20])
    var
        VATRegistrationLog: Record "VAT Registration Log";
    begin
        with VATRegistrationLog do begin
          Init;
          "VAT Registration No." := VATRegNo;
          "Country/Region Code" := CountryCode;
          "Account Type" := AccountType;
          "Account No." := AccountNo;
          "User ID" := UserId;
          Insert(true);
        end;
    end;


    procedure DeleteCustomerLog(Customer: Record Customer)
    var
        VATRegistrationLog: Record "VAT Registration Log";
    begin
        with VATRegistrationLog do begin
          SetRange("Account Type","account type"::Customer);
          SetRange("Account No.",Customer."No.");
          DeleteAll;
        end;
    end;


    procedure DeleteVendorLog(Vendor: Record Vendor)
    var
        VATRegistrationLog: Record "VAT Registration Log";
    begin
        with VATRegistrationLog do begin
          SetRange("Account Type","account type"::Vendor);
          SetRange("Account No.",Vendor."No.");
          DeleteAll;
        end;
    end;


    procedure DeleteContactLog(Contact: Record Contact)
    var
        VATRegistrationLog: Record "VAT Registration Log";
    begin
        with VATRegistrationLog do begin
          SetRange("Account Type","account type"::Contact);
          SetRange("Account No.",Contact."No.");
          DeleteAll;
        end;
    end;


    procedure AssistEditCustomerVATReg(Customer: Record Customer)
    var
        VATRegistrationLog: Record "VAT Registration Log";
    begin
        with VATRegistrationLog do begin
          if IsEmpty then
            LogUnloggedVATRegistrationNumbers;
          SetRange("Account Type","account type"::Customer);
          SetRange("Account No.",Customer."No.");
          Page.RunModal(Page::"VAT Registration Log",VATRegistrationLog);
        end;
    end;


    procedure AssistEditVendorVATReg(Vendor: Record Vendor)
    var
        VATRegistrationLog: Record "VAT Registration Log";
    begin
        with VATRegistrationLog do begin
          if IsEmpty then
            LogUnloggedVATRegistrationNumbers;
          SetRange("Account Type","account type"::Vendor);
          SetRange("Account No.",Vendor."No.");
          Page.RunModal(Page::"VAT Registration Log",VATRegistrationLog);
        end;
    end;


    procedure AssistEditContactVATReg(Contact: Record Contact)
    var
        VATRegistrationLog: Record "VAT Registration Log";
    begin
        with VATRegistrationLog do begin
          if IsEmpty then
            LogUnloggedVATRegistrationNumbers;
          SetRange("Account Type","account type"::Contact);
          SetRange("Account No.",Contact."No.");
          Page.RunModal(Page::"VAT Registration Log",VATRegistrationLog);
        end;
    end;

    local procedure IsEUCountry(CountryCode: Code[10]): Boolean
    var
        CountryRegion: Record "Country/Region";
    begin
        if CountryCode <> '' then
          if CountryRegion.Get(CountryCode) then
            exit(CountryRegion."EU Country/Region Code" <> '');

        exit(false);
    end;

    local procedure GetCountryCode(CountryCode: Code[10]): Code[10]
    var
        CompanyInformation: Record "Company Information";
    begin
        if CountryCode <> '' then
          exit(CountryCode);

        CompanyInformation.Get;
        exit(CompanyInformation."Country/Region Code");
    end;
}

