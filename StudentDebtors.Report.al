#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51575 "Student Debtors"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Student Debtors.rdlc';

    dataset
    {
        dataitem(Customer;Customer)
        {
            DataItemTableView = sorting("No.") where("Customer Type"=const(Student),Blocked=const(" "));
            RequestFilterFields = "No.","Date Filter","Balance (LCY)";
            column(ReportForNavId_6836; 6836)
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
            column(Customer__No__;"No.")
            {
            }
            column(Customer_Name;Name)
            {
            }
            column(Customer__Balance__LCY__;"Balance (LCY)")
            {
            }
            column(CourseR;CourseR)
            {
            }
            column(CourseReg_Semester;CourseReg.Semester)
            {
            }
            column(CourseReg_Programme;CourseReg.Programme)
            {
            }
            column(Customer__Credit_Amount__LCY__;"Credit Amount (LCY)")
            {
            }
            column(Credit_Amount__LCY___0_35;"Credit Amount (LCY)"*0.35)
            {
            }
            column(Customer__Balance__LCY___Control1102760018;"Balance (LCY)")
            {
            }
            column(Customer__Credit_Amount__LCY___Control1102755004;"Credit Amount (LCY)")
            {
            }
            column(Credit_Amount__LCY___0_35_Control1102755005;"Credit Amount (LCY)"*0.35)
            {
            }
            column(Student_DebtorsCaption;Student_DebtorsCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Customer__No__Caption;FieldCaption("No."))
            {
            }
            column(Customer_NameCaption;FieldCaption(Name))
            {
            }
            column(Customer__Balance__LCY__Caption;FieldCaption("Balance (LCY)"))
            {
            }
            column(CategoryCaption;CategoryCaptionLbl)
            {
            }
            column(SemesterCaption;SemesterCaptionLbl)
            {
            }
            column(ProgrammeCaption;ProgrammeCaptionLbl)
            {
            }
            column(Customer__Credit_Amount__LCY__Caption;FieldCaption("Credit Amount (LCY)"))
            {
            }
            column(V35_Caption;V35_CaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                CourseReg.Reset;
                CourseReg.SetRange(CourseReg."Student No.",Customer."No.");
                CourseReg.SetRange(CourseReg.Posted,true);
                if CourseReg.FindLast() then


                CourseR:=CourseReg."Settlement Type";
                if CourseReg."Settlement Type" = 'FULL PAYMENT' then
                CourseR:='JAB';
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
        CourseReg: Record UnknownRecord61532;
        CourseR: Code[20];
        Student_DebtorsCaptionLbl: label 'Student Debtors';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        CategoryCaptionLbl: label 'Category';
        SemesterCaptionLbl: label 'Semester';
        ProgrammeCaptionLbl: label 'Programme';
        V35_CaptionLbl: label '35%';
}

