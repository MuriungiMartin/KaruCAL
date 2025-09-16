#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 50058 "Student Units live"
{
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement(UnknownTable61549;UnknownTable61549)
            {
                AutoUpdate = true;
                XmlName = 'Item';
                fieldelement(a;"ACA-Student Units".Programme)
                {
                }
                fieldelement(b;"ACA-Student Units".Stage)
                {
                }
                fieldelement(c;"ACA-Student Units".Unit)
                {
                }
                fieldelement(d;"ACA-Student Units".Semester)
                {
                }
                fieldelement(e;"ACA-Student Units"."Reg. Transacton ID")
                {
                }
                fieldelement(f;"ACA-Student Units"."Student No.")
                {
                }
                fieldelement(b1;"ACA-Student Units".ENo)
                {
                }
                fieldelement(g;"ACA-Student Units".Taken)
                {
                }
                fieldelement(h;"ACA-Student Units"."Unit Stage")
                {
                }
                fieldelement(i;"ACA-Student Units".Failed)
                {
                }
                fieldelement(b2;"ACA-Student Units"."No. Of Units")
                {
                }
                fieldelement(j;"ACA-Student Units"."Final Score")
                {
                }
                fieldelement(k;"ACA-Student Units"."Total Marks")
                {
                }
                fieldelement(h;"ACA-Student Units".Description)
                {
                }
                fieldelement(b2;"ACA-Student Units"."Result Status")
                {
                }
                fieldelement(b3;"ACA-Student Units"."Exam Status")
                {
                }
                fieldelement(i;"ACA-Student Units".Grade)
                {
                }
                fieldelement(j;"ACA-Student Units".Reversed)
                {
                }
                fieldelement(z;"ACA-Student Units"."Credited Hours")
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

