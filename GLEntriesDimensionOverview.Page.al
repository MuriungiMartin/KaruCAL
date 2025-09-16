#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 563 "G/L Entries Dimension Overview"
{
    Caption = 'G/L Entries Dimension Overview';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SourceTable = "G/L Entry";

    layout
    {
        area(content)
        {
            group("Matrix Options")
            {
                Caption = 'Matrix Options';
                field(MATRIX_CaptionRange;MATRIX_CaptionRange)
                {
                    ApplicationArea = Suite;
                    Caption = 'Column Set';
                    Editable = false;
                    ToolTip = 'Specifies the range of values that are displayed in the matrix window, for example, the total period. To change the contents of the field, choose Next Set or Previous Set.';
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
                ApplicationArea = Suite;
                Caption = '&Show Matrix';
                Image = ShowMatrix;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'View the data overview according to the selected filters and options.';

                trigger OnAction()
                var
                    MatrixForm: Page "G/L Entries Dim. Overv. Matrix";
                begin
                    Clear(MatrixForm);
                    MatrixForm.Load(MATRIX_CaptionSet,MATRIX_PKFirstCaptionInCurrSet,MATRIX_CurrSetLength);
                    if RunOnTempRec then
                      MatrixForm.SetTempGLEntry(TempGLEntry)
                    else
                      MatrixForm.SetTableview(Rec);
                    MatrixForm.RunModal;
                end;
            }
            action("Next Set")
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
                    MATRIX_Step: Option First,Previous,Same,Next;
                begin
                    MATRIX_GenerateColumnCaptions(Matrix_step::Next);
                end;
            }
            action("Previous Set")
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
                    MATRIX_Step: Option First,Previous,Same,Next;
                begin
                    MATRIX_GenerateColumnCaptions(Matrix_step::Previous);
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        MATRIX_Step: Option First,Previous,Same,Next;
    begin
        MATRIX_GenerateColumnCaptions(Matrix_step::First);
    end;

    var
        MatrixRecord: Record Dimension;
        TempGLEntry: Record "G/L Entry" temporary;
        RunOnTempRec: Boolean;
        MATRIX_CaptionSet: array [32] of Text[1024];
        MATRIX_PKFirstCaptionInCurrSet: Text[1024];
        MATRIX_CaptionRange: Text[1024];
        MATRIX_CurrSetLength: Integer;


    procedure SetTempGLEntry(var NewGLEntry: Record "G/L Entry")
    begin
        RunOnTempRec := true;
        TempGLEntry.DeleteAll;
        if NewGLEntry.Find('-') then
          repeat
            TempGLEntry := NewGLEntry;
            TempGLEntry.Insert;
          until NewGLEntry.Next = 0;
    end;

    local procedure MATRIX_GenerateColumnCaptions(Step: Option First,Previous,Same,Next)
    var
        MatrixMgt: Codeunit "Matrix Management";
        RecRef: RecordRef;
    begin
        RecRef.GetTable(MatrixRecord);
        RecRef.SetTable(MatrixRecord);

        MatrixMgt.GenerateMatrixData(RecRef,Step,ArrayLen(MATRIX_CaptionSet)
          ,1,MATRIX_PKFirstCaptionInCurrSet,MATRIX_CaptionSet,MATRIX_CaptionRange,MATRIX_CurrSetLength);
    end;
}

