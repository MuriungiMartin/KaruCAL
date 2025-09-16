#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 50065 "Cust Updates"
{
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement("Detailed Cust. Ledg. Entry";"Detailed Cust. Ledg. Entry")
            {
                AutoUpdate = true;
                XmlName = 'Item';
                fieldelement(a;"Detailed Cust. Ledg. Entry"."Entry No.")
                {
                }
                fieldelement(b;"Detailed Cust. Ledg. Entry"."Debit Amount")
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

