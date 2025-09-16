#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5984 "Contract Invoicing"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Contract Invoicing.rdlc';
    Caption = 'Contract Invoicing - Test';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Service Contract Header";"Service Contract Header")
        {
            DataItemTableView = sorting("Bill-to Customer No.","Contract Type","Combine Invoices","Next Invoice Date") where("Contract Type"=const(Contract),Status=const(Signed));
            RequestFilterFields = "Bill-to Customer No.","Contract No.";
            column(ReportForNavId_9952; 9952)
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(InvoiceToDate;Format(InvoiceToDate))
            {
            }
            column(PostingDate;Format(PostingDate))
            {
            }
            column(TblCptnServContractFilters;TableCaption + ': ' + ServContractFilters)
            {
            }
            column(ServContractFilters;ServContractFilters)
            {
            }
            column(ContractInvoicingTestCaption;ContractInvoicingTestCaptionLbl)
            {
            }
            column(PageNoCaption;PageNoCaptionLbl)
            {
            }
            column(InvoiceToDateCaption;InvoiceToDateCaptionLbl)
            {
            }
            column(PostingDateCaption;PostingDateCaptionLbl)
            {
            }
            column(InvoicePeriodCaption;InvoicePeriodCaptionLbl)
            {
            }
            column(NoofInvoicesCaption;NoofInvoicesCaptionLbl)
            {
            }
            column(LastInvDateCaption;LastInvDateCaptionLbl)
            {
            }
            column(NextInvDateCaption;NextInvDateCaptionLbl)
            {
            }
            column(DescriptionCaption;DescriptionCaptionLbl)
            {
            }
            column(AmountPerPeriodCaption;AmountPerPeriodCaptionLbl)
            {
            }
            column(ContractNoCaption;ContractNoCaptionLbl)
            {
            }
            column(NameCaption;NameCaptionLbl)
            {
            }
            column(CustomerNoCaption;CustomerNoCaptionLbl)
            {
            }
            dataitem(ContrHeader;"Integer")
            {
                DataItemTableView = sorting(Number) where(Number=const(1));
                column(ReportForNavId_9216; 9216)
                {
                }
                column(CustNo_ServContract;"Service Contract Header"."Customer No.")
                {
                }
                column(Name_ServContract;"Service Contract Header".Name)
                {
                }
                column(ContractNo1_ServContract;"Service Contract Header"."Contract No.")
                {
                }
                column(InvPeriod_ServContract;"Service Contract Header"."Invoice Period")
                {
                }
                column(AmtPerPeriod_ServContract;"Service Contract Header"."Amount per Period")
                {
                }
                column(NoOfInvoices;NoOfInvoices)
                {
                    AutoFormatType = 1;
                }
                column(LastInvDate_ServContract;Format("Service Contract Header"."Last Invoice Date"))
                {
                }
                column(NextInvDate_ServContract;Format("Service Contract Header"."Next Invoice Date"))
                {
                }
                column(IndicatorValue;'1')
                {
                }
            }
            dataitem(InvPeriod;"Integer")
            {
                DataItemTableView = sorting(Number);
                column(ReportForNavId_8050; 8050)
                {
                }
                column(ContractInvPeriod;ServLedgEntryTEMP."Contract Invoice Period")
                {
                }
                column(ServLedgEntryAmt;ServLedgEntryTEMP.Amount)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if Number = 1 then
                      ServLedgEntryTEMP.FindSet
                    else
                      ServLedgEntryTEMP.Next;
                    if ServLedgEntryTEMP."Posting Date" < "Service Contract Header"."Next Invoice Date" then
                      CurrReport.Skip;
                end;

                trigger OnPreDataItem()
                begin
                    SetRange(Number,1,ServLedgEntryTEMP.Count);
                end;
            }
            dataitem(ContrSum;"Integer")
            {
                DataItemTableView = sorting(Number) where(Number=const(1));
                column(ReportForNavId_7201; 7201)
                {
                }
                column(InvSum;InvoiceSum)
                {
                }
                column(InvoiceTotalCaption;InvoiceTotalCaptionLbl)
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                if "Starting Date" = 0D then
                  CurrReport.Skip;
                AccumulatedAmount := 0;
                InvoiceSum := 0;
                CalcFields(Name);
                BuildInvoicePlan("Service Contract Header");
            end;

            trigger OnPreDataItem()
            begin
                if PostingDate = 0D then
                  Error(Text000);

                if PostingDate > WorkDate then
                  if not Confirm(Text001) then
                    Error(Text002);

                if InvoiceToDate = 0D then
                  Error(Text003);

                if InvoiceToDate > WorkDate then
                  if not Confirm(Text004) then
                    Error(Text002);

                Currency.InitRoundingPrecision;

                CurrReport.CreateTotals("Amount per Period");
                SetFilter("Next Invoice Date",'<>%1&<=%2',0D,InvoiceToDate);
                if GetFilter("Invoice Period") <> '' then
                  SetFilter("Invoice Period",GetFilter("Invoice Period") + '&<>%1',"invoice period"::None)
                else
                  SetFilter("Invoice Period",'<>%1',"invoice period"::None);
                DateSep := '..';
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
                    field(PostingDate1;PostingDate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Posting Date';
                    }
                    field(InvoiceDate1;InvoiceToDate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Invoice to Date';
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
        if PostingDate = 0D then
          PostingDate := WorkDate;
    end;

    trigger OnPreReport()
    begin
        ServContractFilters := "Service Contract Header".GetFilters;
    end;

    var
        Text000: label 'You have not filled in the posting date.';
        Text001: label 'The posting date is later than the work date.\\Confirm that this is the correct date.';
        Text002: label 'The program has stopped the batch job at your request.';
        Text003: label 'You must fill in the Invoice-to Date field.';
        Text004: label 'The Invoice-to Date is later than the work date.\\Confirm that this is the correct date.';
        Currency: Record Currency;
        ServLedgEntryTEMP: Record "Service Ledger Entry" temporary;
        ServContractMgt: Codeunit ServContractManagement;
        ServContractFilters: Text;
        NoOfInvoices: Integer;
        PostingDate: Date;
        InvoiceToDate: Date;
        InvoiceFrom: Date;
        InvoiceTo: Date;
        EntryNo: Integer;
        DateSep: Text[10];
        AccumulatedAmount: Decimal;
        InvoiceSum: Decimal;
        ContractInvoicingTestCaptionLbl: label 'Contract Invoicing - Test';
        PageNoCaptionLbl: label 'Page';
        InvoiceToDateCaptionLbl: label 'Invoice to Date';
        PostingDateCaptionLbl: label 'Posting Date';
        InvoicePeriodCaptionLbl: label 'Invoice Period';
        NoofInvoicesCaptionLbl: label 'No. of Invoices';
        LastInvDateCaptionLbl: label 'Last Inv. Date';
        NextInvDateCaptionLbl: label 'Next Invoice Date';
        DescriptionCaptionLbl: label 'Expected invoice amount';
        AmountPerPeriodCaptionLbl: label 'Amount per Period';
        ContractNoCaptionLbl: label 'Contract No.';
        NameCaptionLbl: label 'Name';
        CustomerNoCaptionLbl: label 'Customer No.';
        InvoiceTotalCaptionLbl: label 'Invoice Total';


    procedure InitVariables(LocalPostingDate: Date;LocalInvoiceToDate: Date)
    begin
        PostingDate := LocalPostingDate;
        InvoiceToDate := LocalInvoiceToDate;
    end;

    local procedure BuildInvoicePlan(ServContrHeader: Record "Service Contract Header")
    var
        InvoicePeriod: Code[10];
        DateFormula: DateFormula;
        Stop: Boolean;
    begin
        ServLedgEntryTEMP.DeleteAll;
        InvoicePeriod := ServContractMgt.GetInvoicePeriodText(ServContrHeader."Invoice Period");
        Evaluate(DateFormula,InvoicePeriod);
        EntryNo := 0;
        if Date2dmy(ServContrHeader."Starting Date",1) > 1 then begin
          if ServContrHeader."Expiration Date" <> 0D then
            InvoiceTo := FirstDate(CalcDate('<CM>',ServContrHeader."Starting Date"),ServContrHeader."Expiration Date")
          else
            InvoiceTo := CalcDate('<CM>',ServContrHeader."Starting Date");
          InsertServLedgEntry(ServContrHeader."Starting Date",InvoiceTo);
          InvoiceFrom := CalcDate('<1D>',InvoiceTo);
        end else
          InvoiceFrom := ServContrHeader."Starting Date";
        InvoiceTo := CalcDate(DateFormula,InvoiceFrom);
        InvoiceTo := CalcDate('<-CM-1D>',InvoiceTo);
        if ServContrHeader."Expiration Date" <> 0D then
          InvoiceTo := FirstDate(InvoiceTo,ServContrHeader."Expiration Date");
        InsertServLedgEntry(InvoiceFrom,InvoiceTo);
        Stop := false;
        while (InvoiceFrom <= InvoiceToDate) and (not Stop) do begin
          InvoiceFrom := CalcDate('<1D>',InvoiceTo);
          InvoiceTo := CalcDate(DateFormula,InvoiceFrom);
          InvoiceTo := CalcDate('<-CM-1D>',InvoiceTo);
          if ServContrHeader."Expiration Date" <> 0D then
            InvoiceTo := FirstDate(InvoiceTo,ServContrHeader."Expiration Date");
          if InvoiceFrom <= InvoiceToDate then
            InsertServLedgEntry(InvoiceFrom,InvoiceTo);
          if (InvoiceTo = ServContrHeader."Expiration Date") or (InvoiceTo >= InvoiceToDate) then
            Stop := true;
        end;
    end;

    local procedure FirstDate(Date1: Date;Date2: Date): Date
    begin
        if Date1 < Date2 then
          exit(Date1);

        exit(Date2);
    end;

    local procedure InsertServLedgEntry(DateFrom: Date;DateTo: Date)
    begin
        EntryNo += 1;
        ServLedgEntryTEMP.Init;
        ServLedgEntryTEMP."Entry No." := EntryNo;
        ServLedgEntryTEMP."Posting Date" := DateFrom;
        ServLedgEntryTEMP."Contract Invoice Period" := Format(DateFrom) + DateSep + Format(DateTo);
        if DateTo = "Service Contract Header"."Expiration Date" then begin
          if ServContractMgt.YearContract("Service Contract Header"."Contract Type","Service Contract Header"."Contract No.")
          then
            ServLedgEntryTEMP.Amount := "Service Contract Header"."Annual Amount" - AccumulatedAmount
          else
            ServLedgEntryTEMP.Amount := CalcContrAmt("Service Contract Header",DateFrom,DateTo);
        end else begin
          ServLedgEntryTEMP.Amount := CalcContrAmt("Service Contract Header",DateFrom,DateTo);
          AccumulatedAmount := AccumulatedAmount + ServLedgEntryTEMP.Amount;
        end;
        if DateFrom >= "Service Contract Header"."Next Invoice Date" then
          InvoiceSum := InvoiceSum + ServLedgEntryTEMP.Amount;
        ServLedgEntryTEMP.Insert;
    end;

    local procedure CalcContrAmt(ServContHeader: Record "Service Contract Header";DateFrom: Date;DateTo: Date): Decimal
    var
        ServContractLine: Record "Service Contract Line";
        ContAmt: Decimal;
    begin
        Clear(ServContractLine);
        ServContractLine.SetRange("Contract Type",ServContHeader."Contract Type");
        ServContractLine.SetRange("Contract No.",ServContHeader."Contract No.");
        ContAmt := 0;
        if ServContractLine.FindSet then
          repeat
            ContAmt := ContAmt + ROUND(ServContractMgt.CalcContractLineAmount(ServContractLine."Line Amount",DateFrom,DateTo));
          until ServContractLine.Next = 0;
        exit(ROUND(ContAmt));
    end;
}

