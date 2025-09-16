#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 50056 "Customes Import"
{
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement(Customer;Customer)
            {
                AutoUpdate = true;
                XmlName = 'Item';
                fieldelement(a;Customer."No.")
                {
                }
                fieldelement(b;Customer.Name)
                {
                }
                fieldelement(c;Customer."Search Name")
                {
                }
                fieldelement(d;Customer.Address)
                {
                }
                fieldelement(e;Customer."Address 2")
                {
                }
                fieldelement(f;Customer.City)
                {
                }
                fieldelement(g;Customer.Contact)
                {
                }
                fieldelement(h;Customer."Phone No.")
                {
                }
                fieldelement(i;Customer."Telex No.")
                {
                }
                fieldelement(j;Customer."Global Dimension 1 Code")
                {
                }
                fieldelement(k;Customer."Global Dimension 2 Code")
                {
                }
                fieldelement(f;Customer."Credit Limit (LCY)")
                {
                }
                fieldelement(g;Customer."Customer Posting Group")
                {
                }
                fieldelement(h;Customer."Currency Code")
                {
                }
                fieldelement(i;Customer."Customer Price Group")
                {
                }
                fieldelement(j;Customer."Payment Terms Code")
                {
                }
                fieldelement(k;Customer."Salesperson Code")
                {
                }
                fieldelement(f;Customer."Bill-to Customer No.")
                {
                }
                fieldelement(g;Customer."Gen. Bus. Posting Group")
                {
                }
                fieldelement(h;Customer."Post Code")
                {
                }
                fieldelement(i;Customer."VAT Bus. Posting Group")
                {
                }
                fieldelement(j;Customer.Gender)
                {
                }
                fieldelement(k;Customer."Date Of Birth")
                {
                }
                fieldelement(f;Customer.Religion)
                {
                }
                fieldelement(g;Customer."Student Type")
                {
                }
                fieldelement(h;Customer."ID No")
                {
                }
                fieldelement(i;Customer."Customer Type")
                {
                }
                fieldelement(j;Customer."Staff No.")
                {
                }
                fieldelement(k;Customer.Password)
                {
                }
                fieldelement(l;Customer."Gown 1")
                {
                }
                fieldelement(m;Customer."Gown 2")
                {
                }
                fieldelement(n;Customer."Gown 3")
                {
                }
                fieldelement(g;Customer."Date Issued")
                {
                }
                fieldelement(h;Customer."Gown Status")
                {
                }
                fieldelement(i;Customer."Date Returned")
                {
                }
                fieldelement(j;Customer."Certificate Status")
                {
                }
                fieldelement(g;Customer."Date Collected")
                {
                }
                fieldelement(h;Customer.Confirmed)
                {
                }
                fieldelement(i;Customer."Confirmed Remarks")
                {
                }
                fieldelement(j;Customer."Special Requrements")
                {
                }
                fieldelement(g;Customer."Certificate No.")
                {
                }
                fieldelement(h;Customer."Current Programme")
                {
                }
                fieldelement(i;Customer."Hostel Black Listed")
                {
                }
                fieldelement(j;Customer."Black Listed Reason")
                {
                }
                fieldelement(g;Customer."Black Listed By")
                {
                }
                fieldelement(h;Customer."Audit Issue")
                {
                }
                fieldelement(i;Customer."Current Program")
                {
                }
                fieldelement(j;Customer."Current Semester")
                {
                }
                fieldelement(g;Customer."ID Card Expiry Year")
                {
                }
                fieldelement(h;Customer.Tribe)
                {
                }
                fieldelement(j;Customer."Intake Code")
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

