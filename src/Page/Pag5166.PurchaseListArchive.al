#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5166 "Purchase List Archive"
{
    Caption = 'Purchase List Archive';
    Editable = false;
    PageType = List;
    SourceTable = "Purchase Header Archive";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                }
                field("Version No.";"Version No.")
                {
                    ApplicationArea = Basic;
                }
                field("Date Archived";"Date Archived")
                {
                    ApplicationArea = Basic;
                }
                field("Time Archived";"Time Archived")
                {
                    ApplicationArea = Basic;
                }
                field("Archived By";"Archived By")
                {
                    ApplicationArea = Basic;
                }
                field("Interaction Exist";"Interaction Exist")
                {
                    ApplicationArea = Basic;
                }
                field("Buy-from Vendor No.";"Buy-from Vendor No.")
                {
                    ApplicationArea = Basic;
                }
                field("Order Address Code";"Order Address Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Buy-from Vendor Name";"Buy-from Vendor Name")
                {
                    ApplicationArea = Basic;
                }
                field("Vendor Authorization No.";"Vendor Authorization No.")
                {
                    ApplicationArea = Basic;
                }
                field("Buy-from Post Code";"Buy-from Post Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Buy-from Country/Region Code";"Buy-from Country/Region Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Buy-from Contact";"Buy-from Contact")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Pay-to Vendor No.";"Pay-to Vendor No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Pay-to Name";"Pay-to Name")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Pay-to Post Code";"Pay-to Post Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Pay-to Country/Region Code";"Pay-to Country/Region Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Pay-to Contact";"Pay-to Contact")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Ship-to Code";"Ship-to Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Ship-to Name";"Ship-to Name")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Ship-to Post Code";"Ship-to Post Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Ship-to Country/Region Code";"Ship-to Country/Region Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Ship-to Contact";"Ship-to Contact")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                }
                field("Purchaser Code";"Purchaser Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Currency Code";"Currency Code")
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
                action(Card)
                {
                    ApplicationArea = Basic;
                    Caption = 'Card';
                    Image = EditLines;
                    ShortCutKey = 'Shift+F7';

                    trigger OnAction()
                    var
                        PageManagement: Codeunit "Page Management";
                    begin
                        PageManagement.PageRun(Rec);
                    end;
                }
            }
        }
    }
}

