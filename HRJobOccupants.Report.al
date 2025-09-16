#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51141 "HR Job Occupants"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HR Job Occupants.rdlc';
    Caption = 'HR Job Occupants Report';

    dataset
    {
        dataitem(UnknownTable61193;UnknownTable61193)
        {
            RequestFilterFields = "Job ID",Status;
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(CI_Name;CI.Name)
            {
                IncludeCaption = true;
            }
            column(CI_Address;CI.Address)
            {
                IncludeCaption = true;
            }
            column(CI_Address2;CI."Address 2" )
            {
                IncludeCaption = true;
            }
            column(CI_PhoneNo;CI."Phone No.")
            {
            }
            column(CI_Picture;CI.Picture)
            {
            }
            column(CI_City;CI.City)
            {
                IncludeCaption = true;
            }
            column(JobID_HRJobs;"HRM-Jobs"."Job ID")
            {
                IncludeCaption = true;
            }
            column(JobDescription_HRJobs;"HRM-Jobs"."Job Description")
            {
                IncludeCaption = true;
            }
            dataitem(UnknownTable61188;UnknownTable61188)
            {
                DataItemLink = "Job Title"=field("Job ID");
                DataItemTableView = sorting("No.") order(ascending);
                column(ReportForNavId_1000000001; 1000000001)
                {
                }
                column(No_HREmployees;"HRM-Employee C"."No.")
                {
                    IncludeCaption = true;
                }
                column(FirstName_HREmployees;"HRM-Employee C"."First Name")
                {
                    IncludeCaption = true;
                }
                column(MiddleName_HREmployees;"HRM-Employee C"."Middle Name")
                {
                    IncludeCaption = true;
                }
                column(LastName_HREmployees;"HRM-Employee C"."Last Name")
                {
                    IncludeCaption = true;
                }
                column(JobTitle_HREmployees;"HRM-Employee C"."Job Title")
                {
                    IncludeCaption = true;
                }

                trigger OnAfterGetRecord()
                begin
                    HRJob.Reset;
                    HRJob.SetRange(HRJob."Job id","Job Title");
                    if HRJob.Find('-') then
                       CurrReport.SHOWOUTPUT:=true;
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
        CI.Reset;
        CI.Get();
        CI.CalcFields(CI.Picture);
    end;

    var
        CI: Record "Company Information";
        HR_Job_OccupationsCaptionLbl: label 'HR Job Occupations';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Job_OccupantsCaptionLbl: label 'HR Job Occupants';
        P_O__BoxCaptionLbl: label 'P.O. Box';
        NoCaptionLbl: label 'No';
        NameCaptionLbl: label 'Name';
        Company_E_MailCaptionLbl: label 'Company E-Mail';
        Postal_AddressCaptionLbl: label 'Postal Address';
        CityCaptionLbl: label 'City';
        HRJob: Record UnknownRecord61057;
}

