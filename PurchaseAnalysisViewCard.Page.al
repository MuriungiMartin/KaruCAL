#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7156 "Purchase Analysis View Card"
{
    Caption = 'Purch. Analysis View Card';
    PageType = Card;
    SourceTable = "Item Analysis View";
    SourceTableView = where("Analysis Area"=const(Purchase));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
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
                field("Item Filter";"Item Filter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a filter to specify the items that will be included in an analysis view.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        ItemList: Page "Item List";
                    begin
                        ItemList.LookupMode(true);
                        if not (ItemList.RunModal = Action::LookupOK) then begin
                          Text := ItemList.GetSelectionFilter;
                          exit(true);
                        end;
                    end;
                }
                field("Location Filter";"Location Filter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a location filter to specify that only entries posted to a particular location are to be included in an analysis view.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        LocList: Page "Location List";
                    begin
                        LocList.LookupMode(true);
                        if LocList.RunModal = Action::LookupOK then begin
                          Text := LocList.GetSelectionFilter;
                          exit(true);
                        end;
                    end;
                }
                field("Date Compression";"Date Compression")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the period that the program will combine entries for, in order to create a single entry for that time period.';
                }
                field("Starting Date";"Starting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date from which item ledger entries will be included in an analysis view.';
                }
                field("Last Date Updated";"Last Date Updated")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date on which the analysis view was last updated.';
                }
                field("Last Entry No.";"Last Entry No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the last item ledger entry you posted, prior to updating the analysis view.';
                }
                field("Last Budget Entry No.";"Last Budget Entry No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the last item budget entry you entered prior to updating the analysis view.';
                }
                field("Update on Posting";"Update on Posting")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if the analysis view is updated every time that you post an item ledger entry, for example from a sales invoice.';
                }
                field("Include Budgets";"Include Budgets")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether to include an update of analysis view budget entries, when updating an analysis view.';
                }
                field(Blocked;Blocked)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if the analysis view is blocked so that it cannot be updated.';
                }
            }
            group(Dimensions)
            {
                Caption = 'Dimensions';
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
            action("&Update")
            {
                ApplicationArea = Basic;
                Caption = '&Update';
                Image = Refresh;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Codeunit "Update Item Analysis View";
            }
            action("Enable Update on Posting")
            {
                ApplicationArea = Basic;
                Caption = 'Enable Update on Posting';
                Image = Apply;

                trigger OnAction()
                begin
                    SetUpdateOnPosting(true);
                end;
            }
            action("Disable Update on Posting")
            {
                ApplicationArea = Basic;
                Caption = 'Disable Update on Posting';
                Image = UnApply;

                trigger OnAction()
                begin
                    SetUpdateOnPosting(false);
                end;
            }
        }
    }
}

