#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 9171 "Import/Export Permission Sets"
{
    Caption = 'Import/Export Permission Sets';
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement("Permission Set";"Permission Set")
            {
                XmlName = 'UserRole';
                fieldelement(RoleID;"Permission Set"."Role ID")
                {
                }
                fieldelement(Name;"Permission Set".Name)
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

