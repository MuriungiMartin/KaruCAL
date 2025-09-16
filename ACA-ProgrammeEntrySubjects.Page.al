#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68708 "ACA-Programme Entry Subjects"
{
    PageType = List;
    SourceTable = UnknownTable61467;

    layout
    {
        area(content)
        {
            repeater(Control1102756000)
            {
                field(Subject;Subject)
                {
                    ApplicationArea = Basic;
                }
                field("Subject Name";"Subject Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Minimum Grade";"Minimum Grade")
                {
                    ApplicationArea = Basic;
                }
                field("Minimum Points";"Minimum Points")
                {
                    ApplicationArea = Basic;
                    Enabled = false;
                }
            }
        }
    }

    actions
    {
    }
}

