#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51026 "Employee Beneficiaries Proc"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Employee Beneficiaries Proc.rdlc';

    dataset
    {
        dataitem(UnknownTable61188;UnknownTable61188)
        {
            column(ReportForNavId_1; 1)
            {
            }

            trigger OnAfterGetRecord()
            begin
                    counts:=0;
                    empc.Reset;
                    empc.SetRange(empc."Employee Code","HRM-Employee C"."No.");
                    if empc.Find('-') then begin
                    repeat
                    counts:=counts+1;
                    empc."Entry No":=Format(counts);
                    empc.Modify;
                    until empc.Next=0;
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
        empc: Record UnknownRecord61324;
        counts: Integer;
}

