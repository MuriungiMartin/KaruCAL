#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 50216 "General Ledgers"
{
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement("G/L Entry";"G/L Entry")
            {
                XmlName = 'GenLedgers';
                SourceTableView = where("Posting Date"=filter(>06;
                fieldelement(a;"G/L Entry"."Entry No.")
                {
                }
                fieldelement(b;"G/L Entry"."G/L Account No.")
                {
                }
                fieldelement(c;"G/L Entry"."Posting Date")
                {
                }
                fieldelement(d;"G/L Entry"."Document Type")
                {
                }
                fieldelement(e;"G/L Entry"."Document No.")
                {
                }
                fieldelement(f;"G/L Entry".Description)
                {
                }
                fieldelement(g;"G/L Entry"."Global Dimension 1 Code")
                {
                }
                fieldelement(h;"G/L Entry"."Global Dimension 2 Code")
                {
                }
                fieldelement(i;"G/L Entry"."Source Type")
                {
                }
                fieldelement(j;"G/L Entry"."Source No.")
                {
                }
                fieldelement(k;"G/L Entry".Reversed)
                {
                }
                fieldelement(l;"G/L Entry"."Reversed by Entry No.")
                {
                }
                fieldelement(m;"G/L Entry"."System-Created Entry")
                {
                }
                fieldelement(n;"G/L Entry"."Medical Claim 1")
                {
                }
                fieldelement(o;"G/L Entry"."PartTime Claim")
                {
                }
                fieldelement(p;"G/L Entry"."External Document No.")
                {
                }
                fieldelement(q;"G/L Entry".Amount)
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

