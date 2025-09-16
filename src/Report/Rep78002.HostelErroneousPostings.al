#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 78002 "Hostel Erroneous Postings"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Hostel Erroneous Postings.rdlc';

    dataset
    {
        dataitem("ACA-Students Hostel Rooms";"ACA-Students Hostel Rooms")
        {
            RequestFilterFields = "Hostel No","Room No","Space No",Student,Semester;
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(studNo;"ACA-Students Hostel Rooms".Student)
            {
            }
            column(HostelNo;"ACA-Students Hostel Rooms"."Hostel No")
            {
            }
            column(RoomNo;"ACA-Students Hostel Rooms"."Room No")
            {
            }
            column(SpaceNo;"ACA-Students Hostel Rooms"."Space No")
            {
            }
            column(Charges;"ACA-Students Hostel Rooms".Charges)
            {
            }
            column(Allocated;"ACA-Students Hostel Rooms".Allocated)
            {
            }
            column(Billed;"ACA-Students Hostel Rooms".Billed)
            {
            }
            column(Cleared;"ACA-Students Hostel Rooms".Cleared)
            {
            }
            column(stdName;Customer.Name)
            {
            }
            column(Valid;"ACA-Students Hostel Rooms".Valid)
            {
            }
            column(sem;"ACA-Students Hostel Rooms".Semester)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if Customer.Get("ACA-Students Hostel Rooms".Student) then begin
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
}

