#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51771 "Check Marks"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Check Marks.rdlc';

    dataset
    {
        dataitem(UnknownTable61549;UnknownTable61549)
        {
            RequestFilterFields = Programme,Stage,Semester,Unit,"Student No.";
            column(ReportForNavId_1; 1)
            {
            }
            column(No;"ACA-Student Units"."Student No.")
            {
            }
            column(Prog;"ACA-Student Units".Programme)
            {
            }
            column(Stage;"ACA-Student Units".Stage)
            {
            }
            column(Unit;"ACA-Student Units".Unit)
            {
            }
            column(Sem;"ACA-Student Units".Semester)
            {
            }
            column(Year;"ACA-Student Units"."Academic Year")
            {
            }
            column(Grade;"ACA-Student Units".Grade)
            {
            }
            column(Fin_Score;"ACA-Student Units"."Final Score")
            {
            }
            column(Total_Score;"ACA-Student Units"."Total Marks")
            {
            }
            column(TotScore;"ACA-Student Units"."Total Score")
            {
            }

            trigger OnAfterGetRecord()
            begin
                   CalcFields("ACA-Student Units"."Total Score");
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
}

