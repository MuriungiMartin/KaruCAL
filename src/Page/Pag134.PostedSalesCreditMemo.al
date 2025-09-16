#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 134 "Posted Sales Credit Memo"
{
    Caption = 'Posted Sales Credit Memo';
    Editable = false;
    InsertAllowed = false;
    PageType = Document;
    PromotedActionCategories = 'New,Process,Report,Cr. Memo,Cancel,Credit Card';
    RefreshOnActivate = true;
    SourceTable = "Sales Cr.Memo Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No.";"No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the posted credit memo number.';
                }
                field("Sell-to Customer Name";"Sell-to Customer Name")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Customer';
                    Editable = false;
                    ShowMandatory = true;
                    TableRelation = Customer.Name;
                    ToolTip = 'Specifies the name of the customer that you shipped the items on the credit memo to.';
                }
                group("Sell-to")
                {
                    Caption = 'Sell-to';
                    field("Sell-to Address";"Sell-to Address")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Address';
                        Editable = false;
                        Importance = Additional;
                        ToolTip = 'Specifies the address of the customer that the items on the credit memo were sent to.';
                    }
                    field("Sell-to Address 2";"Sell-to Address 2")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Address 2';
                        Editable = false;
                        Importance = Additional;
                        ToolTip = 'Specifies additional address information.';
                    }
                    field("Sell-to City";"Sell-to City")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'City';
                        Editable = false;
                        Importance = Additional;
                        ToolTip = 'Specifies the city the items on the credit memo were shipped to.';
                    }
                    field("Sell-to County";"Sell-to County")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'State';
                        Editable = false;
                        Importance = Additional;
                        ToolTip = 'Specifies the state as a part of the address.';
                    }
                    field("Sell-to Post Code";"Sell-to Post Code")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'ZIP Code';
                        Editable = false;
                        Importance = Additional;
                        ToolTip = 'Specifies the ZIP code.';
                    }
                    field("Sell-to Contact No.";"Sell-to Contact No.")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Contact No.';
                        Editable = false;
                        Importance = Additional;
                        ToolTip = 'Specifies the number of the contact at the customer who handles the credit memo.';
                    }
                }
                field("Sell-to Contact";"Sell-to Contact")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Contact';
                    Editable = false;
                    ToolTip = 'Specifies the name of the person to contact when you communicate with the customer who you shipped the items on the credit memo to.';
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the date on which the credit memo was posted.';
                }
                field("Document Date";"Document Date")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the date on which you created the sales document.';
                }
                group(Control20)
                {
                    Visible = DocExchStatusVisible;
                    field("Document Exchange Status";"Document Exchange Status")
                    {
                        ApplicationArea = Basic,Suite;
                        Editable = false;
                        StyleExpr = DocExchStatusStyle;
                        ToolTip = 'Specifies the status of the document if you are using a document exchange service to send it as an electronic document. The status values are reported by the document exchange service.';

                        trigger OnDrillDown()
                        begin
                            DocExchStatusDrillDown;
                        end;
                    }
                }
                field("Pre-Assigned No.";"Pre-Assigned No.")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the number of the credit memo that the posted credit memo was created from.';
                }
                field("External Document No.";"External Document No.")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the external document number that is entered on the sales header that this line was posted from.';
                }
                field("Salesperson Code";"Salesperson Code")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies which salesperson is associated with the credit memo.';
                }
                field("Responsibility Center";"Responsibility Center")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the code for the responsibility center that serves the customer on this sales document.';
                }
                field(Cancelled;Cancelled)
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    Style = Unfavorable;
                    StyleExpr = Cancelled;
                    ToolTip = 'Specifies if the posted sales invoice that relates to this sales credit memo has been either corrected or canceled.';

                    trigger OnDrillDown()
                    begin
                        ShowCorrectiveInvoice;
                    end;
                }
                field(Corrective;Corrective)
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    Style = Unfavorable;
                    StyleExpr = Corrective;
                    ToolTip = 'Specifies if the posted sales invoice has been either corrected or canceled by this sales credit memo.';

                    trigger OnDrillDown()
                    begin
                        ShowCancelledInvoice;
                    end;
                }
                field("No. Printed";"No. Printed")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies how many times the credit memo has been printed.';
                }
            }
            part(SalesCrMemoLines;"Posted Sales Cr. Memo Subform")
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
                    ToolTip = 'Specifies the currency code of the credit memo.';

                    trigger OnAssistEdit()
                    begin
                        ChangeExchangeRate.SetParameter("Currency Code","Currency Factor","Posting Date");
                        ChangeExchangeRate.Editable(false);
                        if ChangeExchangeRate.RunModal = Action::OK then begin
                          "Currency Factor" := ChangeExchangeRate.GetParameter;
                          Modify;
                        end;
                        Clear(ChangeExchangeRate);
                    end;
                }
            }
            group("Electronic Invoice")
            {
                Caption = 'Electronic Invoice';
                field("Electronic Document Status";"Electronic Document Status")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the status of the document.';
                }
                field("Date/Time Stamped";"Date/Time Stamped")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the date and time that the document received a digital stamp from the authorized service provider.';
                }
                field("Date/Time Sent";"Date/Time Sent")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the date and time that the document was sent to the customer.';
                }
                field("Date/Time Canceled";"Date/Time Canceled")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the date and time that the document was canceled.';
                }
                field("Error Code";"Error Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the error code that the authorized service provider, PAC, has returned to Microsoft Dynamics NAV.';
                }
                field("Error Description";"Error Description")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the error message that the authorized service provider, PAC, has returned to Microsoft Dynamics NAV.';
                }
                field("PAC Web Service Name";"PAC Web Service Name")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the name of the authorized service provider, PAC, which has processed the electronic document.';
                }
                field("Fiscal Invoice Number PAC";"Fiscal Invoice Number PAC")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the official invoice number for the electronic document.';
                }
                field("No. of E-Documents Sent";"No. of E-Documents Sent")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number of times that this document has been sent electronically.';
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    ToolTip = 'Specifies the code for Shortcut Dimension 1.';
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    ToolTip = 'Specifies the code for Shortcut Dimension 2.';
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the location where the credit memo was registered.';
                }
                field("Applies-to Doc. Type";"Applies-to Doc. Type")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the type of the posted document that this document or journal line is applied to.';
                }
                field("Applies-to Doc. No.";"Applies-to Doc. No.")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the number of the posted document that this document or journal line is applied to.';
                }
                field("Payment Method Code";"Payment Method Code")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the customer''s method of payment. The program has copied the code from the Payment Method Code field on the sales header.';
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
            }
            group("Shipping and Billing")
            {
                Caption = 'Shipping and Billing';
                group("Ship-to")
                {
                    Caption = 'Ship-to';
                    field("Ship-to Name";"Ship-to Name")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Name';
                        Editable = false;
                        ToolTip = 'Specifies the name of the customer that the items were shipped to.';
                    }
                    field("Ship-to Address";"Ship-to Address")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Address';
                        Editable = false;
                        ToolTip = 'Specifies the address that the items were shipped to.';
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
                        ToolTip = 'Specifies the city the items were shipped to.';
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
                        ToolTip = 'Specifies the name of the person you regularly contact at the customer to whom the items were shipped.';
                    }
                    field("Ship-to UPS Zone";"Ship-to UPS Zone")
                    {
                        ApplicationArea = Basic;
                        Caption = 'UPS Zone';
                        Editable = false;
                        ToolTip = 'Specifies the Ship-to UPS Zone of the customer to whom the credit memo was sent.';
                    }
                }
                group("Bill-to")
                {
                    Caption = 'Bill-to';
                    field("Bill-to Name";"Bill-to Name")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Name';
                        Editable = false;
                        Importance = Promoted;
                        ToolTip = 'Specifies the name of the customer that the credit memo was sent to.';
                    }
                    field("Bill-to Address";"Bill-to Address")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Address';
                        Editable = false;
                        Importance = Additional;
                        ToolTip = 'Specifies the address of the customer that the credit memo was sent to.';
                    }
                    field("Bill-to Address 2";"Bill-to Address 2")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Address 2';
                        Editable = false;
                        Importance = Additional;
                        ToolTip = 'Specifies additional address information.';
                    }
                    field("Bill-to City";"Bill-to City")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'City';
                        Editable = false;
                        Importance = Additional;
                        ToolTip = 'Specifies the city the credit memo was sent to.';
                    }
                    field("Bill-to County";"Bill-to County")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'State';
                        Editable = false;
                        Importance = Additional;
                        ToolTip = 'Specifies the state as a part of the address.';
                    }
                    field("Bill-to Post Code";"Bill-to Post Code")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'ZIP Code';
                        Editable = false;
                        Importance = Additional;
                        ToolTip = 'Specifies the ZIP code.';
                    }
                    field("Bill-to Contact No.";"Bill-to Contact No.")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Contact No.';
                        Editable = false;
                        Importance = Additional;
                        ToolTip = 'Specifies the number of the contact at the customer who handles the credit memo.';
                    }
                    field("Bill-to Contact";"Bill-to Contact")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Contact';
                        Editable = false;
                        ToolTip = 'Specifies the name of the person you regularly contact when you communicate with the customer to whom the credit memo was sent.';
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
            group("&Cr. Memo")
            {
                Caption = '&Cr. Memo';
                Image = CreditMemo;
                action(Statistics)
                {
                    ApplicationArea = Basic;
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ShortCutKey = 'F7';

                    trigger OnAction()
                    begin
                        if "Tax Area Code" = '' then
                          Page.RunModal(Page::"Sales Credit Memo Statistics",Rec,"No.")
                        else
                          Page.RunModal(Page::"Sales Credit Memo Stats.",Rec,"No.");
                    end;
                }
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    RunObject = Page "Sales Comment Sheet";
                    RunPageLink = "Document Type"=const("Posted Credit Memo"),
                                  "No."=field("No."),
                                  "Document Line No."=const(0);
                    ToolTip = 'View or add notes about the posted sales credit memo.';
                }
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension=R;
                    ApplicationArea = Suite;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
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
            group("&Electronic Document")
            {
                Caption = '&Electronic Document';
                action("S&end")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'S&end';
                    Ellipsis = true;
                    Image = SendTo;
                    ToolTip = 'Send an email to the customer with the electronic credit memo attached as an XML file.';

                    trigger OnAction()
                    begin
                        RequestStampEDocument;
                    end;
                }
                action("Export E-Document as &XML")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Export E-Document as &XML';
                    Image = ExportElectronicDocument;
                    ToolTip = 'Export the posted sales credit memo as an electronic credit memo, an XML file, and save it to a specified location.';

                    trigger OnAction()
                    begin
                        ExportEDocument;
                    end;
                }
                action("&Cancel")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = '&Cancel';
                    Image = Cancel;
                    ToolTip = 'Cancel the sending of the electronic credit memo invoice.';

                    trigger OnAction()
                    begin
                        CancelEDocument;
                    end;
                }
            }
            action(Customer)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Customer';
                Image = Customer;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Customer Card";
                RunPageLink = "No."=field("Sell-to Customer No.");
                ShortCutKey = 'Shift+F7';
                ToolTip = 'View or edit detailed information about the customer on the posted sales document.';
            }
            action(SendCustom)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Send';
                Ellipsis = true;
                Image = SendToMultiple;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ToolTip = 'Prepare to send the document according to the customer''s sending profile, such as attached to an email. The Send document to window opens first so you can confirm or select a sending profile.';

                trigger OnAction()
                var
                    SalesCrMemoHeader: Record "Sales Cr.Memo Header";
                begin
                    SalesCrMemoHeader := Rec;
                    CurrPage.SetSelectionFilter(SalesCrMemoHeader);
                    SalesCrMemoHeader.SendRecords;
                end;
            }
            action(Print)
            {
                ApplicationArea = Basic,Suite;
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                ToolTip = 'Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.';
                Visible = not IsOfficeAddin;

                trigger OnAction()
                begin
                    SalesCrMemoHeader := Rec;
                    CurrPage.SetSelectionFilter(SalesCrMemoHeader);
                    SalesCrMemoHeader.PrintRecords(true);
                end;
            }
            action("Send by &Email")
            {
                ApplicationArea = All;
                Caption = 'Send by &Email';
                Image = Email;
                ToolTip = 'Send the sales credit memo document as a PDF file attached to an email.';

                trigger OnAction()
                begin
                    SalesCrMemoHeader := Rec;
                    CurrPage.SetSelectionFilter(SalesCrMemoHeader);
                    SalesCrMemoHeader.EmailRecords(true);
                end;
            }
            action("&Navigate")
            {
                ApplicationArea = Basic,Suite;
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ToolTip = 'Find all entries and documents that exist for the document number and posting date on the selected entry or document.';
                Visible = not IsOfficeAddin;

                trigger OnAction()
                begin
                    Navigate;
                end;
            }
            action(ActivityLog)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Activity Log';
                Image = Log;
                ToolTip = 'View the status and any errors if the document was sent as an electronic document or OCR file through the document exchange service.';

                trigger OnAction()
                begin
                    ShowActivityLog;
                end;
            }
            group(Cancel)
            {
                Caption = 'Cancel';
                action(CancelCrMemo)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Cancel';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    ToolTip = 'Create and post a sales invoice that reverses this posted sales credit memo. This posted sales credit memo will be canceled.';

                    trigger OnAction()
                    begin
                        Codeunit.Run(Codeunit::"Cancel PstdSalesCrM (Yes/No)",Rec);
                    end;
                }
                action(ShowInvoice)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Show Canceled/Corrective Invoice';
                    Enabled = Cancelled or Corrective;
                    Image = Invoice;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    Scope = Repeater;
                    ToolTip = 'Open the posted sales invoice that was created when you canceled the posted sales credit memo. If the posted sales credit memo is the result of a canceled sales invoice, then canceled invoice will open.';

                    trigger OnAction()
                    begin
                        ShowCanceledOrCorrInvoice;
                    end;
                }
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
        DocExchStatusStyle := GetDocExchStatusStyle;
        DocExchStatusVisible := DocExchangeStatusIsSent;
        CurrPage.IncomingDocAttachFactBox.Page.LoadDataFromRecord(Rec);
    end;

    trigger OnAfterGetRecord()
    begin
        DocExchStatusStyle := GetDocExchStatusStyle;
    end;

    trigger OnOpenPage()
    var
        OfficeMgt: Codeunit "Office Management";
    begin
        SetSecurityFilterOnRespCenter;
        IsOfficeAddin := OfficeMgt.IsAvailable;
    end;

    var
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        ChangeExchangeRate: Page "Change Exchange Rate";
        HasIncomingDocument: Boolean;
        DocExchStatusStyle: Text;
        DocExchStatusVisible: Boolean;
        IsOfficeAddin: Boolean;
}

