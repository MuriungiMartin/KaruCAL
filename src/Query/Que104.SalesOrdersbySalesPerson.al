#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Query 104 "Sales Orders by Sales Person"
{
    Caption = 'Sales Orders by Sales Person';

    elements
    {
        dataitem(Sales_Line;"Sales Line")
        {
            column(ItemNo;"No.")
            {
            }
            column(ItemDescription;Description)
            {
            }
            column(Document_No;"Document No.")
            {
            }
            column(Posting_Date;"Posting Date")
            {
            }
            column(Amount;Amount)
            {
            }
            column(Line_No;"Line No.")
            {
            }
            column(Dimension_Set_ID;"Dimension Set ID")
            {
            }
            dataitem(Currency;Currency)
            {
                DataItemLink = Code=Sales_Line."Currency Code";
                column(CurrenyDescription;Description)
                {
                }
                dataitem(Sales_Header;"Sales Header")
                {
                    DataItemLink = "No."=Sales_Line."Document No.";
                    column(Currency_Code;"Currency Code")
                    {
                    }
                    dataitem(Salesperson_Purchaser;"Salesperson/Purchaser")
                    {
                        DataItemLink = Code=Sales_Header."Salesperson Code";
                        column(SalesPersonCode;"Code")
                        {
                        }
                        column(SalesPersonName;Name)
                        {
                        }
                    }
                }
            }
        }
    }
}

