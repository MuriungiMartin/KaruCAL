#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 50192 "Import payroll transactions"
{
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement(pertrans;UnknownTable61091)
            {
                AutoUpdate = true;
                XmlName = 'Item';
                fieldelement(a;PerTrans."Employee Code")
                {
                }
                fieldelement(b;PerTrans."Transaction Code")
                {
                }
                fieldelement(d;PerTrans.Amount)
                {
                }
                fieldelement(e;PerTrans."Period Month")
                {
                }
                fieldelement(f;PerTrans."Period Year")
                {
                }
                fieldelement(g;PerTrans."Payroll Period")
                {
                }
                fieldelement(k;PerTrans."Recurance Index")
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

