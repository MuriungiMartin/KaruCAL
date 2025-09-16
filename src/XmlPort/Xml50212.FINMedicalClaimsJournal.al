#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 50212 "FIN-Medical Claims Journal"
{
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement(UnknownTable90023;UnknownTable90023)
            {
                AutoUpdate = true;
                XmlName = 'Item';
                fieldelement(a;"FIN-Medical Claims Journal"."Entry No.")
                {
                }
                fieldelement(b;"FIN-Medical Claims Journal"."Document No.")
                {
                }
                fieldelement(c;"FIN-Medical Claims Journal"."Staff No.")
                {
                }
                fieldelement(d;"FIN-Medical Claims Journal"."Transaction Type")
                {
                }
                fieldelement(e;"FIN-Medical Claims Journal".Amount)
                {
                }
                fieldelement(f;"FIN-Medical Claims Journal"."Claim Category")
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

