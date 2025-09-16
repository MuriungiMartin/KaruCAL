#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5639 "FA Get Journal"
{

    trigger OnRun()
    begin
    end;

    var
        Text000: label 'You cannot duplicate using the current journal. Check the table %1.';
        DeprBook: Record "Depreciation Book";
        FAJnlSetup: Record "FA Journal Setup";
        FAJnlTemplate: Record "FA Journal Template";
        FAJnlBatch: Record "FA Journal Batch";
        GenJnlTemplate: Record "Gen. Journal Template";
        GenJnlBatch: Record "Gen. Journal Batch";
        InsuranceJnlTempl: Record "Insurance Journal Template";
        InsuranceJnlBatch: Record "Insurance Journal Batch";
        TemplateName2: Code[10];
        BatchName2: Code[10];


    procedure JnlName(DeprBookCode: Code[10];BudgetAsset: Boolean;FAPostingType: Option "Acquisition Cost",Depreciation,"Write-Down",Appreciation,"Custom 1","Custom 2",Disposal,Maintenance,"Salvage Value";var GLIntegration: Boolean;var TemplateName: Code[10];var BatchName: Code[10])
    var
        GLIntegration2: Boolean;
    begin
        DeprBook.Get(DeprBookCode);
        if not FAJnlSetup.Get(DeprBookCode,UserId) then
          FAJnlSetup.Get(DeprBookCode,'');
        GLIntegration2 := GLIntegration;
        GLIntegration := CalcGLIntegration(BudgetAsset,FAPostingType);
        BatchName2 := BatchName;
        TemplateName2 := TemplateName;
        if GLIntegration then begin
          FAJnlSetup.TestField("Gen. Jnl. Template Name");
          FAJnlSetup.TestField("Gen. Jnl. Batch Name");
          TemplateName := FAJnlSetup."Gen. Jnl. Template Name";
          BatchName := FAJnlSetup."Gen. Jnl. Batch Name";
          GenJnlTemplate.Get(TemplateName);
          GenJnlBatch.Get(TemplateName,BatchName);
        end else begin
          FAJnlSetup.TestField("FA Jnl. Batch Name");
          FAJnlSetup.TestField("FA Jnl. Template Name");
          TemplateName := FAJnlSetup."FA Jnl. Template Name";
          BatchName := FAJnlSetup."FA Jnl. Batch Name";
          FAJnlTemplate.Get(TemplateName);
          FAJnlBatch.Get(TemplateName,BatchName);
        end;
        if (GLIntegration = GLIntegration2) and
           (BatchName = BatchName2) and
           (TemplateName = TemplateName2)
        then
          Error(Text000,FAJnlSetup.TableCaption);
    end;


    procedure InsuranceJnlName(DeprBookCode: Code[10];var TemplateName: Code[10];var BatchName: Code[10])
    begin
        DeprBook.Get(DeprBookCode);
        if not FAJnlSetup.Get(DeprBookCode,UserId) then
          FAJnlSetup.Get(DeprBookCode,'');
        FAJnlSetup.TestField("Insurance Jnl. Template Name");
        FAJnlSetup.TestField("Insurance Jnl. Batch Name");
        BatchName := FAJnlSetup."Insurance Jnl. Batch Name";
        TemplateName := FAJnlSetup."Insurance Jnl. Template Name";
        InsuranceJnlTempl.Get(TemplateName);
        InsuranceJnlBatch.Get(TemplateName,BatchName);
    end;


    procedure SetGenJnlRange(var GenJnlLine: Record "Gen. Journal Line";TemplateName: Code[10];BatchName: Code[10])
    begin
        with GenJnlLine do begin
          Reset;
          "Journal Template Name" := TemplateName;
          "Journal Batch Name" := BatchName;
          SetRange("Journal Template Name",TemplateName);
          SetRange("Journal Batch Name",BatchName);
          if Find('+') then ;
          Init;
        end;
    end;


    procedure SetFAJnlRange(var FAJnlLine: Record "FA Journal Line";TemplateName: Code[10];BatchName: Code[10])
    begin
        with FAJnlLine do begin
          Reset;
          "Journal Template Name" := TemplateName;
          "Journal Batch Name" := BatchName;
          SetRange("Journal Template Name",TemplateName);
          SetRange("Journal Batch Name",BatchName);
          if Find('+') then ;
          Init;
        end;
    end;


    procedure SetInsuranceJnlRange(var InsuranceJnlLine: Record "Insurance Journal Line";TemplateName: Code[10];BatchName: Code[10])
    begin
        with InsuranceJnlLine do begin
          Reset;
          "Journal Template Name" := TemplateName;
          "Journal Batch Name" := BatchName;
          SetRange("Journal Template Name",TemplateName);
          SetRange("Journal Batch Name",BatchName);
          if Find('+') then ;
          Init;
        end;
    end;

    local procedure CalcGLIntegration(BudgetAsset: Boolean;FAPostingType: Option "Acquisition Cost",Depreciation,"Write-Down",Appreciation,"Custom 1","Custom 2",Disposal,Maintenance,"Salvage Value"): Boolean
    begin
        if BudgetAsset then
          exit(false);
        with DeprBook do
          case FAPostingType of
            Fapostingtype::"Acquisition Cost":
              exit("G/L Integration - Acq. Cost");
            Fapostingtype::Depreciation:
              exit("G/L Integration - Depreciation");
            Fapostingtype::"Write-Down":
              exit("G/L Integration - Write-Down");
            Fapostingtype::Appreciation:
              exit("G/L Integration - Appreciation");
            Fapostingtype::"Custom 1":
              exit("G/L Integration - Custom 1");
            Fapostingtype::"Custom 2":
              exit("G/L Integration - Custom 2");
            Fapostingtype::Disposal:
              exit("G/L Integration - Disposal");
            Fapostingtype::Maintenance:
              exit("G/L Integration - Maintenance");
            Fapostingtype::"Salvage Value":
              exit(false);
          end;
    end;
}

