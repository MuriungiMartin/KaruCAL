#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 274 "Resource Registers"
{
    ApplicationArea = Basic;
    Caption = 'Resource Registers';
    Editable = false;
    PageType = List;
    SourceTable = "Resource Register";
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the number of the resource register.';
                }
                field("Creation Date";"Creation Date")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the date when you posted the entries in the journal.';
                }
                field("User ID";"User ID")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the ID of the user who posted the entries and created the resource register.';
                }
                field("Source Code";"Source Code")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the source of the entry.';
                }
                field("Journal Batch Name";"Journal Batch Name")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the batch name that is assigned to this journal.';
                }
                field("From Entry No.";"From Entry No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the first entry number in the register.';
                }
                field("To Entry No.";"To Entry No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the number of the last entry line that you included before you posted the entries in the journal.';
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
        area(navigation)
        {
            group("&Register")
            {
                Caption = '&Register';
                Image = Register;
                action("Resource Ledger")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Resource Ledger';
                    Image = ResourceLedger;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Codeunit "Res. Reg.-Show Ledger";
                    ToolTip = 'View the ledger entries for the resource.';
                }
            }
        }
    }
}

