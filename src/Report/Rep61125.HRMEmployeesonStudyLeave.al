#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 61125 "HRM-Employees on Study Leave"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HRM-Employees on Study Leave.rdlc';

    dataset
    {
        dataitem(Leaves;UnknownTable61125)
        {
            DataItemTableView = where(Status=filter(Posted),"Leave Type"=filter(STUDY|EXAMINATION));
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(CompName;CompanyInformation.Name)
            {
            }
            column(Addresses;CompanyInformation.Address+' '+CompanyInformation."Address 2"+' '+CompanyInformation.City)
            {
            }
            column(PhoneNo;CompanyInformation."Phone No."+' '+CompanyInformation."Phone No. 2")
            {
            }
            column(HomePage;CompanyInformation."E-Mail"+'/'+CompanyInformation."Home Page")
            {
            }
            column(LeaveID;Leaves."No.")
            {
            }
            column(EmployeeNo;Leaves."Employee No")
            {
            }
            column(EmpName;Leaves."Employee Name")
            {
            }
            column(Dept;Leaves."Department Code")
            {
            }
            column(AppliedDays;Leaves."Applied Days")
            {
            }
            column(StartDate;Leaves."Starting Date")
            {
            }
            column(EndDate;Leaves."End Date")
            {
            }
            column(LeaveType;Leaves."Leave Type")
            {
            }
            column(LeaveStatus;Leaves.Status)
            {
            }
            column(ReleaverNo;Leaves."Reliever No.")
            {
            }
            column(ReleaverName;Leaves."Reliever Name")
            {
            }
            column(DurationString;DurationString)
            {
            }
            column(Pic;CompanyInformation.Picture)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if (not (Leaves."End Date">Today)) then CurrReport.Skip;
                Clear(DurationString);
                if ((Leaves."Starting Date"<>0D) and (Leaves."End Date"<>0D)) then begin
                  DurationString:=HRDates.DetermineAge_Years(Leaves."Starting Date",Leaves."End Date");
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

    trigger OnInitReport()
    begin
        CompanyInformation.Reset;
        if CompanyInformation.Find('-') then;
        CompanyInformation.CalcFields(Picture);



    end;

    var
        HRDates: Codeunit "HR Dates";
        DurationString: Text[250];
        CompanyInformation: Record "Company Information";
}

