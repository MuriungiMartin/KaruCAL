#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5802 "Inventory Posting To G/L"
{
    Permissions = TableData "Invt. Posting Buffer"=rimd,
                  TableData "Value Entry"=r,
                  TableData "G/L - Item Ledger Relation"=rimd;
    TableNo = "Value Entry";

    trigger OnRun()
    var
        GenJnlLine: Record "Gen. Journal Line";
    begin
        if GlobalPostPerPostGroup then
          PostInvtPostBuf(Rec,"Document No.",'','',true)
        else
          PostInvtPostBuf(
            Rec,
            "Document No.",
            "External Document No.",
            CopyStr(
              StrSubstNo(Text000,"Entry Type","Source No.","Posting Date"),
              1,MaxStrLen(GenJnlLine.Description)),
            false);
    end;

    var
        GLSetup: Record "General Ledger Setup";
        InvtSetup: Record "Inventory Setup";
        Currency: Record Currency;
        SourceCodeSetup: Record "Source Code Setup";
        GlobalInvtPostBuf: Record "Invt. Posting Buffer" temporary;
        TempInvtPostBuf: array [4] of Record "Invt. Posting Buffer" temporary;
        TempInvtPostToGLTestBuf: Record "Invt. Post to G/L Test Buffer" temporary;
        TempGLItemLedgRelation: Record "G/L - Item Ledger Relation" temporary;
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        GenJnlCheckLine: Codeunit "Gen. Jnl.-Check Line";
        DimBufMgt: Codeunit "Dimension Buffer Management";
        DimMgt: Codeunit DimensionManagement;
        COGSAmt: Decimal;
        InvtAdjmtAmt: Decimal;
        DirCostAmt: Decimal;
        OvhdCostAmt: Decimal;
        VarPurchCostAmt: Decimal;
        VarMfgDirCostAmt: Decimal;
        VarMfgOvhdCostAmt: Decimal;
        WIPInvtAmt: Decimal;
        InvtAmt: Decimal;
        TotalCOGSAmt: Decimal;
        TotalInvtAdjmtAmt: Decimal;
        TotalDirCostAmt: Decimal;
        TotalOvhdCostAmt: Decimal;
        TotalVarPurchCostAmt: Decimal;
        TotalVarMfgDirCostAmt: Decimal;
        TotalVarMfgOvhdCostAmt: Decimal;
        TotalWIPInvtAmt: Decimal;
        TotalInvtAmt: Decimal;
        GlobalInvtPostBufEntryNo: Integer;
        PostBufDimNo: Integer;
        GLSetupRead: Boolean;
        SourceCodeSetupRead: Boolean;
        InvtSetupRead: Boolean;
        Text000: label '%1 %2 on %3';
        Text001: label '%1 - %2, %3,%4,%5,%6';
        Text002: label 'The following combination %1 = %2, %3 = %4, and %5 = %6 is not allowed.';
        RunOnlyCheck: Boolean;
        RunOnlyCheckSaved: Boolean;
        CalledFromItemPosting: Boolean;
        CalledFromTestReport: Boolean;
        GlobalPostPerPostGroup: Boolean;
        Text003: label '%1 %2';


    procedure Initialize(PostPerPostGroup: Boolean)
    begin
        GlobalPostPerPostGroup := PostPerPostGroup;
        GlobalInvtPostBufEntryNo := 0;
    end;


    procedure SetRunOnlyCheck(SetCalledFromItemPosting: Boolean;SetCheckOnly: Boolean;SetCalledFromTestReport: Boolean)
    begin
        CalledFromItemPosting := SetCalledFromItemPosting;
        RunOnlyCheck := SetCheckOnly;
        CalledFromTestReport := SetCalledFromTestReport;

        TempGLItemLedgRelation.Reset;
        TempGLItemLedgRelation.DeleteAll;
    end;


    procedure BufferInvtPosting(var ValueEntry: Record "Value Entry"): Boolean
    var
        CostToPost: Decimal;
        CostToPostACY: Decimal;
        ExpCostToPost: Decimal;
        ExpCostToPostACY: Decimal;
        PostToGL: Boolean;
    begin
        with ValueEntry do begin
          GetGLSetup;
          GetInvtSetup;
          if (not InvtSetup."Expected Cost Posting to G/L") and
             ("Expected Cost Posted to G/L" = 0) and
             "Expected Cost"
          then
            exit(false);

          if not ("Entry Type" in ["entry type"::"Direct Cost","entry type"::Revaluation]) and
             not CalledFromTestReport
          then begin
            TestField("Expected Cost",false);
            TestField("Cost Amount (Expected)",0);
            TestField("Cost Amount (Expected) (ACY)",0);
          end;

          if InvtSetup."Expected Cost Posting to G/L" then begin
            CalcCostToPost(ExpCostToPost,"Cost Amount (Expected)","Expected Cost Posted to G/L",PostToGL);
            CalcCostToPost(ExpCostToPostACY,"Cost Amount (Expected) (ACY)","Exp. Cost Posted to G/L (ACY)",PostToGL);
          end;
          CalcCostToPost(CostToPost,"Cost Amount (Actual)","Cost Posted to G/L",PostToGL);
          CalcCostToPost(CostToPostACY,"Cost Amount (Actual) (ACY)","Cost Posted to G/L (ACY)",PostToGL);
          PostBufDimNo := 0;

          RunOnlyCheckSaved := RunOnlyCheck;
          if not PostToGL then
            exit(false);

          case "Item Ledger Entry Type" of
            "item ledger entry type"::Purchase:
              BufferPurchPosting(ValueEntry,CostToPost,CostToPostACY,ExpCostToPost,ExpCostToPostACY);
            "item ledger entry type"::Sale:
              BufferSalesPosting(ValueEntry,CostToPost,CostToPostACY,ExpCostToPost,ExpCostToPostACY);
            "item ledger entry type"::"Positive Adjmt.",
            "item ledger entry type"::"Negative Adjmt.",
            "item ledger entry type"::Transfer:
              BufferAdjmtPosting(ValueEntry,CostToPost,CostToPostACY,ExpCostToPost,ExpCostToPostACY);
            "item ledger entry type"::Consumption:
              BufferConsumpPosting(ValueEntry,CostToPost,CostToPostACY);
            "item ledger entry type"::Output:
              BufferOutputPosting(ValueEntry,CostToPost,CostToPostACY,ExpCostToPost,ExpCostToPostACY);
            "item ledger entry type"::"Assembly Consumption":
              BufferAsmConsumpPosting(ValueEntry,CostToPost,CostToPostACY);
            "item ledger entry type"::"Assembly Output":
              BufferAsmOutputPosting(ValueEntry,CostToPost,CostToPostACY);
            "item ledger entry type"::" ":
              BufferCapPosting(ValueEntry,CostToPost,CostToPostACY);
            else
              ErrorNonValidCombination(ValueEntry);
          end;
        end;

        if UpdateGlobalInvtPostBuf(ValueEntry."Entry No.") then
          exit(true);
        exit(CalledFromTestReport);
    end;

    local procedure BufferPurchPosting(ValueEntry: Record "Value Entry";CostToPost: Decimal;CostToPostACY: Decimal;ExpCostToPost: Decimal;ExpCostToPostACY: Decimal)
    begin
        with ValueEntry do
          case "Entry Type" of
            "entry type"::"Direct Cost":
              begin
                if (ExpCostToPost <> 0) or (ExpCostToPostACY <> 0) then
                  InitInvtPostBuf(
                    ValueEntry,
                    GlobalInvtPostBuf."account type"::"Inventory (Interim)",
                    GlobalInvtPostBuf."account type"::"Invt. Accrual (Interim)",
                    ExpCostToPost,ExpCostToPostACY,true);
                if (CostToPost <> 0) or (CostToPostACY <> 0) then
                  InitInvtPostBuf(
                    ValueEntry,
                    GlobalInvtPostBuf."account type"::Inventory,
                    GlobalInvtPostBuf."account type"::"Direct Cost Applied",
                    CostToPost,CostToPostACY,false);
              end;
            "entry type"::"Indirect Cost":
              InitInvtPostBuf(
                ValueEntry,
                GlobalInvtPostBuf."account type"::Inventory,
                GlobalInvtPostBuf."account type"::"Overhead Applied",
                CostToPost,CostToPostACY,false);
            "entry type"::Variance:
              begin
                TestField("Variance Type","variance type"::Purchase);
                InitInvtPostBuf(
                  ValueEntry,
                  GlobalInvtPostBuf."account type"::Inventory,
                  GlobalInvtPostBuf."account type"::"Purchase Variance",
                  CostToPost,CostToPostACY,false);
              end;
            "entry type"::Revaluation:
              begin
                if (ExpCostToPost <> 0) or (ExpCostToPostACY <> 0) then
                  InitInvtPostBuf(
                    ValueEntry,
                    GlobalInvtPostBuf."account type"::"Inventory (Interim)",
                    GlobalInvtPostBuf."account type"::"Invt. Accrual (Interim)",
                    ExpCostToPost,ExpCostToPostACY,true);
                if (CostToPost <> 0) or (CostToPostACY <> 0) then
                  InitInvtPostBuf(
                    ValueEntry,
                    GlobalInvtPostBuf."account type"::Inventory,
                    GlobalInvtPostBuf."account type"::"Inventory Adjmt.",
                    CostToPost,CostToPostACY,false);
              end;
            "entry type"::Rounding:
              InitInvtPostBuf(
                ValueEntry,
                GlobalInvtPostBuf."account type"::Inventory,
                GlobalInvtPostBuf."account type"::"Inventory Adjmt.",
                CostToPost,CostToPostACY,false);
            else
              ErrorNonValidCombination(ValueEntry);
          end;
    end;

    local procedure BufferSalesPosting(ValueEntry: Record "Value Entry";CostToPost: Decimal;CostToPostACY: Decimal;ExpCostToPost: Decimal;ExpCostToPostACY: Decimal)
    begin
        with ValueEntry do
          case "Entry Type" of
            "entry type"::"Direct Cost":
              begin
                if (ExpCostToPost <> 0) or (ExpCostToPostACY <> 0) then
                  InitInvtPostBuf(
                    ValueEntry,
                    GlobalInvtPostBuf."account type"::"Inventory (Interim)",
                    GlobalInvtPostBuf."account type"::"COGS (Interim)",
                    ExpCostToPost,ExpCostToPostACY,true);
                if (CostToPost <> 0) or (CostToPostACY <> 0) then
                  InitInvtPostBuf(
                    ValueEntry,
                    GlobalInvtPostBuf."account type"::Inventory,
                    GlobalInvtPostBuf."account type"::COGS,
                    CostToPost,CostToPostACY,false);
              end;
            "entry type"::Revaluation:
              begin
                if (ExpCostToPost <> 0) or (ExpCostToPostACY <> 0) then
                  InitInvtPostBuf(
                    ValueEntry,
                    GlobalInvtPostBuf."account type"::"Inventory (Interim)",
                    GlobalInvtPostBuf."account type"::"COGS (Interim)",
                    ExpCostToPost,ExpCostToPostACY,true);
                if (CostToPost <> 0) or (CostToPostACY <> 0) then
                  InitInvtPostBuf(
                    ValueEntry,
                    GlobalInvtPostBuf."account type"::Inventory,
                    GlobalInvtPostBuf."account type"::"Inventory Adjmt.",
                    CostToPost,CostToPostACY,false);
              end;
            "entry type"::Rounding:
              InitInvtPostBuf(
                ValueEntry,
                GlobalInvtPostBuf."account type"::Inventory,
                GlobalInvtPostBuf."account type"::"Inventory Adjmt.",
                CostToPost,CostToPostACY,false);
            else
              ErrorNonValidCombination(ValueEntry);
          end;
    end;

    local procedure BufferOutputPosting(ValueEntry: Record "Value Entry";CostToPost: Decimal;CostToPostACY: Decimal;ExpCostToPost: Decimal;ExpCostToPostACY: Decimal)
    begin
        with ValueEntry do
          case "Entry Type" of
            "entry type"::"Direct Cost":
              begin
                if (ExpCostToPost <> 0) or (ExpCostToPostACY <> 0) then
                  InitInvtPostBuf(
                    ValueEntry,
                    GlobalInvtPostBuf."account type"::"Inventory (Interim)",
                    GlobalInvtPostBuf."account type"::"WIP Inventory",
                    ExpCostToPost,ExpCostToPostACY,true);
                if (CostToPost <> 0) or (CostToPostACY <> 0) then
                  InitInvtPostBuf(
                    ValueEntry,
                    GlobalInvtPostBuf."account type"::Inventory,
                    GlobalInvtPostBuf."account type"::"WIP Inventory",
                    CostToPost,CostToPostACY,false);
              end;
            "entry type"::"Indirect Cost":
              InitInvtPostBuf(
                ValueEntry,
                GlobalInvtPostBuf."account type"::Inventory,
                GlobalInvtPostBuf."account type"::"Overhead Applied",
                CostToPost,CostToPostACY,false);
            "entry type"::Variance:
              case "Variance Type" of
                "variance type"::Material:
                  InitInvtPostBuf(
                    ValueEntry,
                    GlobalInvtPostBuf."account type"::Inventory,
                    GlobalInvtPostBuf."account type"::"Material Variance",
                    CostToPost,CostToPostACY,false);
                "variance type"::Capacity:
                  InitInvtPostBuf(
                    ValueEntry,
                    GlobalInvtPostBuf."account type"::Inventory,
                    GlobalInvtPostBuf."account type"::"Capacity Variance",
                    CostToPost,CostToPostACY,false);
                "variance type"::Subcontracted:
                  InitInvtPostBuf(
                    ValueEntry,
                    GlobalInvtPostBuf."account type"::Inventory,
                    GlobalInvtPostBuf."account type"::"Subcontracted Variance",
                    CostToPost,CostToPostACY,false);
                "variance type"::"Capacity Overhead":
                  InitInvtPostBuf(
                    ValueEntry,
                    GlobalInvtPostBuf."account type"::Inventory,
                    GlobalInvtPostBuf."account type"::"Cap. Overhead Variance",
                    CostToPost,CostToPostACY,false);
                "variance type"::"Manufacturing Overhead":
                  InitInvtPostBuf(
                    ValueEntry,
                    GlobalInvtPostBuf."account type"::Inventory,
                    GlobalInvtPostBuf."account type"::"Mfg. Overhead Variance",
                    CostToPost,CostToPostACY,false);
                else
                  ErrorNonValidCombination(ValueEntry);
              end;
            "entry type"::Revaluation:
              begin
                if (ExpCostToPost <> 0) or (ExpCostToPostACY <> 0) then
                  InitInvtPostBuf(
                    ValueEntry,
                    GlobalInvtPostBuf."account type"::"Inventory (Interim)",
                    GlobalInvtPostBuf."account type"::"WIP Inventory",
                    ExpCostToPost,ExpCostToPostACY,true);
                if (CostToPost <> 0) or (CostToPostACY <> 0) then
                  InitInvtPostBuf(
                    ValueEntry,
                    GlobalInvtPostBuf."account type"::Inventory,
                    GlobalInvtPostBuf."account type"::"Inventory Adjmt.",
                    CostToPost,CostToPostACY,false);
              end;
            "entry type"::Rounding:
              InitInvtPostBuf(
                ValueEntry,
                GlobalInvtPostBuf."account type"::Inventory,
                GlobalInvtPostBuf."account type"::"Inventory Adjmt.",
                CostToPost,CostToPostACY,false);
            else
              ErrorNonValidCombination(ValueEntry);
          end;
    end;

    local procedure BufferConsumpPosting(ValueEntry: Record "Value Entry";CostToPost: Decimal;CostToPostACY: Decimal)
    begin
        with ValueEntry do
          case "Entry Type" of
            "entry type"::"Direct Cost":
              InitInvtPostBuf(
                ValueEntry,
                GlobalInvtPostBuf."account type"::Inventory,
                GlobalInvtPostBuf."account type"::"WIP Inventory",
                CostToPost,CostToPostACY,false);
            "entry type"::Revaluation,
            "entry type"::Rounding:
              InitInvtPostBuf(
                ValueEntry,
                GlobalInvtPostBuf."account type"::Inventory,
                GlobalInvtPostBuf."account type"::"Inventory Adjmt.",
                CostToPost,CostToPostACY,false);
            else
              ErrorNonValidCombination(ValueEntry);
          end;
    end;

    local procedure BufferCapPosting(ValueEntry: Record "Value Entry";CostToPost: Decimal;CostToPostACY: Decimal)
    begin
        with ValueEntry do begin
          if "Order Type" = "order type"::Assembly then
            case "Entry Type" of
              "entry type"::"Direct Cost":
                InitInvtPostBuf(
                  ValueEntry,
                  GlobalInvtPostBuf."account type"::"Inventory Adjmt.",
                  GlobalInvtPostBuf."account type"::"Direct Cost Applied",
                  CostToPost,CostToPostACY,false);
              "entry type"::"Indirect Cost":
                InitInvtPostBuf(
                  ValueEntry,
                  GlobalInvtPostBuf."account type"::"Inventory Adjmt.",
                  GlobalInvtPostBuf."account type"::"Overhead Applied",
                  CostToPost,CostToPostACY,false);
              else
                ErrorNonValidCombination(ValueEntry);
            end
          else
            case "Entry Type" of
              "entry type"::"Direct Cost":
                InitInvtPostBuf(
                  ValueEntry,
                  GlobalInvtPostBuf."account type"::"WIP Inventory",
                  GlobalInvtPostBuf."account type"::"Direct Cost Applied",
                  CostToPost,CostToPostACY,false);
              "entry type"::"Indirect Cost":
                InitInvtPostBuf(
                  ValueEntry,
                  GlobalInvtPostBuf."account type"::"WIP Inventory",
                  GlobalInvtPostBuf."account type"::"Overhead Applied",
                  CostToPost,CostToPostACY,false);
              else
                ErrorNonValidCombination(ValueEntry);
            end;
        end;
    end;

    local procedure BufferAsmOutputPosting(ValueEntry: Record "Value Entry";CostToPost: Decimal;CostToPostACY: Decimal)
    begin
        with ValueEntry do
          case "Entry Type" of
            "entry type"::"Direct Cost":
              InitInvtPostBuf(
                ValueEntry,
                GlobalInvtPostBuf."account type"::Inventory,
                GlobalInvtPostBuf."account type"::"Inventory Adjmt.",
                CostToPost,CostToPostACY,false);
            "entry type"::"Indirect Cost":
              InitInvtPostBuf(
                ValueEntry,
                GlobalInvtPostBuf."account type"::Inventory,
                GlobalInvtPostBuf."account type"::"Overhead Applied",
                CostToPost,CostToPostACY,false);
            "entry type"::Variance:
              case "Variance Type" of
                "variance type"::Material:
                  InitInvtPostBuf(
                    ValueEntry,
                    GlobalInvtPostBuf."account type"::Inventory,
                    GlobalInvtPostBuf."account type"::"Material Variance",
                    CostToPost,CostToPostACY,false);
                "variance type"::Capacity:
                  InitInvtPostBuf(
                    ValueEntry,
                    GlobalInvtPostBuf."account type"::Inventory,
                    GlobalInvtPostBuf."account type"::"Capacity Variance",
                    CostToPost,CostToPostACY,false);
                "variance type"::Subcontracted:
                  InitInvtPostBuf(
                    ValueEntry,
                    GlobalInvtPostBuf."account type"::Inventory,
                    GlobalInvtPostBuf."account type"::"Subcontracted Variance",
                    CostToPost,CostToPostACY,false);
                "variance type"::"Capacity Overhead":
                  InitInvtPostBuf(
                    ValueEntry,
                    GlobalInvtPostBuf."account type"::Inventory,
                    GlobalInvtPostBuf."account type"::"Cap. Overhead Variance",
                    CostToPost,CostToPostACY,false);
                "variance type"::"Manufacturing Overhead":
                  InitInvtPostBuf(
                    ValueEntry,
                    GlobalInvtPostBuf."account type"::Inventory,
                    GlobalInvtPostBuf."account type"::"Mfg. Overhead Variance",
                    CostToPost,CostToPostACY,false);
                else
                  ErrorNonValidCombination(ValueEntry);
              end;
            "entry type"::Revaluation:
              InitInvtPostBuf(
                ValueEntry,
                GlobalInvtPostBuf."account type"::Inventory,
                GlobalInvtPostBuf."account type"::"Inventory Adjmt.",
                CostToPost,CostToPostACY,false);
            "entry type"::Rounding:
              InitInvtPostBuf(
                ValueEntry,
                GlobalInvtPostBuf."account type"::Inventory,
                GlobalInvtPostBuf."account type"::"Inventory Adjmt.",
                CostToPost,CostToPostACY,false);
            else
              ErrorNonValidCombination(ValueEntry);
          end;
    end;

    local procedure BufferAsmConsumpPosting(ValueEntry: Record "Value Entry";CostToPost: Decimal;CostToPostACY: Decimal)
    begin
        with ValueEntry do
          case "Entry Type" of
            "entry type"::"Direct Cost":
              InitInvtPostBuf(
                ValueEntry,
                GlobalInvtPostBuf."account type"::Inventory,
                GlobalInvtPostBuf."account type"::"Inventory Adjmt.",
                CostToPost,CostToPostACY,false);
            "entry type"::Revaluation,
            "entry type"::Rounding:
              InitInvtPostBuf(
                ValueEntry,
                GlobalInvtPostBuf."account type"::Inventory,
                GlobalInvtPostBuf."account type"::"Inventory Adjmt.",
                CostToPost,CostToPostACY,false);
            else
              ErrorNonValidCombination(ValueEntry);
          end;
    end;

    local procedure BufferAdjmtPosting(ValueEntry: Record "Value Entry";CostToPost: Decimal;CostToPostACY: Decimal;ExpCostToPost: Decimal;ExpCostToPostACY: Decimal)
    begin
        with ValueEntry do
          case "Entry Type" of
            "entry type"::"Direct Cost":
              begin
                // Posting adjustments to Interim accounts (Service)
                if (ExpCostToPost <> 0) or (ExpCostToPostACY <> 0) then
                  InitInvtPostBuf(
                    ValueEntry,
                    GlobalInvtPostBuf."account type"::"Inventory (Interim)",
                    GlobalInvtPostBuf."account type"::"COGS (Interim)",
                    ExpCostToPost,ExpCostToPostACY,true);
                if (CostToPost <> 0) or (CostToPostACY <> 0) then
                  InitInvtPostBuf(
                    ValueEntry,
                    GlobalInvtPostBuf."account type"::Inventory,
                    GlobalInvtPostBuf."account type"::"Inventory Adjmt.",
                    CostToPost,CostToPostACY,false);
              end;
            "entry type"::Revaluation,
            "entry type"::Rounding:
              InitInvtPostBuf(
                ValueEntry,
                GlobalInvtPostBuf."account type"::Inventory,
                GlobalInvtPostBuf."account type"::"Inventory Adjmt.",
                CostToPost,CostToPostACY,false);
            else
              ErrorNonValidCombination(ValueEntry);
          end;
    end;

    local procedure GetGLSetup()
    begin
        if not GLSetupRead then begin
          GLSetup.Get;
          if GLSetup."Additional Reporting Currency" <> '' then
            Currency.Get(GLSetup."Additional Reporting Currency");
        end;
        GLSetupRead := true;
    end;

    local procedure GetInvtSetup()
    begin
        if not InvtSetupRead then
          InvtSetup.Get;
        InvtSetupRead := true;
    end;

    local procedure CalcCostToPost(var CostToPost: Decimal;AdjdCost: Decimal;var PostedCost: Decimal;var PostToGL: Boolean)
    begin
        CostToPost := AdjdCost - PostedCost;

        if CostToPost <> 0 then begin
          if not RunOnlyCheck then
            PostedCost := AdjdCost;
          PostToGL := true;
        end;
    end;

    local procedure InitInvtPostBuf(ValueEntry: Record "Value Entry";AccType: Option;BalAccType: Option;CostToPost: Decimal;CostToPostACY: Decimal;InterimAccount: Boolean)
    begin
        PostBufDimNo := PostBufDimNo + 1;
        SetAccNo(TempInvtPostBuf[PostBufDimNo],ValueEntry,AccType,BalAccType);
        SetPostBufAmounts(TempInvtPostBuf[PostBufDimNo],CostToPost,CostToPostACY,InterimAccount);
        TempInvtPostBuf[PostBufDimNo]."Job No." := ValueEntry."Job No.";
        TempInvtPostBuf[PostBufDimNo]."Dimension Set ID" := ValueEntry."Dimension Set ID";

        PostBufDimNo := PostBufDimNo + 1;
        SetAccNo(TempInvtPostBuf[PostBufDimNo],ValueEntry,BalAccType,AccType);
        SetPostBufAmounts(TempInvtPostBuf[PostBufDimNo],-CostToPost,-CostToPostACY,InterimAccount);
        TempInvtPostBuf[PostBufDimNo]."Job No." := ValueEntry."Job No.";
        TempInvtPostBuf[PostBufDimNo]."Dimension Set ID" := ValueEntry."Dimension Set ID";
    end;

    local procedure SetAccNo(var InvtPostBuf: Record "Invt. Posting Buffer";ValueEntry: Record "Value Entry";AccType: Option;BalAccType: Option)
    var
        InvtPostSetup: Record "Inventory Posting Setup";
        GenPostingSetup: Record "General Posting Setup";
        GLAccount: Record "G/L Account";
    begin
        with InvtPostBuf do begin
          "Account No." := '';
          "Account Type" := AccType;
          "Bal. Account Type" := BalAccType;
          "Location Code" := ValueEntry."Location Code";
          "Inventory Posting Group" :=
            GetInvPostingGroupCode(ValueEntry,AccType = "account type"::"WIP Inventory",ValueEntry."Inventory Posting Group");
          "Gen. Bus. Posting Group" := ValueEntry."Gen. Bus. Posting Group";
          "Gen. Prod. Posting Group" := ValueEntry."Gen. Prod. Posting Group";
          "Posting Date" := ValueEntry."Posting Date";

          if UseInvtPostSetup then begin
            if CalledFromItemPosting then
              InvtPostSetup.Get("Location Code","Inventory Posting Group")
            else
              if not InvtPostSetup.Get("Location Code","Inventory Posting Group") then
                exit;
          end else begin
            if CalledFromItemPosting then
              GenPostingSetup.Get("Gen. Bus. Posting Group","Gen. Prod. Posting Group")
            else
              if not GenPostingSetup.Get("Gen. Bus. Posting Group","Gen. Prod. Posting Group") then
                exit;
          end;

          case "Account Type" of
            "account type"::Inventory:
              begin
                if CalledFromItemPosting then
                  InvtPostSetup.TestField("Inventory Account");
                "Account No." := InvtPostSetup."Inventory Account";
              end;
            "account type"::"Inventory (Interim)":
              begin
                if CalledFromItemPosting then
                  InvtPostSetup.TestField("Inventory Account (Interim)");
                "Account No." := InvtPostSetup."Inventory Account (Interim)";
              end;
            "account type"::"WIP Inventory":
              begin
                if CalledFromItemPosting then
                  InvtPostSetup.TestField("WIP Account");
                "Account No." := InvtPostSetup."WIP Account";
              end;
            "account type"::"Material Variance":
              begin
                if CalledFromItemPosting then
                  InvtPostSetup.TestField("Material Variance Account");
                "Account No." := InvtPostSetup."Material Variance Account";
              end;
            "account type"::"Capacity Variance":
              begin
                if CalledFromItemPosting then
                  InvtPostSetup.TestField("Capacity Variance Account");
                "Account No." := InvtPostSetup."Capacity Variance Account";
              end;
            "account type"::"Subcontracted Variance":
              begin
                if CalledFromItemPosting then
                  InvtPostSetup.TestField("Subcontracted Variance Account");
                "Account No." := InvtPostSetup."Subcontracted Variance Account";
              end;
            "account type"::"Cap. Overhead Variance":
              begin
                if CalledFromItemPosting then
                  InvtPostSetup.TestField("Cap. Overhead Variance Account");
                "Account No." := InvtPostSetup."Cap. Overhead Variance Account";
              end;
            "account type"::"Mfg. Overhead Variance":
              begin
                if CalledFromItemPosting then
                  InvtPostSetup.TestField("Mfg. Overhead Variance Account");
                "Account No." := InvtPostSetup."Mfg. Overhead Variance Account";
              end;
            "account type"::"Inventory Adjmt.":
              begin
                if CalledFromItemPosting then
                  GenPostingSetup.TestField("Inventory Adjmt. Account");
                "Account No." := GenPostingSetup."Inventory Adjmt. Account";
              end;
            "account type"::"Direct Cost Applied":
              begin
                if CalledFromItemPosting then
                  GenPostingSetup.TestField("Direct Cost Applied Account");
                "Account No." := GenPostingSetup."Direct Cost Applied Account";
              end;
            "account type"::"Overhead Applied":
              begin
                if CalledFromItemPosting then
                  GenPostingSetup.TestField("Overhead Applied Account");
                "Account No." := GenPostingSetup."Overhead Applied Account";
              end;
            "account type"::"Purchase Variance":
              begin
                if CalledFromItemPosting then
                  GenPostingSetup.TestField("Purchase Variance Account");
                "Account No." := GenPostingSetup."Purchase Variance Account";
              end;
            "account type"::COGS:
              begin
                if CalledFromItemPosting then
                  GenPostingSetup.TestField("COGS Account");
                "Account No." := GenPostingSetup."COGS Account";
              end;
            "account type"::"COGS (Interim)":
              begin
                if CalledFromItemPosting then
                  GenPostingSetup.TestField("COGS Account (Interim)");
                "Account No." := GenPostingSetup."COGS Account (Interim)";
              end;
            "account type"::"Invt. Accrual (Interim)":
              begin
                if CalledFromItemPosting then
                  GenPostingSetup.TestField("Invt. Accrual Acc. (Interim)");
                "Account No." := GenPostingSetup."Invt. Accrual Acc. (Interim)";
              end;
          end;
          if "Account No." <> '' then begin
            GLAccount.Get("Account No.");
            if GLAccount.Blocked then begin
              if CalledFromItemPosting then
                GLAccount.TestField(Blocked,false);
              if not CalledFromTestReport then
                "Account No." := '';
            end;
          end;
        end;
    end;

    local procedure SetPostBufAmounts(var InvtPostBuf: Record "Invt. Posting Buffer";CostToPost: Decimal;CostToPostACY: Decimal;InterimAccount: Boolean)
    begin
        with InvtPostBuf do begin
          "Interim Account" := InterimAccount;
          Amount := CostToPost;
          "Amount (ACY)" := CostToPostACY;
        end;
    end;

    local procedure UpdateGlobalInvtPostBuf(ValueEntryNo: Integer): Boolean
    var
        i: Integer;
    begin
        with GlobalInvtPostBuf do begin
          if not CalledFromTestReport then
            for i := 1 to PostBufDimNo do begin
              if TempInvtPostBuf[i]."Account No." = '' then begin
                Clear(TempInvtPostBuf);
                exit(false);
              end;
            end;
          for i := 1 to PostBufDimNo do begin
            GlobalInvtPostBuf := TempInvtPostBuf[i];
            "Dimension Set ID" := TempInvtPostBuf[i]."Dimension Set ID";
            Negative := (TempInvtPostBuf[i].Amount < 0) or (TempInvtPostBuf[i]."Amount (ACY)" < 0);

            UpdateReportAmounts;
            if Find then begin
              Amount := Amount + TempInvtPostBuf[i].Amount;
              "Amount (ACY)" := "Amount (ACY)" + TempInvtPostBuf[i]."Amount (ACY)";
              Modify;
            end else begin
              GlobalInvtPostBufEntryNo := GlobalInvtPostBufEntryNo + 1;
              "Entry No." := GlobalInvtPostBufEntryNo;
              Insert;
            end;

            if not (RunOnlyCheck or CalledFromTestReport) then begin
              TempGLItemLedgRelation.Init;
              TempGLItemLedgRelation."G/L Entry No." := "Entry No.";
              TempGLItemLedgRelation."Value Entry No." := ValueEntryNo;
              TempGLItemLedgRelation.Insert;
            end;
          end;
        end;
        Clear(TempInvtPostBuf);
        exit(true);
    end;

    local procedure UpdateReportAmounts()
    begin
        with GlobalInvtPostBuf do
          case "Account Type" of
            "account type"::Inventory,"account type"::"Inventory (Interim)":
              InvtAmt += Amount;
            "account type"::"WIP Inventory":
              WIPInvtAmt += Amount;
            "account type"::"Inventory Adjmt.":
              InvtAdjmtAmt += Amount;
            "account type"::"Invt. Accrual (Interim)":
              InvtAdjmtAmt += Amount;
            "account type"::"Direct Cost Applied":
              DirCostAmt += Amount;
            "account type"::"Overhead Applied":
              OvhdCostAmt += Amount;
            "account type"::"Purchase Variance":
              VarPurchCostAmt += Amount;
            "account type"::COGS:
              COGSAmt += Amount;
            "account type"::"COGS (Interim)":
              COGSAmt += Amount;
            "account type"::"Material Variance","account type"::"Capacity Variance",
            "account type"::"Subcontracted Variance","account type"::"Cap. Overhead Variance":
              VarMfgDirCostAmt += Amount;
            "account type"::"Mfg. Overhead Variance":
              VarMfgOvhdCostAmt += Amount;
          end;
    end;

    local procedure ErrorNonValidCombination(ValueEntry: Record "Value Entry")
    begin
        with ValueEntry do
          if CalledFromTestReport then
            InsertTempInvtPostToGLTestBuf2(ValueEntry)
          else
            Error(
              Text002,
              FieldCaption("Item Ledger Entry Type"),"Item Ledger Entry Type",
              FieldCaption("Entry Type"),"Entry Type",
              FieldCaption("Expected Cost"),"Expected Cost")
    end;

    local procedure InsertTempInvtPostToGLTestBuf2(ValueEntry: Record "Value Entry")
    begin
        with ValueEntry do begin
          TempInvtPostToGLTestBuf."Line No." := GetNextLineNo;
          TempInvtPostToGLTestBuf."Posting Date" := "Posting Date";
          TempInvtPostToGLTestBuf.Description := StrSubstNo(Text003,TableCaption,"Entry No.");
          TempInvtPostToGLTestBuf.Amount := "Cost Amount (Actual)";
          TempInvtPostToGLTestBuf."Value Entry No." := "Entry No.";
          TempInvtPostToGLTestBuf."Dimension Set ID" := "Dimension Set ID";
          TempInvtPostToGLTestBuf.Insert;
        end;
    end;

    local procedure GetNextLineNo(): Integer
    begin
        if TempInvtPostToGLTestBuf.FindLast then
          exit(TempInvtPostToGLTestBuf."Line No." + 10000);

        exit(10000);
    end;


    procedure PostInvtPostBufPerEntry(var ValueEntry: Record "Value Entry")
    var
        DummyGenJnlLine: Record "Gen. Journal Line";
    begin
        with ValueEntry do
          PostInvtPostBuf(
            ValueEntry,
            "Document No.",
            "External Document No.",
            CopyStr(
              StrSubstNo(Text000,"Entry Type","Source No.","Posting Date"),
              1,MaxStrLen(DummyGenJnlLine.Description)),
            false);
    end;


    procedure PostInvtPostBufPerPostGrp(DocNo: Code[20];Desc: Text[50])
    var
        ValueEntry: Record "Value Entry";
    begin
        PostInvtPostBuf(ValueEntry,DocNo,'',Desc,true);
    end;

    local procedure PostInvtPostBuf(var ValueEntry: Record "Value Entry";DocNo: Code[20];ExternalDocNo: Code[35];Desc: Text[50];PostPerPostGrp: Boolean)
    var
        GenJnlLine: Record "Gen. Journal Line";
    begin
        with GlobalInvtPostBuf do begin
          Reset;
          if not FindSet then
            exit;

          GenJnlLine.Init;
          GenJnlLine."Document No." := DocNo;
          GenJnlLine."External Document No." := ExternalDocNo;
          GenJnlLine.Description := Desc;
          GetSourceCodeSetup;
          GenJnlLine."Source Code" := SourceCodeSetup."Inventory Post Cost";
          GenJnlLine."System-Created Entry" := true;
          GenJnlLine."Job No." := "Job No.";
          GenJnlLine."Reason Code" := ValueEntry."Reason Code";
          repeat
            GenJnlLine.Validate("Posting Date","Posting Date");
            if SetAmt(GenJnlLine,Amount,"Amount (ACY)") then begin
              if PostPerPostGrp then
                SetDesc(GenJnlLine,GlobalInvtPostBuf);
              GenJnlLine."Account No." := "Account No.";
              GenJnlLine."Dimension Set ID" := "Dimension Set ID";
              DimMgt.UpdateGlobalDimFromDimSetID(
                "Dimension Set ID",GenJnlLine."Shortcut Dimension 1 Code",
                GenJnlLine."Shortcut Dimension 2 Code");
              if not CalledFromTestReport then
                if not RunOnlyCheck then begin
                  if not CalledFromItemPosting then
                    GenJnlPostLine.SetOverDimErr;
                  GenJnlPostLine.RunWithCheck(GenJnlLine)
                end else
                  GenJnlCheckLine.RunCheck(GenJnlLine)
              else
                InsertTempInvtPostToGLTestBuf(GenJnlLine,ValueEntry);
            end;
            if not CalledFromTestReport and not RunOnlyCheck then
              CreateGLItemLedgRelation(ValueEntry);
          until Next = 0;
          RunOnlyCheck := RunOnlyCheckSaved;
          DeleteAll;
        end;
    end;

    local procedure GetSourceCodeSetup()
    begin
        if not SourceCodeSetupRead then
          SourceCodeSetup.Get;
        SourceCodeSetupRead := true;
    end;

    local procedure SetAmt(var GenJnlLine: Record "Gen. Journal Line";Amt: Decimal;AmtACY: Decimal): Boolean
    begin
        with GenJnlLine do begin
          "Additional-Currency Posting" := "additional-currency posting"::None;
          Validate(Amount,Amt);

          GetGLSetup;
          if GLSetup."Additional Reporting Currency" <> '' then begin
            "Source Currency Code" := GLSetup."Additional Reporting Currency";
            "Source Currency Amount" := AmtACY;
            if (Amount = 0) and ("Source Currency Amount" <> 0) then begin
              "Additional-Currency Posting" :=
                "additional-currency posting"::"Additional-Currency Amount Only";
              Validate(Amount,"Source Currency Amount");
              "Source Currency Amount" := 0;
            end;
          end;
        end;

        exit((Amt <> 0) or (AmtACY <> 0));
    end;


    procedure SetDesc(var GenJnlLine: Record "Gen. Journal Line";InvtPostBuf: Record "Invt. Posting Buffer")
    begin
        with InvtPostBuf do
          GenJnlLine.Description :=
            CopyStr(
              StrSubstNo(
                Text001,
                "Account Type","Bal. Account Type",
                "Location Code","Inventory Posting Group",
                "Gen. Bus. Posting Group","Gen. Prod. Posting Group"),
              1,MaxStrLen(GenJnlLine.Description));
    end;

    local procedure InsertTempInvtPostToGLTestBuf(GenJnlLine: Record "Gen. Journal Line";ValueEntry: Record "Value Entry")
    begin
        with GenJnlLine do begin
          TempInvtPostToGLTestBuf."Line No." := GetNextLineNo;
          TempInvtPostToGLTestBuf."Posting Date" := "Posting Date";
          TempInvtPostToGLTestBuf."Document No." := "Document No.";
          TempInvtPostToGLTestBuf.Description := Description;
          TempInvtPostToGLTestBuf."Account No." := "Account No.";
          TempInvtPostToGLTestBuf.Amount := Amount;
          TempInvtPostToGLTestBuf."Source Code" := "Source Code";
          TempInvtPostToGLTestBuf."System-Created Entry" := true;
          TempInvtPostToGLTestBuf."Value Entry No." := ValueEntry."Entry No.";
          TempInvtPostToGLTestBuf."Additional-Currency Posting" := "Additional-Currency Posting";
          TempInvtPostToGLTestBuf."Source Currency Code" := "Source Currency Code";
          TempInvtPostToGLTestBuf."Source Currency Amount" := "Source Currency Amount";
          TempInvtPostToGLTestBuf."Inventory Account Type" := GlobalInvtPostBuf."Account Type";
          TempInvtPostToGLTestBuf."Dimension Set ID" := "Dimension Set ID";
          if GlobalInvtPostBuf.UseInvtPostSetup then begin
            TempInvtPostToGLTestBuf."Location Code" := GlobalInvtPostBuf."Location Code";
            TempInvtPostToGLTestBuf."Invt. Posting Group Code" :=
              GetInvPostingGroupCode(
                ValueEntry,
                TempInvtPostToGLTestBuf."Inventory Account Type" = TempInvtPostToGLTestBuf."inventory account type"::"WIP Inventory",
                GlobalInvtPostBuf."Inventory Posting Group")
          end else begin
            TempInvtPostToGLTestBuf."Gen. Bus. Posting Group" := GlobalInvtPostBuf."Gen. Bus. Posting Group";
            TempInvtPostToGLTestBuf."Gen. Prod. Posting Group" := GlobalInvtPostBuf."Gen. Prod. Posting Group";
          end;
          TempInvtPostToGLTestBuf.Insert;
        end;
    end;

    local procedure CreateGLItemLedgRelation(var ValueEntry: Record "Value Entry")
    var
        GLReg: Record "G/L Register";
    begin
        GenJnlPostLine.GetGLReg(GLReg);
        if GlobalPostPerPostGroup then begin
          TempGLItemLedgRelation.Reset;
          TempGLItemLedgRelation.SetRange("G/L Entry No.",GlobalInvtPostBuf."Entry No.");
          TempGLItemLedgRelation.FindSet;
          repeat
            ValueEntry.Get(TempGLItemLedgRelation."Value Entry No.");
            UpdateValueEntry(ValueEntry);
            CreateGLItemLedgRelationEntry(GLReg);
          until TempGLItemLedgRelation.Next = 0;
        end else begin
          UpdateValueEntry(ValueEntry);
          CreateGLItemLedgRelationEntry(GLReg);
        end;
    end;

    local procedure CreateGLItemLedgRelationEntry(GLReg: Record "G/L Register")
    var
        GLItemLedgRelation: Record "G/L - Item Ledger Relation";
    begin
        GLItemLedgRelation.Init;
        GLItemLedgRelation."G/L Entry No." := GLReg."To Entry No.";
        GLItemLedgRelation."Value Entry No." := TempGLItemLedgRelation."Value Entry No.";
        GLItemLedgRelation."G/L Register No." := GLReg."No.";
        GLItemLedgRelation.Insert;
        TempGLItemLedgRelation."G/L Entry No." := GlobalInvtPostBuf."Entry No.";
        TempGLItemLedgRelation.Delete;
    end;

    local procedure UpdateValueEntry(var ValueEntry: Record "Value Entry")
    begin
        with ValueEntry do begin
          if GlobalInvtPostBuf."Interim Account" then begin
            "Expected Cost Posted to G/L" := "Cost Amount (Expected)";
            "Exp. Cost Posted to G/L (ACY)" := "Cost Amount (Expected) (ACY)";
          end else begin
            "Cost Posted to G/L" := "Cost Amount (Actual)";
            "Cost Posted to G/L (ACY)" := "Cost Amount (Actual) (ACY)";
          end;
          if not CalledFromItemPosting then
            Modify;
        end;
    end;


    procedure GetTempInvtPostToGLTestBuf(var InvtPostToGLTestBuf: Record "Invt. Post to G/L Test Buffer")
    begin
        InvtPostToGLTestBuf.DeleteAll;
        if not TempInvtPostToGLTestBuf.FindSet then
          exit;

        repeat
          InvtPostToGLTestBuf := TempInvtPostToGLTestBuf;
          InvtPostToGLTestBuf.Insert;
        until TempInvtPostToGLTestBuf.Next = 0;
    end;


    procedure GetAmtToPost(var NewCOGSAmt: Decimal;var NewInvtAdjmtAmt: Decimal;var NewDirCostAmt: Decimal;var NewOvhdCostAmt: Decimal;var NewVarPurchCostAmt: Decimal;var NewVarMfgDirCostAmt: Decimal;var NewVarMfgOvhdCostAmt: Decimal;var NewWIPInvtAmt: Decimal;var NewInvtAmt: Decimal;GetTotal: Boolean)
    begin
        GetAmt(NewInvtAdjmtAmt,InvtAdjmtAmt,TotalInvtAdjmtAmt,GetTotal);
        GetAmt(NewDirCostAmt,DirCostAmt,TotalDirCostAmt,GetTotal);
        GetAmt(NewOvhdCostAmt,OvhdCostAmt,TotalOvhdCostAmt,GetTotal);
        GetAmt(NewVarPurchCostAmt,VarPurchCostAmt,TotalVarPurchCostAmt,GetTotal);
        GetAmt(NewVarMfgDirCostAmt,VarMfgDirCostAmt,TotalVarMfgDirCostAmt,GetTotal);
        GetAmt(NewVarMfgOvhdCostAmt,VarMfgOvhdCostAmt,TotalVarMfgOvhdCostAmt,GetTotal);
        GetAmt(NewWIPInvtAmt,WIPInvtAmt,TotalWIPInvtAmt,GetTotal);
        GetAmt(NewCOGSAmt,COGSAmt,TotalCOGSAmt,GetTotal);
        GetAmt(NewInvtAmt,InvtAmt,TotalInvtAmt,GetTotal);
    end;

    local procedure GetAmt(var NewAmt: Decimal;var Amt: Decimal;var TotalAmt: Decimal;GetTotal: Boolean)
    begin
        if GetTotal then
          NewAmt := TotalAmt
        else begin
          NewAmt := Amt;
          TotalAmt := TotalAmt + Amt;
          Amt := 0;
        end;
    end;


    procedure GetInvtPostBuf(var InvtPostBuf: Record "Invt. Posting Buffer")
    begin
        InvtPostBuf.DeleteAll;

        GlobalInvtPostBuf.Reset;
        if GlobalInvtPostBuf.FindSet then
          repeat
            InvtPostBuf := GlobalInvtPostBuf;
            InvtPostBuf.Insert;
          until GlobalInvtPostBuf.Next = 0;
    end;


    procedure GetDimBuf(DimEntryNo: Integer;var TempDimBuf: Record "Dimension Buffer")
    begin
        TempDimBuf.DeleteAll;
        DimBufMgt.GetDimensions(DimEntryNo,TempDimBuf);
    end;

    local procedure GetInvPostingGroupCode(ValueEntry: Record "Value Entry";WIPInventory: Boolean;InvPostingGroupCode: Code[10]): Code[10]
    var
        Item: Record Item;
    begin
        if WIPInventory then
          if ValueEntry."Source No." <> ValueEntry."Item No." then
            if Item.Get(ValueEntry."Source No.") then
              exit(Item."Inventory Posting Group");

        exit(InvPostingGroupCode);
    end;
}

