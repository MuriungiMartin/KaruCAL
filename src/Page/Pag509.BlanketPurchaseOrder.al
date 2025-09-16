#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 509 "Blanket Purchase Order"
{
    Caption = 'Blanket Purchase Order';
    PageType = Document;
    PromotedActionCategories = 'New,Process,Report,Approve,Request Approval';
    RefreshOnActivate = true;
    SourceTable = "Purchase Header";
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
                    Visible = DocNoVisible;

                    trigger OnAssistEdit()
                    begin
                        if AssistEdit(xRec) then
                          CurrPage.Update;
                    end;
                }
                field("Buy-from Vendor Name";"Buy-from Vendor Name")
                {
                    ApplicationArea = Basic;
                    Caption = 'Vendor';
                    Importance = Promoted;

                    trigger OnValidate()
                    begin
                        if GetFilter("Buy-from Vendor No.") = xRec."Buy-from Vendor No." then
                          if "Buy-from Vendor No." <> xRec."Buy-from Vendor No." then
                            SetRange("Buy-from Vendor No.");

                        CurrPage.Update;
                    end;
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
                    field("Buy-from City";"Buy-from City")
                    {
                        ApplicationArea = Basic;
                        Caption = 'City';
                        Importance = Additional;
                    }
                    field("Buy-from County";"Buy-from County")
                    {
                        ApplicationArea = Basic;
                        Caption = 'State';
                    }
                    field("Buy-from Post Code";"Buy-from Post Code")
                    {
                        ApplicationArea = Basic;
                        Caption = 'ZIP Code';
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
                field("Due Date";"Due Date")
                {
                    ApplicationArea = Basic;
                }
                field("Order Date";"Order Date")
                {
                    ApplicationArea = Basic;
                }
                field("Vendor Shipment No.";"Vendor Shipment No.")
                {
                    ApplicationArea = Basic;
                }
                field("Order Address Code";"Order Address Code")
                {
                    ApplicationArea = Basic;
                }
                field("Vendor Order No.";"Vendor Order No.")
                {
                    ApplicationArea = Basic;
                }
                field("Purchaser Code";"Purchaser Code")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        PurchaserCodeOnAfterValidate;
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
            part(PurchLines;"Blanket Purchase Order Subform")
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
                        PurchCalcDiscByType.ApplyDefaultInvoiceDiscount(0,Rec);
                    end;
                }
                field("Expected Receipt Date";"Expected Receipt Date")
                {
                    ApplicationArea = Basic;
                }
                field("Payment Terms Code";"Payment Terms Code")
                {
                    ApplicationArea = Basic;
                }
                field("Payment Method Code";"Payment Method Code")
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
                    ToolTip = 'Specifies the tax area code used for this purchase to calculate and post sales tax.';
                }
                field("Provincial Tax Area Code";"Provincial Tax Area Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the tax area code for self assessed Provincial Sales Tax for the company.';
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
                field("Payment Discount %";"Payment Discount %")
                {
                    ApplicationArea = Basic;
                }
                field("Pmt. Discount Date";"Pmt. Discount Date")
                {
                    ApplicationArea = Basic;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                }
                field("Shipment Method Code";"Shipment Method Code")
                {
                    ApplicationArea = Basic;
                }
                field("Ship-to UPS Zone";"Ship-to UPS Zone")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a UPS Zone code for this document if UPS is used for shipments.';
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
                    field("Ship-to City";"Ship-to City")
                    {
                        ApplicationArea = Basic;
                        Caption = 'City';
                        Importance = Additional;
                    }
                    field("Ship-to County";"Ship-to County")
                    {
                        ApplicationArea = Basic;
                        Caption = 'State';
                    }
                    field("Ship-to Post Code";"Ship-to Post Code")
                    {
                        ApplicationArea = Basic;
                        Caption = 'ZIP Code';
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
                    field("Pay-to City";"Pay-to City")
                    {
                        ApplicationArea = Basic;
                        Caption = 'City';
                        Importance = Additional;
                    }
                    field("Pay-to County";"Pay-to County")
                    {
                        ApplicationArea = Basic;
                        Caption = 'State';
                    }
                    field("Pay-to Post Code";"Pay-to Post Code")
                    {
                        ApplicationArea = Basic;
                        Caption = 'ZIP Code';
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
                field("On Hold";"On Hold")
                {
                    ApplicationArea = Basic;
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
        }
        area(factboxes)
        {
            part(Control5;"Pending Approval FactBox")
            {
                SubPageLink = "Table ID"=const(38),
                              "Document Type"=field("Document Type"),
                              "Document No."=field("No.");
                Visible = OpenApprovalEntriesExistForCurrUser;
            }
            part(Control1906354007;"Approval FactBox")
            {
                SubPageLink = "Table ID"=const(38),
                              "Document Type"=field("Document Type"),
                              "Document No."=field("No."),
                              Status=const(Open);
                Visible = false;
            }
            part(Control1901138007;"Vendor Details FactBox")
            {
                SubPageLink = "No."=field("Buy-from Vendor No.");
            }
            part(Control1904651607;"Vendor Statistics FactBox")
            {
                SubPageLink = "No."=field("Pay-to Vendor No.");
            }
            part(Control3;"Purchase Line FactBox")
            {
                Provider = PurchLines;
                SubPageLink = "Document Type"=field("Document Type"),
                              "No."=field("No."),
                              "Line No."=field("Line No.");
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
                    begin
                        OpenPurchaseOrderStatistics;
                        PurchCalcDiscByType.ResetRecalculateInvoiceDisc(Rec);
                    end;
                }
                action(Card)
                {
                    ApplicationArea = Basic;
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page "Vendor Card";
                    RunPageLink = "No."=field("Buy-from Vendor No.");
                    ShortCutKey = 'Shift+F7';
                }
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Purch. Comment Sheet";
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
                        ApprovalEntries.Setfilters(Database::"Purchase Header","Document Type","No.");
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
                    AccessByPermission = TableData "Vendor Invoice Disc."=R;
                    ApplicationArea = Basic;
                    Caption = 'Calculate &Invoice Discount';
                    Image = CalculateInvoiceDiscount;

                    trigger OnAction()
                    begin
                        ApproveCalcInvDisc;
                        PurchCalcDiscByType.ResetRecalculateInvoiceDisc(Rec);
                    end;
                }
                separator(Action133)
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
                        CopyPurchDoc.SetPurchHeader(Rec);
                        CopyPurchDoc.RunModal;
                        Clear(CopyPurchDoc);
                    end;
                }
                action(Release)
                {
                    ApplicationArea = Basic;
                    Caption = 'Re&lease';
                    Image = ReleaseDoc;
                    ShortCutKey = 'Ctrl+F9';

                    trigger OnAction()
                    var
                        ReleasePurchDoc: Codeunit "Release Purchase Document";
                    begin
                        ReleasePurchDoc.PerformManualRelease(Rec);
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
                        ReleasePurchDoc: Codeunit "Release Purchase Document";
                    begin
                        ReleasePurchDoc.PerformManualReopen(Rec);
                    end;
                }
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
                        if ApprovalsMgmt.CheckPurchaseApprovalPossible(Rec) then
                          ApprovalsMgmt.OnSendPurchaseDocForApproval(Rec);
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
                        ApprovalsMgmt.OnCancelPurchaseApprovalRequest(Rec);
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
                    if ApprovalsMgmt.PrePostApprovalCheckPurch(Rec) then
                      Codeunit.Run(Codeunit::"Blnkt Purch Ord. to Ord. (Y/N)",Rec);
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
                    DocPrint.PrintPurchHeader(Rec);
                end;
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
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        CurrPage.SaveRecord;
        exit(ConfirmDeletion);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Responsibility Center" := UserMgt.GetPurchasesFilter;

        if (not DocNoVisible) and ("No." = '') then
          SetBuyFromVendorFromFilter;
    end;

    trigger OnOpenPage()
    begin
        if UserMgt.GetPurchasesFilter <> '' then begin
          FilterGroup(2);
          SetRange("Responsibility Center",UserMgt.GetPurchasesFilter);
          FilterGroup(0);
        end;

        SetDocNoVisible;
    end;

    var
        CopyPurchDoc: Report "Copy Purchase Document";
        DocPrint: Codeunit "Document-Print";
        UserMgt: Codeunit "User Setup Management";
        PurchCalcDiscByType: Codeunit "Purch - Calc Disc. By Type";
        ChangeExchangeRate: Page "Change Exchange Rate";
        DocNoVisible: Boolean;
        OpenApprovalEntriesExist: Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        ShowWorkflowStatus: Boolean;
        CanCancelApprovalForRecord: Boolean;

    local procedure ApproveCalcInvDisc()
    begin
        CurrPage.PurchLines.Page.ApproveCalcInvDisc;
    end;

    local procedure PurchaserCodeOnAfterValidate()
    begin
        CurrPage.PurchLines.Page.UpdateForm(true);
    end;

    local procedure ShortcutDimension1CodeOnAfterV()
    begin
        CurrPage.PurchLines.Page.UpdateForm(true);
    end;

    local procedure ShortcutDimension2CodeOnAfterV()
    begin
        CurrPage.PurchLines.Page.UpdateForm(true);
    end;

    local procedure SetDocNoVisible()
    var
        DocumentNoVisibility: Codeunit DocumentNoVisibility;
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",Reminder,FinChMemo;
    begin
        DocNoVisible := DocumentNoVisibility.PurchaseDocumentNoIsVisible(Doctype::"Blanket Order","No.");
    end;

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RecordId);

        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(RecordId);
    end;
}

