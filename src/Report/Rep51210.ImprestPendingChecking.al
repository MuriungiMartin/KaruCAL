#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51210 "Imprest Pending Checking"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Imprest Pending Checking.rdlc';

    dataset
    {
        dataitem(UnknownTable61134;UnknownTable61134)
        {
            DataItemTableView = sorting(No) where(Status=const("1st Approval"),"Payment Type"=const(Imprest),Posted=const(No),"Checked By"=const());
            RequestFilterFields = Date,"Pay Mode";
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
            column(Payments_No;No)
            {
            }
            column(Payments_Date;Date)
            {
            }
            column(Payments__Account_No__;"Account No.")
            {
            }
            column(Payments__Account_Name_;"Account Name")
            {
            }
            column(Payments_Amount;Amount)
            {
            }
            column(Payments_Department;Department)
            {
            }
            column(Payments__IW_No_;"IW No")
            {
            }
            column(Payments__Raised_By_;"Raised By")
            {
            }
            column(Imprest_Pending_CheckingCaption;Imprest_Pending_CheckingCaptionLbl)
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
            column(PF_NOCaption;PF_NOCaptionLbl)
            {
            }
            column(Payments__Account_Name_Caption;FieldCaption("Account Name"))
            {
            }
            column(Payments_AmountCaption;FieldCaption(Amount))
            {
            }
            column(Department_CodeCaption;Department_CodeCaptionLbl)
            {
            }
            column(Warrant_NoCaption;Warrant_NoCaptionLbl)
            {
            }
            column(Payments__Raised_By_Caption;FieldCaption("Raised By"))
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
        Imprest_Pending_CheckingCaptionLbl: label 'Imprest Pending Checking';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        PF_NOCaptionLbl: label 'PF NO';
        Department_CodeCaptionLbl: label 'Department Code';
        Warrant_NoCaptionLbl: label 'Warrant No';
}

