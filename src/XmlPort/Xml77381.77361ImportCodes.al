#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 77381 "77361 Import Codes"
{
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement(bankingdets;UnknownTable77361)
            {
                AutoUpdate = false;
                XmlName = 'Item';
                fieldelement(a;BankingDets."Document Code")
                {
                }
                fieldelement(b;BankingDets.Sequence)
                {
                }
                fieldelement(c;BankingDets."Next Sequence")
                {
                }
                fieldelement(d;BankingDets."First Stage")
                {
                }
                fieldelement(e;BankingDets."Next Sequence")
                {
                }
                fieldelement(f;BankingDets.Mandatory)
                {
                }
                fieldelement(g;BankingDets.Approvers)
                {
                }
                fieldelement(h;BankingDets."Is Hostel")
                {
                }
                fieldelement(i;BankingDets."Academic Year")
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

