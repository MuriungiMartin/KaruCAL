#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51209 "Imprest Pending Approval"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Imprest Pending Approval.rdlc';

    dataset
    {
        dataitem(UnknownTable61134;UnknownTable61134)
        {
            DataItemTableView = sorting(No) where("Payment Type"=const(Imprest));
            RequestFilterFields = No,Date,"Pay Mode","IW No";
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
            column(Payments_Status;Status)
            {
            }
            column(Payments__1st_Approval_Status_;"1st Approval Status")
            {
            }
            column(Payments__2nd_Approval_Status_;"2nd Approval Status")
            {
            }
            column(Payments__3rd_Approval_Status_;"3rd Approval Status")
            {
            }
            column(Imprest_Pending_ApprovalCaption;Imprest_Pending_ApprovalCaptionLbl)
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
            column(Payments_StatusCaption;FieldCaption(Status))
            {
            }
            column(Payments__1st_Approval_Status_Caption;FieldCaption("1st Approval Status"))
            {
            }
            column(Payments__2nd_Approval_Status_Caption;FieldCaption("2nd Approval Status"))
            {
            }
            column(Payments__3rd_Approval_Status_Caption;FieldCaption("3rd Approval Status"))
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
        Imprest_Pending_ApprovalCaptionLbl: label 'Imprest Pending Approval';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        PF_NOCaptionLbl: label 'PF NO';
}

