#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51278 "HTL Customer - Summary Aging."
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HTL Customer - Summary Aging..rdlc';
    Caption = 'Customer - Summary Aging Simp.';

    dataset
    {
        dataitem(Customer;Customer)
        {
            DataItemTableView = where("Customer Posting Group"=const('KSM HOTEL'));
            RequestFilterFields = "No.","Search Name","Statistics Group","Payment Terms Code";
            column(ReportForNavId_6836; 6836)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(STRSUBSTNO_Text001_FORMAT_StartDate__;StrSubstNo(Text001,Format(StartDate)))
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(USERID;UserId)
            {
            }
            column(Customer_TABLECAPTION__________CustFilter;Customer.TableCaption + ': ' + CustFilter)
            {
            }
            column(CustBalanceDueLCY_5_;CustBalanceDueLCY[5])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCY_4_;CustBalanceDueLCY[4])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCY_3_;CustBalanceDueLCY[3])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCY_2_;CustBalanceDueLCY[2])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCY_1_;CustBalanceDueLCY[1])
            {
                AutoFormatType = 1;
            }
            column(Customer__No__;"No.")
            {
            }
            column(Customer_Name;Name)
            {
            }
            column(CustBalanceDueLCY_5__Control25;CustBalanceDueLCY[5])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCY_4__Control26;CustBalanceDueLCY[4])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCY_3__Control27;CustBalanceDueLCY[3])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCY_2__Control28;CustBalanceDueLCY[2])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCY_1__Control29;CustBalanceDueLCY[1])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCY_5__Control31;CustBalanceDueLCY[5])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCY_4__Control32;CustBalanceDueLCY[4])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCY_3__Control33;CustBalanceDueLCY[3])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCY_2__Control34;CustBalanceDueLCY[2])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCY_1__Control35;CustBalanceDueLCY[1])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCY_5__Control37;CustBalanceDueLCY[5])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCY_4__Control38;CustBalanceDueLCY[4])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCY_3__Control39;CustBalanceDueLCY[3])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCY_2__Control40;CustBalanceDueLCY[2])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCY_1__Control41;CustBalanceDueLCY[1])
            {
                AutoFormatType = 1;
            }
            column(Customer___Summary_Aging_Simp_Caption;Customer___Summary_Aging_Simp_CaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(All_amounts_are_in_LCYCaption;All_amounts_are_in_LCYCaptionLbl)
            {
            }
            column(Customer__No__Caption;FieldCaption("No."))
            {
            }
            column(Customer_NameCaption;FieldCaption(Name))
            {
            }
            column(CustBalanceDueLCY_5__Control25Caption;CustBalanceDueLCY_5__Control25CaptionLbl)
            {
            }
            column(CustBalanceDueLCY_4__Control26Caption;CustBalanceDueLCY_4__Control26CaptionLbl)
            {
            }
            column(CustBalanceDueLCY_3__Control27Caption;CustBalanceDueLCY_3__Control27CaptionLbl)
            {
            }
            column(CustBalanceDueLCY_2__Control28Caption;CustBalanceDueLCY_2__Control28CaptionLbl)
            {
            }
            column(CustBalanceDueLCY_1__Control29Caption;CustBalanceDueLCY_1__Control29CaptionLbl)
            {
            }
            column(CustBalanceDueLCY_5_Caption;CustBalanceDueLCY_5_CaptionLbl)
            {
            }
            column(CustBalanceDueLCY_5__Control31Caption;CustBalanceDueLCY_5__Control31CaptionLbl)
            {
            }
            column(TotalCaption;TotalCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                PrintCust := false;
                for i := 1 to 5 do begin
                  DtldCustLedgEntry.SetCurrentkey("Customer No.","Initial Entry Due Date","Posting Date");
                  DtldCustLedgEntry.SetRange("Customer No.","No.");
                  DtldCustLedgEntry.SetRange("Posting Date",0D,StartDate);
                  DtldCustLedgEntry.SetRange("Initial Entry Due Date",PeriodStartDate[i],PeriodStartDate[i + 1] - 1);
                  DtldCustLedgEntry.CalcSums("Amount (LCY)");
                  CustBalanceDueLCY[i] := DtldCustLedgEntry."Amount (LCY)";
                  if CustBalanceDueLCY[i] <> 0 then
                    PrintCust := true;
                end;
                if not PrintCust then
                  CurrReport.Skip;
            end;

            trigger OnPreDataItem()
            begin
                CurrReport.CreateTotals(CustBalanceDueLCY);
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
        CustFilter := Customer.GetFilters;
        PeriodStartDate[5] := StartDate;
        PeriodStartDate[6] := 99991231D;
        for i := 4 downto 2 do
          PeriodStartDate[i] := CalcDate('<-30D>',PeriodStartDate[i + 1]);
    end;

    var
        Text001: label 'As of %1';
        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        StartDate: Date;
        CustFilter: Text[250];
        PeriodStartDate: array [6] of Date;
        CustBalanceDueLCY: array [5] of Decimal;
        PrintCust: Boolean;
        i: Integer;
        Customer___Summary_Aging_Simp_CaptionLbl: label 'Customer - Summary Aging Simp.';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        All_amounts_are_in_LCYCaptionLbl: label 'All amounts are in LCY';
        CustBalanceDueLCY_5__Control25CaptionLbl: label 'Not Due';
        CustBalanceDueLCY_4__Control26CaptionLbl: label '0-30 days';
        CustBalanceDueLCY_3__Control27CaptionLbl: label '31-60 days';
        CustBalanceDueLCY_2__Control28CaptionLbl: label '61-90 days';
        CustBalanceDueLCY_1__Control29CaptionLbl: label 'Over 90 days';
        CustBalanceDueLCY_5_CaptionLbl: label 'Continued';
        CustBalanceDueLCY_5__Control31CaptionLbl: label 'Continued';
        TotalCaptionLbl: label 'Total';
}

