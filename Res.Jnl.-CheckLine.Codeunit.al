#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 211 "Res. Jnl.-Check Line"
{
    TableNo = "Res. Journal Line";

    trigger OnRun()
    begin
        GLSetup.Get;
        RunCheck(Rec);
    end;

    var
        Text000: label 'cannot be a closing date';
        Text001: label 'is not within your range of allowed posting dates';
        Text002: label 'The combination of dimensions used in %1 %2, %3, %4 is blocked. %5';
        Text003: label 'A dimension used in %1 %2, %3, %4 has caused an error. %5';
        GLSetup: Record "General Ledger Setup";
        UserSetup: Record "User Setup";
        DimMgt: Codeunit DimensionManagement;
        TimeSheetMgt: Codeunit "Time Sheet Management";
        AllowPostingFrom: Date;
        AllowPostingTo: Date;


    procedure RunCheck(var ResJnlLine: Record "Res. Journal Line")
    var
        TableID: array [10] of Integer;
        No: array [10] of Code[20];
    begin
        with ResJnlLine do begin
          if EmptyLine then
            exit;

          TestField("Resource No.");
          TestField("Posting Date");
          TestField("Gen. Prod. Posting Group");

          if "Posting Date" <> NormalDate("Posting Date") then
            FieldError("Posting Date",Text000);

          if (AllowPostingFrom = 0D) and (AllowPostingTo = 0D) then begin
            if UserId <> '' then
              if UserSetup.Get(UserId) then begin
                AllowPostingFrom := UserSetup."Allow Posting From";
                AllowPostingTo := UserSetup."Allow Posting To";
              end;
            if (AllowPostingFrom = 0D) and (AllowPostingTo = 0D) then begin
              GLSetup.Get;
              AllowPostingFrom := GLSetup."Allow Posting From";
              AllowPostingTo := GLSetup."Allow Posting To";
            end;
            if AllowPostingTo = 0D then
              AllowPostingTo := Dmy2date(31,12,9999);
          end;
          if ("Posting Date" < AllowPostingFrom) or ("Posting Date" > AllowPostingTo) then
            FieldError("Posting Date",Text001);

          if "Document Date" <> 0D then
            if "Document Date" <> NormalDate("Document Date") then
              FieldError("Document Date",Text000);

          if ("Entry Type" = "entry type"::Usage) and ("Time Sheet No." <> '') then
            TimeSheetMgt.CheckResJnlLine(ResJnlLine);

          if not DimMgt.CheckDimIDComb("Dimension Set ID") then
            Error(
              Text002,
              TableCaption,"Journal Template Name","Journal Batch Name","Line No.",
              DimMgt.GetDimCombErr);

          TableID[1] := Database::Resource;
          No[1] := "Resource No.";
          TableID[2] := Database::"Resource Group";
          No[2] := "Resource Group No.";
          TableID[3] := Database::Job;
          No[3] := "Job No.";
          if not DimMgt.CheckDimValuePosting(TableID,No,"Dimension Set ID") then
            if "Line No." <> 0 then
              Error(
                Text003,
                TableCaption,"Journal Template Name","Journal Batch Name","Line No.",
                DimMgt.GetDimValuePostingErr)
            else
              Error(DimMgt.GetDimValuePostingErr);
        end;
    end;
}

