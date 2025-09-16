#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 50161 "Imp. Graduating Groups"
{
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement("ACA-Graduation Groups";"ACA-Graduation Groups")
            {
                AutoReplace = false;
                AutoUpdate = true;
                XmlName = 'FA';
                fieldelement(a;"ACA-Graduation Groups"."Exam Category")
                {
                }
                fieldelement(b;"ACA-Graduation Groups"."Academic Year")
                {
                }
                fieldelement(c;"ACA-Graduation Groups"."Graduation Group")
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

