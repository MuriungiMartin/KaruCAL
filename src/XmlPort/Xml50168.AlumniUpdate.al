#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 50168 "Alumni Update"
{
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement(UnknownTable78034;UnknownTable78034)
            {
                AutoReplace = false;
                AutoUpdate = true;
                XmlName = 'Item';
                fieldelement(a;"ACA-Graduated Students Upload"."Student No.")
                {
                }
                fieldelement(b;"ACA-Graduated Students Upload"."Graduation Year")
                {
                }
                fieldelement(c;"ACA-Graduated Students Upload"."Graduation Date")
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

