#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 99500 "Fa Ledgers"
{
    Format = VariableText;

    schema
    {
        textelement(roots)
        {
            tableelement("FA Ledger Entry";"FA Ledger Entry")
            {
                XmlName = 'FaLedgers';
                SourceTableView = where("FA Posting Date"=filter(>06;
                fieldelement(a;"FA Ledger Entry"."Entry No.")
                {
                }
                fieldelement(b;"FA Ledger Entry"."Posting Date")
                {
                }
                fieldelement(c;"FA Ledger Entry"."Document No.")
                {
                }
                fieldelement(d;"FA Ledger Entry"."FA No.")
                {
                }
                fieldelement(e;"FA Ledger Entry".Description)
                {
                }
                fieldelement(f;"FA Ledger Entry"."Depreciation Book Code")
                {
                }
                fieldelement(g;"FA Ledger Entry"."FA Posting Group")
                {
                }
                fieldelement(h;"FA Ledger Entry"."FA Posting Type")
                {
                }
                fieldelement(i;"FA Ledger Entry".Amount)
                {
                }
                fieldelement(j;"FA Ledger Entry"."Document Type")
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

