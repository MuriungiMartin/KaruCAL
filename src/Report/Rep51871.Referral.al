#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51871 Referral
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Referral.rdlc';

    dataset
    {
        dataitem(UnknownTable61433;UnknownTable61433)
        {
            column(ReportForNavId_1000000005; 1000000005)
            {
            }
            column(Treatmentno_HMSReferralHeader;"HMS-Referral Header"."Treatment no.")
            {
            }
            column(HospitalNo_HMSReferralHeader;"HMS-Referral Header"."Hospital No.")
            {
            }
            column(PatientNo_HMSReferralHeader;"HMS-Referral Header"."Patient No.")
            {
            }
            column(DateReferred_HMSReferralHeader;"HMS-Referral Header"."Date Referred")
            {
            }
            column(ReferralReason_HMSReferralHeader;"HMS-Referral Header"."Referral Reason")
            {
            }
            column(ReferralRemarks_HMSReferralHeader;"HMS-Referral Header"."Referral Remarks")
            {
            }
            column(Surname_HMSReferralHeader;"HMS-Referral Header".Surname)
            {
            }
            column(MiddleName_HMSReferralHeader;"HMS-Referral Header"."Middle Name")
            {
            }
            column(LastName_HMSReferralHeader;"HMS-Referral Header"."Last Name")
            {
            }
            column(IDNumber_HMSReferralHeader;"HMS-Referral Header"."ID Number")
            {
            }
            column(PatientRefNo_HMSReferralHeader;"HMS-Referral Header"."Patient Ref. No.")
            {
            }
            column(SrNO_HMSReferralHeader;"HMS-Referral Header"."Staff No")
            {
            }
            column(ProvisionalDiagnosis_HMSReferralHeader;"HMS-Referral Header"."Provisional Diagnosis")
            {
            }
            column(PresentTreatment_HMSReferralHeader;"HMS-Referral Header"."Present Treatment")
            {
            }
            column(Comments_HMSReferralHeader;"HMS-Referral Header".Comments)
            {
            }
            column(Log;comp.Picture)
            {
            }
            column(CompName;comp.Name)
            {
            }
            column(number1;comp."Phone No.")
            {
            }
            column(number2;comp."Phone No. 2")
            {
            }
            column(Address;comp.Address)
            {
            }
            column(City;comp.City)
            {
            }

            trigger OnAfterGetRecord()
            begin
                //HMSReferralHeader.RESET;
                ///HMSReferralHeader.SETRANGE("Treatment no.","Treatment no.");
            end;

            trigger OnPreDataItem()
            begin
                "HMS-Referral Header".CalcFields("HMS-Referral Header".Surname,"HMS-Referral Header"."Middle Name");
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
        comp.Reset;
        if comp.FindFirst then begin
          comp.CalcFields(Picture);
        end
    end;

    var
        comp: Record "Company Information";
        HMSReferralHeader: Record UnknownRecord61433;
}

