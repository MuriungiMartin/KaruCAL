#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51535 "KCA - Summary Aging Simp."
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/KCA - Summary Aging Simp..rdlc';
    Caption = 'Customer - Summary Aging Simp.';

    dataset
    {
        dataitem(UnknownTable61532;UnknownTable61532)
        {
            RequestFilterFields = Programme,Stage,Semester,"Student Type";
            column(ReportForNavId_2901; 2901)
            {
            }
            column(USERID;UserId)
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(STRSUBSTNO_Text001_FORMAT_StartDate__;StrSubstNo(Text001,Format(StartDate)))
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(Customer_TABLECAPTION__________CustFilter;Customer.TableCaption + ': ' + CustFilter)
            {
            }
            column(CustBalanceDueLCY_1_;CustBalanceDueLCY[1])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCY_2_;CustBalanceDueLCY[2])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCY_3_;CustBalanceDueLCY[3])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCY_4_;CustBalanceDueLCY[4])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCY_5_;CustBalanceDueLCY[5])
            {
                AutoFormatType = 1;
            }
            column(All_amounts_are_in_LCYCaption;All_amounts_are_in_LCYCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Customer___Summary_Aging_Simp_Caption;Customer___Summary_Aging_Simp_CaptionLbl)
            {
            }
            column(CustBalanceDueLCY_1__Control29Caption;CustBalanceDueLCY_1__Control29CaptionLbl)
            {
            }
            column(CustBalanceDueLCY_2__Control28Caption;CustBalanceDueLCY_2__Control28CaptionLbl)
            {
            }
            column(CustBalanceDueLCY_3__Control27Caption;CustBalanceDueLCY_3__Control27CaptionLbl)
            {
            }
            column(CustBalanceDueLCY_4__Control26Caption;CustBalanceDueLCY_4__Control26CaptionLbl)
            {
            }
            column(CustBalanceDueLCY_5__Control25Caption;CustBalanceDueLCY_5__Control25CaptionLbl)
            {
            }
            column(Customer_NameCaption;Customer.FieldCaption(Name))
            {
            }
            column(Customer__No__Caption;Customer.FieldCaption("No."))
            {
            }
            column(TotalCaption;TotalCaptionLbl)
            {
            }
            column(Course_Registration_Reg__Transacton_ID;"Reg. Transacton ID")
            {
            }
            column(Course_Registration_Student_No_;"Student No.")
            {
            }
            column(Course_Registration_Programme;Programme)
            {
            }
            column(Course_Registration_Semester;Semester)
            {
            }
            column(Course_Registration_Register_for;"Register for")
            {
            }
            column(Course_Registration_Stage;Stage)
            {
            }
            column(Course_Registration_Unit;Unit)
            {
            }
            column(Course_Registration_Student_Type;"Student Type")
            {
            }
            column(Course_Registration_Entry_No_;"Entry No.")
            {
            }
            dataitem(Customer;Customer)
            {
                DataItemLink = "No."=field("Student No.");
                RequestFilterFields = "No.","Search Name","Customer Posting Group","Statistics Group","Payment Terms Code";
                column(ReportForNavId_6836; 6836)
                {
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

                trigger OnAfterGetRecord()
                begin
                    PrintCust := false;
                    for i := 1 to 5 do begin
                      DtldCustLedgEntry.SetCurrentkey("Customer No.","Initial Entry Due Date","Posting Date");
                      DtldCustLedgEntry.SetRange("Customer No.","No.");
                      DtldCustLedgEntry.SetRange("Posting Date",0D,StartDate);
                      DtldCustLedgEntry.SetRange("Initial Entry Due Date",PeriodStartDate[i],PeriodStartDate[i + 1] - 1);
                      DtldCustLedgEntry.CalcSums("Amount (LCY)");
                      CustBalanceDueLCY[i] := CustBalanceDueLCY[i] + DtldCustLedgEntry."Amount (LCY)";
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
        All_amounts_are_in_LCYCaptionLbl: label 'All amounts are in LCY';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Customer___Summary_Aging_Simp_CaptionLbl: label 'Customer - Summary Aging Simp.';
        CustBalanceDueLCY_1__Control29CaptionLbl: label 'Over 90 days';
        CustBalanceDueLCY_2__Control28CaptionLbl: label '61-90 days';
        CustBalanceDueLCY_3__Control27CaptionLbl: label '31-60 days';
        CustBalanceDueLCY_4__Control26CaptionLbl: label '0-30 days';
        CustBalanceDueLCY_5__Control25CaptionLbl: label 'Not Due';
        TotalCaptionLbl: label 'Total';
}

