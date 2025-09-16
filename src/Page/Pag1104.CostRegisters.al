#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1104 "Cost Registers"
{
    ApplicationArea = Basic;
    Caption = 'Cost Registers';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Cost Register";
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(Control9)
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
                field("From Cost Entry No.";"From Cost Entry No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("To Cost Entry No.";"To Cost Entry No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("No. of Entries";"No. of Entries")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("From G/L Entry No.";"From G/L Entry No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("To G/L Entry No.";"To G/L Entry No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Debit Amount";"Debit Amount")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Credit Amount";"Credit Amount")
                {
                    ApplicationArea = Basic;
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
                action("&Cost Entries")
                {
                    ApplicationArea = Basic;
                    Caption = '&Cost Entries';
                    Image = CostEntries;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunPageOnRec = true;
                    ShortCutKey = 'Ctrl+F7';

                    trigger OnAction()
                    var
                        CostEntry: Record "Cost Entry";
                    begin
                        CostEntry.SetRange("Entry No.","From Cost Entry No.","To Cost Entry No.");
                        Page.Run(Page::"Cost Entries",CostEntry);
                    end;
                }
                action("&Allocated Cost Entries")
                {
                    ApplicationArea = Basic;
                    Caption = '&Allocated Cost Entries';
                    Image = GLRegisters;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Cost Entries";
                    RunPageLink = "Allocated with Journal No."=field("No.");
                    RunPageView = sorting("Allocated with Journal No.");
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("&Delete Cost Entries")
                {
                    ApplicationArea = Basic;
                    Caption = '&Delete Cost Entries';
                    Image = Delete;
                    RunObject = Report "Delete Cost Entries";
                    RunPageOnRec = true;
                }
                action("&Delete Old Cost Entries")
                {
                    ApplicationArea = Basic;
                    Caption = '&Delete Old Cost Entries';
                    Image = Delete;
                    RunObject = Report "Delete Old Cost Entries";
                }
            }
        }
    }
}

