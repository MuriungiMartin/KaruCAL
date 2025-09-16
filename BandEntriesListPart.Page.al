#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 78127 "Band Entries ListPart"
{
    DeleteAllowed = false;
    PageType = ListPart;
    SourceTable = "Funding Band Entries";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Student No.";"Student No.")
                {
                    ApplicationArea = Basic;
                }
                field("Previous Band";"Previous Band")
                {
                    ApplicationArea = Basic;
                }
                field("Student Name";"Student Name")
                {
                    ApplicationArea = Basic;
                }
                field("Admission Year";"Admission Year")
                {
                    ApplicationArea = Basic;
                }
                field("KCSE Index No.";"KCSE Index No.")
                {
                    ApplicationArea = Basic;
                }
                field("Band Code";"Band Code")
                {
                    ApplicationArea = Basic;
                }
                field("Programme Code";"Programme Code")
                {
                    ApplicationArea = Basic;
                }
                field("Programme Cost";"Programme Cost")
                {
                    ApplicationArea = Basic;
                }
                field("HouseHold Percentage";"HouseHold Percentage")
                {
                    ApplicationArea = Basic;
                }
                field("HouseHold Fee";"HouseHold Fee")
                {
                    ApplicationArea = Basic;
                }
                field(Semester;Semester)
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

