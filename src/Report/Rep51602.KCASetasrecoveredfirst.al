#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51602 "KCA Set as recovered first"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/KCA Set as recovered first.rdlc';

    dataset
    {
        dataitem(UnknownTable61515;UnknownTable61515)
        {
            DataItemTableView = sorting(Code);
            RequestFilterFields = "Code","Recover First";
            column(ReportForNavId_9183; 9183)
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
            column(Charge_Code;Code)
            {
            }
            column(Charge_Description;Description)
            {
            }
            column(Charge_Amount;Amount)
            {
            }
            column(Charge__Recover_First_;"Recover First")
            {
            }
            column(ChargeCaption;ChargeCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Charge_CodeCaption;FieldCaption(Code))
            {
            }
            column(Charge_DescriptionCaption;FieldCaption(Description))
            {
            }
            column(Charge_AmountCaption;FieldCaption(Amount))
            {
            }
            column(Charge__Recover_First_Caption;FieldCaption("Recover First"))
            {
            }

            trigger OnAfterGetRecord()
            begin
                StudCharges.Reset;
                StudCharges.SetRange(StudCharges.Code,"ACA-Charge".Code);
                if StudCharges.Find('-') then begin
                StudCharges.ModifyAll(StudCharges."Recovered First",true);
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

    var
        StudCharges: Record UnknownRecord61535;
        ChargeCaptionLbl: label 'Charge';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

