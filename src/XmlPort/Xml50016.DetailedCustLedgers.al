#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 50016 "Detailed Cust Ledgers"
{
    Format = VariableText;

    schema
    {
        textelement(Roots)
        {
            tableelement("Detailed Cust. Ledg. Entry";"Detailed Cust. Ledg. Entry")
            {
                XmlName = 'DetailedCust';
                fieldelement(a1;"Detailed Cust. Ledg. Entry"."Entry No.")
                {
                }
                fieldelement(a2;"Detailed Cust. Ledg. Entry"."Posting Date")
                {
                }
                fieldelement(a3;"Detailed Cust. Ledg. Entry"."Document No.")
                {
                }
                fieldelement(a4;"Detailed Cust. Ledg. Entry"."Debit Amount")
                {
                }
                fieldelement(a5;"Detailed Cust. Ledg. Entry"."Credit Amount")
                {
                }
                fieldelement(a6;"Detailed Cust. Ledg. Entry"."Customer No.")
                {
                }
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
}

