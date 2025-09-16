#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 50200 "Import payroll trans. 13th Sli"
{
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement(pertrans;UnknownTable99251)
            {
                AutoReplace = true;
                XmlName = 'Item';
                fieldelement(a;PerTrans."Employee Code")
                {
                }
                fieldelement(b;PerTrans."Transaction Code")
                {
                }
                fieldelement(c;PerTrans."Transaction Name")
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
                fieldelement(l;PerTrans."Current Instalment")
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

