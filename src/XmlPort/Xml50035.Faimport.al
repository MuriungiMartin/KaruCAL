#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 50035 "Fa import"
{
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement("<5621>";"FA Journal Line")
            {
                AutoReplace = true;
                AutoUpdate = false;
                XmlName = 'jv';
                fieldelement(A;"<5621>"."Line No.")
                {
                }
                fieldelement(B;"<5621>"."FA Posting Date")
                {
                }
                fieldelement(c;"<5621>"."Document No.")
                {
                }
                fieldelement(d;"<5621>"."FA No.")
                {
                }
                fieldelement(e;"<5621>"."Depreciation Book Code")
                {
                }
                fieldelement(f;"<5621>"."FA Posting Type")
                {
                }
                fieldelement(j;"<5621>".Amount)
                {
                }
                fieldelement(g;"<5621>".Description)
                {
                }

                trigger OnBeforeInsertRecord()
                begin
                        //Item."VAT Prod. Posting Group":='ZERO';

                        "<5621>"."Journal Template Name":='FA';
                      "<5621>"."Journal Batch Name":='OPBAL';
                      "<5621>"."Line No.":="<5621>"."Line No."+10000;
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

