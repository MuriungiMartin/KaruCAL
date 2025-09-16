#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1507 "WF Event/Response Combinations"
{
    ApplicationArea = Basic;
    Caption = 'Workflow Event/Response Combinations';
    PageType = ListPlus;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            part(MatrixResponseSubpage;"WF Event/Response Comb. Matrix")
            {
                ApplicationArea = Suite;
                Caption = 'Supported Responses';
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
        ColumnSetResponses: Text[1024];
        MATRIX_ColumnCaptions_Responses: array [12] of Text[1024];
        PKFirstRecInCurrSetResponses: Text[1024];
        ColumnSetLengthResponses: Integer;

    local procedure SetColumns(SetWanted: Option)
    var
        WorkflowResponse: Record "Workflow Response";
        ResponseRecRef: RecordRef;
    begin
        ResponseRecRef.Open(Database::"Workflow Response");
        MatrixManagement.GenerateMatrixData(ResponseRecRef,SetWanted,ArrayLen(MATRIX_ColumnCaptions_Responses),
          WorkflowResponse.FieldNo(Description),PKFirstRecInCurrSetResponses,MATRIX_ColumnCaptions_Responses,
          ColumnSetResponses,ColumnSetLengthResponses);

        CurrPage.MatrixResponseSubpage.Page.SetMatrixColumns(MATRIX_ColumnCaptions_Responses,ColumnSetLengthResponses);
        CurrPage.Update(false);
    end;
}

