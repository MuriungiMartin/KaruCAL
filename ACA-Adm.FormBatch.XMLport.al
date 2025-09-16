#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 50044 "ACA-Adm. Form Batch"
{
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement(UnknownTable61368;UnknownTable61368)
            {
                AutoReplace = true;
                XmlName = 'Programmes';
                fieldelement(a;"ACA-Adm. Form Batch"."Batch No.")
                {
                }
                fieldelement(b;"ACA-Adm. Form Batch"."Batch Date")
                {
                }
                fieldelement(c;"ACA-Adm. Form Batch"."Batch Time")
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

