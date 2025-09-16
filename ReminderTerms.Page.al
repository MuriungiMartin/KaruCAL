#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 431 "Reminder Terms"
{
    ApplicationArea = Basic;
    Caption = 'Reminder Terms';
    PageType = List;
    SourceTable = "Reminder Terms";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a code to identify this set of reminder terms.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the reminder terms.';
                }
                field("Max. No. of Reminders";"Max. No. of Reminders")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the maximum number of reminders that can be created for an invoice.';
                }
                field("Post Interest";"Post Interest")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether or not any interest listed on the reminder should be posted to the general ledger and customer accounts.';
                }
                field("Post Additional Fee";"Post Additional Fee")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether or not any additional fee listed on the reminder should be posted to the general ledger and customer accounts.';
                }
                field("Post Add. Fee per Line";"Post Add. Fee per Line")
                {
                    ApplicationArea = Basic;
                }
                field("Minimum Amount (LCY)";"Minimum Amount (LCY)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the minimum amount for which a reminder will be created.';
                }
                field("Note About Line Fee on Report";"Note About Line Fee on Report")
                {
                    ApplicationArea = Basic;
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
            action("&Levels")
            {
                ApplicationArea = Basic;
                Caption = '&Levels';
                Image = ReminderTerms;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Reminder Levels";
                RunPageLink = "Reminder Terms Code"=field(Code);
            }
            action(Translation)
            {
                ApplicationArea = Basic;
                Caption = 'Translation';
                Image = Translation;
                RunObject = Page "Reminder Terms Translation";
                RunPageLink = "Reminder Terms Code"=field(Code);
            }
        }
    }
}

