#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51866 "Meal-Booking report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Meal-Booking report.rdlc';

    dataset
    {
        dataitem(UnknownTable61778;UnknownTable61778)
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(BookingDate;"CAT-Meal Booking Header".Department)
            {
            }
            column(RequestDate;"CAT-Meal Booking Header"."Request Date")
            {
            }
            column(MeetingNaME;"CAT-Meal Booking Header"."Meeting Name")
            {
            }
            column(Venue;"CAT-Meal Booking Header".Venue)
            {
            }
            column(ContactPerson;"CAT-Meal Booking Header"."Contact Person")
            {
            }
            column(DeptName;"CAT-Meal Booking Header"."Department Name")
            {
            }
            column(Totalcost;"CAT-Meal Booking Header"."Total Cost")
            {
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

