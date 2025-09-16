#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5933 "Service Invoice"
{
    Caption = 'Service Invoice';
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = "Service Header";
    SourceTableView = where("Document Type"=filter(Invoice));

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
                    ToolTip = 'Specifies the number of the service document you are creating.';

                    trigger OnAssistEdit()
                    begin
                        if AssistEdit(xRec) then
                          CurrPage.Update;
                    end;
                }
                field("Customer No.";"Customer No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the customer who owns the items in the service document.';

                    trigger OnValidate()
                    begin
                        CustomerNoOnAfterValidate;
                    end;
                }
                field("Contact No.";"Contact No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the contact to whom you will deliver the service.';

                    trigger OnValidate()
                    begin
                        if GetFilter("Contact No.") = xRec."Contact No." then
                          if "Contact No." <> xRec."Contact No." then
                            SetRange("Contact No.");
                    end;
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the customer to whom the items on the document will be shipped.';
                }
                field(Address;Address)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the address of the customer to whom the service will be shipped.';
                }
                field("Address 2";"Address 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies an alternate address of the customer.';
                }
                field(City;City)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the city of the address.';
                }
                field(County;County)
                {
                    ApplicationArea = Basic;
                    Caption = 'State / ZIP Code';
                }
                field("Post Code";"Post Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ZIP code of the address.';
                }
                field("Contact Name";"Contact Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the contact who will receive the service.';
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the service document should be posted.';
                }
                field("Document Date";"Document Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the service document was created.';
                }
                field("Salesperson Code";"Salesperson Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the salesperson assigned to this service document.';

                    trigger OnValidate()
                    begin
                        SalespersonCodeOnAfterValidate;
                    end;
                }
                field("Responsibility Center";"Responsibility Center")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the responsibility center associated with the user who created the service order.';

                    trigger OnValidate()
                    begin
                        ResponsibilityCenterOnAfterVal;
                    end;
                }
                field("Assigned User ID";"Assigned User ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ID of the user who is responsible for the document.';
                }
            }
            part(ServLines;"Service Invoice Subform")
            {
                SubPageLink = "Document No."=field("No.");
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field("Bill-to Customer No.";"Bill-to Customer No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the customer to whom you send the order invoice.';

                    trigger OnValidate()
                    begin
                        BilltoCustomerNoOnAfterValidat;
                    end;
                }
                field("Bill-to Contact No.";"Bill-to Contact No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the contact to whom you will send the invoice.';
                }
                field("Bill-to Name";"Bill-to Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the customer to whom you will send invoices.';
                }
                field("Bill-to Address";"Bill-to Address")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the address of the customer to whom you will send the invoice.';
                }
                field("Bill-to Address 2";"Bill-to Address 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies an alternate address of the customer.';
                }
                field("Bill-to City";"Bill-to City")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the city of the address.';
                }
                field("Bill-to County";"Bill-to County")
                {
                    ApplicationArea = Basic;
                    Caption = 'State / ZIP Code';
                }
                field("Bill-to Post Code";"Bill-to Post Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ZIP code of the address.';
                }
                field("Bill-to Contact";"Bill-to Contact")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the person to contact when sending invoices to the customer.';
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the dimension value code for the dimension chosen as Global Dimension 1.';

                    trigger OnValidate()
                    begin
                        ShortcutDimension1CodeOnAfterV;
                    end;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the dimension value code for the dimension chosen as Global Dimension 2.';

                    trigger OnValidate()
                    begin
                        ShortcutDimension2CodeOnAfterV;
                    end;
                }
                field("Payment Terms Code";"Payment Terms Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code that represents the service header payment terms, which are used to calculate the due date and payment discount date.';
                }
                field("Due Date";"Due Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies when the invoice is due.';
                }
                field("Payment Discount %";"Payment Discount %")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the percentage of payment discount given, if the customer pays by the date entered in the Pmt. Discount Date field.';
                }
                field("Pmt. Discount Date";"Pmt. Discount Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the last date for the customer to pay the invoice and receive a payment discount.';
                }
                field("Payment Method Code";"Payment Method Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the method the customer uses to pay for the service.';
                }
                field("Tax Liable";"Tax Liable")
                {
                    ApplicationArea = Basic;
                }
                field("Tax Area Code";"Tax Area Code")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Shipping)
            {
                Caption = 'Shipping';
                field("Ship-to Code";"Ship-to Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the customer'' s address where you will ship the service.';

                    trigger OnValidate()
                    begin
                        ShiptoCodeOnAfterValidate;
                    end;
                }
                field("Ship-to Name";"Ship-to Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the customer to whom you will ship the service on the document.';
                }
                field("Ship-to Address";"Ship-to Address")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the address where the service on the document should be shipped to.';
                }
                field("Ship-to Address 2";"Ship-to Address 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies an additional line of the address.';
                }
                field("Ship-to City";"Ship-to City")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the city of the address.';
                }
                field("Ship-to County";"Ship-to County")
                {
                    ApplicationArea = Basic;
                    Caption = 'Ship-to State / ZIP Code';
                }
                field("Ship-to Post Code";"Ship-to Post Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ZIP code of the address.';
                }
                field("Ship-to Contact";"Ship-to Contact")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the contact person at the place where the service should be shipped to.';
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the location (for example, warehouse or distribution center) of the items specified on the service item lines.';
                }
            }
            group("Foreign Trade")
            {
                Caption = 'Foreign Trade';
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the currency code for various amounts on the service lines.';

                    trigger OnAssistEdit()
                    begin
                        Clear(ChangeExchangeRate);
                        ChangeExchangeRate.SetParameter("Currency Code","Currency Factor","Posting Date");
                        if ChangeExchangeRate.RunModal = Action::OK then begin
                          Validate("Currency Factor",ChangeExchangeRate.GetParameter);
                          CurrPage.Update;
                        end;
                        Clear(ChangeExchangeRate);
                    end;
                }
                field("EU 3-Party Trade";"EU 3-Party Trade")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a check box in this field if the service order is part of an EU 3-party trade transaction.';
                }
                field("Transaction Type";"Transaction Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the transaction type assigned to the service document.';
                }
                field("Transaction Specification";"Transaction Specification")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the transaction specification code used on the service document.';
                }
                field("Transport Method";"Transport Method")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the transport method to be used for shipment.';
                }
                field("Exit Point";"Exit Point")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the port of exit through which you ship the service out of your country/region.';
                }
                field("Area";Area)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the area where the customer company is located.';
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
                Visible = false;
            }
            part(Control1907829707;"Service Hist. Sell-to FactBox")
            {
                SubPageLink = "No."=field("Customer No.");
                Visible = false;
            }
            part(Control1902613707;"Service Hist. Bill-to FactBox")
            {
                SubPageLink = "No."=field("Bill-to Customer No.");
                Visible = false;
            }
            part(Control1906530507;"Service Item Line FactBox")
            {
                Provider = ServLines;
                SubPageLink = "Document Type"=field("Document Type"),
                              "Document No."=field("No."),
                              "Line No."=field("Line No.");
                Visible = false;
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
            group("&Invoice")
            {
                Caption = '&Invoice';
                Image = Invoice;
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
                action(Card)
                {
                    ApplicationArea = Basic;
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page "Customer Card";
                    RunPageLink = "No."=field("Customer No.");
                    ShortCutKey = 'Shift+F7';
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
                action("&Dimensions")
                {
                    AccessByPermission = TableData Dimension=R;
                    ApplicationArea = Basic;
                    Caption = '&Dimensions';
                    Enabled = "No." <> '';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        ShowDocDim;
                        CurrPage.SaveRecord;
                    end;
                }
                separator(Action64)
                {
                }
                action("Service Document Lo&g")
                {
                    ApplicationArea = Basic;
                    Caption = 'Service Document Lo&g';
                    Image = Log;

                    trigger OnAction()
                    var
                        ServDocLog: Record "Service Document Log";
                        TempServDocLog: Record "Service Document Log" temporary;
                    begin
                        TempServDocLog.Reset;
                        TempServDocLog.DeleteAll;

                        ServDocLog.Reset;
                        ServDocLog.SetRange("Document Type",ServDocLog."document type"::Invoice);
                        ServDocLog.SetRange("Document No.","No.");
                        if ServDocLog.FindSet then
                          repeat
                            TempServDocLog := ServDocLog;
                            TempServDocLog.Insert;
                          until ServDocLog.Next = 0;

                        TempServDocLog.Reset;
                        TempServDocLog.SetCurrentkey("Change Date","Change Time");
                        TempServDocLog.Ascending(false);

                        Page.Run(0,TempServDocLog);
                    end;
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Calculate Invoice Discount")
                {
                    ApplicationArea = Basic;
                    Caption = 'Calculate &Invoice Discount';
                    Image = CalculateInvoiceDiscount;

                    trigger OnAction()
                    begin
                        ApproveCalcInvDisc;
                    end;
                }
                separator(Action142)
                {
                }
                action("Get St&d. Service Codes")
                {
                    ApplicationArea = Basic;
                    Caption = 'Get St&d. Service Codes';
                    Ellipsis = true;
                    Image = ServiceCode;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        StdServCode: Record "Standard Service Code";
                    begin
                        StdServCode.InsertServiceLines(Rec);
                    end;
                }
            }
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
                    begin
                        ReportPrint.PrintServiceHeader(Rec);
                    end;
                }
                action(Post)
                {
                    ApplicationArea = Basic;
                    Caption = 'P&ost';
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    var
                        ServiceHeader: Record "Service Header";
                        ServPostYesNo: Codeunit "Service-Post (Yes/No)";
                        InstructionMgt: Codeunit "Instruction Mgt.";
                        PreAssignedNo: Code[20];
                    begin
                        PreAssignedNo := "No.";
                        ServPostYesNo.PostDocument(Rec);

                        DocumentIsPosted := not ServiceHeader.Get("Document Type","No.");

                        if InstructionMgt.IsEnabled(InstructionMgt.ShowPostedConfirmationMessageCode) then
                          ShowPostedConfirmationMessage(PreAssignedNo);
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
                        ServPostYesNo.PreviewDocument(Rec);
                    end;
                }
                action(PostAndSend)
                {
                    ApplicationArea = Basic;
                    Caption = 'Post and &Send';
                    Ellipsis = true;
                    Image = PostSendTo;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ServiceHeader: Record "Service Header";
                    begin
                        Codeunit.Run(Codeunit::"Service-Post and Send",Rec);
                        DocumentIsPosted := not ServiceHeader.Get("Document Type","No.");
                    end;
                }
                action("Post and &Print")
                {
                    ApplicationArea = Basic;
                    Caption = 'Post and &Print';
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F9';

                    trigger OnAction()
                    var
                        ServPostPrint: Codeunit "Service-Post+Print";
                    begin
                        ServPostPrint.PostDocument(Rec);
                    end;
                }
                action("Post &Batch")
                {
                    ApplicationArea = Basic;
                    Caption = 'Post &Batch';
                    Ellipsis = true;
                    Image = PostBatch;

                    trigger OnAction()
                    begin
                        Report.RunModal(Report::"Batch Post Service Invoices",true,true,Rec);
                        CurrPage.Update(false);
                    end;
                }
            }
        }
    }

    trigger OnDeleteRecord(): Boolean
    begin
        CurrPage.SaveRecord;
        Clear(ServLogMgt);
        ServLogMgt.ServHeaderManualDelete(Rec);
        exit(ConfirmDeletion);
    end;

    trigger OnFindRecord(Which: Text): Boolean
    begin
        if Find(Which) then
          exit(true);

        SetRange("No.");
        exit(Find(Which));
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Responsibility Center" := UserMgt.GetServiceFilter;
        if "No." = '' then
          SetCustomerFromFilter;
    end;

    trigger OnOpenPage()
    begin
        SetSecurityFilterOnRespCenter;
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        if not DocumentIsPosted then
          exit(ConfirmCloseUnposted);
    end;

    var
        ReportPrint: Codeunit "Test Report-Print";
        UserMgt: Codeunit "User Setup Management";
        ServLogMgt: Codeunit ServLogManagement;
        ChangeExchangeRate: Page "Change Exchange Rate";
        DocumentIsPosted: Boolean;
        OpenPostedServiceInvQst: label 'The invoice has been posted and moved to the Posted Service Invoices window.\\Do you want to open the posted invoice?';

    local procedure ApproveCalcInvDisc()
    begin
        CurrPage.ServLines.Page.ApproveCalcInvDisc;
    end;

    local procedure CustomerNoOnAfterValidate()
    begin
        if GetFilter("Customer No.") = xRec."Customer No." then
          if "Customer No." <> xRec."Customer No." then
            SetRange("Customer No.");
        CurrPage.Update;
    end;

    local procedure SalespersonCodeOnAfterValidate()
    begin
        CurrPage.ServLines.Page.UpdateForm(true);
    end;

    local procedure ResponsibilityCenterOnAfterVal()
    begin
        CurrPage.ServLines.Page.UpdateForm(true);
    end;

    local procedure BilltoCustomerNoOnAfterValidat()
    begin
        CurrPage.Update;
    end;

    local procedure ShortcutDimension1CodeOnAfterV()
    begin
        CurrPage.Update;
    end;

    local procedure ShortcutDimension2CodeOnAfterV()
    begin
        CurrPage.Update;
    end;

    local procedure ShiptoCodeOnAfterValidate()
    begin
        CurrPage.Update(false);
    end;

    local procedure ShowPostedConfirmationMessage(PreAssignedNo: Code[20])
    var
        ServiceInvoiceHeader: Record "Service Invoice Header";
        InstructionMgt: Codeunit "Instruction Mgt.";
    begin
        ServiceInvoiceHeader.SetCurrentkey("Pre-Assigned No.");
        ServiceInvoiceHeader.SetRange("Pre-Assigned No.",PreAssignedNo);
        if ServiceInvoiceHeader.FindFirst then
          if InstructionMgt.ShowConfirm(OpenPostedServiceInvQst,InstructionMgt.ShowPostedConfirmationMessageCode) then
            Page.Run(Page::"Posted Service Invoice",ServiceInvoiceHeader);
    end;
}

