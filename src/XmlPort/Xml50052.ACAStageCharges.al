#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 50052 "ACA-Stage Charges"
{
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement(UnknownTable61533;UnknownTable61533)
            {
                AutoReplace = true;
                XmlName = 'Programmes';
                fieldelement(a;"ACA-Stage Charges"."Programme Code")
                {
                }
                fieldelement(b;"ACA-Stage Charges"."Stage Code")
                {
                }
                fieldelement(c;"ACA-Stage Charges".Code)
                {
                }
                fieldelement(d;"ACA-Stage Charges".Description)
                {
                }
                fieldelement(e;"ACA-Stage Charges".Amount)
                {
                }
                fieldelement(f;"ACA-Stage Charges".Remarks)
                {
                }
                fieldelement(g;"ACA-Stage Charges"."Recovered First")
                {
                }
                fieldelement(h;"ACA-Stage Charges".Semester)
                {
                }
                fieldelement(i;"ACA-Stage Charges"."Student Type")
                {
                }
                fieldelement(j;"ACA-Stage Charges"."Settlement Type")
                {
                }
                fieldelement(k;"ACA-Stage Charges"."Recovery Priority")
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

