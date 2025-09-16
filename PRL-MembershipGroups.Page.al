#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68072 "PRL-Membership Groups"
{
    PageType = List;
    SourceTable = UnknownTable61110;

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                field("Group No";"Group No")
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field(Comments;Comments)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Member Details")
            {
                Caption = 'Member Details';
                action("Institutional Listing")
                {
                    ApplicationArea = Basic;
                    Caption = 'Institutional Listing';
                    RunObject = Page "PRL-Institutional Membership";
                    RunPageLink = "Group No"=field("Group No");
                }
            }
        }
    }
}

