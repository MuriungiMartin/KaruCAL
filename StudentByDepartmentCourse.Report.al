#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51259 "Student By Department/Course"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Student By DepartmentCourse.rdlc';

    dataset
    {
        dataitem(UnknownTable61511;UnknownTable61511)
        {
            DataItemTableView = sorting(Code) order(ascending);
            PrintOnlyIfDetail = true;
            column(ReportForNavId_1410; 1410)
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
            column(Programme_Description;Description)
            {
            }
            column(Class_ListCaption;Class_ListCaptionLbl)
            {
            }
            column(KARATINA_UNIVERSITYCaption;KARATINA_UNIVERSITYCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Student_NameCaption;Student_NameCaptionLbl)
            {
            }
            column(Registration_No_Caption;Registration_No_CaptionLbl)
            {
            }
            column(No_Caption;No_CaptionLbl)
            {
            }
            column(YearCaption;YearCaptionLbl)
            {
            }
            column(Programme_Code;Code)
            {
            }
            column(Programme_Stage_Filter;"Stage Filter")
            {
            }
            dataitem(UnknownTable61532;UnknownTable61532)
            {
                DataItemLink = Programme=field(Code),Stage=field("Stage Filter");
                DataItemTableView = sorting(Stage) order(ascending);
                PrintOnlyIfDetail = true;
                RequestFilterFields = Programme,Semester,Stage,"Student No.";
                column(ReportForNavId_2901; 2901)
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
                dataitem(Student;Customer)
                {
                    DataItemLink = "No."=field("Student No.");
                    DataItemTableView = where(Status=filter(Registration|Current));
                    PrintOnlyIfDetail = false;
                    RequestFilterFields = "No.",Status,"Balance (LCY)";
                    column(ReportForNavId_3468; 3468)
                    {
                    }
                    column(Student_Name;Name)
                    {
                    }
                    column(Student__No__;"No.")
                    {
                    }
                    column(No;No)
                    {
                    }
                    column(Course_Registration__Stage;"ACA-Course Registration".Stage)
                    {
                    }

                    trigger OnPreDataItem()
                    begin
                        //Student.SETFILTER(Student.Status,Programme.GETFILTER(Programme."Status Filter"));
                    end;
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
        No: Integer;
        "Total Count": Integer;
        Class_ListCaptionLbl: label 'Class List';
        KARATINA_UNIVERSITYCaptionLbl: label 'KARATINA UNIVERSITY';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Student_NameCaptionLbl: label 'Student Name';
        Registration_No_CaptionLbl: label 'Registration No.';
        No_CaptionLbl: label 'No.';
        YearCaptionLbl: label 'Year';
}

