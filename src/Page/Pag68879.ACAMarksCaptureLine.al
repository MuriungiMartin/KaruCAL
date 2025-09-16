#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68879 "ACA-Marks Capture Line"
{
    PageType = List;
    SourceTable = UnknownTable61702;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Student No.";"Student No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Student Name";"Student Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("CAT 1";"CAT 1")
                {
                    ApplicationArea = Basic;
                }
                field("CAT 2";"CAT 2")
                {
                    ApplicationArea = Basic;
                }
                field(Exam;Exam)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }
}

