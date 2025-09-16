#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 50026 "FIN-Receipt Line q"
{
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement(UnknownTable61717;UnknownTable61717)
            {
                AutoReplace = false;
                AutoUpdate = true;
                XmlName = 'Item';
                fieldelement(a;"FIN-Receipt Line q"."Line No.")
                {
                }
                fieldelement(c;"FIN-Receipt Line q".No)
                {
                }
                fieldelement(d;"FIN-Receipt Line q".Date)
                {
                }
                fieldelement(f;"FIN-Receipt Line q".Type)
                {
                }
                fieldelement(e;"FIN-Receipt Line q"."Pay Mode")
                {
                }
                fieldelement(g;"FIN-Receipt Line q"."Cheque/Deposit Slip No")
                {
                }
                fieldelement(k;"FIN-Receipt Line q"."Cheque/Deposit Slip Date")
                {
                }
                fieldelement(j;"FIN-Receipt Line q"."Cheque/Deposit Slip Type")
                {
                }
                fieldelement(l;"FIN-Receipt Line q"."Bank Code")
                {
                }
                fieldelement(m;"FIN-Receipt Line q"."Received From")
                {
                }
                fieldelement(n;"FIN-Receipt Line q"."On Behalf Of")
                {
                }
                fieldelement(o;"FIN-Receipt Line q".Cashier)
                {
                }
                fieldelement(p;"FIN-Receipt Line q"."Account Type")
                {
                }
                fieldelement(r;"FIN-Receipt Line q"."Account No.")
                {
                }
                fieldelement(s;"FIN-Receipt Line q"."Account Name")
                {
                }
                fieldelement(t;"FIN-Receipt Line q".Posted)
                {
                }
                fieldelement(u;"FIN-Receipt Line q"."Date Posted")
                {
                }
                fieldelement(w;"FIN-Receipt Line q"."Posted By")
                {
                }
                fieldelement(x;"FIN-Receipt Line q".Amount)
                {
                }
                fieldelement(y;"FIN-Receipt Line q".Remarks)
                {
                }
                fieldelement(z;"FIN-Receipt Line q"."Transaction Name")
                {
                }
                fieldelement(aa;"FIN-Receipt Line q".Grouping)
                {
                }
                fieldelement(bb;"FIN-Receipt Line q"."Global Dimension 1 Code")
                {
                }
                fieldelement(cc;"FIN-Receipt Line q"."Shortcut Dimension 2 Code")
                {
                }
                fieldelement(dd;"FIN-Receipt Line q"."Total Amount")
                {
                }
                fieldelement(ee;"FIN-Receipt Line q"."User ID")
                {
                }
                fieldelement(ff;"FIN-Receipt Line q"."Apply to")
                {
                }
                fieldelement(gg;"FIN-Receipt Line q"."Apply to ID")
                {
                }
                fieldelement(hh;"FIN-Receipt Line q"."Dest Global Dimension 1 Code")
                {
                }
                fieldelement(ii;"FIN-Receipt Line q"."Dest Shortcut Dimension 2 Code")
                {
                }
                fieldelement(jj;"FIN-Receipt Line q".Status)
                {
                }
                fieldelement(kk;"FIN-Receipt Line q"."Transaction No.")
                {
                }
                fieldelement(ll;"FIN-Receipt Line q"."Cheque/Deposit Slip Bank")
                {
                }
                fieldelement(hhhh;"FIN-Receipt Line q"."Bank Account")
                {
                }
                fieldelement(mm;"FIN-Receipt Line q".Confirmed)
                {
                }
                fieldelement(nn;"FIN-Receipt Line q".Reconciled)
                {
                }
                fieldelement(oo;"FIN-Receipt Line q".Cancelled)
                {
                }
                fieldelement(pp;"FIN-Receipt Line q"."Cancelled By")
                {
                }
                fieldelement(qq;"FIN-Receipt Line q"."Cancelled Date")
                {
                }
                fieldelement(ss;"FIN-Receipt Line q"."Post Dated")
                {
                }
                fieldelement(tt;"FIN-Receipt Line q"."Applies-to Doc. Type")
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

