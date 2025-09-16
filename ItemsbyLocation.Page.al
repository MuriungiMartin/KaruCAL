#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 491 "Items by Location"
{
    Caption = 'Items by Location';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = Card;
    SaveValues = true;
    SourceTable = Item;

    layout
    {
        area(content)
        {
            group(Options)
            {
                Caption = 'Options';
                field(ShowInTransit;ShowInTransit)
                {
                    ApplicationArea = Basic;
                    Caption = 'Show Items in Transit';

                    trigger OnValidate()
                    begin
                        ShowInTransitOnAfterValidate;
                    end;
                }
                field(ShowColumnName;ShowColumnName)
                {
                    ApplicationArea = Basic;
                    Caption = 'Show Column Name';

                    trigger OnValidate()
                    begin
                        ShowColumnNameOnAfterValidate;
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
                Caption = 'Show Matrix';
                Image = ShowMatrix;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ItemsByLocationMatrix: Page "Items by Location Matrix";
                begin
                    ItemsByLocationMatrix.Load(MATRIX_CaptionSet,MatrixRecords,MatrixRecord);
                    ItemsByLocationMatrix.SetRecord(Rec);
                    ItemsByLocationMatrix.RunModal;
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
                    SetColumns(Matrix_setwanted::Previous);
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
                    SetColumns(Matrix_setwanted::Next);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        SetColumns(Matrix_setwanted::Initial);
    end;

    var
        MatrixRecord: Record Location;
        MatrixRecords: array [32] of Record Location;
        MatrixRecordRef: RecordRef;
        MATRIX_SetWanted: Option Initial,Previous,Same,Next;
        ShowColumnName: Boolean;
        ShowInTransit: Boolean;
        MATRIX_CaptionSet: array [32] of Text[1024];
        MATRIX_CaptionRange: Text[100];
        MATRIX_PKFirstRecInCurrSet: Text[100];
        MATRIX_CurrSetLength: Integer;


    procedure SetColumns(SetWanted: Option Initial,Previous,Same,Next)
    var
        MatrixMgt: Codeunit "Matrix Management";
        CaptionFieldNo: Integer;
        CurrentMatrixRecordOrdinal: Integer;
    begin
        MatrixRecord.SetRange("Use As In-Transit",ShowInTransit);

        Clear(MATRIX_CaptionSet);
        Clear(MatrixRecords);
        CurrentMatrixRecordOrdinal := 1;

        MatrixRecordRef.GetTable(MatrixRecord);
        MatrixRecordRef.SetTable(MatrixRecord);

        if ShowColumnName then
          CaptionFieldNo := MatrixRecord.FieldNo(Name)
        else
          CaptionFieldNo := MatrixRecord.FieldNo(Code);

        MatrixMgt.GenerateMatrixData(MatrixRecordRef,SetWanted,ArrayLen(MatrixRecords),CaptionFieldNo,MATRIX_PKFirstRecInCurrSet,
          MATRIX_CaptionSet,MATRIX_CaptionRange,MATRIX_CurrSetLength);

        if MATRIX_CurrSetLength > 0 then begin
          MatrixRecord.SetPosition(MATRIX_PKFirstRecInCurrSet);
          MatrixRecord.Find;
          repeat
            MatrixRecords[CurrentMatrixRecordOrdinal].Copy(MatrixRecord);
            CurrentMatrixRecordOrdinal := CurrentMatrixRecordOrdinal + 1;
          until (CurrentMatrixRecordOrdinal > MATRIX_CurrSetLength) or (MatrixRecord.Next <> 1);
        end;
    end;

    local procedure ShowColumnNameOnAfterValidate()
    begin
        SetColumns(Matrix_setwanted::Same);
    end;

    local procedure ShowInTransitOnAfterValidate()
    begin
        SetColumns(Matrix_setwanted::Initial);
    end;
}

