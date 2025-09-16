#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 66660 "HRM-Active Leaves"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HRM-Active Leaves.rdlc';

    dataset
    {
        dataitem(LeaveRequisitions;UnknownTable61125)
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(CompName;CompanyInformation.Name)
            {
            }
            column(Addresses;CompanyInformation.Address+' '+CompanyInformation."Address 2"+' '+CompanyInformation.City)
            {
            }
            column(Phones;CompanyInformation."Phone No."+'/'+CompanyInformation."Phone No. 2")
            {
            }
            column(PicsLogo;CompanyInformation.Picture)
            {
            }
            column(CompMails;CompanyInformation."E-Mail"+'/'+CompanyInformation."Home Page")
            {
            }
            column(DocNo;LeaveRequisitions."No.")
            {
            }
            column(EmployeeNumber;LeaveRequisitions."Employee No")
            {
            }
            column(EmployteeNames;LeaveRequisitions."Employee Name")
            {
            }
            column(AppliedDay;LeaveRequisitions."Applied Days")
            {
            }
            column(StartDate;LeaveRequisitions."Starting Date")
            {
            }
            column(EndDate;LeaveRequisitions."End Date")
            {
            }
            column(Purpose;LeaveRequisitions.Purpose)
            {
            }
            column(LeaveType;LeaveRequisitions."Leave Type")
            {
            }

            trigger OnAfterGetRecord()
            begin
                if not (LeaveRequisitions."Return Date">Today) then CurrReport.Skip;
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
        if CompanyInformation.Find('-') then begin
          CompanyInformation.CalcFields(Picture);
          end;
    end;

    var
        CompanyInformation: Record "Company Information";
}

