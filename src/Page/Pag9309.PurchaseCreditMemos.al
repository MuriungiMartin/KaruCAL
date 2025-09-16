#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9309 "Purchase Credit Memos"
{
    ApplicationArea = Basic;
    Caption = 'Purchase Credit Memos';
    CardPageID = "Purchase Credit Memo";
    DataCaptionFields = "Buy-from Vendor No.";
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Request Approval';
    SourceTable = "Purchase Header";
    SourceTableView = where("Document Type"=const("Credit Memo"));
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
                    ToolTip = 'Specifies the number of the purchase document. The field is only visible if you have not set up a number series for the type of purchase document, or if the Manual Nos. field is selected for the number series.';
                }
                field("Buy-from Vendor No.";"Buy-from Vendor No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the vendor that you buy from. When you enter the number, several other fields on the document are filled from the vendor card. You can change the vendor number as long as you have not posted the document.';
                }
                field("Order Address Code";"Order Address Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the order address code linked to the relevant vendor''s order address.';
                    Visible = false;
                }
                field("Buy-from Vendor Name";"Buy-from Vendor Name")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the name of the vendor who delivers the items.';
                }
                field("Vendor Authorization No.";"Vendor Authorization No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the compensation agreement identification number, sometimes referred to as the RMA No. (Returns Materials Authorization).';
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
                    ToolTip = 'Specifies the name of the person to contact about shipment of the item from this vendor.';
                    Visible = false;
                }
                field("Pay-to Vendor No.";"Pay-to Vendor No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the vendor who is sending the invoice.';
                    Visible = false;
                }
                field("Pay-to Name";"Pay-to Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the vendor sending the invoice.';
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
                    ToolTip = 'Specifies the name of the person to contact about an invoice from this vendor.';
                    Visible = false;
                }
                field("Ship-to Code";"Ship-to Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a ship-to code if you want a different shipment address from the one that has been automatically entered.';
                    Visible = false;
                }
                field("Ship-to Name";"Ship-to Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the company at the address to which you want the items to be shipped.';
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
                    ToolTip = 'Specifies the name of a contact person for the address where the items should be shipped.';
                    Visible = false;
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the posting of the purchase document will be recorded.';
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the dimension value code associated with the purchase header.';
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the dimension value code associated with the purchase header.';
                    Visible = false;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a code for the location where you want the items to be placed when they are received.';
                }
                field("Purchaser Code";"Purchaser Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies which purchaser is assigned to the vendor.';
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
                    ToolTip = 'Specifies the code of the currency of the amounts on the purchase lines.';
                    Visible = false;
                }
                field("Document Date";"Document Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date of the vendor''s invoice.';
                    Visible = false;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether the record is open, waiting to be approved, invoiced for prepayment, or released to the next stage of processing.';
                    Visible = false;
                }
                field("Payment Terms Code";"Payment Terms Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a formula that calculates the payment due date, payment discount date, and payment discount amount on the purchase document.';
                    Visible = false;
                }
                field("Due Date";"Due Date")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies when the invoice is due. The program calculates the date using the Payment Terms Code and Document Date fields.';
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the sum of the amounts in the Amount field on the associated purchase lines.';
                }
                field("Payment Discount %";"Payment Discount %")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the payment discount percent granted if payment is made on or before the date in the Pmt. Discount Date field.';
                    Visible = false;
                }
                field("Applies-to Doc. Type";"Applies-to Doc. Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'You can use this field when you post the purchase header, to have the program apply it to a document that has already been posted. In this case, enter here the type of document that you want it to be applied to.';
                    Visible = false;
                }
                field("Job Queue Status";"Job Queue Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the status of a job queue entry that handles the posting of purchase orders.';
                    Visible = JobQueueActive;
                }
            }
        }
        area(factboxes)
        {
            part(IncomingDocAttachFactBox;"Incoming Doc. Attach. FactBox")
            {
                ShowFilter = false;
            }
            part(Control1901138007;"Vendor Details FactBox")
            {
                SubPageLink = "No."=field("Buy-from Vendor No.");
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
            group("&Credit Memo")
            {
                Caption = '&Credit Memo';
                Image = CreditMemo;
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
                          Page.RunModal(Page::"Purchase Stats.",Rec)
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
                    ApplicationArea = Suite;
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
            group(ActionGroup7)
            {
                Caption = 'Release';
                Image = ReleaseDoc;
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
                    Image = ReOpen;

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
                Image = "Action";
                action(SendApprovalRequest)
                {
                    ApplicationArea = Suite;
                    Caption = 'Send A&pproval Request';
                    Enabled = not OpenApprovalEntriesExist;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Send an approval request.';

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
                    ApplicationArea = Suite;
                    Caption = 'Cancel Approval Re&quest';
                    Enabled = CanCancelApprovalForRecord;
                    Image = CancelApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Cancel the approval request.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.OnCancelPurchaseApprovalRequest(Rec);
                    end;
                }
            }
            group("P&osting")
            {
                Caption = 'P&osting';
                Image = Post;
                action(Post)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'P&ost';
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';
                    ToolTip = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';

                    trigger OnAction()
                    begin
                        CheckPurchaseCheckAllLinesHaveQuantityAssigned;
                        SendToPosting(Codeunit::"Purch.-Post (Yes/No)");
                    end;
                }
                action(Preview)
                {
                    ApplicationArea = Basic,Suite;
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
                    ApplicationArea = Basic,Suite;
                    Caption = 'Post and &Print';
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F9';
                    ToolTip = 'Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.';
                    Visible = not IsOfficeAddin;

                    trigger OnAction()
                    begin
                        CheckPurchaseCheckAllLinesHaveQuantityAssigned;
                        SendToPosting(Codeunit::"Purch.-Post + Print");
                    end;
                }
                action(PostBatch)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Post &Batch';
                    Ellipsis = true;
                    Image = PostBatch;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Post several documents at once. A report request window opens where you can specify which documents to post.';

                    trigger OnAction()
                    begin
                        CheckPurchaseCheckAllLinesHaveQuantityAssigned;
                        Report.RunModal(Report::"Batch Post Purch. Credit Memos",true,true,Rec);
                        CurrPage.Update(false);
                    end;
                }
                action(RemoveFromJobQueue)
                {
                    ApplicationArea = All;
                    Caption = 'Remove From Job Queue';
                    Image = RemoveLine;
                    ToolTip = 'Remove the scheduled processing of this record from the job queue.';
                    Visible = JobQueueActive;

                    trigger OnAction()
                    begin
                        CancelBackgroundPosting;
                    end;
                }
            }
        }
        area(reporting)
        {
            group(Sales)
            {
                Caption = 'Sales';
                Image = Sales;
                action("<Report Vendor - Purchase List>")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Vendor - Purchase List';
                    Image = "Report";
                    RunObject = Report "Vendor - Purchase List";
                    ToolTip = 'View a list of your purchases in a period, for example, to report purchase activity to customs and tax authorities.';
                }
                action("<Report Puchase Statistics>")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Purchase Statistics';
                    Image = "Report";
                    RunObject = Report "Vendor Purchase Statistics";
                    ToolTip = 'View an overview of amounts for purchases, invoice discount, and payment discount in $ for each vendor, for example, to analyze item purchases for an individual customer and trends for item purchases.';
                }
            }
            group(Finance)
            {
                Caption = 'Finance';
                Image = Sales;
                action(Statement)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Statement';
                    Image = "Report";
                    RunObject = Report Statement;
                    ToolTip = 'View a list of your transactions for a vendor for a selected period, for example, to study expenditure trends.';
                }
                action("Vendor - Balance to Date")
                {
                    ApplicationArea = Basic;
                    Caption = 'Vendor - Balance to Date';
                    Image = "Report";
                    RunObject = Report "Vendor - Balance to Date";
                    ToolTip = 'View, print, or save vendors'' balances on a certain date, for example, to extract your total expenses at the close of an accounting period or fiscal year.';
                }
                action("<Report Vendor - Trial Balance")
                {
                    ApplicationArea = Suite;
                    Caption = 'Vendor - Trial Balance';
                    Image = "Report";
                    RunObject = Report "Vendor - Trial Balance";
                    ToolTip = 'View the beginning and ending balance for vendors with entries within a specified period. The report can be used to verify that the balance for a vendor posting group is equal to the balance on the corresponding general ledger account on a certain date.';
                }
                action("<Report Vendor - Detail Trial ")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Vendor - Detail. Trial Balance';
                    Image = "Report";
                    RunObject = Report "Vendor - Detail Trial Balance";
                    ToolTip = 'View the balance for vendors with balances on a specified date, for example, at the close of an accounting period or for an audit.';
                }
                action("<Report Aged Accounts Payables")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Aged Accounts Payables';
                    Image = "Report";
                    RunObject = Report "Aged Accounts Payable";
                    ToolTip = 'View an overview of when your payables to vendors are due or overdue (divided into four periods). You must specify the date you want aging calculated from and the length of the period that each column will contain data for.';
                }
                action("<Report Vendor - Payment Recei")
                {
                    ApplicationArea = Suite;
                    Caption = 'Vendor - Payment Receipt';
                    Image = "Report";
                    RunObject = Report "Customer - Payment Receipt";
                    ToolTip = 'View a document showing which vendor ledger entries that a payment has been applied to.';
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
        PurchasesPayablesSetup: Record "Purchases & Payables Setup";
        OfficeMgt: Codeunit "Office Management";
    begin
        SetSecurityFilterOnRespCenter;

        JobQueueActive := PurchasesPayablesSetup.JobQueueActive;
        IsOfficeAddin := OfficeMgt.IsAvailable;

        CopyBuyFromVendorFilter;
    end;

    var
        ReportPrint: Codeunit "Test Report-Print";
        [InDataSet]
        JobQueueActive: Boolean;
        OpenApprovalEntriesExist: Boolean;
        IsOfficeAddin: Boolean;
        CanCancelApprovalForRecord: Boolean;

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RecordId);

        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(RecordId);
    end;

    local procedure CheckPurchaseCheckAllLinesHaveQuantityAssigned()
    var
        ApplicationAreaSetup: Record "Application Area Setup";
        LinesInstructionMgt: Codeunit "Lines Instruction Mgt.";
    begin
        if ApplicationAreaSetup.IsFoundationEnabled then
          LinesInstructionMgt.PurchaseCheckAllLinesHaveQuantityAssigned(Rec);
    end;
}

