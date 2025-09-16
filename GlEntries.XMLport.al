#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 50064 "Gl Entries"
{
    Format = VariableText;

    schema
    {
        textelement(Roots)
        {
            tableelement("G/L Entry";"G/L Entry")
            {
                XmlName = 'Gledgers';
                SourceTableView = where("Posting Date"=filter(04;
                fieldelement(a;"G/L Entry"."Entry No.")
                {
                }
                fieldelement(b;"G/L Entry"."Posting Date")
                {
                }
                fieldelement(c;"G/L Entry"."Document No.")
                {
                }
                fieldelement(d;"G/L Entry"."G/L Account No.")
                {
                }
                fieldelement(e;"G/L Entry".Description)
                {
                }
                fieldelement(f;"G/L Entry".Amount)
                {
                }
                fieldelement(h;"G/L Entry"."Global Dimension 1 Code")
                {
                }
                fieldelement(i;"G/L Entry"."Global Dimension 2 Code")
                {
                }
                fieldelement(j;"G/L Entry"."Bal. Account No.")
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

