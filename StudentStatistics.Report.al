#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51497 "Student Statistics"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Student Statistics.rdlc';

    dataset
    {
        dataitem(UnknownTable61511;UnknownTable61511)
        {
            RequestFilterFields = "Code";
            column(ReportForNavId_1410; 1410)
            {
            }
            column(Programme_Code;Code)
            {
            }
            dataitem(UnknownTable61532;UnknownTable61532)
            {
                DataItemLink = Programme=field(Code);
                DataItemTableView = sorting("Student No.") order(ascending);
                RequestFilterFields = Semester;
                column(ReportForNavId_2901; 2901)
                {
                }
                column(Course_Registration_Programme;Programme)
                {
                }
                column(Course_Registration_Reg__Transacton_ID;"Reg. Transacton ID")
                {
                }
                column(Course_Registration_Student_No_;"Student No.")
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
                    DataItemTableView = sorting("No.") order(ascending);
                    RequestFilterFields = "Balance (LCY)";
                    column(ReportForNavId_6836; 6836)
                    {
                    }
                    column(Customer__No__;"No.")
                    {
                    }
                    column(Serial;Serial)
                    {
                    }
                    column(EmptyStringCaption;EmptyStringCaptionLbl)
                    {
                    }
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
        fltProgramme: Text[30];
        fltCourseReg: Text[30];
        fltCustomer: Text[30];
        recProgramme: Record UnknownRecord61511;
        recCourseReg: Record UnknownRecord61532;
        recCustomer: Record Customer;
        Serial: Integer;
        EmptyStringCaptionLbl: label '.';
}

