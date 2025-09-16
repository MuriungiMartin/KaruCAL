#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 50069 "Bulky Sms Lines"
{
    Format = VariableText;

    schema
    {
        textelement(Roots)
        {
            tableelement(UnknownTable70702;UnknownTable70702)
            {
                XmlName = 'BulkySms';
                fieldelement(A5;"Bulk SMS Recipient"."SMS Code")
                {
                }
                fieldelement(a1;"Bulk SMS Recipient"."Recepient Type")
                {
                }
                fieldelement(a2;"Bulk SMS Recipient"."Recipient No.")
                {
                }
                fieldelement(a3;"Bulk SMS Recipient".Phone)
                {
                    MinOccurs = Zero;
                }
                fieldelement(a4;"Bulk SMS Recipient"."Message 1")
                {
                    MinOccurs = Zero;
                }
                fieldelement(A6;"Bulk SMS Recipient"."Message 2")
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

