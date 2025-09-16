#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 50030 "Pv lines"
{
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement("<fin-payment line>";UnknownTable61705)
            {
                AutoReplace = false;
                AutoUpdate = true;
                XmlName = 'Item';
                fieldelement(a;"<FIN-Payment Line>"."Line No.")
                {
                }
                fieldelement(c;"<FIN-Payment Line>".No)
                {
                }
                fieldelement(d;"<FIN-Payment Line>".Date)
                {
                }
                fieldelement(f;"<FIN-Payment Line>".Type)
                {
                }
                fieldelement(e;"<FIN-Payment Line>"."Pay Mode")
                {
                }
                fieldelement(g;"<FIN-Payment Line>"."Cheque No")
                {
                }
                fieldelement(k;"<FIN-Payment Line>"."Cheque Date")
                {
                }
                fieldelement(j;"<FIN-Payment Line>"."Cheque Type")
                {
                }
                fieldelement(l;"<FIN-Payment Line>"."Bank Code")
                {
                }
                fieldelement(m;"<FIN-Payment Line>"."Received From")
                {
                }
                fieldelement(n;"<FIN-Payment Line>"."On Behalf Of")
                {
                }
                fieldelement(o;"<FIN-Payment Line>".Cashier)
                {
                }
                fieldelement(p;"<FIN-Payment Line>"."Account Type")
                {
                }
                fieldelement(r;"<FIN-Payment Line>"."Account No.")
                {
                }
                fieldelement(s;"<FIN-Payment Line>"."Account Name")
                {
                }
                fieldelement(t;"<FIN-Payment Line>".Amount)
                {
                }
                fieldelement(u;"<FIN-Payment Line>"."VAT Code")
                {
                }
                fieldelement(v;"<FIN-Payment Line>"."Withholding Tax Code")
                {
                }
                fieldelement(w;"<FIN-Payment Line>"."VAT Amount")
                {
                }
                fieldelement(x;"<FIN-Payment Line>"."Withholding Tax Amount")
                {
                }
                fieldelement(y;"<FIN-Payment Line>"."Net Amount")
                {
                }
                fieldelement(z;"<FIN-Payment Line>"."Paying Bank Account")
                {
                }
                fieldelement(aa;"<FIN-Payment Line>".Payee)
                {
                }
                fieldelement(bb;"<FIN-Payment Line>"."Global Dimension 1 Code")
                {
                }
                fieldelement(cc;"<FIN-Payment Line>"."Branch Code")
                {
                }
                fieldelement(dd;"<FIN-Payment Line>"."PO/INV No")
                {
                }
                fieldelement(ee;"<FIN-Payment Line>"."Bank Account No")
                {
                }
                fieldelement(ff;"<FIN-Payment Line>"."Cashier Bank Account")
                {
                }
                fieldelement(gg;"<FIN-Payment Line>".Status)
                {
                }
                fieldelement(hh;"<FIN-Payment Line>".Select)
                {
                }
                fieldelement(ii;"<FIN-Payment Line>".Grouping)
                {
                }
                fieldelement(jj;"<FIN-Payment Line>"."Payment Type")
                {
                }
                fieldelement(kk;"<FIN-Payment Line>"."Bank Type")
                {
                }
                fieldelement(ll;"<FIN-Payment Line>"."PV Type")
                {
                }
                fieldelement(mm;"<FIN-Payment Line>"."Apply to")
                {
                }
                fieldelement(nn;"<FIN-Payment Line>"."Apply to ID")
                {
                }
                fieldelement(oo;"<FIN-Payment Line>"."No of Units")
                {
                }
                fieldelement(pp;"<FIN-Payment Line>"."Surrender Date")
                {
                }
                fieldelement(qq;"<FIN-Payment Line>".Surrendered)
                {
                }
                fieldelement(rr;"<FIN-Payment Line>"."Surrender Doc. No")
                {
                }
                fieldelement(ss;"<FIN-Payment Line>"."Vote Book")
                {
                }
                fieldelement(tt;"<FIN-Payment Line>"."Total Allocation")
                {
                }
                fieldelement(uu;"<FIN-Payment Line>"."Total Expenditure")
                {
                }
                fieldelement(vv;"<FIN-Payment Line>"."Total Commitments")
                {
                }
                fieldelement(ww;"<FIN-Payment Line>".Balance)
                {
                }
                fieldelement(xx;"<FIN-Payment Line>"."Petty Cash")
                {
                }
                fieldelement(yy;"<FIN-Payment Line>"."Supplier Invoice No.")
                {
                }
                fieldelement(zz;"<FIN-Payment Line>"."Shortcut Dimension 2 Code")
                {
                }
                fieldelement(aaa;"<FIN-Payment Line>"."Imprest Request No")
                {
                }
                fieldelement(bbb;"<FIN-Payment Line>"."Batched Imprest Tot")
                {
                }
                fieldelement(ccc;"<FIN-Payment Line>"."Function Name")
                {
                }
                fieldelement(ddd;"<FIN-Payment Line>"."Budget Center Name")
                {
                }
                fieldelement(eee;"<FIN-Payment Line>"."User ID")
                {
                }
                fieldelement(fff;"<FIN-Payment Line>"."Journal Template")
                {
                }
                fieldelement(ggg;"<FIN-Payment Line>"."Journal Batch")
                {
                }
                fieldelement(hhh;"<FIN-Payment Line>"."Require Surrender")
                {
                }
                fieldelement(iii;"<FIN-Payment Line>"."Select to Surrender")
                {
                }
                fieldelement(jjj;"<FIN-Payment Line>"."Payment Reference")
                {
                }
                fieldelement(kkk;"<FIN-Payment Line>"."VAT Rate")
                {
                }
                fieldelement(lll;"<FIN-Payment Line>"."Amount With VAT")
                {
                }
                fieldelement(mmm;"<FIN-Payment Line>"."Exchange Rate")
                {
                }
                fieldelement(nnn;"<FIN-Payment Line>"."Currency Reciprical")
                {
                }
                fieldelement(ooo;"<FIN-Payment Line>"."VAT Prod. Posting Group")
                {
                }
                fieldelement(ppp;"<FIN-Payment Line>"."Budgetary Control A/C")
                {
                }
                fieldelement(qqq;"<FIN-Payment Line>"."Shortcut Dimension 3 Code")
                {
                }
                fieldelement(rrr;"<FIN-Payment Line>"."Shortcut Dimension 4 Code")
                {
                }
                fieldelement(sss;"<FIN-Payment Line>".Committed)
                {
                }
                fieldelement(ttt;"<FIN-Payment Line>"."NetAmount LCY")
                {
                }
                fieldelement(ttty;"<FIN-Payment Line>"."Applies-to Doc. Type")
                {
                }
                fieldelement(uuu;"<FIN-Payment Line>"."Applies-to Doc. No.")
                {
                }
                fieldelement(vvv;"<FIN-Payment Line>"."Applies-to ID")
                {
                }
                fieldelement(www;"<FIN-Payment Line>"."Retention Code")
                {
                }
                fieldelement(xxx;"<FIN-Payment Line>"."Retention  Amount")
                {
                }
                fieldelement(yyy;"<FIN-Payment Line>"."Retention Rate")
                {
                }
                fieldelement(zzz;"<FIN-Payment Line>"."W/Tax Rate")
                {
                }
                fieldelement(az;"<FIN-Payment Line>"."Document Type")
                {
                }
                fieldelement(bz;"<FIN-Payment Line>"."Document No")
                {
                }
                fieldelement(cz;"<FIN-Payment Line>"."Document Line")
                {
                }
                fieldelement(dz;"<FIN-Payment Line>"."PAYE Amount")
                {
                }
                fieldelement(ez;"<FIN-Payment Line>"."PAYE Code")
                {
                }
                fieldelement(fz;"<FIN-Payment Line>"."Budget Balance")
                {
                }
                fieldelement(hz;"<FIN-Payment Line>"."VAT Withheld Amount")
                {
                }
                fieldelement(iz;"<FIN-Payment Line>"."VAT Withheld Code")
                {
                }
                fieldelement(jz;"<FIN-Payment Line>"."VAT Six % Rate")
                {
                }
                fieldelement(kz;"<FIN-Payment Line>"."Not Vatable")
                {
                }
                fieldelement(lz;"<FIN-Payment Line>"."PAYE Rate")
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

