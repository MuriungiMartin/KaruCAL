#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68081 "PRL-Salary Grades"
{
    PageType = Card;
    SourceTable = UnknownTable61120;

    layout
    {
        area(content)
        {
            repeater(Control1102756000)
            {
                field("Salary Grade";"Salary Grade")
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field("Salary Amount";"Salary Amount")
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

