#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51087 "Course Registration Stat New"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Course Registration Stat New.rdlc';

    dataset
    {
        dataitem(UnknownTable61511;UnknownTable61511)
        {
            DataItemTableView = sorting(Faculty,Code) order(ascending);
            RequestFilterFields = Category,Faculty,"Code","Stage Filter","Semester Filter","No. Of Units Filter";
            column(ReportForNavId_1410; 1410)
            {
            }
            column(Programme_Programme_Code;"ACA-Programme".Code)
            {
            }
            dataitem(UnknownTable61532;UnknownTable61532)
            {
                DataItemLink = Programme=field(Code);
                DataItemTableView = sorting("Student No.") order(ascending);
                RequestFilterFields = Stage,Semester;
                column(ReportForNavId_2901; 2901)
                {
                }
                column(studcount;studcount)
                {
                }
                column(studcount2;studcount2)
                {
                }
                column(Programme_TotalCaption;Programme_TotalCaptionLbl)
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
                dataitem(UnknownTable61549;UnknownTable61549)
                {
                    DataItemLink = "Student No."=field("Student No.");
                    column(ReportForNavId_2992; 2992)
                    {
                    }
                    column(Course_Registration___Student_No__;"ACA-Course Registration"."Student No.")
                    {
                    }
                    column(txtcourses;txtcourses)
                    {
                    }
                    column(studcount2_Control1102760003;studcount2)
                    {
                    }
                    column(Student_Units_Programme;Programme)
                    {
                    }
                    column(Student_Units_Stage;Stage)
                    {
                    }
                    column(Student_Units_Unit;Unit)
                    {
                    }
                    column(Student_Units_Semester;Semester)
                    {
                    }
                    column(Student_Units_Reg__Transacton_ID;"Reg. Transacton ID")
                    {
                    }
                    column(Student_Units_Student_No_;"Student No.")
                    {
                    }
                    column(Student_Units_ENo;ENo)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        UnitCount:="ACA-Student Units".Count;
                        if UnitCount>0 then studcount2:=studcount2+1;
                        txtcourses:=txtcourses+"ACA-Student Units".Unit;
                    end;

                    trigger OnPreDataItem()
                    begin
                        "ACA-Student Units".SetFilter("ACA-Student Units".Stage,"ACA-Course Registration".GetFilter("ACA-Course Registration".Stage));
                        "ACA-Student Units".SetFilter("ACA-Student Units".Semester,"ACA-Course Registration".GetFilter("ACA-Course Registration".Semester));
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    txtcourses:='';
                    studcount:=studcount+1;
                end;

                trigger OnPreDataItem()
                begin
                    studcount:=0;
                    studcount2:=0;
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

    var
        txtcourses: Text[255];
        studcount: Integer;
        studcount2: Integer;
        Programme_TotalCaptionLbl: label 'Programme Total';
}

