#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9318 "Service Orders"
{
    ApplicationArea = Basic;
    Caption = 'Service Orders';
    CardPageID = "Service Order";
    DataCaptionFields = "Customer No.";
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Warehouse';
    SourceTable = "Service Header";
    SourceTableView = where("Document Type"=const(Order));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the service document you are creating.';
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the service order status, which reflects the repair or maintenance status of all service items on the service order.';
                }
                field("Order Date";"Order Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the service order was created.';
                }
                field("Order Time";"Order Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the time when the service order was created.';
                }
                field("Customer No.";"Customer No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the customer who owns the items in the service document.';
                }
                field("Ship-to Code";"Ship-to Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the customer'' s address where you will ship the service.';
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the customer to whom the items on the document will be shipped.';
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the location (for example, warehouse or distribution center) of the items specified on the service item lines.';
                }
                field("Response Date";"Response Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the estimated date when work on the order should start, that is, when the service order status changes from Pending, to In Process.';
                }
                field("Response Time";"Response Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the estimated time when work on the order starts, that is, when the service order status changes from Pending, to In Process.';
                }
                field(Priority;Priority)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the priority of the service order.';
                }
                field("Release Status";"Release Status")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if items in the Service Lines window are ready to be handled in warehouse activities.';
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the dimension value code for the dimension chosen as Global Dimension 1.';
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the dimension value code for the dimension chosen as Global Dimension 2.';
                    Visible = false;
                }
                field("Assigned User ID";"Assigned User ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ID of the user who is responsible for the document.';
                }
                field("Notify Customer";"Notify Customer")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Indicates how the customer wants to receive notifications about service completion.';
                    Visible = false;
                }
                field("Service Order Type";"Service Order Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of this service order.';
                    Visible = false;
                }
                field("Contract No.";"Contract No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the contract associated with the order.';
                    Visible = false;
                }
                field("Document Date";"Document Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the service document was created.';
                    Visible = false;
                }
                field("Payment Terms Code";"Payment Terms Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code that represents the service header payment terms, which are used to calculate the due date and payment discount date.';
                    Visible = false;
                }
                field("Due Date";"Due Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Indicates when the invoice is due.';
                    Visible = false;
                }
                field("Payment Discount %";"Payment Discount %")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the percentage of payment discount given, if the customer pays by the date entered in the Pmt. Discount Date field.';
                    Visible = false;
                }
                field("Payment Method Code";"Payment Method Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the method the customer uses to pay for the service.';
                    Visible = false;
                }
                field("Shipping Advice";"Shipping Advice")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies information about whether the customer will accept a partial shipment of the order.';
                    Visible = false;
                }
                field("Warning Status";"Warning Status")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the response time warning status for the order.';
                    Visible = false;
                }
                field("Allocated Hours";"Allocated Hours")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of hours allocated to the items in this service order.';
                    Visible = false;
                }
                field("Expected Finishing Date";"Expected Finishing Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when service on the order is expected to be finished.';
                    Visible = false;
                }
                field("Starting Date";"Starting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the starting date of the service, that is, the date when the order status changes from Pending, to In Process for the first time.';
                    Visible = false;
                }
                field("Finishing Date";"Finishing Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the finishing date of the service, that is, the date when the Status field changes to Finished.';
                    Visible = false;
                }
                field("Service Time (Hours)";"Service Time (Hours)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the total time in hours that the service specified in the order has taken.';
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            part(Control1902018507;"Customer Statistics FactBox")
            {
                SubPageLink = "No."=field("Bill-to Customer No.");
                Visible = true;
            }
            part(Control1900316107;"Customer Details FactBox")
            {
                SubPageLink = "No."=field("Customer No.");
                Visible = true;
            }
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
                Visible = true;
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
                separator(Action1102601006)
                {
                    Caption = '';
                }
                action("&Customer Card")
                {
                    ApplicationArea = Basic;
                    Caption = '&Customer Card';
                    Image = Customer;
                    RunObject = Page "Customer Card";
                    RunPageLink = "No."=field("Customer No.");
                    ShortCutKey = 'Shift+F7';
                }
                action("&Dimensions")
                {
                    AccessByPermission = TableData Dimension=R;
                    ApplicationArea = Basic;
                    Caption = '&Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        ShowDocDim;
                    end;
                }
                separator(Action1102601011)
                {
                    Caption = '';
                }
                action("Service Ledger E&ntries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Service Ledger E&ntries';
                    Image = ServiceLedger;
                    RunObject = Page "Service Ledger Entries";
                    RunPageLink = "Service Order No."=field("No.");
                    RunPageView = sorting("Service Order No.","Service Item No. (Serviced)","Entry Type","Moved from Prepaid Acc.","Posting Date",Open,Type);
                    ShortCutKey = 'Ctrl+F7';
                }
                action("Email &Queue")
                {
                    ApplicationArea = Basic;
                    Caption = 'Email &Queue';
                    Image = Email;
                    RunObject = Page "Service Email Queue";
                    RunPageLink = "Document Type"=const("Service Order"),
                                  "Document No."=field("No.");
                    RunPageView = sorting("Document Type","Document No.");
                }
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Service Comment Sheet";
                    RunPageLink = "Table Name"=const("Service Header"),
                                  "Table Subtype"=field("Document Type"),
                                  "No."=field("No."),
                                  Type=const(General);
                }
            }
            group(ActionGroup17)
            {
                Caption = 'Statistics';
                Image = Statistics;
                separator(Action1102601015)
                {
                    Caption = '';
                }
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
                        SalesSetup: Record "Sales & Receivables Setup";
                        ServLine: Record "Service Line";
                        ServLines: Page "Service Lines";
                    begin
                        SalesSetup.Get;
                        if SalesSetup."Calc. Inv. Discount" then begin
                          ServLine.Reset;
                          ServLine.SetRange("Document Type","Document Type");
                          ServLine.SetRange("Document No.","No.");
                          if ServLine.FindFirst then begin
                            ServLines.SetTableview(ServLine);
                            ServLines.CalcInvDisc(ServLine);
                            Commit
                          end;
                        end;
                        if "Tax Area Code" = '' then
                          Page.RunModal(Page::"Service Order Statistics",Rec)
                        else
                          Page.RunModal(Page::"Service Order Stats.",Rec)
                    end;
                }
                separator(Action1102601017)
                {
                    Caption = '';
                }
            }
            group(Documents)
            {
                Caption = 'Documents';
                Image = Documents;
                action("S&hipments")
                {
                    ApplicationArea = Basic;
                    Caption = 'S&hipments';
                    Image = Shipment;
                    RunObject = Page "Posted Service Shipments";
                    RunPageLink = "Order No."=field("No.");
                    RunPageView = sorting("Order No.");
                }
                action(Invoices)
                {
                    ApplicationArea = Basic;
                    Caption = 'Invoices';
                    Image = Invoice;
                    RunObject = Page "Posted Service Invoices";
                    RunPageLink = "Order No."=field("No.");
                    RunPageView = sorting("Order No.");
                }
            }
            group("W&arehouse")
            {
                Caption = 'W&arehouse';
                Image = Warehouse;
                action("Whse. Shipment Lines")
                {
                    ApplicationArea = Basic;
                    Caption = 'Whse. Shipment Lines';
                    Image = ShipmentLines;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page "Whse. Shipment Lines";
                    RunPageLink = "Source Type"=const(5902),
                                  "Source Subtype"=field("Document Type"),
                                  "Source No."=field("No.");
                    RunPageView = sorting("Source Type","Source Subtype","Source No.","Source Line No.");
                }
            }
            group(History)
            {
                Caption = 'History';
                Image = History;
                action("Service Document Lo&g")
                {
                    ApplicationArea = Basic;
                    Caption = 'Service Document Lo&g';
                    Image = Log;

                    trigger OnAction()
                    var
                        ServDocLog: Record "Service Document Log";
                    begin
                        ServDocLog.ShowServDocLog(Rec);
                    end;
                }
                action("&Warranty Ledger Entries")
                {
                    ApplicationArea = Basic;
                    Caption = '&Warranty Ledger Entries';
                    Image = WarrantyLedger;
                    RunObject = Page "Warranty Ledger Entries";
                    RunPageLink = "Service Order No."=field("No.");
                    RunPageView = sorting("Service Order No.","Posting Date","Document No.");
                }
                action("&Job Ledger Entries")
                {
                    ApplicationArea = Basic;
                    Caption = '&Job Ledger Entries';
                    Image = JobLedger;
                    RunObject = Page "Job Ledger Entries";
                    RunPageLink = "Service Order No."=field("No.");
                    RunPageView = sorting("Service Order No.","Posting Date")
                                  where("Entry Type"=const(Usage));
                }
            }
        }
        area(processing)
        {
            group("P&osting")
            {
                Caption = 'P&osting';
                Image = Post;
                action("Test Report")
                {
                    ApplicationArea = Basic;
                    Caption = 'Test Report';
                    Ellipsis = true;
                    Image = TestReport;
                    ToolTip = 'View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.';

                    trigger OnAction()
                    var
                        ReportPrint: Codeunit "Test Report-Print";
                    begin
                        ReportPrint.PrintServiceHeader(Rec);
                    end;
                }
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
                    var
                        ServPostYesNo: Codeunit "Service-Post (Yes/No)";
                    begin
                        ServHeader.Get("Document Type","No.");
                        ServPostYesNo.PostDocument(ServHeader);
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
                        ServPostYesNo: Codeunit "Service-Post (Yes/No)";
                    begin
                        ServHeader.Get("Document Type","No.");
                        ServPostYesNo.PreviewDocument(ServHeader);
                    end;
                }
                action("Post and &Print")
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
                    var
                        ServPostPrint: Codeunit "Service-Post+Print";
                    begin
                        ServHeader.Get("Document Type","No.");
                        ServPostPrint.PostDocument(ServHeader);
                    end;
                }
                action(PostBatch)
                {
                    ApplicationArea = Basic;
                    Caption = 'Post &Batch';
                    Ellipsis = true;
                    Image = PostBatch;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        Clear(ServHeader);
                        ServHeader.SetRange(Status,ServHeader.Status::Finished);
                        Report.RunModal(Report::"Batch Post Service Orders",true,true,ServHeader);
                        CurrPage.Update(false);
                    end;
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
                    var
                        DocPrint: Codeunit "Document-Print";
                    begin
                        CurrPage.Update(true);
                        DocPrint.PrintServiceHeader(Rec);
                    end;
                }
            }
            group(ActionGroup13)
            {
                Caption = 'W&arehouse';
                Image = Warehouse;
                action("Release to Ship")
                {
                    ApplicationArea = Basic;
                    Caption = 'Release to Ship';
                    Image = ReleaseShipment;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ShortCutKey = 'Ctrl+F9';

                    trigger OnAction()
                    var
                        ReleaseServiceDocument: Codeunit "Release Service Document";
                    begin
                        ReleaseServiceDocument.PerformManualRelease(Rec);
                    end;
                }
                action(Reopen)
                {
                    ApplicationArea = Basic;
                    Caption = 'Reopen';
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    var
                        ReleaseServiceDocument: Codeunit "Release Service Document";
                    begin
                        ReleaseServiceDocument.PerformManualReopen(Rec);
                    end;
                }
                action("Create Whse Shipment")
                {
                    AccessByPermission = TableData "Warehouse Shipment Header"=R;
                    ApplicationArea = Basic;
                    Caption = 'Create Whse. Shipment';
                    Image = NewShipment;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    var
                        GetSourceDocOutbound: Codeunit "Get Source Doc. Outbound";
                    begin
                        GetSourceDocOutbound.CreateFromServiceOrder(Rec);
                        if not Find('=><') then
                          Init;
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        SetSecurityFilterOnRespCenter;

        CopyCustomerFilter;
    end;

    var
        ServHeader: Record "Service Header";
}

