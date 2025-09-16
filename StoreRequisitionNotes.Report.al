#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51280 "Store Requisition Notes"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Store Requisition Notes.rdlc';

    dataset
    {
        dataitem(UnknownTable61146;UnknownTable61146)
        {
            RequestFilterFields = "No.";
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
            column(Internal_Requisition_Date;Date)
            {
            }
            column(Internal_Requisition__Requisitioned_By_;"Requisitioned By")
            {
            }
            column(Internal_Requisition__Units_Issued_;"Units Issued")
            {
            }
            column(Internal_Requisition_Remaining;Remaining)
            {
            }
            column(Internal_Requisition__HOD_Approved_By_;"HOD Approved By")
            {
            }
            column(Internal_Requisition__Store_Approved_By_;"Store Approved By")
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Store_RequisitionCaption;Store_RequisitionCaptionLbl)
            {
            }
            column(Internal_Requisition__No__Caption;FieldCaption("No."))
            {
            }
            column(Internal_Requisition_DateCaption;FieldCaption(Date))
            {
            }
            column(Internal_Requisition__Requisitioned_By_Caption;FieldCaption("Requisitioned By"))
            {
            }
            column(Internal_Requisition__Units_Issued_Caption;FieldCaption("Units Issued"))
            {
            }
            column(Internal_Requisition_RemainingCaption;FieldCaption(Remaining))
            {
            }
            column(Internal_Requisition__HOD_Approved_By_Caption;FieldCaption("HOD Approved By"))
            {
            }
            column(Internal_Requisition__Store_Approved_By_Caption;FieldCaption("Store Approved By"))
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
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Store_RequisitionCaptionLbl: label 'Store Requisition';
}

