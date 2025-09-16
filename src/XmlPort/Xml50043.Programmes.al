#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 50043 Programmes
{
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement(UnknownTable61511;UnknownTable61511)
            {
                AutoReplace = false;
                AutoUpdate = true;
                XmlName = 'Programmes';
                fieldelement(a;"ACA-Programme".Code)
                {
                }
                fieldelement(b;"ACA-Programme".Description)
                {
                }
                fieldelement(f;"ACA-Programme"."School Code")
                {
                }
                fieldelement(o;"ACA-Programme".Category)
                {
                }
                fieldelement(v;"ACA-Programme"."Department Code")
                {
                }
                fieldelement(w;"ACA-Programme"."Exam Category")
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

