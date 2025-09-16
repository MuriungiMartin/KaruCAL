#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 77383 "Import Hostel Allocations"
{
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement(batchallocdetails;"ACA-Students Hostel Rooms")
            {
                AutoUpdate = true;
                XmlName = 'Item';
                fieldelement(a;BatchAllocDetails.Student)
                {
                }
                fieldelement(b;BatchAllocDetails.Semester)
                {
                }
                fieldelement(f;BatchAllocDetails."Academic Year")
                {
                }
                fieldelement(c;BatchAllocDetails."Hostel No")
                {
                }
                fieldelement(d;BatchAllocDetails."Room No")
                {
                }
                fieldelement(e;BatchAllocDetails."Space No")
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

