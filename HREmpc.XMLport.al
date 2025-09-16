#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 50062 HREmpc
{
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement("hr-employee";UnknownTable61188)
            {
                AutoUpdate = true;
                XmlName = 'Item';
                SourceTableView = where(Field31=filter(0));
                fieldelement(a;"HR-Employee"."No.")
                {
                }
                fieldelement(b;"HR-Employee"."Pension Scheme Join")
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

