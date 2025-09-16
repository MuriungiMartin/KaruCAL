#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51138 "HR Medical Scheme Members"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HR Medical Scheme Members.rdlc';

    dataset
    {
        dataitem("HRM-Medical Schemes";"HRM-Medical Schemes")
        {
            PrintOnlyIfDetail = false;
            column(ReportForNavId_1102755000; 1102755000)
            {
            }
            column(SchemeNo_HRMedicalSchemes;"HRM-Medical Schemes"."Scheme No")
            {
                IncludeCaption = true;
            }
            column(SchemeName_HRMedicalSchemes;"HRM-Medical Schemes"."Scheme Name")
            {
                IncludeCaption = true;
            }
            column(Inpatientlimit_HRMedicalSchemes;"HRM-Medical Schemes"."In-patient limit")
            {
                IncludeCaption = true;
            }
            column(Outpatientlimit_HRMedicalSchemes;"HRM-Medical Schemes"."Out-patient limit")
            {
                IncludeCaption = true;
            }
            column(AreaCovered_HRMedicalSchemes;"HRM-Medical Schemes"."Area Covered")
            {
                IncludeCaption = true;
            }
            column(DependantsIncluded_HRMedicalSchemes;"HRM-Medical Schemes"."Dependants Included")
            {
                IncludeCaption = true;
            }
            column(SchemeType_HRMedicalSchemes;"HRM-Medical Schemes"."Scheme Type")
            {
                IncludeCaption = true;
            }
            column(MaximumNoofDependants_HRMedicalSchemes;"HRM-Medical Schemes"."Maximum No of Dependants")
            {
                IncludeCaption = true;
            }
            column(StartDate_HRMedicalSchemes;"HRM-Medical Schemes"."Start Date")
            {
                IncludeCaption = true;
            }
            column(EndDate_HRMedicalSchemes;"HRM-Medical Schemes"."End Date")
            {
                IncludeCaption = true;
            }
            column(Status_HRMedicalSchemes;"HRM-Medical Schemes".Status)
            {
                IncludeCaption = true;
            }
            column(Period_HRMedicalSchemes;"HRM-Medical Schemes".Period)
            {
                IncludeCaption = true;
            }
            column(Currency_HRMedicalSchemes;"HRM-Medical Schemes".Currency)
            {
                IncludeCaption = true;
            }
            column(CompInfoName;CompInfo.Name)
            {
                IncludeCaption = true;
            }
            column(CompInfoAddress;CompInfo.Address)
            {
                IncludeCaption = true;
            }
            column(CompInfoPicture;CompInfo.Picture)
            {
            }
            dataitem("HRM-Medical Scheme Members";"HRM-Medical Scheme Members")
            {
                DataItemLink = "Scheme No"=field("Scheme No");
                PrintOnlyIfDetail = false;
                RequestFilterFields = "Scheme No";
                column(ReportForNavId_1102755001; 1102755001)
                {
                }
                column(SchemeNo_HRMedicalSchemeMembers;"HRM-Medical Scheme Members"."Scheme No")
                {
                    IncludeCaption = true;
                }
                column(EmployeeNo_HRMedicalSchemeMembers;"HRM-Medical Scheme Members"."Employee No")
                {
                    IncludeCaption = true;
                }
                column(FirstName_HRMedicalSchemeMembers;"HRM-Medical Scheme Members"."First Name")
                {
                    IncludeCaption = true;
                }
                column(LastName_HRMedicalSchemeMembers;"HRM-Medical Scheme Members"."Last Name")
                {
                    IncludeCaption = true;
                }
                column(CummAmountSpent_HRMedicalSchemeMembers;"HRM-Medical Scheme Members"."Cumm.Amount Spent")
                {
                    IncludeCaption = true;
                }
                column(OutPatientLimit_HRMedicalSchemeMembers;"HRM-Medical Scheme Members"."Out-Patient Limit")
                {
                    IncludeCaption = true;
                }
                column(InpatientLimit_HRMedicalSchemeMembers;"HRM-Medical Scheme Members"."In-patient Limit")
                {
                    IncludeCaption = true;
                }
                column(CummAmountSpentOut_HRMedicalSchemeMembers;"HRM-Medical Scheme Members"."Cumm.Amount Spent Out")
                {
                    IncludeCaption = true;
                }
                column(BalanceOutPatient_HRMedicalSchemeMembers;"HRM-Medical Scheme Members"."Balance Out- Patient")
                {
                    IncludeCaption = true;
                }
                column(BalanceInPatient_HRMedicalSchemeMembers;"HRM-Medical Scheme Members"."Balance In- Patient")
                {
                    IncludeCaption = true;
                }
                column(NoofDepnedants_HRMedicalSchemeMembers;"HRM-Medical Scheme Members"."No of Depnedants")
                {
                    IncludeCaption = true;
                }
                column(SchemeName_HRMedicalSchemeMembers;"HRM-Medical Scheme Members"."Scheme Name")
                {
                    IncludeCaption = true;
                }
            }

            trigger OnPreDataItem()
            begin
                CompInfo.Get();
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

    var
        CompInfo: Record "Company Information";
}

