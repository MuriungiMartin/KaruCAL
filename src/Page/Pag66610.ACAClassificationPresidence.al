#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 66610 "ACA-Classification Presidence"
{
    PageType = List;
    SourceTable = UnknownTable66600;

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
                field(Comments;Comments)
                {
                    ApplicationArea = Basic;
                }
                field(Presidence;Presidence)
                {
                    ApplicationArea = Basic;
                }
                field("Exists in Course Registration";"Exists in Course Registration")
                {
                    ApplicationArea = Basic;
                }
                field("Graduation Academic Year";"Graduation Academic Year")
                {
                    ApplicationArea = Basic;
                }
                field("Program Code";"Program Code")
                {
                    ApplicationArea = Basic;
                }
                field("Pass Status";"Pass Status")
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

