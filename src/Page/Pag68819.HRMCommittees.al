#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68819 "HRM-Committees"
{
    PageType = List;
    SourceTable = UnknownTable61245;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field(Roles;Roles)
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
            group(Committee)
            {
                Caption = 'Committee';
                action(Members)
                {
                    ApplicationArea = Basic;
                    Caption = 'Members';
                    Image = Loaners;
                    Promoted = true;
                    RunObject = Page "HRM-Commitee Members";
                    RunPageLink = Committee=field(Code);
                }
            }
        }
    }
}

