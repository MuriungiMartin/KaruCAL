#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1012 "Job Jnl.-Post Line"
{
    Permissions = TableData "Job Ledger Entry"=imd,
                  TableData "Job Register"=imd,
                  TableData "Value Entry"=rimd;
    TableNo = "Job Journal Line";

    trigger OnRun()
    begin
        GetGLSetup;
        RunWithCheck(Rec);
    end;

    var
        Cust: Record Customer;
        Job: Record Job;
        JobTask: Record "Job Task";
        JobLedgEntry: Record "Job Ledger Entry";
        JobJnlLine: Record "Job Journal Line";
        JobJnlLine2: Record "Job Journal Line";
        ResJnlLine: Record "Res. Journal Line";
        ItemJnlLine: Record "Item Journal Line";
        JobReg: Record "Job Register";
        GLSetup: Record "General Ledger Setup";
        CurrExchRate: Record "Currency Exchange Rate";
        Currency: Record Currency;
        Location: Record Location;
        Item: Record Item;
        JobJnlCheckLine: Codeunit "Job Jnl.-Check Line";
        ResJnlPostLine: Codeunit "Res. Jnl.-Post Line";
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
        JobPostLine: Codeunit "Job Post-Line";
        XferCustomFields: Codeunit "Transfer Custom Fields";
        GLSetupRead: Boolean;
        NextEntryNo: Integer;
        GLEntryNo: Integer;
        Text000: label 'The Job Planning Line No. field must have a value when reservation entries exist. Journal Template Name=%1, Job Journal Batch Name=%2, Line No.=%3. It cannot be zero or empty.';


    procedure RunWithCheck(var JobJnlLine2: Record "Job Journal Line"): Integer
    var
        JobLedgEntryNo: Integer;
    begin
        JobJnlLine.Copy(JobJnlLine2);
        JobLedgEntryNo := Code(true);
        JobJnlLine2 := JobJnlLine;
        exit(JobLedgEntryNo);
    end;

    local procedure "Code"(CheckLine: Boolean): Integer
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        ResLedgEntry: Record "Res. Ledger Entry";
        ValueEntry: Record "Value Entry";
        JobLedgEntry2: Record "Job Ledger Entry";
        JobPlanningLine: Record "Job Planning Line";
        TempTrackingSpecification: Record "Tracking Specification" temporary;
        ItemJnlLine2: Record "Item Journal Line";
        JobJnlLineReserve: Codeunit "Job Jnl. Line-Reserve";
        JobLedgEntryNo: Integer;
        SkipJobLedgerEntry: Boolean;
        ApplyToJobContractEntryNo: Boolean;
        TempRemainingQty: Decimal;
        RemainingAmount: Decimal;
        RemainingAmountLCY: Decimal;
        RemainingQtyToTrack: Decimal;
    begin
        GetGLSetup;

        with JobJnlLine do begin
          if EmptyLine then
            exit;

          if CheckLine then
            JobJnlCheckLine.RunCheck(JobJnlLine);

          if JobLedgEntry."Entry No." = 0 then begin
            JobLedgEntry.LockTable;
            if JobLedgEntry.FindLast then
              NextEntryNo := JobLedgEntry."Entry No.";
            NextEntryNo := NextEntryNo + 1;
          end;

          if "Document Date" = 0D then
            "Document Date" := "Posting Date";

          if JobReg."No." = 0 then begin
            JobReg.LockTable;
            if (not JobReg.FindLast) or (JobReg."To Entry No." <> 0) then begin
              JobReg.Init;
              JobReg."No." := JobReg."No." + 1;
              JobReg."From Entry No." := NextEntryNo;
              JobReg."To Entry No." := NextEntryNo;
              JobReg."Creation Date" := Today;
              JobReg."Source Code" := "Source Code";
              JobReg."Journal Batch Name" := "Journal Batch Name";
              JobReg."User ID" := UserId;
              JobReg.Insert;
            end;
          end;
          Job.Get("Job No.");
          Job.TestBlocked;
          Job.TestField("Bill-to Customer No.");
          Cust.Get(Job."Bill-to Customer No.");
          TestField("Currency Code",Job."Currency Code");
          JobTask.Get("Job No.","Job Task No.");
          JobTask.TestField("Job Task Type",JobTask."job task type"::Posting);
          JobJnlLine2 := JobJnlLine;

          GetGLSetup;
          if GLSetup."Additional Reporting Currency" <> '' then begin
            if JobJnlLine2."Source Currency Code" <> GLSetup."Additional Reporting Currency" then begin
              Currency.Get(GLSetup."Additional Reporting Currency");
              Currency.TestField("Amount Rounding Precision");
              JobJnlLine2."Source Currency Total Cost" :=
                ROUND(
                  CurrExchRate.ExchangeAmtLCYToFCY(
                    JobJnlLine2."Posting Date",
                    GLSetup."Additional Reporting Currency",JobJnlLine2."Total Cost (LCY)",
                    CurrExchRate.ExchangeRate(
                      JobJnlLine2."Posting Date",GLSetup."Additional Reporting Currency")),
                  Currency."Amount Rounding Precision");
              JobJnlLine2."Source Currency Total Price" :=
                ROUND(
                  CurrExchRate.ExchangeAmtLCYToFCY(
                    JobJnlLine2."Posting Date",
                    GLSetup."Additional Reporting Currency",JobJnlLine2."Total Price (LCY)",
                    CurrExchRate.ExchangeRate(
                      JobJnlLine2."Posting Date",GLSetup."Additional Reporting Currency")),
                  Currency."Amount Rounding Precision");
              JobJnlLine2."Source Currency Line Amount" :=
                ROUND(
                  CurrExchRate.ExchangeAmtLCYToFCY(
                    JobJnlLine2."Posting Date",
                    GLSetup."Additional Reporting Currency",JobJnlLine2."Line Amount (LCY)",
                    CurrExchRate.ExchangeRate(
                      JobJnlLine2."Posting Date",GLSetup."Additional Reporting Currency")),
                  Currency."Amount Rounding Precision");
            end;
          end else begin
            JobJnlLine2."Source Currency Total Cost" := 0;
            JobJnlLine2."Source Currency Total Price" := 0;
            JobJnlLine2."Source Currency Line Amount" := 0;
          end;

          if JobJnlLine2."Entry Type" = JobJnlLine2."entry type"::Usage then begin
            case Type of
              Type::Resource:
                begin
                  InitResJnlLine;
                  XferCustomFields.JobJnlLineTOResJnlLine(JobJnlLine,ResJnlLine);

                  ResLedgEntry.LockTable;
                  ResJnlPostLine.RunWithCheck(ResJnlLine);
                  JobJnlLine2."Resource Group No." := ResJnlLine."Resource Group No.";
                  JobLedgEntryNo := CreateJobLedgEntry(JobJnlLine2);
                end;
              Type::Item:
                begin
                  if not "Job Posting Only" then begin
                    InitItemJnlLine;
                    JobJnlLineReserve.TransJobJnlLineToItemJnlLine(JobJnlLine2,ItemJnlLine,ItemJnlLine."Quantity (Base)");

                    ApplyToJobContractEntryNo := false;
                    if JobPlanningLine.Get("Job No.","Job Task No.","Job Planning Line No.") then
                      ApplyToJobContractEntryNo := true
                    else
                      if JobPlanningReservationExists(JobJnlLine2."No.",JobJnlLine2."Job No.") then
                        if ApplyToMatchingJobPlanningLine(JobJnlLine2,JobPlanningLine) then
                          ApplyToJobContractEntryNo := true
                        else
                          Error(Text000,"Journal Template Name","Journal Batch Name","Line No.");

                    if ApplyToJobContractEntryNo then
                      ItemJnlLine."Job Contract Entry No." := JobPlanningLine."Job Contract Entry No.";

                    ItemLedgEntry.LockTable;
                    ItemJnlLine2 := ItemJnlLine;
                    ItemJnlPostLine.RunWithCheck(ItemJnlLine);
                    ItemJnlPostLine.CollectTrackingSpecification(TempTrackingSpecification);
                    PostWhseJnlLine(ItemJnlLine2,ItemJnlLine2.Quantity,ItemJnlLine2."Quantity (Base)",TempTrackingSpecification);
                  end;

                  if GetJobConsumptionValueEntry(ValueEntry,JobJnlLine) then begin
                    RemainingAmount := JobJnlLine2."Line Amount";
                    RemainingAmountLCY := JobJnlLine2."Line Amount (LCY)";
                    RemainingQtyToTrack := JobJnlLine2.Quantity;

                    repeat
                      SkipJobLedgerEntry := false;
                      if ItemLedgEntry.Get(ValueEntry."Item Ledger Entry No.") then begin
                        JobLedgEntry2.SetRange("Ledger Entry Type",JobLedgEntry2."ledger entry type"::Item);
                        JobLedgEntry2.SetRange("Ledger Entry No.",ItemLedgEntry."Entry No.");
                        // The following code is only to secure that JLEs created at receipt in version 6.0 or earlier,
                        // are not created again at point of invoice (6.0 SP1 and newer).
                        if JobLedgEntry2.FindFirst and (JobLedgEntry2.Quantity = -ItemLedgEntry.Quantity) then
                          SkipJobLedgerEntry := true
                        else begin
                          JobJnlLine2."Serial No." := ItemLedgEntry."Serial No.";
                          JobJnlLine2."Lot No." := ItemLedgEntry."Lot No.";
                        end;
                      end;
                      if not SkipJobLedgerEntry then begin
                        TempRemainingQty := JobJnlLine2."Remaining Qty.";
                        JobJnlLine2.Quantity := -ValueEntry."Invoiced Quantity" / "Qty. per Unit of Measure";
                        JobJnlLine2."Quantity (Base)" := ROUND(JobJnlLine2.Quantity * "Qty. per Unit of Measure",0.00001);
                        if "Currency Code" <> '' then
                          Currency.Get("Currency Code")
                        else
                          Currency.InitRoundingPrecision;

                        UpdateJobJnlLineTotalAmounts(JobJnlLine2,Currency."Amount Rounding Precision");
                        UpdateJobJnlLineAmount(
                          JobJnlLine2,RemainingAmount,RemainingAmountLCY,RemainingQtyToTrack,Currency."Amount Rounding Precision");

                        JobJnlLine2.Validate("Remaining Qty.",TempRemainingQty);
                        JobJnlLine2."Ledger Entry Type" := "ledger entry type"::Item;
                        JobJnlLine2."Ledger Entry No." := ValueEntry."Item Ledger Entry No.";
                        JobLedgEntryNo := CreateJobLedgEntry(JobJnlLine2);
                        ValueEntry."Job Ledger Entry No." := JobLedgEntryNo;
                        ValueEntry.Modify(true);
                      end;
                    until ValueEntry.Next = 0;
                  end;
                end;
              Type::"G/L Account":
                JobLedgEntryNo := CreateJobLedgEntry(JobJnlLine2);
            end;
          end else
            JobLedgEntryNo := CreateJobLedgEntry(JobJnlLine2);
        end;

        exit(JobLedgEntryNo);
    end;

    local procedure GetGLSetup()
    begin
        if not GLSetupRead then
          GLSetup.Get;
        GLSetupRead := true;
    end;

    local procedure CreateJobLedgEntry(JobJnlLine2: Record "Job Journal Line"): Integer
    var
        ResLedgEntry: Record "Res. Ledger Entry";
        JobPlanningLine: Record "Job Planning Line";
        Job: Record Job;
        JobTransferLine: Codeunit "Job Transfer Line";
        JobLinkUsage: Codeunit "Job Link Usage";
    begin
        SetCurrency(JobJnlLine2);

        JobLedgEntry.Init;
        JobTransferLine.FromJnlLineToLedgEntry(JobJnlLine2,JobLedgEntry);

        if JobLedgEntry."Entry Type" = JobLedgEntry."entry type"::Sale then begin
          JobLedgEntry.Quantity := -JobJnlLine2.Quantity;
          JobLedgEntry."Quantity (Base)" := -JobJnlLine2."Quantity (Base)";

          JobLedgEntry."Total Cost (LCY)" := -JobJnlLine2."Total Cost (LCY)";
          JobLedgEntry."Total Cost" := -JobJnlLine2."Total Cost";

          JobLedgEntry."Total Price (LCY)" := -JobJnlLine2."Total Price (LCY)";
          JobLedgEntry."Total Price" := -JobJnlLine2."Total Price";

          JobLedgEntry."Line Amount (LCY)" := -JobJnlLine2."Line Amount (LCY)";
          JobLedgEntry."Line Amount" := -JobJnlLine2."Line Amount";

          JobLedgEntry."Line Discount Amount (LCY)" := -JobJnlLine2."Line Discount Amount (LCY)";
          JobLedgEntry."Line Discount Amount" := -JobJnlLine2."Line Discount Amount";
        end else begin
          JobLedgEntry.Quantity := JobJnlLine2.Quantity;
          JobLedgEntry."Quantity (Base)" := JobJnlLine2."Quantity (Base)";

          JobLedgEntry."Total Cost (LCY)" := JobJnlLine2."Total Cost (LCY)";
          JobLedgEntry."Total Cost" := JobJnlLine2."Total Cost";

          JobLedgEntry."Total Price (LCY)" := JobJnlLine2."Total Price (LCY)";
          JobLedgEntry."Total Price" := JobJnlLine2."Total Price";

          JobLedgEntry."Line Amount (LCY)" := JobJnlLine2."Line Amount (LCY)";
          JobLedgEntry."Line Amount" := JobJnlLine2."Line Amount";

          JobLedgEntry."Line Discount Amount (LCY)" := JobJnlLine2."Line Discount Amount (LCY)";
          JobLedgEntry."Line Discount Amount" := JobJnlLine2."Line Discount Amount";
        end;

        JobLedgEntry."Additional-Currency Total Cost" := -JobLedgEntry."Additional-Currency Total Cost";
        JobLedgEntry."Add.-Currency Total Price" := -JobLedgEntry."Add.-Currency Total Price";
        JobLedgEntry."Add.-Currency Line Amount" := -JobLedgEntry."Add.-Currency Line Amount";

        JobLedgEntry."Entry No." := NextEntryNo;
        JobLedgEntry."No. Series" := JobJnlLine2."Posting No. Series";
        JobLedgEntry."Original Unit Cost (LCY)" := JobLedgEntry."Unit Cost (LCY)";
        JobLedgEntry."Original Total Cost (LCY)" := JobLedgEntry."Total Cost (LCY)";
        JobLedgEntry."Original Unit Cost" := JobLedgEntry."Unit Cost";
        JobLedgEntry."Original Total Cost" := JobLedgEntry."Total Cost";
        JobLedgEntry."Original Total Cost (ACY)" := JobLedgEntry."Additional-Currency Total Cost";
        JobLedgEntry."Dimension Set ID" := JobJnlLine2."Dimension Set ID";

        with JobJnlLine2 do
          case Type of
            Type::Resource:
              begin
                if "Entry Type" = "entry type"::Usage then begin
                  if ResLedgEntry.FindLast then begin
                    JobLedgEntry."Ledger Entry Type" := JobLedgEntry."ledger entry type"::Resource;
                    JobLedgEntry."Ledger Entry No." := ResLedgEntry."Entry No.";
                  end;
                end;
              end;
            Type::Item:
              begin
                JobLedgEntry."Ledger Entry Type" := "ledger entry type"::Item;
                JobLedgEntry."Ledger Entry No." := "Ledger Entry No.";
                JobLedgEntry."Serial No." := "Serial No.";
                JobLedgEntry."Lot No." := "Lot No.";
              end;
            Type::"G/L Account":
              begin
                JobLedgEntry."Ledger Entry Type" := JobLedgEntry."ledger entry type"::" ";
                if GLEntryNo > 0 then begin
                  JobLedgEntry."Ledger Entry Type" := JobLedgEntry."ledger entry type"::"G/L Account";
                  JobLedgEntry."Ledger Entry No." := GLEntryNo;
                  GLEntryNo := 0;
                end;
              end;
          end;
        if JobLedgEntry."Entry Type" = JobLedgEntry."entry type"::Sale then begin
          JobLedgEntry."Serial No." := JobJnlLine2."Serial No.";
          JobLedgEntry."Lot No." := JobJnlLine2."Lot No.";
        end;
        XferCustomFields.JobJnlLineTOJobLedgEntry(JobJnlLine,JobLedgEntry);
        JobLedgEntry.Insert(true);

        JobReg."To Entry No." := NextEntryNo;
        JobReg.Modify;

        if JobLedgEntry."Entry Type" = JobLedgEntry."entry type"::Usage then begin
          // Usage Link should be applied if it is enabled for the job,
          // if a Job Planning Line number is defined or if it is enabled for a Job Planning Line.
          Job.Get(JobLedgEntry."Job No.");
          if Job."Apply Usage Link" or
             (JobJnlLine2."Job Planning Line No." <> 0) or
             JobLinkUsage.FindMatchingJobPlanningLine(JobPlanningLine,JobLedgEntry)
          then
            JobLinkUsage.ApplyUsage(JobLedgEntry,JobJnlLine2)
          else
            JobPostLine.InsertPlLineFromLedgEntry(JobLedgEntry)
        end;

        NextEntryNo := NextEntryNo + 1;

        exit(JobLedgEntry."Entry No.");
    end;

    local procedure SetCurrency(JobJnlLine: Record "Job Journal Line")
    begin
        if JobJnlLine."Currency Code" = '' then begin
          Clear(Currency);
          Currency.InitRoundingPrecision
        end else begin
          Currency.Get(JobJnlLine."Currency Code");
          Currency.TestField("Amount Rounding Precision");
          Currency.TestField("Unit-Amount Rounding Precision");
        end;
    end;

    local procedure PostWhseJnlLine(ItemJnlLine: Record "Item Journal Line";OriginalQuantity: Decimal;OriginalQuantityBase: Decimal;var TempTrackingSpecification: Record "Tracking Specification" temporary)
    var
        WarehouseJournalLine: Record "Warehouse Journal Line";
        TempWarehouseJournalLine: Record "Warehouse Journal Line" temporary;
        ItemTrackingManagement: Codeunit "Item Tracking Management";
        WMSManagement: Codeunit "WMS Management";
    begin
        with ItemJnlLine do begin
          if "Entry Type" in ["entry type"::Consumption,"entry type"::Output] then
            exit;

          Quantity := OriginalQuantity;
          "Quantity (Base)" := OriginalQuantityBase;
          GetLocation("Location Code");
          if Location."Bin Mandatory" then
            if WMSManagement.CreateWhseJnlLine(ItemJnlLine,0,WarehouseJournalLine,false) then begin
              TempTrackingSpecification.ModifyAll("Source Type",Database::"Job Journal Line");
              ItemTrackingManagement.SplitWhseJnlLine(WarehouseJournalLine,TempWarehouseJournalLine,TempTrackingSpecification,false);
              if TempWarehouseJournalLine.Find('-') then
                repeat
                  WMSManagement.CheckWhseJnlLine(TempWarehouseJournalLine,1,0,false);
                  Codeunit.Run(Codeunit::"Whse. Jnl.-Register Line",TempWarehouseJournalLine);
                until TempWarehouseJournalLine.Next = 0;
            end;
        end;
    end;

    local procedure GetLocation(LocationCode: Code[10])
    begin
        if LocationCode = '' then
          Clear(Location)
        else
          if Location.Code <> LocationCode then
            Location.Get(LocationCode);
    end;


    procedure SetGLEntryNo(GLEntryNo2: Integer)
    begin
        GLEntryNo := GLEntryNo2;
    end;

    local procedure InitResJnlLine()
    begin
        with ResJnlLine do begin
          Init;
          "Entry Type" := JobJnlLine2."Entry Type";
          "Document No." := JobJnlLine2."Document No.";
          "External Document No." := JobJnlLine2."External Document No.";
          "Posting Date" := JobJnlLine2."Posting Date";
          "Document Date" := JobJnlLine2."Document Date";
          "Resource No." := JobJnlLine2."No.";
          Description := JobJnlLine2.Description;
          "Work Type Code" := JobJnlLine2."Work Type Code";
          "Job No." := JobJnlLine2."Job No.";
          "Shortcut Dimension 1 Code" := JobJnlLine2."Shortcut Dimension 1 Code";
          "Shortcut Dimension 2 Code" := JobJnlLine2."Shortcut Dimension 2 Code";
          "Dimension Set ID" := JobJnlLine2."Dimension Set ID";
          "Unit of Measure Code" := JobJnlLine2."Unit of Measure Code";
          "Source Code" := JobJnlLine2."Source Code";
          "Gen. Bus. Posting Group" := JobJnlLine2."Gen. Bus. Posting Group";
          "Gen. Prod. Posting Group" := JobJnlLine2."Gen. Prod. Posting Group";
          "Posting No. Series" := JobJnlLine2."Posting No. Series";
          "Reason Code" := JobJnlLine2."Reason Code";
          "Resource Group No." := JobJnlLine2."Resource Group No.";
          "Recurring Method" := JobJnlLine2."Recurring Method";
          "Expiration Date" := JobJnlLine2."Expiration Date";
          "Recurring Frequency" := JobJnlLine2."Recurring Frequency";
          Quantity := JobJnlLine2.Quantity;
          "Qty. per Unit of Measure" := JobJnlLine2."Qty. per Unit of Measure";
          "Direct Unit Cost" := JobJnlLine2."Direct Unit Cost (LCY)";
          "Unit Cost" := JobJnlLine2."Unit Cost (LCY)";
          "Total Cost" := JobJnlLine2."Total Cost (LCY)";
          "Unit Price" := JobJnlLine2."Unit Price (LCY)";
          "Total Price" := JobJnlLine2."Line Amount (LCY)";
          "Time Sheet No." := JobJnlLine2."Time Sheet No.";
          "Time Sheet Line No." := JobJnlLine2."Time Sheet Line No.";
          "Time Sheet Date" := JobJnlLine2."Time Sheet Date";
        end;
    end;

    local procedure InitItemJnlLine()
    begin
        with ItemJnlLine do begin
          Init;
          "Line No." := "Line No.";
          "Item No." := JobJnlLine2."No.";
          Item.Get(JobJnlLine2."No.");
          "Inventory Posting Group" := Item."Inventory Posting Group";
          "Posting Date" := JobJnlLine2."Posting Date";
          "Document Date" := JobJnlLine2."Document Date";
          "Source Type" := "source type"::Customer;
          "Source No." := Job."Bill-to Customer No.";
          "Document No." := JobJnlLine2."Document No.";

          "External Document No." := JobJnlLine2."External Document No.";
          Description := JobJnlLine2.Description;
          "Location Code" := JobJnlLine2."Location Code";
          "Applies-to Entry" := JobJnlLine2."Applies-to Entry";
          "Applies-from Entry" := JobJnlLine2."Applies-from Entry";
          "Shortcut Dimension 1 Code" := JobJnlLine2."Shortcut Dimension 1 Code";
          "Shortcut Dimension 2 Code" := JobJnlLine2."Shortcut Dimension 2 Code";
          "Dimension Set ID" := JobJnlLine2."Dimension Set ID";
          "Country/Region Code" := JobJnlLine2."Country/Region Code";
          "Entry Type" := "entry type"::"Negative Adjmt.";
          "Source Code" := JobJnlLine2."Source Code";
          "Gen. Bus. Posting Group" := JobJnlLine2."Gen. Bus. Posting Group";
          "Gen. Prod. Posting Group" := JobJnlLine2."Gen. Prod. Posting Group";
          "Posting No. Series" := JobJnlLine2."Posting No. Series";
          "Variant Code" := JobJnlLine2."Variant Code";
          "Bin Code" := JobJnlLine2."Bin Code";
          "Unit of Measure Code" := JobJnlLine2."Unit of Measure Code";
          "Reason Code" := JobJnlLine2."Reason Code";

          "Transaction Type" := JobJnlLine2."Transaction Type";
          "Transport Method" := JobJnlLine2."Transport Method";
          "Entry/Exit Point" := JobJnlLine2."Entry/Exit Point";
          Area := JobJnlLine2.Area;
          "Transaction Specification" := JobJnlLine2."Transaction Specification";
          "Invoiced Quantity" := JobJnlLine2.Quantity;
          "Invoiced Qty. (Base)" := JobJnlLine2."Quantity (Base)";
          "Source Currency Code" := JobJnlLine2."Source Currency Code";

          "Item Category Code" := Item."Item Category Code";
          "Product Group Code" := Item."Product Group Code";
          XferCustomFields.JobJnlLineTOItemJnlLine(JobJnlLine,ItemJnlLine);

          Quantity := JobJnlLine2.Quantity;
          "Quantity (Base)" := JobJnlLine2."Quantity (Base)";
          "Qty. per Unit of Measure" := JobJnlLine2."Qty. per Unit of Measure";
          "Unit Cost" := JobJnlLine2."Unit Cost (LCY)";
          "Unit Cost (ACY)" := JobJnlLine2."Unit Cost";
          Amount := JobJnlLine2."Total Cost (LCY)";
          "Amount (ACY)" := JobJnlLine2."Total Cost";
          "Value Entry Type" := "value entry type"::"Direct Cost";

          "Job No." := JobJnlLine2."Job No.";
          "Job Task No." := JobJnlLine2."Job Task No.";
        end;
    end;

    local procedure UpdateJobJnlLineTotalAmounts(var JobJnlLineToUpdate: Record "Job Journal Line";AmtRoundingPrecision: Decimal)
    begin
        with JobJnlLineToUpdate do begin
          "Total Cost" := ROUND("Unit Cost" * Quantity,AmtRoundingPrecision);
          "Total Cost (LCY)" := ROUND("Unit Cost (LCY)" * Quantity,AmtRoundingPrecision);
          "Total Price" := ROUND("Unit Price" * Quantity,AmtRoundingPrecision);
          "Total Price (LCY)" := ROUND("Unit Price (LCY)" * Quantity,AmtRoundingPrecision);
        end;
    end;

    local procedure UpdateJobJnlLineAmount(var JobJnlLineToUpdate: Record "Job Journal Line";var RemainingAmount: Decimal;var RemainingAmountLCY: Decimal;var RemainingQtyToTrack: Decimal;AmtRoundingPrecision: Decimal)
    begin
        with JobJnlLineToUpdate do begin
          "Line Amount" := ROUND(RemainingAmount * Quantity / RemainingQtyToTrack,AmtRoundingPrecision);
          "Line Amount (LCY)" := ROUND(RemainingAmountLCY * Quantity / RemainingQtyToTrack,AmtRoundingPrecision);

          RemainingAmount -= "Line Amount";
          RemainingAmountLCY -= "Line Amount (LCY)";
          RemainingQtyToTrack -= Quantity;
        end;
    end;

    local procedure JobPlanningReservationExists(ItemNo: Code[20];JobNo: Code[20]): Boolean
    var
        ReservationEntry: Record "Reservation Entry";
    begin
        with ReservationEntry do begin
          SetRange("Item No.",ItemNo);
          SetRange("Source Type",Database::"Job Planning Line");
          SetRange("Source Subtype",Job.Status::Open);
          SetRange("Source ID",JobNo);
          exit(not IsEmpty);
        end;
    end;

    local procedure GetJobConsumptionValueEntry(var ValueEntry: Record "Value Entry";JobJournalLine: Record "Job Journal Line"): Boolean
    begin
        with JobJournalLine do begin
          ValueEntry.SetCurrentkey("Job No.","Job Task No.","Document No.");
          ValueEntry.SetRange("Item No.","No.");
          ValueEntry.SetRange("Job No.","Job No.");
          ValueEntry.SetRange("Job Task No.","Job Task No.");
          ValueEntry.SetRange("Document No.","Document No.");
          ValueEntry.SetRange("Item Ledger Entry Type",ValueEntry."item ledger entry type"::"Negative Adjmt.");
          ValueEntry.SetRange("Job Ledger Entry No.",0);
        end;
        exit(ValueEntry.FindSet);
    end;

    local procedure ApplyToMatchingJobPlanningLine(var JobJnlLine: Record "Job Journal Line";var JobPlanningLine: Record "Job Planning Line"): Boolean
    var
        Job: Record Job;
        JobLedgEntry: Record "Job Ledger Entry";
        JobTransferLine: Codeunit "Job Transfer Line";
        JobLinkUsage: Codeunit "Job Link Usage";
    begin
        if JobLedgEntry."Entry Type" <> JobLedgEntry."entry type"::Usage then
          exit(false);

        Job.Get(JobJnlLine."Job No.");
        JobLedgEntry.Init;
        JobTransferLine.FromJnlLineToLedgEntry(JobJnlLine,JobLedgEntry);
        JobLedgEntry.Quantity := JobJnlLine.Quantity;
        JobLedgEntry."Quantity (Base)" := JobJnlLine."Quantity (Base)";

        if JobLinkUsage.FindMatchingJobPlanningLine(JobPlanningLine,JobLedgEntry) then begin
          JobJnlLine.Validate("Job Planning Line No.",JobPlanningLine."Line No.");
          JobJnlLine.Modify(true);
          exit(true);
        end;
        exit(false);
    end;
}

