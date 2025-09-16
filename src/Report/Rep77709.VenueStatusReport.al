#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 77709 "Venue Status Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Venue Status Report.rdlc';

    dataset
    {
        dataitem(UnknownTable77706;UnknownTable77706)
        {
            DataItemTableView = sorting("Venue Code") order(ascending);
            PrintOnlyIfDetail = true;
            column(ReportForNavId_1000000027; 1000000027)
            {
            }
            column(CompName;info.Name)
            {
            }
            column(Address1;info.Address)
            {
            }
            column(Address2;info."Address 2")
            {
            }
            column(City;info.City)
            {
            }
            column(Phone1;info."Phone No.")
            {
            }
            column(Phone2;info."Phone No. 2")
            {
            }
            column(Fax;info."Fax No.")
            {
            }
            column(Pic;info.Picture)
            {
            }
            column(postCode;info."Post Code")
            {
            }
            column(CompEmail;info."E-Mail")
            {
            }
            column(HomePage;info."Home Page")
            {
            }
            dataitem(UnknownTable77709;UnknownTable77709)
            {
                DataItemLink = Venue=field("Venue Code");
                PrintOnlyIfDetail = false;
                RequestFilterFields = "Booking Date",Venue,Status,Department;
                column(ReportForNavId_1000000000; 1000000000)
                {
                }
                column(VenueCode;"Venue Setup"."Venue Code")
                {
                }
                column(VenueDescOriginal;"Venue Setup"."Venue Description")
                {
                }
                column(DocNo;"Gen-Venue Booking"."Booking Id")
                {
                }
                column(DeptCode;"Gen-Venue Booking".Department)
                {
                }
                column(DeptName;"Gen-Venue Booking"."Department Name")
                {
                }
                column(reqBy;"Gen-Venue Booking"."Requested By")
                {
                }
                column(ReqDate;"Gen-Venue Booking"."Request Date")
                {
                }
                column(BooKdate;"Gen-Venue Booking"."Booking Date")
                {
                }
                column(BookTime;"Gen-Venue Booking"."Booking Time")
                {
                }
                column(ReqTime;"Gen-Venue Booking"."Required Time")
                {
                }
                column(MeetingName;"Gen-Venue Booking"."Meeting Description")
                {
                }
                column(Venue;"Gen-Venue Booking".Venue)
                {
                }
                column(ContactPerson;"Gen-Venue Booking"."Contact Person")
                {
                }
                column(ContactNumber;"Gen-Venue Booking"."Contact Number")
                {
                }
                column(ContactMail;"Gen-Venue Booking"."Contact Mail")
                {
                }
                column(Pax;"Gen-Venue Booking".Pax)
                {
                }
                column(Status;"Gen-Venue Booking".Status)
                {
                }
                column(venueDesc;"Gen-Venue Booking"."Venue Dscription")
                {
                }
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

    trigger OnPreReport()
    begin
        if info.Get() then begin
            info.CalcFields(Picture);
          end;
    end;

    var
        info: Record "Company Information";
        userSetup: Record "User Setup";
        userSetup1: Record "User Setup";
        userSetup2: Record "User Setup";
        userSetup3: Record "User Setup";
        userSetup4: Record "User Setup";
        userSetup5: Record "User Setup";
        userSetup6: Record "User Setup";
        VenueSetup: Record UnknownRecord77706;
}

