#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Query 100 "Top Customer Overview"
{
    Caption = 'Top Customer Overview';

    elements
    {
        dataitem(Customer;Customer)
        {
            column(Name;Name)
            {
            }
            column(No;"No.")
            {
            }
            column(Sales_LCY;"Sales (LCY)")
            {
            }
            column(Profit_LCY;"Profit (LCY)")
            {
            }
            column(Country_Region_Code;"Country/Region Code")
            {
            }
            column(City;City)
            {
            }
            column(Global_Dimension_1_Code;"Global Dimension 1 Code")
            {
            }
            column(Global_Dimension_2_Code;"Global Dimension 2 Code")
            {
            }
            column(Salesperson_Code;"Salesperson Code")
            {
            }
            dataitem(Salesperson_Purchaser;"Salesperson/Purchaser")
            {
                DataItemLink = Code=Customer."Salesperson Code";
                column(SalesPersonName;Name)
                {
                }
                dataitem(Country_Region;"Country/Region")
                {
                    DataItemLink = Code=Customer."Country/Region Code";
                    column(CountryRegionName;Name)
                    {
                    }
                }
            }
        }
    }
}

