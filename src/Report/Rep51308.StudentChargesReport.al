#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51308 "Student Charges Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Student Charges Report.rdlc';

    dataset
    {
        dataitem(UnknownTable61515;UnknownTable61515)
        {
            RequestFilterFields = "Code";
            column(ReportForNavId_9183; 9183)
            {
            }
            column(Charge_Code;Code)
            {
            }
            column(Charge_G_L_Account;"G/L Account")
            {
            }
            dataitem("Cust. Ledger Entry";"Cust. Ledger Entry")
            {
                DataItemLink = "Bal. Account No."=field("G/L Account");
                DataItemTableView = sorting("Customer No.","Posting Date");
                RequestFilterFields = "Posting Date";
                column(ReportForNavId_8503; 8503)
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
                column(Cust__Ledger_Entry__Posting_Date_;"Posting Date")
                {
                }
                column(Cust__Ledger_Entry__Cust__Ledger_Entry___Customer_No__;"Cust. Ledger Entry"."Customer No.")
                {
                }
                column(Cust__Ledger_Entry_Description;Description)
                {
                }
                column(Cust__Ledger_Entry_Amount;Amount)
                {
                }
                column(Cust__Ledger_Entry_Amount_Control1102756000;Amount)
                {
                }
                column(STUDENTS_CHARGESCaption;STUDENTS_CHARGESCaptionLbl)
                {
                }
                column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
                {
                }
                column(Cust__Ledger_Entry__Posting_Date_Caption;FieldCaption("Posting Date"))
                {
                }
                column(Cust__Ledger_Entry__Cust__Ledger_Entry___Customer_No__Caption;FieldCaption("Customer No."))
                {
                }
                column(Cust__Ledger_Entry_DescriptionCaption;FieldCaption(Description))
                {
                }
                column(Cust__Ledger_Entry_AmountCaption;FieldCaption(Amount))
                {
                }
                column(TotalCaption;TotalCaptionLbl)
                {
                }
                column(Cust__Ledger_Entry_Entry_No_;"Entry No.")
                {
                }
                column(Cust__Ledger_Entry_Bal__Account_No_;"Bal. Account No.")
                {
                }
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

    var
        STUDENTS_CHARGESCaptionLbl: label 'STUDENTS CHARGES';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        TotalCaptionLbl: label 'Total';
}

