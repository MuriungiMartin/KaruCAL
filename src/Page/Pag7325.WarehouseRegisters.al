#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7325 "Warehouse Registers"
{
    ApplicationArea = Basic;
    Caption = 'Warehouse Registers';
    Editable = false;
    PageType = List;
    SourceTable = "Warehouse Register";
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the warehouse register.';
                }
                field("From Entry No.";"From Entry No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the first warehouse entry number in the register.';
                }
                field("To Entry No.";"To Entry No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the last warehouse entry number in the register.';
                }
                field("Creation Date";"Creation Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date on which the entries in the register were posted.';
                }
                field("Source Code";"Source Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the source code for the entries in the register.';
                }
                field("User ID";"User ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the user ID of the user who posted the entries and created the warehouse register.';
                }
                field("Journal Batch Name";"Journal Batch Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the warehouse journal batch from which the entries were posted.';
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
                action("&Warehouse Entries")
                {
                    ApplicationArea = Basic;
                    Caption = '&Warehouse Entries';
                    Image = BinLedger;
                    ShortCutKey = 'Ctrl+F7';

                    trigger OnAction()
                    var
                        WhseEntry: Record "Warehouse Entry";
                    begin
                        WhseEntry.SetRange("Entry No.","From Entry No.","To Entry No.");
                        Page.Run(Page::"Warehouse Entries",WhseEntry);
                    end;
                }
            }
        }
    }
}

