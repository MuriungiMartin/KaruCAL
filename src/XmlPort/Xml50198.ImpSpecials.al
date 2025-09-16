#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 50198 "Imp. Specials"
{
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement(UnknownTable78002;UnknownTable78002)
            {
                AutoReplace = false;
                AutoUpdate = true;
                XmlName = 'Item';
                fieldelement(a;"Aca-Special Exams Details"."Academic Year")
                {
                }
                fieldelement(b;"Aca-Special Exams Details".Semester)
                {
                }
                fieldelement(c;"Aca-Special Exams Details"."Student No.")
                {
                }
                fieldelement(d;"Aca-Special Exams Details".Stage)
                {
                }
                fieldelement(e;"Aca-Special Exams Details".Programme)
                {
                }
                fieldelement(f;"Aca-Special Exams Details"."Unit Code")
                {
                }
                fieldelement(g;"Aca-Special Exams Details".Status)
                {
                }
                fieldelement(h;"Aca-Special Exams Details"."CAT Marks")
                {
                }
                fieldelement(i;"Aca-Special Exams Details"."Exam Marks")
                {
                }
                fieldelement(j;"Aca-Special Exams Details"."Total Marks")
                {
                }
                fieldelement(k;"Aca-Special Exams Details".Grade)
                {
                }
                fieldelement(l;"Aca-Special Exams Details".Category)
                {
                }
                fieldelement(m;"Aca-Special Exams Details"."Current Academic Year")
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

