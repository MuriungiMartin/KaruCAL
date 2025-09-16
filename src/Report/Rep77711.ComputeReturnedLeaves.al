#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 77711 "Compute Returned Leaves"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(UnknownTable61188;UnknownTable61188)
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                HRMLeaveLedger.Reset;
                HRMLeaveLedger.SetRange("Employee No","HRM-Employee C"."No.");
                HRMLeaveLedger.SetCurrentkey("Employee No","Transaction Date");
                if HRMLeaveLedger.Find('+') then begin
                  HRMLeaveLedger.CalcFields(HRMLeaveLedger."Start Date",HRMLeaveLedger."End Date");
                  if HRMLeaveLedger."End Date">Today then begin
                    "HRM-Employee C"."On Leave":=true;
                    "HRM-Employee C"."Current Leave Start":=HRMLeaveLedger."Start Date";
                    "HRM-Employee C"."Current Leave End":=HRMLeaveLedger."End Date";
                    "HRM-Employee C"."Current Leave Type":=HRMLeaveLedger."Leave Type";
                    "HRM-Employee C"."Current Leave Applied Days":=HRMLeaveLedger."No. of Days"*(-1);
                    "HRM-Employee C".Modify;
                    end else begin
                    "HRM-Employee C"."On Leave":=false;
                    "HRM-Employee C"."Current Leave Start":=0D;
                    "HRM-Employee C"."Current Leave End":=0D;
                    "HRM-Employee C"."Current Leave Type":='';
                    "HRM-Employee C"."Current Leave Applied Days":=0;
                    "HRM-Employee C".Modify;
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
        HRMLeaveLedger: Record UnknownRecord61659;
        HRMLeaveRequisition: Record UnknownRecord61125;
}

