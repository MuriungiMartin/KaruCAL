#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9252 "MyDim Value Combinations"
{
    Caption = 'Dimension Value Combinations';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = Card;
    SaveValues = true;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(ShowColumnName;ShowColumnName)
                {
                    ApplicationArea = Suite;
                    Caption = 'Show Column Name';
                    ToolTip = 'Specifies that the names of columns are shown in the matrix window.';

                    trigger OnValidate()
                    begin
                        ShowColumnNameOnPush;
                    end;
                }
            }
            part(MatrixForm;"Dim. Value Combinations Matrix")
            {
                ApplicationArea = Suite;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(PreviousSet)
            {
                ApplicationArea = Suite;
                Caption = 'Previous Set';
                Image = PreviousSet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Go to the previous set of data.';

                trigger OnAction()
                var
                    Step: Option First,Previous,Same,Next;
                begin
                    MATRIX_GenerateColumnCaptions(Step::Previous);
                    UpdateMatrixSubform;
                end;
            }
            action(PreviousColumn)
            {
                ApplicationArea = Suite;
                Caption = 'Previous Column';
                Image = PreviousRecord;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Go to the previous column.';

                trigger OnAction()
                var
                    Step: Option First,Previous,Same,Next,PreviousColumn,NextColumn;
                begin
                    MATRIX_GenerateColumnCaptions(Step::PreviousColumn);
                    UpdateMatrixSubform;
                end;
            }
            action(NextColumn)
            {
                ApplicationArea = Suite;
                Caption = 'Next Column';
                Image = NextRecord;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Go to the next column.';

                trigger OnAction()
                var
                    Step: Option First,Previous,Same,Next,PreviousColumn,NextColumn;
                begin
                    // SetPoints(3);
                    MATRIX_GenerateColumnCaptions(Step::NextColumn);
                    UpdateMatrixSubform;
                end;
            }
            action(NextSet)
            {
                ApplicationArea = Suite;
                Caption = 'Next Set';
                Image = NextSet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Go to the next set of data.';

                trigger OnAction()
                var
                    Step: Option First,Previous,Same,Next;
                begin
                    // SetPoints(3);
                    MATRIX_GenerateColumnCaptions(Step::Next);
                    UpdateMatrixSubform;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        MaximumNoOfCaptions := ArrayLen(MATRIX_CaptionSet);
        MATRIX_GenerateColumnCaptions(Matrix_setwanted::Initial);
        UpdateMatrixSubform;
    end;

    var
        MatrixRecords: array [32] of Record "Dimension Value";
        MatrixRecord: Record "Dimension Value";
        MatrixMgm: Codeunit "Matrix Management";
        MATRIX_CaptionSet: array [32] of Text[1024];
        MATRIX_ColumnSet: Text[1024];
        MATRIX_CaptionFieldNo: Integer;
        ShowColumnName: Boolean;
        MaximumNoOfCaptions: Integer;
        PrimaryKeyFirstCaptionInCurrSe: Text[1024];
        Row: Code[20];
        MATRIX_CurrSetLength: Integer;
        MATRIX_SetWanted: Option Initial,Previous,Same,Next;


    procedure Load(_Row: Code[20];_Column: Code[20];_ShowColumnName: Boolean)
    begin
        Row := _Row;
        ShowColumnName := _ShowColumnName;
        MatrixRecord.SetRange("Dimension Code",_Column);
    end;

    local procedure MATRIX_GenerateColumnCaptions(SetWanted: Option Initial,Previous,Same,Next,PreviousColumn,NextColumn)
    var
        RecRef: RecordRef;
        CurrentMatrixRecordOrdinal: Integer;
    begin
        RecRef.GetTable(MatrixRecord);
        if ShowColumnName then
          MATRIX_CaptionFieldNo := 3
        else
          MATRIX_CaptionFieldNo := 2;

        MatrixMgm.GenerateMatrixData(RecRef,SetWanted,MaximumNoOfCaptions,MATRIX_CaptionFieldNo,PrimaryKeyFirstCaptionInCurrSe,
          MATRIX_CaptionSet,MATRIX_ColumnSet,MATRIX_CurrSetLength);
        Clear(MatrixRecords);
        MatrixRecord.SetPosition(PrimaryKeyFirstCaptionInCurrSe);
        repeat
          CurrentMatrixRecordOrdinal += 1;
          MatrixRecords[CurrentMatrixRecordOrdinal].Copy(MatrixRecord);
        until (CurrentMatrixRecordOrdinal = ArrayLen(MatrixRecords)) or (MatrixRecord.Next <> 1);
    end;

    local procedure UpdateMatrixSubform()
    begin
        CurrPage.MatrixForm.Page.Load(MATRIX_CaptionSet,MatrixRecords,Row,MATRIX_CurrSetLength);
        CurrPage.Update(false);
    end;

    local procedure ShowColumnNameOnPush()
    begin
        MATRIX_GenerateColumnCaptions(Matrix_setwanted::Same);
        UpdateMatrixSubform;
    end;
}

