#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68726 "HRM-Training Providers Card"
{
    Caption = 'Vendor Card';
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = Vendor;

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
                    Importance = Promoted;

                    trigger OnAssistEdit()
                    begin
                        if AssistEdit(xRec) then
                          CurrPage.Update;
                    end;
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field(Address;Address)
                {
                    ApplicationArea = Basic;
                }
                field("Address 2";"Address 2")
                {
                    ApplicationArea = Basic;
                }
                field("Post Code";"Post Code")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field("Country/Region Code";"Country/Region Code")
                {
                    ApplicationArea = Basic;
                }
                field("Phone No.";"Phone No.")
                {
                    ApplicationArea = Basic;
                }
                field("Primary Contact No.";"Primary Contact No.")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        ActivateFields;
                    end;
                }
                field(Contact;Contact)
                {
                    ApplicationArea = Basic;
                    Editable = ContactEditable;
                    Importance = Promoted;

                    trigger OnValidate()
                    begin
                        ContactOnAfterValidate;
                    end;
                }
                field(City;City)
                {
                    ApplicationArea = Basic;
                }
                field("Search Name";"Search Name")
                {
                    ApplicationArea = Basic;
                }
                field("Balance (LCY)";"Balance (LCY)")
                {
                    ApplicationArea = Basic;

                    trigger OnDrillDown()
                    var
                        VendLedgEntry: Record "Vendor Ledger Entry";
                        DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
                    begin
                        DtldVendLedgEntry.SetRange("Vendor No.","No.");
                        Copyfilter("Global Dimension 1 Filter",DtldVendLedgEntry."Initial Entry Global Dim. 1");
                        Copyfilter("Global Dimension 2 Filter",DtldVendLedgEntry."Initial Entry Global Dim. 2");
                        Copyfilter("Currency Filter",DtldVendLedgEntry."Currency Code");
                        VendLedgEntry.DrillDownOnEntries(DtldVendLedgEntry);
                    end;
                }
                field("Purchaser Code";"Purchaser Code")
                {
                    ApplicationArea = Basic;
                }
                field("Responsibility Center";"Responsibility Center")
                {
                    ApplicationArea = Basic;
                }
                field(Blocked;Blocked)
                {
                    ApplicationArea = Basic;
                }
                field("Last Date Modified";"Last Date Modified")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Communication)
            {
                Caption = 'Communication';
                field("Phone No.2";"Phone No.")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field("Fax No.";"Fax No.")
                {
                    ApplicationArea = Basic;
                }
                field("E-Mail";"E-Mail")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field("Home Page";"Home Page")
                {
                    ApplicationArea = Basic;
                }
                field("IC Partner Code";"IC Partner Code")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field("Pay-to Vendor No.";"Pay-to Vendor No.")
                {
                    ApplicationArea = Basic;
                }
                field("Gen. Bus. Posting Group";"Gen. Bus. Posting Group")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field("VAT Bus. Posting Group";"VAT Bus. Posting Group")
                {
                    ApplicationArea = Basic;
                }
                field("Vendor Posting Group";"Vendor Posting Group")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field("Invoice Disc. Code";"Invoice Disc. Code")
                {
                    ApplicationArea = Basic;
                    NotBlank = true;
                }
                field("Prices Including VAT";"Prices Including VAT")
                {
                    ApplicationArea = Basic;
                }
                field("Prepayment %";"Prepayment %")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Payments)
            {
                Caption = 'Payments';
                field("Application Method";"Application Method")
                {
                    ApplicationArea = Basic;
                }
                field("Partner Type";"Partner Type")
                {
                    ApplicationArea = Basic;
                }
                field("Payment Terms Code";"Payment Terms Code")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field("Payment Method Code";"Payment Method Code")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field(Priority;Priority)
                {
                    ApplicationArea = Basic;
                }
                field("Cash Flow Payment Terms Code";"Cash Flow Payment Terms Code")
                {
                    ApplicationArea = Basic;
                }
                field("Our Account No.";"Our Account No.")
                {
                    ApplicationArea = Basic;
                }
                field("Block Payment Tolerance";"Block Payment Tolerance")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        if "Block Payment Tolerance" then begin
                          if Confirm(Text002,false) then
                            PaymentToleranceMgt.DelTolVendLedgEntry(Rec);
                        end else begin
                          if Confirm(Text001,false) then
                            PaymentToleranceMgt.CalcTolVendLedgEntry(Rec);
                        end;
                    end;
                }
                field("Creditor No.";"Creditor No.")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Receiving)
            {
                Caption = 'Receiving';
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field("Shipment Method Code";"Shipment Method Code")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field("Lead Time Calculation";"Lead Time Calculation")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field("Base Calendar Code";"Base Calendar Code")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                }
                label("Customized Calendar")
                {
                    ApplicationArea = Basic;
                    Caption = 'Customized Calendar';
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        CurrPage.SaveRecord;
                        TestField("Base Calendar Code");
                        //CalendarMgmt.ShowCustomizedCalendar(CustomizedCalEntry."Source Type"::Vendor,"No.",'',"Base Calendar Code");
                    end;
                }
            "}"
            group("Foreign Trade")
            {
                Caption = 'Foreign Trade';
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field("Language Code";"Language Code")
                {
                    ApplicationArea = Basic;
                }
                field("VAT Registration No.";"VAT Registration No.")
                {
                    ApplicationArea = Basic;
                }
            }
        }
        area(factboxes)
        {
            part(Control1904651607;"Vendor Statistics FactBox")
            {
                SubPageLink = "No."=FIELD("No."),
                              "Currency Filter"=FIELD("Currency Filter"),
                              "Date Filter"=FIELD("Date Filter"),
                              "Global Dimension 1 Filter"=FIELD("Global Dimension 1 Filter"),
                              "Global Dimension 2 Filter"=FIELD("Global Dimension 2 Filter");
                Visible = true;
            }
            part(Control1903435607;"Vendor Hist. Buy-from FactBox")
            {
                SubPageLink = "No."=FIELD("No."),
                              "Currency Filter"=FIELD("Currency Filter"),
                              "Date Filter"=FIELD("Date Filter"),
                              "Global Dimension 1 Filter"=FIELD("Global Dimension 1 Filter"),
                              "Global Dimension 2 Filter"=FIELD("Global Dimension 2 Filter");
                Visible = true;
            }
            part(Control1906949207;"Vendor Hist. Pay-to FactBox")
            {
                SubPageLink = "No."=FIELD("No."),
                              "Currency Filter"=FIELD("Currency Filter"),
                              "Date Filter"=FIELD("Date Filter"),
                              "Global Dimension 1 Filter"=FIELD("Global Dimension 1 Filter"),
                              "Global Dimension 2 Filter"=FIELD("Global Dimension 2 Filter");
                Visible = false;
            }
            systempart(Control1900383207;Links)
            {
                Visible = true;
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
            group("Ven&dor")
            {
                Caption = 'Ven&dor';
                Image = Vendor;
                action(Dimensions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID"=CONST(23),
                                  "No."=Page "Vendor Bank Account List";
                    RunPageLink = "Vendor No."=Page "Order Address List";
                    RunPageLink = "Vendor No."=Page "Comment Sheet";
                    RunPageLink = "Table Name"=CONST(Vendor),
                                  "No."=Page "Cross References";
                    RunPageLink = "Cross-Reference Type"=CONST(Vendor),
                                  "Cross-Reference Type No."=Page "Vendor Item Catalog";
                    RunPageLink = "Vendor No."=Page "Vend. Invoice Discounts";
                    RunPageLink = Code=Page "Purchase Prices";
                    RunPageLink = "Vendor No."=Page "Purchase Line Discounts";
                    RunPageLink = "Vendor No."=Page "Purchase Prepmt. Percentages";
                    RunPageLink = "Vendor No."=Page "Standard Vendor Purchase Codes";
                    RunPageLink = "Vendor No."=Page "Purchase Quotes";
                    RunPageLink = "Buy-from Vendor No."=Page "Purchase Order List";
                    RunPageLink = "Buy-from Vendor No."=Page "Purchase Return Order List";
                    RunPageLink = "Buy-from Vendor No."=Page "Blanket Purchase Orders";
                    RunPageLink = "Buy-from Vendor No."=Page "Vendor Ledger Entries";
                    RunPageLink = "Vendor No."=Page "Vendor Statistics";
                    RunPageLink = "No."=Page "Vendor Purchases";
                    RunPageLink = "No."=Page "Vendor Entry Statistics";
                    RunPageLink = "No."=Page "Vend. Stats. by Curr. Lines";
                    RunPageLink = "Vendor Filter"=Codeunit "Item Tracking Management"Page "Blanket Purchase Order";
                RunPageLink = "Buy-from Vendor No."=Page "Purchase Quote";
                RunPageLink = "Buy-from Vendor No."=Page "Purchase Invoice";
                RunPageLink = "Buy-from Vendor No."=Page "Purchase Order";
                RunPageLink = "Buy-from Vendor No."=Page "Purchase Credit Memo";
                RunPageLink = "Buy-from Vendor No."=Page "Purchase Return Order";
                RunPageLink = "Buy-from Vendor No."=Codeunit "Config. Template Management"Page "Payment Journal";
Page "Purchase Journal";
Report "Vendor - Labels";
Report "Vendor - Balance to Date";
Codeunit "Online Map Management"Codeunit "Calendar Management"Codeunit ""
