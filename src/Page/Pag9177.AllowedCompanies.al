#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9177 "Allowed Companies"
{
    Caption = 'Allowed Companies';
    Editable = false;
    PageType = List;
    SourceTable = Company;
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Name;Name)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the name of a company that has been created in the current database.';
                }
                field("Evaluation Company";"Evaluation Company")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Create New Company")
            {
                AccessByPermission = TableData Company=I;
                ApplicationArea = Suite;
                Caption = 'Create New Company';
                Image = Company;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Get assistance with creating a new company.';

                trigger OnAction()
                begin
                    // Action invoked through event subscriber to avoid hard coupling to other objects,
                    // as this page is part of the Cloud Manager.
                    Initialize;
                end;
            }
        }
    }


    procedure Initialize()
    var
        Company: Record Company;
        Language: Record Language;
    begin
        DeleteAll;
        Language.Init;

        if Company.FindSet then
          repeat
            // Use a table that all users can access, and check whether users have permissions to open the company.
            if Language.ChangeCompany(Company.Name) then begin
              Rec := Company;
              Insert;
            end;
          until Company.Next = 0;
    end;
}

