#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5845 "Get Inventory Report"
{
    TableNo = "Inventory Report Entry";

    trigger OnRun()
    begin
        WindowUpdateDateTime := CurrentDatetime;
        WindowIsOpen := false;

        Reset;
        DeleteAll;
        Calculate(Rec);

        if WindowIsOpen then
          Window.Close;
    end;

    var
        InvtReportHeader: Record "Inventory Report Header";
        Item: Record Item;
        GLAcc: Record "G/L Account";
        ValueEntry: Record "Value Entry";
        Text000: label 'Calculating...\';
        Text001: label 'Type         #1######\';
        Text002: label 'No.          #2######\';
        Text003: label 'Posting Type #3######';
        Window: Dialog;
        WindowIsOpen: Boolean;
        WindowType: Text[80];
        WindowNo: Text[20];
        WindowPostingType: Text[80];
        WindowUpdateDateTime: DateTime;
        Text004: label 'Show Item Direct Costs,Show Assembly Direct Cost,Show Revaluations,Show Roundings';
        Text005: label 'Show WIP Consumption,Show WIP Capacity,Show WIP Output';
        Text006: label 'Show Item Direct Costs,Show Assembly Direct Costs';
        Text007: label 'Show Item Indirect Costs,Show Assembly Indirect Costs';

    local procedure Calculate(var InventoryReportLine: Record "Inventory Report Entry")
    begin
        CalcGLPostings(InventoryReportLine);
        CalcInvtPostings(InventoryReportLine);
        InsertDiffReportEntry(InventoryReportLine);

        if InvtReportHeader."Show Warning" then
          DetermineDiffError(InventoryReportLine);
    end;

    local procedure CalcGLPostings(var InventoryReportLine: Record "Inventory Report Entry")
    begin
        CalcGenPostingSetup(InventoryReportLine);
        CalcInvtPostingSetup(InventoryReportLine);
    end;

    local procedure CalcInvtPostings(var InventoryReportLine: Record "Inventory Report Entry")
    begin
        with ValueEntry do begin
          Reset;
          Clear(InventoryReportLine);
          SetCurrentkey(
            "Item No.","Posting Date","Item Ledger Entry Type","Entry Type","Variance Type",
            "Item Charge No.","Location Code","Variant Code");
          SetFilter("Item No.",InvtReportHeader.GetFilter("Item Filter"));
          if Find('-') then
            repeat
              UpDateWindow(Item.TableCaption,"Item No.",'');
              SetRange("Item No.","Item No.");
              if not Item.Get("Item No.") then
                Clear(Item);
              if Item.Type = Item.Type::Inventory then
                InsertItemInvtReportEntry(InventoryReportLine);

              SetFilter("Item No.",InvtReportHeader.GetFilter("Item Filter"));
            until Next = 0;
        end
    end;

    local procedure InsertDiffReportEntry(var InventoryReportLine: Record "Inventory Report Entry")
    begin
        with InventoryReportLine do begin
          Init;
          CalcDiff(InventoryReportLine);
          Type := Type::" ";
          "No." := '';
          Description := '';
          "Entry No." := "Entry No." + 1;
          Insert;
        end;
    end;

    local procedure DetermineDiffError(var InventoryReportLine: Record "Inventory Report Entry")
    begin
        InventoryReportLine.SetRange(Type,InventoryReportLine.Type::" ");
        if not InventoryReportLine.FindFirst then
          exit;

        CheckExpectedCostPosting(InventoryReportLine);
        case true of
          CheckIfNoDifference(InventoryReportLine):
            ;
          CheckCostIsPostedToGL(InventoryReportLine):
            ;
          CheckValueGLCompression(InventoryReportLine):
            ;
          CheckGLClosingOverlaps(InventoryReportLine):
            ;
          CheckDeletedGLAcc(InventoryReportLine):
            ;
          CheckPostingDateToGLNotTheSame(InventoryReportLine):
            ;
          CheckDirectPostings(InventoryReportLine):
            ;
        end;
    end;

    local procedure CalcInvtPostingSetup(var InventoryReportLine: Record "Inventory Report Entry")
    var
        InvtPostingSetup: Record "Inventory Posting Setup";
        TempInvtPostingSetup: Record "Inventory Posting Setup" temporary;
    begin
        with InvtPostingSetup do begin
          if Find('-') then
            repeat
              TempInvtPostingSetup.Reset;
              TempInvtPostingSetup.SetRange("Inventory Account","Inventory Account");
              if not TempInvtPostingSetup.FindFirst then begin
                UpDateWindow(WindowType,WindowNo,FieldCaption("Inventory Account"));
                InsertGLInvtReportEntry(InventoryReportLine,"Inventory Account",InventoryReportLine.Inventory);
              end;

              TempInvtPostingSetup.Reset;
              TempInvtPostingSetup.SetRange("Inventory Account (Interim)","Inventory Account (Interim)");
              if not TempInvtPostingSetup.FindFirst then begin
                UpDateWindow(WindowType,WindowNo,FieldCaption("Inventory Account (Interim)"));
                InsertGLInvtReportEntry(
                  InventoryReportLine,"Inventory Account (Interim)",InventoryReportLine."Inventory (Interim)");
              end;

              TempInvtPostingSetup.Reset;
              TempInvtPostingSetup.SetRange("Material Variance Account","Material Variance Account");
              if not TempInvtPostingSetup.FindFirst then begin
                UpDateWindow(WindowType,WindowNo,FieldCaption("Material Variance Account"));
                InsertGLInvtReportEntry(
                  InventoryReportLine,"Material Variance Account",InventoryReportLine."Material Variance");
              end;

              TempInvtPostingSetup.Reset;
              TempInvtPostingSetup.SetRange("Capacity Variance Account","Capacity Variance Account");
              if not TempInvtPostingSetup.FindFirst then begin
                UpDateWindow(WindowType,WindowNo,FieldCaption("Capacity Variance Account"));
                InsertGLInvtReportEntry(
                  InventoryReportLine,"Capacity Variance Account",InventoryReportLine."Capacity Variance");
              end;

              TempInvtPostingSetup.Reset;
              TempInvtPostingSetup.SetRange("Mfg. Overhead Variance Account","Mfg. Overhead Variance Account");
              if not TempInvtPostingSetup.FindFirst then begin
                UpDateWindow(WindowType,WindowNo,FieldCaption("Mfg. Overhead Variance Account"));
                InsertGLInvtReportEntry(
                  InventoryReportLine,"Mfg. Overhead Variance Account",InventoryReportLine."Mfg. Overhead Variance");
              end;

              TempInvtPostingSetup.Reset;
              TempInvtPostingSetup.SetRange("Cap. Overhead Variance Account","Cap. Overhead Variance Account");
              if not TempInvtPostingSetup.FindFirst then begin
                UpDateWindow(WindowType,WindowNo,FieldCaption("Cap. Overhead Variance Account"));
                InsertGLInvtReportEntry(
                  InventoryReportLine,"Cap. Overhead Variance Account",InventoryReportLine."Capacity Overhead Variance");
              end;

              TempInvtPostingSetup.Reset;
              TempInvtPostingSetup.SetRange("Subcontracted Variance Account","Subcontracted Variance Account");
              if not TempInvtPostingSetup.FindFirst then begin
                UpDateWindow(WindowType,WindowNo,FieldCaption("Subcontracted Variance Account"));
                InsertGLInvtReportEntry(
                  InventoryReportLine,"Subcontracted Variance Account",InventoryReportLine."Subcontracted Variance");
              end;

              TempInvtPostingSetup.Reset;
              TempInvtPostingSetup.SetRange("WIP Account","WIP Account");
              if not TempInvtPostingSetup.FindFirst then begin
                UpDateWindow(WindowType,WindowNo,FieldCaption("WIP Account"));
                InsertGLInvtReportEntry(InventoryReportLine,"WIP Account",InventoryReportLine."WIP Inventory");
              end;

              TempInvtPostingSetup := InvtPostingSetup;
              TempInvtPostingSetup.Insert;
            until Next = 0;
        end;
    end;

    local procedure CalcGenPostingSetup(var InventoryReportLine: Record "Inventory Report Entry")
    var
        GenPostingSetup: Record "General Posting Setup";
        TempGenPostingSetup: Record "General Posting Setup" temporary;
    begin
        with GenPostingSetup do begin
          if Find('-') then
            repeat
              TempGenPostingSetup.Reset;
              TempGenPostingSetup.SetRange("COGS Account","COGS Account");
              if not TempGenPostingSetup.FindFirst then begin
                UpDateWindow(WindowType,WindowNo,FieldCaption("COGS Account"));
                InsertGLInvtReportEntry(InventoryReportLine,"COGS Account",InventoryReportLine.COGS);
              end;

              TempGenPostingSetup.Reset;
              TempGenPostingSetup.SetRange("Inventory Adjmt. Account","Inventory Adjmt. Account");
              if not TempGenPostingSetup.FindFirst then begin
                UpDateWindow(WindowType,WindowNo,FieldCaption("Inventory Adjmt. Account"));
                InsertGLInvtReportEntry(
                  InventoryReportLine,"Inventory Adjmt. Account",InventoryReportLine."Inventory Adjmt.");
              end;

              TempGenPostingSetup.Reset;
              TempGenPostingSetup.SetRange("Invt. Accrual Acc. (Interim)","Invt. Accrual Acc. (Interim)");
              if not TempGenPostingSetup.FindFirst then begin
                UpDateWindow(WindowType,WindowNo,FieldCaption("Invt. Accrual Acc. (Interim)"));
                InsertGLInvtReportEntry(
                  InventoryReportLine,"Invt. Accrual Acc. (Interim)",InventoryReportLine."Invt. Accrual (Interim)");
              end;

              TempGenPostingSetup.Reset;
              TempGenPostingSetup.SetRange("COGS Account (Interim)","COGS Account (Interim)");
              if not TempGenPostingSetup.FindFirst then begin
                UpDateWindow(WindowType,WindowNo,FieldCaption("COGS Account (Interim)"));
                InsertGLInvtReportEntry(
                  InventoryReportLine,"COGS Account (Interim)",InventoryReportLine."COGS (Interim)");
              end;

              TempGenPostingSetup.Reset;
              TempGenPostingSetup.SetRange("Direct Cost Applied Account","Direct Cost Applied Account");
              if not TempGenPostingSetup.FindFirst then begin
                UpDateWindow(WindowType,WindowNo,FieldCaption("Direct Cost Applied Account"));
                InsertGLInvtReportEntry(
                  InventoryReportLine,"Direct Cost Applied Account",InventoryReportLine."Direct Cost Applied");
              end;

              TempGenPostingSetup.Reset;
              TempGenPostingSetup.SetRange("Overhead Applied Account","Overhead Applied Account");
              if not TempGenPostingSetup.FindFirst then begin
                UpDateWindow(WindowType,WindowNo,FieldCaption("Overhead Applied Account"));
                InsertGLInvtReportEntry(
                  InventoryReportLine,"Overhead Applied Account",InventoryReportLine."Overhead Applied");
              end;

              TempGenPostingSetup.Reset;
              TempGenPostingSetup.SetRange("Purchase Variance Account","Purchase Variance Account");
              if not TempGenPostingSetup.FindFirst then begin
                UpDateWindow(WindowType,WindowNo,FieldCaption("Purchase Variance Account"));
                InsertGLInvtReportEntry(
                  InventoryReportLine,"Purchase Variance Account",InventoryReportLine."Purchase Variance");
              end;

              TempGenPostingSetup := GenPostingSetup;
              TempGenPostingSetup.Insert;
            until Next = 0;
        end;
    end;

    local procedure InsertGLInvtReportEntry(var InventoryReportLine: Record "Inventory Report Entry";GLAccNo: Code[20];var CostAmount: Decimal)
    begin
        with InventoryReportLine do begin
          Init;
          if not GLAcc.Get(GLAccNo) then
            exit;
          GLAcc.SetFilter("Date Filter",InvtReportHeader.GetFilter("Posting Date Filter"));
          CostAmount := CalcGLAccount(GLAcc);

          if CostAmount = 0 then
            exit;
          Type := Type::"G/L Account";
          "No." := GLAcc."No.";
          Description := GLAcc.Name;
          "Entry No." := "Entry No." + 1;
          Insert;
        end;
    end;

    local procedure InsertItemInvtReportEntry(var InventoryReportLine: Record "Inventory Report Entry")
    begin
        with InventoryReportLine do begin
          Init;
          CalcItem(InventoryReportLine);
          "No." := ValueEntry."Item No.";
          Description := Item.Description;
          Type := Type::Item;
          "Entry No." := "Entry No." + 1;
          Insert;
        end;
    end;

    local procedure CalcItem(var InventoryReportLine: Record "Inventory Report Entry")
    begin
        with ValueEntry do
          repeat
            SetRange("Posting Date","Posting Date");
            repeat
              if ValueEntryInFilteredSet(ValueEntry,InvtReportHeader,false) then begin
                if Item."No." <> "Item No." then
                  if not Item.Get("Item No.") then
                    Item.Init;
                SetRange("Entry Type","Entry Type");
                SetRange("Item Ledger Entry Type","Item Ledger Entry Type");
                SetRange("Location Code","Location Code");
                SetRange("Variance Type","Variance Type");
                SetRange("Item Charge No.","Item Charge No.");

                if ValueEntryInFilteredSet(ValueEntry,InvtReportHeader,true) then
                  CalcValueEntries(InventoryReportLine);

                FindLast;
                SetRange("Entry Type");
                SetRange("Item Ledger Entry Type");
                SetRange("Location Code");
                SetRange("Variance Type");
                SetRange("Item Charge No.");
              end else
                FindLast;
            until Next = 0;

            FindLast;
            SetFilter("Posting Date",InvtReportHeader.GetFilter("Posting Date Filter"));
          until Next = 0;
    end;

    local procedure ValueEntryInFilteredSet(var ValueEntry: Record "Value Entry";var InvtReportHeader: Record "Inventory Report Header";Detailed: Boolean): Boolean
    var
        TempValueEntry: Record "Value Entry" temporary;
    begin
        with TempValueEntry do begin
          SetFilter("Item No.",InvtReportHeader.GetFilter("Item Filter"));
          SetFilter("Posting Date",InvtReportHeader.GetFilter("Posting Date Filter"));
          if Detailed then
            SetFilter("Location Code",InvtReportHeader.GetFilter("Location Filter"));

          TempValueEntry := ValueEntry;
          Insert;
          exit(not IsEmpty);
        end;
    end;

    local procedure CalcValueEntries(var InventoryReportLine: Record "Inventory Report Entry")
    begin
        with InventoryReportLine do begin
          UpDateWindow(WindowType,WindowNo,Format(ValueEntry."Entry Type"));
          "Direct Cost Applied Actual" := "Direct Cost Applied Actual" + CalcDirectCostAppliedActual(ValueEntry);
          "Overhead Applied Actual" := "Overhead Applied Actual" + CalcOverheadAppliedActual(ValueEntry);
          "Purchase Variance" := "Purchase Variance" + CalcPurchaseVariance(ValueEntry);
          "Inventory Adjmt." := "Inventory Adjmt." + CalcInventoryAdjmt(ValueEntry);
          "Invt. Accrual (Interim)" := "Invt. Accrual (Interim)" + CalcInvtAccrualInterim(ValueEntry);
          COGS := COGS + CalcCOGS(ValueEntry);
          "COGS (Interim)" := "COGS (Interim)" + CalcCOGSInterim(ValueEntry);
          "WIP Inventory" := "WIP Inventory" + CalcWIPInventory(ValueEntry);
          "Material Variance" := "Material Variance" + CalcMaterialVariance(ValueEntry);
          "Capacity Variance" := "Capacity Variance" + CalcCapVariance(ValueEntry);
          "Subcontracted Variance" := "Subcontracted Variance" + CalcSubcontractedVariance(ValueEntry);
          "Capacity Overhead Variance" := "Capacity Overhead Variance" + CalcCapOverheadVariance(ValueEntry);
          "Mfg. Overhead Variance" := "Mfg. Overhead Variance" + CalcMfgOverheadVariance(ValueEntry);
          "Inventory (Interim)" := "Inventory (Interim)" + CalcInventoryInterim(ValueEntry);
          "Direct Cost Applied WIP" := "Direct Cost Applied WIP" + CalcDirectCostAppliedToWIP(ValueEntry);
          "Overhead Applied WIP" := "Overhead Applied WIP" + CalcOverheadAppliedToWIP(ValueEntry);
          "Inventory To WIP" := "Inventory To WIP" + CalcInvtToWIP(ValueEntry);
          "WIP To Interim" := "WIP To Interim" + CalcWIPToInvtInterim(ValueEntry);
          Inventory := Inventory + CalcInventory(ValueEntry);
          "Direct Cost Applied" := "Direct Cost Applied" + CalcDirectCostApplied(ValueEntry);
          "Overhead Applied" := "Overhead Applied" + CalcOverheadApplied(ValueEntry);
        end;
    end;

    local procedure CalcGLAccount(var GLAcc: Record "G/L Account"): Decimal
    begin
        with GLAcc do begin
          UpDateWindow(TableCaption,"No.",WindowPostingType);
          CalcFields("Net Change");
          exit("Net Change");
        end;
    end;

    local procedure CalcDiff(var InventoryReportLine: Record "Inventory Report Entry")
    var
        CalcInventoryReportLine: Record "Inventory Report Entry";
    begin
        with InventoryReportLine do begin
          CalcInventoryReportLine.Copy(InventoryReportLine);
          Reset;

          SetRange(Type,Type::"G/L Account");
          CalcSums(
            Inventory,"Inventory (Interim)","WIP Inventory",
            "Direct Cost Applied Actual","Overhead Applied Actual","Purchase Variance",
            "Inventory Adjmt.","Invt. Accrual (Interim)",COGS,
            "COGS (Interim)","Material Variance");
          CalcSums(
            "Capacity Variance","Subcontracted Variance","Capacity Overhead Variance",
            "Mfg. Overhead Variance","Direct Cost Applied WIP","Overhead Applied WIP",
            "Inventory To WIP","WIP To Interim","Direct Cost Applied","Overhead Applied");
          CalcInventoryReportLine := InventoryReportLine;

          SetRange(Type,Type::Item);
          CalcSums(
            Inventory,"Inventory (Interim)","WIP Inventory",
            "Direct Cost Applied Actual","Overhead Applied Actual","Purchase Variance",
            "Inventory Adjmt.","Invt. Accrual (Interim)",COGS,
            "COGS (Interim)","Material Variance");
          CalcSums(
            "Capacity Variance","Subcontracted Variance","Capacity Overhead Variance",
            "Mfg. Overhead Variance","Direct Cost Applied WIP","Overhead Applied WIP",
            "Inventory To WIP","WIP To Interim","Direct Cost Applied","Overhead Applied");
        end;

        with CalcInventoryReportLine do begin
          Inventory := Inventory - InventoryReportLine.Inventory;
          "Inventory (Interim)" := "Inventory (Interim)" - InventoryReportLine."Inventory (Interim)";
          "WIP Inventory" := "WIP Inventory" - InventoryReportLine."WIP Inventory";
          "Direct Cost Applied Actual" := "Direct Cost Applied Actual" - InventoryReportLine."Direct Cost Applied Actual";
          "Overhead Applied Actual" := "Overhead Applied Actual" - InventoryReportLine."Overhead Applied Actual";
          "Purchase Variance" := "Purchase Variance" - InventoryReportLine."Purchase Variance";
          "Inventory Adjmt." := "Inventory Adjmt." - InventoryReportLine."Inventory Adjmt.";
          "Invt. Accrual (Interim)" := "Invt. Accrual (Interim)" - InventoryReportLine."Invt. Accrual (Interim)";
          COGS := COGS - InventoryReportLine.COGS;
          "COGS (Interim)" := "COGS (Interim)" - InventoryReportLine."COGS (Interim)";
          "Material Variance" := "Material Variance" - InventoryReportLine."Material Variance";
          "Capacity Variance" := "Capacity Variance" - InventoryReportLine."Capacity Variance";
          "Subcontracted Variance" := "Subcontracted Variance" - InventoryReportLine."Subcontracted Variance";
          "Capacity Overhead Variance" := "Capacity Overhead Variance" - InventoryReportLine."Capacity Overhead Variance";
          "Mfg. Overhead Variance" := "Mfg. Overhead Variance" - InventoryReportLine."Mfg. Overhead Variance";
          "Direct Cost Applied WIP" := "Direct Cost Applied WIP" - InventoryReportLine."Direct Cost Applied WIP";
          "Overhead Applied WIP" := "Overhead Applied WIP" - InventoryReportLine."Overhead Applied WIP";
          "Inventory To WIP" := "Inventory To WIP" - InventoryReportLine."Inventory To WIP";
          "WIP To Interim" := "WIP To Interim" - InventoryReportLine."WIP To Interim";
          "Direct Cost Applied" := "Direct Cost Applied" - InventoryReportLine."Direct Cost Applied";
          "Overhead Applied" := "Overhead Applied" - InventoryReportLine."Overhead Applied";
          InventoryReportLine.Copy(CalcInventoryReportLine);
        end;
    end;

    local procedure DrillDownGL(var InvtReportEntry: Record "Inventory Report Entry")
    var
        GLEntry: Record "G/L Entry";
    begin
        with GLEntry do begin
          SetRange("G/L Account No.",InvtReportEntry."No.");
          SetFilter("Posting Date",InvtReportEntry.GetFilter("Posting Date Filter"));
          Page.Run(0,GLEntry,Amount);
        end;
    end;

    local procedure CalcDirectCostAppliedActual(var ValueEntry: Record "Value Entry"): Decimal
    begin
        with ValueEntry do begin
          if "Entry Type" = "entry type"::"Direct Cost" then
            case "Item Ledger Entry Type" of
              "item ledger entry type"::Purchase:
                begin
                  CalcSums("Cost Amount (Actual)");
                  exit(-"Cost Amount (Actual)");
                end;
              "item ledger entry type"::" ":
                if "Order Type" = "order type"::Assembly then begin
                  CalcSums("Cost Amount (Actual)");
                  exit(-"Cost Amount (Actual)");
                end;
            end;
          exit(0);
        end;
    end;

    local procedure CalcOverheadAppliedActual(var ValueEntry: Record "Value Entry"): Decimal
    begin
        with ValueEntry do begin
          if "Entry Type" = "entry type"::"Indirect Cost" then
            case "Item Ledger Entry Type" of
              "item ledger entry type"::Purchase,
              "item ledger entry type"::Output,
              "item ledger entry type"::"Assembly Output":
                begin
                  CalcSums("Cost Amount (Actual)");
                  exit(-"Cost Amount (Actual)");
                end;
              "item ledger entry type"::" ":
                if "Order Type" = "order type"::Assembly then begin
                  CalcSums("Cost Amount (Actual)");
                  exit(-"Cost Amount (Actual)");
                end;
            end;
          exit(0);
        end;
    end;

    local procedure CalcPurchaseVariance(var ValueEntry: Record "Value Entry"): Decimal
    begin
        with ValueEntry do begin
          if ("Entry Type" = "entry type"::Variance) and
             ("Item Ledger Entry Type" = "item ledger entry type"::Purchase)
          then begin
            CalcSums("Cost Amount (Actual)");
            exit(-"Cost Amount (Actual)");
          end;
          exit(0);
        end;
    end;

    local procedure CalcInventoryAdjmt(var ValueEntry: Record "Value Entry"): Decimal
    begin
        with ValueEntry do
          case "Entry Type" of
            "entry type"::Rounding,
            "entry type"::Revaluation:
              begin
                CalcSums("Cost Amount (Actual)");
                exit(-"Cost Amount (Actual)");
              end;
            "entry type"::"Direct Cost":
              case "Item Ledger Entry Type" of
                "item ledger entry type"::"Positive Adjmt.",
                "item ledger entry type"::"Negative Adjmt.",
                "item ledger entry type"::"Assembly Output",
                "item ledger entry type"::"Assembly Consumption",
                "item ledger entry type"::Transfer:
                  begin
                    CalcSums("Cost Amount (Actual)");
                    exit(-"Cost Amount (Actual)");
                  end;
                "item ledger entry type"::" ":
                  if "Order Type" = "order type"::Assembly then begin
                    CalcSums("Cost Amount (Actual)");
                    exit(-"Cost Amount (Actual)");
                  end;
              end;
          end;
        exit(0);
    end;

    local procedure CalcInvtAccrualInterim(var ValueEntry: Record "Value Entry"): Decimal
    begin
        with ValueEntry do begin
          if ("Entry Type" = "entry type"::"Direct Cost") and
             ("Item Ledger Entry Type" = "item ledger entry type"::Purchase)
          then begin
            CalcSums("Cost Amount (Expected)");
            exit(-"Cost Amount (Expected)");
          end;
          exit(0);
        end;
    end;

    local procedure CalcCOGS(var ValueEntry: Record "Value Entry"): Decimal
    begin
        with ValueEntry do begin
          if ("Entry Type" = "entry type"::"Direct Cost") and
             ("Item Ledger Entry Type" = "item ledger entry type"::Sale)
          then begin
            CalcSums("Cost Amount (Actual)");
            exit(-"Cost Amount (Actual)");
          end;
          exit(0);
        end;
    end;

    local procedure CalcCOGSInterim(var ValueEntry: Record "Value Entry"): Decimal
    begin
        with ValueEntry do begin
          if ("Entry Type" in ["entry type"::"Direct Cost","entry type"::Revaluation]) and
             ("Item Ledger Entry Type" = "item ledger entry type"::Sale)
          then begin
            CalcSums("Cost Amount (Expected)");
            exit(-"Cost Amount (Expected)");
          end;
          exit(0);
        end;
    end;

    local procedure CalcWIPInventory(var ValueEntry: Record "Value Entry"): Decimal
    begin
        with ValueEntry do begin
          if "Order Type" = "order type"::Production then
            case "Item Ledger Entry Type" of
              "item ledger entry type"::Consumption:
                if "Entry Type" = "entry type"::"Direct Cost" then begin
                  CalcSums("Cost Amount (Actual)");
                  exit(-"Cost Amount (Actual)");
                end;
              "item ledger entry type"::Output:
                case "Entry Type" of
                  "entry type"::"Direct Cost":
                    begin
                      CalcSums("Cost Amount (Actual)","Cost Amount (Expected)");
                      exit(-"Cost Amount (Actual)" - "Cost Amount (Expected)");
                    end;
                  "entry type"::Revaluation:
                    begin
                      CalcSums("Cost Amount (Expected)");
                      exit(-"Cost Amount (Expected)");
                    end;
                end;
              "item ledger entry type"::" ":
                if "Entry Type" in ["entry type"::"Direct Cost","entry type"::"Indirect Cost"] then begin
                  CalcSums("Cost Amount (Actual)");
                  exit("Cost Amount (Actual)");
                end;
            end;
        end;
    end;

    local procedure CalcMaterialVariance(var ValueEntry: Record "Value Entry"): Decimal
    begin
        with ValueEntry do begin
          if ("Entry Type" = "entry type"::Variance) and
             ("Item Ledger Entry Type" in ["item ledger entry type"::Output,
                                           "item ledger entry type"::"Assembly Output"]) and
             ("Variance Type" = "variance type"::Material)
          then begin
            CalcSums("Cost Amount (Actual)");
            exit(-"Cost Amount (Actual)");
          end;
          exit(0);
        end;
    end;

    local procedure CalcCapVariance(var ValueEntry: Record "Value Entry"): Decimal
    begin
        with ValueEntry do begin
          if ("Entry Type" = "entry type"::Variance) and
             ("Item Ledger Entry Type" in ["item ledger entry type"::Output,
                                           "item ledger entry type"::"Assembly Output"]) and
             ("Variance Type" = "variance type"::Capacity)
          then begin
            CalcSums("Cost Amount (Actual)");
            exit(-"Cost Amount (Actual)");
          end;
          exit(0);
        end;
    end;

    local procedure CalcSubcontractedVariance(var ValueEntry: Record "Value Entry"): Decimal
    begin
        with ValueEntry do begin
          if ("Entry Type" = "entry type"::Variance) and
             ("Item Ledger Entry Type" in ["item ledger entry type"::Output,
                                           "item ledger entry type"::"Assembly Output"]) and
             ("Variance Type" = "variance type"::Subcontracted)
          then begin
            CalcSums("Cost Amount (Actual)");
            exit(-"Cost Amount (Actual)");
          end;
          exit(0);
        end;
    end;

    local procedure CalcCapOverheadVariance(var ValueEntry: Record "Value Entry"): Decimal
    begin
        with ValueEntry do begin
          if ("Entry Type" = "entry type"::Variance) and
             ("Item Ledger Entry Type" in ["item ledger entry type"::Output,
                                           "item ledger entry type"::"Assembly Output"]) and
             ("Variance Type" = "variance type"::"Capacity Overhead")
          then begin
            CalcSums("Cost Amount (Actual)");
            exit(-"Cost Amount (Actual)");
          end;
          exit(0);
        end;
    end;

    local procedure CalcMfgOverheadVariance(var ValueEntry: Record "Value Entry"): Decimal
    begin
        with ValueEntry do begin
          if ("Entry Type" = "entry type"::Variance) and
             ("Item Ledger Entry Type" in ["item ledger entry type"::Output,
                                           "item ledger entry type"::"Assembly Output"]) and
             ("Variance Type" = "variance type"::"Manufacturing Overhead")
          then begin
            CalcSums("Cost Amount (Actual)");
            exit(-"Cost Amount (Actual)");
          end;
          exit(0);
        end;
    end;

    local procedure CalcInventoryInterim(var ValueEntry: Record "Value Entry"): Decimal
    begin
        with ValueEntry do begin
          if ("Entry Type" in ["entry type"::"Direct Cost","entry type"::Revaluation]) and
             ("Item Ledger Entry Type" in
              ["item ledger entry type"::Purchase,
               "item ledger entry type"::Sale,
               "item ledger entry type"::Output])
          then begin
            CalcSums("Cost Amount (Expected)");
            exit("Cost Amount (Expected)");
          end;
          exit(0);
        end;
    end;

    local procedure CalcOverheadAppliedToWIP(var ValueEntry: Record "Value Entry"): Decimal
    begin
        with ValueEntry do begin
          if ("Entry Type" = "entry type"::"Indirect Cost") and
             ("Item Ledger Entry Type" = "item ledger entry type"::" ") and
             ("Order Type" = "order type"::Production)
          then begin
            CalcSums("Cost Amount (Actual)");
            exit(-"Cost Amount (Actual)");
          end;
          exit(0);
        end;
    end;

    local procedure CalcDirectCostAppliedToWIP(var ValueEntry: Record "Value Entry"): Decimal
    begin
        with ValueEntry do begin
          if ("Entry Type" = "entry type"::"Direct Cost") and
             ("Item Ledger Entry Type" = "item ledger entry type"::" ") and
             ("Order Type" = "order type"::Production)
          then begin
            CalcSums("Cost Amount (Actual)");
            exit(-"Cost Amount (Actual)");
          end;
          exit(0);
        end;
    end;

    local procedure CalcWIPToInvtInterim(var ValueEntry: Record "Value Entry"): Decimal
    begin
        with ValueEntry do begin
          if ("Entry Type" in ["entry type"::"Direct Cost","entry type"::Revaluation]) and
             ("Item Ledger Entry Type" = "item ledger entry type"::Output)
          then begin
            CalcSums("Cost Amount (Expected)");
            exit(-"Cost Amount (Expected)");
          end;
          exit(0);
        end;
    end;

    local procedure CalcInvtToWIP(var ValueEntry: Record "Value Entry"): Decimal
    begin
        with ValueEntry do
          if ("Entry Type" = "entry type"::"Direct Cost") and
             ("Item Ledger Entry Type" in
              ["item ledger entry type"::Output,"item ledger entry type"::Consumption])
          then begin
            CalcSums("Cost Amount (Actual)");
            exit("Cost Amount (Actual)");
          end;
    end;

    local procedure CalcInventory(var ValueEntry: Record "Value Entry"): Decimal
    begin
        with ValueEntry do begin
          if "Item Ledger Entry Type" = "item ledger entry type"::" " then
            exit(0);
          CalcSums("Cost Amount (Actual)");
          exit("Cost Amount (Actual)");
        end;
    end;

    local procedure CalcDirectCostApplied(var ValueEntry: Record "Value Entry"): Decimal
    begin
        with ValueEntry do begin
          if "Entry Type" = "entry type"::"Direct Cost" then
            case "Item Ledger Entry Type" of
              "item ledger entry type"::Purchase:
                begin
                  CalcSums("Cost Amount (Actual)");
                  exit(-"Cost Amount (Actual)");
                end;
              "item ledger entry type"::" ":
                begin
                  if "Order Type" = "order type"::Assembly then begin
                    CalcSums("Cost Amount (Actual)");
                    exit(-"Cost Amount (Actual)");
                  end;
                  CalcSums("Cost Amount (Actual)");
                  exit(-"Cost Amount (Actual)");
                end;
            end;
          exit(0);
        end;
    end;

    local procedure CalcOverheadApplied(var ValueEntry: Record "Value Entry"): Decimal
    begin
        with ValueEntry do begin
          if "Entry Type" = "entry type"::"Indirect Cost" then
            case "Item Ledger Entry Type" of
              "item ledger entry type"::Purchase,
              "item ledger entry type"::Output,
              "item ledger entry type"::"Assembly Output":
                begin
                  CalcSums("Cost Amount (Actual)");
                  exit(-"Cost Amount (Actual)");
                end;
              "item ledger entry type"::" ":
                begin
                  if "Order Type" = "order type"::Assembly then begin
                    CalcSums("Cost Amount (Actual)");
                    exit(-"Cost Amount (Actual)");
                  end;
                  CalcSums("Cost Amount (Actual)");
                  exit(-"Cost Amount (Actual)");
                end;
            end;
          exit(0);
        end;
    end;

    local procedure CopyFiltersFronInventoryReportLine(var ValueEntry: Record "Value Entry";var InventoryReportEntry: Record "Inventory Report Entry")
    begin
        ValueEntry.SetCurrentkey("Item No.","Posting Date","Item Ledger Entry Type","Entry Type");
        ValueEntry.SetRange("Item No.",InventoryReportEntry."No.");
        ValueEntry.SetFilter("Posting Date",InventoryReportEntry.GetFilter("Posting Date Filter"));
        ValueEntry.SetFilter("Location Code",InventoryReportEntry.GetFilter("Location Filter"));
    end;


    procedure DrillDownDirectCostApplActual(var InvtReportEntry: Record "Inventory Report Entry")
    begin
        DrillDownInventoryReportEntryAmount(
          InvtReportEntry,InvtReportEntry.FieldNo("Direct Cost Applied Actual"),ValueEntry.FieldNo("Cost Amount (Actual)"));
    end;

    local procedure SetFiltersDirectCostApplActual(var ValueEntry: Record "Value Entry";var InvtReportEntry: Record "Inventory Report Entry")
    var
        Selection: Integer;
    begin
        Selection := StrMenu(Text006,2);
        CopyFiltersFronInventoryReportLine(ValueEntry,InvtReportEntry);
        with ValueEntry do begin
          SetRange("Entry Type","entry type"::"Direct Cost");
          SetRange("Variance Type");
          case Selection of
            1:
              SetRange("Item Ledger Entry Type","item ledger entry type"::Purchase);
            2:
              begin
                SetRange("Item Ledger Entry Type","item ledger entry type"::" ");
                SetRange("Order Type","order type"::Assembly);
              end;
          end;
        end;
    end;


    procedure DrillDownOverheadAppliedActual(var InvtReportEntry: Record "Inventory Report Entry")
    begin
        DrillDownInventoryReportEntryAmount(
          InvtReportEntry,InvtReportEntry.FieldNo("Overhead Applied Actual"),ValueEntry.FieldNo("Cost Amount (Actual)"));
    end;

    local procedure SetFiltersOverheadAppliedActual(var ValueEntry: Record "Value Entry";var InvtReportEntry: Record "Inventory Report Entry")
    var
        Selection: Integer;
    begin
        Selection := StrMenu(Text007,2);
        with ValueEntry do begin
          CopyFiltersFronInventoryReportLine(ValueEntry,InvtReportEntry);
          SetRange("Entry Type","entry type"::"Indirect Cost");
          SetRange("Variance Type");
          case Selection of
            1:
              SetFilter("Item Ledger Entry Type",'%1|%2|%3',
                "item ledger entry type"::Purchase,
                "item ledger entry type"::Output,
                "item ledger entry type"::"Assembly Output");
            2:
              begin
                SetRange("Item Ledger Entry Type","item ledger entry type"::" ");
                SetRange("Order Type","order type"::Assembly);
              end;
          end;
        end;
    end;


    procedure DrillDownPurchaseVariance(var InvtReportEntry: Record "Inventory Report Entry")
    begin
        DrillDownInventoryReportEntryAmount(
          InvtReportEntry,InvtReportEntry.FieldNo("Purchase Variance"),ValueEntry.FieldNo("Cost Amount (Actual)"));
    end;

    local procedure SetFiltersPurchaseVariance(var ValueEntry: Record "Value Entry";var InvtReportEntry: Record "Inventory Report Entry")
    begin
        with ValueEntry do begin
          CopyFiltersFronInventoryReportLine(ValueEntry,InvtReportEntry);
          SetRange("Entry Type","entry type"::Variance);
          SetRange("Item Ledger Entry Type","item ledger entry type"::Purchase);
        end;
    end;


    procedure DrillDownInventoryAdjmt(var InvtReportEntry: Record "Inventory Report Entry")
    begin
        DrillDownInventoryReportEntryAmount(
          InvtReportEntry,InvtReportEntry.FieldNo("Inventory Adjmt."),ValueEntry.FieldNo("Cost Amount (Actual)"));
    end;

    local procedure SetFiltersInventoryAdjmt(var ValueEntry: Record "Value Entry";var InvtReportEntry: Record "Inventory Report Entry")
    var
        Selection: Integer;
    begin
        Selection := StrMenu(Text004,3);
        if Selection = 0 then
          exit;

        with ValueEntry do begin
          CopyFiltersFronInventoryReportLine(ValueEntry,InvtReportEntry);

          case Selection of
            1:
              begin
                SetRange("Entry Type","entry type"::"Direct Cost");
                SetFilter("Item Ledger Entry Type",'%1|%2|%3|%4|%5',
                  "item ledger entry type"::"Positive Adjmt.",
                  "item ledger entry type"::"Negative Adjmt.",
                  "item ledger entry type"::"Assembly Output",
                  "item ledger entry type"::"Assembly Consumption",
                  "item ledger entry type"::Transfer);
              end;
            2:
              begin
                SetRange("Entry Type","entry type"::"Direct Cost");
                SetRange("Order Type","order type"::Assembly);
                SetRange("Item Ledger Entry Type","item ledger entry type"::" ");
              end;
            3:
              SetRange("Entry Type","entry type"::Revaluation);
            4:
              SetRange("Entry Type","entry type"::Rounding);
          end;
        end;
    end;


    procedure DrillDownInvtAccrualInterim(var InvtReportEntry: Record "Inventory Report Entry")
    begin
        DrillDownInventoryReportEntryAmount(
          InvtReportEntry,InvtReportEntry.FieldNo("Invt. Accrual (Interim)"),ValueEntry.FieldNo("Cost Amount (Expected)"));
    end;

    local procedure SetFiltersInvtAccrualInterim(var ValueEntry: Record "Value Entry";var InvtReportEntry: Record "Inventory Report Entry")
    begin
        with ValueEntry do begin
          CopyFiltersFronInventoryReportLine(ValueEntry,InvtReportEntry);
          SetRange("Entry Type","entry type"::"Direct Cost");
          SetRange("Item Ledger Entry Type","item ledger entry type"::Purchase);
          SetRange("Variance Type");
        end;
    end;


    procedure DrillDownCOGS(var InvtReportEntry: Record "Inventory Report Entry")
    begin
        DrillDownInventoryReportEntryAmount(InvtReportEntry,InvtReportEntry.FieldNo(COGS),ValueEntry.FieldNo("Cost Amount (Actual)"));
    end;

    local procedure SetFiltersCOGS(var ValueEntry: Record "Value Entry";var InvtReportEntry: Record "Inventory Report Entry")
    begin
        with ValueEntry do begin
          CopyFiltersFronInventoryReportLine(ValueEntry,InvtReportEntry);
          SetRange("Entry Type","entry type"::"Direct Cost");
          SetRange("Item Ledger Entry Type","item ledger entry type"::Sale);
          SetRange("Variance Type");
        end;
    end;


    procedure DrillDownCOGSInterim(var InvtReportEntry: Record "Inventory Report Entry")
    begin
        DrillDownInventoryReportEntryAmount(
          InvtReportEntry,InvtReportEntry.FieldNo("COGS (Interim)"),ValueEntry.FieldNo("Cost Amount (Expected)"));
    end;

    local procedure SetFiltersCOGSInterim(var ValueEntry: Record "Value Entry";var InvtReportEntry: Record "Inventory Report Entry")
    begin
        with ValueEntry do begin
          CopyFiltersFronInventoryReportLine(ValueEntry,InvtReportEntry);
          SetFilter("Entry Type",'%1|%2',"entry type"::"Direct Cost","entry type"::Revaluation);
          SetRange("Item Ledger Entry Type","item ledger entry type"::Sale);
          SetRange("Variance Type");
        end;
    end;


    procedure DrillDownWIPInventory(var InvtReportEntry: Record "Inventory Report Entry")
    begin
        DrillDownInventoryReportEntryAmount(
          InvtReportEntry,InvtReportEntry.FieldNo("WIP Inventory"),ValueEntry.FieldNo("Cost Amount (Actual)"));
    end;

    local procedure SetFiltersWIPInventory(var ValueEntry: Record "Value Entry";var InvtReportEntry: Record "Inventory Report Entry")
    var
        Selection: Integer;
    begin
        Selection := StrMenu(Text005,3);
        if Selection = 0 then
          exit;

        with ValueEntry do begin
          CopyFiltersFronInventoryReportLine(ValueEntry,InvtReportEntry);
          SetRange("Order Type","order type"::Production);

          case Selection of
            1:
              begin
                SetRange("Entry Type","entry type"::"Direct Cost");
                SetRange("Item Ledger Entry Type","item ledger entry type"::Consumption);
              end;
            2:
              begin
                SetFilter("Entry Type",'%1|%2',"entry type"::"Direct Cost","entry type"::"Indirect Cost");
                SetRange("Item Ledger Entry Type","item ledger entry type"::" ");
              end;
            3:
              begin
                SetFilter("Entry Type",'%1|%2',"entry type"::"Direct Cost","entry type"::Revaluation);
                SetRange("Item Ledger Entry Type","item ledger entry type"::Output);
              end;
          end;
        end;
    end;


    procedure DrillDownMaterialVariance(var InvtReportEntry: Record "Inventory Report Entry")
    begin
        DrillDownInventoryReportEntryAmount(
          InvtReportEntry,InvtReportEntry.FieldNo("Material Variance"),ValueEntry.FieldNo("Cost Amount (Actual)"));
    end;

    local procedure SetFiltersMaterialVariance(var ValueEntry: Record "Value Entry";var InvtReportEntry: Record "Inventory Report Entry")
    begin
        with ValueEntry do begin
          CopyFiltersFronInventoryReportLine(ValueEntry,InvtReportEntry);
          SetRange("Entry Type","entry type"::Variance);
          SetRange("Variance Type","variance type"::Material);
          SetFilter("Item Ledger Entry Type",'%1|%2',
            "item ledger entry type"::Output,
            "item ledger entry type"::"Assembly Output");
        end;
    end;


    procedure DrillDownCapVariance(var InvtReportEntry: Record "Inventory Report Entry")
    begin
        DrillDownInventoryReportEntryAmount(
          InvtReportEntry,InvtReportEntry.FieldNo("Capacity Variance"),ValueEntry.FieldNo("Cost Amount (Actual)"));
    end;

    local procedure SetFiltersCapVariance(var ValueEntry: Record "Value Entry";var InvtReportEntry: Record "Inventory Report Entry")
    begin
        with ValueEntry do begin
          CopyFiltersFronInventoryReportLine(ValueEntry,InvtReportEntry);
          SetRange("Entry Type","entry type"::Variance);
          SetRange("Variance Type","variance type"::Capacity);
          SetFilter("Item Ledger Entry Type",'%1|%2',
            "item ledger entry type"::Output,
            "item ledger entry type"::"Assembly Output");
        end;
    end;


    procedure DrillDownSubcontractedVariance(var InvtReportEntry: Record "Inventory Report Entry")
    begin
        DrillDownInventoryReportEntryAmount(
          InvtReportEntry,InvtReportEntry.FieldNo("Subcontracted Variance"),ValueEntry.FieldNo("Cost Amount (Actual)"));
    end;

    local procedure SetFiltersSubcontractedVariance(var ValueEntry: Record "Value Entry";var InvtReportEntry: Record "Inventory Report Entry")
    begin
        with ValueEntry do begin
          CopyFiltersFronInventoryReportLine(ValueEntry,InvtReportEntry);
          SetRange("Entry Type","entry type"::Variance);
          SetRange("Variance Type","variance type"::Subcontracted);
          SetFilter("Item Ledger Entry Type",'%1|%2',
            "item ledger entry type"::Output,
            "item ledger entry type"::"Assembly Output");
        end;
    end;


    procedure DrillDownCapOverheadVariance(var InvtReportEntry: Record "Inventory Report Entry")
    begin
        DrillDownInventoryReportEntryAmount(
          InvtReportEntry,InvtReportEntry.FieldNo("Capacity Overhead Variance"),ValueEntry.FieldNo("Cost Amount (Actual)"));
    end;

    local procedure SetFiltersCapOverheadVariance(var ValueEntry: Record "Value Entry";var InvtReportEntry: Record "Inventory Report Entry")
    begin
        with ValueEntry do begin
          CopyFiltersFronInventoryReportLine(ValueEntry,InvtReportEntry);
          SetRange("Entry Type","entry type"::Variance);
          SetRange("Variance Type","variance type"::"Capacity Overhead");
          SetFilter("Item Ledger Entry Type",'%1|%2',
            "item ledger entry type"::Output,
            "item ledger entry type"::"Assembly Output");
        end;
    end;


    procedure DrillDownMfgOverheadVariance(var InvtReportEntry: Record "Inventory Report Entry")
    begin
        DrillDownInventoryReportEntryAmount(
          InvtReportEntry,InvtReportEntry.FieldNo("Mfg. Overhead Variance"),ValueEntry.FieldNo("Cost Amount (Actual)"));
    end;

    local procedure SetFiltersMfgOverheadVariance(var ValueEntry: Record "Value Entry";var InvtReportEntry: Record "Inventory Report Entry")
    begin
        with ValueEntry do begin
          CopyFiltersFronInventoryReportLine(ValueEntry,InvtReportEntry);
          SetRange("Entry Type","entry type"::Variance);
          SetRange("Variance Type","variance type"::"Manufacturing Overhead");
          SetFilter("Item Ledger Entry Type",'%1|%2',
            "item ledger entry type"::Output,
            "item ledger entry type"::"Assembly Output");
        end;
    end;


    procedure DrillDownInventoryInterim(var InvtReportEntry: Record "Inventory Report Entry")
    begin
        DrillDownInventoryReportEntryAmount(
          InvtReportEntry,InvtReportEntry.FieldNo("Inventory (Interim)"),ValueEntry.FieldNo("Cost Amount (Expected)"));
    end;

    local procedure SetFiltersInventoryInterim(var ValueEntry: Record "Value Entry";var InvtReportEntry: Record "Inventory Report Entry")
    begin
        with ValueEntry do begin
          CopyFiltersFronInventoryReportLine(ValueEntry,InvtReportEntry);
          SetFilter("Entry Type",'%1|%2',"entry type"::"Direct Cost","entry type"::Revaluation);
          SetFilter("Item Ledger Entry Type",'%1|%2|%3',
            "item ledger entry type"::Output,
            "item ledger entry type"::Purchase,
            "item ledger entry type"::Sale);
          SetRange("Variance Type");
        end;
    end;


    procedure DrillDownOverheadAppliedToWIP(var InvtReportEntry: Record "Inventory Report Entry")
    begin
        DrillDownInventoryReportEntryAmount(
          InvtReportEntry,InvtReportEntry.FieldNo("Overhead Applied WIP"),ValueEntry.FieldNo("Cost Amount (Actual)"));
    end;

    local procedure SetFiltersOverheadAppliedToWIP(var ValueEntry: Record "Value Entry";var InvtReportEntry: Record "Inventory Report Entry")
    begin
        with ValueEntry do begin
          CopyFiltersFronInventoryReportLine(ValueEntry,InvtReportEntry);
          SetRange("Entry Type","entry type"::"Indirect Cost");
          SetRange("Item Ledger Entry Type","item ledger entry type"::" ");
          SetRange("Order Type","order type"::Production);
          SetRange("Variance Type");
        end;
    end;


    procedure DrillDownDirectCostApplToWIP(var InvtReportEntry: Record "Inventory Report Entry")
    begin
        DrillDownInventoryReportEntryAmount(
          InvtReportEntry,InvtReportEntry.FieldNo("Direct Cost Applied WIP"),ValueEntry.FieldNo("Cost Amount (Actual)"));
    end;

    local procedure SetFiltersDirectCostApplToWIP(var ValueEntry: Record "Value Entry";var InvtReportEntry: Record "Inventory Report Entry")
    begin
        with ValueEntry do begin
          CopyFiltersFronInventoryReportLine(ValueEntry,InvtReportEntry);
          SetRange("Entry Type","entry type"::"Direct Cost");
          SetRange("Order Type","order type"::Production);
          SetRange("Item Ledger Entry Type","item ledger entry type"::" ");
          SetRange("Variance Type");
        end;
    end;


    procedure DrillDownWIPToInvtInterim(var InvtReportEntry: Record "Inventory Report Entry")
    begin
        DrillDownInventoryReportEntryAmount(
          InvtReportEntry,InvtReportEntry.FieldNo("WIP To Interim"),ValueEntry.FieldNo("Cost Amount (Expected)"));
    end;

    local procedure SetFiltersWIPToInvtInterim(var ValueEntry: Record "Value Entry";var InvtReportEntry: Record "Inventory Report Entry")
    begin
        with ValueEntry do begin
          CopyFiltersFronInventoryReportLine(ValueEntry,InvtReportEntry);
          SetFilter("Entry Type",'%1|%2',"entry type"::"Direct Cost","entry type"::Revaluation);
          SetRange("Item Ledger Entry Type","item ledger entry type"::Output);
          SetRange("Order Type","order type"::Production);
          SetRange("Variance Type");
        end;
    end;


    procedure DrillDownInvtToWIP(var InvtReportEntry: Record "Inventory Report Entry")
    begin
        DrillDownInventoryReportEntryAmount(
          InvtReportEntry,InvtReportEntry.FieldNo("Inventory To WIP"),ValueEntry.FieldNo("Cost Amount (Actual)"));
    end;

    local procedure SetFiltersInvtToWIP(var ValueEntry: Record "Value Entry";var InvtReportEntry: Record "Inventory Report Entry")
    begin
        with ValueEntry do begin
          CopyFiltersFronInventoryReportLine(ValueEntry,InvtReportEntry);
          SetRange("Entry Type","entry type"::"Direct Cost");
          SetRange("Order Type","order type"::Production);
          SetFilter("Item Ledger Entry Type",'%1|%2',
            "item ledger entry type"::Output,
            "item ledger entry type"::Consumption);
          SetRange("Variance Type");
        end;
    end;


    procedure DrillDownInventory(var InvtReportEntry: Record "Inventory Report Entry")
    begin
        DrillDownInventoryReportEntryAmount(
          InvtReportEntry,InvtReportEntry.FieldNo(Inventory),ValueEntry.FieldNo("Cost Amount (Actual)"));
    end;

    local procedure SetFiltersInventory(var ValueEntry: Record "Value Entry";var InvtReportEntry: Record "Inventory Report Entry")
    begin
        with ValueEntry do begin
          CopyFiltersFronInventoryReportLine(ValueEntry,InvtReportEntry);
          SetRange("Entry Type");
          SetFilter("Item Ledger Entry Type",'<>%1',"item ledger entry type"::" ");
          SetRange("Variance Type");
          SetFilter("Item Ledger Entry Type",'<>%1',"item ledger entry type"::" ");
        end;
    end;


    procedure DrillDownDirectCostApplied(var InvtReportEntry: Record "Inventory Report Entry")
    begin
        DrillDownInventoryReportEntryAmount(
          InvtReportEntry,InvtReportEntry.FieldNo("Direct Cost Applied"),ValueEntry.FieldNo("Cost Amount (Actual)"));
    end;

    local procedure SetFiltersDirectCostApplied(var ValueEntry: Record "Value Entry";var InvtReportEntry: Record "Inventory Report Entry")
    begin
        with ValueEntry do begin
          CopyFiltersFronInventoryReportLine(ValueEntry,InvtReportEntry);
          SetRange("Entry Type","entry type"::"Direct Cost");
          SetFilter("Item Ledger Entry Type",'%1|%2',
            "item ledger entry type"::Purchase,
            "item ledger entry type"::" ");
          SetRange("Variance Type");
        end;
    end;


    procedure DrillDownOverheadApplied(var InvtReportEntry: Record "Inventory Report Entry")
    begin
        DrillDownInventoryReportEntryAmount(
          InvtReportEntry,InvtReportEntry.FieldNo("Overhead Applied"),ValueEntry.FieldNo("Cost Amount (Actual)"));
    end;

    local procedure SetFiltersOverheadApplied(var ValueEntry: Record "Value Entry";var InvtReportEntry: Record "Inventory Report Entry")
    begin
        with ValueEntry do begin
          CopyFiltersFronInventoryReportLine(ValueEntry,InvtReportEntry);
          SetRange("Entry Type","entry type"::"Indirect Cost");
          SetFilter("Item Ledger Entry Type",'%1|%2|%3|%4',
            "item ledger entry type"::Purchase,
            "item ledger entry type"::Output,
            "item ledger entry type"::"Assembly Output",
            "item ledger entry type"::" ");
          SetRange("Variance Type");
        end;
    end;

    local procedure DrillDownInventoryReportEntryAmount(var InvtReportEntry: Record "Inventory Report Entry";DrillDownFieldNo: Integer;ActiveFieldNo: Integer)
    begin
        if InvtReportEntry.Type = InvtReportEntry.Type::"G/L Account" then
          DrillDownGL(InvtReportEntry)
        else
          DrillDownInventoryReportValueEntry(InvtReportEntry,DrillDownFieldNo,ActiveFieldNo);
    end;

    local procedure DrillDownInventoryReportValueEntry(var InvtReportEntry: Record "Inventory Report Entry";DrillDownFieldNo: Integer;ActiveFieldNo: Integer)
    var
        ValueEntry: Record "Value Entry";
    begin
        case DrillDownFieldNo of
          InvtReportEntry.FieldNo("Direct Cost Applied Actual"):
            SetFiltersDirectCostApplActual(ValueEntry,InvtReportEntry);
          InvtReportEntry.FieldNo("Overhead Applied Actual"):
            SetFiltersOverheadAppliedActual(ValueEntry,InvtReportEntry);
          InvtReportEntry.FieldNo("Purchase Variance"):
            SetFiltersPurchaseVariance(ValueEntry,InvtReportEntry);
          InvtReportEntry.FieldNo("Inventory Adjmt."):
            SetFiltersInventoryAdjmt(ValueEntry,InvtReportEntry);
          InvtReportEntry.FieldNo("Invt. Accrual (Interim)"):
            SetFiltersInvtAccrualInterim(ValueEntry,InvtReportEntry);
          InvtReportEntry.FieldNo(COGS):
            SetFiltersCOGS(ValueEntry,InvtReportEntry);
          InvtReportEntry.FieldNo("COGS (Interim)"):
            SetFiltersCOGSInterim(ValueEntry,InvtReportEntry);
          InvtReportEntry.FieldNo("WIP Inventory"):
            SetFiltersWIPInventory(ValueEntry,InvtReportEntry);
          InvtReportEntry.FieldNo("Material Variance"):
            SetFiltersMaterialVariance(ValueEntry,InvtReportEntry);
          InvtReportEntry.FieldNo("Capacity Variance"):
            SetFiltersCapVariance(ValueEntry,InvtReportEntry);
          InvtReportEntry.FieldNo("Subcontracted Variance"):
            SetFiltersSubcontractedVariance(ValueEntry,InvtReportEntry);
          InvtReportEntry.FieldNo("Capacity Overhead Variance"):
            SetFiltersCapOverheadVariance(ValueEntry,InvtReportEntry);
          InvtReportEntry.FieldNo("Mfg. Overhead Variance"):
            SetFiltersMfgOverheadVariance(ValueEntry,InvtReportEntry);
          InvtReportEntry.FieldNo("Inventory (Interim)"):
            SetFiltersInventoryInterim(ValueEntry,InvtReportEntry);
          InvtReportEntry.FieldNo("Overhead Applied WIP"):
            SetFiltersOverheadAppliedToWIP(ValueEntry,InvtReportEntry);
          InvtReportEntry.FieldNo("Direct Cost Applied WIP"):
            SetFiltersDirectCostApplToWIP(ValueEntry,InvtReportEntry);
          InvtReportEntry.FieldNo("WIP To Interim"):
            SetFiltersWIPToInvtInterim(ValueEntry,InvtReportEntry);
          InvtReportEntry.FieldNo("Inventory To WIP"):
            SetFiltersInvtToWIP(ValueEntry,InvtReportEntry);
          InvtReportEntry.FieldNo(Inventory):
            SetFiltersInventory(ValueEntry,InvtReportEntry);
          InvtReportEntry.FieldNo("Direct Cost Applied"):
            SetFiltersDirectCostApplied(ValueEntry,InvtReportEntry);
          InvtReportEntry.FieldNo("Overhead Applied"):
            SetFiltersOverheadApplied(ValueEntry,InvtReportEntry);
        end;

        Page.Run(0,ValueEntry,ActiveFieldNo);
    end;


    procedure SetReportHeader(var InvtReportHeader2: Record "Inventory Report Header")
    begin
        InvtReportHeader.Copy(InvtReportHeader2);
    end;

    local procedure OpenWindow()
    begin
        Window.Open(
          Text000 +
          Text001 +
          Text002 +
          Text003);
        WindowIsOpen := true;
        WindowUpdateDateTime := CurrentDatetime;
    end;

    local procedure UpDateWindow(NewWindowType: Text[80];NewWindowNo: Code[20];NewWindowPostingType: Text[80])
    begin
        WindowType := NewWindowType;
        WindowNo := NewWindowNo;
        WindowPostingType := NewWindowPostingType;

        if IsTimeForUpdate then begin
          if not WindowIsOpen then
            OpenWindow;
          Window.Update(1,WindowType);
          Window.Update(2,WindowNo);
          Window.Update(3,WindowPostingType);
        end;
    end;

    local procedure IsTimeForUpdate(): Boolean
    begin
        if CurrentDatetime - WindowUpdateDateTime >= 1000 then begin
          WindowUpdateDateTime := CurrentDatetime;
          exit(true);
        end;
        exit(false);
    end;

    local procedure CheckExpectedCostPosting(var InventoryReportLine: Record "Inventory Report Entry"): Boolean
    var
        InvtSetup: Record "Inventory Setup";
    begin
        with InventoryReportLine do begin
          if ("Inventory (Interim)" <> 0) or
             ("WIP Inventory" <> 0) or
             ("Invt. Accrual (Interim)" <> 0) or
             ("COGS (Interim)" <> 0)
          then begin
            InvtSetup.Get;
            "Expected Cost Posting Warning" := not InvtSetup."Expected Cost Posting to G/L";
            Modify;
            exit(true);
          end;
          exit(false);
        end;
    end;

    local procedure CheckIfNoDifference(var InventoryReportLine: Record "Inventory Report Entry"): Boolean
    begin
        with InventoryReportLine do begin
          if (Inventory = 0) and
             ("WIP Inventory" = 0) and
             ("Direct Cost Applied Actual" = 0) and
             ("Overhead Applied Actual" = 0) and
             ("Purchase Variance" = 0) and
             ("Inventory Adjmt." = 0) and
             ("Invt. Accrual (Interim)" = 0) and
             (COGS = 0) and
             ("COGS (Interim)" = 0) and
             ("Material Variance" = 0) and
             ("Capacity Variance" = 0) and
             ("Subcontracted Variance" = 0) and
             ("Capacity Overhead Variance" = 0) and
             ("Mfg. Overhead Variance" = 0) and
             ("Direct Cost Applied WIP" = 0) and
             ("Overhead Applied WIP" = 0) and
             ("Inventory To WIP" = 0) and
             ("WIP To Interim" = 0) and
             ("Direct Cost Applied" = 0) and
             ("Overhead Applied" = 0)
          then
            exit(true);
          exit(false);
        end;
    end;

    local procedure CheckCostIsPostedToGL(var InventoryReportLine: Record "Inventory Report Entry"): Boolean
    var
        ValueEntry: Record "Value Entry";
    begin
        with InventoryReportLine do begin
          ValueEntry.SetCurrentkey("Item No.","Posting Date");
          if ValueEntry.FindFirst then
            repeat
              ValueEntry.SetRange("Item No.",ValueEntry."Item No.");
              ValueEntry.SetRange("Posting Date",ValueEntry."Posting Date");
              if ValueEntryInFilteredSet(ValueEntry,InvtReportHeader,false) then
                repeat
                  ValueEntry.SetRange("Entry Type",ValueEntry."Entry Type");
                  ValueEntry.SetRange("Item Ledger Entry Type",ValueEntry."Item Ledger Entry Type");
                  ValueEntry.SetRange("Location Code",ValueEntry."Location Code");
                  ValueEntry.SetRange("Variance Type",ValueEntry."Variance Type");

                  if ValueEntryInFilteredSet(ValueEntry,InvtReportHeader,true) then begin
                    ValueEntry.SetRange("Cost Posted to G/L",0);
                    ValueEntry.SetFilter("Cost Amount (Actual)",'<>%1',0);
                    if ValueEntry.FindLast then begin
                      "Cost is Posted to G/L Warning" := true;
                      Modify;
                      exit(true);
                    end;
                    ValueEntry.SetRange("Cost Posted to G/L");
                    ValueEntry.SetRange("Cost Amount (Actual)");
                  end;
                  ValueEntry.FindLast;
                  ValueEntry.SetRange("Entry Type");
                  ValueEntry.SetRange("Item Ledger Entry Type");
                  ValueEntry.SetRange("Location Code");
                  ValueEntry.SetRange("Variance Type");
                until ValueEntry.Next = 0;

              if ValueEntry.FindLast then;
              ValueEntry.SetRange("Item No.");
              ValueEntry.SetRange("Posting Date");
            until ValueEntry.Next = 0;
          exit(false);
        end;
    end;

    local procedure CheckValueGLCompression(var InventoryReportLine: Record "Inventory Report Entry"): Boolean
    var
        DateComprRegister: Record "Date Compr. Register";
        InStartDateCompr: Boolean;
        InEndDateCompr: Boolean;
    begin
        with InventoryReportLine do begin
          DateComprRegister.SetCurrentkey("Table ID");
          DateComprRegister.SetFilter("Table ID",'%1|%2',Database::"Value Entry",Database::"G/L Entry");
          DateComprRegister.SetFilter("Starting Date",InvtReportHeader.GetFilter("Posting Date Filter"));
          InStartDateCompr := DateComprRegister.FindFirst;
          DateComprRegister.SetFilter("Ending Date",InvtReportHeader.GetFilter("Posting Date Filter"));
          InEndDateCompr := DateComprRegister.FindFirst;
          if InEndDateCompr or InStartDateCompr then begin
            "Compression Warning" := true;
            Modify;
            exit(true);
          end;
          exit(false);
        end;
    end;

    local procedure CheckGLClosingOverlaps(var InventoryReportLine: Record "Inventory Report Entry"): Boolean
    var
        AccountingPeriod: Record "Accounting Period";
        GLEntry: Record "G/L Entry";
        MinDate: Date;
        found: Boolean;
    begin
        with InventoryReportLine do begin
          if not (("Direct Cost Applied Actual" = 0) and
                  ("Overhead Applied Actual" = 0) and
                  ("Purchase Variance" = 0) and
                  ("Inventory Adjmt." = 0) and
                  (COGS = 0) and
                  ("Material Variance" = 0) and
                  ("Capacity Variance" = 0) and
                  ("Subcontracted Variance" = 0) and
                  ("Capacity Overhead Variance" = 0) and
                  ("Mfg. Overhead Variance" = 0) and
                  ("Direct Cost Applied WIP" = 0) and
                  ("Overhead Applied WIP" = 0) and
                  ("Inventory To WIP" = 0) and
                  ("Direct Cost Applied" = 0) and
                  ("Overhead Applied" = 0))
          then begin
            AccountingPeriod.SetFilter("Starting Date",InvtReportHeader.GetFilter("Posting Date Filter"));
            if InvtReportHeader.GetFilter("Posting Date Filter") <> '' then
              MinDate := InvtReportHeader.GetRangeMin("Posting Date Filter")
            else
              MinDate := 0D;

            found :=
              AccountingPeriod.Find('-') and AccountingPeriod.Closed and
              (AccountingPeriod."Starting Date" <= MinDate);
            if AccountingPeriod."Starting Date" > MinDate then begin
              AccountingPeriod.SetRange("Starting Date");
              if not found then
                found :=
                  AccountingPeriod.Next(-1) <> 0;
              if not found then
                found := AccountingPeriod.Closed;
            end;
            if found then
              repeat
                repeat
                until (AccountingPeriod.Next = 0) or AccountingPeriod."New Fiscal Year";
                if AccountingPeriod."New Fiscal Year" then
                  AccountingPeriod."Starting Date" := ClosingDate(CalcDate('<-1D>',AccountingPeriod."Starting Date"))
                else
                  AccountingPeriod."Starting Date" := ClosingDate(AccountingPeriod."Starting Date");
                AccountingPeriod.SetFilter("Starting Date",InvtReportHeader.GetFilter("Posting Date Filter"));
                GLEntry.SetRange("Posting Date",AccountingPeriod."Starting Date");
                if not GLEntry.IsEmpty then begin
                  "Closing Period Overlap Warning" := true;
                  Modify;
                  exit(true);
                end;
                AccountingPeriod.SetRange(Closed,true);
              until AccountingPeriod.Next = 0;
          end;
          exit(false);
        end;
    end;

    local procedure CheckDeletedGLAcc(var InventoryReportLine: Record "Inventory Report Entry"): Boolean
    var
        GLEntry: Record "G/L Entry";
    begin
        with InventoryReportLine do begin
          GLEntry.Reset;
          GLEntry.SetCurrentkey("G/L Account No.","Posting Date");
          GLEntry.SetRange("G/L Account No.",'');
          GLEntry.SetFilter("Posting Date",InvtReportHeader.GetFilter("Posting Date Filter"));
          if GLEntry.FindFirst then begin
            "Deleted G/L Accounts Warning" := true;
            Modify;
            exit(true);
          end;
          exit(false);
        end;
    end;

    local procedure CheckPostingDateToGLNotTheSame(var InventoryReportLine: Record "Inventory Report Entry"): Boolean
    var
        ValueEntry: Record "Value Entry";
        InvtPostingSetup: Record "Inventory Posting Setup";
        TempInvtPostingSetup: Record "Inventory Posting Setup" temporary;
        TotalInventory: Decimal;
    begin
        with InventoryReportLine do begin
          ValueEntry.Reset;
          ValueEntry.SetCurrentkey("Item No.");
          if ValueEntry.FindFirst then
            repeat
              ValueEntry.SetRange("Item No.",ValueEntry."Item No.");
              if ValueEntry."Item No." <> '' then
                TotalInventory := TotalInventory + CalcInventory(ValueEntry);
              ValueEntry.FindLast;
              ValueEntry.SetRange("Item No.");
            until ValueEntry.Next = 0;

          if InvtPostingSetup.Find('-') then
            repeat
              TempInvtPostingSetup.Reset;
              TempInvtPostingSetup.SetRange("Inventory Account",InvtPostingSetup."Inventory Account");
              if not TempInvtPostingSetup.FindFirst then
                if GLAcc.Get(InvtPostingSetup."Inventory Account") then
                  TotalInventory := TotalInventory - CalcGLAccount(GLAcc);
              TempInvtPostingSetup := InvtPostingSetup;
              TempInvtPostingSetup.Insert;
            until InvtPostingSetup.Next = 0;
          if TotalInventory = 0 then begin
            "Posting Date Warning" := true;
            Modify;
            exit(true);
          end;
          exit(false);
        end;
    end;

    local procedure CheckDirectPostings(var InventoryReportLine: Record "Inventory Report Entry"): Boolean
    begin
        with InventoryReportLine do begin
          if Inventory +
             "Inventory (Interim)" +
             "WIP Inventory" +
             "Direct Cost Applied Actual" +
             "Overhead Applied Actual" +
             "Purchase Variance" +
             "Inventory Adjmt." +
             "Invt. Accrual (Interim)" +
             COGS +
             "COGS (Interim)" +
             "Material Variance" +
             "Capacity Variance" +
             "Subcontracted Variance" +
             "Capacity Overhead Variance" +
             "Mfg. Overhead Variance" +
             "Direct Cost Applied WIP" +
             "Overhead Applied WIP" +
             "Direct Cost Applied" +
             "Overhead Applied" <>
             0
          then begin
            "Direct Postings Warning" := true;
            Modify;
            exit(true);
          end;
          exit(false);
        end;
    end;
}

