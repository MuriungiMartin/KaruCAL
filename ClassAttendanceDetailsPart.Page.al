#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 65802 "Class Attendance Details Part"
{
    PageType = ListPart;
    SourceTable = UnknownTable65801;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Counting;Counting)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Student No.";"Student No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Student Name";"Student Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field(Present;Present)
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

