#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 214 "Res. Group Capacity"
{
    ApplicationArea = Basic;
    Caption = 'Res. Group Capacity';
    DataCaptionExpression = '';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = false;
    PageType = ListPlus;
    SaveValues = true;
    SourceTable = "Resource Group";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            group("Matrix Options")
            {
                Caption = 'Matrix Options';
                field(PeriodType;PeriodType)
                {
                    ApplicationArea = Jobs;
                    Caption = 'View by';
                    OptionCaption = 'Day,Week,Month,Quarter,Year,Accounting Period';
                    ToolTip = 'Specifies by which period amounts are displayed.';

                    trigger OnValidate()
                    begin
                        SetColumns(Setwanted::Initial);
                        UpdateMatrixSubform;
                    end;
                }
                field(QtyType;QtyType)
                {
                    ApplicationArea = Jobs;
                    Caption = 'View as';
                    OptionCaption = 'Net Change,Balance at Date';
                    ToolTip = 'Specifies how amounts are displayed. Net Change: The net change in the balance for the selected period. Balance at Date: The balance as of the last day in the selected period.';

                    trigger OnValidate()
                    begin
                        UpdateMatrixSubform;
                    end;
                }
            }
            part(MatrixForm;"Res. Group Capacity Matrix")
            {
                ApplicationArea = Jobs;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Previous Set")
            {
                ApplicationArea = Jobs;
                Caption = 'Previous Set';
                Image = PreviousSet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Go to the previous set of data.';

                trigger OnAction()
                begin
                    SetColumns(Setwanted::Previous);
                    UpdateMatrixSubform;
                end;
            }
            action("Previous Column")
            {
                ApplicationArea = Jobs;
                Caption = 'Previous Column';
                Image = PreviousRecord;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Go to the previous column.';

                trigger OnAction()
                begin
                    SetColumns(Setwanted::PreviousColumn);
                    UpdateMatrixSubform;
                end;
            }
            action("Next Column")
            {
                ApplicationArea = Jobs;
                Caption = 'Next Column';
                Image = NextRecord;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Go to the next column.';

                trigger OnAction()
                begin
                    SetColumns(Setwanted::NextColumn);
                    UpdateMatrixSubform;
                end;
            }
            action("Next Set")
            {
                ApplicationArea = Jobs;
                Caption = 'Next Set';
                Image = NextSet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Go to the next set of data.';

                trigger OnAction()
                begin
                    SetColumns(Setwanted::Next);
                    UpdateMatrixSubform;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        SetColumns(Setwanted::Initial);
        UpdateMatrixSubform;
    end;

    var
        MatrixRecords: array [32] of Record Date;
        PeriodType: Option Day,Week,Month,Quarter,Year,"Accounting Period";
        QtyType: Option "Net Change","Balance at Date";
        MatrixColumnCaptions: array [32] of Text[1024];
        ColumnSet: Text[1024];
        SetWanted: Option Initial,Previous,Same,Next,PreviousColumn,NextColumn;
        PKFirstRecInCurrSet: Text[100];
        CurrSetLength: Integer;


    procedure SetColumns(SetWanted: Option Initial,Previous,Same,Next,PreviousColumn,NextColumn)
    var
        MatrixMgt: Codeunit "Matrix Management";
    begin
        MatrixMgt.GeneratePeriodMatrixData(SetWanted,12,false,PeriodType,'',
          PKFirstRecInCurrSet,MatrixColumnCaptions,ColumnSet,CurrSetLength,MatrixRecords);
    end;

    local procedure UpdateMatrixSubform()
    begin
        CurrPage.MatrixForm.Page.Load(PeriodType,QtyType,MatrixColumnCaptions,MatrixRecords);
        CurrPage.Update(false);
    end;
}

