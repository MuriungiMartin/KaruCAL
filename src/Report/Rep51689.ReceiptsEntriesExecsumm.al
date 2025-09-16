#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51689 "Receipts Entries-Exec. summ"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Receipts Entries-Exec. summ.rdlc';

    dataset
    {
        dataitem(UnknownTable61538;UnknownTable61538)
        {
            DataItemTableView = sorting("Payment Mode") order(ascending);
            RequestFilterFields = "Bank Account",Date,"Payment Mode","User ID";
            column(ReportForNavId_5672; 5672)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(USERID;UserId)
            {
            }
            column(Receipt__Student_No__;"Student No.")
            {
            }
            column(Receipt__Receipt_No__;"Receipt No.")
            {
            }
            column(Receipt_Date;Date)
            {
            }
            column(Receipt_Amount;Amount)
            {
            }
            column(SName;SName)
            {
            }
            column(Course;Course)
            {
            }
            column(Receipt__Payment_Mode_;"Payment Mode")
            {
            }
            column(Receipt_Amount_Control1000000039;Amount)
            {
            }
            column(Receipt_Amount_Control1000000007;Amount)
            {
            }
            column(Receipt_Receipt_Date;"ACA-Receipt".Date)
            {
            }
            column(Income_Analysis_Cash_RegisterCaption;Income_Analysis_Cash_RegisterCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Receipt__Receipt_No__Caption;FieldCaption("Receipt No."))
            {
            }
            column(Receipt__Student_No__Caption;FieldCaption("Student No."))
            {
            }
            column(NameCaption;NameCaptionLbl)
            {
            }
            column(Receipt_DateCaption;FieldCaption(Date))
            {
            }
            column(Receipt_AmountCaption;FieldCaption(Amount))
            {
            }
            column(KARATINA_UNIVERSITYSCaption;KARATINA_UNIVERSITYSCaptionLbl)
            {
            }
            column(CourseCaption;CourseCaptionLbl)
            {
            }
            column(Receipt__Payment_Mode_Caption;FieldCaption("Payment Mode"))
            {
            }
            column(DAILY_RECEIPTS_EXECUTIVE_SUMMARYCaption;DAILY_RECEIPTS_EXECUTIVE_SUMMARYCaptionLbl)
            {
            }
            column(Group_TotalsCaption;Group_TotalsCaptionLbl)
            {
            }
            column(Grand_Totals_ForCaption;Grand_Totals_ForCaptionLbl)
            {
            }
            column(BankSlipChequeNo_Receipt;"ACA-Receipt"."Bank Slip/Cheque No")
            {
            }

            trigger OnAfterGetRecord()
            begin
                if Cust.Get("ACA-Receipt"."Student No.") then
                SName:=Cust.Name
                else
                SName:='';
                StudNo:=StudNo+1;
                CourseReg.Reset;
                CourseReg.SetRange(CourseReg."Student No.","Student No.");
                if CourseReg.Find('-') then begin
                Course:=CourseReg.Programme;
                end;
            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("User ID");
                 StudNo:=0;
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
        Cust: Record Customer;
        SName: Text[200];
        StudNo: Integer;
        Course: Code[20];
        CourseReg: Record UnknownRecord61532;
        Income_Analysis_Cash_RegisterCaptionLbl: label 'Income Analysis-Cash Register';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        NameCaptionLbl: label 'Name';
        KARATINA_UNIVERSITYSCaptionLbl: label 'KARATINA UNIVERSITY';
        CourseCaptionLbl: label 'Course';
        DAILY_RECEIPTS_EXECUTIVE_SUMMARYCaptionLbl: label 'DAILY RECEIPTS EXECUTIVE SUMMARY';
        Group_TotalsCaptionLbl: label 'Group Totals';
        Grand_Totals_ForCaptionLbl: label 'Grand Totals For';
}

