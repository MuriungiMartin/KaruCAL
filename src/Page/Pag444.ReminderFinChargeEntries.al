#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 444 "Reminder/Fin. Charge Entries"
{
    ApplicationArea = Basic;
    Caption = 'Reminder/Fin. Charge Entries';
    Editable = false;
    PageType = List;
    SourceTable = "Reminder/Fin. Charge Entry";
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the posting date of the reminder or finance charge memo.';
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether the entry comes from a reminder or a finance charge memo.';
                }
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the reminder or the finance charge memo.';
                }
                field("Customer Entry No.";"Customer Entry No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the customer ledger entry on the reminder line or finance charge memo line.';
                }
                field("Document Type";"Document Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the document type of the customer entry on the reminder line or finance charge memo line.';
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the document number of the customer entry on the reminder line or finance charge memo line.';
                }
                field("Interest Posted";"Interest Posted")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether or not interest was posted to the customer account and a general ledger account when the reminder or finance charge memo was issued.';
                }
                field("Remaining Amount";"Remaining Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the remaining amount of the customer ledger entry this reminder or finance charge memo entry is for.';
                }
                field("Reminder Level";"Reminder Level")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the reminder level if the Type field contains Reminder.';
                }
                field("Entry No.";"Entry No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that a consecutive number is assigned to each new entry.';
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
            action("&Navigate")
            {
                ApplicationArea = Basic;
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Find all entries and documents that exist for the document number and posting date on the selected entry or document.';

                trigger OnAction()
                begin
                    Navigate;
                end;
            }
        }
    }
}

