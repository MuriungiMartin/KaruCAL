#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5983 "Contract Gain/Loss Entries"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Contract GainLoss Entries.rdlc';
    Caption = 'Contract Gain/Loss Entries';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Contract Gain/Loss Entry";"Contract Gain/Loss Entry")
        {
            DataItemTableView = sorting("Contract No.","Change Date","Reason Code");
            RequestFilterFields = "Contract No.","Change Date","Reason Code";
            column(ReportForNavId_1395; 1395)
            {
            }
            column(TodayFormatted;Format(Today,0,4))
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(TblCaptContGainLossFilter;TableCaption + ': ' + ContractGainLossFilter)
            {
            }
            column(ContractGainLossFilter;ContractGainLossFilter)
            {
            }
            column(ContNo_ContGainLossEntry;"Contract No.")
            {
                IncludeCaption = true;
            }
            column(GrpCode_ContGainLossEntry;"Contract Group Code")
            {
                IncludeCaption = true;
            }
            column(ReaCode_ContGainLossEntry;"Reason Code")
            {
                IncludeCaption = true;
            }
            column(CustNo_ContGainLossEntry;"Customer No.")
            {
                IncludeCaption = true;
            }
            column(ShipCode_ContGainLossEntry;"Ship-to Code")
            {
            }
            column(ContGain_ContGainLossEntry;ContractGain)
            {
                AutoFormatType = 1;
            }
            column(ContLoss_ContGainLossEntry;ContractLoss)
            {
                AutoFormatType = 1;
            }
            column(RespCent_ContGainLossEntry;"Responsibility Center")
            {
                IncludeCaption = true;
            }
            column(CustShiptoName;CustShiptoName)
            {
            }
            column(TypeofCng_ContGainLossEty;"Type of Change")
            {
                IncludeCaption = true;
            }
            column(TotalContractNo;Text000 + "Contract No.")
            {
            }
            column(GrFooterShowoutput;Abs(ContractLoss) + Abs(ContractGain) > 0)
            {
            }
            column(Total;TotalLbl)
            {
            }
            column(ContractGainLossEntriesCaption;ContractGainLossEntriesCaptionLbl)
            {
            }
            column(CurrReportPageNoCaption;CurrReportPageNoCaptionLbl)
            {
            }
            column(ShiptoCodeCaption;ShiptoCodeCaptionLbl)
            {
            }
            column(ContractGainCaption;ContractGainCaptionLbl)
            {
            }
            column(ContractLossCaption;ContractLossCaptionLbl)
            {
            }
            column(CustomerNameCaption;CustomerNameCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                CustShiptoName := '';
                if "Ship-to Code" <> '' then
                  if ShiptoAddr.Get("Customer No.","Ship-to Code") then
                    CustShiptoName := ShiptoAddr.Name;
                if CustShiptoName = '' then
                  if Cust.Get("Customer No.") then
                    CustShiptoName := Cust.Name;

                if Amount > 0 then
                  ContractGain := Amount
                else
                  ContractLoss := Abs(Amount);
            end;

            trigger OnPreDataItem()
            begin
                CurrReport.CreateTotals(ContractLoss,ContractGain);
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        ContractGainLossFilter := "Contract Gain/Loss Entry".GetFilters;
    end;

    var
        Text000: label 'Total for Contract ';
        Cust: Record Customer;
        ShiptoAddr: Record "Ship-to Address";
        ContractGainLossFilter: Text;
        CustShiptoName: Text[50];
        ContractGain: Decimal;
        ContractLoss: Decimal;
        TotalLbl: label 'Total';
        ContractGainLossEntriesCaptionLbl: label 'Contract Gain/Loss Entries';
        CurrReportPageNoCaptionLbl: label 'Page';
        ShiptoCodeCaptionLbl: label 'Ship-to Code';
        ContractGainCaptionLbl: label 'Contract Gain';
        ContractLossCaptionLbl: label 'Contract Loss';
        CustomerNameCaptionLbl: label 'Customer Name';
}

