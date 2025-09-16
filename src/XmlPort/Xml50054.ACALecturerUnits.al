#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 50054 "ACA-Lecturer Units"
{
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement(UnknownTable61541;UnknownTable61541)
            {
                AutoReplace = true;
                XmlName = 'Programmes';
                fieldelement(a;"ACA-Lecturers Units".Programme)
                {
                }
                fieldelement(b;"ACA-Lecturers Units".Stage)
                {
                }
                fieldelement(c;"ACA-Lecturers Units".Unit)
                {
                }
                fieldelement(d;"ACA-Lecturers Units".Semester)
                {
                }
                fieldelement(e;"ACA-Lecturers Units".Lecturer)
                {
                }
                fieldelement(f;"ACA-Lecturers Units"."Campus Code")
                {
                }
                fieldelement(e;"ACA-Lecturers Units".Remarks)
                {
                }
                fieldelement(f;"ACA-Lecturers Units"."No. Of Hours")
                {
                }
                fieldelement(i;"ACA-Lecturers Units"."Minimum Contracted")
                {
                }
                fieldelement(j;"ACA-Lecturers Units".Class)
                {
                }
                fieldelement(k;"ACA-Lecturers Units"."Unit Class")
                {
                }
                fieldelement(l;"ACA-Lecturers Units"."Student Type")
                {
                }
                fieldelement(m;"ACA-Lecturers Units".Description)
                {
                }
                fieldelement(n;"ACA-Lecturers Units".Rate)
                {
                }
                fieldelement(o;"ACA-Lecturers Units".Claimed)
                {
                }
                fieldelement(p;"ACA-Lecturers Units"."Claimed Amount")
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

