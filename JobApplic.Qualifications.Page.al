#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 70047 "Job Applic. Qualifications"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = UnknownTable60238;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Criteria Code";"Criteria Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Value Code";"Value Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Achievable Score";"Achievable Score")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Attachment Exists";"Attachment Exists")
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

