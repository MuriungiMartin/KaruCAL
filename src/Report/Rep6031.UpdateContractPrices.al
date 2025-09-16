#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 6031 "Update Contract Prices"
{
    Caption = 'Update Contract Prices';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem("Service Contract Header";"Service Contract Header")
        {
            CalcFields = Name,"Calcd. Annual Amount";
            DataItemTableView = sorting("Next Price Update Date") where("Contract Type"=const(Contract),Status=const(Signed),"Change Status"=const(Locked));
            RequestFilterFields = "Contract No.","Item Filter";
            column(ReportForNavId_9952; 9952)
            {
            }

            trigger OnAfterGetRecord()
            begin
                ServContract.Get("Contract Type","Contract No.");
                ServContract.SuspendStatusCheck(true);
                UpdateServContract := true;

                OldAnnualAmount := "Annual Amount";

                "Last Price Update %" := PriceUpdPct;
                CalcFields("Calcd. Annual Amount");
                if Format("Price Update Period") = '' then
                  UpdateServContract := false;

                TotOldAnnualAmount := TotOldAnnualAmount + OldAnnualAmount;
                TotSignedAmount := TotSignedAmount + "Calcd. Annual Amount";

                TotContractLinesAmount := 0;
                ServContractLine.Reset;
                ServContractLine.SetRange("Contract Type",ServContractLine."contract type"::Contract);
                ServContractLine.SetRange("Contract No.","Contract No.");
                if GetFilter("Item Filter") <> '' then
                  ServContractLine.SetFilter("Item No.",GetFilter("Item Filter"));
                if ServContractLine.Find('-') then
                  repeat
                    ServContractLine2 := ServContractLine;
                    ServContractLine.SuspendStatusCheck(true);
                    if UpdateServContract then begin
                      ServContractLine.Validate(
                        "Line Value",
                        ROUND(
                          ServContractLine."Line Value" + (ServContractLine."Line Value" * PriceUpdPct / 100),
                          Currency."Amount Rounding Precision"));
                      if ServMgtSetup."Register Contract Changes" then
                        ServContractLine.LogContractLineChanges(ServContractLine2);
                      ServContractLine.Modify(true);
                    end;
                    TotContractLinesAmount := TotContractLinesAmount + ServContractLine."Line Amount";
                  until ServContractLine.Next = 0;

                if UpdateServContract then begin
                  ServContract."Last Price Update Date" := WorkDate;
                  ServContract."Next Price Update Date" := CalcDate(ServContract."Price Update Period",ServContract."Next Price Update Date");
                  ServContract."Last Price Update %" := PriceUpdPct;
                  ContractGainLossEntry.AddEntry(
                    5,
                    ServContract."Contract Type",
                    ServContract."Contract No.",
                    TotContractLinesAmount - ServContract."Annual Amount",'');

                  ServContract."Annual Amount" := TotContractLinesAmount;
                  ServContract."Amount per Period" :=
                    ROUND(ServContract."Annual Amount" / ReturnNoOfPer(ServContract."Invoice Period"),
                      Currency."Amount Rounding Precision");
                  if OldAnnualAmount <> ServContract."Annual Amount" then
                    ServContract."Print Increase Text" := true;
                  ServContract.Modify;
                  if ServMgtSetup."Register Contract Changes" then
                    ServContract.UpdContractChangeLog("Service Contract Header");
                  TotNewAmount := TotNewAmount + ServContract."Annual Amount";
                end;
            end;

            trigger OnPreDataItem()
            begin
                if PerformUpd = Performupd::"Print Only" then begin
                  Clear(ContractPriceUpdateTest);
                  ContractPriceUpdateTest.InitVariables(PriceUpdPct,UpdateToDate);
                  ContractPriceUpdateTest.SetTableview("Service Contract Header");
                  ContractPriceUpdateTest.RunModal;
                  CurrReport.Break;
                end;

                TotOldAnnualAmount := 0;
                TotNewAmount := 0;
                TotSignedAmount := 0;
                if PriceUpdPct = 0 then
                  Error(Text000);

                if PriceUpdPct > 10 then
                  if not Confirm(Text001) then
                    Error(Text002);

                if UpdateToDate = 0D then
                  Error(Text003);

                SetFilter("Next Price Update Date",'<>%1&<=%2',0D,UpdateToDate);

                Currency.InitRoundingPrecision;
                ServMgtSetup.Get;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(UpdateToDate;UpdateToDate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Update to Date';
                    }
                    field("Price Update %";PriceUpdPct)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Price Update %';
                        DecimalPlaces = 0:5;
                    }
                    field(PerformUpd;PerformUpd)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Action';
                        OptionCaption = 'Update Contract Prices,Print Only';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        UpdateToDate := WorkDate;
    end;

    var
        Text000: label 'You must fill in the Price Update % field.';
        Text001: label 'The price update % is unusually large.\\Confirm that this is the correct percentage.';
        Text002: label 'The program has stopped the batch job at your request.';
        Text003: label 'You must fill in the Update to Date field.';
        ServContract: Record "Service Contract Header";
        ServContractLine: Record "Service Contract Line";
        ContractGainLossEntry: Record "Contract Gain/Loss Entry";
        ServContractLine2: Record "Service Contract Line";
        Currency: Record Currency;
        ServMgtSetup: Record "Service Mgt. Setup";
        ContractPriceUpdateTest: Report "Contract Price Update - Test";
        OldAnnualAmount: Decimal;
        TotOldAnnualAmount: Decimal;
        TotNewAmount: Decimal;
        TotSignedAmount: Decimal;
        TotContractLinesAmount: Decimal;
        PriceUpdPct: Decimal;
        UpdateToDate: Date;
        PerformUpd: Option "Update Contract Prices","Print Only";
        UpdateServContract: Boolean;


    procedure InitializeRequest(UpdateToDateFrom: Date;PricePercentage: Decimal;PerformUpdate: Option)
    begin
        UpdateToDate := UpdateToDateFrom;
        PriceUpdPct := PricePercentage;
        PerformUpd := PerformUpdate;
    end;
}

