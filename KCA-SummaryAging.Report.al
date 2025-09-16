#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51536 "KCA - Summary Aging"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/KCA - Summary Aging.rdlc';
    Caption = 'Customer - Summary Aging';

    dataset
    {
        dataitem(UnknownTable61532;UnknownTable61532)
        {
            RequestFilterFields = Programme,Stage,Semester;
            column(ReportForNavId_2901; 2901)
            {
            }
            column(Customer_TABLECAPTION__________CustFilter;Customer.TableCaption + ': ' + CustFilter)
            {
            }
            column(EmptyString;'')
            {
            }
            column(PeriodStartDate_5____1;PeriodStartDate[5] - 1)
            {
            }
            column(PeriodStartDate_4_;PeriodStartDate[4])
            {
            }
            column(USERID;UserId)
            {
            }
            column(PeriodStartDate_4____1;PeriodStartDate[4] - 1)
            {
            }
            column(PeriodStartDate_3_;PeriodStartDate[3])
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(PeriodStartDate_2_;PeriodStartDate[2])
            {
            }
            column(PeriodStartDate_3____1;PeriodStartDate[3] - 1)
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
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
            column(TotalCustBalanceLCY;TotalCustBalanceLCY)
            {
                AutoFormatType = 1;
            }
            column(LineTotalCustBalanceCaption;LineTotalCustBalanceCaptionLbl)
            {
            }
            column(CustBalanceDue_5_Caption;CustBalanceDue_5_CaptionLbl)
            {
            }
            column(Balance_DueCaption;Balance_DueCaptionLbl)
            {
            }
            column(CustBalanceDue_1_Caption;CustBalanceDue_1_CaptionLbl)
            {
            }
            column(Customer___Summary_AgingCaption;Customer___Summary_AgingCaptionLbl)
            {
            }
            column(All_amounts_are_in_LCYCaption;All_amounts_are_in_LCYCaptionLbl)
            {
            }
            column(Customer_NameCaption;Customer.FieldCaption(Name))
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Customer__No__Caption;Customer.FieldCaption("No."))
            {
            }
            column(Total__LCY_Caption;Total__LCY_CaptionLbl)
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
                DataItemTableView = sorting("No.");
                RequestFilterFields = "No.","Search Name","Customer Posting Group","Currency Filter";
                column(ReportForNavId_6836; 6836)
                {
                }
                column(CustBalanceDueLCY_1__Control23;CustBalanceDueLCY[1])
                {
                    AutoFormatType = 1;
                }
                column(CustBalanceDueLCY_2__Control24;CustBalanceDueLCY[2])
                {
                    AutoFormatType = 1;
                }
                column(CustBalanceDueLCY_3__Control25;CustBalanceDueLCY[3])
                {
                    AutoFormatType = 1;
                }
                column(CustBalanceDueLCY_4__Control26;CustBalanceDueLCY[4])
                {
                    AutoFormatType = 1;
                }
                column(CustBalanceDueLCY_5__Control27;CustBalanceDueLCY[5])
                {
                    AutoFormatType = 1;
                }
                column(TotalCustBalanceLCY_Control28;TotalCustBalanceLCY)
                {
                    AutoFormatType = 1;
                }
                column(LineTotalCustBalance;LineTotalCustBalance)
                {
                    AutoFormatType = 1;
                }
                column(CustBalanceDue_5_;CustBalanceDue[5])
                {
                    AutoFormatType = 1;
                }
                column(CustBalanceDue_4_;CustBalanceDue[4])
                {
                    AutoFormatType = 1;
                }
                column(CustBalanceDue_3_;CustBalanceDue[3])
                {
                    AutoFormatType = 1;
                }
                column(CustBalanceDue_2_;CustBalanceDue[2])
                {
                    AutoFormatType = 1;
                }
                column(CustBalanceDue_1_;CustBalanceDue[1])
                {
                    AutoFormatType = 1;
                }
                column(Customer_Name;Name)
                {
                }
                column(Customer__No__;"No.")
                {
                }
                column(CustBalanceDueLCY_1__Control39;CustBalanceDueLCY[1])
                {
                    AutoFormatType = 1;
                }
                column(CustBalanceDueLCY_2__Control40;CustBalanceDueLCY[2])
                {
                    AutoFormatType = 1;
                }
                column(CustBalanceDueLCY_3__Control41;CustBalanceDueLCY[3])
                {
                    AutoFormatType = 1;
                }
                column(CustBalanceDueLCY_4__Control42;CustBalanceDueLCY[4])
                {
                    AutoFormatType = 1;
                }
                column(CustBalanceDueLCY_5__Control43;CustBalanceDueLCY[5])
                {
                    AutoFormatType = 1;
                }
                column(TotalCustBalanceLCY_Control44;TotalCustBalanceLCY)
                {
                    AutoFormatType = 1;
                }
                column(CustBalanceDueLCY_1__Control23Caption;CustBalanceDueLCY_1__Control23CaptionLbl)
                {
                }
                column(CustBalanceDueLCY_1__Control39Caption;CustBalanceDueLCY_1__Control39CaptionLbl)
                {
                }
                dataitem("Integer";"Integer")
                {
                    DataItemTableView = sorting(Number) where(Number=filter(1..));
                    column(ReportForNavId_5444; 5444)
                    {
                    }
                    column(LineTotalCustBalance_Control67;LineTotalCustBalance)
                    {
                        AutoFormatExpression = Currency2.Code;
                        AutoFormatType = 1;
                    }
                    column(CustBalanceDue_5__Control68;CustBalanceDue[5])
                    {
                        AutoFormatExpression = Currency2.Code;
                        AutoFormatType = 1;
                    }
                    column(CustBalanceDue_4__Control69;CustBalanceDue[4])
                    {
                        AutoFormatExpression = Currency2.Code;
                        AutoFormatType = 1;
                    }
                    column(CustBalanceDue_3__Control70;CustBalanceDue[3])
                    {
                        AutoFormatExpression = Currency2.Code;
                        AutoFormatType = 1;
                    }
                    column(CustBalanceDue_2__Control71;CustBalanceDue[2])
                    {
                        AutoFormatExpression = Currency2.Code;
                        AutoFormatType = 1;
                    }
                    column(CustBalanceDue_1__Control72;CustBalanceDue[1])
                    {
                        AutoFormatExpression = Currency2.Code;
                        AutoFormatType = 1;
                    }
                    column(Currency2_Code;Currency2.Code)
                    {
                    }
                    column(Customer_Name_Control74;Customer.Name)
                    {
                    }
                    column(Customer__No___Control75;Customer."No.")
                    {
                    }
                    column(Integer_Number;Number)
                    {
                    }

                    trigger OnAfterGetRecord()
                    var
                        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
                    begin
                        if Number = 1 then
                          Currency2.Find('-')
                        else
                          if Currency2.Next = 0 then
                            CurrReport.Break;
                        Currency2.CalcFields("Cust. Ledg. Entries in Filter");
                        if not Currency2."Cust. Ledg. Entries in Filter" then
                          CurrReport.Skip;

                        PrintLine := false;
                        LineTotalCustBalance := 0;
                        for i := 1 to 5 do begin
                          DtldCustLedgEntry.SetCurrentkey("Customer No.","Initial Entry Due Date");
                          DtldCustLedgEntry.SetRange("Customer No.",Customer."No.");
                          DtldCustLedgEntry.SetRange("Initial Entry Due Date",PeriodStartDate[i],PeriodStartDate[i + 1] - 1);
                          DtldCustLedgEntry.SetRange("Currency Code",Currency2.Code);
                          DtldCustLedgEntry.CalcSums(Amount);
                          CustBalanceDue[i] := DtldCustLedgEntry.Amount;
                          if CustBalanceDue[i] <> 0 then
                            PrintLine := true;
                          LineTotalCustBalance := LineTotalCustBalance + CustBalanceDue[i];
                        end;
                    end;

                    trigger OnPreDataItem()
                    begin
                        if PrintAmountsInLCY or not PrintLine then
                          CurrReport.Break;
                        Currency2.Reset;
                        Currency2.SetRange("Customer Filter",Customer."No.");
                        Customer.Copyfilter("Currency Filter",Currency2.Code);
                        if (Customer.GetFilter("Global Dimension 1 Filter") <> '') or
                           (Customer.GetFilter("Global Dimension 2 Filter") <> '')
                        then begin
                          Customer.Copyfilter("Global Dimension 1 Filter",Currency2."Global Dimension 1 Filter");
                          Customer.Copyfilter("Global Dimension 2 Filter",Currency2."Global Dimension 2 Filter");
                        end;
                    end;
                }

                trigger OnAfterGetRecord()
                var
                    DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
                begin
                    PrintLine := false;
                    LineTotalCustBalance := 0;
                    for i := 1 to 5 do begin
                      DtldCustLedgEntry.SetCurrentkey("Customer No.","Initial Entry Due Date");
                      DtldCustLedgEntry.SetRange("Customer No.","No.");
                      DtldCustLedgEntry.SetRange("Initial Entry Due Date",PeriodStartDate[i],PeriodStartDate[i + 1] - 1);
                      DtldCustLedgEntry.CalcSums("Amount (LCY)");
                      CustBalanceDue[i] := CustBalanceDueLCY[i] + DtldCustLedgEntry."Amount (LCY)";
                      CustBalanceDueLCY[i] :=CustBalanceDueLCY[i] + DtldCustLedgEntry."Amount (LCY)";
                      if CustBalanceDue[i] <> 0 then
                        PrintLine := true;
                      LineTotalCustBalance := LineTotalCustBalance + CustBalanceDueLCY[i];
                      TotalCustBalanceLCY := TotalCustBalanceLCY + CustBalanceDueLCY[i];
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    CurrReport.CreateTotals(CustBalanceDue,CustBalanceDueLCY,TotalCustBalanceLCY);
                    Currency2.Reset;
                    Currency2.SetRange(Currency2.Code,'');
                    if Currency2.Find('-') = false then begin
                    Currency2.Code := '';
                    Currency2.Insert;
                    end;

                    if Currency.Find('-') then
                      repeat
                        Currency2.Reset;
                        Currency2.SetRange(Currency2.Code,Currency.Code);
                        if Currency2.Find('-') = false then begin

                        Currency2 := Currency;
                        Currency2.Insert;
                        end;
                      until Currency.Next = 0;
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
        for i := 3 to 5 do
          PeriodStartDate[i] := CalcDate(PeriodLength,PeriodStartDate[i - 1]);
        PeriodStartDate[6] := 99991231D;
    end;

    var
        Currency: Record Currency;
        Currency2: Record Currency temporary;
        CustFilter: Text[250];
        PrintAmountsInLCY: Boolean;
        PeriodLength: DateFormula;
        PeriodStartDate: array [6] of Date;
        CustBalanceDue: array [5] of Decimal;
        CustBalanceDueLCY: array [5] of Decimal;
        LineTotalCustBalance: Decimal;
        TotalCustBalanceLCY: Decimal;
        PrintLine: Boolean;
        i: Integer;
        LineTotalCustBalanceCaptionLbl: label 'Balance';
        CustBalanceDue_5_CaptionLbl: label 'after...';
        Balance_DueCaptionLbl: label 'Balance Due';
        CustBalanceDue_1_CaptionLbl: label '...before';
        Customer___Summary_AgingCaptionLbl: label 'Customer - Summary Aging';
        All_amounts_are_in_LCYCaptionLbl: label 'All amounts are in LCY';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Total__LCY_CaptionLbl: label 'Total (LCY)';
        CustBalanceDueLCY_1__Control23CaptionLbl: label 'Continued (LCY)';
        CustBalanceDueLCY_1__Control39CaptionLbl: label 'Continued (LCY)';
}

