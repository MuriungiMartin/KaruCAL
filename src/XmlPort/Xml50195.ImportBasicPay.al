#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 50195 "Import Basic Pay"
{
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement(UnknownTable61105;UnknownTable61105)
            {
                AutoReplace = false;
                AutoUpdate = true;
                XmlName = 'Item';
                fieldelement(a;"PRL-Salary Card"."Employee Code")
                {
                }
                fieldelement(b;"PRL-Salary Card"."Basic Pay")
                {
                }
                fieldelement(c;"PRL-Salary Card"."Period Month")
                {
                }
                fieldelement(d;"PRL-Salary Card"."Period Year")
                {
                }
                fieldelement(e;"PRL-Salary Card"."Payroll Period")
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

