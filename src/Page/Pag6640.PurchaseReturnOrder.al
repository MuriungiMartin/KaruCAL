#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 6640 "Purchase Return Order"
{
    Caption = 'Purchase Return Order';
    PageType = Document;
    PromotedActionCategories = 'New,Process,Report,Approve,Release,Posting,Prepare,Invoice,Request Approval';
    RefreshOnActivate = true;
    SourceTable = "Purchase Header";
    SourceTableView = where("Document Type"=filter("Return Order"));

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
                    QuickEntry = false;

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
                        QuickEntry = false;
                    }
                    field("Buy-from Address 2";"Buy-from Address 2")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Address 2';
                        Importance = Additional;
                        QuickEntry = false;
                    }
                    field("Buy-from City";"Buy-from City")
                    {
                        ApplicationArea = Basic;
                        Caption = 'City';
                        Importance = Additional;
                        QuickEntry = false;
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
                        QuickEntry = false;
                    }
                    field("Buy-from Contact No.";"Buy-from Contact No.")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Contact No.';
                        Importance = Additional;
                        QuickEntry = false;
                    }
                }
                field("Buy-from Contact";"Buy-from Contact")
                {
                    ApplicationArea = Basic;
                    Caption = 'Contact';
                    QuickEntry = false;
                }
                field("Document Date";"Document Date")
                {
                    ApplicationArea = Basic;
                    QuickEntry = false;
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic;
                    QuickEntry = false;
                }
                field("No. of Archived Versions";"No. of Archived Versions")
                {
                    ApplicationArea = Basic;
                    QuickEntry = false;
                }
                field("Order Date";"Order Date")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    QuickEntry = false;
                }
                field("Vendor Authorization No.";"Vendor Authorization No.")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field("Vendor Cr. Memo No.";"Vendor Cr. Memo No.")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field("Order Address Code";"Order Address Code")
                {
                    ApplicationArea = Basic;
                    QuickEntry = false;
                }
                field("Purchaser Code";"Purchaser Code")
                {
                    ApplicationArea = Basic;
                    QuickEntry = false;

                    trigger OnValidate()
                    begin
                        PurchaserCodeOnAfterValidate;
                    end;
                }
                field("Campaign No.";"Campaign No.")
                {
                    ApplicationArea = Basic;
                    QuickEntry = false;
                }
                field("Responsibility Center";"Responsibility Center")
                {
                    ApplicationArea = Basic;
                    QuickEntry = false;
                }
                field("Assigned User ID";"Assigned User ID")
                {
                    ApplicationArea = Basic;
                    QuickEntry = false;
                }
                field("Job Queue Status";"Job Queue Status")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    QuickEntry = false;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    QuickEntry = false;
                }
                field("Posting No. Series";"Posting No. Series")
                {
                    ApplicationArea = Basic;
                }
                field("Posting No.";"Posting No.")
                {
                    ApplicationArea = Basic;
                }
            }
            part(PurchLines;"Purchase Return Order Subform")
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
                    Importance = Promoted;

                    trigger OnAssistEdit()
                    begin
                        if "Posting Date" <> 0D then
                          ChangeExchangeRate.SetParameter("Currency Code","Currency Factor","Posting Date")
                        else
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
                    Importance = Promoted;
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
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field("Applies-to Doc. Type";"Applies-to Doc. Type")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field("Applies-to Doc. No.";"Applies-to Doc. No.")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field("Applies-to ID";"Applies-to ID")
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
                    ToolTip = 'Specifies the tax area code for self assessed Provincial Sales Tax for this purchase.';
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
            part(Control21;"Pending Approval FactBox")
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
                Visible = false;
            }
            part(Control1903435607;"Vendor Hist. Buy-from FactBox")
            {
                SubPageLink = "No."=field("Buy-from Vendor No.");
            }
            part(Control1906949207;"Vendor Hist. Pay-to FactBox")
            {
                SubPageLink = "No."=field("Pay-to Vendor No.");
                Visible = false;
            }
            part(Control3;"Purchase Line FactBox")
            {
                Provider = PurchLines;
                SubPageLink = "Document Type"=field("Document Type"),
                              "Document No."=field("Document No."),
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
            group("&Return Order")
            {
                Caption = '&Return Order';
                Image = Return;
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
                action(Vendor)
                {
                    ApplicationArea = Basic;
                    Caption = 'Vendor';
                    Image = Vendor;
                    RunObject = Page "Vendor Card";
                    RunPageLink = "No."=field("Buy-from Vendor No.");
                    ShortCutKey = 'Shift+F7';
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
                        CurrPage.SaveRecord;
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
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Purch. Comment Sheet";
                    RunPageLink = "Document Type"=field("Document Type"),
                                  "No."=field("No."),
                                  "Document Line No."=const(0);
                }
            }
            group(Documents)
            {
                Caption = 'Documents';
                Image = Documents;
                action("Return Shipments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Return Shipments';
                    Image = Shipment;
                    RunObject = Page "Posted Return Shipments";
                    RunPageLink = "Return Order No."=field("No.");
                    RunPageView = sorting("Return Order No.");
                }
                action("Cred&it Memos")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cred&it Memos';
                    Image = CreditMemo;
                    RunObject = Page "Posted Purchase Credit Memos";
                    RunPageLink = "Return Order No."=field("No.");
                    RunPageView = sorting("Return Order No.");
                }
                separator(Action136)
                {
                }
            }
            group(Warehouse)
            {
                Caption = 'Warehouse';
                Image = Warehouse;
                action("Whse. Shipment Lines")
                {
                    ApplicationArea = Basic;
                    Caption = 'Whse. Shipment Lines';
                    Image = ShipmentLines;
                    RunObject = Page "Whse. Shipment Lines";
                    RunPageLink = "Source Type"=const(39),
                                  "Source Subtype"=field("Document Type"),
                                  "Source No."=field("No.");
                    RunPageView = sorting("Source Type","Source Subtype","Source No.","Source Line No.");
                }
                action("In&vt. Put-away/Pick Lines")
                {
                    ApplicationArea = Basic;
                    Caption = 'In&vt. Put-away/Pick Lines';
                    Image = PickLines;
                    RunObject = Page "Warehouse Activity List";
                    RunPageLink = "Source Document"=const("Purchase Return Order"),
                                  "Source No."=field("No.");
                    RunPageView = sorting("Source Document","Source No.","Location Code");
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
                    DocPrint.PrintPurchHeader(Rec);
                end;
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
                    Promoted = true;
                    PromotedCategory = Process;
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
                    PromotedCategory = Category5;
                    ToolTip = 'Reopen the document to change it after it has been approved. Approved documents have the Released status and must be opened before they can be changed';

                    trigger OnAction()
                    var
                        ReleasePurchDoc: Codeunit "Release Purchase Document";
                    begin
                        ReleasePurchDoc.PerformManualReopen(Rec);
                    end;
                }
                separator(Action690)
                {
                }
            }
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action(GetPostedDocumentLinesToReverse)
                {
                    ApplicationArea = Basic;
                    Caption = 'Get Posted Doc&ument Lines to Reverse';
                    Ellipsis = true;
                    Image = ReverseLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        GetPstdDocLinesToRevere;
                    end;
                }
                action("Apply Entries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Apply Entries';
                    Image = ApplyEntries;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'Shift+F11';

                    trigger OnAction()
                    begin
                        Codeunit.Run(Codeunit::"Purchase Header Apply",Rec);
                    end;
                }
                separator(Action130)
                {
                }
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
                separator(Action132)
                {
                }
                action(CopyDocument)
                {
                    ApplicationArea = Basic;
                    Caption = 'Copy Document';
                    Ellipsis = true;
                    Image = CopyDocument;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        CopyPurchDoc.SetPurchHeader(Rec);
                        CopyPurchDoc.RunModal;
                        Clear(CopyPurchDoc);
                        if Get("Document Type","No.") then;
                    end;
                }
                action("Move Negative Lines")
                {
                    ApplicationArea = Basic;
                    Caption = 'Move Negative Lines';
                    Ellipsis = true;
                    Image = MoveNegativeLines;

                    trigger OnAction()
                    begin
                        Clear(MoveNegPurchLines);
                        MoveNegPurchLines.SetPurchHeader(Rec);
                        MoveNegPurchLines.RunModal;
                        MoveNegPurchLines.ShowDocument;
                    end;
                }
                action("Archive Document")
                {
                    ApplicationArea = Basic;
                    Caption = 'Archive Document';
                    Image = Archive;

                    trigger OnAction()
                    begin
                        ArchiveManagement.ArchivePurchDocument(Rec);
                        CurrPage.Update(false);
                    end;
                }
                action("Send IC Return Order")
                {
                    AccessByPermission = TableData "IC G/L Account"=R;
                    ApplicationArea = Basic;
                    Caption = 'Send IC Return Order';
                    Image = IntercompanyOrder;

                    trigger OnAction()
                    var
                        ICInOutMgt: Codeunit ICInboxOutboxMgt;
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        if ApprovalsMgmt.PrePostApprovalCheckPurch(Rec) then
                          ICInOutMgt.SendPurchDoc(Rec,false);
                    end;
                }
                separator(Action134)
                {
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
                    PromotedCategory = Category9;
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
                    PromotedCategory = Category9;
                    PromotedIsBig = true;
                    PromotedOnly = true;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.OnCancelPurchaseApprovalRequest(Rec);
                    end;
                }
                separator(Action137)
                {
                }
            }
            group(ActionGroup19)
            {
                Caption = 'Warehouse';
                Image = Warehouse;
                action("Create &Whse. Shipment")
                {
                    AccessByPermission = TableData "Warehouse Shipment Header"=R;
                    ApplicationArea = Basic;
                    Caption = 'Create &Whse. Shipment';
                    Image = NewShipment;

                    trigger OnAction()
                    var
                        GetSourceDocOutbound: Codeunit "Get Source Doc. Outbound";
                    begin
                        GetSourceDocOutbound.CreateFromPurchaseReturnOrder(Rec);
                    end;
                }
                action("Create Inventor&y Put-away/Pick")
                {
                    AccessByPermission = TableData "Posted Invt. Pick Header"=R;
                    ApplicationArea = Basic;
                    Caption = 'Create Inventor&y Put-away/Pick';
                    Ellipsis = true;
                    Image = CreateInventoryPickup;

                    trigger OnAction()
                    begin
                        CreateInvtPutAwayPick;
                    end;
                }
                separator(Action135)
                {
                }
            }
            group("P&osting")
            {
                Caption = 'P&osting';
                Image = Post;
                action(Post)
                {
                    ApplicationArea = Basic;
                    Caption = 'P&ost';
                    Ellipsis = true;
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    begin
                        Post(Codeunit::"Purch.-Post (Yes/No)");
                    end;
                }
                action(Preview)
                {
                    ApplicationArea = Basic;
                    Caption = 'Preview Posting';
                    Image = ViewPostedOrder;
                    ToolTip = 'Review the different types of entries that will be created when you post the document or journal.';

                    trigger OnAction()
                    var
                        PurchPostYesNo: Codeunit "Purch.-Post (Yes/No)";
                    begin
                        PurchPostYesNo.Preview(Rec);
                    end;
                }
                action(TestReport)
                {
                    ApplicationArea = Basic;
                    Caption = 'Test Report';
                    Ellipsis = true;
                    Image = TestReport;
                    ToolTip = 'View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.';

                    trigger OnAction()
                    begin
                        ReportPrint.PrintPurchHeader(Rec);
                    end;
                }
                action(PostAndPrint)
                {
                    ApplicationArea = Basic;
                    Caption = 'Post and &Print';
                    Ellipsis = true;
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F9';

                    trigger OnAction()
                    begin
                        Post(Codeunit::"Purch.-Post + Print");
                    end;
                }
                action(PostBatch)
                {
                    ApplicationArea = Basic;
                    Caption = 'Post &Batch';
                    Ellipsis = true;
                    Image = PostBatch;

                    trigger OnAction()
                    begin
                        Report.RunModal(Report::"Batch Post Purch. Ret. Orders",true,true,Rec);
                        CurrPage.Update(false);
                    end;
                }
                action(RemoveFromJobQueue)
                {
                    ApplicationArea = Basic;
                    Caption = 'Remove From Job Queue';
                    Image = RemoveLine;
                    Visible = JobQueueVisible;

                    trigger OnAction()
                    begin
                        CancelBackgroundPosting;
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

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        if not DocumentIsPosted then
          exit(ConfirmCloseUnposted);
    end;

    var
        CopyPurchDoc: Report "Copy Purchase Document";
        MoveNegPurchLines: Report "Move Negative Purchase Lines";
        DocPrint: Codeunit "Document-Print";
        ReportPrint: Codeunit "Test Report-Print";
        UserMgt: Codeunit "User Setup Management";
        ArchiveManagement: Codeunit ArchiveManagement;
        PurchCalcDiscByType: Codeunit "Purch - Calc Disc. By Type";
        ChangeExchangeRate: Page "Change Exchange Rate";
        [InDataSet]
        JobQueueVisible: Boolean;
        DocNoVisible: Boolean;
        OpenApprovalEntriesExist: Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        ShowWorkflowStatus: Boolean;
        CanCancelApprovalForRecord: Boolean;
        DocumentIsPosted: Boolean;
        OpenPostedPurchaseReturnOrderQst: label 'The return order has been posted and moved to the Posted Purchase Credit Memos window.\\Do you want to open the posted credit memo?';

    local procedure Post(PostingCodeunitID: Integer)
    var
        PurchaseHeader: Record "Purchase Header";
        InstructionMgt: Codeunit "Instruction Mgt.";
    begin
        SendToPosting(PostingCodeunitID);

        DocumentIsPosted := not PurchaseHeader.Get("Document Type","No.");

        if "Job Queue Status" = "job queue status"::"Scheduled for Posting" then
          CurrPage.Close;
        CurrPage.Update(false);

        if PostingCodeunitID <> Codeunit::"Purch.-Post (Yes/No)" then
          exit;

        if InstructionMgt.IsEnabled(InstructionMgt.ShowPostedConfirmationMessageCode) then
          ShowPostedConfirmationMessage;
    end;

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
        DocNoVisible := DocumentNoVisibility.PurchaseDocumentNoIsVisible(Doctype::"Return Order","No.");
    end;

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        JobQueueVisible := "Job Queue Status" = "job queue status"::"Scheduled for Posting";

        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RecordId);
        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(RecordId);
    end;

    local procedure ShowPostedConfirmationMessage()
    var
        ReturnOrderPurchaseHeader: Record "Purchase Header";
        PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
        InstructionMgt: Codeunit "Instruction Mgt.";
    begin
        if not ReturnOrderPurchaseHeader.Get("Document Type","No.") then begin
          PurchCrMemoHdr.SetRange("No.","Last Posting No.");
          if PurchCrMemoHdr.FindFirst then
            if InstructionMgt.ShowConfirm(OpenPostedPurchaseReturnOrderQst,InstructionMgt.ShowPostedConfirmationMessageCode) then
              Page.Run(Page::"Posted Purchase Credit Memo",PurchCrMemoHdr);
        end;
    end;
}

