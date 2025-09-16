#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5848 "Cost Shares Breakdown"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Cost Shares Breakdown.rdlc';
    Caption = 'Cost Shares Breakdown';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(Item;Item)
        {
            DataItemTableView = where(Type=const(Inventory));
            RequestFilterFields = "No.","Inventory Posting Group";
            column(ReportForNavId_8129; 8129)
            {
            }
            dataitem("Item Ledger Entry";"Item Ledger Entry")
            {
                DataItemLink = "Item No."=field("No.");
                DataItemTableView = sorting("Item No.");
                column(ReportForNavId_7209; 7209)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    CalcRemainingQty("Item Ledger Entry");
                    if RemainingQty = 0 then
                      CurrReport.Skip;
                end;

                trigger OnPreDataItem()
                begin
                    if EndDate <> 0D then begin
                      SetRange("Posting Date",0D,EndDate);
                      SetRange("Drop Shipment",false);
                    end;

                    if Find('-') then begin
                      SetRange("Posting Date");
                      SetRange("Drop Shipment");
                    end;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if "Costing Method" = "costing method"::Average then
                  CurrReport.Skip;
            end;
        }
        dataitem("Production Order";"Production Order")
        {
            DataItemTableView = where(Status=filter(Released..));
            column(ReportForNavId_4824; 4824)
            {
            }
            dataitem("Capacity Ledger Entry";"Capacity Ledger Entry")
            {
                DataItemLink = "Order No."=field("No.");
                DataItemTableView = sorting("Order Type","Order No.","Order Line No.") where("Order Type"=const(Production));
                column(ReportForNavId_2011; 2011)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    InsertCapLedgEntryCostShare("Capacity Ledger Entry");
                end;

                trigger OnPreDataItem()
                begin
                    if EndDate <> 0D then
                      SetRange("Posting Date",StartDate,EndDate)
                    else
                      SetFilter("Posting Date",'>=%1',StartDate);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if CostSharePrint <> Costshareprint::"WIP Inventory" then
                  CurrReport.Break;
            end;
        }
        dataitem(PrintHeader;"Integer")
        {
            DataItemTableView = sorting(Number) where(Number=filter(1..));
            PrintOnlyIfDetail = true;
            column(ReportForNavId_5017; 5017)
            {
            }
            column(TodayFormatted;Format(Today,0,4))
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(CostSharePrint;CostSharePrint)
            {
                OptionCaption = 'Sales,Inventory,WIP Inventory';
                OptionMembers = Sales,Inventory,"WIP Inventory";
            }
            column(TableCaptionItemFilter;Item.TableCaption + ': ' + ItemFilter)
            {
            }
            column(TableCaptionProdOrderFilter;"Production Order".TableCaption + ': ' + ProdOrderFilter)
            {
            }
            column(ProdOrderFilter;ProdOrderFilter)
            {
            }
            column(Number_PrintHeader;Number)
            {
            }
            column(FdCaptSubcontracted;CostShareBuf.FieldCaption(Subcontracted))
            {
            }
            column(CostShareBufNewMaterial;CostShareBuf."New Material")
            {
            }
            column(CostShareBufNewCapacity;CostShareBuf."New Capacity")
            {
            }
            column(CostShareBufNewCapOverhd;CostShareBuf."New Capacity Overhead")
            {
            }
            column(CostShareBufNewMatrlOverhd;CostShareBuf."New Material Overhead")
            {
            }
            column(Subcontracted;CostShareBuf."New Subcontracted")
            {
            }
            column(CostShareBufNewVar;CostShareBuf."New Variance")
            {
            }
            column(CostShareBufNewRevaluation;CostShareBuf."New Revaluation")
            {
            }
            column(CostShareBufNewRounding;CostShareBuf."New Rounding")
            {
            }
            column(Total;CostShareBuf."New Direct Cost" + CostShareBuf."New Indirect Cost" + CostShareBuf."New Revaluation" + CostShareBuf."New Rounding" + CostShareBuf."New Variance")
            {
            }
            column(CostShareBufNewPurchaseVar;CostShareBuf."New Purchase Variance")
            {
            }
            column(CostShareBufNewMaterialVar;CostShareBuf."New Material Variance")
            {
            }
            column(CostShareBufNewCpctyVar;CostShareBuf."New Capacity Variance")
            {
            }
            column(CostShareBufNewCapOverHdVar;CostShareBuf."New Capacity Overhead Variance")
            {
            }
            column(CostShareBufNewMfgOverheadVar;CostShareBuf."New Mfg. Overhead Variance")
            {
            }
            column(NewSubcontracted;CostShareBuf."New Subcontracted Variance")
            {
            }
            column(CurrReportPageNoCaption;CurrReportPageNoCaptionLbl)
            {
            }
            column(CostShareBufDocumentNoCaption;CostShareBufDocumentNoCaptionLbl)
            {
            }
            column(CostShareBufDescriptionCaption;CostShareBufDescriptionCaptionLbl)
            {
            }
            column(CostShareBufNewQuantityCaption;CostShareBufNewQuantityCaptionLbl)
            {
            }
            column(CostShareBufNewMatrlCaption;CostShareBufNewMatrlCaptionLbl)
            {
            }
            column(CapacityDirCostAppCaption;CapacityDirCostAppCaptionLbl)
            {
            }
            column(CapacityOverheadCaption;CapacityOverheadCaptionLbl)
            {
            }
            column(MaterialOverheadCaption;MaterialOverheadCaptionLbl)
            {
            }
            column(VarianceCaption;VarianceCaptionLbl)
            {
            }
            column(RevaluationCaption;RevaluationCaptionLbl)
            {
            }
            column(RoundingCaption;RoundingCaptionLbl)
            {
            }
            column(TotalCaption;TotalCaptionLbl)
            {
            }
            column(VarBreakdownCaption;VarBreakdownCaptionLbl)
            {
            }
            dataitem(PrintInvtCostShareBuf;"Integer")
            {
                DataItemTableView = sorting(Number) where(Number=filter(1..));
                column(ReportForNavId_5669; 5669)
                {
                }
                column(CostShareBufDescription;CostShareBuf.Description)
                {
                }
                column(CostShareBufItemNo;CostShareBuf."Item No.")
                {
                }
                column(Number_PrntInvtCostSharBufNo;Number)
                {
                }
                column(ShowDetails;ShowDetails)
                {
                }
                column(TotalPrintInvtCostShareBuf;CostShareBuf."New Direct Cost" + CostShareBuf."New Indirect Cost" + CostShareBuf."New Revaluation" + CostShareBuf."New Rounding" + CostShareBuf."New Variance")
                {
                }
                column(CostShareBufDocumentNo;CostShareBuf."Document No.")
                {
                }
                column(NewMatrl_PrintInvCstShrBuf;CostShareBuf."New Material")
                {
                }
                column(NewCap_PrintInvCstShrBuf;CostShareBuf."New Capacity")
                {
                }
                column(NewCapOvrHd_PrintInvCstShrBuf;CostShareBuf."New Capacity Overhead")
                {
                }
                column(NewMatOvrHd_PrintInvCstShrBuf;CostShareBuf."New Material Overhead")
                {
                }
                column(Subcontrt_PrintInvCstShrBuf;CostShareBuf."New Subcontracted")
                {
                }
                column(NewVar_PrintInvCstShrBuf;CostShareBuf."New Variance")
                {
                }
                column(NewReval_PrintInvCstShrBuf;CostShareBuf."New Revaluation")
                {
                }
                column(NewRounding_PrintInvCstShrBuf;CostShareBuf."New Rounding")
                {
                }
                column(CostShareBufNewQuantity;CostShareBuf."New Quantity")
                {
                    DecimalPlaces = 0:5;
                }
                column(NewPurchVar_PrintInvCstShrBuf;CostShareBuf."New Purchase Variance")
                {
                }
                column(NewMatrlVar_PrintInvCstShrBuf;CostShareBuf."New Material Variance")
                {
                }
                column(NewCapVar_PrintInvCstShrBuf;CostShareBuf."New Capacity Variance")
                {
                }
                column(NwCapOvHdVar_PrintInvCstShrBuf;CostShareBuf."New Capacity Overhead Variance")
                {
                }
                column(NwMfgOvrhdVar_PrintInvCstShrBuf;CostShareBuf."New Mfg. Overhead Variance")
                {
                }
                column(CostShareBufNewSubcontractedVar;CostShareBuf."New Subcontracted Variance")
                {
                }
                column(TotalCostVariance;CostShareBuf."New Purchase Variance" + CostShareBuf."New Material Variance" + CostShareBuf."New Capacity Variance" + CostShareBuf."New Capacity Overhead Variance" + CostShareBuf."New Mfg. Overhead Variance" + CostShareBuf."New Subcontracted Variance")
                {
                }
                column(TotalCost;CostShareBuf."New Direct Cost" + CostShareBuf."New Indirect Cost" + CostShareBuf."New Revaluation" + CostShareBuf."New Rounding" + CostShareBuf."New Variance")
                {
                }
                column(SrvTrPrintInvtCostShareBufFtr4;SrvTrPrintInvtCostShareBufFtr4)
                {
                }
                column(SrvTrPrintInvtCostShareBufFtr5;SrvTrPrintInvtCostShareBufFtr5)
                {
                }

                trigger OnAfterGetRecord()
                var
                    TempItem: Record Item temporary;
                    InvtAdjmtEntryOrder: Record "Inventory Adjmt. Entry (Order)";
                begin
                    if Number = 1 then begin
                      if not CostShareBuf.Find('-') then
                        CurrReport.Break;
                    end else
                      if CostShareBuf.Next = 0 then
                        CurrReport.Break;

                    if CostShareBuf."Posting Date" > EndDate then
                      CurrReport.Skip;

                    case CostSharePrint of
                      Costshareprint::Sales:
                        begin
                          CostShareBuf."New Revaluation" := CostShareBuf."New Revaluation" - CostShareBuf.Revaluation;
                          CostShareBuf."New Quantity" := CostShareBuf.Quantity;
                        end;
                      Costshareprint::Inventory:
                        begin
                          if CostShareBuf."New Quantity" = 0 then
                            CurrReport.Skip;
                        end;
                      Costshareprint::"WIP Inventory":
                        begin
                          if InvtAdjmtEntryOrder.Get(CostShareBuf."Order Type",CostShareBuf."Order No.",CostShareBuf."Order Line No.") then begin
                            Item.Get(InvtAdjmtEntryOrder."Item No.");
                            TempItem := Item;
                            TempItem.Insert;
                            TempItem.CopyFilters(Item);
                            if TempItem.IsEmpty then
                              CurrReport.Skip;
                          end;

                          if CostShareBuf."Entry Type" = CostShareBuf."entry type"::" " then begin
                            CostShareBuf."New Direct Cost" := -CostShareBuf."New Direct Cost";
                            CostShareBuf."New Indirect Cost" := -CostShareBuf."New Indirect Cost";
                            CostShareBuf."New Revaluation" := -CostShareBuf."New Revaluation";
                            CostShareBuf."New Rounding" := -CostShareBuf."New Rounding";
                            CostShareBuf."New Variance" := -CostShareBuf."New Variance";
                            CostShareBuf."New Purchase Variance" := -CostShareBuf."New Purchase Variance";
                            CostShareBuf."New Material Variance" := -CostShareBuf."New Material Variance";
                            CostShareBuf."New Capacity Variance" := -CostShareBuf."New Capacity Variance";
                            CostShareBuf."New Capacity Overhead Variance" := -CostShareBuf."New Capacity Overhead Variance";
                            CostShareBuf."New Mfg. Overhead Variance" := -CostShareBuf."New Mfg. Overhead Variance";
                            CostShareBuf."New Subcontracted Variance" := -CostShareBuf."New Subcontracted Variance";
                            CostShareBuf."New Material" := -CostShareBuf."New Material";
                            CostShareBuf."New Capacity" := -CostShareBuf."New Capacity";
                            CostShareBuf."New Capacity Overhead" := -CostShareBuf."New Capacity Overhead";
                            CostShareBuf."New Material Overhead" := -CostShareBuf."New Material Overhead";
                            CostShareBuf."New Subcontracted" := -CostShareBuf."New Subcontracted";
                          end;
                          CostShareBuf."New Variance" := CostShareBuf."New Variance" - CostShareBuf.Variance;
                          CostShareBuf."New Purchase Variance" := CostShareBuf."New Purchase Variance" - CostShareBuf."Purchase Variance";
                          CostShareBuf."New Material Variance" := CostShareBuf."New Material Variance" - CostShareBuf."Material Variance";
                          CostShareBuf."New Capacity Variance" := CostShareBuf."New Capacity Variance" - CostShareBuf."Capacity Variance";
                          CostShareBuf."New Capacity Overhead Variance" :=
                            CostShareBuf."New Capacity Overhead Variance" - CostShareBuf."Capacity Overhead Variance";
                          CostShareBuf."New Mfg. Overhead Variance" := CostShareBuf."New Mfg. Overhead Variance" -
                            CostShareBuf."Mfg. Overhead Variance";
                          CostShareBuf."New Subcontracted Variance" := CostShareBuf."New Subcontracted Variance" -
                            CostShareBuf."Subcontracted Variance";
                        end;
                    end;

                    if Number = 1 then
                      if CostSharePrint in [Costshareprint::Sales,Costshareprint::Inventory] then begin
                        if ItemPrint.Get(CostShareBuf."Item No.") then begin
                          CostShareBuf."Item No." := ItemPrint."No.";
                          CostShareBuf.Description := ItemPrint.Description;
                        end;
                      end else
                        if (CostShareBuf."Order Type" = CostShareBuf."order type"::Production) and
                           (ProdOrderPrint.Get(ProdOrderPrint.Status::Finished,CostShareBuf."Order No.") or
                            ProdOrderPrint.Get(ProdOrderPrint.Status::Released,CostShareBuf."Order No."))
                        then begin
                          CostShareBuf."Item No." := ProdOrderPrint."No.";
                          CostShareBuf.Description := ProdOrderPrint.Description;
                          CostShareBuf."New Quantity" := ProdOrderPrint.Quantity;
                        end;
                end;

                trigger OnPreDataItem()
                begin
                    if CostSharePrint in [Costshareprint::Sales,Costshareprint::Inventory] then begin
                      CostShareBuf.SetCurrentkey("Item No.");
                      CostShareBuf.SetRange("Item No.",ItemPrint."No.");
                      if CostSharePrint = Costshareprint::Sales then
                        CostShareBuf.SetRange("Entry Type",CostShareBuf."entry type"::Sale);
                    end else begin
                      CostShareBuf.SetCurrentkey("Order Type","Order No.");
                      CostShareBuf.SetRange("Order Type",CostShareBuf."order type"::Production);
                      CostShareBuf.SetRange("Order No.",ProdOrderPrint."No.");
                    end;

                    CurrReport.CreateTotals(
                      CostShareBuf."New Quantity",CostShareBuf."New Direct Cost",
                      CostShareBuf."New Indirect Cost",CostShareBuf."New Revaluation",
                      CostShareBuf."New Rounding",CostShareBuf."New Variance",
                      CostShareBuf."New Purchase Variance",CostShareBuf."New Material Variance",
                      CostShareBuf."New Capacity Variance",CostShareBuf."New Capacity Overhead Variance");
                    CurrReport.CreateTotals(
                      CostShareBuf."New Mfg. Overhead Variance",CostShareBuf."New Subcontracted Variance",
                      CostShareBuf."New Material",
                      CostShareBuf."New Capacity",CostShareBuf."New Capacity Overhead",
                      CostShareBuf."New Material Overhead",CostShareBuf."New Subcontracted");
                end;
            }

            trigger OnAfterGetRecord()
            begin
                case CostSharePrint of
                  Costshareprint::Sales,Costshareprint::Inventory:
                    if Number = 1 then begin
                      if not ItemPrint.Find('-') then
                        CurrReport.Break;
                    end else
                      if ItemPrint.Next = 0 then
                        CurrReport.Break;
                  Costshareprint::"WIP Inventory":
                    if Number = 1 then begin
                      if not ProdOrderPrint.Find('-') then
                        CurrReport.Break;
                    end else
                      if ProdOrderPrint.Next = 0 then
                        CurrReport.Break;
                end;

                CostShareBuf.Reset;
                if not CostShareBuf.Find('-') then
                  CurrReport.Skip;
            end;

            trigger OnPreDataItem()
            begin
                if CostSharePrint in [Costshareprint::Sales,Costshareprint::Inventory] then begin
                  ItemPrint.CopyFilters(Item);
                  ItemPrint.SetCurrentkey("Inventory Posting Group");
                end else
                  ProdOrderPrint.CopyFilters("Production Order");

                CurrReport.CreateTotals(
                  CostShareBuf."New Quantity",CostShareBuf."New Direct Cost",
                  CostShareBuf."New Indirect Cost",CostShareBuf."New Revaluation",
                  CostShareBuf."New Rounding",CostShareBuf."New Variance",
                  CostShareBuf."New Purchase Variance",CostShareBuf."New Material Variance",
                  CostShareBuf."New Capacity Variance",CostShareBuf."New Capacity Overhead Variance");
                CurrReport.CreateTotals(
                  CostShareBuf."New Mfg. Overhead Variance",CostShareBuf."New Subcontracted Variance",
                  CostShareBuf."New Material",
                  CostShareBuf."New Capacity",CostShareBuf."New Capacity Overhead",
                  CostShareBuf."New Material Overhead",CostShareBuf."New Subcontracted");
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(StartDate;StartDate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Starting Date';
                    }
                    field(EndDate;EndDate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Ending Date';
                    }
                    field(CostSharePrint;CostSharePrint)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Print Cost Share ';
                        OptionCaption = 'Sales,Inventory,WIP Inventory';
                    }
                    field(ShowDetails;ShowDetails)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Show Details';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if (StartDate = 0D) and (EndDate = 0D) then
              EndDate := WorkDate;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        if (StartDate = 0D) and (EndDate = 0D) then
          EndDate := WorkDate;

        case true of
          (StartDate <> 0D) and (EndDate <> 0D):
            Item.SetRange("Date Filter",StartDate,EndDate);
          (StartDate <> 0D):
            Item.SetFilter("Date Filter",'%1..',StartDate);
          else
            Item.SetRange("Date Filter",0D,EndDate);
        end;

        ItemFilter := Item.GetFilters;
        ProdOrderFilter := "Production Order".GetFilters;

        CostShareBuf.Reset;
        CostShareBuf.DeleteAll;
    end;

    var
        ItemPrint: Record Item;
        ProdOrderPrint: Record "Production Order";
        CostShareBuf: Record "Cost Share Buffer" temporary;
        ItemFilter: Text;
        ProdOrderFilter: Text;
        RemainingQty: Decimal;
        CostSharePrint: Option Sales,Inventory,"WIP Inventory";
        StartDate: Date;
        EndDate: Date;
        ShowDetails: Boolean;
        CurrReportPageNoCaptionLbl: label 'Page';
        CostShareBufDocumentNoCaptionLbl: label 'No.';
        CostShareBufDescriptionCaptionLbl: label 'Description';
        CostShareBufNewQuantityCaptionLbl: label 'Quantity';
        CostShareBufNewMatrlCaptionLbl: label 'Material Direct Cost Applied';
        CapacityDirCostAppCaptionLbl: label 'Capacity Direct Cost Applied';
        CapacityOverheadCaptionLbl: label 'Capacity Overhead';
        MaterialOverheadCaptionLbl: label 'Material Overhead';
        VarianceCaptionLbl: label 'Variance';
        RevaluationCaptionLbl: label 'Revaluation';
        RoundingCaptionLbl: label 'Rounding';
        TotalCaptionLbl: label 'Total';
        VarBreakdownCaptionLbl: label 'Variance Breakdown';

    local procedure CalcRemainingQty(FromItemLedgEntry: Record "Item Ledger Entry")
    var
        ItemApplnEntry: Record "Item Application Entry";
    begin
        RemainingQty := FromItemLedgEntry.Quantity;

        with ItemApplnEntry do
          if FromItemLedgEntry.Positive then begin
            if CostShareBuf.Get(FromItemLedgEntry."Entry No.") then
              exit;
            if not AppliedFromEntryExists(FromItemLedgEntry."Entry No.") then
              if ForwardToAppliedOutbndEntry(FromItemLedgEntry."Entry No.") then
                exit;
          end;

        if (FromItemLedgEntry."Posting Date" > EndDate) and (EndDate <> 0D) then
          exit;

        if not CostShareBuf.Get(FromItemLedgEntry."Entry No.") then
          InsertItemLedgEntryCostShare(FromItemLedgEntry);
    end;

    local procedure ForwardToAppliedOutbndEntry(EntryNo: Integer): Boolean
    var
        ItemApplnEntry: Record "Item Application Entry";
    begin
        with ItemApplnEntry do
          if AppliedOutbndEntryExists(EntryNo,true,false) then begin
            ForwardItemLedgEntryCostShare(ItemApplnEntry,EntryNo,false);
            exit(true);
          end;
        exit(false);
    end;

    local procedure ForwardToAppliedInbndEntry(EntryNo: Integer)
    var
        ItemApplnEntry: Record "Item Application Entry";
    begin
        with ItemApplnEntry do
          if AppliedInbndEntryExists(EntryNo,true) then
            ForwardItemLedgEntryCostShare(ItemApplnEntry,EntryNo,true);
    end;

    local procedure ForwardToInbndTranEntry(EntryNo: Integer): Boolean
    var
        ItemApplnEntry: Record "Item Application Entry";
    begin
        with ItemApplnEntry do
          if AppliedInbndTransEntryExists(EntryNo,true) then begin
            ForwardItemLedgEntryCostShare(ItemApplnEntry,EntryNo,true);
            exit(true);
          end;
        exit(false);
    end;

    local procedure ForwardItemLedgEntryCostShare(var ItemApplnEntry: Record "Item Application Entry";EntryNo: Integer;IsInBound: Boolean)
    var
        FromItemLedgEntry: Record "Item Ledger Entry";
        ToItemLedgEntry: Record "Item Ledger Entry";
        FromCostShareBuf: Record "Cost Share Buffer";
        ToCostShareBuf: Record "Cost Share Buffer";
        ToEntryNo: Integer;
        CostShare: Decimal;
        AppliedQty: Decimal;
    begin
        repeat
          if not CostShareBuf.Get(EntryNo) then begin
            FromItemLedgEntry.Get(EntryNo);
            if FromItemLedgEntry."Posting Date" > EndDate then
              exit;
            InsertItemLedgEntryCostShare(FromItemLedgEntry);
          end;
          FromCostShareBuf := CostShareBuf;
          if IsInBound then
            ToEntryNo := ItemApplnEntry."Inbound Item Entry No."
          else
            ToEntryNo := ItemApplnEntry."Outbound Item Entry No.";

          ToItemLedgEntry.Get(ToEntryNo);
          if not CostShareBuf.Get(ToEntryNo) then
            InsertItemLedgEntryCostShare(ToItemLedgEntry);

          ToCostShareBuf := CostShareBuf;
          if (ToCostShareBuf."Posting Date" <= EndDate) or (EndDate = 0D) then begin
            if (EndDate = 0D) or (ToItemLedgEntry."Posting Date" <= EndDate) and
               (FromCostShareBuf.Quantity * ItemApplnEntry.Quantity < 0)
            then
              AppliedQty := AppliedQty + ItemApplnEntry.Quantity;

            with ToCostShareBuf do begin
              if Quantity < 0 then
                "New Quantity" := "New Quantity" - ItemApplnEntry.Quantity;

              CostShare := ItemApplnEntry.Quantity / FromCostShareBuf.Quantity;
              UpdateCosts(FromCostShareBuf,ToCostShareBuf,CostShare,true);

              CostShareBuf := ToCostShareBuf;
              CostShareBuf.Modify;

              ForwardToAppliedOutbndEntry("Item Ledger Entry No.");
              if "New Quantity" - ToItemLedgEntry."Remaining Quantity" = 0 then
                ForwardToAppliedInbndEntry("Item Ledger Entry No.");

              if (Quantity < 0) and
                 (CostSharePrint in [Costshareprint::Inventory,Costshareprint::"WIP Inventory"])
              then begin
                CostShareBuf.Find;
                ToCostShareBuf := CostShareBuf;
                CostShare := -CostShare;
                UpdateCosts(FromCostShareBuf,ToCostShareBuf,CostShare,false);
                CostShareBuf := ToCostShareBuf;
                CostShareBuf.Modify;
              end;
            end;
          end;
        until ItemApplnEntry.Next = 0;

        if ToItemLedgEntry."Entry Type" = ToItemLedgEntry."entry type"::Transfer then
          if not ToItemLedgEntry.Positive then begin
            if EndDate in [0D..ToItemLedgEntry."Posting Date"] then
              ForwardToInbndTranEntry(EntryNo)
          end else
            exit;

        with FromCostShareBuf do begin
          if (CostSharePrint = Costshareprint::Inventory) and (Quantity > 0) then begin
            "New Quantity" := "New Quantity" + AppliedQty;
            CostShare := AppliedQty / Quantity;
            UpdateCosts(FromCostShareBuf,FromCostShareBuf,CostShare,false);
          end;
          CostShareBuf := FromCostShareBuf;
          CostShareBuf.Modify;
        end;
    end;

    local procedure UpdateCosts(FromCostShareBuf: Record "Cost Share Buffer";var ToCostShareBuf: Record "Cost Share Buffer";CostShare: Decimal;DirCostIsDiff: Boolean)
    begin
        with ToCostShareBuf do begin
          "New Indirect Cost" := "New Indirect Cost" + CostShare * FromCostShareBuf."New Indirect Cost";
          if CostSharePrint = Costshareprint::Sales then
            "New Revaluation" := "New Revaluation" + CostShare * FromCostShareBuf."New Revaluation";
          "New Rounding" := "New Rounding" + CostShare * FromCostShareBuf."New Rounding";
          "New Variance" := "New Variance" + CostShare * FromCostShareBuf."New Variance";
          "New Purchase Variance" := "New Purchase Variance" + CostShare * FromCostShareBuf."New Purchase Variance";
          "New Material Variance" := "New Material Variance" + CostShare * FromCostShareBuf."New Material Variance";
          "New Capacity Variance" := "New Capacity Variance" + CostShare * FromCostShareBuf."New Capacity Variance";
          "New Capacity Overhead Variance" :=
            "New Capacity Overhead Variance" + CostShare * FromCostShareBuf."New Capacity Overhead Variance";
          "New Mfg. Overhead Variance" :=
            "New Mfg. Overhead Variance" + CostShare * FromCostShareBuf."New Mfg. Overhead Variance";
          "New Subcontracted Variance" :=
            "New Subcontracted Variance" + CostShare * FromCostShareBuf."New Subcontracted Variance";
          if DirCostIsDiff then
            "New Direct Cost" := "New Direct Cost" - CostShare *
              (FromCostShareBuf."New Indirect Cost" +
               FromCostShareBuf."New Revaluation" +
               FromCostShareBuf."New Variance" +
               FromCostShareBuf."New Rounding")
          else
            "New Direct Cost" := "New Direct Cost" + CostShare * FromCostShareBuf."New Direct Cost";
          "New Capacity" := "New Capacity" + CostShare * FromCostShareBuf."New Capacity";
          "New Capacity Overhead" := "New Capacity Overhead" + CostShare * FromCostShareBuf."New Capacity Overhead";
          "New Material Overhead" := "New Material Overhead" + CostShare * FromCostShareBuf."New Material Overhead";
          "New Subcontracted" := "New Subcontracted" + CostShare * FromCostShareBuf."New Subcontracted";
          "New Material" := "New Direct Cost" - ("New Capacity" + "New Capacity Overhead" + "New Subcontracted");
        end;
    end;

    local procedure InsertItemLedgEntryCostShare(ItemLedgEntry: Record "Item Ledger Entry")
    var
        ValueEntry: Record "Value Entry";
        InvtAdjmtEntryOrder: Record "Inventory Adjmt. Entry (Order)";
        CalcInvtAdjmtOrder: Codeunit "Calc. Inventory Adjmt. - Order";
        OutputQty: Decimal;
        CostInPeriod: Decimal;
        TotalCost: Decimal;
        DirectCostInPeriod: Decimal;
        TotalDirectCost: Decimal;
        ShareOfCost: Decimal;
    begin
        with CostShareBuf do begin
          Init;
          "Item Ledger Entry No." := ItemLedgEntry."Entry No.";
          "Item No." := ItemLedgEntry."Item No.";
          Quantity := ItemLedgEntry.Quantity;
          "Entry Type" := ItemLedgEntry."Entry Type";
          "Location Code" := ItemLedgEntry."Location Code";
          "Variant Code" := ItemLedgEntry."Variant Code";
          "Order Type" := ItemLedgEntry."Order Type";
          "Order No." := ItemLedgEntry."Order No.";
          "Order Line No." := ItemLedgEntry."Order Line No.";
          "Document No." := ItemLedgEntry."Document No.";
          Description := ItemLedgEntry.Description;
          "Posting Date" := ItemLedgEntry."Posting Date";

          TotalCost := 0;
          CostInPeriod := 0;
          DirectCostInPeriod := 0;
          TotalDirectCost := 0;
          ValueEntry.SetCurrentkey("Item Ledger Entry No.","Entry Type");
          ValueEntry.SetRange("Item Ledger Entry No.",ItemLedgEntry."Entry No.");
          if EndDate <> 0D then
            ValueEntry.SetRange("Posting Date",0D,EndDate);
          if ValueEntry.Find('-') then
            repeat
              GetValueEntryCostAmts(CostShareBuf,ValueEntry);

              if IsInCostingPeriod(ValueEntry."Posting Date") then begin
                CostInPeriod := CostInPeriod + ValueEntry."Cost Amount (Actual)" + ValueEntry."Cost Amount (Expected)";
                if ValueEntry."Entry Type" = ValueEntry."entry type"::"Direct Cost" then
                  DirectCostInPeriod := DirectCostInPeriod + ValueEntry."Cost Amount (Actual)" + ValueEntry."Cost Amount (Expected)";
              end;
              TotalCost := TotalCost + ValueEntry."Cost Amount (Actual)" + ValueEntry."Cost Amount (Expected)";
              if ValueEntry."Entry Type" = ValueEntry."entry type"::"Direct Cost" then
                TotalDirectCost := TotalDirectCost + ValueEntry."Cost Amount (Actual)" + ValueEntry."Cost Amount (Expected)";
            until ValueEntry.Next = 0;

          if ItemLedgEntry."Entry Type" in [ItemLedgEntry."entry type"::Output,
                                            ItemLedgEntry."entry type"::"Assembly Output"]
          then begin
            InvtAdjmtEntryOrder.Get(ItemLedgEntry."Order Type",ItemLedgEntry."Order No.",ItemLedgEntry."Order Line No.");
            OutputQty := CalcInvtAdjmtOrder.CalcOutputQty(InvtAdjmtEntryOrder,false);
            CalcInvtAdjmtOrder.CalcActualUsageCosts(InvtAdjmtEntryOrder,OutputQty,InvtAdjmtEntryOrder);

            Material += InvtAdjmtEntryOrder."Single-Level Material Cost";
            Capacity += InvtAdjmtEntryOrder."Single-Level Capacity Cost";
            Subcontracted += InvtAdjmtEntryOrder."Single-Level Subcontrd. Cost";
            "Capacity Overhead" += InvtAdjmtEntryOrder."Single-Level Cap. Ovhd Cost";
            "Material Overhead" += InvtAdjmtEntryOrder."Single-Level Mfg. Ovhd Cost";
            if OutputQty = 0 then
              ShareOfCost := 1
            else
              ShareOfCost := ItemLedgEntry.Quantity / OutputQty;

            Capacity := Capacity * ShareOfCost;
            "Capacity Overhead" := "Capacity Overhead" * ShareOfCost;
            "Material Overhead" := "Material Overhead" * ShareOfCost;
            Subcontracted := Subcontracted * ShareOfCost;
          end else
            "Material Overhead" := "Indirect Cost";

          Material := "Direct Cost" - (Capacity + "Capacity Overhead" + Subcontracted);

          if TotalCost <> 0 then
            "Share of Cost in Period" := CostInPeriod / TotalCost;

          "New Quantity" := Quantity;
          "New Direct Cost" := "Direct Cost";
          "New Indirect Cost" := "Indirect Cost";
          "New Revaluation" := Revaluation;
          "New Variance" := Variance;
          "New Rounding" := Rounding;

          "New Purchase Variance" := "Purchase Variance";
          "New Material Variance" := "Material Variance";
          "New Capacity Variance" := "Capacity Variance";
          "New Capacity Overhead Variance" := "Capacity Overhead Variance";
          "New Mfg. Overhead Variance" := "Mfg. Overhead Variance";
          "New Subcontracted Variance" := "Subcontracted Variance";

          "New Material" := Material;
          "New Capacity" := Capacity;
          "New Capacity Overhead" := "Capacity Overhead";
          "New Material Overhead" := "Material Overhead";
          "New Subcontracted" := Subcontracted;
          Insert;
        end;
    end;

    local procedure InsertCapLedgEntryCostShare(CapLedgEntry: Record "Capacity Ledger Entry")
    var
        ValueEntry: Record "Value Entry";
        CostInPeriod: Decimal;
        TotalCost: Decimal;
    begin
        with CostShareBuf do begin
          Init;
          "Capacity Ledger Entry No." := CapLedgEntry."Entry No.";
          "Item No." := CapLedgEntry."Item No.";
          Quantity := CapLedgEntry.Quantity;
          "Entry Type" := "entry type"::" ";
          "Order Type" := CapLedgEntry."Order Type";
          "Order No." := CapLedgEntry."Order No.";
          "Order Line No." := CapLedgEntry."Order Line No.";
          "Document No." := CapLedgEntry."Document No.";
          Description := CapLedgEntry.Description;

          TotalCost := 0;
          CostInPeriod := 0;
          ValueEntry.SetCurrentkey("Capacity Ledger Entry No.","Entry Type");
          ValueEntry.SetRange("Capacity Ledger Entry No.",CapLedgEntry."Entry No.");
          if EndDate <> 0D then
            ValueEntry.SetRange("Posting Date",0D,EndDate);
          if ValueEntry.Find('-') then
            repeat
              GetValueEntryCostAmts(CostShareBuf,ValueEntry);

              if IsInCostingPeriod(ValueEntry."Posting Date") then
                CostInPeriod := CostInPeriod + ValueEntry."Cost Amount (Actual)";
              TotalCost := TotalCost + ValueEntry."Cost Amount (Actual)";
            until ValueEntry.Next = 0;

          if TotalCost <> 0 then
            "Share of Cost in Period" := CostInPeriod / TotalCost;

          if CapLedgEntry.Subcontracting then
            Subcontracted := "Direct Cost"
          else
            Capacity := "Direct Cost";
          "Capacity Overhead" := "Indirect Cost";

          "New Quantity" := Quantity;
          "New Direct Cost" := "Direct Cost";
          "New Indirect Cost" := "Indirect Cost";
          "New Revaluation" := Revaluation;
          "New Variance" := Variance;
          "New Rounding" := Rounding;

          "New Purchase Variance" := "Purchase Variance";
          "New Material Variance" := "Material Variance";
          "New Capacity Variance" := "Capacity Variance";
          "New Capacity Overhead Variance" := "Capacity Overhead Variance";
          "New Mfg. Overhead Variance" := "Mfg. Overhead Variance";
          "New Subcontracted Variance" := "Subcontracted Variance";

          "New Material" := Material;
          "New Capacity" := Capacity;
          "New Capacity Overhead" := "Capacity Overhead";
          "New Material Overhead" := "Material Overhead";
          "New Subcontracted" := Subcontracted;
          Insert;
        end;
    end;

    local procedure GetValueEntryCostAmts(var CostShareBuf: Record "Cost Share Buffer";ValueEntry: Record "Value Entry")
    begin
        with CostShareBuf do
          case ValueEntry."Entry Type" of
            ValueEntry."entry type"::"Direct Cost":
              "Direct Cost" := "Direct Cost" + ValueEntry."Cost Amount (Actual)" + ValueEntry."Cost Amount (Expected)";
            ValueEntry."entry type"::"Indirect Cost":
              "Indirect Cost" := "Indirect Cost" + ValueEntry."Cost Amount (Actual)" + ValueEntry."Cost Amount (Expected)";
            ValueEntry."entry type"::Variance:
              begin
                Variance := Variance + ValueEntry."Cost Amount (Actual)";
                case ValueEntry."Variance Type" of
                  ValueEntry."variance type"::Purchase:
                    "Purchase Variance" := "Purchase Variance" + ValueEntry."Cost Amount (Actual)" + ValueEntry."Cost Amount (Expected)";
                  ValueEntry."variance type"::Material:
                    "Material Variance" := "Material Variance" + ValueEntry."Cost Amount (Actual)" + ValueEntry."Cost Amount (Expected)";
                  ValueEntry."variance type"::Capacity:
                    "Capacity Variance" := "Capacity Variance" + ValueEntry."Cost Amount (Actual)" + ValueEntry."Cost Amount (Expected)";
                  ValueEntry."variance type"::"Capacity Overhead":
                    "Capacity Overhead Variance" :=
                      "Capacity Overhead Variance" + ValueEntry."Cost Amount (Actual)" + ValueEntry."Cost Amount (Expected)";
                  ValueEntry."variance type"::"Manufacturing Overhead":
                    "Mfg. Overhead Variance" :=
                      "Mfg. Overhead Variance" + ValueEntry."Cost Amount (Actual)" + ValueEntry."Cost Amount (Expected)";
                  ValueEntry."variance type"::Subcontracted:
                    "Subcontracted Variance" :=
                      "Subcontracted Variance" + ValueEntry."Cost Amount (Actual)" + ValueEntry."Cost Amount (Expected)";
                end;
              end;
            ValueEntry."entry type"::Revaluation:
              Revaluation := Revaluation + ValueEntry."Cost Amount (Actual)" + ValueEntry."Cost Amount (Expected)";
            ValueEntry."entry type"::Rounding:
              Rounding := Rounding + ValueEntry."Cost Amount (Actual)" + ValueEntry."Cost Amount (Expected)";
          end;
    end;

    local procedure IsInCostingPeriod(PostingDate: Date): Boolean
    begin
        if EndDate <> 0D then
          exit(PostingDate in [StartDate..EndDate]);
        exit(PostingDate >= StartDate);
    end;

    local procedure SrvTrPrintInvtCostShareBufFtr4(): Boolean
    begin
        if CostSharePrint in [Costshareprint::Sales,Costshareprint::Inventory] then begin
          CostShareBuf."Item No." := ItemPrint."No.";
          CostShareBuf.Description := ItemPrint.Description;
        end else begin
          CostShareBuf."Item No." := ProdOrderPrint."No.";
          CostShareBuf.Description := ProdOrderPrint.Description;
          CostShareBuf."New Quantity" := ProdOrderPrint.Quantity;
        end;
        exit(ShowDetails);
    end;

    local procedure SrvTrPrintInvtCostShareBufFtr5(): Boolean
    begin
        if CostSharePrint = Costshareprint::"WIP Inventory" then begin
          CostShareBuf."Item No." := ProdOrderPrint."No.";
          CostShareBuf."New Quantity" := ProdOrderPrint.Quantity;
        end;
        exit(not ShowDetails);
    end;


    procedure InitializeRequest(NewStartDate: Date;NewEndDate: Date;NewPrintCostShare: Option;NewShowDetails: Boolean)
    begin
        StartDate := NewStartDate;
        EndDate := NewEndDate;
        CostSharePrint := NewPrintCostShare;
        ShowDetails := NewShowDetails;
    end;
}

