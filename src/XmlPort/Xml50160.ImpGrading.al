#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 50160 "Imp. Grading"
{
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement(UnknownTable61599;UnknownTable61599)
            {
                AutoReplace = false;
                AutoUpdate = true;
                XmlName = 'FA';
                fieldelement(a;"ACA-Exam Gradding Setup".Category)
                {
                }
                fieldelement(b;"ACA-Exam Gradding Setup".Grade)
                {
                }
                fieldelement(c;"ACA-Exam Gradding Setup".Description)
                {
                    MinOccurs = Zero;
                }
                fieldelement(d;"ACA-Exam Gradding Setup"."Up to")
                {
                }
                fieldelement(e;"ACA-Exam Gradding Setup".Remarks)
                {
                }
                fieldelement(f;"ACA-Exam Gradding Setup".Failed)
                {
                    MinOccurs = Zero;
                }
                fieldelement(g;"ACA-Exam Gradding Setup".Range)
                {
                }
                fieldelement(h;"ACA-Exam Gradding Setup"."Results Exists Status")
                {
                }
                fieldelement(i;"ACA-Exam Gradding Setup"."Consolidated Prefix")
                {
                    MinOccurs = Zero;
                }
                fieldelement(j;"ACA-Exam Gradding Setup"."Lower Limit")
                {
                }
                fieldelement(k;"ACA-Exam Gradding Setup"."Upper Limit")
                {
                }
                fieldelement(l;"ACA-Exam Gradding Setup".Award)
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

