#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 89998 "Correct Semesters"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Correct Semesters.rdlc';

    dataset
    {
        dataitem(Coreg;UnknownTable61532)
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                // IF Coreg.RENAME(Coreg."Reg. Transacton ID",Coreg."Student No.",Coreg.Programme,'SEM2 19/20',Coreg."Register for",Coreg.Stage,
                // Coreg."Student Type",Coreg."Entry No.") THEN;
                Coreg.Validate(Stage);
                Coreg.Modify;
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

