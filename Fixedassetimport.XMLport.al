#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 50039 "Fixed asset import"
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
                fieldelement(d;"<5600>"."FA Subclass Code")
                {
                }
                fieldelement(e;"<5600>"."FA Posting Group")
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

