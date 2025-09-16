#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51169 "HR Job Applications"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HR Job Applications.rdlc';

    dataset
    {
        dataitem(UnknownTable61225;UnknownTable61225)
        {
            PrintOnlyIfDetail = false;
            RequestFilterFields = "Application No",Qualified,Shortlist;
            column(ReportForNavId_1102755000; 1102755000)
            {
            }
            column(ApplicationNo_HRJobApplications;"HRM-Job Applications (B)"."Application No")
            {
                IncludeCaption = true;
            }
            column(FirstName_HRJobApplications;"HRM-Job Applications (B)"."First Name")
            {
                IncludeCaption = true;
            }
            column(MiddleName_HRJobApplications;"HRM-Job Applications (B)"."Middle Name")
            {
                IncludeCaption = true;
            }
            column(LastName_HRJobApplications;"HRM-Job Applications (B)"."Last Name")
            {
                IncludeCaption = true;
            }
            column(JobAppliedFor_HRJobApplications;"HRM-Job Applications (B)"."Job Applied For")
            {
                IncludeCaption = true;
            }
            column(JobAppliedforDescription_HRJobApplications;"HRM-Job Applications (B)"."Job Applied for Description")
            {
            }
            column(City_HRJobApplications;"HRM-Job Applications (B)".City)
            {
                IncludeCaption = true;
            }
            column(PostCode_HRJobApplications;"HRM-Job Applications (B)"."Post Code")
            {
                IncludeCaption = true;
            }
            column(IDNumber_HRJobApplications;"HRM-Job Applications (B)"."ID Number")
            {
                IncludeCaption = true;
            }
            column(Gender_HRJobApplications;"HRM-Job Applications (B)".Gender)
            {
                IncludeCaption = true;
            }
            column(CountryCode_HRJobApplications;"HRM-Job Applications (B)"."Country Code")
            {
                IncludeCaption = true;
            }
            column(HomePhoneNumber_HRJobApplications;"HRM-Job Applications (B)"."Home Phone Number")
            {
                IncludeCaption = true;
            }
            column(CellPhoneNumber_HRJobApplications;"HRM-Job Applications (B)"."Cell Phone Number")
            {
                IncludeCaption = true;
            }
            column(WorkPhoneNumber_HRJobApplications;"HRM-Job Applications (B)"."Work Phone Number")
            {
                IncludeCaption = true;
            }
            column(EMail_HRJobApplications;"HRM-Job Applications (B)"."E-Mail")
            {
                IncludeCaption = true;
            }
            column(PostalAddress_HRJobApplications;"HRM-Job Applications (B)"."Postal Address")
            {
                IncludeCaption = true;
            }
            column(CI_Name;CI.Name)
            {
                IncludeCaption = true;
            }
            column(CI_Address;CI.Address)
            {
                IncludeCaption = true;
            }
            column(CI_Address2;CI."Address 2")
            {
                IncludeCaption = true;
            }
            column(CI_City;CI.City)
            {
                IncludeCaption = true;
            }
            column(CI_EMail;CI."E-Mail")
            {
                IncludeCaption = true;
            }
            column(CI_HomePage;CI."Home Page")
            {
                IncludeCaption = true;
            }
            column(CI_PhoneNo;CI."Phone No.")
            {
                IncludeCaption = true;
            }
            column(CI_Picture;CI.Picture)
            {
                IncludeCaption = true;
            }
            column(Submitted3;"HRM-Job Applications (B)".Submitted)
            {
            }
            column(Submitted2;Submitted2)
            {
            }
            dataitem(UnknownTable61200;UnknownTable61200)
            {
                DataItemLink = "Job ID"=field("Job Applied For");
                column(ReportForNavId_1000000003; 1000000003)
                {
                }
                column(JobID;"HRM-Employee Requisitions"."Job ID")
                {
                }
                column(JobDescr;"HRM-Employee Requisitions"."Job Description")
                {
                }
                column(JobRefNo;"HRM-Employee Requisitions"."Job Ref No")
                {
                }
                column(OpeningDate;"HRM-Employee Requisitions"."Opening Date")
                {
                }
                column(ClosingDate;"HRM-Employee Requisitions"."Closing Date")
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                if "HRM-Job Applications (B)".Submitted=true then
                  Submitted2 :='Submitted' else
                  Submitted2:='Not Submitted/Incomplete';
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
                    CI.Get();
                    CI.CalcFields(CI.Picture);

                    //GET FILTER
                    JobApplicationNo:="HRM-Job Applications (B)".GetFilter("HRM-Job Applications (B)"."Employee Requisition No");
                    if JobApplicationNo='' then
                    begin
                    //    MESSAGE('Please select a Job Requisition No  Number before printing a report');
                    //    CurrReport.QUIT;
                    end;
    end;

    var
        CI: Record "Company Information";
        SectionA: label 'Section A :: Personal Details';
        SectionB: label 'Section B :: Contact Details';
        SectionC: label 'Section C :: Academic and Qualification Information';
        SectionD: label 'Section D :: Applicant''s Refferees';
        JobApplicationNo: Text;
        Submitted2: Text;
}

