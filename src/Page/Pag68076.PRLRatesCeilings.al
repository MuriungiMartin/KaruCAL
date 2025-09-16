#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68076 "PRL-Rates & Ceilings"
{
    PageType = Card;
    SourceTable = UnknownTable61104;

    layout
    {
        area(content)
        {
            field("Setup Code";"Setup Code")
            {
                ApplicationArea = Basic;
                Editable = false;
            }
            field("Tax Relief";"Tax Relief")
            {
                ApplicationArea = Basic;
            }
            field("Insurance Relief";"Insurance Relief")
            {
                ApplicationArea = Basic;
            }
            field("Insurance Relief Ceiling";"Insurance Relief Ceiling")
            {
                ApplicationArea = Basic;
            }
            field("Max Relief";"Max Relief")
            {
                ApplicationArea = Basic;
            }
            field("NHI FInsurancePercentage";"NHI FInsurancePercentage")
            {
                ApplicationArea = Basic;
            }
            field("NSSF Employee";"NSSF Employee")
            {
                ApplicationArea = Basic;
            }
            field("NSSF Employer Factor";"NSSF Employer Factor")
            {
                ApplicationArea = Basic;
            }
            field("Nhif InsuApplies";"Nhif InsuApplies")
            {
                ApplicationArea = Basic;
            }
            field("NHIF Based on";"NHIF Based on")
            {
                ApplicationArea = Basic;
                Caption = 'NHIF Based on';
            }
            field("Max Pension Contribution";"Max Pension Contribution")
            {
                ApplicationArea = Basic;
            }
            field("Tax On Excess Pension";"Tax On Excess Pension")
            {
                ApplicationArea = Basic;
            }
            field("Mortgage Relief";"Mortgage Relief")
            {
                ApplicationArea = Basic;
                Caption = 'Less from Taxable Pay';
            }
            field("OOI Deduction";"OOI Deduction")
            {
                ApplicationArea = Basic;
                Caption = 'Max Monthly Contribution';
            }
            field("OOI December";"OOI December")
            {
                ApplicationArea = Basic;
                Caption = 'December deduction';
            }
            field("Loan Market Rate";"Loan Market Rate")
            {
                ApplicationArea = Basic;
            }
            field("Loan Corporate Rate";"Loan Corporate Rate")
            {
                ApplicationArea = Basic;
            }
            field("Security Day (U)";"Security Day (U)")
            {
                ApplicationArea = Basic;
            }
            field("Security Night (U)";"Security Night (U)")
            {
                ApplicationArea = Basic;
            }
            field("Ayah (U)";"Ayah (U)")
            {
                ApplicationArea = Basic;
            }
            field("Gardener (U)";"Gardener (U)")
            {
                ApplicationArea = Basic;
            }
            field("Security Day (R)";"Security Day (R)")
            {
                ApplicationArea = Basic;
            }
            field("Security Night (R)";"Security Night (R)")
            {
                ApplicationArea = Basic;
            }
            field("Ayah (R)";"Ayah (R)")
            {
                ApplicationArea = Basic;
            }
            field("Gardener (R)";"Gardener (R)")
            {
                ApplicationArea = Basic;
            }
            field("Taxable Pay (Normal)";"Taxable Pay (Normal)")
            {
                ApplicationArea = Basic;
            }
            field("Taxable Pay (Agricultural)";"Taxable Pay (Agricultural)")
            {
                ApplicationArea = Basic;
            }
            field("Payslip Message";"Payslip Message")
            {
                ApplicationArea = Basic;
            }
            label(Control1102755089)
            {
                ApplicationArea = Basic;
                CaptionClass = Text19080003;
            }
            label(Control1102755091)
            {
                ApplicationArea = Basic;
                CaptionClass = Text19080002;
            }
            label(Control1102755107)
            {
                ApplicationArea = Basic;
                CaptionClass = Text19080001;
            }
            label(Control1102755105)
            {
                ApplicationArea = Basic;
                CaptionClass = Text19049626;
            }
            label(Control1102755104)
            {
                ApplicationArea = Basic;
                CaptionClass = Text19058477;
            }
            label(Control1102755106)
            {
                ApplicationArea = Basic;
                CaptionClass = Text19076757;
            }
        }
    }

    actions
    {
    }

    var
        Text19076757: label '(%)';
        Text19058477: label '(Personal+Insurance)';
        Text19049626: label '(Pension(self)+Nssf)';
        Text19080001: label '(%)';
        Text19080002: label '(%)';
        Text19080003: label '(%)';
}

