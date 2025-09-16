#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 609 "IC Partner Card"
{
    Caption = 'IC Partner Card';
    PageType = Card;
    SourceTable = "IC Partner";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                }
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Basic;
                }
                field("Inbox Type";"Inbox Type")
                {
                    ApplicationArea = Basic;
                }
                field("Inbox Details";"Inbox Details")
                {
                    ApplicationArea = Basic;
                }
                field(Blocked;Blocked)
                {
                    ApplicationArea = Basic;
                }
            }
            group(Posting)
            {
                Caption = 'Posting';
                field("Receivables Account";"Receivables Account")
                {
                    ApplicationArea = Basic;
                }
                field("Payables Account";"Payables Account")
                {
                    ApplicationArea = Basic;
                }
                field("Outbound Sales Item No. Type";"Outbound Sales Item No. Type")
                {
                    ApplicationArea = Basic;
                }
                field("Outbound Purch. Item No. Type";"Outbound Purch. Item No. Type")
                {
                    ApplicationArea = Basic;
                }
                field("Cost Distribution in LCY";"Cost Distribution in LCY")
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
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("IC &Partner")
            {
                Caption = 'IC &Partner';
                Image = ICPartner;
                action(Dimensions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID"=const(413),
                                  "No."=field(Code);
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';
                }
            }
        }
    }
}

