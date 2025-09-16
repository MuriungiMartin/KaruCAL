#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 50068 "Customer ledgers"
{
    Format = VariableText;

    schema
    {
        textelement(root)
        {
            tableelement("Cust. Ledger Entry";"Cust. Ledger Entry")
            {
                RequestFilterFields = "Posting Date";
                XmlName = 'Custledgers';
                SourceTableView = where("Posting Date"=filter(>07;
                fieldelement(a;"Cust. Ledger Entry"."Entry No.")
                {
                }
                fieldelement(b;"Cust. Ledger Entry"."Document No.")
                {
                }
                fieldelement(c;"Cust. Ledger Entry"."Posting Date")
                {
                }
                fieldelement(d;"Cust. Ledger Entry"."Customer No.")
                {
                }
                fieldelement(e;"Cust. Ledger Entry".Amount)
                {
                }
                fieldelement(F;"Cust. Ledger Entry"."Applying Entry")
                {
                }
                fieldelement(G;"Cust. Ledger Entry".Reversed)
                {
                }
                fieldelement(H;"Cust. Ledger Entry"."Document Type")
                {
                }
                fieldelement(I;"Cust. Ledger Entry"."Global Dimension 1 Code")
                {
                }
                fieldelement(J;"Cust. Ledger Entry"."Global Dimension 2 Code")
                {
                }
                fieldelement(I;"Cust. Ledger Entry"."External Document No.")
                {
                }
                fieldelement(k;"Cust. Ledger Entry".Description)
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

