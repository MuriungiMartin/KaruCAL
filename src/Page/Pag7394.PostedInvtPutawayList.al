#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7394 "Posted Invt. Put-away List"
{
    ApplicationArea = Basic;
    Caption = 'Posted Invt. Put-away List';
    CardPageID = "Posted Invt. Put-away";
    Editable = false;
    PageType = List;
    SourceTable = "Posted Invt. Put-away Header";
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the posted inventory put-away number.';
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the posting date from the inventory put-away.';
                }
                field("Source No.";"Source No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the posted source document that the inventory put-away is based upon.';
                }
                field("Invt. Put-away No.";"Invt. Put-away No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the inventory put-away number from which the put-away was posted.';
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the location in which the posted inventory put-away occurred.';
                }
                field("No. Series";"No. Series")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number series code used to assign a number to the posted inventory put-away header.';
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
            group("Put-&away")
            {
                Caption = 'Put-&away';
                Image = CreatePutAway;
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Warehouse Comment Sheet";
                    RunPageLink = "Table Name"=const("Posted Invt. Put-Away"),
                                  Type=const(" "),
                                  "No."=field("No.");
                }
            }
        }
        area(processing)
        {
            action("&Navigate")
            {
                ApplicationArea = Basic;
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Navigate;
                end;
            }
        }
    }
}

