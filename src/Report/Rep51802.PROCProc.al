#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51802 "PROC-Proc"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(UnknownTable61752;UnknownTable61752)
        {
            column(ReportForNavId_1; 1)
            {
            }

            trigger OnAfterGetRecord()
            begin
                 trans.Reset;
                 trans.SetRange(trans."Employee Code","ACA-Clearance Property Records"."Clearance Level Code");
                 trans.SetRange(trans."Transaction Code","ACA-Clearance Property Records"."Initiated By");
                 trans.SetRange(trans."Payroll Period","ACA-Clearance Property Records"."Last Time Modified");
                 trans.SetFilter(trans.Balance,'=%1',0);
                 if trans.Find('-') then trans.DeleteAll;

                  trans.Reset;
                 trans.SetRange(trans."Employee Code","ACA-Clearance Property Records"."Clearance Level Code");
                 trans.SetRange(trans."Transaction Code","ACA-Clearance Property Records"."Initiated By");
                 trans.SetRange(trans."Payroll Period","ACA-Clearance Property Records"."Last Time Modified");
                 if trans.Find('-') then begin // Uodate
                 trans.Amount:="ACA-Clearance Property Records"."Initiated Date";
                 "ACA-Clearance Property Records"."Student Intake":="ACA-Clearance Property Records"."student intake"::"1";
                 "ACA-Clearance Property Records".Modify;
                 trans.Modify;
                 end
                 else begin// Insert
                 trans.Init();
                 trans."Employee Code":="ACA-Clearance Property Records"."Clearance Level Code";
                 trans."Transaction Code":="ACA-Clearance Property Records"."Initiated By";
                 trans."Period Month":="ACA-Clearance Property Records"."Last Date Modified";
                 trans."Period Year":="ACA-Clearance Property Records"."Initiated Time";
                 trans."Payroll Period":="ACA-Clearance Property Records"."Last Time Modified";
                 trans."Transaction Name":="ACA-Clearance Property Records".Department;
                 trans.Amount:="ACA-Clearance Property Records"."Initiated Date";
                 trans.Insert();
                 "ACA-Clearance Property Records"."Student Intake":="ACA-Clearance Property Records"."student intake"::"2";
                 "ACA-Clearance Property Records".Modify;

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
        trans: Record UnknownRecord61091;
}

