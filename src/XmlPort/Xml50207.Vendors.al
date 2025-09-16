#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 50207 Vendors
{
    Format = VariableText;

    schema
    {
        textelement(root)
        {
            tableelement(Vendor;Vendor)
            {
                XmlName = 'Vendors';
                fieldelement(a;Vendor."No.")
                {
                }
                fieldelement(b;Vendor.Name)
                {
                }
                fieldelement(c;Vendor."Phone No.")
                {
                }
                fieldelement(d;Vendor.Address)
                {
                }
                fieldelement(d;Vendor."Global Dimension 1 Code")
                {
                }
                fieldelement(e;Vendor."Global Dimension 2 Code")
                {
                }
                fieldelement(g;Vendor."Vendor Posting Group")
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

