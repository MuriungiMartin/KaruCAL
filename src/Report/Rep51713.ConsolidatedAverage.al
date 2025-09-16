#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51713 "Consolidated Average"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Consolidated Average.rdlc';

    dataset
    {
        dataitem(UnknownTable61532;UnknownTable61532)
        {
            DataItemTableView = sorting("Student No.") order(ascending);
            RequestFilterFields = Programme,Stage,Semester,"Student No.","Cummulative Year Filter";
            column(ReportForNavId_2901; 2901)
            {
            }
            column(Course_Registration__Student_No__;"Student No.")
            {
            }
            column(Course_Registration_Stage;Stage)
            {
            }
            column(Course_Registration_Semester;Semester)
            {
            }
            column(unitcount;unitcount)
            {
            }
            column(totalmarks;totalmarks)
            {
            }
            column(avg;avg)
            {
            }
            column(Course_Registration__Student_No__Caption;FieldCaption("Student No."))
            {
            }
            column(Course_Registration_StageCaption;FieldCaption(Stage))
            {
            }
            column(Course_Registration_SemesterCaption;FieldCaption(Semester))
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

            trigger OnAfterGetRecord()
            begin

                if "ACA-Course Registration"."Student No."=regno then CurrReport.Skip;

                regno:="ACA-Course Registration"."Student No.";

                studunitrec.SetFilter(studunitrec."Student No.","ACA-Course Registration"."Student No.");

                unitcount:=studunitrec.Count;

                totalmarks:=0;
                avg:=0;

                if studunitrec.Find('-') then
                  repeat
                    studunitrec.CalcFields(studunitrec."Total Score");
                    totalmarks:=totalmarks+studunitrec."Total Score";
                  until studunitrec.Next=0;

                if unitcount>0 then avg:=ROUND((totalmarks/unitcount),1);
            end;

            trigger OnPreDataItem()
            begin

                studunitrec.SetFilter(studunitrec.Stage,"ACA-Course Registration".GetFilter("ACA-Course Registration".Stage));
                studunitrec.SetFilter(studunitrec.Semester,"ACA-Course Registration".GetFilter("ACA-Course Registration".Semester));

                regno:='';
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
        examrec: Record UnknownRecord61548;
        studunitrec: Record UnknownRecord61549;
        totalmarks: Decimal;
        unitcount: Integer;
        avg: Decimal;
        regno: Text[30];
}

