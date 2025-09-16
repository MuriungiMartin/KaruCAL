#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 379 "Transfer Old Ext. Text Lines"
{

    trigger OnRun()
    begin
    end;

    var
        LineNoBuffer: Record "Line Number Buffer" temporary;

    local procedure InsertLineNumbers(OldLineNo: Integer;NewLineNo: Integer)
    begin
        LineNoBuffer."Old Line Number" := OldLineNo;
        LineNoBuffer."New Line Number" := NewLineNo;
        LineNoBuffer.Insert;
    end;


    procedure GetNewLineNumber(OldLineNo: Integer): Integer
    begin
        if LineNoBuffer.Get(OldLineNo) then
          exit(LineNoBuffer."New Line Number");

        exit(0);
    end;


    procedure ClearLineNumbers()
    begin
        LineNoBuffer.DeleteAll;
    end;


    procedure TransferExtendedText(OldLineNo: Integer;NewLineNo: Integer;AttachedLineNo: Integer): Integer
    begin
        InsertLineNumbers(OldLineNo,NewLineNo);
        if AttachedLineNo <> 0 then
          exit(GetNewLineNumber(AttachedLineNo));

        exit(0);
    end;
}

