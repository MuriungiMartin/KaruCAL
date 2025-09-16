#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 9992 "Export Item Ledger Entries"
{
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement("<item entry>";"Item Ledger Entry")
            {
                AutoReplace = true;
                AutoUpdate = false;
                XmlName = 'St';
                SourceTableView = where("Posting Date"=filter(>06;
                fieldelement(A;"<Item Entry>"."Entry No.")
                {
                }
                fieldelement(B;"<Item Entry>"."Item No.")
                {
                }
                fieldelement(c;"<Item Entry>"."Posting Date")
                {
                }
                fieldelement(d;"<Item Entry>"."Entry Type")
                {
                }
                fieldelement(e;"<Item Entry>"."Source No.")
                {
                }
                fieldelement(f;"<Item Entry>"."Document No.")
                {
                }
                fieldelement(g;"<Item Entry>".Description)
                {
                }
                fieldelement(h;"<Item Entry>"."Location Code")
                {
                }
                fieldelement(i;"<Item Entry>".Quantity)
                {
                }
                fieldelement(j;"<Item Entry>"."Global Dimension 1 Code")
                {
                }
                fieldelement(k;"<Item Entry>"."Global Dimension 2 Code")
                {
                }
                fieldelement(l;"<Item Entry>"."Source Type")
                {
                }
                fieldelement(m;"<Item Entry>"."Transaction Type")
                {
                }
                fieldelement(n;"<Item Entry>"."Document Date")
                {
                }
                fieldelement(o;"<Item Entry>"."External Document No.")
                {
                }
                fieldelement(p;"<Item Entry>"."Document Type")
                {
                }
                fieldelement(q;"<Item Entry>"."Order Type")
                {
                }
                fieldelement(r;"<Item Entry>"."Order No.")
                {
                }
                fieldelement(s;"<Item Entry>"."Unit of Measure Code")
                {
                }
                fieldelement(t;"<Item Entry>"."Purchasing Code")
                {
                }
                fieldelement(u;"<Item Entry>"."Purchase Amount (Actual)")
                {
                }
                fieldelement(r1;"<Item Entry>"."Sales Amount (Actual)")
                {
                }
                fieldelement(r2;"<Item Entry>"."Cost Amount (Actual)")
                {
                }

                trigger OnBeforeInsertRecord()
                begin
                        //Item."VAT Prod. Posting Group":='ZERO';

                end;
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

