#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5985 "Contract Price Update - Test"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Contract Price Update - Test.rdlc';
    Caption = 'Contract Price Update - Test';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Service Contract Header";"Service Contract Header")
        {
            CalcFields = Name;
            DataItemTableView = sorting("Next Price Update Date") where("Contract Type"=const(Contract),Status=const(Signed),"Change Status"=const(Locked));
            RequestFilterFields = "Contract No.","Item Filter";
            RequestFilterHeading = 'Service Contract';
            column(ReportForNavId_9952; 9952)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(UpdateToDate;Format(UpdateToDate))
            {
            }
            column(PriceUpdPct;PriceUpdPct)
            {
            }
            column(Service_Contract_Header__TABLECAPTION__________ServContractFilters;TableCaption + ': ' + ServContractFilters)
            {
            }
            column(ServContractFilters;ServContractFilters)
            {
            }
            column(Service_Contract_Header__Contract_No__;"Contract No.")
            {
            }
            column(Service_Contract_Header__Customer_No__;"Customer No.")
            {
            }
            column(Service_Contract_Header_Name;Name)
            {
            }
            column(MsgTxt;MsgTxt)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Contract_Price_Update___TestCaption;Contract_Price_Update___TestCaptionLbl)
            {
            }
            column(Update_to_dateCaption;Update_to_dateCaptionLbl)
            {
            }
            column(PriceUpdPctCaption;PriceUpdPctCaptionLbl)
            {
            }
            column(Service_Contract_Header__Contract_No__Caption;FieldCaption("Contract No."))
            {
            }
            column(Service_Contract_Header__Customer_No__Caption;FieldCaption("Customer No."))
            {
            }
            column(Service_Contract_Header_NameCaption;FieldCaption(Name))
            {
            }
            column(Price_Update_DateCaption;Price_Update_DateCaptionLbl)
            {
            }
            column(Update_Caption;Update_CaptionLbl)
            {
            }
            column(Old_Annual_AmountCaption;Old_Annual_AmountCaptionLbl)
            {
            }
            column(New_Annual_AmountCaption;New_Annual_AmountCaptionLbl)
            {
            }
            column(MsgTxtCaption;MsgTxtCaptionLbl)
            {
            }
            column(Amount_DifferenceCaption;Amount_DifferenceCaptionLbl)
            {
            }
            dataitem("Integer";"Integer")
            {
                DataItemTableView = sorting(Number);
                column(ReportForNavId_5444; 5444)
                {
                }
                column(OldUpdateDate;Format(OldUpdateDate))
                {
                }
                column(OldAnnualAmount;OldAnnualAmount)
                {
                    AutoFormatType = 1;
                }
                column(PriceUpdPct_Control23;PriceUpdPct)
                {
                }
                column(NewAnnualAmount;NewAnnualAmount)
                {
                }
                column(Diff;Diff)
                {
                }
                column(Diff_Control10;Diff)
                {
                }
                column(Total_Caption;Total_CaptionLbl)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if Format(ServContract."Price Update Period") = '' then
                      CurrReport.Break;

                    if NewAnnualAmount > 0 then begin
                      OldAnnualAmount := NewAnnualAmount;
                      OldUpdateDate := CalcDate(ServContract."Price Update Period",OldUpdateDate);
                      OldAnnualAmount2 := OldAnnualAmount;
                      OldUpdateDate2 := OldUpdateDate;
                    end;

                    NewAnnualAmount := 0;

                    if TempServContractLine.Find('-') then
                      repeat
                        TempServContractLine.SuspendStatusCheck(true);
                        TempServContractLine.Validate(
                          "Line Value",
                          ROUND(
                            TempServContractLine."Line Value" + (TempServContractLine."Line Value" * PriceUpdPct / 100),
                            Currency."Amount Rounding Precision"));
                        TempServContractLine.Modify(true);
                        NewAnnualAmount := NewAnnualAmount + TempServContractLine."Line Amount";
                      until TempServContractLine.Next = 0;

                    if NewAnnualAmount <= 0 then begin
                      OldAnnualAmount := OldAnnualAmount2;
                      OldAnnualAmount2 := NewAnnualAmount;
                      OldUpdateDate := OldUpdateDate2;
                      OldUpdateDate2 := CalcDate(ServContract."Price Update Period",OldUpdateDate);
                    end;

                    Diff := NewAnnualAmount - OldAnnualAmount;

                    if OldUpdateDate > UpdateToDate then begin
                      NewAnnualAmount := 0;
                      CurrReport.Break
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    CurrReport.CreateTotals(Diff);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                TempServContractLine.DeleteAll;
                OldAnnualAmount := 0;
                OldAnnualAmount2 := 0;

                ServContract.Get("Contract Type","Contract No.");
                MsgTxt := '';
                ServContract.CopyFilters("Service Contract Header");
                OldUpdateDate := "Next Price Update Date";
                OldUpdateDate2 := "Next Price Update Date";
                if Format(ServContract."Price Update Period") = '' then
                  MsgTxt := Text005;
                ServContractLine.Reset;
                ServContractLine.SetRange("Contract Type",ServContractLine."contract type"::Contract);
                ServContractLine.SetRange("Contract No.",ServContract."Contract No.");
                if ServContract.GetFilter("Item Filter") <> '' then
                  ServContractLine.SetFilter("Item No.",ServContract.GetFilter("Item Filter"));
                if ServContractLine.Find('-') then
                  repeat
                    OldAnnualAmount += ServContractLine."Line Amount";
                    OldAnnualAmount2 += ServContractLine."Line Amount";
                    TempServContractLine := ServContractLine;
                    TempServContractLine.Insert;
                  until ServContractLine.Next = 0;
            end;

            trigger OnPreDataItem()
            begin
                if PriceUpdPct = 0 then
                  Error(Text000);

                if PriceUpdPct > 10 then
                  if not Confirm(Text001) then
                    Error(Text002);

                if UpdateToDate = 0D then
                  Error(Text003);

                SetFilter("Next Price Update Date",'<>%1&<=%2',0D,UpdateToDate);

                Currency.InitRoundingPrecision;
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
        if UpdateToDate = 0D then
          UpdateToDate := WorkDate;
    end;

    trigger OnPreReport()
    begin
        ServContractFilters := "Service Contract Header".GetFilters;
    end;

    var
        Text000: label 'You must fill in the Price Update % field.';
        Text001: label 'The price update % is unusually large.\\Confirm that this is the correct percentage.';
        Text002: label 'The program has stopped the batch job at your request.';
        Text003: label 'You must fill in the Update to Date field.';
        Text005: label 'The price update period is empty.';
        ServContract: Record "Service Contract Header";
        Currency: Record Currency;
        ServContractLine: Record "Service Contract Line";
        TempServContractLine: Record "Service Contract Line" temporary;
        MsgTxt: Text[80];
        ServContractFilters: Text;
        OldAnnualAmount: Decimal;
        OldAnnualAmount2: Decimal;
        NewAnnualAmount: Decimal;
        PriceUpdPct: Decimal;
        Diff: Decimal;
        OldUpdateDate: Date;
        OldUpdateDate2: Date;
        UpdateToDate: Date;
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Contract_Price_Update___TestCaptionLbl: label 'Contract Price Update - Test';
        Update_to_dateCaptionLbl: label 'Update to Date';
        PriceUpdPctCaptionLbl: label 'Next Price Update %';
        Price_Update_DateCaptionLbl: label 'Price Update Date';
        Update_CaptionLbl: label 'Update%';
        Old_Annual_AmountCaptionLbl: label 'Old Annual Amount';
        New_Annual_AmountCaptionLbl: label 'New Annual Amount';
        MsgTxtCaptionLbl: label 'Message';
        Amount_DifferenceCaptionLbl: label 'Amount Difference';
        Total_CaptionLbl: label 'Total:';


    procedure InitVariables(LocalPriceUpdPct: Decimal;LocalUpdateToDate: Date)
    begin
        PriceUpdPct := LocalPriceUpdPct;
        UpdateToDate := LocalUpdateToDate;
    end;
}

