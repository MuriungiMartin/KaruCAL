#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 99958 "Student Portal Activation"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(UnknownTable61532;UnknownTable61532)
        {
            RequestFilterFields = Semester,"Academic Year","Student No.";
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(StudentReg;"ACA-Course Registration"."Student No.")
            {
            }
            column(Prog;"ACA-Course Registration".Programme)
            {
            }
            column(Stage;"ACA-Course Registration".Stage)
            {
            }
            column(Sem;"ACA-Course Registration".Semester)
            {
            }

            trigger OnAfterGetRecord()
            begin
                cust.Reset;
                cust.SetRange("No.","ACA-Course Registration"."Student No.");
                if cust.FindFirst then begin
                  cust.Password:=cust."ID No";
                  cust.Modify();
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
        cust: Record Customer;
}

