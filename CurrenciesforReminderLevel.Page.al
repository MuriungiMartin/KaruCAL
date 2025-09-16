#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 478 "Currencies for Reminder Level"
{
    Caption = 'Currencies for Reminder Level';
    PageType = List;
    SourceTable = "Currency for Reminder Level";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the currency in which you want to set up additional fees for reminders.';
                }
                field("Additional Fee";"Additional Fee")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the amount of the additional fee in foreign currency that will be added on the reminder.';
                }
                field("Add. Fee per Line";"Add. Fee per Line")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that the fee will be distributed on individual reminder lines.';
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

