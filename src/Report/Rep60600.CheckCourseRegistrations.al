#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 60600 "Check Course Registrations"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Check Course Registrations.rdlc';

    dataset
    {
        dataitem(UnknownTable61532;UnknownTable61532)
        {
            RequestFilterFields = Semester,Programme,Stage,"Settlement Type","Registration Date","Student No.";
            column(ReportForNavId_1000000001; 1000000001)
            {
            }
            column(ProgNo;"ACA-Course Registration".Programme)
            {
            }
            column(ProgName;"ACA-Programme".Description)
            {
            }
            column(StudNo;"ACA-Course Registration"."Student No.")
            {
            }
            column(StudNames;Customer.Name)
            {
            }
            column(Phone;Customer."Phone No.")
            {
            }
            column(TransNo;"ACA-Course Registration"."Reg. Transacton ID")
            {
            }
            column(AcademicYear;"ACA-Course Registration"."Academic Year")
            {
            }
            column(Semester;"ACA-Course Registration".Semester)
            {
            }
            column(Stage;"ACA-Course Registration".Stage)
            {
            }
            column(SettlementType;"ACA-Course Registration"."Settlement Type")
            {
            }
            column(Stopped;"ACA-Course Registration".Reversed)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Customer.Reset;
                Customer.SetRange("No.","ACA-Course Registration"."Student No.");
                if Customer.Find('-') then begin

                  end;
                "ACA-Programme".Reset;
                "ACA-Programme".SetRange("ACA-Programme".Code,"ACA-Course Registration".Programme);
                if "ACA-Programme".Find('-') then begin
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
        Customer: Record Customer;
        "ACA-Programme": Record UnknownRecord61511;
}

