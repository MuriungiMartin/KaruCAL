#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 6652 "Posted Return Shipments"
{
    ApplicationArea = Basic;
    Caption = 'Posted Return Shipments';
    CardPageID = "Posted Return Shipment";
    Editable = false;
    PageType = List;
    SourceTable = "Return Shipment Header";
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
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
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
                field("Purchaser Code";"Purchaser Code")
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
                field("No. Printed";"No. Printed")
                {
                    ApplicationArea = Basic;
                }
                field("Document Date";"Document Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Applies-to Doc. Type";"Applies-to Doc. Type")
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
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Return Shpt.")
            {
                Caption = '&Return Shpt.';
                Image = Shipment;
                action(Statistics)
                {
                    ApplicationArea = Basic;
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Return Shipment Statistics";
                    RunPageLink = "No."=field("No.");
                    ShortCutKey = 'F7';
                }
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Purch. Comment Sheet";
                    RunPageLink = "Document Type"=const("Posted Return Shipment"),
                                  "No."=field("No.");
                }
                action(Dimensions)
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
                action(CertificateOfSupplyDetails)
                {
                    ApplicationArea = Basic;
                    Caption = 'Certificate of Supply Details';
                    Image = Certificate;
                    RunObject = Page "Certificates of Supply";
                    RunPageLink = "Document Type"=filter("Return Shipment"),
                                  "Document No."=field("No.");
                }
                action(PrintCertificateofSupply)
                {
                    ApplicationArea = Basic;
                    Caption = 'Print Certificate of Supply';
                    Image = PrintReport;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction()
                    var
                        CertificateOfSupply: Record "Certificate of Supply";
                    begin
                        CertificateOfSupply.SetRange("Document Type",CertificateOfSupply."document type"::"Return Shipment");
                        CertificateOfSupply.SetRange("Document No.","No.");
                        CertificateOfSupply.Print;
                    end;
                }
            }
        }
        area(processing)
        {
            action("&Print")
            {
                ApplicationArea = Basic;
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    CurrPage.SetSelectionFilter(ReturnShptHeader);
                    ReturnShptHeader.PrintRecords(true);
                end;
            }
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

    trigger OnOpenPage()
    begin
        SetSecurityFilterOnRespCenter;
    end;

    var
        ReturnShptHeader: Record "Return Shipment Header";
}

