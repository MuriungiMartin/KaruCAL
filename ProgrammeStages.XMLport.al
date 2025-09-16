#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 50050 "Programme Stages"
{
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement(UnknownTable61516;UnknownTable61516)
            {
                AutoReplace = true;
                XmlName = 'Programmes';
                fieldelement(a;"ACA-Programme Stages"."Programme Code")
                {
                }
                fieldelement(b;"ACA-Programme Stages".Code)
                {
                }
                fieldelement(c;"ACA-Programme Stages".Description)
                {
                }
                fieldelement(d;"ACA-Programme Stages"."G/L Account")
                {
                }
                fieldelement(e;"ACA-Programme Stages".Department)
                {
                }
                fieldelement(f;"ACA-Programme Stages".Remarks)
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

