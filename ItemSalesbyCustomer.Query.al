#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Query 102 "Item Sales by Customer"
{
    Caption = 'Item Sales by Customer';

    elements
    {
        dataitem(Value_Entry;"Value Entry")
        {
            DataItemTableFilter = "Source Type"=filter(Customer),"Item Ledger Entry No."=filter(<>0),"Document Type"=filter("Sales Invoice");
            column(Entry_No;"Entry No.")
            {
            }
            column(Document_No;"Document No.")
            {
            }
            column(Posting_Date;"Posting Date")
            {
            }
            column(Item_No;"Item No.")
            {
            }
            column(Item_Ledger_Entry_Quantity;"Item Ledger Entry Quantity")
            {
            }
            column(Dimension_Set_ID;"Dimension Set ID")
            {
            }
            dataitem(Customer;Customer)
            {
                DataItemLink = "No."=Value_Entry."Source No.";
                column(CustomerNo;"No.")
                {
                }
                column(Name;Name)
                {
                }
                dataitem(Item;Item)
                {
                    DataItemLink = "No."=Value_Entry."Item No.";
                    column(Description;Description)
                    {
                    }
                    column(Gen_Prod_Posting_Group;"Gen. Prod. Posting Group")
                    {
                    }
                }
            }
        }
    }
}

