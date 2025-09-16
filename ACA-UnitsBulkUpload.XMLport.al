#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 50206 "ACA-Units Bulk Upload"
{
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement("ACA-Bulk Units Reg. Det";"ACA-Bulk Units Reg. Det")
            {
                AutoReplace = true;
                XmlName = 'Item';
                fieldelement(a;"ACA-Bulk Units Reg. Det"."Semester Code")
                {
                }
                fieldelement(b;"ACA-Bulk Units Reg. Det"."Program Code")
                {
                }
                fieldelement(c;"ACA-Bulk Units Reg. Det"."Unit Code")
                {
                }
                fieldelement(d;"ACA-Bulk Units Reg. Det"."Student No.")
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

