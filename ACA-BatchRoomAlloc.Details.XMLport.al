#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 77382 "ACA-Batch Room Alloc. Details"
{
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement(batchallocdetails;"ACA-Batch Room Alloc. Details")
            {
                AutoUpdate = true;
                XmlName = 'Item';
                fieldelement(a;BatchAllocDetails."Academic Year")
                {
                }
                fieldelement(b;BatchAllocDetails."Student No.")
                {
                }
                fieldelement(f;BatchAllocDetails.Gender)
                {
                }
                fieldelement(c;BatchAllocDetails."Hostel Block")
                {
                }
                fieldelement(d;BatchAllocDetails."Room No")
                {
                }
                fieldelement(e;BatchAllocDetails."Room Space")
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

