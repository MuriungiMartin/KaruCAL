#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9300 "Sales Quotes"
{
    ApplicationArea = Basic;
    Caption = 'Sales Quotes';
    CardPageID = "Sales Quote";
    DataCaptionFields = "Sell-to Customer No.";
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Quote,Request Approval';
    SourceTable = "Sales Header";
    SourceTableView = where("Document Type"=const(Quote));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No.";"No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the sales document. The field can be filled automatically or manually and can be set up to be invisible.';
                }
                field("Sell-to Customer No.";"Sell-to Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the customer who will receive the products and be billed by default. When you fill this field, most of the other fields on the document are filled from the customer card.';
                }
                field("Sell-to Customer Name";"Sell-to Customer Name")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the name of the customer who will receive the products and be billed by default.';
                }
                field("External Document No.";"External Document No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number that the customer uses in their own system to refer to this sales document.';
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
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the name of the person to contact at the customer that the items were sold to.';
                }
                field("Bill-to Customer No.";"Bill-to Customer No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the customer to whom you will send the sales invoice when this customer is different from the sell-to customer.';
                    Visible = false;
                }
                field("Bill-to Name";"Bill-to Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the customer to whom you will send the sales invoice, when different from the customer that you are selling to.';
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
                    ToolTip = 'Specifies the name of the person you should contact at the customer who you are sending the invoice to.';
                    Visible = false;
                }
                field("Ship-to Code";"Ship-to Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for another shipment address than the customer''s own address, which is entered by default.';
                    Visible = false;
                }
                field("Ship-to Name";"Ship-to Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name that products on the sales document will be shipped to.';
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
                    ToolTip = 'Specifies the name of the contact person at the address that products will be shipped to.';
                    Visible = false;
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the date when the posting of the sales document will be recorded.';
                }
                field("Due Date";"Due Date")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies when the sales invoice must be paid.';
                }
                field("Requested Delivery Date";"Requested Delivery Date")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the date that the customer has asked for the order to be delivered.';
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the sum of amounts in the Line Amount field on the sales order lines. It is used to calculate the invoice discount of the sales order.';
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the dimension value code associated with the sales header.';
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the dimension value code associated with the sales header.';
                    Visible = false;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the location from where inventory items to the customer on the sales document are to be shipped by default.';
                }
                field("Shipping Agent Code";"Shipping Agent Code")
                {
                    ApplicationArea = Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies which shipping agent is used to transport the items on the sales document to the customer.';
                    Visible = false;
                }
                field("Shipping Agent Service Code";"Shipping Agent Service Code")
                {
                    ApplicationArea = Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the code that represents the default shipping agent service you are using for this sales order.';
                    Visible = false;
                }
                field("Salesperson Code";"Salesperson Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the sales person who is assigned to the customer.';
                    Visible = false;
                }
                field("Assigned User ID";"Assigned User ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ID of the user who is responsible for the document.';
                }
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the currency of amounts on the sales document.';
                    Visible = false;
                }
                field("Document Date";"Document Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when you created the sales document.';
                    Visible = false;
                }
                field("Campaign No.";"Campaign No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the campaign that the document is linked to.';
                    Visible = false;
                }
                field("Opportunity No.";"Opportunity No.")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the number of the opportunity that the sales quote is assigned to.';
                    Visible = false;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether the document is open, waiting to be approved, has been invoiced for prepayment, or has been released to the next stage of processing.';
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            part(Control1902018507;"Customer Statistics FactBox")
            {
                SubPageLink = "No."=field("Bill-to Customer No.");
            }
            part(Control1900316107;"Customer Details FactBox")
            {
                SubPageLink = "No."=field("Sell-to Customer No.");
            }
            part(IncomingDocAttachFactBox;"Incoming Doc. Attach. FactBox")
            {
                ShowFilter = false;
                Visible = false;
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
            group("&Quote")
            {
                Caption = '&Quote';
                Image = Quote;
                action(Approvals)
                {
                    AccessByPermission = TableData "Approval Entry"=R;
                    ApplicationArea = Suite;
                    Caption = 'Approvals';
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.';

                    trigger OnAction()
                    var
                        ApprovalEntries: Page "Approval Entries";
                    begin
                        ApprovalEntries.Setfilters(Database::"Sales Header","Document Type","No.");
                        ApprovalEntries.Run;
                    end;
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
                    PromotedOnly = true;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edits dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                    trigger OnAction()
                    begin
                        ShowDocDim;
                    end;
                }
            }
            group("&View")
            {
                Caption = '&View';
                action(Customer)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Customer';
                    Enabled = CustomerSelected;
                    Image = Customer;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    RunObject = Page "Customer Card";
                    RunPageLink = "No."=field("Sell-to Customer No.");
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'View or edit detailed information about the customer.';
                }
                action("C&ontact")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'C&ontact';
                    Image = Card;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    RunObject = Page "Contact Card";
                    RunPageLink = "No."=field("Sell-to Contact No.");
                    ToolTip = 'View or edit detailed information about the contact person at the customer.';
                }
            }
        }
        area(processing)
        {
            group(ActionGroup1102601026)
            {
                Caption = '&Quote';
                Image = Quote;
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
                        CalcInvDiscForHeader;
                        Commit;
                        if "Tax Area Code" = '' then
                          Page.RunModal(Page::"Sales Statistics",Rec)
                        else
                          Page.RunModal(Page::"Sales Stats.",Rec);
                    end;
                }
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Sales Comment Sheet";
                    RunPageLink = "Document Type"=field("Document Type"),
                                  "No."=field("No."),
                                  "Document Line No."=const(0);
                }
                action(Print)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = '&Print';
                    Ellipsis = true;
                    Image = Print;
                    ToolTip = 'Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.';
                    Visible = not IsOfficeAddin;

                    trigger OnAction()
                    begin
                        CheckSalesCheckAllLinesHaveQuantityAssigned;
                        DocPrint.PrintSalesHeader(Rec);
                    end;
                }
                action(Email)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Send by Email';
                    Image = Email;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Finalize and prepare to email the document. The Send Email window opens prefilled with the customer''s email address so you can add or edit information.';

                    trigger OnAction()
                    begin
                        CheckSalesCheckAllLinesHaveQuantityAssigned;
                        DocPrint.EmailSalesHeader(Rec);
                    end;
                }
            }
            group(Create)
            {
                Caption = 'Create';
                action(MakeOrder)
                {
                    ApplicationArea = Basic;
                    Caption = 'Make &Order';
                    Image = MakeOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Convert the sales quote to a sales order. The sales order will contain the sales quote number.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        if ApprovalsMgmt.PrePostApprovalCheckSales(Rec) then
                          Codeunit.Run(Codeunit::"Sales-Quote to Order (Yes/No)",Rec);
                    end;
                }
                action(MakeInvoice)
                {
                    ApplicationArea = Basic;
                    Caption = 'Make Invoice';
                    Image = MakeOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Scope = Repeater;
                    ToolTip = 'Convert the selected sales quote to a sales invoice.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        if ApprovalsMgmt.PrePostApprovalCheckSales(Rec) then begin
                          CheckSalesCheckAllLinesHaveQuantityAssigned;
                          Codeunit.Run(Codeunit::"Sales-Quote to Invoice Yes/No",Rec);
                        end;
                    end;
                }
                action("C&reate Customer")
                {
                    ApplicationArea = Basic;
                    Caption = 'C&reate Customer';
                    Image = NewCustomer;

                    trigger OnAction()
                    begin
                        if CheckCustomerCreated(false) then
                          CurrPage.Update(true);
                    end;
                }
                action("Create &To-do")
                {
                    AccessByPermission = TableData Contact=R;
                    ApplicationArea = Basic;
                    Caption = 'Create &To-do';
                    Image = NewToDo;

                    trigger OnAction()
                    begin
                        CreateTodo;
                    end;
                }
            }
            group(Release)
            {
                Caption = 'Release';
                Image = ReleaseDoc;
                action("Re&lease")
                {
                    ApplicationArea = Basic;
                    Caption = 'Re&lease';
                    Image = ReleaseDoc;
                    ShortCutKey = 'Ctrl+F9';

                    trigger OnAction()
                    var
                        ReleaseSalesDoc: Codeunit "Release Sales Document";
                    begin
                        ReleaseSalesDoc.PerformManualRelease(Rec);
                    end;
                }
                action("Re&open")
                {
                    ApplicationArea = Basic;
                    Caption = 'Re&open';
                    Image = ReOpen;

                    trigger OnAction()
                    var
                        ReleaseSalesDoc: Codeunit "Release Sales Document";
                    begin
                        ReleaseSalesDoc.PerformManualReopen(Rec);
                    end;
                }
            }
            group("Request Approval")
            {
                Caption = 'Request Approval';
                Image = Approval;
                action(SendApprovalRequest)
                {
                    ApplicationArea = Basic;
                    Caption = 'Send A&pproval Request';
                    Enabled = not OpenApprovalEntriesExist;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Send an approval request.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        if ApprovalsMgmt.CheckSalesApprovalPossible(Rec) then
                          ApprovalsMgmt.OnSendSalesDocForApproval(Rec);
                    end;
                }
                action(CancelApprovalRequest)
                {
                    ApplicationArea = Basic;
                    Caption = 'Cancel Approval Re&quest';
                    Enabled = CanCancelApprovalForRecord;
                    Image = CancelApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Cancel the approval request.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.OnCancelSalesApprovalRequest(Rec);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        SetControlAppearance;
        CurrPage.IncomingDocAttachFactBox.Page.LoadDataFromRecord(Rec);
    end;

    trigger OnOpenPage()
    var
        OfficeMgt: Codeunit "Office Management";
    begin
        SetSecurityFilterOnRespCenter;
        IsOfficeAddin := OfficeMgt.IsAvailable;

        CopySellToCustomerFilter;
    end;

    var
        DocPrint: Codeunit "Document-Print";
        OpenApprovalEntriesExist: Boolean;
        IsOfficeAddin: Boolean;
        CanCancelApprovalForRecord: Boolean;
        CustomerSelected: Boolean;

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RecordId);

        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(RecordId);
        CustomerSelected := "Sell-to Customer No." <> '';
    end;

    local procedure CheckSalesCheckAllLinesHaveQuantityAssigned()
    var
        ApplicationAreaSetup: Record "Application Area Setup";
        LinesInstructionMgt: Codeunit "Lines Instruction Mgt.";
    begin
        if ApplicationAreaSetup.IsFoundationEnabled then
          LinesInstructionMgt.SalesCheckAllLinesHaveQuantityAssigned(Rec);
    end;
}

