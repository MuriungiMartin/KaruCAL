#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 312 "Purchase Statistics"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Purchase Statistics.rdlc';
    Caption = 'Purchase Statistics';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(Vendor;Vendor)
        {
            RequestFilterFields = "No.","Search Name","Vendor Posting Group","Currency Code";
            column(ReportForNavId_3182; 3182)
            {
            }
            column(Picture;CompanyInformation.Picture)
            {
            }
            column(Tel;CompanyInformation."Phone No.")
            {
            }
            column(Company_Email;CompanyInformation."E-Mail")
            {
            }
            column(Website;CompanyInformation."Home Page")
            {
            }
            column(floor;CompanyInformation."Ship-to Address 2")
            {
            }
            column(Locations;CompanyInformation.City)
            {
            }
            column(addess2;CompanyInformation."Address 2")
            {
            }
            column(Adress;CompanyInformation.Address)
            {
            }
            column(County;CompanyInformation.County)
            {
            }
            column(Name;CompanyInformation.Name)
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(Vendor_TABLECAPTION__________VendFilter;TableCaption + ': ' + VendFilter)
            {
            }
            column(VendFilter;VendFilter)
            {
            }
            column(PeriodStartDate_2_;Format(PeriodStartDate[2]))
            {
            }
            column(PeriodStartDate_3_;Format(PeriodStartDate[3]))
            {
            }
            column(PeriodStartDate_4_;Format(PeriodStartDate[4]))
            {
            }
            column(PeriodStartDate_3__1;Format(PeriodStartDate[3] - 1))
            {
            }
            column(PeriodStartDate_4__1;Format(PeriodStartDate[4] - 1))
            {
            }
            column(PeriodStartDate_5__1;Format(PeriodStartDate[5] - 1))
            {
            }
            column(Vendor__No__;"No.")
            {
            }
            column(Vendor_Name;Name)
            {
            }
            column(VendPurchLCY_1_;VendPurchLCY[1])
            {
                AutoFormatType = 1;
            }
            column(VendPurchLCY_2_;VendPurchLCY[2])
            {
                AutoFormatType = 1;
            }
            column(VendPurchLCY_3_;VendPurchLCY[3])
            {
                AutoFormatType = 1;
            }
            column(VendPurchLCY_4_;VendPurchLCY[4])
            {
                AutoFormatType = 1;
            }
            column(VendPurchLCY_5_;VendPurchLCY[5])
            {
                AutoFormatType = 1;
            }
            column(VendInvDiscAmountLCY_1_;VendInvDiscAmountLCY[1])
            {
                AutoFormatType = 1;
            }
            column(VendInvDiscAmountLCY_2_;VendInvDiscAmountLCY[2])
            {
                AutoFormatType = 1;
            }
            column(VendInvDiscAmountLCY_3_;VendInvDiscAmountLCY[3])
            {
                AutoFormatType = 1;
            }
            column(VendInvDiscAmountLCY_4_;VendInvDiscAmountLCY[4])
            {
                AutoFormatType = 1;
            }
            column(VendInvDiscAmountLCY_5_;VendInvDiscAmountLCY[5])
            {
                AutoFormatType = 1;
            }
            column(VendPaymentDiscLCY_1_;VendPaymentDiscLCY[1])
            {
                AutoFormatType = 1;
            }
            column(VendPaymentDiscLCY_2_;VendPaymentDiscLCY[2])
            {
                AutoFormatType = 1;
            }
            column(VendPaymentDiscLCY_3_;VendPaymentDiscLCY[3])
            {
                AutoFormatType = 1;
            }
            column(VendPaymentDiscLCY_4_;VendPaymentDiscLCY[4])
            {
                AutoFormatType = 1;
            }
            column(VendPaymentDiscLCY_5_;VendPaymentDiscLCY[5])
            {
                AutoFormatType = 1;
            }
            column(VendPaymentDiscTolLcy_1_;VendPaymentDiscTolLcy[1])
            {
                AutoFormatType = 1;
            }
            column(VendPaymentDiscTolLcy_2_;VendPaymentDiscTolLcy[2])
            {
                AutoFormatType = 1;
            }
            column(VendPaymentDiscTolLcy_3_;VendPaymentDiscTolLcy[3])
            {
                AutoFormatType = 1;
            }
            column(VendPaymentDiscTolLcy_4_;VendPaymentDiscTolLcy[4])
            {
                AutoFormatType = 1;
            }
            column(VendPaymentDiscTolLcy_5_;VendPaymentDiscTolLcy[5])
            {
                AutoFormatType = 1;
            }
            column(VendPaymentTolLcy_5_;VendPaymentTolLcy[5])
            {
                AutoFormatType = 1;
            }
            column(VendPaymentTolLcy_4_;VendPaymentTolLcy[4])
            {
                AutoFormatType = 1;
            }
            column(VendPaymentTolLcy_3_;VendPaymentTolLcy[3])
            {
                AutoFormatType = 1;
            }
            column(VendPaymentTolLcy_2_;VendPaymentTolLcy[2])
            {
                AutoFormatType = 1;
            }
            column(VendPaymentTolLcy_1_;VendPaymentTolLcy[1])
            {
                AutoFormatType = 1;
            }
            column(VendPurchLCY_1__Control40;VendPurchLCY[1])
            {
                AutoFormatType = 1;
            }
            column(VendInvDiscAmountLCY_1__Control46;VendInvDiscAmountLCY[1])
            {
                AutoFormatType = 1;
            }
            column(VendPaymentDiscLCY_1__Control52;VendPaymentDiscLCY[1])
            {
                AutoFormatType = 1;
            }
            column(VendPaymentDiscTolLcy_1__Control77;VendPaymentDiscTolLcy[1])
            {
                AutoFormatType = 1;
            }
            column(VendPaymentTolLcy_1__Control78;VendPaymentTolLcy[1])
            {
                AutoFormatType = 1;
            }
            column(Purchase_StatisticsCaption;Purchase_StatisticsCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Vendor__No__Caption;FieldCaption("No."))
            {
            }
            column(Vendor_NameCaption;FieldCaption(Name))
            {
            }
            column(beforeCaption;beforeCaptionLbl)
            {
            }
            column(after___Caption;after___CaptionLbl)
            {
            }
            column(VendPurchLCY_1_Caption;VendPurchLCY_1_CaptionLbl)
            {
            }
            column(VendInvDiscAmountLCY_1_Caption;VendInvDiscAmountLCY_1_CaptionLbl)
            {
            }
            column(VendPaymentDiscLCY_1_Caption;VendPaymentDiscLCY_1_CaptionLbl)
            {
            }
            column(VendPaymentDiscTolLcy_1_Caption;VendPaymentDiscTolLcy_1_CaptionLbl)
            {
            }
            column(VendPaymentTolLcy_1_Caption;VendPaymentTolLcy_1_CaptionLbl)
            {
            }
            column(TotalCaption;TotalCaptionLbl)
            {
            }
            column(VendPurchLCY_1__Control40Caption;VendPurchLCY_1__Control40CaptionLbl)
            {
            }
            column(VendInvDiscAmountLCY_1__Control46Caption;VendInvDiscAmountLCY_1__Control46CaptionLbl)
            {
            }
            column(VendPaymentDiscLCY_1__Control52Caption;VendPaymentDiscLCY_1__Control52CaptionLbl)
            {
            }
            column(VendPaymentDiscTolLcy_1__Control77Caption;VendPaymentDiscTolLcy_1__Control77CaptionLbl)
            {
            }
            column(VendPaymentTolLcy_1__Control78Caption;VendPaymentTolLcy_1__Control78CaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                PrintVend := false;
                for i := 1 to 5 do begin
                  SetRange("Date Filter",PeriodStartDate[i],PeriodStartDate[i + 1] - 1);
                  CalcFields("Purchases (LCY)","Inv. Discounts (LCY)","Pmt. Discounts (LCY)",
                    "Pmt. Disc. Tolerance (LCY)","Pmt. Tolerance (LCY)");
                  VendPurchLCY[i] := "Purchases (LCY)";
                  VendInvDiscAmountLCY[i] := "Inv. Discounts (LCY)";
                  VendPaymentDiscLCY[i] := "Pmt. Discounts (LCY)";
                  VendPaymentDiscTolLcy[i] := "Pmt. Disc. Tolerance (LCY)";
                  VendPaymentTolLcy[i] := "Pmt. Tolerance (LCY)";
                  if (VendPurchLCY[i] <> 0) or (VendInvDiscAmountLCY[i] <> 0) or (VendPaymentDiscLCY[i] <> 0) then
                    PrintVend := true;
                end;
                if not PrintVend then
                  CurrReport.Skip;
            end;

            trigger OnPreDataItem()
            begin
                CurrReport.CreateTotals(VendPurchLCY,VendInvDiscAmountLCY,VendPaymentDiscLCY,VendPaymentDiscTolLcy,VendPaymentTolLcy);
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
                    field("PeriodStartDate[2]";PeriodStartDate[2])
                    {
                        ApplicationArea = Basic;
                        Caption = 'Starting Date';
                    }
                    field(PeriodLength;PeriodLength)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Period Length';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if PeriodStartDate[2] = 0D then
              PeriodStartDate[2] := WorkDate;
            if Format(PeriodLength) = '' then
              Evaluate(PeriodLength,'<1M>');
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        CompanyInformation.Get;
          CompanyInformation.CalcFields(CompanyInformation.Picture);



        VendFilter := Vendor.GetFilters;
        for i := 2 to 4 do
          PeriodStartDate[i + 1] := CalcDate(PeriodLength,PeriodStartDate[i]);
        PeriodStartDate[6] := 99991231D;
        PeriodStartDate[1] := 00000101D;
    end;

    var
        PeriodLength: DateFormula;
        VendFilter: Text;
        PeriodStartDate: array [6] of Date;
        VendPurchLCY: array [5] of Decimal;
        VendInvDiscAmountLCY: array [5] of Decimal;
        VendPaymentDiscLCY: array [5] of Decimal;
        VendPaymentDiscTolLcy: array [5] of Decimal;
        VendPaymentTolLcy: array [5] of Decimal;
        PrintVend: Boolean;
        i: Integer;
        Purchase_StatisticsCaptionLbl: label 'Purchase Statistics';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        beforeCaptionLbl: label '...Before';
        after___CaptionLbl: label 'After...';
        VendPurchLCY_1_CaptionLbl: label 'Purchases (LCY)';
        VendInvDiscAmountLCY_1_CaptionLbl: label 'Inv. Discounts (LCY)';
        VendPaymentDiscLCY_1_CaptionLbl: label 'Pmt. Discounts (LCY)';
        VendPaymentDiscTolLcy_1_CaptionLbl: label 'Pmt. Disc. Tolerance (LCY)';
        VendPaymentTolLcy_1_CaptionLbl: label 'Payment Tolerance (LCY)';
        TotalCaptionLbl: label 'Total';
        VendPurchLCY_1__Control40CaptionLbl: label 'Purchases (LCY)';
        VendInvDiscAmountLCY_1__Control46CaptionLbl: label 'Inv. Discounts (LCY)';
        VendPaymentDiscLCY_1__Control52CaptionLbl: label 'Pmt. Discounts (LCY)';
        VendPaymentDiscTolLcy_1__Control77CaptionLbl: label 'Pmt. Disc. Tolerance (LCY)';
        VendPaymentTolLcy_1__Control78CaptionLbl: label 'Payment Tolerance (LCY)';
        CompanyInformation: Record "Company Information";


    procedure InitializeRequest(NewPeriodLength: DateFormula;NewPeriodStartDate: Date)
    begin
        PeriodLength := NewPeriodLength;
        PeriodStartDate[2] := CalcDate(PeriodLength,NewPeriodStartDate);
    end;
}

