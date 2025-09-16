#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 50019 "Import Receipts Buffer"
{
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement("<aca-imp. receipts buffer>";UnknownTable61552)
            {
                AutoReplace = true;
                AutoUpdate = false;
                XmlName = 'St';
                fieldelement(A;"<ACA-Imp. Receipts Buffer>"."Transaction Code")
                {
                }
                fieldelement(B;"<ACA-Imp. Receipts Buffer>".Date)
                {
                }
                fieldelement(c;"<ACA-Imp. Receipts Buffer>".Description)
                {
                }
                fieldelement(d;"<ACA-Imp. Receipts Buffer>".Amount)
                {
                }
                fieldelement(e;"<ACA-Imp. Receipts Buffer>"."Student No.")
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

