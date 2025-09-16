#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1117 "Cost Budget per Period"
{
    Caption = 'Cost Budget per Period';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = ListPlus;
    SourceTable = "Cost Type";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(CostCenterFilter;CostCenterFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Cost Center Filter';
                    TableRelation = "Cost Center";

                    trigger OnValidate()
                    begin
                        UpdateMatrixSubform;
                    end;
                }
                field(CostObjectFilter;CostObjectFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Cost Object Filter';
                    TableRelation = "Cost Object";

                    trigger OnValidate()
                    begin
                        UpdateMatrixSubform;
                    end;
                }
                field(BudgetFilter;BudgetFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Budget Filter';
                    TableRelation = "Cost Budget Name";

                    trigger OnValidate()
                    begin
                        UpdateMatrixSubform;
                    end;
                }
                field(PeriodType;PeriodType)
                {
                    ApplicationArea = Basic;
                    Caption = 'View by';
                    OptionCaption = 'Day,Week,Month,Quarter,Year,Accounting Period';
                    ToolTip = 'Specifies by which period amounts are displayed.';

                    trigger OnValidate()
                    begin
                        SetColumns(Setwanted::First);
                        UpdateMatrixSubform;
                    end;
                }
                field(AmountType;AmountType)
                {
                    ApplicationArea = Basic;
                    Caption = 'View as';
                    OptionCaption = 'Balance at Date,Net Change';
                    ToolTip = 'Specifies how amounts are displayed. Net Change: The net change in the balance for the selected period. Balance at Date: The balance as of the last day in the selected period.';

                    trigger OnValidate()
                    begin
                        UpdateMatrixSubform;
                    end;
                }
                field(RoundingFactor;RoundingFactor)
                {
                    ApplicationArea = Basic;
                    Caption = 'Rounding Factor';
                    OptionCaption = 'None,1,1000,1000000';

                    trigger OnValidate()
                    begin
                        UpdateMatrixSubform;
                    end;
                }
            }
            part(MatrixForm;"Cost Budget per Period Matrix")
            {
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Budge&t")
            {
                Caption = 'Budge&t';
                Image = LedgerBudget;
                action("By Cost &Center")
                {
                    ApplicationArea = Basic;
                    Caption = 'By Cost &Center';
                    Image = CostCenter;
                    RunObject = Page "Cost Budget by Cost Center";
                    RunPageOnRec = true;
                }
                action("By Cost &Object")
                {
                    ApplicationArea = Basic;
                    Caption = 'By Cost &Object';
                    Image = Cost;
                    RunObject = Page "Cost Budget by Cost Object";
                    RunPageOnRec = true;
                }
                separator(Action5)
                {
                }
                action("Budget / Movement")
                {
                    ApplicationArea = Basic;
                    Caption = 'Budget / Movement';
                    Image = CostBudget;
                    RunObject = Page "Cost Type Balance/Budget";
                    RunPageOnRec = true;
                }
            }
        }
        area(processing)
        {
            action(PreviousSet)
            {
                ApplicationArea = Basic;
                Caption = 'Previous Set';
                Image = PreviousSet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Go to the previous set of data.';

                trigger OnAction()
                begin
                    MATRIX_GenerateColumnCaptions(Setwanted::Previous);
                    UpdateMatrixSubform;
                end;
            }
            action(PreviousColumn)
            {
                ApplicationArea = Basic;
                Caption = 'Previous Column';
                Image = PreviousRecord;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    MATRIX_GenerateColumnCaptions(Setwanted::PreviousColumn);
                    UpdateMatrixSubform;
                end;
            }
            action(NextColumn)
            {
                ApplicationArea = Basic;
                Caption = 'Next Column';
                Image = NextRecord;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    MATRIX_GenerateColumnCaptions(Setwanted::NextColumn);
                    UpdateMatrixSubform;
                end;
            }
            action(NextSet)
            {
                ApplicationArea = Basic;
                Caption = 'Next Set';
                Image = NextSet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Go to the next set of data.';

                trigger OnAction()
                begin
                    MATRIX_GenerateColumnCaptions(Setwanted::Next);
                    UpdateMatrixSubform;
                end;
            }
            separator(Action27)
            {
            }
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Copy Cost Budget to Cost Budget")
                {
                    ApplicationArea = Basic;
                    Caption = 'Copy Cost Budget to Cost Budget';
                    Image = CopyCostBudget;
                    RunObject = Report "Copy Cost Budget";
                }
                action("Copy G/L Budget to Cost Budget")
                {
                    ApplicationArea = Basic;
                    Caption = 'Copy G/L Budget to Cost Budget';
                    Image = CopyGLtoCostBudget;
                    RunObject = Report "Copy G/L Budget to Cost Acctg.";
                }
                action("Copy Cost Budget to G/L Budget")
                {
                    ApplicationArea = Basic;
                    Caption = 'Copy Cost Budget to G/L Budget';
                    Image = CopyCosttoGLBudget;
                    RunObject = Report "Copy Cost Acctg. Budget to G/L";
                }
                action(ExportToExcel)
                {
                    ApplicationArea = Basic;
                    Caption = 'Export To Excel';
                    Image = ExportToExcel;

                    trigger OnAction()
                    var
                        CostBudgetEntry: Record "Cost Budget Entry";
                        ExportCostBudgetToExcel: Report "Export Cost Budget to Excel";
                    begin
                        CostBudgetEntry.SetFilter("Budget Name",BudgetFilter);
                        CostBudgetEntry.SetFilter("Cost Center Code",CostCenterFilter);
                        CostBudgetEntry.SetFilter("Cost Object Code",CostObjectFilter);
                        ExportCostBudgetToExcel.SetParameters(RoundingFactor);
                        ExportCostBudgetToExcel.SetTableview(CostBudgetEntry);
                        ExportCostBudgetToExcel.Run;
                    end;
                }
                action(ImportFromExcel)
                {
                    ApplicationArea = Basic;
                    Caption = 'Import From Excel';
                    Image = ImportExcel;

                    trigger OnAction()
                    var
                        CostBudgetEntry: Record "Cost Budget Entry";
                        ImportCostBudgetFromExcel: Report "Import Cost Budget from Excel";
                    begin
                        CostBudgetEntry.SetFilter("Budget Name",BudgetFilter);
                        ImportCostBudgetFromExcel.SetGLBudgetName(CostBudgetEntry.GetRangeMin("Budget Name"));
                        ImportCostBudgetFromExcel.RunModal;
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        SetColumns(Setwanted::First);
        BudgetFilter := GetFilter("Budget Filter");
        MATRIX_GenerateColumnCaptions(Setwanted::First);
        UpdateMatrixSubform;
    end;

    var
        MatrixRecords: array [32] of Record Date;
        CostCenterFilter: Text;
        CostObjectFilter: Text;
        BudgetFilter: Text;
        MatrixColumnCaptions: array [32] of Text[80];
        ColumnSet: Text[80];
        PKFirstRecInCurrSet: Text[80];
        PeriodType: Option Day,Week,Month,Quarter,Year,"Accounting Period";
        AmountType: Option "Balance at Date","Net Change";
        RoundingFactor: Option "None","1","1000","1000000";
        SetWanted: Option First,Previous,Same,Next,PreviousColumn,NextColumn;
        CurrSetLength: Integer;


    procedure SetColumns(SetWanted: Option First,Previous,Same,Next,PreviousColumn,NextColumn)
    var
        MatrixMgt: Codeunit "Matrix Management";
    begin
        MatrixMgt.GeneratePeriodMatrixData(SetWanted,12,false,PeriodType,'',
          PKFirstRecInCurrSet,MatrixColumnCaptions,ColumnSet,CurrSetLength,MatrixRecords);
    end;

    local procedure UpdateMatrixSubform()
    begin
        CurrPage.MatrixForm.Page.Load(MatrixColumnCaptions,MatrixRecords,CurrSetLength,CostCenterFilter,
          CostObjectFilter,BudgetFilter,RoundingFactor,AmountType);
    end;

    local procedure MATRIX_GenerateColumnCaptions(MATRIX_SetWanted: Option First,Previous,Same,Next,PreviousColumn,NextColumn)
    var
        MatrixMgt: Codeunit "Matrix Management";
    begin
        Clear(MatrixColumnCaptions);
        CurrSetLength := 12;

        MatrixMgt.GeneratePeriodMatrixData(
          MATRIX_SetWanted,CurrSetLength,false,PeriodType,'',
          PKFirstRecInCurrSet,MatrixColumnCaptions,ColumnSet,CurrSetLength,MatrixRecords);
    end;
}

