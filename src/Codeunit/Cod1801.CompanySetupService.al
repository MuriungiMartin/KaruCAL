#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1801 "Company Setup Service"
{

    trigger OnRun()
    begin
    end;


    procedure ConfigureCompany(Name: Text[50];Address: Text[50];Address2: Text[50];City: Text[30];County: Text[30];PostCode: Code[20];CountryCode: Code[10];PhoneNo: Text[30]): Boolean
    var
        CompanyInformation: Record "Company Information";
    begin
        if not CompanyInformation.Get then
          CompanyInformation.Insert;
        CompanyInformation.Name := Name;
        CompanyInformation.Address := Address;
        CompanyInformation."Address 2" := Address2;
        CompanyInformation.City := City;
        CompanyInformation.County := County;
        CompanyInformation."Post Code" := PostCode;
        CompanyInformation."Country/Region Code" := CountryCode;
        CompanyInformation."Phone No." := PhoneNo;
        exit(CompanyInformation.Modify);
    end;
}

