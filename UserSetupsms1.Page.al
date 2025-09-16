#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 90056 "User Setup sms1"
{
    Caption = 'User Setup';
    PageType = List;
    SourceTable = UnknownTable90050;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("User ID";"User ID")
                {
                    ApplicationArea = Basic;
                }
                field("Allow Posting From";"Allow Posting From")
                {
                    ApplicationArea = Basic;
                }
                field("Allow Posting To";"Allow Posting To")
                {
                    ApplicationArea = Basic;
                }
                field("Register Time";"Register Time")
                {
                    ApplicationArea = Basic;
                }
                field("Sales Resp. Ctr. Filter";"Sales Resp. Ctr. Filter")
                {
                    ApplicationArea = Basic;
                }
                field("Purchase Resp. Ctr. Filter";"Purchase Resp. Ctr. Filter")
                {
                    ApplicationArea = Basic;
                }
                field("Service Resp. Ctr. Filter";"Service Resp. Ctr. Filter")
                {
                    ApplicationArea = Basic;
                }
                field("Time Sheet Admin.";"Time Sheet Admin.")
                {
                    ApplicationArea = Basic;
                }
                field("Phone No.";"Phone No.")
                {
                    ApplicationArea = Basic;
                }
                field("Use Two Factor Authentication";"Use Two Factor Authentication")
                {
                    ApplicationArea = Basic;
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
    }
}

