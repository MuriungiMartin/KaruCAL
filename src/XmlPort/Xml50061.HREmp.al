#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 50061 HREmp
{
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement("hr-employee";UnknownTable61118)
            {
                AutoUpdate = true;
                XmlName = 'Item';
                fieldelement(a;"HR-Employee"."No.")
                {
                }
                fieldelement(b;"HR-Employee"."ID Number")
                {
                }
                fieldelement(c;"HR-Employee"."NSSF No.")
                {
                }
                fieldelement(d;"HR-Employee"."NHIF No.")
                {
                }
                fieldelement(e;"HR-Employee"."PIN Number")
                {
                }
                fieldelement(f;"HR-Employee"."Main Bank")
                {
                }
                fieldelement(g;"HR-Employee"."Branch Bank")
                {
                }
                fieldelement(h;"HR-Employee"."Bank Account Number")
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

