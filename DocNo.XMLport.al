#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 50067 "Doc No"
{
    Format = VariableText;

    schema
    {
        textelement(root)
        {
            tableelement(UnknownTable99910;UnknownTable99910)
            {
                XmlName = 'docnos';
                fieldelement(a;"Doc No".ser)
                {
                }
                fieldelement(b;"Doc No"."Doc No")
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

