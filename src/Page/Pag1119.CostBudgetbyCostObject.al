#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1119 "Cost Budget by Cost Object"
{
    Caption = 'Cost Budget by Cost Object';
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
                    OptionCaption = 'Day,Week,Month,Quarter,Year,Period';
                    ToolTip = 'Specifies by which period amounts are displayed.';

                    trigger OnValidate()
                    begin
                        FindPeriod('');
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
                        FindPeriod('');
                        UpdateMatrixSubform;
                    end;
                }
            }
            part(MatrixForm;"Cost Bdgt. per Object Matrix")
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
                action("By &Period")
                {
                    ApplicationArea = Basic;
                    Caption = 'By &Period';
                    Image = Calendar;
                    RunObject = Page "Cost Budget per Period";
                    RunPageOnRec = true;
                }
                action("By Cost &Center")
                {
                    ApplicationArea = Basic;
                    Caption = 'By Cost &Center';
                    Image = CostCenter;
                    RunObject = Page "Cost Budget by Cost Center";
                    RunPageOnRec = true;
                }
                separator(Action5)
                {
                }
                action("&Budget / Movement")
                {
                    ApplicationArea = Basic;
                    Caption = '&Budget / Movement';
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
                    MATRIX_GenerateColumnCaptions(Matrix_setwanted::Previous);
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
                    MATRIX_GenerateColumnCaptions(Matrix_setwanted::PreviousColumn);
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
                    MATRIX_GenerateColumnCaptions(Matrix_setwanted::NextColumn);
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
                    MATRIX_GenerateColumnCaptions(Matrix_setwanted::Next);
                    UpdateMatrixSubform;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        FindPeriod('');
        CostObjectMatrixRecord.SetCurrentkey("Sorting Order");
        MATRIX_CaptionFieldNo := 1;
        BudgetFilter := GetFilter("Budget Filter");
        MATRIX_GenerateColumnCaptions(Matrix_setwanted::Initial);
        UpdateMatrixSubform;
    end;

    var
        CostObjectMatrixRecords: array [12] of Record "Cost Object";
        CostObjectMatrixRecord: Record "Cost Object";
        MatrixMgt: Codeunit "Matrix Management";
        MatrixRecordRef: RecordRef;
        MATRIX_CaptionSet: array [12] of Text[80];
        MATRIX_CaptionRange: Text[80];
        MATRIX_PKFirstRecInCurrSet: Text[80];
        MATRIX_SetWanted: Option Initial,Previous,Same,Next,PreviousColumn,NextColumn;
        PeriodType: Option Day,Week,Month,Quarter,Year,"Accounting Period";
        RoundingFactor: Option "None","1","1000","1000000";
        AmountType: Option "Balance at Date","Net Change";
        MATRIX_CaptionFieldNo: Integer;
        CurrentMatrixRecordOrdinal: Integer;
        MATRIX_CurrSetLength: Integer;
        BudgetFilter: Code[10];

    local procedure MATRIX_GenerateColumnCaptions(MATRIX_NewSetWanted: Option Initial,Previous,Same,Next,PreviousColumn,NextColumn)
    begin
        Clear(MATRIX_CaptionSet);
        Clear(CostObjectMatrixRecords);
        CurrentMatrixRecordOrdinal := 1;

        CostObjectMatrixRecord.SetRange("Line Type",CostObjectMatrixRecord."line type"::"Cost Object");
        if CostObjectMatrixRecord.Find('-') then;

        MatrixRecordRef.GetTable(CostObjectMatrixRecord);
        MatrixRecordRef.SetTable(CostObjectMatrixRecord);

        MatrixMgt.GenerateMatrixData(MatrixRecordRef,MATRIX_NewSetWanted,ArrayLen(CostObjectMatrixRecords),MATRIX_CaptionFieldNo,
          MATRIX_PKFirstRecInCurrSet,MATRIX_CaptionSet,MATRIX_CaptionRange,MATRIX_CurrSetLength);

        if MATRIX_CurrSetLength > 0 then begin
          CostObjectMatrixRecord.SetPosition(MATRIX_PKFirstRecInCurrSet);
          CostObjectMatrixRecord.Get(CostObjectMatrixRecord.Code);
          repeat
            CostObjectMatrixRecords[CurrentMatrixRecordOrdinal].Copy(CostObjectMatrixRecord);
            CurrentMatrixRecordOrdinal := CurrentMatrixRecordOrdinal + 1;
          until (CurrentMatrixRecordOrdinal > MATRIX_CurrSetLength) or (CostObjectMatrixRecord.Next <> 1);
        end;
    end;

    local procedure FindPeriod(FindTxt: Code[3])
    var
        Calendar: Record Date;
        PeriodFormMgt: Codeunit PeriodFormManagement;
    begin
        if GetFilter("Date Filter") <> '' then begin
          Calendar.SetFilter("Period Start",GetFilter("Date Filter"));
          if not PeriodFormMgt.FindDate('+',Calendar,PeriodType) then
            PeriodFormMgt.FindDate('+',Calendar,Periodtype::Day);
          Calendar.SetRange("Period Start");
        end;
        PeriodFormMgt.FindDate(FindTxt,Calendar,PeriodType);
        if AmountType = Amounttype::"Net Change" then begin
          SetRange("Date Filter",Calendar."Period Start",Calendar."Period End");
          if GetRangeMin("Date Filter") = GetRangemax("Date Filter") then
            SetRange("Date Filter",GetRangeMin("Date Filter"));
        end else
          SetRange("Date Filter",0D,Calendar."Period End");
    end;

    local procedure UpdateMatrixSubform()
    begin
        CurrPage.MatrixForm.Page.Load(
          MATRIX_CaptionSet,CostObjectMatrixRecords,MATRIX_CurrSetLength,GetFilter("Date Filter"),BudgetFilter,RoundingFactor);
    end;
}

