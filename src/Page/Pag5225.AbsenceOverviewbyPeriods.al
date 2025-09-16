#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5225 "Absence Overview by Periods"
{
    Caption = 'Absence Overview by Periods';
    DataCaptionExpression = '';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = Card;
    SaveValues = true;
    SourceTable = Employee;

    layout
    {
        area(content)
        {
            group(Options)
            {
                Caption = 'Options';
                field("Cause Of Absence Filter";CauseOfAbsenceFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Cause of Absence Filter';
                    TableRelation = "Cause of Absence";
                }
            }
            group("Matrix Options")
            {
                Caption = 'Matrix Options';
                field(PeriodType;PeriodType)
                {
                    ApplicationArea = Basic;
                    Caption = 'View by';
                    OptionCaption = 'Day,Week,Month,Quarter,Year,Accounting Period';
                    ToolTip = 'Specifies by which period amounts are displayed.';

                    trigger OnValidate()
                    begin
                        SetColumns(Setwanted::Initial);
                    end;
                }
                field(QtyType;QtyType)
                {
                    ApplicationArea = Basic;
                    Caption = 'View as';
                    OptionCaption = 'Net Change,Balance at Date';
                    ToolTip = 'Specifies how amounts are displayed. Net Change: The net change in the balance for the selected period. Balance at Date: The balance as of the last day in the selected period.';
                }
                field(ColumnSet;ColumnSet)
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
                    AbsOverviewByPeriodMatrix: Page "Abs. Overview by Period Matrix";
                begin
                    AbsOverviewByPeriodMatrix.Load(MatrixColumnCaptions,MatrixRecords,CauseOfAbsenceFilter,QtyType);
                    AbsOverviewByPeriodMatrix.RunModal;
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
                    SetColumns(Setwanted::Previous);
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
                    SetColumns(Setwanted::Next);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        SetColumns(Setwanted::Initial);
        if HasFilter then
          CauseOfAbsenceFilter := GetFilter("Cause of Absence Filter");
    end;

    var
        MatrixRecords: array [32] of Record Date;
        QtyType: Option "Balance at Date","Net Change";
        PeriodType: Option Day,Week,Month,Quarter,Year,"Accounting Period";
        CauseOfAbsenceFilter: Code[10];
        MatrixColumnCaptions: array [32] of Text[1024];
        ColumnSet: Text[1024];
        SetWanted: Option Initial,Previous,Same,Next;
        PKFirstRecInCurrSet: Text[100];
        CurrSetLength: Integer;


    procedure SetColumns(SetWanted: Option Initial,Previous,Same,Next)
    var
        MatrixMgt: Codeunit "Matrix Management";
    begin
        MatrixMgt.GeneratePeriodMatrixData(SetWanted,32,false,PeriodType,'',
          PKFirstRecInCurrSet,MatrixColumnCaptions,ColumnSet,CurrSetLength,MatrixRecords);
    end;
}

