#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 6080 "Service Price Groups"
{
    ApplicationArea = Basic;
    Caption = 'Service Price Groups';
    PageType = List;
    SourceTable = "Service Price Group";
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
                    ToolTip = 'Specifies a code for the service price group.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the service price group.';
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
                ApplicationArea = Basic;
                Caption = '&Setup';
                Image = Setup;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Serv. Price Group Setup";
                RunPageLink = "Service Price Group Code"=field(Code);
            }
        }
    }
}

