#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 50213 "Bank ledgers"
{
    Format = VariableText;

    schema
    {
        textelement(root)
        {
            tableelement("Bank Account Ledger Entry";"Bank Account Ledger Entry")
            {
                XmlName = 'bnkledgers';
                SourceTableView = where(Field69041=const(1));
                fieldelement(a;"Bank Account Ledger Entry"."Posting Date")
                {
                }
                fieldelement(b;"Bank Account Ledger Entry".Amount)
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

