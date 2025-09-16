#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51344 "Resit Registration by Course"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Resit Registration by Course.rdlc';

    dataset
    {
        dataitem(UnknownTable61549;UnknownTable61549)
        {
            DataItemTableView = where("Repeat Unit"=const(Yes));
            RequestFilterFields = "Student No.",Programme,Stage,Semester;
            column(ReportForNavId_2992; 2992)
            {
            }
            column(Student_Units_Unit;Unit)
            {
            }
            column(txtUnitDesc;txtUnitDesc)
            {
            }
            column(Student_Units__Student_No__;"Student No.")
            {
            }
            column(Resit_Registration_by_CourseCaption;Resit_Registration_by_CourseCaptionLbl)
            {
            }
            column(Student_Units_Programme;Programme)
            {
            }
            column(Student_Units_Stage;Stage)
            {
            }
            column(Student_Units_Semester;Semester)
            {
            }
            column(Student_Units_Reg__Transacton_ID;"Reg. Transacton ID")
            {
            }
            column(Student_Units_ENo;ENo)
            {
            }

            trigger OnAfterGetRecord()
            begin
                recUnitSubj.SetFilter(recUnitSubj.Code,"ACA-Student Units".Unit);

                if recUnitSubj.Find('-') then
                txtUnitDesc:=recUnitSubj.Desription;
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
        txtUnitDesc: Text[250];
        recUnitSubj: Record UnknownRecord61517;
        Resit_Registration_by_CourseCaptionLbl: label 'Resit Registration by Course';
}

