#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 541 "Account Type Default Dim."
{
    Caption = 'Account Type Default Dim.';
    DataCaptionFields = "Dimension Code";
    PageType = List;
    SourceTable = "Default Dimension";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Table ID";"Table ID")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies a table ID for the account type if you are specifying default dimensions for an entire account type.';

                    trigger OnValidate()
                    begin
                        TableIDOnAfterValidate;
                    end;
                }
                field("Table Caption";"Table Caption")
                {
                    ApplicationArea = Suite;
                    DrillDown = false;
                    ToolTip = 'Specifies the table name for the account type you wish to define a default dimension for.';
                }
                field("Dimension Value Code";"Dimension Value Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the dimension value code to suggest as the default dimension.';
                }
                field("Value Posting";"Value Posting")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies how default dimensions and their values must be used.';
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
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Check Value Posting")
                {
                    ApplicationArea = Suite;
                    Caption = 'Check Value Posting';
                    Ellipsis = true;
                    Image = "Report";
                    RunObject = Report "Check Value Posting";
                    ToolTip = 'Find out if value posting rules that are specified for individual default dimensions conflict with value posting rules that you have specified for account type default dimensions. For example, if you have set up a customer account with value posting No Code and then specify that all customer accounts should have a particular default dimension value code, this report will show that a conflict exists.';
                }
            }
        }
    }

    local procedure TableIDOnAfterValidate()
    begin
        CalcFields("Table Caption");
    end;
}

