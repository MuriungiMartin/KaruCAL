#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 50032 "Imp Surr Det"
{
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement(UnknownTable61733;UnknownTable61733)
            {
                AutoReplace = false;
                AutoUpdate = true;
                XmlName = 'Item';
                fieldelement(a;"FIN-Imprest Surrender Details"."Surrender Doc No.")
                {
                }
                fieldelement(c;"FIN-Imprest Surrender Details"."Account No:")
                {
                }
                fieldelement(d;"FIN-Imprest Surrender Details"."Account Name")
                {
                }
                fieldelement(f;"FIN-Imprest Surrender Details".Amount)
                {
                }
                fieldelement(e;"FIN-Imprest Surrender Details"."Due Date")
                {
                }
                fieldelement(g;"FIN-Imprest Surrender Details"."Imprest Holder")
                {
                }
                fieldelement(k;"FIN-Imprest Surrender Details"."Actual Spent")
                {
                }
                fieldelement(j;"FIN-Imprest Surrender Details"."Apply to")
                {
                }
                fieldelement(l;"FIN-Imprest Surrender Details"."Apply to ID")
                {
                }
                fieldelement(m;"FIN-Imprest Surrender Details"."Surrender Date")
                {
                }
                fieldelement(n;"FIN-Imprest Surrender Details".Surrendered)
                {
                }
                fieldelement(o;"FIN-Imprest Surrender Details"."Cash Receipt No")
                {
                }
                fieldelement(p;"FIN-Imprest Surrender Details"."Date Issued")
                {
                }
                fieldelement(r;"FIN-Imprest Surrender Details"."Type of Surrender")
                {
                }
                fieldelement(s;"FIN-Imprest Surrender Details"."Dept. Vch. No.")
                {
                }
                fieldelement(t;"FIN-Imprest Surrender Details"."Cash Surrender Amt")
                {
                }
                fieldelement(u;"FIN-Imprest Surrender Details"."Bank/Petty Cash")
                {
                }
                fieldelement(v;"FIN-Imprest Surrender Details"."Shortcut Dimension 1 Code")
                {
                }
                fieldelement(w;"FIN-Imprest Surrender Details"."Shortcut Dimension 2 Code")
                {
                }
                fieldelement(x;"FIN-Imprest Surrender Details"."Shortcut Dimension 3 Code")
                {
                }
                fieldelement(y;"FIN-Imprest Surrender Details"."Shortcut Dimension 4 Code")
                {
                }
                fieldelement(z;"FIN-Imprest Surrender Details"."Shortcut Dimension 5 Code")
                {
                }
                fieldelement(aa;"FIN-Imprest Surrender Details"."Shortcut Dimension 6 Code")
                {
                }
                fieldelement(bb;"FIN-Imprest Surrender Details"."Shortcut Dimension 7 Code")
                {
                }
                fieldelement(cc;"FIN-Imprest Surrender Details"."Shortcut Dimension 8 Code")
                {
                }
                fieldelement(dd;"FIN-Imprest Surrender Details"."VAT Prod. Posting Group")
                {
                }
                fieldelement(ee;"FIN-Imprest Surrender Details"."Imprest Type")
                {
                }
                fieldelement(ff;"FIN-Imprest Surrender Details"."Currency Factor")
                {
                }
                fieldelement(gg;"FIN-Imprest Surrender Details"."Currency Code")
                {
                }
                fieldelement(hh;"FIN-Imprest Surrender Details"."Amount LCY")
                {
                }
                fieldelement(ii;"FIN-Imprest Surrender Details"."Cash Surrender Amt LCY")
                {
                }
                fieldelement(jj;"FIN-Imprest Surrender Details"."Imprest Req Amt LCY")
                {
                }
                fieldelement(kk;"FIN-Imprest Surrender Details"."Cash Receipt Amount")
                {
                }
                fieldelement(ll;"FIN-Imprest Surrender Details"."Cheque/Deposit Slip No")
                {
                }
                fieldelement(hhhh;"FIN-Imprest Surrender Details"."Cheque/Deposit Slip Date")
                {
                }
                fieldelement(mm;"FIN-Imprest Surrender Details"."Cheque/Deposit Slip Type")
                {
                }
                fieldelement(nn;"FIN-Imprest Surrender Details"."Cheque/Deposit Slip Bank")
                {
                }
                fieldelement(oo;"FIN-Imprest Surrender Details"."Cash Pay Mode")
                {
                }
                fieldelement(pp;"FIN-Imprest Surrender Details"."Over Expenditure")
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

