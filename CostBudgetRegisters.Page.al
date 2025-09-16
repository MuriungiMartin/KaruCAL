#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1121 "Cost Budget Registers"
{
    ApplicationArea = Basic;
    Caption = 'Cost Budget Registers';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Cost Budget Register";
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(Control8)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Source;Source)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Level;Level)
                {
                    ApplicationArea = Basic;
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field("From Cost Budget Entry No.";"From Cost Budget Entry No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("To Cost Budget Entry No.";"To Cost Budget Entry No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("No. of Entries";"No. of Entries")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("From Budget Entry No.";"From Budget Entry No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("To Budget Entry No.";"To Budget Entry No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Closed;Closed)
                {
                    ApplicationArea = Basic;
                }
                field("Processed Date";"Processed Date")
                {
                    ApplicationArea = Basic;
                }
                field("User ID";"User ID")
                {
                    ApplicationArea = Basic;
                }
                field("Journal Batch Name";"Journal Batch Name")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Entry")
            {
                Caption = '&Entry';
                Image = Entry;
                action("&Cost Budget Entries")
                {
                    ApplicationArea = Basic;
                    Caption = '&Cost Budget Entries';
                    Image = GLRegisters;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunPageMode = View;
                    ShortCutKey = 'Ctrl+F7';

                    trigger OnAction()
                    var
                        CostBudgetEntry: Record "Cost Budget Entry";
                        CostBudgetEntries: Page "Cost Budget Entries";
                    begin
                        CostBudgetEntry.SetRange("Entry No.","From Cost Budget Entry No.","To Cost Budget Entry No.");
                        CostBudgetEntries.SetTableview(CostBudgetEntry);
                        CostBudgetEntries.Editable := false;
                        CostBudgetEntries.Run;
                    end;
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("&Delete Cost Budget Entries")
                {
                    ApplicationArea = Basic;
                    Caption = '&Delete Cost Budget Entries';
                    Image = Delete;
                    RunObject = Report "Delete Cost Budget Entries";
                    RunPageOnRec = true;
                }
            }
        }
    }
}

