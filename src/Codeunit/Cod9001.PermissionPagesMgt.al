#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 9001 "Permission Pages Mgt."
{

    trigger OnRun()
    begin
    end;

    var
        NoOfRecords: Integer;
        NoOfColumns: Integer;
        OffSet: Integer;


    procedure Init(NewNoOfRecords: Integer;NewNoOfColumns: Integer)
    begin
        OffSet := 0;
        NoOfRecords := NewNoOfRecords;
        NoOfColumns := NewNoOfColumns;
    end;


    procedure GetOffset(): Integer
    begin
        exit(OffSet);
    end;


    procedure AllColumnsLeft()
    begin
        OffSet -= NoOfColumns;
        if OffSet < 0 then
          OffSet := 0;
    end;


    procedure ColumnLeft()
    begin
        if OffSet > 0 then
          OffSet -= 1;
    end;


    procedure ColumnRight()
    begin
        if OffSet < NoOfRecords - NoOfColumns then
          OffSet += 1;
    end;


    procedure AllColumnsRight()
    begin
        OffSet += NoOfColumns;
        if OffSet > NoOfRecords - NoOfColumns then
          OffSet := NoOfRecords - NoOfColumns;
        if OffSet < 0 then
          OffSet := 0;
    end;


    procedure IsInColumnsRange(i: Integer): Boolean
    begin
        exit((i > OffSet) and (i <= OffSet + NoOfColumns));
    end;


    procedure IsPastColumnRange(i: Integer): Boolean
    begin
        exit(i >= OffSet + NoOfColumns);
    end;
}

