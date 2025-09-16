#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 77380 "Import Core Banking Details"
{
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement(bankingdets;Core_Banking_Details)
            {
                AutoUpdate = false;
                XmlName = 'Item';
                fieldelement(a;BankingDets."Transaction Date")
                {
                }
                fieldelement(b;BankingDets.Bank_Code)
                {
                }
                fieldelement(c;BankingDets."Student No.")
                {
                }
                fieldelement(d;BankingDets."Transaction Number")
                {
                }
                fieldelement(e;BankingDets."Transaction Description")
                {
                }
                fieldelement(f;BankingDets."Trans. Amount")
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

