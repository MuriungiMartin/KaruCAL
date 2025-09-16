#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 50042 Pv
{
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement("<fin-payments header>";UnknownTable61688)
            {
                AutoReplace = false;
                AutoUpdate = true;
                XmlName = 'Item';
                fieldelement(a;"<FIN-Payments Header>"."No.")
                {
                }
                fieldelement(c;"<FIN-Payments Header>".Date)
                {
                }
                fieldelement(d;"<FIN-Payments Header>".Payee)
                {
                }
                fieldelement(f;"<FIN-Payments Header>"."On Behalf Of")
                {
                }
                fieldelement(e;"<FIN-Payments Header>".Cashier)
                {
                }
                fieldelement(g;"<FIN-Payments Header>".Posted)
                {
                }
                fieldelement(k;"<FIN-Payments Header>"."Posted By")
                {
                }
                fieldelement(j;"<FIN-Payments Header>"."Paying Bank Account")
                {
                }
                fieldelement(l;"<FIN-Payments Header>"."Global Dimension 1 Code")
                {
                }
                fieldelement(m;"<FIN-Payments Header>".Status)
                {
                }
                fieldelement(n;"<FIN-Payments Header>"."Payment Type")
                {
                }
                fieldelement(o;"<FIN-Payments Header>"."Shortcut Dimension 2 Code")
                {
                }
                fieldelement(p;"<FIN-Payments Header>"."Function Name")
                {
                }
                fieldelement(r;"<FIN-Payments Header>"."Budget Center Name")
                {
                }
                fieldelement(s;"<FIN-Payments Header>"."Bank Name")
                {
                }
                fieldelement(t;"<FIN-Payments Header>"."No. Series")
                {
                }
                fieldelement(y;"<FIN-Payments Header>"."Cheque No.")
                {
                }
                fieldelement(z;"<FIN-Payments Header>"."Pay Mode")
                {
                }
                fieldelement(a1;"<FIN-Payments Header>"."Payment Release Date")
                {
                }
                fieldelement(a2;"<FIN-Payments Header>"."Cheque Type")
                {
                }
                fieldelement(a5;"<FIN-Payments Header>"."Payment Narration")
                {
                }

                trigger OnBeforeInsertRecord()
                begin
                        //Item."VAT Prod. Posting Group":='ZERO';
                end;
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

