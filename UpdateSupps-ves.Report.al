#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 78064 "Update Supps -ves"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Update Supps -ves.rdlc';

    dataset
    {
        dataitem(Results;UnknownTable78031)
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                // // Results."Exam Marks":=0;
                // // Results."CAT Marks":=0;
                // // Results."Total Marks":=0;
                // // Results.MODIFY;
                if Results.Category = Results.Category::" " then begin
                  Results.Category := Results.Category::Supplementary;
                  Results.Modify;
                  end;
            end;
        }
        dataitem(secondSuppRes;UnknownTable78002)
        {
            column(ReportForNavId_1000000001; 1000000001)
            {
            }

            trigger OnAfterGetRecord()
            begin
                // secondSuppRes."Exam Marks":=0;
                // secondSuppRes."CAT Marks":=0;
                // secondSuppRes."Total Marks":=0;
                // secondSuppRes.MODIFY;

                if secondSuppRes.Category = Results.Category::" " then begin
                  secondSuppRes.Category := secondSuppRes.Category::Supplementary;
                  secondSuppRes.Modify;
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
        AcaSpecialExamsDetails: Record UnknownRecord78002;
        Aca2ndSuppExamsDetails: Record UnknownRecord78031;
        ACAStudentUnits: Record UnknownRecord61549;
}

