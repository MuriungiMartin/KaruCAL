#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51305 "Vendor - Summary Aging Simp."
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Vendor - Summary Aging Simp..rdlc';
    Caption = 'Customer - Summary Aging Simp.';

    dataset
    {
        dataitem(Vendor;Vendor)
        {
            RequestFilterFields = "No.","Search Name","Vendor Posting Group","Payment Method Code";
            column(ReportForNavId_3182; 3182)
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
            column(Vendor_TABLECAPTION__________CustFilter;Vendor.TableCaption + ': ' + CustFilter)
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
            column(CustBalanceDueLCY_1___CustBalanceDueLCY_2__CustBalanceDueLCY_3__CustBalanceDueLCY_4__CustBalanceDueLCY_5_;CustBalanceDueLCY[1] +CustBalanceDueLCY[2]+CustBalanceDueLCY[3]+CustBalanceDueLCY[4]+CustBalanceDueLCY[5])
            {
                AutoFormatType = 1;
            }
            column(Vendor__No__;"No.")
            {
            }
            column(Vendor_Name;Name)
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
            column(DataItem1102760001;CustBalanceDueLCY[1] +CustBalanceDueLCY[2]+CustBalanceDueLCY[3]+CustBalanceDueLCY[4]+CustBalanceDueLCY[5])
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
            column(DataItem1102760002;CustBalanceDueLCY[1] +CustBalanceDueLCY[2]+CustBalanceDueLCY[3]+CustBalanceDueLCY[4]+CustBalanceDueLCY[5])
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
            column(DataItem1102760003;CustBalanceDueLCY[1] +CustBalanceDueLCY[2]+CustBalanceDueLCY[3]+CustBalanceDueLCY[4]+CustBalanceDueLCY[5])
            {
                AutoFormatType = 1;
            }
            column(Vendor___Summary_Aging_Simp_Caption;Vendor___Summary_Aging_Simp_CaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(All_amounts_are_in_LCYCaption;All_amounts_are_in_LCYCaptionLbl)
            {
            }
            column(Vendor__No__Caption;FieldCaption("No."))
            {
            }
            column(Vendor_NameCaption;FieldCaption(Name))
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
            column(TotalCaption;TotalCaptionLbl)
            {
            }
            column(CustBalanceDueLCY_5_Caption;CustBalanceDueLCY_5_CaptionLbl)
            {
            }
            column(CustBalanceDueLCY_5__Control31Caption;CustBalanceDueLCY_5__Control31CaptionLbl)
            {
            }
            column(TotalCaption_Control36;TotalCaption_Control36Lbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                PrintCust := false;

                vAmount:=0;//reset the amount

                for i := 1 to 5 do begin
                  DtldVendLedgEntry.SetCurrentkey("Vendor No.","Initial Entry Due Date","Posting Date");
                  DtldVendLedgEntry.SetRange(DtldVendLedgEntry."Vendor No.","No.");
                  DtldVendLedgEntry.SetRange("Posting Date",FinalDate,StartDate);
                  DtldVendLedgEntry.SetRange("Initial Entry Due Date",PeriodStartDate[i],PeriodStartDate[i + 1] - 1);
                  DtldVendLedgEntry.CalcSums("Amount (LCY)");
                  CustBalanceDueLCY[i] := DtldVendLedgEntry."Amount (LCY)";
                  if CustBalanceDueLCY[i] <> 0 then PrintCust := true;

                    //set the amounts
                    vAmount:=vAmount + CustBalanceDueLCY[i];

                end;
                if not PrintCust then
                  CurrReport.Skip;

                  //check if the amount is equal to zero
                  if vAmount=0 then
                    begin
                      CurrReport.Skip;
                    end;
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
        CustFilter := Vendor.GetFilters;
        PeriodStartDate[1]:=FinalDate;
        PeriodStartDate[5] := StartDate;
        PeriodStartDate[6] := 99991231D;
        for i := 4 downto 2
          do
            begin
              PeriodStartDate[i] := CalcDate('<-30D>',PeriodStartDate[i + 1]);
            end;
    end;

    var
        Text001: label 'As of %1';
        DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
        StartDate: Date;
        CustFilter: Text[250];
        PeriodStartDate: array [6] of Date;
        CustBalanceDueLCY: array [5] of Decimal;
        PrintCust: Boolean;
        i: Integer;
        vAmount: Decimal;
        FinalDate: Date;
        Vendor___Summary_Aging_Simp_CaptionLbl: label 'Vendor - Summary Aging Simp.';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        All_amounts_are_in_LCYCaptionLbl: label 'All amounts are in LCY';
        CustBalanceDueLCY_5__Control25CaptionLbl: label 'Not Due';
        CustBalanceDueLCY_4__Control26CaptionLbl: label '0-30 days';
        CustBalanceDueLCY_3__Control27CaptionLbl: label '31-60 days';
        CustBalanceDueLCY_2__Control28CaptionLbl: label '61-90 days';
        CustBalanceDueLCY_1__Control29CaptionLbl: label 'Over 90 days';
        TotalCaptionLbl: label 'Total';
        CustBalanceDueLCY_5_CaptionLbl: label 'Continued';
        CustBalanceDueLCY_5__Control31CaptionLbl: label 'Continued';
        TotalCaption_Control36Lbl: label 'Total';
}

