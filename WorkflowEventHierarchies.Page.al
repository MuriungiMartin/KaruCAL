#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1506 "Workflow Event Hierarchies"
{
    ApplicationArea = Basic;
    Caption = 'Workflow Event Hierarchies';
    PageType = ListPlus;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            part(MatrixEventSubpage;"WF Event/Event Comb. Matrix")
            {
                ApplicationArea = Suite;
                Caption = 'Supported Events';
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
                begin
                    SetColumns(Setwanted::Previous);
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
                begin
                    SetColumns(Setwanted::Next);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        SetColumns(Setwanted::Initial);
    end;

    var
        MatrixManagement: Codeunit "Matrix Management";
        SetWanted: Option Initial,Previous,Same,Next,PreviousColumn,NextColumn;
        ColumnSetEvents: Text[1024];
        MATRIX_ColumnCaptions_Events: array [12] of Text[1024];
        PKFirstRecInCurrSetEvents: Text[1024];
        ColumnSetLengthEvents: Integer;

    local procedure SetColumns(SetWanted: Option)
    var
        WorkflowEvent: Record "Workflow Event";
        EventRecRef: RecordRef;
    begin
        EventRecRef.Open(Database::Allo);
        MatrixManagement.GenerateMatrixData(EventRecRef,SetWanted,ArrayLen(MATRIX_ColumnCaptions_Events),
          WorkflowEvent.FieldNo(Description),PKFirstRecInCurrSetEvents,MATRIX_ColumnCaptions_Events,
          ColumnSetEvents,ColumnSetLengthEvents);

        CurrPage.MatrixEventSubpage.Page.SetMatrixColumns(MATRIX_ColumnCaptions_Events,ColumnSetLengthEvents);
        CurrPage.Update(false);
    end;
}

