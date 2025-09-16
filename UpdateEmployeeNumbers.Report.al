#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51032 "Update Employee Numbers"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Update Employee Numbers.rdlc';

    dataset
    {
        dataitem(UnknownTable61118;UnknownTable61118)
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(No;"HRM-Employee (D)"."No.")
            {
            }
            column(FName;"HRM-Employee (D)"."First Name")
            {
            }
            column(MName;"HRM-Employee (D)"."Middle Name")
            {
            }
            column(LName;"HRM-Employee (D)"."Last Name")
            {
            }

            trigger OnAfterGetRecord()
            begin
                Clear(NoUsed);
                Clear(Diff);

                NoUsed:=StrLen("HRM-Employee (D)"."No.");
                if NoUsed<4 then begin
                  if NoUsed=3 then begin
                    "HRM-Employee (D)".Rename('0'+"HRM-Employee (D)"."No.");
                  end else if NoUsed=2 then begin
                    "HRM-Employee (D)".Rename('00'+"HRM-Employee (D)"."No.");
                  end else if NoUsed=1 then begin
                    "HRM-Employee (D)".Rename('000'+"HRM-Employee (D)"."No.");
                  end;

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
        NoUsed: Integer;
        Diff: Integer;
}

