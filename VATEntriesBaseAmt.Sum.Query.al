#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Query 19 "VAT Entries Base Amt. Sum"
{
    Caption = 'Tax Entries Base Amt. Sum';
    OrderBy = ascending(Country_Region_Code),ascending(VAT_Registration_No);

    elements
    {
        dataitem(VAT_Entry;"VAT Entry")
        {
            DataItemTableFilter = Type=const(Sale);
            filter(Posting_Date;"Posting Date")
            {
            }
            column(VAT_Registration_No;"VAT Registration No.")
            {
            }
            column(EU_3_Party_Trade;"EU 3-Party Trade")
            {
            }
            column(EU_Service;"EU Service")
            {
            }
            column(Country_Region_Code;"Country/Region Code")
            {
            }
            column(Sum_Base;Base)
            {
                Method = Sum;
            }
            column(Sum_Additional_Currency_Base;"Additional-Currency Base")
            {
                Method = Sum;
            }
            column(Bill_to_Pay_to_No;"Bill-to/Pay-to No.")
            {
            }
            dataitem(Country_Region;"Country/Region")
            {
                DataItemLink = Code=VAT_Entry."Country/Region Code";
                column(EU_Country_Region_Code;"EU Country/Region Code")
                {
                    ColumnFilter = EU_Country_Region_Code=filter(<>'');
                }
            }
        }
    }
}

