#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68130 "ACA-Exams Activities Header"
{
    PageType = Card;
    SourceTable = UnknownTable61736;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field("Semester Code";"Semester Code")
                {
                    ApplicationArea = Basic;
                }
                field("Academic Year";"Academic Year")
                {
                    ApplicationArea = Basic;
                }
                field("Campus Code";"Campus Code")
                {
                    ApplicationArea = Basic;
                }
                part(Control1102755007;"ACA-Exams Activities Lines")
                {
                    SubPageLink = Code=field(Code);
                }
            }
        }
    }

    actions
    {
    }
}

