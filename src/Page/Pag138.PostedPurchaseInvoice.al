#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 138 "Posted Purchase Invoice"
{
    Caption = 'Posted Purchase Invoice';
    Editable = false;
    InsertAllowed = false;
    PageType = Document;
    PromotedActionCategories = 'New,Process,Report,Correct,Navigation';
    RefreshOnActivate = true;
    SourceTable = "Purch. Inv. Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No.";"No.")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the posted invoice number.';
                }
                field("Buy-from Vendor Name";"Buy-from Vendor Name")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Vendor';
                    Editable = false;
                    TableRelation = Vendor.Name;
                    ToolTip = 'Specifies the name of the vendor who shipped the items.';
                }
                group("Buy-from")
                {
                    Caption = 'Buy-from';
                    field("Buy-from Address";"Buy-from Address")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Address';
                        Editable = false;
                        Importance = Additional;
                        ToolTip = 'Specifies the address of the vendor who shipped the items.';
                    }
                    field("Buy-from Address 2";"Buy-from Address 2")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Address 2';
                        Editable = false;
                        Importance = Additional;
                        ToolTip = 'Specifies additional address information.';
                    }
                    field("Buy-from City";"Buy-from City")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'City';
                        Editable = false;
                        Importance = Additional;
                        ToolTip = 'Specifies the city of the vendor who shipped the items.';
                    }
                    field("Buy-from County";"Buy-from County")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'State';
                        Editable = false;
                        Importance = Additional;
                        ToolTip = 'Specifies the state as a part of the address.';
                    }
                    field("Buy-from Post Code";"Buy-from Post Code")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'ZIP Code';
                        Editable = false;
                        Importance = Additional;
                        ToolTip = 'Specifies the ZIP code.';
                    }
                    field("Buy-from Contact No.";"Buy-from Contact No.")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Contact No.';
                        Editable = false;
                        Importance = Additional;
                        ToolTip = 'Specifies the number of the contact you bought the items from.';
                    }
                }
                field("Buy-from Contact";"Buy-from Contact")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Contact';
                    Editable = false;
                    ToolTip = 'Specifies the name of the person to contact at the vendor who shipped the items.';
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the date the purchase header was posted.';
                }
                field("Document Date";"Document Date")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the date on which the purchase document was created.';
                }
                field("Due Date";"Due Date")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies when the invoice is due. The program calculates the date using the Payment Terms Code and Document Date fields on the purchase header.';
                }
                field("Quote No.";"Quote No.")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    ToolTip = 'Specifies the number of the purchase quote document if a quote was used to start the purchase process.';
                }
                field("Order No.";"Order No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the number of the purchase order that this invoice was posted from.';
                }
                field("Vendor Invoice No.";"Vendor Invoice No.")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the vendor''s own invoice number.';
                }
                field("Vendor Order No.";"Vendor Order No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the vendor''s order number.';
                }
                field("Pre-Assigned No.";"Pre-Assigned No.")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the number of the purchase document that the posted invoice was created for.';
                }
                field("No. Printed";"No. Printed")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies how many times the invoice has been printed.';
                }
                field("Order Address Code";"Order Address Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the order address code used in the invoice.';
                }
                field("Purchaser Code";"Purchaser Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies which purchaser is associated with the invoice.';
                }
                field("Responsibility Center";"Responsibility Center")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the code for the responsibility center that serves the vendor on this purchase document.';
                }
                field(Cancelled;Cancelled)
                {
                    ApplicationArea = Basic,Suite;
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
            part(PurchInvLines;"Posted Purch. Invoice Subform")
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = "Document No."=field("No.");
            }
            group("Invoice Details")
            {
                Caption = 'Invoice Details';
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Suite;
                    Importance = Promoted;
                    ToolTip = 'Specifies the currency code used to calculate the amounts on the invoice.';

                    trigger OnAssistEdit()
                    var
                        ChangeExchangeRate: Page "Change Exchange Rate";
                    begin
                        ChangeExchangeRate.SetParameter("Currency Code","Currency Factor","Posting Date");
                        ChangeExchangeRate.Editable(false);
                        if ChangeExchangeRate.RunModal = Action::OK then begin
                          "Currency Factor" := ChangeExchangeRate.GetParameter;
                          Modify;
                        end;
                    end;
                }
                field("Expected Receipt Date";"Expected Receipt Date")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the date on which the invoiced items were expected.';
                }
                field("Payment Terms Code";"Payment Terms Code")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the code to use to find the payment terms that apply to the purchase header.';
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the code for the dimension value associated with the invoice.';
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the code for the dimension value associated with the invoice.';
                }
                field("Payment Discount %";"Payment Discount %")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the payment discount percent granted if payment is made on or before the date in the Pmt. Discount Date field.';
                }
                field("Pmt. Discount Date";"Pmt. Discount Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the last date on which you can pay the invoice and still receive a payment discount.';
                }
                field("Tax Liable";"Tax Liable")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies if the customer or vendor is liable for sales tax.';
                }
                field("Tax Area Code";"Tax Area Code")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the tax area that is used to calculate and post sales tax.';
                }
                field("Tax Exemption No.";"Tax Exemption No.")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the vendor''s tax exemption number.';
                }
                field("Provincial Tax Area Code";"Provincial Tax Area Code")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the tax area code for self assessed Provincial Sales Tax for the company.';
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the code for the location where the items are registered.';
                }
                field("Shipment Method Code";"Shipment Method Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the code that represents the shipment method for this invoice.';
                }
                field("Payment Reference";"Payment Reference")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    ToolTip = 'Identifies the payment of the purchase invoice.';
                }
                field("Creditor No.";"Creditor No.")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    ToolTip = 'Identifies the vendor who sent the purchase invoice.';
                }
                group("Electronic Invoice")
                {
                    Caption = 'Electronic Invoice';
                    field("Fiscal Invoice Number PAC";"Fiscal Invoice Number PAC")
                    {
                        ApplicationArea = Basic,Suite;
                        ToolTip = 'Specifies the official invoice number for the electronic document.';
                    }
                }
            }
            group("Shipping and Payment")
            {
                Caption = 'Shipping and Payment';
                group("Ship-to")
                {
                    Caption = 'Ship-to';
                    field("Ship-to Code";"Ship-to Code")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Address Code';
                        Importance = Promoted;
                        ToolTip = 'Specifies the address on purchase orders shipped with a drop shipment directly from the vendor to a customer.';
                    }
                    field("Ship-to Name";"Ship-to Name")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Name';
                        Editable = false;
                        ToolTip = 'Specifies the name of the company at the address to which the items in the purchase order were shipped.';
                    }
                    field("Ship-to Address";"Ship-to Address")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Address';
                        Editable = false;
                        ToolTip = 'Specifies the address that the items in the purchase order were shipped to.';
                    }
                    field("Ship-to Address 2";"Ship-to Address 2")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Address 2';
                        Editable = false;
                        ToolTip = 'Specifies additional address information.';
                    }
                    field("Ship-to City";"Ship-to City")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'City';
                        Editable = false;
                        ToolTip = 'Specifies the city the items in the purchase order were shipped to.';
                    }
                    field("Ship-to County";"Ship-to County")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'State';
                        Editable = false;
                        ToolTip = 'Specifies the state as a part of the address.';
                    }
                    field("Ship-to Post Code";"Ship-to Post Code")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'ZIP Code';
                        Editable = false;
                        ToolTip = 'Specifies the ZIP code.';
                    }
                    field("Ship-to Contact";"Ship-to Contact")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Contact';
                        Editable = false;
                        ToolTip = 'Specifies the name of a contact person at the address that the items in the purchase order were shipped to.';
                    }
                }
                group("Pay-to")
                {
                    Caption = 'Pay-to';
                    field("Pay-to Name";"Pay-to Name")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Name';
                        Editable = false;
                        Importance = Promoted;
                        ToolTip = 'Specifies the name of the vendor who you received the invoice from.';
                    }
                    field("Pay-to Address";"Pay-to Address")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Address';
                        Editable = false;
                        Importance = Additional;
                        ToolTip = 'Specifies the address of the vendor that you received the invoice from.';
                    }
                    field("Pay-to Address 2";"Pay-to Address 2")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Address 2';
                        Editable = false;
                        Importance = Additional;
                        ToolTip = 'Specifies additional address information.';
                    }
                    field("Pay-to City";"Pay-to City")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'City';
                        Editable = false;
                        Importance = Additional;
                        ToolTip = 'Specifies the city of the vendor you received the invoice from.';
                    }
                    field("Pay-to County";"Pay-to County")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'State';
                        Editable = false;
                        Importance = Additional;
                        ToolTip = 'Specifies the state as a part of the address.';
                    }
                    field("Pay-to Post Code";"Pay-to Post Code")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'ZIP Code';
                        Editable = false;
                        Importance = Additional;
                        ToolTip = 'Specifies the ZIP code.';
                    }
                    field("Pay-to Contact No.";"Pay-to Contact No.")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Contact No.';
                        Editable = false;
                        Importance = Additional;
                        ToolTip = 'Specifies the number of the contact you received the invoice from.';
                    }
                    field("Pay-to Contact";"Pay-to Contact")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Contact';
                        Editable = false;
                        ToolTip = 'Specifies the name of the person you should contact at the vendor who you received the invoice from.';
                    }
                    field("IRS 1099 Code";"IRS 1099 Code")
                    {
                        ApplicationArea = Basic,Suite;
                        Editable = false;
                        Importance = Additional;
                        ToolTip = 'Specifies the Internal Revenue Service (IRS) 1099 code for the purchase invoice header.';
                    }
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
                                  "No."=field("No."),
                                  "Document Line No."=const(0);
                }
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension=R;
                    ApplicationArea = Suite;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edits dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                    trigger OnAction()
                    begin
                        ShowDimensions;
                    end;
                }
                action(Approvals)
                {
                    AccessByPermission = TableData "Posted Approval Entry"=R;
                    ApplicationArea = Suite;
                    Caption = 'Approvals';
                    Image = Approvals;
                    ToolTip = 'View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.ShowPostedApprovalEntries(RecordId);
                    end;
                }
            }
        }
        area(processing)
        {
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
                    ToolTip = 'Reverse this posted invoice and automatically create a new invoice with the same information that you can correct before posting. This posted invoice will automatically be canceled.';

                    trigger OnAction()
                    var
                        CorrectPstdPurchInvYesNo: Codeunit "Correct PstdPurchInv (Yes/No)";
                    begin
                        if CorrectPstdPurchInvYesNo.CorrectInvoice(Rec) then
                          CurrPage.Close;
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
                    ToolTip = 'Create and post a purchase credit memo that reverses this posted purchase invoice. This posted purchase invoice will be canceled.';

                    trigger OnAction()
                    var
                        CancelPstdPurchInvYesNo: Codeunit "Cancel PstdPurchInv (Yes/No)";
                    begin
                        if CancelPstdPurchInvYesNo.CancelInvoice(Rec) then
                          CurrPage.Close;
                    end;
                }
                action(CreateCreditMemo)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Create Corrective Credit Memo';
                    Image = CreateCreditMemo;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'Create a credit memo for this posted invoice that you complete and post manually to reverse the posted invoice.';

                    trigger OnAction()
                    var
                        PurchaseHeader: Record "Purchase Header";
                        CorrectPostedPurchInvoice: Codeunit "Correct Posted Purch. Invoice";
                    begin
                        CorrectPostedPurchInvoice.CreateCreditMemoCopyDocument(Rec,PurchaseHeader);
                        Page.Run(Page::"Purchase Credit Memo",PurchaseHeader);
                        CurrPage.Close;
                    end;
                }
            }
            group("Actions")
            {
                Caption = 'Actions';
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
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'View or edit detailed information about the vendor on the posted purchase document.';
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
                    ToolTip = 'Open the posted purchase credit memo that was created when you canceled the posted purchase invoice. If the posted purchase invoice is the result of a canceled purchase credit memo, then canceled purchase credit memo will open.';

                    trigger OnAction()
                    begin
                        ShowCanceledOrCorrCrMemo;
                    end;
                }
            }
            group(ActionGroup29)
            {
                Caption = 'Print';
                action(Print)
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
                    begin
                        CurrPage.SetSelectionFilter(PurchInvHeader);
                        PurchInvHeader.PrintRecords(true);
                    end;
                }
            }
            action(Navigate)
            {
                ApplicationArea = Basic,Suite;
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Find all entries and documents that exist for the document number and posting date on the selected entry or document.';
                Visible = not IsOfficeAddin;

                trigger OnAction()
                begin
                    Navigate;
                end;
            }
            group(IncomingDocument)
            {
                Caption = 'Incoming Document';
                Image = Documents;
                action(IncomingDocCard)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'View Incoming Document';
                    Enabled = HasIncomingDocument;
                    Image = ViewOrder;
                    ToolTip = 'View any incoming document records and file attachments that exist for the entry or document.';

                    trigger OnAction()
                    var
                        IncomingDocument: Record "Incoming Document";
                    begin
                        IncomingDocument.ShowCard("No.","Posting Date");
                    end;
                }
                action(SelectIncomingDoc)
                {
                    AccessByPermission = TableData "Incoming Document"=R;
                    ApplicationArea = Basic,Suite;
                    Caption = 'Select Incoming Document';
                    Enabled = not HasIncomingDocument;
                    Image = SelectLineToApply;
                    ToolTip = 'Select an incoming document record and file attachment that you want to link to the entry or document.';

                    trigger OnAction()
                    var
                        IncomingDocument: Record "Incoming Document";
                    begin
                        IncomingDocument.SelectIncomingDocumentForPostedDocument("No.","Posting Date",RecordId);
                    end;
                }
                action(IncomingDocAttachFile)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Create Incoming Document from File';
                    Ellipsis = true;
                    Enabled = not HasIncomingDocument;
                    Image = Attach;
                    ToolTip = 'Create an incoming document record by selecting a file to attach, and then link the incoming document record to the entry or document.';

                    trigger OnAction()
                    var
                        IncomingDocumentAttachment: Record "Incoming Document Attachment";
                    begin
                        IncomingDocumentAttachment.NewAttachmentFromPostedDocument("No.","Posting Date");
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        IncomingDocument: Record "Incoming Document";
    begin
        HasIncomingDocument := IncomingDocument.PostedDocExists("No.","Posting Date");
        CurrPage.IncomingDocAttachFactBox.Page.LoadDataFromRecord(Rec);
    end;

    trigger OnOpenPage()
    var
        OfficeMgt: Codeunit "Office Management";
    begin
        SetSecurityFilterOnRespCenter;
        IsOfficeAddin := OfficeMgt.IsAvailable;
    end;

    var
        PurchInvHeader: Record "Purch. Inv. Header";
        HasIncomingDocument: Boolean;
        IsOfficeAddin: Boolean;
}

