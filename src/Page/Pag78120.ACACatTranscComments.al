#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 78120 "ACA-Cat. Transc. Comments"
{
    PageType = List;
    SourceTable = UnknownTable78020;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Year of Study";"Year of Study")
                {
                    ApplicationArea = Basic;
                }
                field("Pass Comment";"Pass Comment")
                {
                    ApplicationArea = Basic;
                }
                field("Failed Comment";"Failed Comment")
                {
                    ApplicationArea = Basic;
                }
                field("Include Programme Name";"Include Programme Name")
                {
                    ApplicationArea = Basic;
                }
                field("Include Classification";"Include Classification")
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

