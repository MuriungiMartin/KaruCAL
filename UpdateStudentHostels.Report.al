#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 56605 "Update Student Hostels"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Update Student Hostels.rdlc';

    dataset
    {
        dataitem(Ledgerz;"ACA-Hostel Ledger")
        {
            PrintOnlyIfDetail = true;
            column(ReportForNavId_1000000001; 1000000001)
            {
            }
            dataitem(HostStuds;"ACA-Students Hostel Rooms")
            {
                DataItemLink = Student=field("Student No");
                DataItemTableView = where(Cleared=filter(false),Allocated=filter(true),Billed=filter(true));
                column(ReportForNavId_1000000000; 1000000000)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    HostStuds."Hostel No":=Ledgerz."Hostel No";
                    HostStuds."Room No":=Ledgerz."Room No";
                    HostStuds."Space No":=Ledgerz."Space No";
                    HostStuds.Modify;
                end;
            }
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
}

