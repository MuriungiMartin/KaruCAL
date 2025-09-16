#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 6644 "Purchase Return Order Archive"
{
    Caption = 'Purchase Return Order Archive';
    DeleteAllowed = false;
    Editable = false;
    PageType = Document;
    SourceTable = "Purchase Header Archive";
    SourceTableView = where("Document Type"=const("Return Order"));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                }
                field("Buy-from Vendor No.";"Buy-from Vendor No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Vendor No.';
                }
                field("Buy-from Vendor Name";"Buy-from Vendor Name")
                {
                    ApplicationArea = Basic;
                    Caption = 'Vendor';
                }
                group("Buy-from")
                {
                    Caption = 'Buy-from';
                    field("Buy-from Address";"Buy-from Address")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Address';
                        Importance = Additional;
                    }
                    field("Buy-from Address 2";"Buy-from Address 2")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Address 2';
                        Importance = Additional;
                    }
                    field("Buy-from Post Code";"Buy-from Post Code")
                    {
                        ApplicationArea = Basic;
                        Caption = 'ZIP Code';
                        Importance = Additional;
                    }
                    field("Buy-from City";"Buy-from City")
                    {
                        ApplicationArea = Basic;
                        Caption = 'City';
                        Importance = Additional;
                    }
                    field("Buy-from Contact No.";"Buy-from Contact No.")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Contact No.';
                        Importance = Additional;
                    }
                }
                field("Buy-from Contact";"Buy-from Contact")
                {
                    ApplicationArea = Basic;
                    Caption = 'Contact';
                }
                field("Document Date";"Document Date")
                {
                    ApplicationArea = Basic;
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field("Order Date";"Order Date")
                {
                    ApplicationArea = Basic;
                }
                field("Vendor Authorization No.";"Vendor Authorization No.")
                {
                    ApplicationArea = Basic;
                }
                field("Vendor Cr. Memo No.";"Vendor Cr. Memo No.")
                {
                    ApplicationArea = Basic;
                }
                field("Order Address Code";"Order Address Code")
                {
                    ApplicationArea = Basic;
                }
                field("Purchaser Code";"Purchaser Code")
                {
                    ApplicationArea = Basic;
                }
                field("Responsibility Center";"Responsibility Center")
                {
                    ApplicationArea = Basic;
                }
                field("Assigned User ID";"Assigned User ID")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
            }
            part(PurchLinesArchive;"Purch Return Order Arc Subform")
            {
                SubPageLink = "Document No."=field("No."),
                              "Doc. No. Occurrence"=field("Doc. No. Occurrence"),
                              "Version No."=field("Version No.");
            }
            group("Invoice Details")
            {
                Caption = 'Invoice Details';
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Basic;
                }
                field("Prices Including VAT";"Prices Including VAT")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        PricesIncludingVATOnAfterValid;
                    end;
                }
                field("VAT Bus. Posting Group";"VAT Bus. Posting Group")
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Type";"Transaction Type")
                {
                    ApplicationArea = Basic;
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Applies-to Doc. Type";"Applies-to Doc. Type")
                {
                    ApplicationArea = Basic;
                }
                field("Applies-to Doc. No.";"Applies-to Doc. No.")
                {
                    ApplicationArea = Basic;
                }
                field("Applies-to ID";"Applies-to ID")
                {
                    ApplicationArea = Basic;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                }
                field("Expected Receipt Date";"Expected Receipt Date")
                {
                    ApplicationArea = Basic;
                }
            }
            group("Shipping and Payment")
            {
                Caption = 'Shipping and Payment';
                group("Ship-to")
                {
                    Caption = 'Ship-to';
                    field("Ship-to Name";"Ship-to Name")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Name';
                        Importance = Additional;
                    }
                    field("Ship-to Address";"Ship-to Address")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Address';
                        Importance = Additional;
                    }
                    field("Ship-to Address 2";"Ship-to Address 2")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Address 2';
                        Importance = Additional;
                    }
                    field("Ship-to Post Code";"Ship-to Post Code")
                    {
                        ApplicationArea = Basic;
                        Caption = 'ZIP Code';
                        Importance = Additional;
                    }
                    field("Ship-to City";"Ship-to City")
                    {
                        ApplicationArea = Basic;
                        Caption = 'City';
                        Importance = Additional;
                    }
                    field("Ship-to Contact";"Ship-to Contact")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Contact';
                        Importance = Additional;
                    }
                }
                group("Pay-to")
                {
                    Caption = 'Pay-to';
                    field("Pay-to Name";"Pay-to Name")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Name';
                        Importance = Promoted;
                    }
                    field("Pay-to Address";"Pay-to Address")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Address';
                        Importance = Additional;
                    }
                    field("Pay-to Address 2";"Pay-to Address 2")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Address 2';
                        Importance = Additional;
                    }
                    field("Pay-to Post Code";"Pay-to Post Code")
                    {
                        ApplicationArea = Basic;
                        Caption = 'ZIP Code';
                        Importance = Additional;
                    }
                    field("Pay-to City";"Pay-to City")
                    {
                        ApplicationArea = Basic;
                        Caption = 'City';
                        Importance = Additional;
                    }
                    field("Pay-to Contact No.";"Pay-to Contact No.")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Contact No.';
                        Importance = Additional;
                    }
                    field("Pay-to Contact";"Pay-to Contact")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Contact';
                        Importance = Additional;
                    }
                }
            }
            group("Foreign Trade")
            {
                Caption = 'Foreign Trade';
                field("Transaction Specification";"Transaction Specification")
                {
                    ApplicationArea = Basic;
                }
                field("Transport Method";"Transport Method")
                {
                    ApplicationArea = Basic;
                }
                field("Entry Point";"Entry Point")
                {
                    ApplicationArea = Basic;
                }
                field("Area";Area)
                {
                    ApplicationArea = Basic;
                }
            }
            group(Version)
            {
                Caption = 'Version';
                field("Version No.";"Version No.")
                {
                    ApplicationArea = Basic;
                }
                field("Archived By";"Archived By")
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
                field("Interaction Exist";"Interaction Exist")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Ver&sion")
            {
                Caption = 'Ver&sion';
                Image = Versions;
                action(Card)
                {
                    ApplicationArea = Basic;
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page "Vendor Card";
                    RunPageLink = "No."=field("Buy-from Vendor No.");
                    ShortCutKey = 'Shift+F7';
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
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Purch. Archive Comment Sheet";
                    RunPageLink = "Document Type"=field("Document Type"),
                                  "No."=field("No."),
                                  "Document Line No."=const(0),
                                  "Doc. No. Occurrence"=field("Doc. No. Occurrence"),
                                  "Version No."=field("Version No.");
                }
                action(Print)
                {
                    ApplicationArea = Basic;
                    Caption = 'Print';
                    Image = Print;

                    trigger OnAction()
                    begin
                        DocPrint.PrintPurchHeaderArch(Rec);
                    end;
                }
            }
        }
    }

    var
        DocPrint: Codeunit "Document-Print";

    local procedure PricesIncludingVATOnAfterValid()
    begin
        CurrPage.Update;
    end;
}

