#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 556 "Analysis View List"
{
    ApplicationArea = Basic;
    Caption = 'Analysis View List';
    CardPageID = "Analysis View Card";
    Editable = false;
    PageType = List;
    SourceTable = "Analysis View";
    UsageCategory = ReportsandAnalysis;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                }
                field("Account Source";"Account Source")
                {
                    ApplicationArea = Basic;
                }
                field("Include Budgets";"Include Budgets")
                {
                    ApplicationArea = Basic;
                    Visible = GLAccountSource;
                }
                field("Last Date Updated";"Last Date Updated")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Dimension 1 Code";"Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Dimension 2 Code";"Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Dimension 3 Code";"Dimension 3 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Dimension 4 Code";"Dimension 4 Code")
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
            action(EditAnalysis)
            {
                ApplicationArea = Basic;
                Caption = 'Edit Analysis View';
                Image = Edit;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    AnalysisbyDimensions: Page "Analysis by Dimensions";
                begin
                    AnalysisbyDimensions.SetAnalysisViewCode(Code);
                    AnalysisbyDimensions.Run;
                end;
            }
            action("&Update")
            {
                ApplicationArea = Basic;
                Caption = '&Update';
                Image = Refresh;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Codeunit "Update Analysis View";
            }
        }
    }

    trigger OnOpenPage()
    begin
        GLAccountSource := "Account Source" = "account source"::"G/L Account";
    end;

    var
        GLAccountSource: Boolean;
}

