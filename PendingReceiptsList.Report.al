#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51247 "Pending Receipts List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Pending Receipts List.rdlc';

    dataset
    {
        dataitem(UnknownTable61157;UnknownTable61157)
        {
            DataItemTableView = where(Posted=const(Yes));
            RequestFilterFields = "Doc No",Date,"Campus Code";
            column(ReportForNavId_3303; 3303)
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
            column(Cash_Sale_Header__Doc_No_;"Doc No")
            {
            }
            column(Cash_Sale_Header__Customer_No_;"Customer No")
            {
            }
            column(Cash_Sale_Header__Customer_Name_;"Customer Name")
            {
            }
            column(Cash_Sale_Header_Balance;Balance)
            {
            }
            column(Cash_Sale_Header__Cheque_No_;"Cheque No")
            {
            }
            column(Cash_Sale_Header_Amount;Amount)
            {
            }
            column(Cash_Sale_Header__Campus_Code_;"Campus Code")
            {
            }
            column(Cash_Sale_HeaderCaption;Cash_Sale_HeaderCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Cash_Sale_Header__Doc_No_Caption;FieldCaption("Doc No"))
            {
            }
            column(Cash_Sale_Header__Customer_No_Caption;FieldCaption("Customer No"))
            {
            }
            column(Cash_Sale_Header__Customer_Name_Caption;FieldCaption("Customer Name"))
            {
            }
            column(Cash_Sale_Header_BalanceCaption;FieldCaption(Balance))
            {
            }
            column(Cash_Sale_Header__Cheque_No_Caption;FieldCaption("Cheque No"))
            {
            }
            column(Cash_Sale_Header_AmountCaption;FieldCaption(Amount))
            {
            }
            column(Cash_Sale_Header__Campus_Code_Caption;FieldCaption("Campus Code"))
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
        Cash_Sale_HeaderCaptionLbl: label 'Cash Sale Header';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

