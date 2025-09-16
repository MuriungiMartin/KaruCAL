#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51231 "Inventory Issue"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Inventory Issue.rdlc';

    dataset
    {
        dataitem(UnknownTable61161;UnknownTable61161)
        {
            DataItemTableView = sorting("Line No",No);
            RequestFilterFields = "Item No","Customer No",Location,Status;
            column(ReportForNavId_2852; 2852)
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
            column(Inventory_Issue_Line__Item_No_;"Item No")
            {
            }
            column(Inventory_Issue_Line__Item_Name_;"Item Name")
            {
            }
            column(Inventory_Issue_Line__Issued_Quantity_;"Issued Quantity")
            {
            }
            column(Inventory_Issue_Line_Select;Select)
            {
            }
            column(Inventory_Issue_Line__Returned_Date_;"Returned Date")
            {
            }
            column(Inventory_Issue_Line_Units;Units)
            {
            }
            column(Inventory_Issue_Line__Unit_price_;"Unit price")
            {
            }
            column(Inventory_Issue_Line__Total_Cost_;"Total Cost")
            {
            }
            column(Inventory_Issue_Line__Delay_Cost_;"Delay Cost")
            {
            }
            column(Inventory_Issue_Line_Location;Location)
            {
            }
            column(Inventory_Issue_Line__Dist__Quantity_;"Dist. Quantity")
            {
            }
            column(Inventory_Issue_Line__Dist__Quantity_Returned_;"Dist. Quantity Returned")
            {
            }
            column(Inventory_Issue_Line__Customer_No_;"Customer No")
            {
            }
            column(Inventory_Issue_LineCaption;Inventory_Issue_LineCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Inventory_Issue_Line__Item_No_Caption;FieldCaption("Item No"))
            {
            }
            column(Inventory_Issue_Line__Item_Name_Caption;FieldCaption("Item Name"))
            {
            }
            column(Inventory_Issue_Line__Issued_Quantity_Caption;FieldCaption("Issued Quantity"))
            {
            }
            column(Inventory_Issue_Line_SelectCaption;FieldCaption(Select))
            {
            }
            column(Inventory_Issue_Line__Returned_Date_Caption;FieldCaption("Returned Date"))
            {
            }
            column(Inventory_Issue_Line_UnitsCaption;FieldCaption(Units))
            {
            }
            column(Inventory_Issue_Line__Unit_price_Caption;FieldCaption("Unit price"))
            {
            }
            column(Inventory_Issue_Line__Total_Cost_Caption;FieldCaption("Total Cost"))
            {
            }
            column(Inventory_Issue_Line__Delay_Cost_Caption;FieldCaption("Delay Cost"))
            {
            }
            column(Inventory_Issue_Line_LocationCaption;FieldCaption(Location))
            {
            }
            column(Inventory_Issue_Line__Dist__Quantity_Caption;FieldCaption("Dist. Quantity"))
            {
            }
            column(Inventory_Issue_Line__Dist__Quantity_Returned_Caption;FieldCaption("Dist. Quantity Returned"))
            {
            }
            column(Inventory_Issue_Line__Customer_No_Caption;FieldCaption("Customer No"))
            {
            }
            column(Inventory_Issue_Line_Line_No;"Line No")
            {
            }
            column(Inventory_Issue_Line_No;No)
            {
            }

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("Line No");
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
        Inventory_Issue_LineCaptionLbl: label 'Inventory Issue Line';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

