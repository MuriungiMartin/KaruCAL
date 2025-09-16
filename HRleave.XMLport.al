#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 50166 HRleave
{
    Format = VariableText;
    FormatEvaluate = Xml;

    schema
    {
        textelement("<root>")
        {
            XmlName = 'Root';
            tableelement(UnknownTable61618;UnknownTable61618)
            {
                XmlName = 'HRleave';
                fieldelement(a;"HRM-Employee Leave Journal"."Line No.")
                {
                }
                fieldelement(b;"HRM-Employee Leave Journal"."Staff No.")
                {
                }
                fieldelement(c;"HRM-Employee Leave Journal"."Staff Name")
                {
                }
                fieldelement(d;"HRM-Employee Leave Journal"."Transaction Description")
                {
                }
                fieldelement(e;"HRM-Employee Leave Journal"."Leave Type")
                {
                }
                fieldelement(f;"HRM-Employee Leave Journal"."No. of Days")
                {
                }
                fieldelement(g;"HRM-Employee Leave Journal"."Transaction Type")
                {
                }
                fieldelement(j;"HRM-Employee Leave Journal"."Leave Period")
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

