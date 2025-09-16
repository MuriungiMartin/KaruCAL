#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1900 "Template Selection Mgt."
{

    trigger OnRun()
    begin
    end;


    procedure SaveCustTemplateSelectionForCurrentUser(TemplateCode: Code[10])
    begin
        SaveTemplateSelectionForCurrentUser(TemplateCode,GetCustomerTemplateSelectionCode);
    end;


    procedure GetLastCustTemplateSelection(var TemplateCode: Code[10]): Boolean
    begin
        exit(GetLastTemplateSelection(TemplateCode,GetCustomerTemplateSelectionCode));
    end;


    procedure SaveVendorTemplateSelectionForCurrentUser(TemplateCode: Code[10])
    begin
        SaveTemplateSelectionForCurrentUser(TemplateCode,GetVendorTemplateSelectionCode);
    end;


    procedure GetLastVendorTemplateSelection(var TemplateCode: Code[10]): Boolean
    begin
        exit(GetLastTemplateSelection(TemplateCode,GetVendorTemplateSelectionCode));
    end;


    procedure SaveItemTemplateSelectionForCurrentUser(TemplateCode: Code[10])
    begin
        SaveTemplateSelectionForCurrentUser(TemplateCode,GetItemTemplateSelectionCode);
    end;


    procedure GetLastItemTemplateSelection(var TemplateCode: Code[10]): Boolean
    begin
        exit(GetLastTemplateSelection(TemplateCode,GetItemTemplateSelectionCode));
    end;


    procedure GetCustomerTemplateSelectionCode(): Code[20]
    begin
        exit('LASTCUSTTEMPSEL');
    end;


    procedure GetVendorTemplateSelectionCode(): Code[20]
    begin
        exit('LASTVENDTEMPSEL');
    end;


    procedure GetItemTemplateSelectionCode(): Code[20]
    begin
        exit('LASTITEMTEMPSEL');
    end;

    local procedure SaveTemplateSelectionForCurrentUser(TemplateCode: Code[10];ContextCode: Code[20])
    var
        UserPreference: Record "User Preference";
    begin
        if UserPreference.Get(UserId,ContextCode) then
          UserPreference.Delete;

        UserPreference.Init;
        UserPreference."User ID" := UserId;
        UserPreference."Instruction Code" := ContextCode;
        UserPreference.SetUserSelection(TemplateCode);
        UserPreference.Insert;
    end;

    local procedure GetLastTemplateSelection(var TemplateCode: Code[10];ContextCode: Code[20]): Boolean
    var
        UserPreference: Record "User Preference";
    begin
        if not UserPreference.Get(UserId,ContextCode) then
          exit(false);

        UserPreference.CalcFields("User Selection");
        TemplateCode := CopyStr(UserPreference.GetUserSelectionAsText,1,MaxStrLen(TemplateCode));
        exit(true);
    end;
}

