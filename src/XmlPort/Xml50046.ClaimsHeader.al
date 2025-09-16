#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 50046 "Claims  Header"
{
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement(UnknownTable61602;UnknownTable61602)
            {
                AutoReplace = false;
                AutoUpdate = true;
                XmlName = 'Item';
                fieldelement(a;"FIN-Staff Claims Header"."No.")
                {
                    FieldValidate = no;
                }
                fieldelement(c;"FIN-Staff Claims Header".Date)
                {
                }
                fieldelement(d;"FIN-Staff Claims Header".Payee)
                {
                    FieldValidate = no;
                }
                fieldelement(f;"FIN-Staff Claims Header"."On Behalf Of")
                {
                }
                fieldelement(e;"FIN-Staff Claims Header".Cashier)
                {
                }
                fieldelement(g;"FIN-Staff Claims Header".Posted)
                {
                }
                fieldelement(l;"FIN-Staff Claims Header"."Posted By")
                {
                    FieldValidate = no;
                }
                fieldelement(m;"FIN-Staff Claims Header"."Global Dimension 1 Code")
                {
                    FieldValidate = no;
                }
                fieldelement(n;"FIN-Staff Claims Header".Status)
                {
                }
                fieldelement(o;"FIN-Staff Claims Header"."Payment Type")
                {
                }
                fieldelement(p;"FIN-Staff Claims Header"."Shortcut Dimension 2 Code")
                {
                    FieldValidate = no;
                }
                fieldelement(r;"FIN-Staff Claims Header"."Function Name")
                {
                }
                fieldelement(s;"FIN-Staff Claims Header"."Bank Name")
                {
                }
                fieldelement(t;"FIN-Staff Claims Header"."No. Series")
                {
                }
                fieldelement(u;"FIN-Staff Claims Header".Select)
                {
                }
                fieldelement(v;"FIN-Staff Claims Header"."Current Status")
                {
                }
                fieldelement(w;"FIN-Staff Claims Header"."Cheque No.")
                {
                }
                fieldelement(x;"FIN-Staff Claims Header"."Pay Mode")
                {
                }
                fieldelement(z;"FIN-Staff Claims Header"."No. Printed")
                {
                }
                fieldelement(aa;"FIN-Staff Claims Header"."VAT Base Amount")
                {
                }
                fieldelement(bb;"FIN-Staff Claims Header"."Exchange Rate")
                {
                }
                fieldelement(cc;"FIN-Staff Claims Header"."Cancellation Remarks")
                {
                }
                fieldelement(dd;"FIN-Staff Claims Header"."Register Number")
                {
                }
                fieldelement(ee;"FIN-Staff Claims Header"."From Entry No.")
                {
                }
                fieldelement(ff;"FIN-Staff Claims Header"."To Entry No.")
                {
                }
                fieldelement(gg;"FIN-Staff Claims Header"."Invoice Currency Code")
                {
                }
                fieldelement(hh;"FIN-Staff Claims Header"."Document Type")
                {
                }
                fieldelement(ii;"FIN-Staff Claims Header"."Shortcut Dimension 3 Code")
                {
                    FieldValidate = no;
                }
                fieldelement(jj;"FIN-Staff Claims Header"."Shortcut Dimension 4 Code")
                {
                    FieldValidate = no;
                }
                fieldelement(kk;"FIN-Staff Claims Header".Dim3)
                {
                    FieldValidate = no;
                }
                fieldelement(ll;"FIN-Staff Claims Header".Dim4)
                {
                    FieldValidate = no;
                }
                fieldelement(hhhh;"FIN-Staff Claims Header"."Responsibility Center")
                {
                    FieldValidate = no;
                }
                fieldelement(mm;"FIN-Staff Claims Header"."Account Type")
                {
                }
                fieldelement(nn;"FIN-Staff Claims Header"."Account No.")
                {
                    FieldValidate = no;
                }
                fieldelement(oo;"FIN-Staff Claims Header"."Surrender Status")
                {
                }
                fieldelement(pp;"FIN-Staff Claims Header".Purpose)
                {
                }
                fieldelement(qq;"FIN-Staff Claims Header"."Allow Over Expenditure")
                {
                }
                fieldelement(rr;"FIN-Staff Claims Header"."Requested Amount")
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

