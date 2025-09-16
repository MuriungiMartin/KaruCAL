#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 49 "Purchase Quote"
{
    Caption = 'Purchase Quote';
    PageType = Document;
    PromotedActionCategories = 'New,Process,Report,Approve,Request Approval';
    RefreshOnActivate = true;
    SourceTable = "Purchase Header";
    SourceTableView = where("Document Type"=filter(Quote),
                            "Document Type 2"=filter(Quote),
                            DocApprovalType=filter(Quote));

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
                }
                field("Document Date";"Document Date")
                {
                    ApplicationArea = Basic;
                }
                field("Request for Quote No.";"Request for Quote No.")
                {
                    ApplicationArea = Basic;
                }
                field("Due Date";"Due Date")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field("Order Date";"Order Date")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field("Requested Receipt Date";"Requested Receipt Date")
                {
                    ApplicationArea = Basic;
                }
                field("Vendor Order No.";"Vendor Order No.")
                {
                    ApplicationArea = Basic;
                }
                field("Vendor Shipment No.";"Vendor Shipment No.")
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
                field("Responsibility Center";"Responsibility Center")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field("Assigned User ID";"Assigned User ID")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
            }
            part(PurchLines;"Purchase Quote Subform")
            {
                Editable = "Buy-from Vendor No." <> '';
                Enabled = "Buy-from Vendor No." <> '';
                SubPageLink = "Document No."=field("No.");
                UpdatePropagation = Both;
            }
            group("Invoice Details")
            {
                Caption = 'Invoice Details';
                Visible = false;
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;

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
                    Importance = Promoted;
                }
                field("Payment Terms Code";"Payment Terms Code")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field("Payment Method Code";"Payment Method Code")
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
                field("Payment Discount %";"Payment Discount %")
                {
                    ApplicationArea = Basic;
                }
                field("Pmt. Discount Date";"Pmt. Discount Date")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field("Shipment Method Code";"Shipment Method Code")
                {
                    ApplicationArea = Basic;
                }
                field("Payment Reference";"Payment Reference")
                {
                    ApplicationArea = Basic;
                }
                field("Creditor No.";"Creditor No.")
                {
                    ApplicationArea = Basic;
                }
                field("On Hold";"On Hold")
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
            }
            group("Shipping and Payment")
            {
                Caption = 'Shipping and Payment';
                group("Ship-to")
                {
                    Caption = 'Ship-to';
                    Visible = false;
                    field("Order Address Code";"Order Address Code")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Code';
                        Importance = Additional;
                    }
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
                    Visible = false;
                    field("Pay-to Name";"Pay-to Name")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Name';

                        trigger OnValidate()
                        begin
                            if GetFilter("Pay-to Vendor No.") = xRec."Pay-to Vendor No." then
                              if "Pay-to Vendor No." <> xRec."Pay-to Vendor No." then
                                SetRange("Pay-to Vendor No.");

                            CurrPage.Update;
                        end;
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
                Visible = false;
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
            part(Control13;"Pending Approval FactBox")
            {
                SubPageLink = "Table ID"=const(38),
                              "Document Type"=field("Document Type"),
                              "Document No."=field("No.");
                Visible = OpenApprovalEntriesExistForCurrUser;
            }
            part(Control1901138007;"Vendor Details FactBox")
            {
                SubPageLink = "No."=field("Buy-from Vendor No.");
                Visible = false;
            }
            part(Control1904651607;"Vendor Statistics FactBox")
            {
                SubPageLink = "No."=field("Pay-to Vendor No.");
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
            part(Control5;"Purchase Line FactBox")
            {
                Provider = PurchLines;
                SubPageLink = "Document Type"=field("Document Type"),
                              "Document No."=field("Document No."),
                              "Line No."=field("Line No.");
            }
            part(Control1906354007;"Approval FactBox")
            {
                SubPageLink = "Table ID"=const(38),
                              "Document Type"=field("Document Type"),
                              "Document No."=field("No.");
                Visible = false;
            }
            part(IncomingDocAttachFactBox;"Incoming Doc. Attach. FactBox")
            {
                ShowFilter = false;
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
            group("&Quote")
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
                          Page.RunModal(Page::"Purchase Statistics",Rec)
                        else
                          Page.RunModal(Page::"Purchase Stats.",Rec);
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
                action("Bid Analysis")
                {
                    ApplicationArea = Basic;
                    Caption = 'Bid Analysis';
                    Image = Worksheet;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Student Deferment/Withdrawals";
                    RunPageLink = "RFQ No."=field("RFQ No.");

                    trigger OnAction()
                    var
                        PurchaseHeader: Record "Purchase Header";
                        PurchaseLines: Record "Purchase Line";
                        ItemNoFilter: Text[250];
                        RFQNoFilter: Text[250];
                        InsertCount: Integer;
                        BidAnalysis: Record UnknownRecord61550;
                    begin
                        //deletebidanalysis for this vendor
                        BidAnalysis.SetRange(BidAnalysis."RFQ No.","No.");
                        BidAnalysis.DeleteAll;

                        //insert the quotes from vendors
                        PurchaseHeader.SetRange("Request for Quote No.","RFQ No.");
                        PurchaseHeader.FindSet;
                        repeat
                          PurchaseLines.Reset;
                          PurchaseLines.SetRange("Document No.",PurchaseHeader."No.");
                          if PurchaseLines.FindSet then
                          repeat
                            BidAnalysis.Init;
                            BidAnalysis."RFQ No.":="RFQ No.";
                            BidAnalysis."RFQ Line No.":=PurchaseLines."Line No.";
                            BidAnalysis."Quote No.":=PurchaseLines."Document No.";
                            BidAnalysis."Vendor No.":=PurchaseHeader."Buy-from Vendor No.";
                            BidAnalysis."Item No.":=PurchaseLines."No.";
                            BidAnalysis.Description:=PurchaseLines.Description;
                            BidAnalysis.Quantity:=PurchaseLines.Quantity;
                            BidAnalysis."Unit Of Measure":=PurchaseLines."Unit of Measure";
                            BidAnalysis.Amount:=PurchaseLines."Direct Unit Cost";
                            //BidAnalysis."Vat Amount":=PurchaseLines."VAT Amount";
                            BidAnalysis."Line Amount":=BidAnalysis.Quantity*BidAnalysis. Amount;
                            BidAnalysis.Remarks := PurchaseLines."RFQ Remarks";
                            if BidAnalysis.Insert(true) then
                            InsertCount+=1;
                           until PurchaseLines.Next=0;
                        until PurchaseHeader.Next=0;
                        //MESSAGE('%1 records have been inserted to the bid analysis',InsertCount);
                    end;
                }
                action("Print Bid Analysis")
                {
                    ApplicationArea = Basic;
                    Caption = 'Print Bid Analysis';
                    Image = Report2;
                    Promoted = true;
                    PromotedCategory = "Report";

                    trigger OnAction()
                    var
                        PurchaseHeader: Record "Purchase Header";
                        PurchaseLines: Record "Purchase Line";
                        ItemNoFilter: Text[250];
                        RFQNoFilter: Text[250];
                        InsertCount: Integer;
                        BidAnalysis: Record UnknownRecord61550;
                    begin
                        //deletebidanalysis for this vendor
                        BidAnalysis.SetRange(BidAnalysis."RFQ No.","RFQ No.");
                        BidAnalysis.DeleteAll;


                        //insert the quotes from vendors

                        PurchaseHeader.SetRange("RFQ No.","RFQ No.");
                        PurchaseHeader.FindSet;
                        repeat
                          PurchaseLines.Reset;
                          PurchaseLines.SetRange("Document No.",PurchaseHeader."No.");
                          if PurchaseLines.FindSet then
                          repeat
                            BidAnalysis.Init;
                            BidAnalysis."RFQ No.":="RFQ No.";
                            BidAnalysis."RFQ Line No.":=PurchaseLines."Line No.";
                            BidAnalysis."Quote No.":=PurchaseLines."Document No.";
                            BidAnalysis."Vendor No.":=PurchaseHeader."Buy-from Vendor No.";
                            BidAnalysis."Item No.":=PurchaseLines."No.";
                            BidAnalysis.Description:=PurchaseLines.Description;
                            BidAnalysis.Quantity:=PurchaseLines.Quantity;
                            BidAnalysis."Unit Of Measure":=PurchaseLines."Unit of Measure";
                            BidAnalysis.Amount:=PurchaseLines."Direct Unit Cost";
                            //BidAnalysis."Vat Amount":=PurchaseLines."VAT Amount";
                            BidAnalysis."Line Amount":=BidAnalysis.Quantity*BidAnalysis. Amount;
                            BidAnalysis.Remarks := PurchaseLines."RFQ Remarks";
                            BidAnalysis.Insert(true);
                            InsertCount+=1;
                           until PurchaseLines.Next=0;
                        until PurchaseHeader.Next=0;
                        //MESSAGE('%1 records have been inserted to the bid analysis',InsertCount);
                        Commit;

                        BidAnalysis.Reset;
                        BidAnalysis.SetRange("RFQ No.","RFQ No.");
                        //RFQ No.,RFQ Line No.,Quote No.,Vendor No.
                        if BidAnalysis.Find
                         then
                        Report.Run(Report::"Bid Analysis",true,false,BidAnalysis);
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
            group(ActionGroup3)
            {
                Caption = 'Release';
                Image = ReleaseDoc;
                separator(Action148)
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
                        CurrPage.PurchLines.Page.RecalculateTaxes;
                    end;
                }
                separator(Action144)
                {
                }
                action("Get St&d. Vend. Purchase Codes")
                {
                    ApplicationArea = Basic;
                    Caption = 'Get St&d. Vend. Purchase Codes';
                    Ellipsis = true;
                    Image = VendorCode;

                    trigger OnAction()
                    var
                        StdVendPurchCode: Record "Standard Vendor Purchase Code";
                    begin
                        StdVendPurchCode.InsertPurchLines(Rec);
                    end;
                }
                separator(Action146)
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
                action("Archive Document")
                {
                    ApplicationArea = Basic;
                    Caption = 'Archi&ve Document';
                    Image = Archive;

                    trigger OnAction()
                    begin
                        ArchiveManagement.ArchivePurchDocument(Rec);
                        CurrPage.Update(false);
                    end;
                }
                group(IncomingDocument)
                {
                    Caption = 'Incoming Document';
                    Image = Documents;
                    action(IncomingDocCard)
                    {
                        ApplicationArea = Basic;
                        Caption = 'View Incoming Document';
                        Enabled = HasIncomingDocument;
                        Image = ViewOrder;
                        ToolTip = 'View any incoming document records and file attachments that exist for the entry or document, for example for auditing purposes';

                        trigger OnAction()
                        var
                            IncomingDocument: Record "Incoming Document";
                        begin
                            IncomingDocument.ShowCardFromEntryNo("Incoming Document Entry No.");
                        end;
                    }
                    action(SelectIncomingDoc)
                    {
                        AccessByPermission = TableData "Incoming Document"=R;
                        ApplicationArea = Basic;
                        Caption = 'Select Incoming Document';
                        Image = SelectLineToApply;
                        //The property 'ToolTip' cannot be empty.
                        //ToolTip = '';

                        trigger OnAction()
                        var
                            IncomingDocument: Record "Incoming Document";
                        begin
                            Validate("Incoming Document Entry No.",IncomingDocument.SelectIncomingDocument("Incoming Document Entry No.",RecordId));
                        end;
                    }
                    action(IncomingDocAttachFile)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Create Incoming Document from File';
                        Ellipsis = true;
                        Enabled = CreateIncomingDocumentEnabled;
                        Image = Attach;
                        //The property 'ToolTip' cannot be empty.
                        //ToolTip = '';

                        trigger OnAction()
                        var
                            IncomingDocumentAttachment: Record "Incoming Document Attachment";
                        begin
                            IncomingDocumentAttachment.NewAttachmentFromPurchaseDocument(Rec);
                        end;
                    }
                    action(RemoveIncomingDoc)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Remove Incoming Document';
                        Enabled = HasIncomingDocument;
                        Image = RemoveLine;
                        //The property 'ToolTip' cannot be empty.
                        //ToolTip = '';

                        trigger OnAction()
                        var
                            IncomingDocument: Record "Incoming Document";
                        begin
                            if IncomingDocument.Get("Incoming Document Entry No.") then
                              IncomingDocument.RemoveLinkToRelatedRecord;
                            "Incoming Document Entry No." := 0;
                            Modify(true);
                        end;
                    }
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
                        if  ApprovalsMgmt.CheckPurchaseApprovalPossible(Rec) then
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
            group("Make Order")
            {
                Caption = 'Make Order';
                Image = MakeOrder;
                action("Make Order")
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
                          Codeunit.Run(Codeunit::"Purch.-Quote to Order (Yes/No)",Rec);
                    end;
                }
            }
        }
        area(reporting)
        {
            action("Purchase Advice")
            {
                ApplicationArea = Basic;
                Caption = 'Purchase Advice';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Purchase Advice";
            }
            action("Vendor/Item Catalog")
            {
                ApplicationArea = Basic;
                Caption = 'Vendor/Item Catalog';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Item/Vendor Catalog";
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        SetControlAppearance;
        CurrPage.IncomingDocAttachFactBox.Page.LoadDataFromRecord(Rec);
        ShowWorkflowStatus := CurrPage.WorkflowStatus.Page.SetFilterOnWorkflowRecord(RecordId);
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        CurrPage.SaveRecord;
        exit(ConfirmDeletion);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Document Type":="document type"::Quote;
        "Document Type 2":="document type 2"::Quote;
        DocApprovalType:=Docapprovaltype::Quote;
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
        ArchiveManagement: Codeunit ArchiveManagement;
        PurchCalcDiscByType: Codeunit "Purch - Calc Disc. By Type";
        ChangeExchangeRate: Page "Change Exchange Rate";
        HasIncomingDocument: Boolean;
        DocNoVisible: Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        ShowWorkflowStatus: Boolean;
        CanCancelApprovalForRecord: Boolean;
        CreateIncomingDocumentEnabled: Boolean;

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
        CurrPage.Update;
    end;

    local procedure ShortcutDimension2CodeOnAfterV()
    begin
        CurrPage.Update;
    end;

    local procedure SetDocNoVisible()
    var
        DocumentNoVisibility: Codeunit DocumentNoVisibility;
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",Reminder,FinChMemo;
    begin
        DocNoVisible := DocumentNoVisibility.PurchaseDocumentNoIsVisible(Doctype::Quote,"No.");
    end;

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RecordId);
        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(RecordId);
        HasIncomingDocument := "Incoming Document Entry No." <> 0;
        CreateIncomingDocumentEnabled := (not HasIncomingDocument) and ("No." <> '')
    end;
}

