#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 144 "Posted Sales Credit Memos"
{
    ApplicationArea = Basic;
    Caption = 'Posted Sales Credit Memos';
    CardPageID = "Posted Sales Credit Memo";
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Credit Memo,Cancel';
    SourceTable = "Sales Cr.Memo Header";
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
                    ApplicationArea = All;
                    ToolTip = 'Specifies the posted credit memo number.';
                }
                field("Sell-to Customer No.";"Sell-to Customer No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the customer number associated with the credit memo.';
                }
                field("Sell-to Customer Name";"Sell-to Customer Name")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Customer Name';
                    ToolTip = 'Specifies the name of the customer that you shipped the items on the credit memo to.';
                }
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the currency code of the credit memo.';
                }
                field("Due Date";"Due Date")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the date on which the shipment is due for payment.';
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the total of the amounts on all the credit memo lines, in the currency of the credit memo. The amount does not include tax.';

                    trigger OnDrillDown()
                    begin
                        SetRange("No.");
                        Page.RunModal(Page::"Posted Sales Credit Memo",Rec)
                    end;
                }
                field("Amount Including VAT";"Amount Including VAT")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the total of the amounts in all the amount fields on the credit memo, in the currency of the credit memo. The amount includes tax.';

                    trigger OnDrillDown()
                    begin
                        SetRange("No.");
                        Page.RunModal(Page::"Posted Sales Credit Memo",Rec)
                    end;
                }
                field("Remaining Amount";"Remaining Amount")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the amount that remains to be paid for the posted sales invoice.';
                }
                field(Paid;Paid)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies if the posted sales invoice that relates to this sales credit memo is paid.';
                }
                field(Cancelled;Cancelled)
                {
                    ApplicationArea = Basic,Suite;
                    HideValue = not Cancelled;
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
                    HideValue = not Corrective;
                    Style = Unfavorable;
                    StyleExpr = Corrective;
                    ToolTip = 'Specifies if the posted sales invoice has been either corrected or canceled by this sales credit memo.';

                    trigger OnDrillDown()
                    begin
                        ShowCancelledInvoice;
                    end;
                }
                field("Sell-to Post Code";"Sell-to Post Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ZIP code of the address.';
                    Visible = false;
                }
                field("Sell-to Country/Region Code";"Sell-to Country/Region Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the country/region code of the address.';
                    Visible = false;
                }
                field("Sell-to Contact";"Sell-to Contact")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the person to contact when you communicate with the customer that you shipped the items on the credit memo to.';
                    Visible = false;
                }
                field("Bill-to Customer No.";"Bill-to Customer No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the customer the credit memo was sent to.';
                    Visible = false;
                }
                field("Bill-to Name";"Bill-to Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the customer that the credit memo was sent to.';
                    Visible = false;
                }
                field("Bill-to Post Code";"Bill-to Post Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ZIP code of the address.';
                    Visible = false;
                }
                field("Bill-to Country/Region Code";"Bill-to Country/Region Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the country/region code of the address.';
                    Visible = false;
                }
                field("Bill-to Contact";"Bill-to Contact")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the person you regularly contact when you communicate with the customer to whom the credit memo was sent.';
                    Visible = false;
                }
                field("Ship-to Code";"Ship-to Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'This field is used with shipments to customers with multiple ship-to addresses.';
                    Visible = false;
                }
                field("Ship-to Name";"Ship-to Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the customer that the items were shipped to.';
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
                    ToolTip = 'Specifies the name of the person you regularly contact at the customer to whom the items were shipped.';
                    Visible = false;
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the credit memo was posted.';
                    Visible = false;
                }
                field("Salesperson Code";"Salesperson Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies which salesperson is associated with the credit memo.';
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the dimension value code associated with the credit memo.';
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the dimension value code associated with the credit memo.';
                    Visible = false;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the location where the credit memo was registered.';
                }
                field("Electronic Document Status";"Electronic Document Status")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the status of the document.';
                }
                field("Date/Time Stamped";"Date/Time Stamped")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the date and time that the document received a digital stamp from the authorized service provider.';
                    Visible = false;
                }
                field("Date/Time Sent";"Date/Time Sent")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the date and time that the document was sent to the customer.';
                    Visible = false;
                }
                field("Date/Time Canceled";"Date/Time Canceled")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the date and time that the document was canceled.';
                    Visible = false;
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
                field("No. Printed";"No. Printed")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how many times the credit memo has been printed.';
                }
                field("Document Date";"Document Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when you created the sales document.';
                    Visible = false;
                }
                field("Applies-to Doc. Type";"Applies-to Doc. Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether the credit memo has been applied to an already-posted document.';
                    Visible = false;
                }
                field("Document Exchange Status";"Document Exchange Status")
                {
                    ApplicationArea = Basic,Suite;
                    StyleExpr = DocExchStatusStyle;
                    ToolTip = 'Specifies the status of the document if you are using a document exchange service to send it as an electronic document. The status values are reported by the document exchange service.';
                    Visible = DocExchStatusVisible;

                    trigger OnDrillDown()
                    begin
                        DocExchStatusDrillDown;
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
                Visible = false;
            }
        }
    }

    actions
    {
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
            group("&Credit Memo")
            {
                Caption = '&Credit Memo';
                Image = CreditMemo;
                action(Card)
                {
                    ApplicationArea = Basic;
                    Caption = 'Card';
                    Image = EditLines;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F7';

                    trigger OnAction()
                    begin
                        Page.Run(Page::"Posted Sales Credit Memo",Rec)
                    end;
                }
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
                                  "No."=field("No.");
                }
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension=R;
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
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
                    ApplicationArea = Basic,Suite;
                    Caption = 'Incoming Document';
                    Image = Document;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'View or create an incoming document record that is linked to the entry or document.';

                    trigger OnAction()
                    var
                        IncomingDocument: Record "Incoming Document";
                    begin
                        IncomingDocument.ShowCard("No.","Posting Date");
                    end;
                }
                action(Customer)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Customer';
                    Image = Customer;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    RunObject = Page "Customer Card";
                    RunPageLink = "No."=field("Sell-to Customer No.");
                    Scope = Repeater;
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'View or edit detailed information about the customer.';
                }
                action("&Navigate")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = '&Navigate';
                    Image = Navigate;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    Scope = Repeater;
                    ToolTip = 'Find all entries and documents that exist for the document number and posting date on the selected posted sales document.';
                    Visible = not IsOfficeAddin;

                    trigger OnAction()
                    begin
                        Navigate;
                    end;
                }
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
                    Scope = Repeater;
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
            action("Sales - Credit Memo")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Sales - Credit Memo';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Report "Sales Credit Memo";
                ToolTip = 'View all sales credit memos. You can print on pre-printed credit memo forms, generic forms or on plain paper. The unit price quoted on this form is the direct price adjusted by any line discounts or other adjustments.';
            }
        }
        area(reporting)
        {
            action("Outstanding Sales Order Aging")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Outstanding Sales Order Aging';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Outstanding Sales Order Aging";
                ToolTip = 'View customer orders aged by their target shipping date. Only orders that have not been shipped appear on the report.';
            }
            action("Outstanding Sales Order Status")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Outstanding Sales Order Status';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Outstanding Sales Order Status";
                ToolTip = 'View detailed outstanding order information for each customer. This report includes shipping information, quantities ordered, and the amount that is back ordered.';
            }
            action("Daily Invoicing Report")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Daily Invoicing Report';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Daily Invoicing Report";
                ToolTip = 'View the total invoice or credit memo activity, or both. This report can be run for a particular day, or range of dates. The report shows one line for each invoice or credit memo. You can view the customer number, name, payment terms, salesperson code, amount, sales tax, amount including tax, and total of all invoices or credit memos.';
            }
            group(Send)
            {
                Caption = 'Send';
                action(SendCustom)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Send';
                    Ellipsis = true;
                    Image = SendToMultiple;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Scope = Repeater;
                    ToolTip = 'Prepare to send the document according to the customer''s sending profile, such as attached to an email. The Send document to window opens where you can confirm or select a sending profile.';

                    trigger OnAction()
                    var
                        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
                    begin
                        SalesCrMemoHeader := Rec;
                        CurrPage.SetSelectionFilter(SalesCrMemoHeader);
                        SalesCrMemoHeader.SendRecords;
                    end;
                }
                action("&Print")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = '&Print';
                    Ellipsis = true;
                    Image = Print;
                    Scope = Repeater;
                    ToolTip = 'Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.';
                    Visible = not IsOfficeAddin;

                    trigger OnAction()
                    var
                        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
                    begin
                        SalesCrMemoHeader := Rec;
                        CurrPage.SetSelectionFilter(SalesCrMemoHeader);
                        SalesCrMemoHeader.PrintRecords(true);
                    end;
                }
                action("Send by &Email")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Send by &Email';
                    Image = Email;
                    Scope = Repeater;
                    ToolTip = 'Prepare to send the document by email. The Send Email window opens prefilled for the customer where you can add or change information before you send the email.';

                    trigger OnAction()
                    var
                        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
                    begin
                        SalesCrMemoHeader := Rec;
                        CurrPage.SetSelectionFilter(SalesCrMemoHeader);
                        SalesCrMemoHeader.EmailRecords(true);
                    end;
                }
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
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        DocExchStatusStyle := GetDocExchStatusStyle;
        CurrPage.IncomingDocAttachFactBox.Page.LoadDataFromRecord(Rec);
    end;

    trigger OnAfterGetRecord()
    var
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
    begin
        DocExchStatusStyle := GetDocExchStatusStyle;

        SalesCrMemoHeader.CopyFilters(Rec);
        SalesCrMemoHeader.SetFilter("Document Exchange Status",'<>%1',"document exchange status"::"Not Sent");
        DocExchStatusVisible := not SalesCrMemoHeader.IsEmpty;
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
        DocExchStatusStyle: Text;
        DocExchStatusVisible: Boolean;
        IsOfficeAddin: Boolean;
}

