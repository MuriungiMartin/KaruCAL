#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 99952 "Update Lecture Vendors"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Update Lecture Vendors.rdlc';

    dataset
    {
        dataitem(Vendor;Vendor)
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Vendor1.Reset;
                Vendor1.SetRange("No.", Vendor."No.");
                Vendor1.SetRange("Medical Claim Account", true);
                if Vendor1.Find('-') then begin
                  repeat
                    Vendor1."Vendor Posting Group" := 'LECTURER';
                    Vendor1.Modify;
                    until Vendor1.Next=0;
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
        Vendor1: Record Vendor;
        CLaimLedger: Record UnknownRecord90022;
}

