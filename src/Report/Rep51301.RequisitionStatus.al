#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51301 "Requisition Status"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Requisition Status.rdlc';

    dataset
    {
        dataitem(UnknownTable61146;UnknownTable61146)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.",Date,Status;
            column(ReportForNavId_7033; 7033)
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
            column(Internal_Requisition__No__;"No.")
            {
            }
            column(Internal_Requisition__Internal_Requisition__Date;"PROC-Internal Requisition".Date)
            {
            }
            column(Internal_Requisition__Entered_By_;"Entered By")
            {
            }
            column(Internal_Requisition_Status;Status)
            {
            }
            column(Internal_Requisition__HOD_Approved_By_;"HOD Approved By")
            {
            }
            column(Internal_Requisition__HOD_Approved_Date_;"HOD Approved Date")
            {
            }
            column(Internal_Requisition__HOD_Status_;"HOD Status")
            {
            }
            column(Internal_Requisition__Store_Approved_By_;"Store Approved By")
            {
            }
            column(Internal_Requisition__Store_Approved_Date_;"Store Approved Date")
            {
            }
            column(REQUISITION_STATUSCaption;REQUISITION_STATUSCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Internal_Requisition__No__Caption;FieldCaption("No."))
            {
            }
            column(DateCaption;DateCaptionLbl)
            {
            }
            column(Internal_Requisition__Entered_By_Caption;FieldCaption("Entered By"))
            {
            }
            column(Internal_Requisition_StatusCaption;FieldCaption(Status))
            {
            }
            column(Internal_Requisition__HOD_Approved_By_Caption;FieldCaption("HOD Approved By"))
            {
            }
            column(Internal_Requisition__HOD_Approved_Date_Caption;FieldCaption("HOD Approved Date"))
            {
            }
            column(Internal_Requisition__HOD_Status_Caption;FieldCaption("HOD Status"))
            {
            }
            column(Internal_Requisition__Store_Approved_By_Caption;FieldCaption("Store Approved By"))
            {
            }
            column(Internal_Requisition__Store_Approved_Date_Caption;FieldCaption("Store Approved Date"))
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
        REQUISITION_STATUSCaptionLbl: label 'REQUISITION STATUS';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        DateCaptionLbl: label 'Date';
}

