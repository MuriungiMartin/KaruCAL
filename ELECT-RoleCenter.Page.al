#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 60023 "ELECT-Role Center"
{
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
        }
    }

    actions
    {
        area(creation)
        {
            action(Vote)
            {
                ApplicationArea = Basic;
                Caption = 'Vote';
                Image = PostedVoucherGroup;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "ELECT-Voter Login";
            }
        }
    }
}

