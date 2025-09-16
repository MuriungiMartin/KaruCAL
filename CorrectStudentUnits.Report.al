#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 89999 "Correct Student Units"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Correct Student Units.rdlc';

    dataset
    {
        dataitem(SyudUnits;UnknownTable61549)
        {
            DataItemTableView = where(Semester=filter("SEM 2 19/20"));
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                // IF SyudUnits.RENAME(SyudUnits.Programme,SyudUnits.Stage,SyudUnits.Unit,'SEM2 19/20',SyudUnits."Reg. Transacton ID"
                //  ,SyudUnits."Student No.",SyudUnits.ENo,SyudUnits."Academic Year") THEN;
                 SyudUnits.Rename(SyudUnits.Programme,SyudUnits.Stage,SyudUnits.Unit,'SEM2 19/20',SyudUnits."Reg. Transacton ID"
                  ,SyudUnits."Student No.",SyudUnits.ENo,SyudUnits."Academic Year");
                //SyudUnits.DELETE;
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

