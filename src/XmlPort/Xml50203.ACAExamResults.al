#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 50203 "ACA-Exam Results"
{
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement(UnknownTable61548;UnknownTable61548)
            {
                AutoReplace = true;
                XmlName = 'Item';
                fieldelement(a;"ACA-Exam Results".Programme)
                {
                }
                fieldelement(b;"ACA-Exam Results".Stage)
                {
                }
                fieldelement(c;"ACA-Exam Results".Unit)
                {
                }
                fieldelement(d;"ACA-Exam Results".Semester)
                {
                }
                fieldelement(e;"ACA-Exam Results".Score)
                {
                }
                fieldelement(f;"ACA-Exam Results".Exam)
                {
                }
                fieldelement(k;"ACA-Exam Results"."Student No.")
                {
                }
                fieldelement(b;"ACA-Exam Results"."Exam Category")
                {
                }
                fieldelement(c;"ACA-Exam Results".ExamType)
                {
                }
                fieldelement(d;"ACA-Exam Results"."Admission No")
                {
                }
                fieldelement(e;"ACA-Exam Results"."Lecturer Names")
                {
                }
                fieldelement(f;"ACA-Exam Results".User_ID)
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

