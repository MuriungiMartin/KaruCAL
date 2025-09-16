#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51206 Imprest
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Imprest.rdlc';

    dataset
    {
        dataitem(UnknownTable61134;UnknownTable61134)
        {
            DataItemTableView = sorting(No);
            RequestFilterFields = "Date Posted",Department,Cashier;
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
            column(Payments_Amount;Amount)
            {
            }
            column(Payments_No;No)
            {
            }
            column(Payments__Pay_Mode_;"Pay Mode")
            {
            }
            column(Payments_Cashier;Cashier)
            {
            }
            column(Payments__Account_No__;"Account No.")
            {
            }
            column(Payments__Account_Name_;"Account Name")
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
            column(Payments_Department;Department)
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
            column(Payments__Pay_Mode_Caption;FieldCaption("Pay Mode"))
            {
            }
            column(Payments_CashierCaption;FieldCaption(Cashier))
            {
            }
            column(Payments__Account_No__Caption;FieldCaption("Account No."))
            {
            }
            column(Payments__Account_Name_Caption;FieldCaption("Account Name"))
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
            column(Payments_DepartmentCaption;FieldCaption(Department))
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

    var
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        PaymentsCaptionLbl: label 'Payments';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Imprest_ReportCaptionLbl: label 'Imprest Report';
        Countinued_AmountCaptionLbl: label 'Countinued Amount';
        Countinued_AmountCaption_Control1000000010Lbl: label 'Countinued Amount';
        Total__AmountCaptionLbl: label 'Total  Amount';
}

