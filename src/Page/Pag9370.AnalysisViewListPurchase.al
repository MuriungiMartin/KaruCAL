#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9370 "Analysis View List Purchase"
{
    ApplicationArea = Basic;
    Caption = 'Analysis View List Purchase';
    CardPageID = "Purchase Analysis View Card";
    DataCaptionFields = "Analysis Area";
    Editable = false;
    PageType = List;
    SourceTable = "Item Analysis View";
    SourceTableView = where("Analysis Area"=const(Purchase));
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
                    ToolTip = 'Specifies a code for the analysis view.';
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the analysis view.';
                }
                field("Include Budgets";"Include Budgets")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether to include an update of analysis view budget entries, when updating an analysis view.';
                }
                field("Last Date Updated";"Last Date Updated")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the date on which the analysis view was last updated.';
                }
                field("Dimension 1 Code";"Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies one of the three dimensions that you can include in an analysis view.';
                }
                field("Dimension 2 Code";"Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies one of the three dimensions that you can include in an analysis view.';
                }
                field("Dimension 3 Code";"Dimension 3 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies one of the three dimensions that you can include in an analysis view.';
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
            group("&Analysis")
            {
                Caption = '&Analysis';
                Image = AnalysisView;
                action("Filter")
                {
                    ApplicationArea = Basic;
                    Caption = 'Filter';
                    Image = "Filter";
                    RunObject = Page "Item Analysis View Filter";
                    RunPageLink = "Analysis Area"=field("Analysis Area"),
                                  "Analysis View Code"=field(Code);
                }
            }
        }
        area(processing)
        {
            action(EditAnalysisView)
            {
                ApplicationArea = Basic;
                Caption = 'Edit Analysis View';
                Image = Edit;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    PurchAnalysisbyDim: Page "Purch. Analysis by Dimensions";
                begin
                    PurchAnalysisbyDim.SetCurrentAnalysisViewCode(Code);
                    PurchAnalysisbyDim.Run;
                end;
            }
            action("&Update")
            {
                ApplicationArea = Basic;
                Caption = '&Update';
                Image = Refresh;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Codeunit "Update Item Analysis View";
            }
        }
    }
}

