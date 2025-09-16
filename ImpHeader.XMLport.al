#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 50033 "Imp  Header"
{
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement(UnknownTable61704;UnknownTable61704)
            {
                AutoReplace = false;
                AutoUpdate = true;
                XmlName = 'Item';
                fieldelement(a;"FIN-Imprest Header"."No.")
                {
                }
                fieldelement(c;"FIN-Imprest Header".Date)
                {
                }
                fieldelement(d;"FIN-Imprest Header"."Currency Factor")
                {
                }
                fieldelement(f;"FIN-Imprest Header"."Currency Code")
                {
                }
                fieldelement(e;"FIN-Imprest Header".Payee)
                {
                }
                fieldelement(g;"FIN-Imprest Header"."On Behalf Of")
                {
                }
                fieldelement(k;"FIN-Imprest Header".Cashier)
                {
                }
                fieldelement(j;"FIN-Imprest Header".Posted)
                {
                }
                fieldelement(l;"FIN-Imprest Header"."Date Posted")
                {
                }
                fieldelement(m;"FIN-Imprest Header"."Time Posted")
                {
                }
                fieldelement(n;"FIN-Imprest Header"."Posted By")
                {
                }
                fieldelement(o;"FIN-Imprest Header"."Paying Bank Account")
                {
                }
                fieldelement(p;"FIN-Imprest Header"."Global Dimension 1 Code")
                {
                }
                fieldelement(r;"FIN-Imprest Header".Status)
                {
                }
                fieldelement(s;"FIN-Imprest Header"."Payment Type")
                {
                }
                fieldelement(t;"FIN-Imprest Header"."Shortcut Dimension 2 Code")
                {
                }
                fieldelement(u;"FIN-Imprest Header"."Function Name")
                {
                }
                fieldelement(v;"FIN-Imprest Header"."Budget Center Name")
                {
                }
                fieldelement(w;"FIN-Imprest Header"."Bank Name")
                {
                }
                fieldelement(x;"FIN-Imprest Header"."No. Series")
                {
                }
                fieldelement(y;"FIN-Imprest Header".Select)
                {
                }
                fieldelement(z;"FIN-Imprest Header"."Current Status")
                {
                }
                fieldelement(aa;"FIN-Imprest Header"."Cheque No.")
                {
                }
                fieldelement(bb;"FIN-Imprest Header"."Pay Mode")
                {
                }
                fieldelement(cc;"FIN-Imprest Header"."Payment Release Date")
                {
                }
                fieldelement(dd;"FIN-Imprest Header"."No. Printed")
                {
                }
                fieldelement(ee;"FIN-Imprest Header"."VAT Base Amount")
                {
                }
                fieldelement(ff;"FIN-Imprest Header"."Exchange Rate")
                {
                }
                fieldelement(gg;"FIN-Imprest Header"."Currency Reciprical")
                {
                }
                fieldelement(hh;"FIN-Imprest Header"."Current Source A/C Bal.")
                {
                }
                fieldelement(ii;"FIN-Imprest Header"."Cancellation Remarks")
                {
                }
                fieldelement(jj;"FIN-Imprest Header"."Register Number")
                {
                }
                fieldelement(kk;"FIN-Imprest Header"."From Entry No.")
                {
                }
                fieldelement(ll;"FIN-Imprest Header"."To Entry No.")
                {
                }
                fieldelement(hhhh;"FIN-Imprest Header"."Invoice Currency Code")
                {
                }
                fieldelement(mm;"FIN-Imprest Header"."Document Type")
                {
                }
                fieldelement(nn;"FIN-Imprest Header"."Shortcut Dimension 3 Code")
                {
                }
                fieldelement(oo;"FIN-Imprest Header"."Shortcut Dimension 4 Code")
                {
                }
                fieldelement(pp;"FIN-Imprest Header".Dim3)
                {
                }
                fieldelement(qq;"FIN-Imprest Header".Dim4)
                {
                }
                fieldelement(rr;"FIN-Imprest Header"."Responsibility Center")
                {
                }
                fieldelement(ss;"FIN-Imprest Header"."Account Type")
                {
                }
                fieldelement(tt;"FIN-Imprest Header"."Account No.")
                {
                }
                fieldelement(uu;"FIN-Imprest Header"."Surrender Status")
                {
                }
                fieldelement(vv;"FIN-Imprest Header".Purpose)
                {
                }
                fieldelement(ww;"FIN-Imprest Header"."Payment Voucher No")
                {
                }
                fieldelement(xx;"FIN-Imprest Header"."Serial No.")
                {
                }
                fieldelement(yy;"FIN-Imprest Header"."Budgeted Amount")
                {
                }
                fieldelement(zz;"FIN-Imprest Header"."Actual Expenditure")
                {
                }
                fieldelement(aaa;"FIN-Imprest Header"."Committed Amount")
                {
                }
                fieldelement(bbb;"FIN-Imprest Header"."Budget Balance")
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

