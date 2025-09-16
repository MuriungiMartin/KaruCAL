#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 488 "Column Layout Names"
{
    Caption = 'Column Layout Names';
    PageType = List;
    SourceTable = "Column Layout Name";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Name;Name)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the name of the account schedule column layout.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a description of the account schedule column layout.';
                }
                field("Analysis View Name";"Analysis View Name")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the name of the analysis view you want the column layout to be based on.';
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
            action(EditColumnLayoutSetup)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Edit Column Layout Setup';
                Ellipsis = true;
                Image = SetupColumns;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Create or change the column layout for the current account schedule name.';

                trigger OnAction()
                var
                    ColumnLayout: Page "Column Layout";
                begin
                    ColumnLayout.SetColumnLayoutName(Name);
                    ColumnLayout.Run;
                end;
            }
        }
    }
}

