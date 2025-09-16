#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 50162 "Imp.Exam Setup"
{
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement(UnknownTable61567;UnknownTable61567)
            {
                AutoReplace = false;
                AutoUpdate = true;
                XmlName = 'FA';
                fieldelement(a;"ACA-Exams Setup".Category)
                {
                }
                fieldelement(b;"ACA-Exams Setup".Code)
                {
                }
                fieldelement(c;"ACA-Exams Setup".Desription)
                {
                    MinOccurs = Zero;
                }
                fieldelement(d;"ACA-Exams Setup"."Max. Score")
                {
                }
                fieldelement(e;"ACA-Exams Setup"."% Contrib. Final Score")
                {
                }
                fieldelement(f;"ACA-Exams Setup".Amount)
                {
                    MinOccurs = Zero;
                }
                fieldelement(g;"ACA-Exams Setup"."G/L Account")
                {
                }
                fieldelement(h;"ACA-Exams Setup".Department)
                {
                }
                fieldelement(i;"ACA-Exams Setup".Remarks)
                {
                    MinOccurs = Zero;
                }
                fieldelement(j;"ACA-Exams Setup".Type)
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

