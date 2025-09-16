#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9291 "Work Center Calendar Matrix"
{
    Caption = 'Work Center Calendar Matrix';
    DataCaptionExpression = '';
    Editable = false;
    LinksAllowed = false;
    PageType = List;
    SourceTable = "Work Center";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the work center.';
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the work center.';
                }
                field(Field1;MATRIX_CellData[1])
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[1];
                    DecimalPlaces = 0:2;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(1);
                    end;
                }
                field(Field2;MATRIX_CellData[2])
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[2];
                    DecimalPlaces = 0:2;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(2);
                    end;
                }
                field(Field3;MATRIX_CellData[3])
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[3];
                    DecimalPlaces = 0:2;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(3);
                    end;
                }
                field(Field4;MATRIX_CellData[4])
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[4];
                    DecimalPlaces = 0:2;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(4);
                    end;
                }
                field(Field5;MATRIX_CellData[5])
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[5];
                    DecimalPlaces = 0:2;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(5);
                    end;
                }
                field(Field6;MATRIX_CellData[6])
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[6];
                    DecimalPlaces = 0:2;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(6);
                    end;
                }
                field(Field7;MATRIX_CellData[7])
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[7];
                    DecimalPlaces = 0:2;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(7);
                    end;
                }
                field(Field8;MATRIX_CellData[8])
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[8];
                    DecimalPlaces = 0:2;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(8);
                    end;
                }
                field(Field9;MATRIX_CellData[9])
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[9];
                    DecimalPlaces = 0:2;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(9);
                    end;
                }
                field(Field10;MATRIX_CellData[10])
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[10];
                    DecimalPlaces = 0:2;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(10);
                    end;
                }
                field(Field11;MATRIX_CellData[11])
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[11];
                    DecimalPlaces = 0:2;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(11);
                    end;
                }
                field(Field12;MATRIX_CellData[12])
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[12];
                    DecimalPlaces = 0:2;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(12);
                    end;
                }
                field(Field13;MATRIX_CellData[13])
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[13];
                    DecimalPlaces = 0:2;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(13);
                    end;
                }
                field(Field14;MATRIX_CellData[14])
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[14];
                    DecimalPlaces = 0:2;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(14);
                    end;
                }
                field(Field15;MATRIX_CellData[15])
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[15];
                    DecimalPlaces = 0:2;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(15);
                    end;
                }
                field(Field16;MATRIX_CellData[16])
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[16];
                    DecimalPlaces = 0:2;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(16);
                    end;
                }
                field(Field17;MATRIX_CellData[17])
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[17];
                    DecimalPlaces = 0:2;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(17);
                    end;
                }
                field(Field18;MATRIX_CellData[18])
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[18];
                    DecimalPlaces = 0:2;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(18);
                    end;
                }
                field(Field19;MATRIX_CellData[19])
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[19];
                    DecimalPlaces = 0:2;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(19);
                    end;
                }
                field(Field20;MATRIX_CellData[20])
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[20];
                    DecimalPlaces = 0:2;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(20);
                    end;
                }
                field(Field21;MATRIX_CellData[21])
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[21];
                    DecimalPlaces = 0:2;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(21);
                    end;
                }
                field(Field22;MATRIX_CellData[22])
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[22];
                    DecimalPlaces = 0:2;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(22);
                    end;
                }
                field(Field23;MATRIX_CellData[23])
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[23];
                    DecimalPlaces = 0:2;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(23);
                    end;
                }
                field(Field24;MATRIX_CellData[24])
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[24];
                    DecimalPlaces = 0:2;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(24);
                    end;
                }
                field(Field25;MATRIX_CellData[25])
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[25];
                    DecimalPlaces = 0:2;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(25);
                    end;
                }
                field(Field26;MATRIX_CellData[26])
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[26];
                    DecimalPlaces = 0:2;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(26);
                    end;
                }
                field(Field27;MATRIX_CellData[27])
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[27];
                    DecimalPlaces = 0:2;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(27);
                    end;
                }
                field(Field28;MATRIX_CellData[28])
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[28];
                    DecimalPlaces = 0:2;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(28);
                    end;
                }
                field(Field29;MATRIX_CellData[29])
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[29];
                    DecimalPlaces = 0:2;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(29);
                    end;
                }
                field(Field30;MATRIX_CellData[30])
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[30];
                    DecimalPlaces = 0:2;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(30);
                    end;
                }
                field(Field31;MATRIX_CellData[31])
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[31];
                    DecimalPlaces = 0:2;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(31);
                    end;
                }
                field(Field32;MATRIX_CellData[32])
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[32];
                    DecimalPlaces = 0:2;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(32);
                    end;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Wor&k Ctr.")
            {
                Caption = 'Wor&k Ctr.';
                Image = WorkCenter;
                action("Capacity Ledger E&ntries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Capacity Ledger E&ntries';
                    Image = CapacityLedger;
                    RunObject = Page "Capacity Ledger Entries";
                    RunPageLink = "Work Center No."=field("No."),
                                  "Posting Date"=field("Date Filter");
                    RunPageView = sorting("Work Center No.","Work Shift Code","Posting Date");
                    ShortCutKey = 'Ctrl+F7';
                }
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Manufacturing Comment Sheet";
                    RunPageLink = "No."=field("No.");
                    RunPageView = where("Table Name"=const("Work Center"));
                }
                action("Lo&ad")
                {
                    ApplicationArea = Basic;
                    Caption = 'Lo&ad';
                    Image = WorkCenterLoad;
                    RunObject = Page "Work Center Load";
                    RunPageLink = "No."=field("No.");
                    RunPageView = sorting("No.");
                }
                separator(Action12)
                {
                }
                action(Statistics)
                {
                    ApplicationArea = Basic;
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Work Center Statistics";
                    RunPageLink = "No."=field("No."),
                                  "Date Filter"=field("Date Filter"),
                                  "Work Shift Filter"=field("Work Shift Filter");
                    ShortCutKey = 'F7';
                }
            }
            group("Pla&nning")
            {
                Caption = 'Pla&nning';
                Image = Planning;
                action("A&bsence")
                {
                    ApplicationArea = Basic;
                    Caption = 'A&bsence';
                    Image = WorkCenterAbsence;
                    RunObject = Page "Capacity Absence";
                    RunPageLink = "Capacity Type"=const("Work Center"),
                                  "No."=field("No."),
                                  Date=field("Date Filter");
                    RunPageView = sorting("Capacity Type","No.",Date);
                }
                action("Ta&sk List")
                {
                    ApplicationArea = Basic;
                    Caption = 'Ta&sk List';
                    Image = TaskList;
                    RunObject = Page "Work Center Task List";
                    RunPageLink = Type=const("Work Center"),
                                  "No."=field("No."),
                                  "Routing Status"=filter(<>Finished);
                    RunPageView = sorting(Type,"No.","Starting Date");
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action(Calculate)
                {
                    ApplicationArea = Basic;
                    Caption = 'Calculate';
                    Ellipsis = true;
                    Image = Calculate;
                    RunObject = Report "Calculate Work Center Calendar";
                }
                action(Recalculate)
                {
                    ApplicationArea = Basic;
                    Caption = 'Recalculate';
                    Ellipsis = true;
                    Image = Refresh;

                    trigger OnAction()
                    var
                        Calendarentry: Record "Calendar Entry";
                    begin
                        Calendarentry.SetRange("Capacity Type",Calendarentry."capacity type"::"Work Center");
                        Report.RunModal(Report::"Recalculate Calendar",true,true,Calendarentry);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        MATRIX_CurrentColumnOrdinal: Integer;
    begin
        MATRIX_CurrentColumnOrdinal := 0;
        while MATRIX_CurrentColumnOrdinal < MATRIX_CurrentNoOfMatrixColumn do begin
          MATRIX_CurrentColumnOrdinal := MATRIX_CurrentColumnOrdinal + 1;
          MATRIX_OnAfterGetRecord(MATRIX_CurrentColumnOrdinal);
        end;
    end;

    trigger OnOpenPage()
    begin
        MATRIX_CurrentNoOfMatrixColumn := ArrayLen(MATRIX_CellData);
    end;

    var
        MatrixRecords: array [32] of Record Date;
        MATRIX_CurrentNoOfMatrixColumn: Integer;
        MATRIX_CellData: array [32] of Decimal;
        MATRIX_CaptionSet: array [32] of Text[1024];

    local procedure SetDateFilter(MATRIX_ColumnOrdinal: Integer)
    begin
        if MatrixRecords[MATRIX_ColumnOrdinal]."Period Start" = MatrixRecords[MATRIX_ColumnOrdinal]."Period End" then
          SetRange("Date Filter",MatrixRecords[MATRIX_ColumnOrdinal]."Period Start")
        else
          SetRange("Date Filter",MatrixRecords[MATRIX_ColumnOrdinal]."Period Start",MatrixRecords[MATRIX_ColumnOrdinal]."Period End")
    end;


    procedure Load(MatrixColumns1: array [32] of Text[1024];var MatrixRecords1: array [32] of Record Date;CurrentNoOfMatrixColumns: Integer)
    begin
        CopyArray(MATRIX_CaptionSet,MatrixColumns1,1);
        CopyArray(MatrixRecords,MatrixRecords1,1);
        MATRIX_CurrentNoOfMatrixColumn := CurrentNoOfMatrixColumns;
    end;

    local procedure MATRIX_OnDrillDown(MATRIX_ColumnOrdinal: Integer)
    var
        CalendarEntry: Record "Calendar Entry";
    begin
        CalendarEntry.SetRange("Capacity Type",CalendarEntry."capacity type"::"Work Center");
        CalendarEntry.SetRange("No.","No.");

        if MatrixRecords[MATRIX_ColumnOrdinal]."Period Start" = MatrixRecords[MATRIX_ColumnOrdinal]."Period End" then
          CalendarEntry.SetRange(Date,MatrixRecords[MATRIX_ColumnOrdinal]."Period Start")
        else
          CalendarEntry.SetRange(Date,
            MatrixRecords[MATRIX_ColumnOrdinal]."Period Start",MatrixRecords[MATRIX_ColumnOrdinal]."Period End");

        Page.RunModal(Page::"Calendar Entries",CalendarEntry);
    end;

    local procedure MATRIX_OnAfterGetRecord(MATRIX_ColumnOrdinal: Integer)
    begin
        SetDateFilter(MATRIX_ColumnOrdinal);
        CalcFields("Capacity (Effective)");
        MATRIX_CellData[MATRIX_ColumnOrdinal] := "Capacity (Effective)" ;
    end;
}

