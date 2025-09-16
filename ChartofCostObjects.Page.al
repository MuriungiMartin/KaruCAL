#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1123 "Chart of Cost Objects"
{
    ApplicationArea = Basic;
    Caption = 'Chart of Cost Objects';
    CardPageID = "Cost Object Card";
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Cost Object";
    SourceTableView = sorting("Sorting Order");
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control16)
            {
                IndentationColumn = NameIndent;
                IndentationControls = Name;
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                    Style = Strong;
                    StyleExpr = Emphasize;
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                    Style = Strong;
                    StyleExpr = Emphasize;
                }
                field("Line Type";"Line Type")
                {
                    ApplicationArea = Basic;
                }
                field(Totaling;Totaling)
                {
                    ApplicationArea = Basic;
                }
                field("Sorting Order";"Sorting Order")
                {
                    ApplicationArea = Basic;
                }
                field("Balance at Date";"Balance at Date")
                {
                    ApplicationArea = Basic;
                    Style = Strong;
                    StyleExpr = Emphasize;
                }
                field("Net Change";"Net Change")
                {
                    ApplicationArea = Basic;
                    Style = Strong;
                    StyleExpr = Emphasize;
                }
                field(Comment;Comment)
                {
                    ApplicationArea = Basic;
                }
                field(Blocked;Blocked)
                {
                    ApplicationArea = Basic;
                }
                field("New Page";"New Page")
                {
                    ApplicationArea = Basic;
                }
                field("Blank Line";"Blank Line")
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
            group("&Cost Object")
            {
                Caption = '&Cost Object';
                Image = Costs;
                action("Cost E&ntries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cost E&ntries';
                    Image = CostEntries;
                    RunObject = Page "Cost Entries";
                    RunPageLink = "Cost Object Code"=field(Code);
                    RunPageView = sorting("Cost Object Code","Cost Type No.",Allocated,"Posting Date");
                    ShortCutKey = 'Ctrl+F7';
                }
                separator(Action4)
                {
                }
                action("&Balance")
                {
                    ApplicationArea = Basic;
                    Caption = '&Balance';
                    Image = Balance;
                    ShortCutKey = 'F7';

                    trigger OnAction()
                    begin
                        if Totaling = '' then
                          CostType.SetFilter("Cost Object Filter",Code)
                        else
                          CostType.SetFilter("Cost Object Filter",Totaling);

                        Page.Run(Page::"Cost Type Balance",CostType);
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
                action("I&ndent Cost Objects")
                {
                    ApplicationArea = Basic;
                    Caption = 'I&ndent Cost Objects';
                    Image = IndentChartOfAccounts;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        CostAccountMgt.IndentCostObjectsYN;
                    end;
                }
                action("Get Cost Objects From Dimension")
                {
                    ApplicationArea = Basic;
                    Caption = 'Get Cost Objects From Dimension';
                    Image = ChangeTo;

                    trigger OnAction()
                    begin
                        CostAccountMgt.CreateCostObjects;
                    end;
                }
            }
            action("Dimension Values")
            {
                AccessByPermission = TableData Dimension=R;
                ApplicationArea = Basic;
                Caption = 'Dimension Values';
                Image = Dimensions;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    DimValue: Record "Dimension Value";
                begin
                    CostAccSetup.Get;
                    DimValue.SetRange("Dimension Code",CostAccSetup."Cost Object Dimension");
                    Page.Run(0,DimValue);
                end;
            }
        }
        area(reporting)
        {
            action("Cost Object with Budget")
            {
                ApplicationArea = Basic;
                Caption = 'Cost Object with Budget';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Cost Acctg. Balance/Budget";
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        NameIndent := 0;
        CodeOnFormat;
        NameOnFormat;
        BalanceatDateOnFormat;
        NetChangeOnFormat;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        CurrPage.SetSelectionFilter(Rec);
        ConfirmDeleteIfEntriesExist(Rec,false);
        Reset;
    end;

    var
        CostType: Record "Cost Type";
        CostAccSetup: Record "Cost Accounting Setup";
        CostAccountMgt: Codeunit "Cost Account Mgt";
        [InDataSet]
        Emphasize: Boolean;
        [InDataSet]
        NameIndent: Integer;

    local procedure CodeOnFormat()
    begin
        Emphasize := "Line Type" <> "line type"::"Cost Object";
    end;

    local procedure NameOnFormat()
    begin
        NameIndent := Indentation;
        Emphasize := "Line Type" <> "line type"::"Cost Object";
    end;

    local procedure BalanceatDateOnFormat()
    begin
        Emphasize := "Line Type" <> "line type"::"Cost Object";
    end;

    local procedure NetChangeOnFormat()
    begin
        Emphasize := "Line Type" <> "line type"::"Cost Object";
    end;


    procedure GetSelectionFilter(): Text
    var
        CostObject: Record "Cost Object";
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
    begin
        CurrPage.SetSelectionFilter(CostObject);
        exit(SelectionFilterManagement.GetSelectionFilterForCostObject(CostObject));
    end;
}

