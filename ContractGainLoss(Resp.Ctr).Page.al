#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 6069 "Contract Gain/Loss (Resp.Ctr)"
{
    ApplicationArea = Basic;
    Caption = 'Contract Gain/Loss (Resp.Ctr)';
    DataCaptionExpression = '';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = Card;
    RefreshOnActivate = true;
    SaveValues = true;
    SourceTable = Date;
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(PeriodStart;PeriodStart)
                {
                    ApplicationArea = Basic;
                    Caption = 'Period Start';
                }
            }
            group(Filters)
            {
                Caption = 'Filters';
                field(RespCrFilter;RespCrFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Responsibility Center Filter';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        RespCrCode.Reset;
                        if Page.RunModal(0,RespCrCode) = Action::LookupOK then begin
                          Text := RespCrCode.Code;
                          exit(true);
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        MATRIX_GenerateColumnCaptions(Setwanted::Initial);
                        RespCrFilterOnAfterValidate;
                    end;
                }
            }
            group("Matrix Options")
            {
                Caption = 'Matrix Options';
                field(PeriodType;PeriodType)
                {
                    ApplicationArea = Basic;
                    Caption = 'View by';
                    OptionCaption = 'Day,Week,Month,Quarter,Year';
                    ToolTip = 'Specifies by which period amounts are displayed.';
                }
                field(AmountType;AmountType)
                {
                    ApplicationArea = Basic;
                    Caption = 'View as';
                    OptionCaption = 'Net Change,Balance at Date';
                    ToolTip = 'Specifies how amounts are displayed. Net Change: The net change in the balance for the selected period. Balance at Date: The balance as of the last day in the selected period.';
                }
                field(MATRIX_CaptionRange;MATRIX_CaptionRange)
                {
                    ApplicationArea = Basic;
                    Caption = 'Column Set';
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(ShowMatrix)
            {
                ApplicationArea = Basic;
                Caption = '&Show Matrix';
                Image = ShowMatrix;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    MatrixForm: Page "Contr. G/Loss (Res.Ctr) Matrix";
                begin
                    if PeriodStart = 0D then
                      PeriodStart := WorkDate;
                    Clear(MatrixForm);

                    MatrixForm.Load(MATRIX_CaptionSet,MatrixRecords,MATRIX_CurrentNoOfColumns,AmountType,PeriodType,
                      RespCrFilter,PeriodStart);
                    MatrixForm.RunModal;
                end;
            }
            action("Next Set")
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
                end;
            }
            action("Previous Set")
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
                end;
            }
        }
    }

    trigger OnFindRecord(Which: Text): Boolean
    begin
        exit(true);
    end;

    trigger OnOpenPage()
    begin
        if PeriodStart = 0D then
          PeriodStart := WorkDate;
        MATRIX_GenerateColumnCaptions(Setwanted::Initial);
    end;

    var
        MatrixRecords: array [32] of Record "Responsibility Center";
        MatrixRecord: Record "Responsibility Center";
        RespCrCode: Record "Responsibility Center";
        MATRIX_CaptionSet: array [32] of Text[1024];
        MATRIX_CaptionRange: Text[1024];
        PKFirstRecInCurrSet: Text[1024];
        MATRIX_CurrentNoOfColumns: Integer;
        AmountType: Option "Net Change","Balance at Date";
        PeriodType: Option Day,Week,Month,Quarter,Year;
        RespCrFilter: Text[250];
        PeriodStart: Date;
        SetWanted: Option Initial,Previous,Same,Next;

    local procedure MATRIX_GenerateColumnCaptions(SetWanted: Option First,Previous,Same,Next)
    var
        MatrixMgt: Codeunit "Matrix Management";
        RecRef: RecordRef;
        CurrentMatrixRecordOrdinal: Integer;
    begin
        Clear(MATRIX_CaptionSet);
        Clear(MatrixRecords);
        CurrentMatrixRecordOrdinal := 1;
        if RespCrFilter <> '' then
          MatrixRecord.SetFilter(Code,RespCrFilter)
        else
          MatrixRecord.SetRange(Code);

        RecRef.GetTable(MatrixRecord);
        RecRef.SetTable(MatrixRecord);

        MatrixMgt.GenerateMatrixData(RecRef,SetWanted,ArrayLen(MatrixRecords),1,PKFirstRecInCurrSet,
          MATRIX_CaptionSet,MATRIX_CaptionRange,MATRIX_CurrentNoOfColumns);
        if MATRIX_CurrentNoOfColumns > 0 then begin
          MatrixRecord.SetPosition(PKFirstRecInCurrSet);
          MatrixRecord.Find;
          repeat
            MatrixRecords[CurrentMatrixRecordOrdinal].Copy(MatrixRecord);
            CurrentMatrixRecordOrdinal := CurrentMatrixRecordOrdinal + 1;
          until (CurrentMatrixRecordOrdinal > MATRIX_CurrentNoOfColumns) or (MatrixRecord.Next <> 1);
        end;
    end;

    local procedure RespCrFilterOnAfterValidate()
    begin
        CurrPage.Update(true);
    end;
}

