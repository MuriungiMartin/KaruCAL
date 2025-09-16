#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 507 "Blanket Sales Order"
{
    Caption = 'Blanket Sales Order';
    PageType = Document;
    PromotedActionCategories = 'New,Process,Report,Approve,Request Approval';
    RefreshOnActivate = true;
    SourceTable = "Sales Header";
    SourceTableView = where("Document Type"=filter("Blanket Order"));

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
                    Importance = Additional;
                    Visible = DocNoVisible;

                    trigger OnAssistEdit()
                    begin
                        if AssistEdit(xRec) then
                          CurrPage.Update;
                    end;
                }
                field("Sell-to Customer Name";"Sell-to Customer Name")
                {
                    ApplicationArea = Basic;
                    Caption = 'Customer';
                    Importance = Promoted;

                    trigger OnValidate()
                    begin
                        if GetFilter("Sell-to Customer No.") = xRec."Sell-to Customer No." then
                          if "Sell-to Customer No." <> xRec."Sell-to Customer No." then
                            SetRange("Sell-to Customer No.");

                        CurrPage.Update;
                    end;
                }
                group("Sell-to")
                {
                    Caption = 'Sell-to';
                    field("Sell-to Address";"Sell-to Address")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Address';
                        Importance = Additional;
                    }
                    field("Sell-to Address 2";"Sell-to Address 2")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Address 2';
                        Importance = Additional;
                    }
                    field("Sell-to City";"Sell-to City")
                    {
                        ApplicationArea = Basic;
                        Caption = 'City';
                        Importance = Additional;
                    }
                    field("Sell-to County";"Sell-to County")
                    {
                        ApplicationArea = Basic;
                        Caption = 'State';
                    }
                    field("Sell-to Post Code";"Sell-to Post Code")
                    {
                        ApplicationArea = Basic;
                        Caption = 'ZIP Code';
                        Importance = Additional;
                    }
                    field("Sell-to Contact No.";"Sell-to Contact No.")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Contact No.';
                        Importance = Additional;

                        trigger OnValidate()
                        begin
                            if GetFilter("Sell-to Contact No.") = xRec."Sell-to Contact No." then
                              if "Sell-to Contact No." <> xRec."Sell-to Contact No." then
                                SetRange("Sell-to Contact No.");
                        end;
                    }
                }
                field("Sell-to Contact";"Sell-to Contact")
                {
                    ApplicationArea = Basic;
                    Caption = 'Contact';
                }
                field("Document Date";"Document Date")
                {
                    ApplicationArea = Basic;
                }
                field("Due Date";"Due Date")
                {
                    ApplicationArea = Basic;
                }
                field("Order Date";"Order Date")
                {
                    ApplicationArea = Basic;
                }
                field("External Document No.";"External Document No.")
                {
                    ApplicationArea = Basic;
                }
                field("Salesperson Code";"Salesperson Code")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        SalespersonCodeOnAfterValidate;
                    end;
                }
                field("Campaign No.";"Campaign No.")
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
            part(SalesLines;"Blanket Sales Order Subform")
            {
                SubPageLink = "Document No."=field("No.");
                UpdatePropagation = Both;
            }
            group("Invoice Details")
            {
                Caption = 'Invoice Details';
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Basic;

                    trigger OnAssistEdit()
                    begin
                        Clear(ChangeExchangeRate);
                        ChangeExchangeRate.SetParameter("Currency Code","Currency Factor",WorkDate);
                        if ChangeExchangeRate.RunModal = Action::OK then begin
                          Validate("Currency Factor",ChangeExchangeRate.GetParameter);
                          CurrPage.Update;
                        end;
                        Clear(ChangeExchangeRate);
                    end;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                        SalesCalcDiscByType.ApplyDefaultInvoiceDiscount(0,Rec);
                    end;
                }
                field("Shipment Date";"Shipment Date")
                {
                    ApplicationArea = Basic;
                }
                field("Payment Terms Code";"Payment Terms Code")
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

                    trigger OnValidate()
                    begin
                        ShortcutDimension1CodeOnAfterV;
                    end;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        ShortcutDimension2CodeOnAfterV;
                    end;
                }
                field("Pmt. Discount Date";"Pmt. Discount Date")
                {
                    ApplicationArea = Basic;
                }
                field("Tax Liable";"Tax Liable")
                {
                    ApplicationArea = Basic;
                }
                field("Tax Area Code";"Tax Area Code")
                {
                    ApplicationArea = Basic;
                }
                field("Payment Discount %";"Payment Discount %")
                {
                    ApplicationArea = Basic;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                }
            }
            group("Shipping and Billing")
            {
                Caption = 'Shipping and Billing';
                Enabled = "Sell-to Customer No." <> '';
                group(Control25)
                {
                    group(Control21)
                    {
                        field(ShippingOptions;ShipToOptions)
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = 'Ship-to';
                            ToolTip = 'Specifies the address that the products on the sales document are shipped to. Default (Sell-to Address): The same as the customer''s sell-to address. Alternate Ship-to Address: One of the customer''s alternate ship-to addresses. Custom Address: Any ship-to address that you specify in the fields below.';

                            trigger OnValidate()
                            var
                                ShipToAddress: Record "Ship-to Address";
                                ShipToAddressList: Page "Ship-to Address List";
                            begin
                                case ShipToOptions of
                                  Shiptooptions::"Default (Sell-to Address)":
                                    begin
                                      Validate("Ship-to Code",'');
                                      CopySellToAddressToShipToAddress;
                                    end;
                                  Shiptooptions::"Alternate Shipping Address":
                                    begin
                                      ShipToAddress.SetRange("Customer No.","Sell-to Customer No.");
                                      ShipToAddressList.LookupMode := true;
                                      ShipToAddressList.SetTableview(ShipToAddress);

                                      if ShipToAddressList.RunModal = Action::LookupOK then begin
                                        ShipToAddressList.GetRecord(ShipToAddress);
                                        Validate("Ship-to Code",ShipToAddress.Code);
                                      end else
                                        ShipToOptions := Shiptooptions::"Custom Address";
                                    end;
                                  Shiptooptions::"Custom Address":
                                    Validate("Ship-to Code",'');
                                end;
                            end;
                        }
                        group(Control4)
                        {
                            Visible = not (ShipToOptions = ShipToOptions::"Default (Sell-to Address)");
                            field("Ship-to Code";"Ship-to Code")
                            {
                                ApplicationArea = Basic;
                                Caption = 'Code';
                                Editable = ShipToOptions = ShipToOptions::"Alternate Shipping Address";
                                Importance = Promoted;

                                trigger OnValidate()
                                begin
                                    if (xRec."Ship-to Code" <> '') and ("Ship-to Code" = '') then
                                      Error(EmptyShipToCodeErr);
                                end;
                            }
                            field("Ship-to Name";"Ship-to Name")
                            {
                                ApplicationArea = Basic;
                                Caption = 'Name';
                                Editable = ShipToOptions = ShipToOptions::"Custom Address";
                            }
                            field("Ship-to Address";"Ship-to Address")
                            {
                                ApplicationArea = Basic;
                                Caption = 'Address';
                                Editable = ShipToOptions = ShipToOptions::"Custom Address";
                            }
                            field("Ship-to Address 2";"Ship-to Address 2")
                            {
                                ApplicationArea = Basic;
                                Caption = 'Address 2';
                                Editable = ShipToOptions = ShipToOptions::"Custom Address";
                            }
                            field("Ship-to City";"Ship-to City")
                            {
                                ApplicationArea = Basic;
                                Caption = 'City';
                                Editable = ShipToOptions = ShipToOptions::"Custom Address";
                            }
                            field("Ship-to County";"Ship-to County")
                            {
                                ApplicationArea = Basic;
                                Caption = 'State';
                                Editable = ShipToOptions = ShipToOptions::"Custom Address";
                            }
                            field("Ship-to Post Code";"Ship-to Post Code")
                            {
                                ApplicationArea = Basic;
                                Caption = 'ZIP Code';
                                Editable = ShipToOptions = ShipToOptions::"Custom Address";
                            }
                            field("Ship-to Country/Region Code";"Ship-to Country/Region Code")
                            {
                                ApplicationArea = Basic;
                                Caption = 'Country/Region';
                                Editable = ShipToOptions = ShipToOptions::"Custom Address";
                                Importance = Additional;
                            }
                            field("Ship-to Contact";"Ship-to Contact")
                            {
                                ApplicationArea = Basic;
                                Caption = 'Contact';
                                Editable = ShipToOptions = ShipToOptions::"Custom Address";
                            }
                        }
                    }
                    group("Shipment Method")
                    {
                        Caption = 'Shipment Method';
                        field("Shipment Method Code";"Shipment Method Code")
                        {
                            ApplicationArea = Basic;
                            Caption = 'Code';
                            Importance = Additional;
                            ToolTip = 'Specifies how items on the sales document are shipped to the customer.';
                        }
                        field("Ship-to UPS Zone";"Ship-to UPS Zone")
                        {
                            ApplicationArea = Basic;
                            ToolTip = 'Specifies a UPS Zone code for this document if UPS is used for shipments.';
                        }
                        field("Shipping Agent Code";"Shipping Agent Code")
                        {
                            ApplicationArea = Basic;
                            Caption = 'Agent';
                            Importance = Additional;
                            ToolTip = 'Specifies which shipping agent is used to transport the items on the sales document to the customer.';
                        }
                        field("Shipping Agent Service Code";"Shipping Agent Service Code")
                        {
                            ApplicationArea = Basic;
                            Caption = 'Agent service';
                            Importance = Additional;
                            ToolTip = 'Specifies which shipping agent service is used to transport the items on the sales document to the customer.';
                        }
                        field("Package Tracking No.";"Package Tracking No.")
                        {
                            ApplicationArea = Basic;
                            Importance = Additional;
                            ToolTip = 'Specifies the shipping agent''s package number.';
                        }
                    }
                }
                group(Control41)
                {
                    field(BilltoOptions;BillToOptions)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Bill-to';
                        ToolTip = 'Specifies the customer that the sales invoice will be sent to. Default (Customer): The same as the customer on the sales invoice. Another Customer: Any customer that you specify in the fields below.';

                        trigger OnValidate()
                        begin
                            if BillToOptions = Billtooptions::"Default (Customer)" then
                              Validate("Bill-to Customer No.","Sell-to Customer No.");
                        end;
                    }
                    group(Control43)
                    {
                        Visible = BillToOptions = BillToOptions::"Another Customer";
                        field("Bill-to Name";"Bill-to Name")
                        {
                            ApplicationArea = Basic;
                            Caption = 'Name';
                            Importance = Promoted;

                            trigger OnValidate()
                            var
                                ApplicationAreaSetup: Record "Application Area Setup";
                            begin
                                if GetFilter("Bill-to Customer No.") = xRec."Bill-to Customer No." then
                                  if "Bill-to Customer No." <> xRec."Bill-to Customer No." then
                                    SetRange("Bill-to Customer No.");

                                if ApplicationAreaSetup.IsFoundationEnabled then
                                  SalesCalcDiscByType.ApplyDefaultInvoiceDiscount(0,Rec);
                            end;
                        }
                        field("Bill-to Address";"Bill-to Address")
                        {
                            ApplicationArea = Basic;
                            Caption = 'Address';
                            Importance = Additional;
                        }
                        field("Bill-to Address 2";"Bill-to Address 2")
                        {
                            ApplicationArea = Basic;
                            Caption = 'Address 2';
                            Importance = Additional;
                        }
                        field("Bill-to City";"Bill-to City")
                        {
                            ApplicationArea = Basic;
                            Caption = 'City';
                            Importance = Additional;
                        }
                        field("Bill-to County";"Bill-to County")
                        {
                            ApplicationArea = Basic;
                            Caption = 'State';
                        }
                        field("Bill-to Post Code";"Bill-to Post Code")
                        {
                            ApplicationArea = Basic;
                            Caption = 'ZIP Code';
                            Importance = Additional;
                        }
                        field("Bill-to Contact No.";"Bill-to Contact No.")
                        {
                            ApplicationArea = Basic;
                            Caption = 'Contact No.';
                            Importance = Additional;
                        }
                        field("Bill-to Contact";"Bill-to Contact")
                        {
                            ApplicationArea = Basic;
                            Caption = 'Contact';
                        }
                    }
                }
            }
            group("Foreign Trade")
            {
                Caption = 'Foreign Trade';
                field("EU 3-Party Trade";"EU 3-Party Trade")
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Specification";"Transaction Specification")
                {
                    ApplicationArea = Basic;
                }
                field("Transport Method";"Transport Method")
                {
                    ApplicationArea = Basic;
                }
                field("Exit Point";"Exit Point")
                {
                    ApplicationArea = Basic;
                }
                field("Area";Area)
                {
                    ApplicationArea = Basic;
                }
            }
        }
        area(factboxes)
        {
            part(Control13;"Pending Approval FactBox")
            {
                SubPageLink = "Table ID"=const(36),
                              "Document Type"=field("Document Type"),
                              "Document No."=field("No.");
                Visible = OpenApprovalEntriesExistForCurrUser;
            }
            part(Control1902018507;"Customer Statistics FactBox")
            {
                SubPageLink = "No."=field("Bill-to Customer No.");
            }
            part(Control1900316107;"Customer Details FactBox")
            {
                SubPageLink = "No."=field("Sell-to Customer No.");
            }
            part(Control1906127307;"Sales Line FactBox")
            {
                Provider = SalesLines;
                SubPageLink = "Document Type"=field("Document Type"),
                              "Document No."=field("Document No."),
                              "Line No."=field("Line No.");
                Visible = false;
            }
            part(Control1906354007;"Approval FactBox")
            {
                SubPageLink = "Table ID"=const(36),
                              "Document Type"=field("Document Type"),
                              "Document No."=field("No."),
                              Status=const(Open);
                Visible = false;
            }
            part(Control1907012907;"Resource Details FactBox")
            {
                Provider = SalesLines;
                SubPageLink = "No."=field("No.");
                Visible = false;
            }
            part(WorkflowStatus;"Workflow Status FactBox")
            {
                Editable = false;
                Enabled = false;
                ShowFilter = false;
                Visible = ShowWorkflowStatus;
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
            group("O&rder")
            {
                Caption = 'O&rder';
                Image = "Order";
                action(Statistics)
                {
                    ApplicationArea = Basic;
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'F7';

                    trigger OnAction()
                    var
                        Handled: Boolean;
                    begin
                        OnBeforeStatisticsAction(Rec,Handled);
                        if not Handled then begin
                          OpenSalesOrderStatistics;
                          SalesCalcDiscByType.ResetRecalculateInvoiceDisc(Rec);
                        end
                    end;
                }
                action(Card)
                {
                    ApplicationArea = Basic;
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page "Customer Card";
                    RunPageLink = "No."=field("Sell-to Customer No.");
                    ShortCutKey = 'Shift+F7';
                }
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Sales Comment Sheet";
                    RunPageLink = "Document Type"=const("Blanket Order"),
                                  "No."=field("No."),
                                  "Document Line No."=const(0);
                }
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension=R;
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';
                    Enabled = "No." <> '';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                    trigger OnAction()
                    begin
                        ShowDocDim;
                    end;
                }
                action(Approvals)
                {
                    AccessByPermission = TableData "Approval Entry"=R;
                    ApplicationArea = Basic;
                    Caption = 'Approvals';
                    Image = Approvals;
                    ToolTip = 'View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.';

                    trigger OnAction()
                    var
                        ApprovalEntries: Page "Approval Entries";
                    begin
                        ApprovalEntries.Setfilters(Database::"Sales Header","Document Type","No.");
                        ApprovalEntries.Run;
                    end;
                }
            }
        }
        area(processing)
        {
            group(Approval)
            {
                Caption = 'Approval';
                action(Approve)
                {
                    ApplicationArea = Basic;
                    Caption = 'Approve';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.ApproveRecordApprovalRequest(RecordId);
                    end;
                }
                action(Reject)
                {
                    ApplicationArea = Basic;
                    Caption = 'Reject';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.RejectRecordApprovalRequest(RecordId);
                    end;
                }
                action(Delegate)
                {
                    ApplicationArea = Basic;
                    Caption = 'Delegate';
                    Image = Delegate;
                    Promoted = true;
                    PromotedCategory = Category4;
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.DelegateRecordApprovalRequest(RecordId);
                    end;
                }
                action(Comment)
                {
                    ApplicationArea = Basic;
                    Caption = 'Comments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Category4;
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.GetApprovalComment(Rec);
                    end;
                }
            }
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action(CalculateInvoiceDiscount)
                {
                    AccessByPermission = TableData "Cust. Invoice Disc."=R;
                    ApplicationArea = Basic;
                    Caption = 'Calculate &Invoice Discount';
                    Image = CalculateInvoiceDiscount;

                    trigger OnAction()
                    begin
                        ApproveCalcInvDisc;
                        SalesCalcDiscByType.ResetRecalculateInvoiceDisc(Rec);
                    end;
                }
                separator(Action134)
                {
                }
                action(CopyDocument)
                {
                    ApplicationArea = Basic;
                    Caption = 'Copy Document';
                    Ellipsis = true;
                    Image = CopyDocument;

                    trigger OnAction()
                    begin
                        CopySalesDoc.SetSalesHeader(Rec);
                        CopySalesDoc.RunModal;
                        Clear(CopySalesDoc);
                    end;
                }
                separator(Action138)
                {
                }
                action(Release)
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
                action(Reopen)
                {
                    ApplicationArea = Basic;
                    Caption = 'Re&open';
                    Enabled = Status <> Status::Open;
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Reopen the document to change it after it has been approved. Approved documents have the Released status and must be opened before they can be changed';

                    trigger OnAction()
                    var
                        ReleaseSalesDoc: Codeunit "Release Sales Document";
                    begin
                        ReleaseSalesDoc.PerformManualReopen(Rec);
                    end;
                }
            }
            action(MakeOrder)
            {
                ApplicationArea = Basic;
                Caption = 'Make &Order';
                Image = MakeOrder;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    if ApprovalsMgmt.PrePostApprovalCheckSales(Rec) then
                      Codeunit.Run(Codeunit::"Blnkt Sales Ord. to Ord. (Y/N)",Rec);
                end;
            }
            action(Print)
            {
                ApplicationArea = Basic;
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    DocPrint.PrintSalesHeader(Rec);
                end;
            }
            group("Request Approval")
            {
                Caption = 'Request Approval';
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
        ShowWorkflowStatus := CurrPage.WorkflowStatus.Page.SetFilterOnWorkflowRecord(RecordId);
    end;

    trigger OnAfterGetRecord()
    begin
        SetControlAppearance;
        UpdateShipToBillToGroupVisibility
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        CurrPage.SaveRecord;
        exit(ConfirmDeletion);
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        if DocNoVisible then
          CheckCreditMaxBeforeInsert;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Responsibility Center" := UserMgt.GetSalesFilter;
        if (not DocNoVisible) and ("No." = '') then
          SetSellToCustomerFromFilter;
    end;

    trigger OnOpenPage()
    begin
        if UserMgt.GetSalesFilter <> '' then begin
          FilterGroup(2);
          SetRange("Responsibility Center",UserMgt.GetSalesFilter);
          FilterGroup(0);
        end;

        SetDocNoVisible;
    end;

    var
        CopySalesDoc: Report "Copy Sales Document";
        DocPrint: Codeunit "Document-Print";
        UserMgt: Codeunit "User Setup Management";
        SalesCalcDiscByType: Codeunit "Sales - Calc Discount By Type";
        ChangeExchangeRate: Page "Change Exchange Rate";
        DocNoVisible: Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        ShowWorkflowStatus: Boolean;
        CanCancelApprovalForRecord: Boolean;
        ShipToOptions: Option "Default (Sell-to Address)","Alternate Shipping Address","Custom Address";
        BillToOptions: Option "Default (Customer)","Another Customer";
        EmptyShipToCodeErr: label 'The Code field can only be empty if you select Custom Address in the Ship-to field.';

    local procedure ApproveCalcInvDisc()
    begin
        CurrPage.SalesLines.Page.ApproveCalcInvDisc;
    end;

    local procedure SalespersonCodeOnAfterValidate()
    begin
        CurrPage.SalesLines.Page.UpdateForm(true);
    end;

    local procedure ShortcutDimension1CodeOnAfterV()
    begin
        CurrPage.SalesLines.Page.UpdateForm(true);
    end;

    local procedure ShortcutDimension2CodeOnAfterV()
    begin
        CurrPage.SalesLines.Page.UpdateForm(true);
    end;

    local procedure SetDocNoVisible()
    var
        DocumentNoVisibility: Codeunit DocumentNoVisibility;
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",Reminder,FinChMemo;
    begin
        DocNoVisible := DocumentNoVisibility.SalesDocumentNoIsVisible(Doctype::"Blanket Order","No.");
    end;

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RecordId);
        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(RecordId);
    end;

    local procedure UpdateShipToBillToGroupVisibility()
    begin
        case true of
          ("Ship-to Code" = '') and ShipToAddressEqualsSellToAddress:
            ShipToOptions := Shiptooptions::"Default (Sell-to Address)";
          ("Ship-to Code" = '') and (not ShipToAddressEqualsSellToAddress):
            ShipToOptions := Shiptooptions::"Custom Address";
          "Ship-to Code" <> '':
            ShipToOptions := Shiptooptions::"Alternate Shipping Address";
        end;

        if "Bill-to Customer No." = "Sell-to Customer No." then
          BillToOptions := Billtooptions::"Default (Customer)"
        else
          BillToOptions := Billtooptions::"Another Customer";
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeStatisticsAction(var SalesHeader: Record "Sales Header";var Handled: Boolean)
    begin
    end;
}

