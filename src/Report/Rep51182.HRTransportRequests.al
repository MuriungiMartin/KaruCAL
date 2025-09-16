#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51182 "HR Transport Requests"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HR Transport Requests.rdlc';

    dataset
    {
        dataitem(UnknownTable61621;UnknownTable61621)
        {
            RequestFilterFields = "Code";
            column(ReportForNavId_1919; 1919)
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
            column(HR_Transport_Requests_Code;Code)
            {
            }
            column(HR_Transport_Requests__Requester_Code_;"Requester Code")
            {
            }
            column(HR_Transport_Requests_Requester;Requester)
            {
            }
            column(HR_Transport_Requests_From;From)
            {
            }
            column(HR_Transport_Requests__To_;"To")
            {
            }
            column(HR_Transport_Requests__Purpose_of_Request_;"Purpose of Request")
            {
            }
            column(HR_Transport_Requests__Requisition_Date_;"Requisition Date")
            {
            }
            column(HR_Transport_RequestsCaption;HR_Transport_RequestsCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(HR_Transport_Requests_CodeCaption;FieldCaption(Code))
            {
            }
            column(HR_Transport_Requests__Requester_Code_Caption;FieldCaption("Requester Code"))
            {
            }
            column(HR_Transport_Requests_RequesterCaption;FieldCaption(Requester))
            {
            }
            column(HR_Transport_Requests_FromCaption;FieldCaption(From))
            {
            }
            column(HR_Transport_Requests__To_Caption;FieldCaption("To"))
            {
            }
            column(HR_Transport_Requests__Purpose_of_Request_Caption;FieldCaption("Purpose of Request"))
            {
            }
            column(HR_Transport_Requests__Requisition_Date_Caption;FieldCaption("Requisition Date"))
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
        HR_Transport_RequestsCaptionLbl: label 'HR Transport Requests';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

