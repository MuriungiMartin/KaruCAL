#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5747 "Transfer Routes"
{
    ApplicationArea = Basic;
    Caption = 'Transfer Routes';
    DataCaptionExpression = '';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = Card;
    SaveValues = true;
    SourceTable = Location;
    SourceTableView = where("Use As In-Transit"=const(false));
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            group(Options)
            {
                Caption = 'Options';
                field(Show;Show)
                {
                    ApplicationArea = Basic;
                    Caption = 'Show';
                    OptionCaption = 'In-Transit Code,Shipping Agent Code,Shipping Agent Service Code';
                }
                field(ShowTransferToName;ShowTransferToName)
                {
                    ApplicationArea = Basic;
                    Caption = 'Show Transfer-to Name';

                    trigger OnValidate()
                    begin
                        ShowTransferToNameOnAfterValid;
                    end;
                }
            }
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
                    MatrixForm: Page "Transfer Routes Matrix";
                begin
                    Clear(MatrixForm);
                    MatrixForm.Load(MATRIX_CaptionSet,MatrixRecords,MATRIX_CurrentNoOfColumns,Show);
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
                    MATRIX_GenerateColumnCaptions(Matrix_setwanted::Next);
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
                    MATRIX_GenerateColumnCaptions(Matrix_setwanted::Previous);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        MATRIX_MatrixRecord.SetRange("Use As In-Transit",false);
        MATRIX_GenerateColumnCaptions(Matrix_setwanted::First);
    end;

    var
        MATRIX_MatrixRecord: Record Location;
        MatrixRecords: array [32] of Record Location;
        MATRIX_CaptionSet: array [32] of Text[1024];
        MATRIX_CaptionRange: Text[1024];
        MATRIX_PKFirstRecInCurrSet: Text[1024];
        MATRIX_CurrentNoOfColumns: Integer;
        ShowTransferToName: Boolean;
        Show: Option "In-Transit Code","Shipping Agent Code","Shipping Agent Service Code";
        MATRIX_SetWanted: Option First,Previous,Same,Next;

    local procedure MATRIX_GenerateColumnCaptions(SetWanted: Option First,Previous,Same,Next)
    var
        MatrixMgt: Codeunit "Matrix Management";
        RecRef: RecordRef;
        CurrentMatrixRecordOrdinal: Integer;
        CaptionField: Integer;
    begin
        Clear(MATRIX_CaptionSet);
        Clear(MatrixRecords);
        CurrentMatrixRecordOrdinal := 1;

        RecRef.GetTable(MATRIX_MatrixRecord);
        RecRef.SetTable(MATRIX_MatrixRecord);

        if ShowTransferToName then
          CaptionField := 2
        else
          CaptionField := 1;

        MatrixMgt.GenerateMatrixData(RecRef,SetWanted,ArrayLen(MatrixRecords),CaptionField,MATRIX_PKFirstRecInCurrSet,MATRIX_CaptionSet
          ,MATRIX_CaptionRange,MATRIX_CurrentNoOfColumns);

        if MATRIX_CurrentNoOfColumns > 0 then begin
          MATRIX_MatrixRecord.SetPosition(MATRIX_PKFirstRecInCurrSet);
          MATRIX_MatrixRecord.Find;
          repeat
            MatrixRecords[CurrentMatrixRecordOrdinal].Copy(MATRIX_MatrixRecord);
            CurrentMatrixRecordOrdinal := CurrentMatrixRecordOrdinal + 1;
          until (CurrentMatrixRecordOrdinal > MATRIX_CurrentNoOfColumns) or (MATRIX_MatrixRecord.Next <> 1);
        end;
    end;

    local procedure ShowTransferToNameOnAfterValid()
    begin
        MATRIX_GenerateColumnCaptions(Matrix_setwanted::Same);
    end;
}

