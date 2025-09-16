#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5802 "Inventory Valuation - WIP"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Inventory Valuation - WIP.rdlc';
    Caption = 'Inventory Valuation - WIP';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Production Order";"Production Order")
        {
            DataItemTableView = where(Status=filter(Released..));
            PrintOnlyIfDetail = true;
            RequestFilterFields = Status,"No.";
            column(ReportForNavId_4824; 4824)
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(TodayFormatted;Format(Today,0,4))
            {
            }
            column(ProdOrderFilter;ProdOrderFilter)
            {
            }
            column(AsOfStartDateText;StrSubstNo(Text005,StartDateText))
            {
            }
            column(AsofEndDate;StrSubstNo(Text005,Format(EndDate)))
            {
            }
            column(No_ProductionOrder;"No.")
            {
            }
            column(SourceNo_ProductionOrder;"Source No.")
            {
            }
            column(SrcType_ProductionOrder;"Source Type")
            {
            }
            column(Desc_ProductionOrder;Description)
            {
            }
            column(Status_ProductionOrder;Status)
            {
            }
            column(InventoryValuationWIPCptn;InventoryValuationWIPCptnLbl)
            {
            }
            column(CurrReportPageNoCaption;CurrReportPageNoCaptionLbl)
            {
            }
            column(ValueOfCapCaption;ValueOfCapCaptionLbl)
            {
            }
            column(ValueOfOutputCaption;ValueOfOutputCaptionLbl)
            {
            }
            column(ValueEntryCostPostedtoGLCaption;ValueEntryCostPostedtoGLCaptionLbl)
            {
            }
            column(ValueOfMatConsumpCaption;ValueOfMatConsumpCaptionLbl)
            {
            }
            column(ProductionOrderNoCaption;ProductionOrderNoCaptionLbl)
            {
            }
            column(ProdOrderStatusCaption;ProdOrderStatusCaptionLbl)
            {
            }
            column(ProdOrderDescriptionCaption;ProdOrderDescriptionCaptionLbl)
            {
            }
            column(ProdOrderSourceTypeCaptn;ProdOrderSourceTypeCaptnLbl)
            {
            }
            column(ProdOrderSourceNoCaption;ProdOrderSourceNoCaptionLbl)
            {
            }
            column(TotalCaption;TotalCaptionLbl)
            {
            }
            dataitem("Value Entry";"Value Entry")
            {
                DataItemTableView = sorting("Order Type","Order No.");
                column(ReportForNavId_8894; 8894)
                {
                }
                column(ValueEntryCostPostedtoGL;TotalValueOfCostPstdToGL)
                {
                    AutoFormatType = 1;
                }
                column(ValueOfOutput;TotalValueOfOutput)
                {
                    AutoFormatType = 1;
                }
                column(ValueOfCap;TotalValueOfCap)
                {
                    AutoFormatType = 1;
                }
                column(ValueOfMatConsump;TotalValueOfMatConsump)
                {
                    AutoFormatType = 1;
                }
                column(ValueOfWIP;TotalValueOfWIP)
                {
                    AutoFormatType = 1;
                }
                column(LastOutput;TotalLastOutput)
                {
                }
                column(AtLastDate;TotalAtLastDate)
                {
                }
                column(LastWIP;TotalLastWIP)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    CountRecord := CountRecord + 1;
                    LastOutput := 0;
                    AtLastDate := 0;
                    LastWIP := 0;

                    if (CountRecord = LengthRecord) and IsNotWIP then begin
                      ValueEntryOnPostDataItem("Value Entry");

                      AtLastDate := NcValueOfWIP + NcValueOfMatConsump + NcValueOfCap + NcValueOfOutput;
                      LastOutput := NcValueOfOutput;
                      LastWIP := NcValueOfWIP;
                      ValueOfCostPstdToGL := NcValueOfCostPstdToGL;

                      NcValueOfWIP := 0;
                      NcValueOfOutput := 0;
                      NcValueOfMatConsump := 0;
                      NcValueOfCap := 0;
                      NcValueOfInvOutput1 := 0;
                      NcValueOfExpOutPut1 := 0;
                      NcValueOfExpOutPut2 := 0;
                      NcValueOfRevalCostAct := 0;
                      NcValueOfRevalCostPstd := 0;
                      NcValueOfCostPstdToGL := 0;
                    end;

                    if not IsNotWIP then begin
                      ValueOfWIP := 0;
                      ValueOfMatConsump := 0;
                      ValueOfCap := 0;
                      ValueOfOutput := 0;
                      ValueOfInvOutput1 := 0;
                      ValueOfExpOutput1 := 0;
                      ValueOfExpOutput2 := 0;
                      if EntryFound then
                        ValueOfCostPstdToGL := "Cost Posted to G/L";

                      if "Posting Date" < StartDate then begin
                        if "Item Ledger Entry Type" = "item ledger entry type"::" " then
                          ValueOfWIP := "Cost Amount (Actual)"
                        else
                          ValueOfWIP := -"Cost Amount (Actual)";
                        if "Item Ledger Entry Type" = "item ledger entry type"::Output then begin
                          ValueOfExpOutput1 := -"Cost Amount (Expected)";
                          ValueOfInvOutput1 := -"Cost Amount (Actual)";
                          ValueOfWIP := ValueOfExpOutput1 + ValueOfInvOutput1;
                        end;

                        if ("Entry Type" = "entry type"::Revaluation) and ("Cost Amount (Actual)" <> 0) then
                          ValueOfWIP := 0;
                      end else
                        case "Item Ledger Entry Type" of
                          "item ledger entry type"::Consumption:
                            if IsProductionCost("Value Entry") then
                              ValueOfMatConsump := -"Cost Amount (Actual)";
                          "item ledger entry type"::" ":
                            ValueOfCap := "Cost Amount (Actual)";
                          "item ledger entry type"::Output:
                            begin
                              ValueOfExpOutput2 := -"Cost Amount (Expected)";
                              ValueOfOutput := -("Cost Amount (Actual)" + "Cost Amount (Expected)");
                              if "Entry Type" = "entry type"::Revaluation then
                                ValueOfRevalCostAct += -"Cost Amount (Actual)";
                            end;
                        end;

                      if not ("Item Ledger Entry Type" = "item ledger entry type"::" ") then begin
                        "Cost Amount (Actual)" := -"Cost Amount (Actual)";
                        if IsProductionCost("Value Entry") then begin
                          ValueOfCostPstdToGL := -("Cost Posted to G/L" + "Expected Cost Posted to G/L");
                          if "Entry Type" = "entry type"::Revaluation then
                            ValueOfRevalCostPstd += ValueOfCostPstdToGL;
                        end else
                          ValueOfCostPstdToGL := 0;
                      end else
                        ValueOfCostPstdToGL := "Cost Posted to G/L" + "Expected Cost Posted to G/L";

                      NcValueOfWIP := NcValueOfWIP + ValueOfWIP;
                      NcValueOfOutput := NcValueOfOutput + ValueOfOutput;
                      NcValueOfMatConsump := NcValueOfMatConsump + ValueOfMatConsump;
                      NcValueOfCap := NcValueOfCap + ValueOfCap;
                      NcValueOfInvOutput1 := NcValueOfInvOutput1 + ValueOfInvOutput1;
                      NcValueOfExpOutPut1 := NcValueOfExpOutPut1 + ValueOfExpOutput1;
                      NcValueOfExpOutPut2 := NcValueOfExpOutPut2 + ValueOfExpOutput2;
                      NcValueOfRevalCostAct := ValueOfRevalCostAct;
                      NcValueOfRevalCostPstd := ValueOfRevalCostPstd;
                      NcValueOfCostPstdToGL := NcValueOfCostPstdToGL + ValueOfCostPstdToGL;
                      ValueOfCostPstdToGL := 0;

                      if CountRecord = LengthRecord then begin
                        ValueEntryOnPostDataItem("Value Entry");
                        ValueOfCostPstdToGL := NcValueOfCostPstdToGL;

                        AtLastDate := NcValueOfWIP + NcValueOfMatConsump + NcValueOfCap + NcValueOfOutput;
                        LastOutput := NcValueOfOutput;
                        LastWIP := NcValueOfWIP;

                        NcValueOfWIP := 0;
                        NcValueOfOutput := 0;
                        NcValueOfMatConsump := 0;
                        NcValueOfCap := 0;
                        NcValueOfInvOutput1 := 0;
                        NcValueOfExpOutPut1 := 0;
                        NcValueOfExpOutPut2 := 0;
                        NcValueOfRevalCostAct := 0;
                        NcValueOfRevalCostPstd := 0;
                        NcValueOfCostPstdToGL := 0;
                      end;
                    end;

                    TotalValueOfCostPstdToGL := TotalValueOfCostPstdToGL + ValueOfCostPstdToGL;
                    TotalValueOfOutput := TotalValueOfOutput + ValueOfOutput;
                    TotalValueOfCap := TotalValueOfCap + ValueOfCap;
                    TotalValueOfMatConsump := TotalValueOfMatConsump + ValueOfMatConsump;
                    TotalValueOfWIP := TotalValueOfWIP + ValueOfWIP;
                    TotalLastOutput := TotalLastOutput + LastOutput;
                    TotalAtLastDate := TotalAtLastDate + AtLastDate;
                    TotalLastWIP := TotalLastWIP + LastWIP;

                    if CountRecord <> LengthRecord then
                      CurrReport.Skip;
                end;

                trigger OnPostDataItem()
                begin
                    ValueEntryOnPostDataItem("Value Entry");
                end;

                trigger OnPreDataItem()
                begin
                    TotalValueOfCostPstdToGL := 0;
                    TotalValueOfOutput := 0;
                    TotalValueOfCap := 0;
                    TotalValueOfMatConsump := 0;
                    TotalValueOfWIP := 0;
                    TotalLastOutput := 0;
                    TotalAtLastDate := 0;
                    TotalLastWIP := 0;

                    SetRange("Order Type","order type"::Production);
                    SetRange("Order No.","Production Order"."No.");
                    if EndDate <> 0D then
                      SetRange("Posting Date",0D,EndDate);

                    ValueOfRevalCostAct := 0;
                    ValueOfRevalCostPstd := 0;
                    LengthRecord := 0;
                    CountRecord := 0;

                    if Find('-') then
                      repeat
                        LengthRecord := LengthRecord + 1;
                      until  Next = 0;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if FinishedProdOrderIsCompletelyInvoiced then
                  CurrReport.Skip;
                EntryFound := ValueEntryExist("Production Order",StartDate,EndDate);
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
                    field(StartingDate;StartDate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Starting Date';
                    }
                    field(EndingDate;EndDate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Ending Date';
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
        ProdOrderFilter := "Production Order".GetFilters;
        if (StartDate = 0D) and (EndDate = 0D) then
          EndDate := WorkDate;

        if StartDate in [0D,00000101D] then
          StartDateText := ''
        else
          StartDateText := Format(StartDate - 1);
    end;

    var
        Text005: label 'As of %1';
        StartDate: Date;
        EndDate: Date;
        ProdOrderFilter: Text;
        StartDateText: Text[10];
        ValueOfWIP: Decimal;
        ValueOfMatConsump: Decimal;
        ValueOfCap: Decimal;
        ValueOfOutput: Decimal;
        ValueOfExpOutput1: Decimal;
        ValueOfInvOutput1: Decimal;
        ValueOfExpOutput2: Decimal;
        ValueOfRevalCostAct: Decimal;
        ValueOfRevalCostPstd: Decimal;
        ValueOfCostPstdToGL: Decimal;
        NcValueOfWIP: Decimal;
        NcValueOfOutput: Decimal;
        NcValueOfMatConsump: Decimal;
        NcValueOfCap: Decimal;
        NcValueOfInvOutput1: Decimal;
        NcValueOfExpOutPut1: Decimal;
        NcValueOfExpOutPut2: Decimal;
        NcValueOfRevalCostAct: Decimal;
        NcValueOfRevalCostPstd: Decimal;
        NcValueOfCostPstdToGL: Decimal;
        LastOutput: Decimal;
        LengthRecord: Integer;
        CountRecord: Integer;
        AtLastDate: Decimal;
        LastWIP: Decimal;
        TotalValueOfCostPstdToGL: Decimal;
        TotalValueOfOutput: Decimal;
        TotalValueOfCap: Decimal;
        TotalValueOfMatConsump: Decimal;
        TotalValueOfWIP: Decimal;
        TotalLastOutput: Decimal;
        TotalAtLastDate: Decimal;
        TotalLastWIP: Decimal;
        InventoryValuationWIPCptnLbl: label 'Inventory Valuation - WIP';
        CurrReportPageNoCaptionLbl: label 'Page';
        ValueOfCapCaptionLbl: label 'Capacity ';
        ValueOfOutputCaptionLbl: label 'Output ';
        ValueEntryCostPostedtoGLCaptionLbl: label 'Cost Posted to G/L';
        ValueOfMatConsumpCaptionLbl: label 'Consumption ';
        ProductionOrderNoCaptionLbl: label 'No.';
        ProdOrderStatusCaptionLbl: label 'Status';
        ProdOrderDescriptionCaptionLbl: label 'Description';
        ProdOrderSourceTypeCaptnLbl: label 'Source Type';
        ProdOrderSourceNoCaptionLbl: label 'Source No.';
        TotalCaptionLbl: label 'Total';
        EntryFound: Boolean;

    local procedure ValueEntryOnPostDataItem(ValueEntry: Record "Value Entry")
    begin
        with ValueEntry do
          if (NcValueOfExpOutPut2 + NcValueOfExpOutPut1) = 0 then begin // if prod. order is invoiced
            NcValueOfOutput := NcValueOfOutput - NcValueOfRevalCostAct; // take out revalued differnce
            NcValueOfCostPstdToGL := NcValueOfCostPstdToGL - NcValueOfRevalCostPstd; // take out Cost posted to G/L
          end;
    end;

    local procedure IsNotWIP(): Boolean
    begin
        with "Value Entry" do begin
          if "Item Ledger Entry Type" = "item ledger entry type"::Output then
            exit(not ("Entry Type" in ["entry type"::"Direct Cost",
                                       "entry type"::Revaluation]));

          exit("Expected Cost");
        end;
    end;

    local procedure IsProductionCost(ValueEntry: Record "Value Entry"): Boolean
    var
        ILE: Record "Item Ledger Entry";
    begin
        with ValueEntry do
          if ("Entry Type" = "entry type"::Revaluation) and ("Item Ledger Entry Type" = "item ledger entry type"::Consumption) then begin
            ILE.Get("Item Ledger Entry No.");
            if ILE.Positive then
              exit(false)
          end;

        exit(true);
    end;

    local procedure FinishedProdOrderIsCompletelyInvoiced(): Boolean
    var
        InvtAdjmtEntryOrder: Record "Inventory Adjmt. Entry (Order)";
    begin
        if "Production Order".Status <> "Production Order".Status::Finished then
          exit(false);

        with InvtAdjmtEntryOrder do begin
          SetRange("Order Type","order type"::Production);
          SetRange("Order No.","Production Order"."No.");
          SetRange("Completely Invoiced",false);
          if not IsEmpty then
            exit(false);
        end;

        exit(not ValueEntryExist("Production Order",StartDate,EndDate));
    end;


    procedure InitializeRequest(NewStartDate: Date;NewEndDate: Date)
    begin
        StartDate := NewStartDate;
        EndDate := NewEndDate;
    end;

    local procedure ValueEntryExist(ProductionOrder: Record "Production Order";StartDate: Date;EndDate: Date): Boolean
    var
        ValueEntry: Record "Value Entry";
    begin
        with ValueEntry do begin
          SetRange("Order Type","order type"::Production);
          SetRange("Order No.",ProductionOrder."No.");
          SetRange("Posting Date",StartDate,EndDate);
          exit(not IsEmpty);
        end;
    end;
}

