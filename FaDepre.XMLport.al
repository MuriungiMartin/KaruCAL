#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 50037 "Fa Depre"
{
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement("<5600>";"Fixed Asset")
            {
                AutoReplace = false;
                AutoUpdate = true;
                XmlName = 'FA';
                fieldelement(A;"<5600>"."No.")
                {
                }
                fieldelement(c;"<5600>"."FA Class Code")
                {
                }
                fieldelement(d;"<5600>"."FA Subclass Code")
                {
                }
                fieldelement(f;"<5600>"."Tag No")
                {
                    MinOccurs = Zero;
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

