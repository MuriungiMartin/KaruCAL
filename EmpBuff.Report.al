#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 70091 EmpBuff
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(UnknownTable61118;UnknownTable61118)
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                EmpBuff.Reset;
                EmpBuff.SetRange("Emp No","HRM-Employee (D)"."No.");
                if EmpBuff.Find('-') then begin
                "HRM-Employee (D)".Status:="HRM-Employee (D)".Status::Normal;
                  "HRM-Employee (D)".Modify;
                  if HRMEmployeeC.Find('-') then begin
                    end;
                  end else begin
                    "HRM-Employee (D)".Status:="HRM-Employee (D)".Status::Resigned;
                  "HRM-Employee (D)".Modify;
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
        EmpBuff: Record UnknownRecord70091;
        HRMEmployeeC: Record UnknownRecord61188;
}

