#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51232 "Inventory Issue Summary"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Inventory Issue Summary.rdlc';

    dataset
    {
        dataitem(UnknownTable61160;UnknownTable61160)
        {
            DataItemTableView = sorting(No);
            RequestFilterFields = "Customer No",Date,"Expected Date","Issued By";
            column(ReportForNavId_6910; 6910)
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
            column(Inventory_Issue_Header_No;No)
            {
            }
            column(Inventory_Issue_Header__Customer_No_;"Customer No")
            {
            }
            column(Inventory_Issue_Header__Cleared_Date_;"Cleared Date")
            {
            }
            column(Inventory_Issue_Header__Customer_Name_;"Customer Name")
            {
            }
            column(Inventory_Issue_Header_Contacts;Contacts)
            {
            }
            column(Inventory_Issue_Header_Date;Date)
            {
            }
            column(Inventory_Issue_Header__Expected_Date_;"Expected Date")
            {
            }
            column(Inventory_Issue_Header_Amount;Amount)
            {
            }
            column(Inventory_Issue_Header_Issued;Issued)
            {
            }
            column(Inventory_Issue_Header__Issued_By_;"Issued By")
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Inventory_Issue_SummaryCaption;Inventory_Issue_SummaryCaptionLbl)
            {
            }
            column(Inventory_Issue_Header_NoCaption;FieldCaption(No))
            {
            }
            column(Inventory_Issue_Header__Customer_No_Caption;FieldCaption("Customer No"))
            {
            }
            column(Inventory_Issue_Header__Cleared_Date_Caption;FieldCaption("Cleared Date"))
            {
            }
            column(Inventory_Issue_Header__Customer_Name_Caption;FieldCaption("Customer Name"))
            {
            }
            column(Inventory_Issue_Header_ContactsCaption;FieldCaption(Contacts))
            {
            }
            column(Inventory_Issue_Header_DateCaption;FieldCaption(Date))
            {
            }
            column(Inventory_Issue_Header__Expected_Date_Caption;FieldCaption("Expected Date"))
            {
            }
            column(Inventory_Issue_Header_AmountCaption;FieldCaption(Amount))
            {
            }
            column(Inventory_Issue_Header_IssuedCaption;FieldCaption(Issued))
            {
            }
            column(Inventory_Issue_Header__Issued_By_Caption;FieldCaption("Issued By"))
            {
            }

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo(No);
            end;
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
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Inventory_Issue_SummaryCaptionLbl: label 'Inventory Issue Summary';
}

