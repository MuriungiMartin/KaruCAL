#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51056 "Update posting group"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Update posting group.rdlc';

    dataset
    {
        dataitem(UnknownTable61118;UnknownTable61118)
        {
            column(ReportForNavId_1; 1)
            {
            }

            trigger OnAfterGetRecord()
            begin
                    HrEmp.Reset;
                    HrEmp.SetRange(HrEmp."No.","HRM-Employee (D)"."No.");
                    if HrEmp.Find('-') then begin
                    if HrEmp."Date Of Join"=0D  then begin
                    if  HrEmp."Posting Group"='' then begin
                    HrEmp."Posting Group":='PAYROLL';
                    HrEmp."Date Of Join":=20090101D;
                    HrEmp.Modify(true);
                    end;
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
        HrEmp: Record UnknownRecord61118;
}

