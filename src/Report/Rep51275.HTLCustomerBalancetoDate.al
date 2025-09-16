#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51275 "HTL Customer - Balance to Date"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HTL Customer - Balance to Date.rdlc';
    Caption = 'Customer - Balance to Date';

    dataset
    {
        dataitem(Customer;Customer)
        {
            DataItemTableView = sorting("No.") where("Customer Posting Group"=const('KSM HOTEL'));
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.","Search Name",Blocked,"Date Filter";
            column(ReportForNavId_6836; 6836)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(STRSUBSTNO_Text000_FORMAT_Customer_GETRANGEMAX__Date_Filter____;StrSubstNo(Text000,Format(Customer.GetRangemax("Date Filter"))))
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
            column(Customer__No__;"No.")
            {
            }
            column(Customer_Name;Name)
            {
            }
            column(Customer__Phone_No__;"Phone No.")
            {
            }
            column(Customer___Balance_to_DateCaption;Customer___Balance_to_DateCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(All_amounts_are_in_LCY_Caption;All_amounts_are_in_LCY_CaptionLbl)
            {
            }
            column(CustLedgEntry3__Posting_Date_Caption;CustLedgEntry3.FieldCaption("Posting Date"))
            {
            }
            column(CustLedgEntry3__Document_Type_Caption;CustLedgEntry3.FieldCaption("Document Type"))
            {
            }
            column(CustLedgEntry3__Document_No__Caption;CustLedgEntry3.FieldCaption("Document No."))
            {
            }
            column(CustLedgEntry3_DescriptionCaption;CustLedgEntry3.FieldCaption(Description))
            {
            }
            column(OriginalAmtCaption;OriginalAmtCaptionLbl)
            {
            }
            column(CustLedgEntry3__Entry_No__Caption;CustLedgEntry3.FieldCaption("Entry No."))
            {
            }
            column(Customer__Phone_No__Caption;FieldCaption("Phone No."))
            {
            }
            dataitem(CustLedgEntry3;"Cust. Ledger Entry")
            {
                DataItemTableView = sorting("Entry No.");
                column(ReportForNavId_5082; 5082)
                {
                }
                column(CustLedgEntry3__Posting_Date_;"Posting Date")
                {
                }
                column(CustLedgEntry3__Document_Type_;"Document Type")
                {
                }
                column(CustLedgEntry3__Document_No__;"Document No.")
                {
                }
                column(CustLedgEntry3_Description;Description)
                {
                }
                column(OriginalAmt;OriginalAmt)
                {
                    AutoFormatExpression = CurrencyCode;
                    AutoFormatType = 1;
                }
                column(CustLedgEntry3__Entry_No__;"Entry No.")
                {
                }
                column(CurrencyCode;CurrencyCode)
                {
                }
                column(CustLedgEntry3_Date_Filter;"Date Filter")
                {
                }
                dataitem("Detailed Cust. Ledg. Entry";"Detailed Cust. Ledg. Entry")
                {
                    DataItemLink = "Cust. Ledger Entry No."=field("Entry No."),"Posting Date"=field("Date Filter");
                    DataItemTableView = sorting("Cust. Ledger Entry No.","Posting Date") where("Entry Type"=filter(<>"Initial Entry"));
                    column(ReportForNavId_6942; 6942)
                    {
                    }
                    column(Detailed_Cust__Ledg__Entry__Entry_Type_;"Entry Type")
                    {
                    }
                    column(Detailed_Cust__Ledg__Entry__Posting_Date_;"Posting Date")
                    {
                    }
                    column(Detailed_Cust__Ledg__Entry__Document_Type_;"Document Type")
                    {
                    }
                    column(Detailed_Cust__Ledg__Entry__Document_No__;"Document No.")
                    {
                    }
                    column(Amt;Amt)
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(CurrencyCode_Control56;CurrencyCode)
                    {
                    }
                    column(CurrencyCode_Control13;CurrencyCode)
                    {
                    }
                    column(RemainingAmt;RemainingAmt)
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(Detailed_Cust__Ledg__Entry_Entry_No_;"Entry No.")
                    {
                    }
                    column(Detailed_Cust__Ledg__Entry_Cust__Ledger_Entry_No_;"Cust. Ledger Entry No.")
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if not PrintUnappliedEntries  then
                          if Unapplied then
                            CurrReport.Skip;

                        if PrintAmountInLCY then begin
                          Amt := "Amount (LCY)";
                          CurrencyCode := '';
                        end else begin
                          Amt := Amount;
                          CurrencyCode := "Currency Code";
                        end;
                        if Amt = 0 then
                          CurrReport.Skip;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    if PrintAmountInLCY then begin
                      CalcFields("Original Amt. (LCY)","Remaining Amt. (LCY)");
                      OriginalAmt := "Original Amt. (LCY)";
                      RemainingAmt := "Remaining Amt. (LCY)";
                      CurrencyCode := '';
                    end else begin
                      CalcFields("Original Amount","Remaining Amount");
                      OriginalAmt := "Original Amount";
                      RemainingAmt := "Remaining Amount";
                      CurrencyCode := "Currency Code";
                    end;

                    CurrencyTotalBuffer.UpdateTotal(
                      CurrencyCode,
                      RemainingAmt,
                      0,
                      Counter1);
                end;

                trigger OnPreDataItem()
                begin
                    Reset;
                    DtldCustLedgEntry.SetCurrentkey("Customer No.","Posting Date","Entry Type");
                    DtldCustLedgEntry.SetRange("Customer No.",Customer."No.");
                    DtldCustLedgEntry.SetRange("Posting Date",CalcDate('<+1D>',MaxDate),99991231D);
                    DtldCustLedgEntry.SetRange("Entry Type",DtldCustLedgEntry."entry type"::Application);
                    if not PrintUnappliedEntries  then
                      DtldCustLedgEntry.SetRange(Unapplied,false);

                    if DtldCustLedgEntry.Find('-') then
                      repeat
                        "Entry No." := DtldCustLedgEntry."Cust. Ledger Entry No.";
                        Mark(true);
                      until DtldCustLedgEntry.Next = 0;

                    SetCurrentkey("Customer No.",Open);
                    SetRange("Customer No.",Customer."No.");
                    SetRange(Open,true);
                    SetRange("Posting Date",0D,MaxDate);

                    if Find('-') then
                      repeat
                        Mark(true);
                      until Next = 0;

                    SetCurrentkey("Entry No.");
                    SetRange(Open);
                    MarkedOnly(true);
                    SetRange("Date Filter",0D,MaxDate);
                end;
            }
            dataitem(Integer2;"Integer")
            {
                DataItemTableView = sorting(Number) where(Number=filter(1..));
                column(ReportForNavId_4152; 4152)
                {
                }
                column(Customer_Name_Control9;Customer.Name)
                {
                }
                column(CurrencyTotalBuffer__Total_Amount_;CurrencyTotalBuffer."Total Amount")
                {
                    AutoFormatExpression = CurrencyTotalBuffer."Currency Code";
                    AutoFormatType = 1;
                }
                column(CurrencyTotalBuffer__Currency_Code_;CurrencyTotalBuffer."Currency Code")
                {
                }
                column(Integer2_Number;Number)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if Number = 1 then
                      OK := CurrencyTotalBuffer.Find('-')
                    else
                      OK := CurrencyTotalBuffer.Next <> 0;
                    if not OK then
                      CurrReport.Break;

                    CurrencyTotalBuffer2.UpdateTotal(
                      CurrencyTotalBuffer."Currency Code",
                      CurrencyTotalBuffer."Total Amount",
                      0,
                      Counter1);
                end;

                trigger OnPostDataItem()
                begin
                    CurrencyTotalBuffer.DeleteAll;
                end;

                trigger OnPreDataItem()
                begin
                    CurrencyTotalBuffer.SetFilter("Total Amount",'<>0');
                end;
            }

            trigger OnAfterGetRecord()
            begin
                MaxDate := GetRangemax("Date Filter");
                SetRange("Date Filter",0D,MaxDate);
                CalcFields("Net Change (LCY)","Net Change");

                if ((PrintAmountInLCY and (Customer."Net Change (LCY)" = 0))  or
                   ((not PrintAmountInLCY) and (Customer."Net Change" = 0)))
                then
                  CurrReport.Skip;
            end;

            trigger OnPreDataItem()
            begin
                CurrReport.NewPagePerRecord := PrintOnePrPage;
            end;
        }
        dataitem(Integer3;"Integer")
        {
            DataItemTableView = sorting(Number) where(Number=filter(1..));
            column(ReportForNavId_7913; 7913)
            {
            }
            column(CurrencyTotalBuffer2__Currency_Code_;CurrencyTotalBuffer2."Currency Code")
            {
            }
            column(CurrencyTotalBuffer2__Total_Amount_;CurrencyTotalBuffer2."Total Amount")
            {
                AutoFormatExpression = CurrencyTotalBuffer2."Currency Code";
                AutoFormatType = 1;
            }
            column(TotalCaption;TotalCaptionLbl)
            {
            }
            column(Integer3_Number;Number)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if Number = 1 then
                  OK := CurrencyTotalBuffer2.Find('-')
                else
                  OK := CurrencyTotalBuffer2.Next <> 0;
                if not OK then
                  CurrReport.Break;
            end;

            trigger OnPostDataItem()
            begin
                CurrencyTotalBuffer2.DeleteAll;
            end;

            trigger OnPreDataItem()
            begin
                CurrencyTotalBuffer2.SetFilter("Total Amount",'<>0');
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
        CustDateFilter := Customer.GetFilter("Date Filter");
    end;

    var
        Text000: label 'Balance on %1';
        CurrencyTotalBuffer: Record "Currency Total Buffer" temporary;
        CurrencyTotalBuffer2: Record "Currency Total Buffer" temporary;
        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        PrintAmountInLCY: Boolean;
        PrintOnePrPage: Boolean;
        CustFilter: Text[250];
        CustDateFilter: Text[30];
        MaxDate: Date;
        OriginalAmt: Decimal;
        Amt: Decimal;
        RemainingAmt: Decimal;
        Counter1: Integer;
        OK: Boolean;
        CurrencyCode: Code[10];
        PrintUnappliedEntries: Boolean;
        Customer___Balance_to_DateCaptionLbl: label 'Customer - Balance to Date';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        All_amounts_are_in_LCY_CaptionLbl: label 'All amounts are in LCY.';
        OriginalAmtCaptionLbl: label 'Amount';
        TotalCaptionLbl: label 'Total';
}

