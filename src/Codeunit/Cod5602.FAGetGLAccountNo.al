#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5602 "FA Get G/L Account No."
{

    trigger OnRun()
    begin
    end;

    var
        FAPostingGr: Record "FA Posting Group";
        GLAccNo: Code[20];


    procedure GetAccNo(var FALedgEntry: Record "FA Ledger Entry"): Code[20]
    begin
        with FALedgEntry do begin
          FAPostingGr.Get("FA Posting Group");
          GLAccNo := '';
          if "FA Posting Category" = "fa posting category"::" " then
            case "FA Posting Type" of
              "fa posting type"::"Acquisition Cost":
                begin
                  FAPostingGr.TestField("Acquisition Cost Account");
                  GLAccNo := FAPostingGr."Acquisition Cost Account";
                end;
              "fa posting type"::Depreciation:
                begin
                  FAPostingGr.TestField("Accum. Depreciation Account");
                  GLAccNo := FAPostingGr."Accum. Depreciation Account";
                end;
              "fa posting type"::"Write-Down":
                begin
                  FAPostingGr.TestField("Write-Down Account");
                  GLAccNo := FAPostingGr."Write-Down Account";
                end;
              "fa posting type"::Appreciation:
                begin
                  FAPostingGr.TestField("Appreciation Account");
                  GLAccNo := FAPostingGr."Appreciation Account";
                end;
              "fa posting type"::"Custom 1":
                begin
                  FAPostingGr.TestField("Custom 1 Account");
                  GLAccNo := FAPostingGr."Custom 1 Account";
                end;
              "fa posting type"::"Custom 2":
                begin
                  FAPostingGr.TestField("Custom 2 Account");
                  GLAccNo := FAPostingGr."Custom 2 Account";
                end;
              "fa posting type"::"Proceeds on Disposal":
                begin
                  FAPostingGr.TestField("Sales Acc. on Disp. (Gain)");
                  GLAccNo := FAPostingGr."Sales Acc. on Disp. (Gain)";
                end;
              "fa posting type"::"Gain/Loss":
                begin
                  if "Result on Disposal" = "result on disposal"::Gain then begin
                    FAPostingGr.TestField("Gains Acc. on Disposal");
                    GLAccNo := FAPostingGr."Gains Acc. on Disposal";
                  end;
                  if "Result on Disposal" = "result on disposal"::Loss then begin
                    FAPostingGr.TestField("Losses Acc. on Disposal");
                    GLAccNo := FAPostingGr."Losses Acc. on Disposal";
                  end;
                end;
            end;

          if "FA Posting Category" = "fa posting category"::Disposal then
            case "FA Posting Type" of
              "fa posting type"::"Acquisition Cost":
                begin
                  FAPostingGr.TestField("Acq. Cost Acc. on Disposal");
                  GLAccNo := FAPostingGr."Acq. Cost Acc. on Disposal";
                end;
              "fa posting type"::Depreciation:
                begin
                  FAPostingGr.TestField("Accum. Depr. Acc. on Disposal");
                  GLAccNo := FAPostingGr."Accum. Depr. Acc. on Disposal";
                end;
              "fa posting type"::"Write-Down":
                begin
                  FAPostingGr.TestField("Write-Down Acc. on Disposal");
                  GLAccNo := FAPostingGr."Write-Down Acc. on Disposal";
                end;
              "fa posting type"::Appreciation:
                begin
                  FAPostingGr.TestField("Appreciation Acc. on Disposal");
                  GLAccNo := FAPostingGr."Appreciation Acc. on Disposal";
                end;
              "fa posting type"::"Custom 1":
                begin
                  FAPostingGr.TestField("Custom 1 Account on Disposal");
                  GLAccNo := FAPostingGr."Custom 1 Account on Disposal";
                end;
              "fa posting type"::"Custom 2":
                begin
                  FAPostingGr.TestField("Custom 2 Account on Disposal");
                  GLAccNo := FAPostingGr."Custom 2 Account on Disposal";
                end;
              "fa posting type"::"Book Value on Disposal":
                begin
                  if "Result on Disposal" = "result on disposal"::Gain then begin
                    FAPostingGr.TestField("Book Val. Acc. on Disp. (Gain)");
                    GLAccNo := FAPostingGr."Book Val. Acc. on Disp. (Gain)";
                  end;
                  if "Result on Disposal" = "result on disposal"::Loss then begin
                    FAPostingGr.TestField("Book Val. Acc. on Disp. (Loss)");
                    GLAccNo := FAPostingGr."Book Val. Acc. on Disp. (Loss)";
                  end;
                  "Result on Disposal" := "result on disposal"::" ";
                end;
            end;

          if "FA Posting Category" = "fa posting category"::"Bal. Disposal" then
            case "FA Posting Type" of
              "fa posting type"::"Write-Down":
                begin
                  FAPostingGr.TestField("Write-Down Bal. Acc. on Disp.");
                  GLAccNo := FAPostingGr."Write-Down Bal. Acc. on Disp.";
                end;
              "fa posting type"::Appreciation:
                begin
                  FAPostingGr.TestField("Apprec. Bal. Acc. on Disp.");
                  GLAccNo := FAPostingGr."Apprec. Bal. Acc. on Disp.";
                end;
              "fa posting type"::"Custom 1":
                begin
                  FAPostingGr.TestField("Custom 1 Bal. Acc. on Disposal");
                  GLAccNo := FAPostingGr."Custom 1 Bal. Acc. on Disposal";
                end;
              "fa posting type"::"Custom 2":
                begin
                  FAPostingGr.TestField("Custom 2 Bal. Acc. on Disposal");
                  GLAccNo := FAPostingGr."Custom 2 Bal. Acc. on Disposal";
                end;
            end;
        end;
        exit(GLAccNo);
    end;


    procedure GetMaintenanceAccNo(var MaintenanceLedgEntry: Record "Maintenance Ledger Entry"): Code[20]
    begin
        FAPostingGr.Get(MaintenanceLedgEntry."FA Posting Group");
        FAPostingGr.TestField("Maintenance Expense Account");
        exit(FAPostingGr."Maintenance Expense Account");
    end;
}

