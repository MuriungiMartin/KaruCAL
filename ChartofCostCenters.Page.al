#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1122 "Chart of Cost Centers"
{
    ApplicationArea = Basic;
    Caption = 'Chart of Cost Centers';
    CardPageID = "Cost Center Card";
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Cost Center";
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
                field("Net Change";"Net Change")
                {
                    ApplicationArea = Basic;
                    Style = Strong;
                    StyleExpr = Emphasize;
                }
                field("Balance at Date";"Balance at Date")
                {
                    ApplicationArea = Basic;
                    Style = Strong;
                    StyleExpr = Emphasize;
                    Visible = false;
                }
                field("Balance to Allocate";"Balance to Allocate")
                {
                    ApplicationArea = Basic;
                    Style = Strong;
                    StyleExpr = Emphasize;
                }
                field("Cost Subtype";"Cost Subtype")
                {
                    ApplicationArea = Basic;
                }
                field("Responsible Person";"Responsible Person")
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
                    Visible = false;
                }
                field("Blank Line";"Blank Line")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Comment;Comment)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Cost Center")
            {
                Caption = '&Cost Center';
                Image = CostCenter;
                action("Cost E&ntries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cost E&ntries';
                    Image = CostEntries;
                    RunObject = Page "Cost Entries";
                    RunPageLink = "Cost Center Code"=field(Code);
                    RunPageView = sorting("Cost Center Code","Cost Type No.",Allocated,"Posting Date");
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
                          CostType.SetFilter("Cost Center Filter",Code)
                        else
                          CostType.SetFilter("Cost Center Filter",Totaling);

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
                action("I&ndent Cost Centers")
                {
                    ApplicationArea = Basic;
                    Caption = 'I&ndent Cost Centers';
                    Image = IndentChartOfAccounts;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        CostAccMgt.IndentCostCentersYN;
                    end;
                }
                action("Get Cost Centers From Dimension")
                {
                    ApplicationArea = Basic;
                    Caption = 'Get Cost Centers From Dimension';
                    Image = ChangeTo;

                    trigger OnAction()
                    begin
                        CostAccMgt.CreateCostCenters;
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
                    DimValue.SetRange("Dimension Code",CostAccSetup."Cost Center Dimension");
                    Page.Run(0,DimValue);
                end;
            }
        }
        area(reporting)
        {
            action("Cost Center with Budget")
            {
                ApplicationArea = Basic;
                Caption = 'Cost Center with Budget';
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
        NetChangeOnFormat;
        BalanceatDateC15OnFormat;
        BalancetoAllocateOnFormat;
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
        CostAccMgt: Codeunit "Cost Account Mgt";
        [InDataSet]
        Emphasize: Boolean;
        [InDataSet]
        NameIndent: Integer;

    local procedure CodeOnFormat()
    begin
        Emphasize := "Line Type" <> "line type"::"Cost Center";
    end;

    local procedure NameOnFormat()
    begin
        NameIndent := Indentation;
        Emphasize := "Line Type" <> "line type"::"Cost Center";
    end;

    local procedure NetChangeOnFormat()
    begin
        Emphasize := "Line Type" <> "line type"::"Cost Center";
    end;

    local procedure BalanceatDateC15OnFormat()
    begin
        Emphasize := "Line Type" <> "line type"::"Cost Center";
    end;

    local procedure BalancetoAllocateOnFormat()
    begin
        Emphasize := "Line Type" <> "line type"::"Cost Center";
    end;


    procedure GetSelectionFilter(): Text
    var
        CostCenter: Record "Cost Center";
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
    begin
        CurrPage.SetSelectionFilter(CostCenter);
        exit(SelectionFilterManagement.GetSelectionFilterForCostCenter(CostCenter));
    end;
}

