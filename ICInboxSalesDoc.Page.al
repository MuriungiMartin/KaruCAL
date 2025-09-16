#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 644 "IC Inbox Sales Doc."
{
    Caption = 'IC Inbox Sales Doc.';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Document;
    SourceTable = "IC Inbox Sales Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Document Type";"Document Type")
                {
                    ApplicationArea = Basic;
                }
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                }
                field("IC Transaction No.";"IC Transaction No.")
                {
                    ApplicationArea = Basic;
                }
                field("IC Partner Code";"IC Partner Code")
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Source";"Transaction Source")
                {
                    ApplicationArea = Basic;
                }
                field("Sell-to Customer No.";"Sell-to Customer No.")
                {
                    ApplicationArea = Basic;
                }
                field("Bill-to Customer No.";"Bill-to Customer No.")
                {
                    ApplicationArea = Basic;
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field("Document Date";"Document Date")
                {
                    ApplicationArea = Basic;
                }
                field("Due Date";"Due Date")
                {
                    ApplicationArea = Basic;
                }
                field("Pmt. Discount Date";"Pmt. Discount Date")
                {
                    ApplicationArea = Basic;
                }
                field("Payment Discount %";"Payment Discount %")
                {
                    ApplicationArea = Basic;
                }
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Basic;
                }
            }
            part(ICInboxSalesLines;"IC Inbox Sales Lines")
            {
                SubPageLink = "IC Transaction No."=field("IC Transaction No."),
                              "IC Partner Code"=field("IC Partner Code"),
                              "Transaction Source"=field("Transaction Source");
            }
            group(Shipping)
            {
                Caption = 'Shipping';
                field("Ship-to Name";"Ship-to Name")
                {
                    ApplicationArea = Basic;
                }
                field("Ship-to Address";"Ship-to Address")
                {
                    ApplicationArea = Basic;
                }
                field("Ship-to City";"Ship-to City")
                {
                    ApplicationArea = Basic;
                }
                field("Promised Delivery Date";"Promised Delivery Date")
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
        area(navigation)
        {
            group(Document)
            {
                Caption = '&Document';
                Image = Document;
                action(Dimensions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page "IC Document Dimensions";
                    RunPageLink = "Table ID"=const(434),
                                  "Transaction No."=field("IC Transaction No."),
                                  "IC Partner Code"=field("IC Partner Code"),
                                  "Transaction Source"=field("Transaction Source"),
                                  "Line No."=const(0);
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';
                }
            }
        }
    }
}

