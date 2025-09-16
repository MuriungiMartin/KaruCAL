#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51170 "HR Shortlisted Candidates"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HR Shortlisted Candidates.rdlc';

    dataset
    {
        dataitem(UnknownTable61200;UnknownTable61200)
        {
            RequestFilterFields = "Requisition No.";
            column(ReportForNavId_5259; 5259)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(USERID;UserId)
            {
            }
            column(HR_Employee_Requisitions__Requisition_No__;"Requisition No.")
            {
            }
            column(HR_Employee_Requisitions__Requisition_Type_;"Requisition Type")
            {
            }
            column(HR_Employee_Requisitions__Requisition_Date_;"Requisition Date")
            {
            }
            column(HR_Employee_Requisitions__Reason_For_Request_;"Reason For Request")
            {
            }
            column(HR_Employee_Requisitions__Type_of_Contract_Required_;"Type of Contract Required")
            {
            }
            column(HR_Employee_Requisitions_Requestor;Requestor)
            {
            }
            column(HR_Employee_Requisitions__Job_ID_;"Job ID")
            {
            }
            column(HR_Employee_Requisitions__Job_Description_;"Job Description")
            {
            }
            column(HR_Employee_RequisitionsCaption;HR_Employee_RequisitionsCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(HR_Shortlisted_CandidatesCaption;HR_Shortlisted_CandidatesCaptionLbl)
            {
            }
            column(P_O__BoxCaption;P_O__BoxCaptionLbl)
            {
            }
            column(Job_Requisition_DetailsCaption;Job_Requisition_DetailsCaptionLbl)
            {
            }
            column(HR_Employee_Requisitions__Requisition_Type_Caption;FieldCaption("Requisition Type"))
            {
            }
            column(HR_Employee_Requisitions__Requisition_Date_Caption;FieldCaption("Requisition Date"))
            {
            }
            column(HR_Employee_Requisitions__Reason_For_Request_Caption;FieldCaption("Reason For Request"))
            {
            }
            column(HR_Employee_Requisitions__Type_of_Contract_Required_Caption;FieldCaption("Type of Contract Required"))
            {
            }
            column(HR_Employee_Requisitions_RequestorCaption;FieldCaption(Requestor))
            {
            }
            column(HR_Employee_Requisitions__Requisition_No__Caption;FieldCaption("Requisition No."))
            {
            }
            column(HR_Employee_Requisitions__Job_ID_Caption;FieldCaption("Job ID"))
            {
            }
            column(HR_Employee_Requisitions__Job_Description_Caption;FieldCaption("Job Description"))
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
            dataitem(UnknownTable61227;UnknownTable61227)
            {
                DataItemLink = "Employee Requisition No"=field("Requisition No.");
                DataItemTableView = sorting("Employee Requisition No","Job Application No");
                RequestFilterFields = Gender;
                column(ReportForNavId_2704; 2704)
                {
                }
                column(HR_Shortlisted_Applicants__Job_Application_No_;"Job Application No")
                {
                }
                column(HR_Shortlisted_Applicants__First_Name_;"First Name")
                {
                }
                column(HR_Shortlisted_Applicants__Middle_Name_;"Middle Name")
                {
                }
                column(HR_Shortlisted_Applicants__Last_Name_;"Last Name")
                {
                }
                column(HR_Shortlisted_Applicants__ID_No_;"ID No")
                {
                }
                column(HR_Shortlisted_Applicants_Gender;Gender)
                {
                }
                column(HR_Shortlisted_Applicants_Qualified;Qualified)
                {
                }
                column(HR_Shortlisted_Applicants__Job_Application_No_Caption;FieldCaption("Job Application No"))
                {
                }
                column(HR_Shortlisted_Applicants__Last_Name_Caption;FieldCaption("Last Name"))
                {
                }
                column(HR_Shortlisted_Applicants__First_Name_Caption;FieldCaption("First Name"))
                {
                }
                column(HR_Shortlisted_Applicants__Middle_Name_Caption;FieldCaption("Middle Name"))
                {
                }
                column(HR_Shortlisted_Applicants__ID_No_Caption;FieldCaption("ID No"))
                {
                }
                column(HR_Shortlisted_Applicants_GenderCaption;FieldCaption(Gender))
                {
                }
                column(HR_Shortlisted_Applicants_QualifiedCaption;FieldCaption(Qualified))
                {
                }
                column(Shortlisted_ApplicantsCaption;Shortlisted_ApplicantsCaptionLbl)
                {
                }
                column(HR_Shortlisted_Applicants_Employee_Requisition_No;"Employee Requisition No")
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                No:=No+1;
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
    end;

    var
        CI: Record "Company Information";
        HR_Employee_RequisitionsCaptionLbl: label 'HR Employee Requisitions';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        HR_Shortlisted_CandidatesCaptionLbl: label 'HR Shortlisted Candidates';
        P_O__BoxCaptionLbl: label 'P.O. Box';
        Job_Requisition_DetailsCaptionLbl: label 'Job Requisition Details';
        Shortlisted_ApplicantsCaptionLbl: label 'Shortlisted Applicants';
        No: Integer;
}

