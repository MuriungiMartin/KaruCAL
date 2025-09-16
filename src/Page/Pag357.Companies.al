#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 357 Companies
{
    ApplicationArea = Basic;
    Caption = 'Companies';
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = Company;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Name;Name)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Name';
                    ToolTip = 'Specifies the name of a company that has been created in the current database.';
                }
                field("Evaluation Company";"Evaluation Company")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                }
                field(EnableAssistedCompanySetup;EnableAssistedCompanySetup)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Enable Assisted Company Setup';
                    ToolTip = 'Specifies that the user will be assisted in setting up the company.';

                    trigger OnValidate()
                    var
                        AssistedCompanySetupStatus: Record "Assisted Company Setup Status";
                    begin
                        AssistedCompanySetupStatus.SetEnabled(Name,EnableAssistedCompanySetup,false);
                    end;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(CopyCompany)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Copy';
                Image = Copy;
                Promoted = true;
                PromotedIsBig = false;
                ToolTip = 'Copy an existing company to a new company.';

                trigger OnAction()
                var
                    Company: Record Company;
                    CopyCompany: Report "Copy Company";
                begin
                    Company.SetRange(Name,Name);
                    CopyCompany.SetTableview(Company);
                    CopyCompany.RunModal;

                    if Get(CopyCompany.GetCompanyName) then;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        AssistedCompanySetupStatus: Record "Assisted Company Setup Status";
    begin
        if AssistedCompanySetupStatus.Get(Name) then
          EnableAssistedCompanySetup := AssistedCompanySetupStatus.Enabled
        else
          EnableAssistedCompanySetup := false;
    end;

    trigger OnDeleteRecord(): Boolean
    var
        AssistedCompanySetupStatus: Record "Assisted Company Setup Status";
    begin
        if not Confirm(DeleteCompanyQst,false) then
          exit(false);

        if AssistedCompanySetupStatus.Get(Name) then
          AssistedCompanySetupStatus.Delete;

        exit(true);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        EnableAssistedCompanySetup := false;
    end;

    var
        DeleteCompanyQst: label 'Do you want to delete the company?\All company data will be deleted.\\Do you want to continue?';
        EnableAssistedCompanySetup: Boolean;
}

