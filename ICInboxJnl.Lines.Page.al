#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 616 "IC Inbox Jnl. Lines"
{
    Caption = 'IC Inbox Jnl. Lines';
    DataCaptionFields = "IC Partner Code";
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "IC Inbox Jnl. Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("IC Partner Code";"IC Partner Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Account Type";"Account Type")
                {
                    ApplicationArea = Basic;
                }
                field("Account No.";"Account No.")
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic;
                }
                field("VAT Amount";"VAT Amount")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Due Date";"Due Date")
                {
                    ApplicationArea = Basic;
                }
                field("Payment Discount %";"Payment Discount %")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Payment Discount Date";"Payment Discount Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                    Visible = false;
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
        area(navigation)
        {
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action("&Dimensions")
                {
                    ApplicationArea = Basic;
                    Caption = '&Dimensions';
                    Image = Dimensions;
                    RunObject = Page "IC Inbox/Outbox Jnl. Line Dim.";
                    RunPageLink = "Table ID"=const(419),
                                  "IC Partner Code"=field("IC Partner Code"),
                                  "Transaction No."=field("Transaction No."),
                                  "Transaction Source"=field("Transaction Source"),
                                  "Line No."=field("Line No.");
                    ShortCutKey = 'Shift+Ctrl+D';
                }
            }
        }
    }
}

