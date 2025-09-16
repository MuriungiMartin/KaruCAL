#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 50070 "Phone Nos"
{
    Format = VariableText;

    schema
    {
        textelement(Roots)
        {
            tableelement(UnknownTable90012;UnknownTable90012)
            {
                XmlName = 'PhoneNo';
                fieldelement(a1;"Kuccps Phone Nos"."Serial No")
                {
                }
                fieldelement(a2;"Kuccps Phone Nos"."Phione No.")
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

