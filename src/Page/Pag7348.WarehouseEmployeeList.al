#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7348 "Warehouse Employee List"
{
    Caption = 'Warehouse Employee List';
    DelayedInsert = true;
    Editable = false;
    PageType = List;
    SourceTable = "Warehouse Employee";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("User ID";"User ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the user ID of the warehouse employee.';
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the location in which the employee works.';
                }
                field(Default;Default)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that the location code that is defined as the default location for this employee''s activities.';
                }
                field("ADCS User";"ADCS User")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ADCS user name of a warehouse employee.';
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
    }
}

