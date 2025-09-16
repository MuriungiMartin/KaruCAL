#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51495 "Charges - Amount Receipted"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Charges - Amount Receipted.rdlc';

    dataset
    {
        dataitem(UnknownTable61515;UnknownTable61515)
        {
            DataItemTableView = sorting(Code);
            RequestFilterFields = "Code","Date Filter";
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
            column(Charge__Date_Filter_;"Date Filter")
            {
            }
            column(Charge_Code;Code)
            {
            }
            column(Charge_Description;Description)
            {
            }
            column(Charge__G_L_Account_;"G/L Account")
            {
            }
            column(Charge__Total_Income_;"Total Income")
            {
            }
            column(Charge__Total_Income__Control1000000010;"Total Income")
            {
            }
            column(Charges___Amount_ReceiptedCaption;Charges___Amount_ReceiptedCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Charge__Date_Filter_Caption;FieldCaption("Date Filter"))
            {
            }
            column(Charge_CodeCaption;FieldCaption(Code))
            {
            }
            column(Charge_DescriptionCaption;FieldCaption(Description))
            {
            }
            column(Charge__G_L_Account_Caption;FieldCaption("G/L Account"))
            {
            }
            column(Charge__Total_Income_Caption;FieldCaption("Total Income"))
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

    var
        Charges___Amount_ReceiptedCaptionLbl: label 'Charges - Amount Receipted';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

