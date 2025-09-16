#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 844 "Cash Flow Wksh.-Register Batch"
{
    Permissions = TableData UnknownTableData845=imd;
    TableNo = "Cash Flow Worksheet Line";

    trigger OnRun()
    begin
        CFWkshLine.Copy(Rec);
        Code;
        Rec := CFWkshLine;
    end;

    var
        Text1002: label 'Checking lines         #2######\';
        Text1005: label 'Register lines         #3###### @4@@@@@@@@@@@@@';
        CFWkshLine: Record "Cash Flow Worksheet Line";
        LicPermission: Record "License Permission";
        CFWkshCheckLine: Codeunit "Cash Flow Wksh.- Check Line";
        Window: Dialog;
        StartLineNo: Integer;
        NoOfRecords: Integer;

    local procedure "Code"()
    var
        UpdateAnalysisView: Codeunit "Update Analysis View";
        Which: Option "Ledger Entries","Budget Entries",Both;
    begin
        with CFWkshLine do begin
          LockTable;

          if not Find('=><') then begin
            "Line No." := 0;
            Commit;
            exit;
          end;

          CreateWindow;

          CheckLines;
          RegisterLines;

          DeleteLines;

          Commit;
        end;

        LicPermission.Get(
          LicPermission."object type"::Codeunit,
          Codeunit::"Update Analysis View");
        if LicPermission."Execute Permission" = LicPermission."execute permission"::Yes then begin
          UpdateAnalysisView.UpdateAll(Which::"Ledger Entries",true);
          Commit;
        end;
    end;

    local procedure DeleteLines()
    var
        CFWkshLine2: Record "Cash Flow Worksheet Line";
    begin
        CFWkshLine2.Copy(CFWkshLine);
        CFWkshLine2.DeleteAll;
    end;

    local procedure CreateWindow()
    begin
        Window.Open(
          Text1002 +
          Text1005);
    end;

    local procedure CheckLines()
    var
        LineCount: Integer;
    begin
        with CFWkshLine do begin
          LineCount := 0;
          StartLineNo := "Line No.";
          repeat
            LineCount := LineCount + 1;
            Window.Update(2,LineCount);
            CFWkshCheckLine.RunCheck(CFWkshLine);
            if Next = 0 then
              Find('-');
          until "Line No." = StartLineNo;
          NoOfRecords := LineCount;
        end;
    end;

    local procedure RegisterLines()
    var
        LineCount: Integer;
    begin
        with CFWkshLine do begin
          LineCount := 0;
          Find('-');
          repeat
            LineCount := LineCount + 1;
            Window.Update(3,LineCount);
            Window.Update(4,ROUND(LineCount / NoOfRecords * 10000,1));
            Codeunit.Run(Codeunit::"Cash Flow Wksh. -Register Line",CFWkshLine);
          until Next = 0;
        end;
    end;
}

