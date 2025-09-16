#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51303 "PV Pending Payments Detailed"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/PV Pending Payments Detailed.rdlc';

    dataset
    {
        dataitem(UnknownTable61134;UnknownTable61134)
        {
            DataItemTableView = sorting("Account No.") where(Status=const("2nd Approval"),"Payment Type"=const(Normal));
            RequestFilterFields = "Account No.";
            column(ReportForNavId_3752; 3752)
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
            column(Payments__Account_No__;"Account No.")
            {
            }
            column(Payments_No;No)
            {
            }
            column(Payments_Date;Date)
            {
            }
            column(Payments_OPN;OPN)
            {
            }
            column(Payments__Account_No___Control1102760020;"Account No.")
            {
            }
            column(Payments__Account_Name_;"Account Name")
            {
            }
            column(Payments_Amount;Amount)
            {
            }
            column(Payments__VAT_Amount_;"VAT Amount")
            {
            }
            column(Payments__Withholding_Tax_Amount_;"Withholding Tax Amount")
            {
            }
            column(Payments__Net_Amount_;"Net Amount")
            {
            }
            column(TotalFor___FIELDCAPTION__Account_No___;TotalFor + FieldCaption("Account No."))
            {
            }
            column(Payments_Amount_Control1102760038;Amount)
            {
            }
            column(Payments__VAT_Amount__Control1102760039;"VAT Amount")
            {
            }
            column(Payments__Withholding_Tax_Amount__Control1102760040;"Withholding Tax Amount")
            {
            }
            column(Payments__Net_Amount__Control1102760041;"Net Amount")
            {
            }
            column(PV_Pending_Payments__Per_Supplier_Caption;PV_Pending_Payments__Per_Supplier_CaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Payments_NoCaption;FieldCaption(No))
            {
            }
            column(Payments_DateCaption;FieldCaption(Date))
            {
            }
            column(Payments_OPNCaption;FieldCaption(OPN))
            {
            }
            column(Payments__Account_No___Control1102760020Caption;FieldCaption("Account No."))
            {
            }
            column(Payments__Account_Name_Caption;FieldCaption("Account Name"))
            {
            }
            column(Payments_AmountCaption;FieldCaption(Amount))
            {
            }
            column(Payments__VAT_Amount_Caption;FieldCaption("VAT Amount"))
            {
            }
            column(Payments__Withholding_Tax_Amount_Caption;FieldCaption("Withholding Tax Amount"))
            {
            }
            column(Payments__Net_Amount_Caption;FieldCaption("Net Amount"))
            {
            }
            column(Payments__Account_No__Caption;FieldCaption("Account No."))
            {
            }

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("Account No.");
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
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        TotalFor: label 'Total for ';
        PV_Pending_Payments__Per_Supplier_CaptionLbl: label 'PV Pending Payments (Per Supplier)';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

