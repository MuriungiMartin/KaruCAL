#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51290 "HTL Items Transaction"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HTL Items Transaction.rdlc';

    dataset
    {
        dataitem(Item;Item)
        {
            DataItemTableView = sorting("No.") order(ascending);
            PrintOnlyIfDetail = true;
            column(ReportForNavId_8129; 8129)
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
            column(Item__No__;"No.")
            {
            }
            column(Item_Description;Description)
            {
            }
            column(Item__Base_Unit_of_Measure_;"Base Unit of Measure")
            {
            }
            column(ITEMS_LEDGERSCaption;ITEMS_LEDGERSCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Item__No__Caption;FieldCaption("No."))
            {
            }
            column(Item_DescriptionCaption;FieldCaption(Description))
            {
            }
            column(Item__Base_Unit_of_Measure_Caption;FieldCaption("Base Unit of Measure"))
            {
            }
            dataitem("Item Ledger Entry";"Item Ledger Entry")
            {
                DataItemLink = "Item No."=field("No.");
                RequestFilterFields = "Item No.","Posting Date","Entry Type","Location Code",Quantity;
                RequestFilterHeading = 'Item Filters';
                column(ReportForNavId_7209; 7209)
                {
                }
                column(Item_Ledger_Entry__Document_No__;"Document No.")
                {
                }
                column(Item_Ledger_Entry__Location_Code_;"Location Code")
                {
                }
                column(Item_Ledger_Entry_Quantity;Quantity)
                {
                }
                column(Item_Ledger_Entry_Description;Description)
                {
                }
                column(Item_Ledger_Entry_Quantity_Control1000000024;Quantity)
                {
                }
                column(Item_Ledger_Entry__Document_No__Caption;FieldCaption("Document No."))
                {
                }
                column(Item_Ledger_Entry__Location_Code_Caption;FieldCaption("Location Code"))
                {
                }
                column(Item_Ledger_Entry_QuantityCaption;FieldCaption(Quantity))
                {
                }
                column(Item_Ledger_Entry_DescriptionCaption;FieldCaption(Description))
                {
                }
                column(Total_QuantityCaption;Total_QuantityCaptionLbl)
                {
                }
                column(Item_Ledger_Entry_Entry_No_;"Entry No.")
                {
                }
                column(Item_Ledger_Entry_Item_No_;"Item No.")
                {
                }
            }

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("No.");
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
        ITEMS_LEDGERSCaptionLbl: label 'ITEMS LEDGERS';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Total_QuantityCaptionLbl: label 'Total Quantity';
}

