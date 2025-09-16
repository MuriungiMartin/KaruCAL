#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 50202 "Import Student Hostel Ledger"
{
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement("ACA-Hostel Ledger";"ACA-Hostel Ledger")
            {
                AutoReplace = true;
                XmlName = 'Item';
                fieldelement(a;"ACA-Hostel Ledger".No)
                {
                }
                fieldelement(b;"ACA-Hostel Ledger"."Hostel No")
                {
                }
                fieldelement(c;"ACA-Hostel Ledger"."Room No")
                {
                }
                fieldelement(d;"ACA-Hostel Ledger".Status)
                {
                }
                fieldelement(e;"ACA-Hostel Ledger"."Room Cost")
                {
                }
                fieldelement(f;"ACA-Hostel Ledger"."Student No")
                {
                }
                fieldelement(g;"ACA-Hostel Ledger"."Space No")
                {
                }
                fieldelement(k;"ACA-Hostel Ledger".Campus)
                {
                }
                fieldelement(l;"ACA-Hostel Ledger".Semester)
                {
                }
                fieldelement(n;"ACA-Hostel Ledger"."Academic Year")
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

