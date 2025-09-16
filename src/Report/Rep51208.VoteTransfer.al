#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51208 "Vote Transfer"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Vote Transfer.rdlc';

    dataset
    {
        dataitem(UnknownTable61151;UnknownTable61151)
        {
            DataItemTableView = sorting(No) where(Posted=const(Yes));
            RequestFilterFields = No,Date,"Source Vote","Destination Vote";
            column(ReportForNavId_4021; 4021)
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
            column(Vote_Transfer_No;No)
            {
            }
            column(Vote_Transfer_Date;Date)
            {
            }
            column(Vote_Transfer__Source_Vote_;"Source Vote")
            {
            }
            column(Vote_Transfer__Destination_Vote_;"Destination Vote")
            {
            }
            column(Vote_Transfer__Budget_Name_;"Budget Name")
            {
            }
            column(Vote_Transfer_Amount;Amount)
            {
            }
            column(Vote_Transfer__Source_Dimmension_1_;"Source Dimmension 1")
            {
            }
            column(Vote_Transfer__Destination_Dimmension_1_;"Destination Dimmension 1")
            {
            }
            column(Vote_Transfer__Source_Dimmension_2_;"Source Dimmension 2")
            {
            }
            column(Vote_Transfer__Destination_Dimmension_2_;"Destination Dimmension 2")
            {
            }
            column(Vote_Transfer_Remarks;Remarks)
            {
            }
            column(Vote_Transfer__Posted_By_;"Posted By")
            {
            }
            column(Vote_TransferCaption;Vote_TransferCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Vote_Transfer_NoCaption;FieldCaption(No))
            {
            }
            column(Vote_Transfer_DateCaption;FieldCaption(Date))
            {
            }
            column(Vote_Transfer__Source_Vote_Caption;FieldCaption("Source Vote"))
            {
            }
            column(Vote_Transfer__Destination_Vote_Caption;FieldCaption("Destination Vote"))
            {
            }
            column(Vote_Transfer__Budget_Name_Caption;FieldCaption("Budget Name"))
            {
            }
            column(Vote_Transfer_AmountCaption;FieldCaption(Amount))
            {
            }
            column(Vote_Transfer__Source_Dimmension_1_Caption;FieldCaption("Source Dimmension 1"))
            {
            }
            column(Vote_Transfer__Destination_Dimmension_1_Caption;FieldCaption("Destination Dimmension 1"))
            {
            }
            column(Vote_Transfer__Source_Dimmension_2_Caption;FieldCaption("Source Dimmension 2"))
            {
            }
            column(Vote_Transfer__Destination_Dimmension_2_Caption;FieldCaption("Destination Dimmension 2"))
            {
            }
            column(Vote_Transfer_RemarksCaption;FieldCaption(Remarks))
            {
            }
            column(Vote_Transfer__Posted_By_Caption;FieldCaption("Posted By"))
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
        Vote_TransferCaptionLbl: label 'Vote Transfer';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

