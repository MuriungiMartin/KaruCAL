#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 5902 "Import IRIS to Resol. Codes"
{
    Caption = 'Import IRIS to Resol. Codes';
    Direction = Import;
    FieldDelimiter = '<None>';
    FieldSeparator = '<TAB>';
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement("Resolution Code";"Resolution Code")
            {
                XmlName = 'ResolutionCode';
                fieldelement(Code;"Resolution Code".Code)
                {
                }
                fieldelement(Description;"Resolution Code".Description)
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

