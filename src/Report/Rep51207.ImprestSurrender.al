#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51207 "Imprest Surrender"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Imprest Surrender.rdlc';

    dataset
    {
        dataitem(UnknownTable61504;UnknownTable61504)
        {
            DataItemTableView = sorting(No);
            column(ReportForNavId_3752; 3752)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(USERID;UserId)
            {
            }
            column(PIC;COMP.Picture)
            {
            }
            column(Payments_Amount;Amount)
            {
            }
            column(Payments_No;No)
            {
            }
            column(Payments__Date_Posted_;"Date Posted")
            {
            }
            column(Payments_Amount_Control1000000029;Amount)
            {
            }
            column(Payments__Paying_Bank_Account_;"Paying Bank Account")
            {
            }
            column(Payments_Payee;Payee)
            {
            }
            column(Payments_Department;"FIN-Imprest Surr. Header"."Global Dimension 2 Code")
            {
            }
            column(Payments__Surrender_Date_;"Surrender Date")
            {
            }
            column(Payments__Surrender_Doc__No_;"FIN-Imprest Surr. Header"."Imprest Issue Doc. No")
            {
            }
            column(Payments_Balance;Balance)
            {
            }
            column(Payments_Cashier;Cashier)
            {
            }
            column(Payments_Amount_Control1000000013;Amount)
            {
            }
            column(Payments_Amount_Control1000000016;Amount)
            {
            }
            column(PaymentsCaption;PaymentsCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Imprest_ReportCaption;Imprest_ReportCaptionLbl)
            {
            }
            column(Payments_NoCaption;FieldCaption(No))
            {
            }
            column(Payments__Date_Posted_Caption;FieldCaption("Date Posted"))
            {
            }
            column(Payments_Amount_Control1000000029Caption;FieldCaption(Amount))
            {
            }
            column(Payments__Paying_Bank_Account_Caption;FieldCaption("Paying Bank Account"))
            {
            }
            column(Payments_PayeeCaption;FieldCaption(Payee))
            {
            }
            column(Payments__Surrender_Date_Caption;FieldCaption("Surrender Date"))
            {
            }
            column(Payments_BalanceCaption;FieldCaption(Balance))
            {
            }
            column(Payments_CashierCaption;FieldCaption(Cashier))
            {
            }
            column(Countinued_AmountCaption;Countinued_AmountCaptionLbl)
            {
            }
            column(Countinued_AmountCaption_Control1000000010;Countinued_AmountCaption_Control1000000010Lbl)
            {
            }
            column(Total__AmountCaption;Total__AmountCaptionLbl)
            {
            }
            dataitem(UnknownTable61126;UnknownTable61126)
            {
                RequestFilterFields = "Account No:","Surrender Date","Surrender Type No","Type of Surrender","Due Date";
                column(ReportForNavId_3307; 3307)
                {
                }
                column(Imprest_Details__Account_No__;"Account No:")
                {
                }
                column(Imprest_Details__Account_Name_;"Account Name")
                {
                }
                column(Imprest_Details_Amount;Amount)
                {
                }
                column(Imprest_Details__Actual_Spent_;"Actual Spent")
                {
                }
                column(Imprest_Details__Apply_to_;"Apply to")
                {
                }
                column(Imprest_Details__Apply_to_ID_;"Apply to ID")
                {
                }
                column(Imprest_Details__Surrender_Date_;"Surrender Date")
                {
                }
                column(Imprest_Details__Surrender_Type_No_;"Surrender Type No")
                {
                }
                column(Imprest_Details__Cash_Surrender_Amt_;"Cash Surrender Amt")
                {
                }
                column(Imprest_Details__Date_Issued_;"Date Issued")
                {
                }
                column(Imprest_Details__Type_of_Surrender_;"Type of Surrender")
                {
                }
                column(Imprest_Details_Amount_Control1000000050;Amount)
                {
                }
                column(Imprest_Details__Actual_Spent__Control1000000058;"Actual Spent")
                {
                }
                column(Imprest_Details__Account_No__Caption;FieldCaption("Account No:"))
                {
                }
                column(Imprest_Details__Account_Name_Caption;FieldCaption("Account Name"))
                {
                }
                column(Imprest_Details_AmountCaption;FieldCaption(Amount))
                {
                }
                column(Imprest_Details__Actual_Spent_Caption;FieldCaption("Actual Spent"))
                {
                }
                column(Imprest_Details__Apply_to_Caption;FieldCaption("Apply to"))
                {
                }
                column(Imprest_Details__Apply_to_ID_Caption;FieldCaption("Apply to ID"))
                {
                }
                column(Imprest_Details__Surrender_Date_Caption;FieldCaption("Surrender Date"))
                {
                }
                column(Imprest_Details__Surrender_Type_No_Caption;FieldCaption("Surrender Type No"))
                {
                }
                column(Imprest_Details__Cash_Surrender_Amt_Caption;FieldCaption("Cash Surrender Amt"))
                {
                }
                column(Imprest_Details__Date_Issued_Caption;FieldCaption("Date Issued"))
                {
                }
                column(Imprest_Details__Type_of_Surrender_Caption;FieldCaption("Type of Surrender"))
                {
                }
                column(Imprest_Details_Amount_Control1000000050Caption;FieldCaption(Amount))
                {
                }
                column(Imprest_Details__Actual_Spent__Control1000000058Caption;FieldCaption("Actual Spent"))
                {
                }
                column(Imprest_Details_No;No)
                {
                }
                column(Imprest_Details_Line_No;"Line No")
                {
                }
            }

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo(No);
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

    trigger OnInitReport()
    begin
        if COMP.Get() then begin
            COMP.CalcFields(Picture);
          end;
    end;

    var
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        PaymentsCaptionLbl: label 'Payments';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Imprest_ReportCaptionLbl: label 'Imprest Report';
        Countinued_AmountCaptionLbl: label 'Countinued Amount';
        Countinued_AmountCaption_Control1000000010Lbl: label 'Countinued Amount';
        Total__AmountCaptionLbl: label 'Total  Amount';
        COMP: Record "Company Information";
}

