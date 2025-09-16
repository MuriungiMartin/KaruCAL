#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 50059 GLEntBack
{
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement(UnknownTable70071;UnknownTable70071)
            {
                AutoUpdate = true;
                XmlName = 'Item';
                fieldelement(a;"GLentry Backup"."Entry No")
                {
                }
                fieldelement(b;"GLentry Backup".Description)
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

