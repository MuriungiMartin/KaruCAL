#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 50060 CourseReg
{
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement(UnknownTable61532;UnknownTable61532)
            {
                AutoUpdate = true;
                XmlName = 'Item';
                fieldelement(a;"ACA-Course Registration"."Reg. Transacton ID")
                {
                }
                fieldelement(b;"ACA-Course Registration"."Student No.")
                {
                }
                fieldelement(a;"ACA-Course Registration".Programme)
                {
                }
                fieldelement(b;"ACA-Course Registration".Semester)
                {
                }
                fieldelement(a;"ACA-Course Registration"."Register for")
                {
                }
                fieldelement(b;"ACA-Course Registration".Stage)
                {
                }
                fieldelement(a;"ACA-Course Registration"."Student Type")
                {
                }
                fieldelement(b;"ACA-Course Registration"."Entry No.")
                {
                }
                fieldelement(a;"ACA-Course Registration".Remarks)
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

