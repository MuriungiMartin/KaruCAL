#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 61832 "Hostel Incidents Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Hostel Incidents Report.rdlc';

    dataset
    {
        dataitem("ACA-Hostel Card";"ACA-Hostel Card")
        {
            column(ReportForNavId_1; 1)
            {
            }
            column(address;info.Address)
            {
            }
            column(Phone;info."Phone No.")
            {
            }
            column(pics;info.Picture)
            {
            }
            column(No;"ACA-Hostel Card"."Asset No")
            {
            }
            column(Desc;"ACA-Hostel Card".Description)
            {
            }
            dataitem("Hostel Incidents Register";"Hostel Incidents Register")
            {
                DataItemLink = "Hostel Block No."=field("Asset No");
                column(ReportForNavId_1000000000; 1000000000)
                {
                }
                column(IncidentNo;"Hostel Incidents Register"."Incident No.")
                {
                }
                column(IncidentDate;"Hostel Incidents Register"."Incident Date")
                {
                }
                column(IncidentTime;"Hostel Incidents Register"."Incident Time")
                {
                }
                column(DayOrNight;"Hostel Incidents Register"."Day/Night")
                {
                }
                column(ReportBy;"Hostel Incidents Register"."Report By")
                {
                }
                column(ReportSummary;"Hostel Incidents Register"."Report Summary")
                {
                }
                column(ReportDetails;"Hostel Incidents Register"."Report Details")
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                     Clear(totRooms);
                     totRooms:="ACA-Hostel Card".Vaccant+"ACA-Hostel Card"."Fully Occupied"+"ACA-Hostel Card".Blacklisted+"ACA-Hostel Card"."Partially Occupied";
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

    trigger OnPreReport()
    begin
         info.Reset;
         if info.Find('-') then info.CalcFields(Picture)
    end;

    var
        info: Record "Company Information";
        totRooms: Integer;
}

