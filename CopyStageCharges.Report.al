#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51682 "Copy Stage Charges"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Copy Stage Charges.rdlc';

    dataset
    {
        dataitem(UnknownTable61533;UnknownTable61533)
        {
            DataItemTableView = sorting("Programme Code","Stage Code",Code);
            RequestFilterFields = "Programme Code";
            column(ReportForNavId_6690; 6690)
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
            column(Stage_Charges__Programme_Code_;"Programme Code")
            {
            }
            column(Stage_Charges__Stage_Code_;"Stage Code")
            {
            }
            column(Stage_Charges_Code;Code)
            {
            }
            column(Stage_Charges_Description;Description)
            {
            }
            column(Stage_Charges_Amount;Amount)
            {
            }
            column(Stage_ChargesCaption;Stage_ChargesCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Stage_Charges__Programme_Code_Caption;FieldCaption("Programme Code"))
            {
            }
            column(Stage_Charges__Stage_Code_Caption;FieldCaption("Stage Code"))
            {
            }
            column(Stage_Charges_CodeCaption;FieldCaption(Code))
            {
            }
            column(Stage_Charges_DescriptionCaption;FieldCaption(Description))
            {
            }
            column(Stage_Charges_AmountCaption;FieldCaption(Amount))
            {
            }
            column(Stage_Charges_Settlement_Type;"Settlement Type")
            {
            }

            trigger OnAfterGetRecord()
            begin
                StageCharges.Init;
                StageCharges."Programme Code":='DPITNEW07';
                StageCharges."Stage Code":="ACA-Stage Charges"."Stage Code";
                StageCharges.Code:="ACA-Stage Charges".Code;
                StageCharges.Description:="ACA-Stage Charges".Description;
                StageCharges.Amount:="ACA-Stage Charges".Amount;
                StageCharges.Remarks:="ACA-Stage Charges".Remarks;
                StageCharges."Recovered First":="ACA-Stage Charges"."Recovered First";
                StageCharges.Semester:="ACA-Stage Charges".Semester;
                StageCharges."Student Type":="ACA-Stage Charges"."Student Type";
                StageCharges.Insert;
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
        StageCharges: Record UnknownRecord61533;
        Stage_ChargesCaptionLbl: label 'Stage Charges';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

