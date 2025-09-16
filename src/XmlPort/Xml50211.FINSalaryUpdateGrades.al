#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 50211 "FIN-Salary Update Grades"
{
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement(UnknownTable61118;UnknownTable61118)
            {
                AutoUpdate = true;
                XmlName = 'Item';
                fieldelement(a;"HRM-Employee (D)"."No.")
                {
                }
                fieldelement(b;"HRM-Employee (D)"."Salary Category")
                {
                }
                fieldelement(c;"HRM-Employee (D)"."Salary Grade")
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

