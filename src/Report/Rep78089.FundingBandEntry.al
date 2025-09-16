#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 78089 "Funding Band Entry"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Funding Band Entry.rdlc';

    dataset
    {
        dataitem("Funding Band Entries";"Funding Band Entries")
        {
            DataItemTableView = where(Archived=const(false));
            RequestFilterFields = "Academic Year","Admission Year","Programme Code","Batch No.","Student No.";
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(StudentNo_FundingBandEntries;"Funding Band Entries"."Student No.")
            {
            }
            column(StudentName_FundingBandEntries;"Funding Band Entries"."Student Name")
            {
            }
            column(AcademicYear_FundingBandEntries;"Funding Band Entries"."Academic Year")
            {
            }
            column(AdmissionYear_FundingBandEntries;"Funding Band Entries"."Admission Year")
            {
            }
            column(KCSEIndexNo_FundingBandEntries;"Funding Band Entries"."KCSE Index No.")
            {
            }
            column(BandCode_FundingBandEntries;"Funding Band Entries"."Band Code")
            {
            }
            column(BandDescription_FundingBandEntries;"Funding Band Entries"."Band Description")
            {
            }
            column(ProgrammeCode_FundingBandEntries;"Funding Band Entries"."Programme Code")
            {
            }
            column(ProgrammeCost_FundingBandEntries;"Funding Band Entries"."Programme Cost")
            {
            }
            column(HouseHoldPercentage_FundingBandEntries;"Funding Band Entries"."HouseHold Percentage")
            {
            }
            column(HouseHoldFee_FundingBandEntries;"Funding Band Entries"."HouseHold Fee")
            {
            }
            column(ProgrammDescription_FundingBandEntries;"Funding Band Entries"."Programm Description")
            {
            }
            column(LastModifiedBy_FundingBandEntries;"Funding Band Entries"."Last Modified By")
            {
            }
            column(LastModifiedDateTime_FundingBandEntries;"Funding Band Entries"."Last Modified DateTime")
            {
            }
            column(CreatedBy_FundingBandEntries;"Funding Band Entries"."Created By")
            {
            }
            column(CreatedDateTime_FundingBandEntries;"Funding Band Entries"."Created DateTime")
            {
            }
            column(BatchNo_FundingBandEntries;"Funding Band Entries"."Batch No.")
            {
            }
            column(Archived_FundingBandEntries;"Funding Band Entries".Archived)
            {
            }
            column(CompName;CompanyInfo.Name)
            {
            }
            column(CompPic;CompanyInfo.Picture)
            {
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
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
    end;

    var
        CompanyInfo: Record "Company Information";
}

