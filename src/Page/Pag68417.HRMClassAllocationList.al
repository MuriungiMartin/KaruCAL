#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68417 "HRM-Class Allocation List"
{
    CardPageID = "ACA-Class Allocation Card";
    PageType = List;
    SourceTable = UnknownTable61212;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                }
                field(Programme;Programme)
                {
                    ApplicationArea = Basic;
                }
                field(Stage;Stage)
                {
                    ApplicationArea = Basic;
                }
                field(Semester;Semester)
                {
                    ApplicationArea = Basic;
                }
                field(Campus;Campus)
                {
                    ApplicationArea = Basic;
                }
                field("Students Range";"Students Range")
                {
                    ApplicationArea = Basic;
                }
                field("Student Count";"Student Count")
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

