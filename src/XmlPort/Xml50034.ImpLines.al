#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 50034 "Imp Lines"
{
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement(UnknownTable61714;UnknownTable61714)
            {
                AutoReplace = false;
                AutoUpdate = true;
                XmlName = 'Item';
                fieldelement(a;"FIN-Imprest Lines".No)
                {
                }
                fieldelement(c;"FIN-Imprest Lines"."Advance Type")
                {
                }
                fieldelement(d;"FIN-Imprest Lines"."Shortcut Dimension 2 Code")
                {
                }
                fieldelement(f;"FIN-Imprest Lines"."Account No:")
                {
                }
                fieldelement(e;"FIN-Imprest Lines"."Account Name")
                {
                }
                fieldelement(g;"FIN-Imprest Lines".Amount)
                {
                }
                fieldelement(k;"FIN-Imprest Lines"."Due Date")
                {
                }
                fieldelement(j;"FIN-Imprest Lines"."Imprest Holder")
                {
                }
                fieldelement(l;"FIN-Imprest Lines"."Actual Spent")
                {
                }
                fieldelement(m;"FIN-Imprest Lines"."Global Dimension 1 Code")
                {
                }
                fieldelement(n;"FIN-Imprest Lines"."Apply to")
                {
                }
                fieldelement(o;"FIN-Imprest Lines"."Apply to ID")
                {
                }
                fieldelement(p;"FIN-Imprest Lines"."Surrender Date")
                {
                }
                fieldelement(r;"FIN-Imprest Lines".Surrendered)
                {
                }
                fieldelement(s;"FIN-Imprest Lines"."M.R. No")
                {
                }
                fieldelement(t;"FIN-Imprest Lines"."Date Issued")
                {
                }
                fieldelement(u;"FIN-Imprest Lines"."Type of Surrender")
                {
                }
                fieldelement(v;"FIN-Imprest Lines"."Dept. Vch. No.")
                {
                }
                fieldelement(w;"FIN-Imprest Lines"."Cash Surrender Amt")
                {
                }
                fieldelement(x;"FIN-Imprest Lines"."Bank/Petty Cash")
                {
                }
                fieldelement(y;"FIN-Imprest Lines"."Surrender Doc No.")
                {
                }
                fieldelement(z;"FIN-Imprest Lines"."Date Taken")
                {
                }
                fieldelement(aa;"FIN-Imprest Lines".Purpose)
                {
                }
                fieldelement(bb;"FIN-Imprest Lines"."Budgetary Control A/C")
                {
                }
                fieldelement(cc;"FIN-Imprest Lines"."Shortcut Dimension 3 Code")
                {
                }
                fieldelement(dd;"FIN-Imprest Lines"."Shortcut Dimension 4 Code")
                {
                }
                fieldelement(ee;"FIN-Imprest Lines".Committed)
                {
                }
                fieldelement(ff;"FIN-Imprest Lines"."Currency Factor")
                {
                }
                fieldelement(gg;"FIN-Imprest Lines"."Currency Code")
                {
                }
                fieldelement(hh;"FIN-Imprest Lines"."Amount LCY")
                {
                }
                fieldelement(ii;"FIN-Imprest Lines"."EFT Bank Account No")
                {
                }
                fieldelement(jj;"FIN-Imprest Lines"."EFT Bank Code")
                {
                }
                fieldelement(kk;"FIN-Imprest Lines"."EFT Account Name")
                {
                }
                fieldelement(ll;"FIN-Imprest Lines"."Budget Name")
                {
                }
                fieldelement(hhhh;"FIN-Imprest Lines"."Budgeted Amount")
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

