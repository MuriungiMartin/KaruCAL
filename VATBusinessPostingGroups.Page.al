#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 470 "VAT Business Posting Groups"
{
    ApplicationArea = Basic;
    Caption = 'Tax Business Posting Groups';
    PageType = List;
    SourceTable = "VAT Business Posting Group";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a code for the group.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a description for the Tax business posting group.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&Setup")
            {
                ApplicationArea = Basic,Suite;
                Caption = '&Setup';
                Image = Setup;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "VAT Posting Setup";
                RunPageLink = "VAT Bus. Posting Group"=field(Code);
                ToolTip = 'View or edit combinations of Tax business posting groups and Tax product posting groups. Fill in a line for each combination of Tax business posting group and Tax product posting group.';
            }
        }
    }
}

