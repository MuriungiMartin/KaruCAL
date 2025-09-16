#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51048 "Validate Branch Code"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Validate Branch Code.rdlc';

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
                  if "HRM-Employee (D)".Find('-') then begin
                  HrEmp."Main Bank":="HRM-Employee (D)"."Main Bank";
                  HrEmp."Branch Bank":="HRM-Employee (D)"."Branch Bank" ;
                  HrEmp.Modify(true);
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

