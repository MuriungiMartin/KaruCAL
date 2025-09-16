#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 50187 "Import KUCCPS Students"
{
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement("text kuccps jab";UnknownTable70082)
            {
                AutoUpdate = false;
                XmlName = 'Item';
                fieldelement(a;"Text KUCCPS Jab".ser)
                {
                }
                fieldelement(n;"Text KUCCPS Jab"."Academic Year")
                {
                    MinOccurs = Zero;
                }
                fieldelement(b;"Text KUCCPS Jab".Index)
                {
                }
                fieldelement(c;"Text KUCCPS Jab".Admin)
                {
                }
                fieldelement(d;"Text KUCCPS Jab".Prog)
                {
                }
                fieldelement(e;"Text KUCCPS Jab".Names)
                {
                }
                fieldelement(f;"Text KUCCPS Jab".Gender)
                {
                }
                fieldelement(g;"Text KUCCPS Jab".Phone)
                {
                    MinOccurs = Zero;
                }
                fieldelement(h;"Text KUCCPS Jab"."Alt. Phone")
                {
                    MinOccurs = Zero;
                }
                fieldelement(i;"Text KUCCPS Jab".Box)
                {
                    MinOccurs = Once;
                }
                fieldelement(j;"Text KUCCPS Jab".Codes)
                {
                    MinOccurs = Zero;
                }
                fieldelement(k;"Text KUCCPS Jab".Town)
                {
                    MinOccurs = Once;
                }
                fieldelement(l;"Text KUCCPS Jab".Email)
                {
                    MaxOccurs = Once;
                    MinOccurs = Zero;
                }
                fieldelement(m;"Text KUCCPS Jab"."Slt Mail")
                {
                    MinOccurs = Zero;
                }
                fieldelement(o;"Text KUCCPS Jab"."Settlement Type")
                {
                }
                fieldelement(n;"Text KUCCPS Jab"."Funding Category")
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

