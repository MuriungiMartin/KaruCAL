#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 50163 "Imp.Transcript Comments"
{
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement(UnknownTable78020;UnknownTable78020)
            {
                AutoReplace = false;
                AutoUpdate = true;
                XmlName = 'FA';
                fieldelement(a;"ACA-Prog. Cat. Transcript Comm"."Exam Catogory")
                {
                }
                fieldelement(b;"ACA-Prog. Cat. Transcript Comm"."Year of Study")
                {
                }
                fieldelement(c;"ACA-Prog. Cat. Transcript Comm"."Pass Comment")
                {
                    MinOccurs = Zero;
                }
                fieldelement(d;"ACA-Prog. Cat. Transcript Comm"."Failed Comment")
                {
                }
                fieldelement(e;"ACA-Prog. Cat. Transcript Comm"."Include Programme Name")
                {
                }
                fieldelement(f;"ACA-Prog. Cat. Transcript Comm"."Include Classification")
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

