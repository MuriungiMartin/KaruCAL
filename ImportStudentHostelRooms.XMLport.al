#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 50201 "Import Student Hostel Rooms"
{
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement("ACA-Students Hostel Rooms";"ACA-Students Hostel Rooms")
            {
                AutoReplace = true;
                XmlName = 'Item';
                fieldelement(a;"ACA-Students Hostel Rooms"."Line No")
                {
                }
                fieldelement(b;"ACA-Students Hostel Rooms"."Space No")
                {
                }
                fieldelement(c;"ACA-Students Hostel Rooms"."Room No")
                {
                }
                fieldelement(d;"ACA-Students Hostel Rooms"."Hostel No")
                {
                }
                fieldelement(e;"ACA-Students Hostel Rooms"."Accomodation Fee")
                {
                }
                fieldelement(f;"ACA-Students Hostel Rooms"."Allocation Date")
                {
                }
                fieldelement(g;"ACA-Students Hostel Rooms".Charges)
                {
                }
                fieldelement(k;"ACA-Students Hostel Rooms".Student)
                {
                }
                fieldelement(l;"ACA-Students Hostel Rooms".Billed)
                {
                }
                fieldelement(m;"ACA-Students Hostel Rooms"."Billed Date")
                {
                }
                fieldelement(n;"ACA-Students Hostel Rooms".Semester)
                {
                }
                fieldelement(o;"ACA-Students Hostel Rooms"."Hostel Assigned")
                {
                }
                fieldelement(p;"ACA-Students Hostel Rooms"."Academic Year")
                {
                }
                fieldelement(q;"ACA-Students Hostel Rooms".Allocated)
                {
                }
                fieldelement(r;"ACA-Students Hostel Rooms"."Invoice Printed")
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

