#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 50020 "FIN-Receipts Header"
{
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement(UnknownTable61723;UnknownTable61723)
            {
                AutoReplace = false;
                AutoUpdate = true;
                XmlName = 'Item';
                fieldelement(a;"FIN-Receipts Header"."No.")
                {
                }
                fieldelement(c;"FIN-Receipts Header".Date)
                {
                }
                fieldelement(d;"FIN-Receipts Header".Cashier)
                {
                }
                fieldelement(f;"FIN-Receipts Header"."Date Posted")
                {
                }
                fieldelement(g;"FIN-Receipts Header".Posted)
                {
                }
                fieldelement(k;"FIN-Receipts Header"."No. Series")
                {
                }
                fieldelement(j;"FIN-Receipts Header"."Bank Code")
                {
                }
                fieldelement(l;"FIN-Receipts Header"."Received From")
                {
                }
                fieldelement(m;"FIN-Receipts Header"."On Behalf Of")
                {
                }
                fieldelement(n;"FIN-Receipts Header"."Amount Recieved")
                {
                }
                fieldelement(o;"FIN-Receipts Header"."Global Dimension 1 Code")
                {
                }
                fieldelement(p;"FIN-Receipts Header"."Shortcut Dimension 2 Code")
                {
                }
                fieldelement(r;"FIN-Receipts Header"."Currency Code")
                {
                }
                fieldelement(s;"FIN-Receipts Header"."Currency Factor")
                {
                }
                fieldelement(t;"FIN-Receipts Header"."Posted By")
                {
                }
                fieldelement(u;"FIN-Receipts Header"."Print No.")
                {
                }
                fieldelement(v;"FIN-Receipts Header".Status)
                {
                }
                fieldelement(w;"FIN-Receipts Header"."Cheque No.")
                {
                }
                fieldelement(x;"FIN-Receipts Header"."No. Printed")
                {
                }
                fieldelement(y;"FIN-Receipts Header"."Created By")
                {
                }
                fieldelement(aa;"FIN-Receipts Header"."Register No.")
                {
                }
                fieldelement(bb;"FIN-Receipts Header"."From Entry No.")
                {
                }
                fieldelement(cc;"FIN-Receipts Header"."To Entry No.")
                {
                }
                fieldelement(dd;"FIN-Receipts Header"."Document Date")
                {
                }
                fieldelement(ee;"FIN-Receipts Header"."Responsibility Center")
                {
                }
                fieldelement(ff;"FIN-Receipts Header"."Shortcut Dimension 3 Code")
                {
                }
                fieldelement(gg;"FIN-Receipts Header"."Shortcut Dimension 4 Code")
                {
                }
                fieldelement(hh;"FIN-Receipts Header".Dim3)
                {
                }
                fieldelement(ii;"FIN-Receipts Header".Dim4)
                {
                }
                fieldelement(jj;"FIN-Receipts Header"."Bank Name")
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

