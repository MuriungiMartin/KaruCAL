#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51679 "Student Lists"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Student Lists.rdlc';

    dataset
    {
        dataitem(Customer;Customer)
        {
            DataItemTableView = sorting("Lib Membership","No.") where("Customer Type"=const(Student));
            RequestFilterFields = "No.","Date Registered",Status,Gender;
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
            column(Hesabu;Hesabu)
            {
            }
            column(Course;Course)
            {
            }
            column(AmountPaid;AmountPaid)
            {
            }
            column(Customer__Balance__LCY__;"Balance (LCY)")
            {
            }
            column(Student_ListCaption;Student_ListCaptionLbl)
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
            column(CourseCaption;CourseCaptionLbl)
            {
            }
            column(Amount_PaidCaption;Amount_PaidCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Course:='';
                AmountPaid:=0;
                courseReg.Reset;
                courseReg.SetCurrentkey(courseReg."Student No.");
                courseReg.SetRange(courseReg."Student No.","No.");
                if courseReg.Find('+') then
                Course:=courseReg.Programme;
                Receipt.Reset;
                Receipt.SetCurrentkey(Receipt."Student No.");
                Receipt.SetRange(Receipt."Student No.",Customer."No.");
                if Receipt.Find('-') then begin
                repeat
                AmountPaid:=AmountPaid+Receipt.Amount;
                until Receipt.Next=0;
                end;
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
        Hesabu: Integer;
        Programme: Record UnknownRecord61511;
        courseReg: Record UnknownRecord61532;
        Course: Code[20];
        Receipt: Record UnknownRecord61538;
        AmountPaid: Decimal;
        Student_ListCaptionLbl: label 'Student List';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        CourseCaptionLbl: label 'Course';
        Amount_PaidCaptionLbl: label 'Amount Paid';
}

