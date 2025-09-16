#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51509 "Programme - Billing"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Programme - Billing.rdlc';

    dataset
    {
        dataitem(UnknownTable61511;UnknownTable61511)
        {
            DataItemTableView = sorting(Code);
            RequestFilterFields = "Code","Semester Filter","School Code","Date Filter",Status;
            column(ReportForNavId_1410; 1410)
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
            column(Programme_Code;Code)
            {
            }
            column(Programme_Description;Description)
            {
            }
            column(Programme__Total_Billing_;"Total Billing")
            {
            }
            column(Programme__Total_Billing__Control1000000010;"Total Billing")
            {
            }
            column(Programme_Receipted_Income_Caption;Programme_Receipted_Income_CaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Programme_CodeCaption;FieldCaption(Code))
            {
            }
            column(Programme_DescriptionCaption;FieldCaption(Description))
            {
            }
            column(Programme__Total_Billing_Caption;FieldCaption("Total Billing"))
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
        Programme_Receipted_Income_CaptionLbl: label 'Programme Receipted Income ';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

