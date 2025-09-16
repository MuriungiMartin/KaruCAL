#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51284 "Stock Transfer"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Stock Transfer.rdlc';

    dataset
    {
        dataitem(UnknownTable61148;UnknownTable61148)
        {
            DataItemTableView = sorting("No.") where("Issue Type"=const(Transfer));
            RequestFilterFields = "Issued By","Transfer to Location";
            column(ReportForNavId_5506; 5506)
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
            column(Store_Issue__No__;"No.")
            {
            }
            column(Store_Issue__Date_Issued_;"Date Issued")
            {
            }
            column(Store_Issue__Received_By_;"Received By")
            {
            }
            column(Store_Issue_Location;Location)
            {
            }
            column(Store_Issue__Transfer_to_Location_;"Transfer to Location")
            {
            }
            column(Store_Issue__Transfer_Transit_;"Transfer Transit")
            {
            }
            column(Store_Issue__Request_No_;"Request No")
            {
            }
            column(Store_Issue__Vote_Book_;"Vote Book")
            {
            }
            column(Store_Issue__Issued_By_;"Issued By")
            {
            }
            column(Stock_TransferCaption;Stock_TransferCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Store_Issue__No__Caption;FieldCaption("No."))
            {
            }
            column(Store_Issue__Date_Issued_Caption;FieldCaption("Date Issued"))
            {
            }
            column(Store_Issue__Received_By_Caption;FieldCaption("Received By"))
            {
            }
            column(Transfer_From_LocationCaption;Transfer_From_LocationCaptionLbl)
            {
            }
            column(Store_Issue__Transfer_to_Location_Caption;FieldCaption("Transfer to Location"))
            {
            }
            column(Store_Issue__Transfer_Transit_Caption;FieldCaption("Transfer Transit"))
            {
            }
            column(Store_Issue__Request_No_Caption;FieldCaption("Request No"))
            {
            }
            column(Store_Issue__Vote_Book_Caption;FieldCaption("Vote Book"))
            {
            }
            column(Store_Issue__Issued_By_Caption;FieldCaption("Issued By"))
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
        Stock_TransferCaptionLbl: label 'Stock Transfer';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Transfer_From_LocationCaptionLbl: label 'Transfer From Location';
}

