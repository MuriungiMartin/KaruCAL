#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51716 "Double Registration"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Double Registration.rdlc';

    dataset
    {
        dataitem(UnknownTable61532;UnknownTable61532)
        {
            RequestFilterFields = Semester,"Programme Exam Category";
            column(ReportForNavId_2901; 2901)
            {
            }
            column(Course_Registration__Student_No__;"Student No.")
            {
            }
            column(Course_Registration_Semester;Semester)
            {
            }
            column(Course_Registration_Stage;Stage)
            {
            }
            column(regs;regs)
            {
            }
            column(i;i)
            {
            }
            column(Course_Registration__Student_No__Caption;FieldCaption("Student No."))
            {
            }
            column(Course_Registration_SemesterCaption;FieldCaption(Semester))
            {
            }
            column(Course_Registration_StageCaption;FieldCaption(Stage))
            {
            }
            column(RegsCaption;RegsCaptionLbl)
            {
            }
            column(Course_Registration_Reg__Transacton_ID;"Reg. Transacton ID")
            {
            }
            column(Course_Registration_Programme;Programme)
            {
            }
            column(Course_Registration_Register_for;"Register for")
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
            dataitem("<Course Registration2>";UnknownTable61532)
            {
                DataItemLink = "Student No."=field("Student No.");
                column(ReportForNavId_6046; 6046)
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                regs:=0;
                "<Course Registration2>".Reset;
                "<Course Registration2>".SetRange("<Course Registration2>"."Student No.","ACA-Course Registration"."Student No.");
                //"<Course Registration2>".SETRANGE("<Course Registration2>".Semester,"Course Registration".GETFILTER(
                //"Course Registration".Semester));
                "<Course Registration2>".SetRange("<Course Registration2>".Semester,'SEM 2 09/10');
                regs:="<Course Registration2>".Count;
                if regs>=1 then CurrReport.Skip else
                i:=i+1;
            end;

            trigger OnPreDataItem()
            begin
                i:=0
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
        regs: Integer;
        i: Integer;
        RegsCaptionLbl: label 'Regs';
}

