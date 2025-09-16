#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 55504 "FLT-Driver Duty Roster"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/FLT-Driver Duty Roster.rdlc';

    dataset
    {
        dataitem(WeeksRotar;UnknownTable55507)
        {
            column(ReportForNavId_1000000028; 1000000028)
            {
            }
            column(CompName;CompanyInformation.Name)
            {
            }
            column(Address;CompanyInformation.Address+' ,'+CompanyInformation."Address 2"+' ,'+CompanyInformation.City)
            {
            }
            column(conts;CompanyInformation."Phone No."+' '+CompanyInformation."Phone No. 2")
            {
            }
            column(mails;CompanyInformation."E-Mail"+' '+CompanyInformation."Home Page")
            {
            }
            column(Logo;CompanyInformation.Picture)
            {
            }
            column(WeekId;WeeksRotar."Week ID")
            {
            }
            column(WeekStart;WeeksRotar."Week Start")
            {
            }
            column(Weekend;WeeksRotar."Week End")
            {
            }
            dataitem(DutyRoster;UnknownTable55506)
            {
                DataItemLink = "Week No"=field("Week ID");
                column(ReportForNavId_1000000037; 1000000037)
                {
                }
                column(DriverNo;DutyRoster."Employee No.")
                {
                }
                column(DriverName;HRMEmployeeC2."First Name"+' '+HRMEmployeeC2."Middle Name"+' '+HRMEmployeeC2."Last Name")
                {
                }
                column(mond;DutyRoster.Monday)
                {
                }
                column(Tues;DutyRoster.Tuesday)
                {
                }
                column(Wedns;DutyRoster.Wednesday)
                {
                }
                column(thurs;DutyRoster.Thursday)
                {
                }
                column(fri;DutyRoster.Friday)
                {
                }
                column(sat;DutyRoster.Saturday)
                {
                }
                column(sun;DutyRoster.Sunday)
                {
                }
                column(startdates;DutyRoster."Start Date")
                {
                }
                column(enddates;DutyRoster."End Date")
                {
                }
                column(Mondate;DutyRoster."Monday Date")
                {
                }
                column(Tuesdate;DutyRoster."Tuesday Date")
                {
                }
                column(Wednesdate;DutyRoster."Wednesday Date")
                {
                }
                column(Thursdate;DutyRoster."Thursday Date")
                {
                }
                column(Fridate;DutyRoster."Friday Date")
                {
                }
                column(Saturdate;DutyRoster."Saturday Date")
                {
                }
                column(Sundate;DutyRoster."Sunday Date")
                {
                }
                column(NotAllocated;NotAllocated)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    HRMEmployeeC2.Reset;
                    HRMEmployeeC2.SetRange("No.",DutyRoster."Employee No.");
                    if HRMEmployeeC2.Find('-') then;
                    Clear(NotAllocated);
                    NotAllocated:='NO';
                    if ((DutyRoster.Monday='') and
                    (DutyRoster.Tuesday  ='') and
                    (DutyRoster.Wednesday  ='') and
                    (DutyRoster.Thursday  ='') and
                    (DutyRoster.Friday  ='') and
                    (DutyRoster.Saturday  ='') and
                    (DutyRoster.Sunday  ='')) then
                    NotAllocated:='YES';
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

    trigger OnPreReport()
    begin
        CompanyInformation.Reset;
        if CompanyInformation.Find('-') then CompanyInformation.CalcFields(Picture);
    end;

    var
        CompanyInformation: Record "Company Information";
        FLTVehicleHeader: Record UnknownRecord61816;
        HRMEmployeeC: Record UnknownRecord61188;
        HRMEmployeeC2: Record UnknownRecord61188;
        NotAllocated: Code[10];
}

