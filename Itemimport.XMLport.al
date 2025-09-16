#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 50041 "Item import"
{
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement("<96>";"G/L Budget Entry")
            {
                AutoReplace = false;
                AutoUpdate = true;
                XmlName = 'jv';
                fieldelement(A;"<96>"."Entry No.")
                {
                }
                fieldelement(B;"<96>"."Budget Name")
                {
                }
                fieldelement(c;"<96>"."G/L Account No.")
                {
                }
                fieldelement(d;"<96>".Date)
                {
                }
                fieldelement(e;"<96>"."Global Dimension 1 Code")
                {
                }
                fieldelement(f;"<96>"."Global Dimension 2 Code")
                {
                }
                fieldelement(g;"<96>".Amount)
                {
                }
                fieldelement(h;"<96>".Description)
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

