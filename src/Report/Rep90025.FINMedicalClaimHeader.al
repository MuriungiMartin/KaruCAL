#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 90025 "FIN-Medical Claim Header"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/FIN-Medical Claim Header.rdlc';
    UsageCategory = Administration;

    dataset
    {
        dataitem(mclaims;UnknownTable90025)
        {
            DataItemTableView = where(Status=filter(Posted));
            RequestFilterFields = "Date Posted";
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(ClaimNo_mclaims;mclaims."Claim No.")
            {
            }
            column(StaffNo_mclaims;mclaims."Staff No.")
            {
            }
            column(StaffName_mclaims;mclaims."Staff Name")
            {
            }
            column(SalaryGrade_mclaims;mclaims."Salary Grade")
            {
            }
            column(CeilingAmount_mclaims;mclaims."Ceiling Amount")
            {
            }
            column(PeriodCode_mclaims;mclaims."Period Code")
            {
            }
            column(PeriodBalance_mclaims;mclaims."Period Balance")
            {
            }
            column(DepartmentCode_mclaims;mclaims."Department Code")
            {
            }
            column(CampusCode_mclaims;mclaims."Campus Code")
            {
            }
            column(ClaimAmount_mclaims;mclaims."Claim Amount")
            {
            }
            column(Status_mclaims;mclaims.Status)
            {
            }
            column(Posted_mclaims;mclaims.Posted)
            {
            }
            column(PostedBy_mclaims;mclaims."Posted By")
            {
            }
            column(DatePosted_mclaims;Format(mclaims."Date Posted"))
            {
            }
            column(TimePosted_mclaims;mclaims."Time Posted")
            {
            }
            column(PVNumber_mclaims;mclaims."PV Number")
            {
            }
            column(Selected_mclaims;mclaims.Selected)
            {
            }
            column(CompName;CompanyInformation.Name)
            {
            }
            column(CompAddress;CompanyInformation.Address)
            {
            }
            column(CompPhone;CompanyInformation."Phone No.")
            {
            }
            column(CompMail;CompanyInformation."E-Mail")
            {
            }
            column(CompUrl;CompanyInformation."Home Page")
            {
            }
            column(logo;CompanyInformation.Picture)
            {
            }
            dataitem(mclaimLines;UnknownTable90026)
            {
                DataItemLink = "Claim No."=field("Claim No.");
                column(ReportForNavId_1000000024; 1000000024)
                {
                }
                column(ClaimNo_mclaimLines;mclaimLines."Claim No.")
                {
                }
                column(RefferalCode_mclaimLines;mclaimLines."Refferal Code")
                {
                }
                column(ReferalDescription_mclaimLines;mclaimLines."Referal Description")
                {
                }
                column(StaffNo_mclaimLines;mclaimLines."Staff No.")
                {
                }
                column(ReferalDate_mclaimLines;mclaimLines."Referal Date")
                {
                }
                column(ClaimPeriod_mclaimLines;mclaimLines."Claim Period")
                {
                }
                column(ClaimCategory_mclaimLines;mclaimLines."Claim Category")
                {
                }
                column(PeriodBalance_mclaimLines;mclaimLines."Period Balance")
                {
                }
                column(ClaimAmount_mclaimLines;mclaimLines."Claim Amount")
                {
                }
                column(CurrentAmounts_mclaimLines;mclaimLines."Current Amounts")
                {
                }
            }

            trigger OnAfterGetRecord()
            begin

                mclaims.CalcFields("Claim Amount");
            end;

            trigger OnPreDataItem()
            begin
                CompanyInformation.Get;
                CompanyInformation.CalcFields(Picture);
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
        CompanyInformation: Record "Company Information";
}

