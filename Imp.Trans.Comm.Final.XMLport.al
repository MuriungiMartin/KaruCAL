#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 50165 "Imp. Trans. Comm. Final"
{
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement(UnknownTable66661;UnknownTable66661)
            {
                AutoReplace = false;
                AutoUpdate = true;
                XmlName = 'FA';
                fieldelement(a;"ACA-Final Grade Setup"."Exam Catregory")
                {
                }
                fieldelement(b;"ACA-Final Grade Setup"."Minimum Score")
                {
                }
                fieldelement(c;"ACA-Final Grade Setup"."Maximum Score")
                {
                    MinOccurs = Zero;
                }
                fieldelement(d;"ACA-Final Grade Setup".Grade)
                {
                }
                fieldelement(e;"ACA-Final Grade Setup".Pass)
                {
                }
                fieldelement(f;"ACA-Final Grade Setup".Remarks)
                {
                    MinOccurs = Zero;
                }
                fieldelement(g;"ACA-Final Grade Setup"."Missing CAT")
                {
                }
                fieldelement(h;"ACA-Final Grade Setup"."Missing Exam")
                {
                }
                fieldelement(i;"ACA-Final Grade Setup"."Override Transcript Comments")
                {
                    MinOccurs = Zero;
                }
                fieldelement(j;"ACA-Final Grade Setup"."Missed Both CAT & Exam")
                {
                    MinOccurs = Zero;
                }
                fieldelement(k;"ACA-Final Grade Setup"."Less Courses")
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

