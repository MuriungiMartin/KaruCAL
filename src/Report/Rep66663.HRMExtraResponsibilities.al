#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 66663 "HRM-Extra Responsibilities"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HRM-Extra Responsibilities.rdlc';

    dataset
    {
        dataitem(HRM_ExtraResp;UnknownTable66662)
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(RefNo;HRM_ExtraResp."Record No.")
            {
            }
            column(EmpNo;HRM_ExtraResp."Employee No.")
            {
            }
            column(EmpName;empNo)
            {
            }
            column(RefDates;HRM_ExtraResp."Reference Date")
            {
            }
            column(UserID;HRM_ExtraResp."User ID")
            {
            }
            column(Responsibility;HRM_ExtraResp.Responsibility)
            {
            }
            column(StartDate;HRM_ExtraResp."Start Date")
            {
            }
            column(CompName;CompanyInformation.Name)
            {
            }
            column(Address;CompanyInformation.Address+' '+CompanyInformation."Address 2"+' '+CompanyInformation.City)
            {
            }
            column(Phones;CompanyInformation."Phone No."+'/'+CompanyInformation."Phone No. 2")
            {
            }
            column(Mails;CompanyInformation."E-Mail"+'/'+CompanyInformation."Home Page")
            {
            }
            column(Status;HRM_ExtraResp.Status)
            {
            }
            column(Pics;CompanyInformation.Picture)
            {
            }
            column(EndDate;HRM_ExtraResp."End Date")
            {
            }
            column(PerTerm;HRM_ExtraResp."Period/Term")
            {
            }

            trigger OnAfterGetRecord()
            begin
                Clear(empNo);
                HRMEmployeeC.Reset;
                HRMEmployeeC.SetRange("No.",HRM_ExtraResp."Employee No.");
                if HRMEmployeeC.Find('-') then begin
                  empNo:=HRMEmployeeC."First Name"+' '+HRMEmployeeC."Middle Name"+' '+HRMEmployeeC."Last Name";
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
        if CompanyInformation.Find('-') then CompanyInformation.CalcFields(Picture);
    end;

    var
        CompanyInformation: Record "Company Information";
        HRMEmployeeC: Record UnknownRecord61188;
        empNo: Code[150];
}

