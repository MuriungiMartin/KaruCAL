#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 50214 VendorsLedgers
{
    Format = VariableText;

    schema
    {
        textelement(Roots)
        {
            tableelement("Vendor Ledger Entry";"Vendor Ledger Entry")
            {
                XmlName = 'Vendorledgers';
                SourceTableView = where("Posting Date"=filter(11;
                fieldelement(a;"Vendor Ledger Entry"."Entry No.")
                {
                }
                fieldelement(b;"Vendor Ledger Entry"."Posting Date")
                {
                }
                fieldelement(c;"Vendor Ledger Entry"."Vendor No.")
                {
                }
                fieldelement(d;"Vendor Ledger Entry"."Document No.")
                {
                }
                fieldelement(e;"Vendor Ledger Entry".Description)
                {
                }
                fieldelement(f;"Vendor Ledger Entry".Amount)
                {
                }
                fieldelement(g;"Vendor Ledger Entry"."Vendor Posting Group")
                {
                }
                fieldelement(h;"Vendor Ledger Entry"."Bal. Account No.")
                {
                }
                fieldelement(i;"Vendor Ledger Entry"."User ID")
                {
                }
                fieldelement(j;"Vendor Ledger Entry"."Is a Medical Claim")
                {
                }
                fieldelement(k;"Vendor Ledger Entry".Available)
                {
                }
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

