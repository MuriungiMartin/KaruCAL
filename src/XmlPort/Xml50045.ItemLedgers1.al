#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 50045 "Item Ledgers 1"
{
    Format = VariableText;

    schema
    {
        textelement(roots)
        {
            tableelement("Item Ledger Entry";"Item Ledger Entry")
            {
                XmlName = 'Itemledger';
                SourceTableView = where("Posting Date"=filter(>06;
                fieldelement(a;"Item Ledger Entry"."Item No.")
                {
                }
                fieldelement(b;"Item Ledger Entry"."Posting Date")
                {
                }
                fieldelement(c;"Item Ledger Entry"."Document No.")
                {
                }
                fieldelement(d;"Item Ledger Entry".Description)
                {
                }
                fieldelement(e;"Item Ledger Entry"."Location Code")
                {
                }
                fieldelement(f;"Item Ledger Entry".Quantity)
                {
                }
                fieldelement(h;"Item Ledger Entry".Open)
                {
                }
                fieldelement(i;"Item Ledger Entry"."Entry No.")
                {
                }
                fieldelement(j;"Item Ledger Entry"."Unit of Measure Code")
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

