#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9317 "Service Quotes"
{
    ApplicationArea = Basic;
    Caption = 'Service Quotes';
    CardPageID = "Service Quote";
    DataCaptionFields = "Customer No.";
    Editable = false;
    PageType = List;
    SourceTable = "Service Header";
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
                field(Priority;Priority)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the priority of the service order.';
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
                field("Response Date";"Response Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the estimated date when work on the order should start, that is, when the service order status changes from Pending, to In Process.';
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
            group("&Quote")
            {
                Caption = '&Quote';
                Image = Quote;
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
                separator(Action1102601006)
                {
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
                separator(Action1102601008)
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
                    begin
                        CalcInvDiscForHeader;
                        Commit;
                        if "Tax Area Code" = '' then
                          Page.RunModal(Page::"Service Statistics",Rec)
                        else
                          Page.RunModal(Page::"Service Stats.",Rec)
                    end;
                }
                action("Customer Card")
                {
                    ApplicationArea = Basic;
                    Caption = 'Customer Card';
                    Image = Customer;
                    RunObject = Page "Customer Card";
                    RunPageLink = "No."=field("Customer No.");
                    ShortCutKey = 'Shift+F7';
                }
                separator(Action1102601011)
                {
                    Caption = '';
                }
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
            }
        }
        area(processing)
        {
            action("Make &Order")
            {
                ApplicationArea = Basic;
                Caption = 'Make &Order';
                Image = MakeOrder;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    CurrPage.Update;
                    Codeunit.Run(Codeunit::"Serv-Quote to Order (Yes/No)",Rec);
                    CurrPage.Update;
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
    }

    trigger OnOpenPage()
    begin
        SetSecurityFilterOnRespCenter;

        CopyCustomerFilter;
    end;
}

