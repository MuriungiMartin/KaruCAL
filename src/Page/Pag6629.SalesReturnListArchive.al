#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 6629 "Sales Return List Archive"
{
    ApplicationArea = Basic;
    Caption = 'Sales Return List Archive';
    CardPageID = "Sales Return Order Archive";
    DataCaptionFields = "Document Type";
    Editable = false;
    PageType = List;
    SourceTable = "Sales Header Archive";
    SourceTableView = where("Document Type"=const("Return Order"));
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
                }
                field("Sell-to Customer No.";"Sell-to Customer No.")
                {
                    ApplicationArea = Basic;
                }
                field("Sell-to Customer Name";"Sell-to Customer Name")
                {
                    ApplicationArea = Basic;
                }
                field("External Document No.";"External Document No.")
                {
                    ApplicationArea = Basic;
                }
                field("Sell-to Post Code";"Sell-to Post Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Sell-to Country/Region Code";"Sell-to Country/Region Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Sell-to Contact";"Sell-to Contact")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Bill-to Customer No.";"Bill-to Customer No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Bill-to Name";"Bill-to Name")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Bill-to Post Code";"Bill-to Post Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Bill-to Country/Region Code";"Bill-to Country/Region Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Bill-to Contact";"Bill-to Contact")
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
                    Visible = true;
                }
                field("Salesperson Code";"Salesperson Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Assigned User ID";"Assigned User ID")
                {
                    ApplicationArea = Basic;
                }
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("<Action1102601000>")
            {
                Caption = 'Ver&sion';
                Image = Versions;
                action("<Action1102601003>")
                {
                    AccessByPermission = TableData Dimension=R;
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                    trigger OnAction()
                    begin
                        ShowDimensions;
                    end;
                }
                action("<Page Sales Archive Comment Sheet>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Sales Archive Comment Sheet";
                    RunPageLink = "Document Type"=field("Document Type"),
                                  "No."=field("No."),
                                  "Document Line No."=const(0),
                                  "Doc. No. Occurrence"=field("Doc. No. Occurrence"),
                                  "Version No."=field("Version No.");
                }
            }
        }
    }
}

