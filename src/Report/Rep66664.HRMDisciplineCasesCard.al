#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 66664 "HRM-Discipline Cases Card"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HRM-Discipline Cases Card.rdlc';

    dataset
    {
        dataitem(Employees;UnknownTable61188)
        {
            column(ReportForNavId_1000000007; 1000000007)
            {
            }
            column(EmpNo;Employees."No.")
            {
            }
            column(EmpName;Employees."First Name"+' '+Employees."Middle Name"+' '+Employees."Last Name")
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
            column(Pics;CompanyInformation.Picture)
            {
            }
            dataitem(HRM_Cases;UnknownTable61223)
            {
                DataItemLink = "Accused Employee"=field("No.");
                column(ReportForNavId_1000000000; 1000000000)
                {
                }
                column(CaseNo;HRM_Cases."Case Number")
                {
                }
                column(CompaintDate;HRM_Cases."Date of Complaint")
                {
                }
                column(RecommendedAction;HRM_Cases."Recommended Action")
                {
                }
                column(DesciplineRemarks;HRM_Cases."Disciplinary Remarks")
                {
                }
                column(Comments;HRM_Cases.Comments)
                {
                }
                column(DateOfComplaint;HRM_Cases."Date of Complaint")
                {
                }
                column(ComplaintType;HRM_Cases."Type Complaint")
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

    trigger OnInitReport()
    begin
        CompanyInformation.Reset;
        if CompanyInformation.Find('-') then CompanyInformation.CalcFields(Picture);
    end;

    var
        CompanyInformation: Record "Company Information";
}

