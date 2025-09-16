#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 50047 "Claims Lines"
{
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement(UnknownTable61603;UnknownTable61603)
            {
                AutoReplace = false;
                AutoUpdate = true;
                XmlName = 'Item';
                fieldelement(a;"FIN-Staff Claim Lines"."Line No.")
                {
                }
                fieldelement(c;"FIN-Staff Claim Lines".No)
                {
                }
                fieldelement(d;"FIN-Staff Claim Lines"."Account No:")
                {
                    FieldValidate = no;
                }
                fieldelement(f;"FIN-Staff Claim Lines"."Account Name")
                {
                    FieldValidate = no;
                }
                fieldelement(e;"FIN-Staff Claim Lines".Amount)
                {
                }
                fieldelement(g;"FIN-Staff Claim Lines"."Due Date")
                {
                }
                fieldelement(k;"FIN-Staff Claim Lines"."Imprest Holder")
                {
                    FieldValidate = no;
                }
                fieldelement(j;"FIN-Staff Claim Lines"."Actual Spent")
                {
                }
                fieldelement(l;"FIN-Staff Claim Lines"."Global Dimension 1 Code")
                {
                    FieldValidate = no;
                }
                fieldelement(m;"FIN-Staff Claim Lines"."Apply to")
                {
                    FieldValidate = no;
                }
                fieldelement(n;"FIN-Staff Claim Lines"."Apply to ID")
                {
                    FieldValidate = no;
                }
                fieldelement(o;"FIN-Staff Claim Lines"."Surrender Date")
                {
                }
                fieldelement(p;"FIN-Staff Claim Lines".Surrendered)
                {
                }
                fieldelement(r;"FIN-Staff Claim Lines"."M.R. No")
                {
                    FieldValidate = no;
                }
                fieldelement(s;"FIN-Staff Claim Lines"."Date Issued")
                {
                }
                fieldelement(t;"FIN-Staff Claim Lines"."Type of Surrender")
                {
                    FieldValidate = no;
                }
                fieldelement(u;"FIN-Staff Claim Lines"."Dept. Vch. No.")
                {
                    FieldValidate = no;
                }
                fieldelement(v;"FIN-Staff Claim Lines"."Cash Surrender Amt")
                {
                }
                fieldelement(w;"FIN-Staff Claim Lines"."Bank/Petty Cash")
                {
                }
                fieldelement(x;"FIN-Staff Claim Lines"."Surrender Doc No.")
                {
                    FieldValidate = no;
                }
                fieldelement(y;"FIN-Staff Claim Lines"."Date Taken")
                {
                }
                fieldelement(z;"FIN-Staff Claim Lines".Purpose)
                {
                }
                fieldelement(aa;"FIN-Staff Claim Lines"."Shortcut Dimension 2 Code")
                {
                    FieldValidate = no;
                }
                fieldelement(bb;"FIN-Staff Claim Lines"."Budgetary Control A/C")
                {
                    FieldValidate = no;
                }
                fieldelement(cc;"FIN-Staff Claim Lines"."Shortcut Dimension 3 Code")
                {
                    FieldValidate = no;
                }
                fieldelement(dd;"FIN-Staff Claim Lines"."Shortcut Dimension 4 Code")
                {
                    FieldValidate = no;
                }
                fieldelement(ee;"FIN-Staff Claim Lines".Committed)
                {
                }
                fieldelement(ff;"FIN-Staff Claim Lines"."Advance Type")
                {
                    FieldValidate = no;
                }
                fieldelement(gg;"FIN-Staff Claim Lines"."Currency Factor")
                {
                    FieldValidate = no;
                }
                fieldelement(hh;"FIN-Staff Claim Lines"."Currency Code")
                {
                }
                fieldelement(ii;"FIN-Staff Claim Lines"."Amount LCY")
                {
                }
                fieldelement(jj;"FIN-Staff Claim Lines"."Claim Receipt No")
                {
                    FieldValidate = no;
                }
                fieldelement(kk;"FIN-Staff Claim Lines"."Expenditure Date")
                {
                }
                fieldelement(ll;"FIN-Staff Claim Lines"."Attendee/Organization Names")
                {
                }
                fieldelement(hhhh;"FIN-Staff Claim Lines"."Lecturer No")
                {
                    FieldValidate = no;
                }
                fieldelement(kkkk;"FIN-Staff Claim Lines"."Semester Code")
                {
                    FieldValidate = no;
                }
                fieldelement(lllll;"FIN-Staff Claim Lines"."Campus Code")
                {
                    FieldValidate = no;
                }
                fieldelement(mmmmm;"FIN-Staff Claim Lines"."Unit Code")
                {
                    FieldValidate = no;
                }
                fieldelement(nnnnn;"FIN-Staff Claim Lines"."No. of Hours")
                {
                }
                fieldelement(sdfsd;"FIN-Staff Claim Lines"."PAYE Amount")
                {
                }
                fieldelement(werqt;"FIN-Staff Claim Lines"."PAYE Code")
                {
                }
                fieldelement(dsvc;"FIN-Staff Claim Lines"."Net Amount")
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

