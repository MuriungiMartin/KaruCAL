#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 50167 "Sms-Batch Custom Lines"
{
    Format = VariableText;

    schema
    {
        textelement(Roots)
        {
            tableelement(UnknownTable70708;UnknownTable70708)
            {
                XmlName = 'smsCustomes';
                fieldelement(a1;"Sms-Custom Batch Line"."Batch No")
                {
                    MinOccurs = Zero;
                }
                fieldelement(a2;"Sms-Custom Batch Line"."Recepient Type")
                {
                }
                fieldelement(a3;"Sms-Custom Batch Line"."Phone Number")
                {
                }
                fieldelement(a4;"Sms-Custom Batch Line"."Reception No")
                {
                    MinOccurs = Zero;
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

