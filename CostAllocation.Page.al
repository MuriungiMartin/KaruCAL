#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1105 "Cost Allocation"
{
    Caption = 'Cost Allocation';
    PageType = Document;
    SourceTable = "Cost Allocation Source";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(ID;ID)
                {
                    ApplicationArea = Basic;
                }
                field(Level;Level)
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field("Valid From";"Valid From")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field("Valid To";"Valid To")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field(Variant;Variant)
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field("Cost Type Range";"Cost Type Range")
                {
                    ApplicationArea = Basic;
                }
                field("Cost Center Code";"Cost Center Code")
                {
                    ApplicationArea = Basic;
                }
                field("Cost Object Code";"Cost Object Code")
                {
                    ApplicationArea = Basic;
                }
                field("Credit to Cost Type";"Credit to Cost Type")
                {
                    ApplicationArea = Basic;
                }
                field(Blocked;Blocked)
                {
                    ApplicationArea = Basic;
                }
            }
            part(AllocTarget;"Cost Allocation Target")
            {
                SubPageLink = ID=field(ID);
            }
            group(Statistics)
            {
                Caption = 'Statistics';
                field("Allocation Source Type";"Allocation Source Type")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field("Last Date Modified";"Last Date Modified")
                {
                    ApplicationArea = Basic;
                }
                field("User ID";"User ID")
                {
                    ApplicationArea = Basic;
                }
                field(Comment;Comment)
                {
                    ApplicationArea = Basic;
                }
                field("Total Share";"Total Share")
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
            group("Allo&cation")
            {
                Caption = 'Allo&cation';
                Image = Allocate;
                separator(Action3)
                {
                }
                action("Cost E&ntries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cost E&ntries';
                    Image = CostEntries;
                    RunObject = Page "Cost Entries";
                    RunPageLink = "Allocation ID"=field(ID);
                    RunPageView = sorting("Allocation ID","Posting Date");
                    ShortCutKey = 'Ctrl+F7';
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Calculate Allocation Bases")
                {
                    ApplicationArea = Basic;
                    Caption = 'Calculate Allocation Bases';
                    Image = CalculateCost;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        CostAccAllocation: Codeunit "Cost Account Allocation";
                    begin
                        CostAccAllocation.CalcAllocationKey(Rec);
                    end;
                }
            }
        }
        area(reporting)
        {
            action(Allocations)
            {
                ApplicationArea = Basic;
                Caption = 'Allocations';
                Image = Allocations;
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Cost Allocations";
            }
        }
    }
}

