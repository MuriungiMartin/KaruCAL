#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 146 "Posted Purchase Invoices"
{
    ApplicationArea = Basic;
    Caption = 'Posted Purchase Invoices';
    CardPageID = "Posted Purchase Invoice";
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Correct,Navigation';
    RefreshOnActivate = true;
    SourceTable = "Purch. Inv. Header";
    SourceTableView = sorting("Posting Date")
                      order(descending);
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the posted invoice number.';
                }
                field("Buy-from Vendor No.";"Buy-from Vendor No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Vendor No.';
                    ToolTip = 'Specifies the number of the vendor that you bought the items from.';
                }
                field("Order Address Code";"Order Address Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the order address code used in the invoice.';
                    Visible = false;
                }
                field("Buy-from Vendor Name";"Buy-from Vendor Name")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Vendor';
                    ToolTip = 'Specifies the name of the vendor who shipped the items.';
                }
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the currency code used to calculate the amounts on the invoice.';
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the total, in the currency of the invoice, of the amounts on all the invoice lines.';

                    trigger OnDrillDown()
                    begin
                        SetRange("No.");
                        Page.RunModal(Page::"Posted Purchase Invoice",Rec)
                    end;
                }
                field("Amount Including VAT";"Amount Including VAT")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the total, in the currency of the invoice, of the amounts on all the invoice lines - including tax.';

                    trigger OnDrillDown()
                    begin
                        SetRange("No.");
                        Page.RunModal(Page::"Posted Purchase Invoice",Rec)
                    end;
                }
                field("Buy-from Post Code";"Buy-from Post Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ZIP code of the address.';
                    Visible = false;
                }
                field("Buy-from Country/Region Code";"Buy-from Country/Region Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the country/region code of the address.';
                    Visible = false;
                }
                field("Buy-from Contact";"Buy-from Contact")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the person to contact at the vendor who shipped the items.';
                    Visible = false;
                }
                field("Pay-to Vendor No.";"Pay-to Vendor No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the vendor who you received the invoice from.';
                    Visible = false;
                }
                field("Pay-to Name";"Pay-to Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the vendor who you received the invoice from.';
                    Visible = false;
                }
                field("Pay-to Post Code";"Pay-to Post Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ZIP code of the address.';
                    Visible = false;
                }
                field("Pay-to Country/Region Code";"Pay-to Country/Region Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the country/region code of the address.';
                    Visible = false;
                }
                field("Pay-to Contact";"Pay-to Contact")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the person you should contact at the vendor who you received the invoice from.';
                    Visible = false;
                }
                field("Ship-to Code";"Ship-to Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the shipment of the sales order that is linked to the purchase order for drop shipment from the vendor to a customer.';
                    Visible = false;
                }
                field("Ship-to Name";"Ship-to Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the company at the address to which the items were shipped.';
                    Visible = false;
                }
                field("Ship-to Post Code";"Ship-to Post Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ZIP code of the address.';
                    Visible = false;
                }
                field("Ship-to Country/Region Code";"Ship-to Country/Region Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the country/region code of the address.';
                    Visible = false;
                }
                field("Ship-to Contact";"Ship-to Contact")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of a contact person at the address that the items were shipped to.';
                    Visible = false;
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date the purchase header was posted.';
                    Visible = false;
                }
                field("Purchaser Code";"Purchaser Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies which purchaser is associated with the invoice.';
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the dimension value associated with the invoice.';
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the dimension value associated with the invoice.';
                    Visible = false;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the location where the items are registered.';
                }
                field("No. Printed";"No. Printed")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how many times the invoice has been printed.';
                }
                field("Document Date";"Document Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the purchase document was created.';
                    Visible = false;
                }
                field("Payment Terms Code";"Payment Terms Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code to use to find the payment terms that apply to the purchase header.';
                    Visible = false;
                }
                field("Due Date";"Due Date")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies when the invoice is due. The program calculates the date using the Payment Terms Code and Document Date fields on the purchase header.';
                }
                field("Payment Discount %";"Payment Discount %")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the payment discount percent granted if payment is made on or before the date in the Pmt. Discount Date field.';
                    Visible = false;
                }
                field("Payment Method Code";"Payment Method Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the method of payment for payments to vendors.';
                    Visible = false;
                }
                field("Shipment Method Code";"Shipment Method Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code that represents the shipment method for this invoice.';
                    Visible = false;
                }
                field("Remaining Amount";"Remaining Amount")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the amount that remains to be paid for the posted purchase invoice.';
                }
                field(Closed;Closed)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies if the posted purchase invoice is paid. The check box will also be selected if a credit memo for the remaining amount has been applied.';
                }
                field(Cancelled;Cancelled)
                {
                    ApplicationArea = Basic,Suite;
                    HideValue = not Cancelled;
                    Importance = Additional;
                    Style = Unfavorable;
                    StyleExpr = Cancelled;
                    ToolTip = 'Specifies if the posted purchase invoice has been either corrected or canceled.';

                    trigger OnDrillDown()
                    begin
                        ShowCorrectiveCreditMemo;
                    end;
                }
                field(Corrective;Corrective)
                {
                    ApplicationArea = Basic,Suite;
                    HideValue = not Corrective;
                    Importance = Additional;
                    Style = Unfavorable;
                    StyleExpr = Corrective;
                    ToolTip = 'Specifies if the posted purchase invoice is a corrective document.';

                    trigger OnDrillDown()
                    begin
                        ShowCancelledCreditMemo;
                    end;
                }
            }
        }
        area(factboxes)
        {
            part(IncomingDocAttachFactBox;"Incoming Doc. Attach. FactBox")
            {
                ApplicationArea = Basic,Suite;
                ShowFilter = false;
                Visible = not IsOfficeAddin;
            }
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Invoice")
            {
                Caption = '&Invoice';
                Image = Invoice;
                action(Statistics)
                {
                    ApplicationArea = Basic;
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'F7';

                    trigger OnAction()
                    begin
                        if "Tax Area Code" = '' then
                          Page.RunModal(Page::"Purchase Invoice Statistics",Rec,"No.")
                        else
                          Page.RunModal(Page::"Purchase Invoice Stats.",Rec,"No.");
                    end;
                }
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Purch. Comment Sheet";
                    RunPageLink = "Document Type"=const("Posted Invoice"),
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
                action(IncomingDoc)
                {
                    AccessByPermission = TableData "Incoming Document"=R;
                    ApplicationArea = Basic;
                    Caption = 'Incoming Document';
                    Image = Document;

                    trigger OnAction()
                    var
                        IncomingDocument: Record "Incoming Document";
                    begin
                        IncomingDocument.ShowCard("No.","Posting Date");
                    end;
                }
            }
        }
        area(processing)
        {
            group(Navigation)
            {
                Caption = 'Navigation';
                Image = Invoice;
                action(Vendor)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Vendor';
                    Image = Vendor;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    RunObject = Page "Vendor Card";
                    RunPageLink = "No."=field("Buy-from Vendor No.");
                    Scope = Repeater;
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'View or edit detailed information about the vendor on the selected posted purchase document.';
                }
                action(ShowCreditMemo)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Show Canceled/Corrective Credit Memo';
                    Enabled = Cancelled or Corrective;
                    Image = CreditMemo;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    Scope = Repeater;
                    ToolTip = 'Open the posted purchase credit memo that was created when you canceled the posted purchase invoice. If the posted purchase invoice is the result of a canceled purchase credit memo, then canceled purchase credit memo will open.';

                    trigger OnAction()
                    begin
                        ShowCanceledOrCorrCrMemo;
                    end;
                }
                action(Navigate)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = '&Navigate';
                    Image = Navigate;
                    Promoted = true;
                    PromotedCategory = Category5;
                    Scope = Repeater;
                    ToolTip = 'Find all entries and documents that exist for the document number and posting date on the selected posted purchase document.';
                    Visible = not IsOfficeAddin;

                    trigger OnAction()
                    begin
                        Navigate;
                    end;
                }
            }
            group(Correct)
            {
                Caption = 'Correct';
                action(CorrectInvoice)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Correct';
                    Image = Undo;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    Scope = Repeater;
                    ToolTip = 'Reverse this posted invoice and automatically create a new invoice with the same information that you can correct before posting. This posted invoice will automatically be canceled.';

                    trigger OnAction()
                    begin
                        Codeunit.Run(Codeunit::"Correct PstdPurchInv (Yes/No)",Rec);
                    end;
                }
                action(CancelInvoice)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Cancel';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    Scope = Repeater;
                    ToolTip = 'Create and post a purchase credit memo that reverses this posted purchase invoice. This posted purchase invoice will be canceled.';

                    trigger OnAction()
                    begin
                        Codeunit.Run(Codeunit::"Cancel PstdPurchInv (Yes/No)",Rec);
                    end;
                }
                action(CreateCreditMemo)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Create Corrective Credit Memo';
                    Image = CreateCreditMemo;
                    Promoted = true;
                    PromotedCategory = Category4;
                    Scope = Repeater;
                    ToolTip = 'Create a credit memo for this posted invoice that you complete and post manually to reverse the posted invoice.';

                    trigger OnAction()
                    var
                        PurchaseHeader: Record "Purchase Header";
                        CorrectPostedPurchInvoice: Codeunit "Correct Posted Purch. Invoice";
                    begin
                        CorrectPostedPurchInvoice.CreateCreditMemoCopyDocument(Rec,PurchaseHeader);
                        Page.Run(Page::"Purchase Credit Memo",PurchaseHeader);
                    end;
                }
            }
            action("&Print")
            {
                ApplicationArea = Basic,Suite;
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.';
                Visible = not IsOfficeAddin;

                trigger OnAction()
                var
                    PurchInvHeader: Record "Purch. Inv. Header";
                begin
                    CurrPage.SetSelectionFilter(PurchInvHeader);
                    PurchInvHeader.PrintRecords(true);
                end;
            }
            action("Purchase - Invoice")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Purchase - Invoice';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Report "Purchase Invoice";
                ToolTip = 'Print purchase invoices. You can print all or specific purchase invoices. The unit price quoted on this form is the direct price adjusted by any line discounts or other adjustments.';
            }
        }
        area(reporting)
        {
            action("Outstanding Purch. Order Aging")
            {
                ApplicationArea = Basic;
                Caption = 'Outstanding Purch. Order Aging';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Outstanding Purch. Order Aging";
            }
            action("Outstanding Purch. Order Status")
            {
                ApplicationArea = Basic;
                Caption = 'Outstanding Purch. Order Status';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Outstanding Purch.Order Status";
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.IncomingDocAttachFactBox.Page.LoadDataFromRecord(Rec);
    end;

    trigger OnOpenPage()
    var
        OfficeMgt: Codeunit "Office Management";
    begin
        SetSecurityFilterOnRespCenter;
        if FindFirst then;
        IsOfficeAddin := OfficeMgt.IsAvailable;
    end;

    var
        IsOfficeAddin: Boolean;
}

