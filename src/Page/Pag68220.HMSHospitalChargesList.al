#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68220 "HMS-Hospital Charges List"
{
    PageType = List;
    SourceTable = UnknownTable61613;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Class Code";"Class Code")
                {
                    ApplicationArea = Basic;
                }
                field("Unit Code";"Unit Code")
                {
                    ApplicationArea = Basic;
                }
                field("Entry No";"Entry No")
                {
                    ApplicationArea = Basic;
                }
                field("Class Size";"Class Size")
                {
                    ApplicationArea = Basic;
                }
                field(Lecturer;Lecturer)
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

