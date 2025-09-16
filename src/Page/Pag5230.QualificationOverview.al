#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5230 "Qualification Overview"
{
    Caption = 'Qualification Overview';
    DataCaptionExpression = '';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = Card;
    SaveValues = true;

    layout
    {
        area(content)
        {
            group("Matrix Options")
            {
                Caption = 'Matrix Options';
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
                    MatrixForm: Page "Qualification Overview Matrix";
                begin
                    MatrixForm.Load(MATRIX_CaptionSet,MatrixRecords);
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

    trigger OnOpenPage()
    begin
        MATRIX_GenerateColumnCaptions(Setwanted::Initial);
    end;

    var
        MatrixRecord: Record Qualification;
        MatrixRecords: array [32] of Record Qualification;
        MATRIX_CaptionSet: array [32] of Text[1024];
        PKFirstRecInCurrSet: Text[1024];
        MATRIX_CaptionRange: Text[1024];
        MatrixCaptions: Integer;
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
        RecRef.GetTable(MatrixRecord);
        RecRef.SetTable(MatrixRecord);

        MatrixMgt.GenerateMatrixData(RecRef,SetWanted,ArrayLen(MatrixRecords),1,PKFirstRecInCurrSet,
          MATRIX_CaptionSet,MATRIX_CaptionRange,MatrixCaptions);
        if MatrixCaptions > 0 then begin
          MatrixRecord.SetPosition(PKFirstRecInCurrSet);
          MatrixRecord.Find;
          repeat
            MatrixRecords[CurrentMatrixRecordOrdinal].Copy(MatrixRecord);
            CurrentMatrixRecordOrdinal := CurrentMatrixRecordOrdinal + 1;
          until (CurrentMatrixRecordOrdinal > MatrixCaptions) or (MatrixRecord.Next <> 1);
        end;
    end;
}

