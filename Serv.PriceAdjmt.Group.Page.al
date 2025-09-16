#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 6082 "Serv. Price Adjmt. Group"
{
    ApplicationArea = Basic;
    Caption = 'Serv. Price Adjmt. Group';
    PageType = List;
    SourceTable = "Service Price Adjustment Group";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a code for the service price adjustment group.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the service price adjustment group.';
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
            action("&Details")
            {
                ApplicationArea = Basic;
                Caption = '&Details';
                Image = View;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Serv. Price Adjmt. Detail";
                RunPageLink = "Serv. Price Adjmt. Gr. Code"=field(Code);
            }
        }
    }
}

