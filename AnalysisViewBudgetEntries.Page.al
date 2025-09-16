#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 559 "Analysis View Budget Entries"
{
    ApplicationArea = Basic;
    Caption = 'Analysis View Budget Entries';
    Editable = false;
    PageType = List;
    SourceTable = "Analysis View Budget Entry";
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Analysis View Code";"Analysis View Code")
                {
                    ApplicationArea = Basic;
                }
                field("Budget Name";"Budget Name")
                {
                    ApplicationArea = Basic;
                }
                field("Business Unit Code";"Business Unit Code")
                {
                    ApplicationArea = Basic;
                }
                field("G/L Account No.";"G/L Account No.")
                {
                    ApplicationArea = Basic;
                }
                field("Dimension 1 Value Code";"Dimension 1 Value Code")
                {
                    ApplicationArea = Basic;
                }
                field("Dimension 2 Value Code";"Dimension 2 Value Code")
                {
                    ApplicationArea = Basic;
                }
                field("Dimension 3 Value Code";"Dimension 3 Value Code")
                {
                    ApplicationArea = Basic;
                }
                field("Dimension 4 Value Code";"Dimension 4 Value Code")
                {
                    ApplicationArea = Basic;
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic;

                    trigger OnDrillDown()
                    begin
                        DrillDown;
                    end;
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

    trigger OnAfterGetCurrRecord()
    begin
        if "Analysis View Code" <> xRec."Analysis View Code" then;
    end;

    local procedure DrillDown()
    var
        GLBudgetEntry: Record "G/L Budget Entry";
    begin
        GLBudgetEntry.SetRange("Entry No.","Entry No.");
        Page.RunModal(Page::"G/L Budget Entries",GLBudgetEntry);
    end;
}

