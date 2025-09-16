#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 50191 "Import Applications 3"
{
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement(UnknownTable61358;UnknownTable61358)
            {
                AutoUpdate = true;
                XmlName = 'Item';
                fieldelement(a;"ACA-Applic. Form Header"."Application No.")
                {
                }
                fieldelement(ggg;"ACA-Applic. Form Header".Status)
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

