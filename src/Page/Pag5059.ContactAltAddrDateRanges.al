#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5059 "Contact Alt. Addr. Date Ranges"
{
    Caption = 'Contact Alt. Addr. Date Ranges';
    DataCaptionFields = "Contact No.","Contact Alt. Address Code";
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Contact Alt. Addr. Date Range";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Starting Date";"Starting Date")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the date from which the alternate address is valid. There are certain rules for how dates should be entered.';
                }
                field("Ending Date";"Ending Date")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the last day on which the alternate address is valid. There are certain rules for how dates should be entered.';
                }
                field("Contact Alt. Address Code";"Contact Alt. Address Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the code of the contact alternate address to which the date range applies.';
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

