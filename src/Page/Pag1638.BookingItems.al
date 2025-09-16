#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1638 "Booking Items"
{
    Caption = 'Bookings Not Invoiced';
    Editable = false;
    LinksAllowed = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Invoicing';
    SourceTable = "Booking Item";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(From;Start)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the start date and time of the booking.';
                }
                field("To";"End")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the end date and time of the booking.';
                }
                field(Customer;"Customer Name")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Customer';
                    ToolTip = 'Specifies the name of the customer that the booking is for.';
                }
                field(Service;"Service Name")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the subject of the booking.';
                }
                field("Invoice No.";InvoiceNo)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Invoice No.';
                    ToolTip = 'Specifies the invoice. If the field is blank, the customer has not been invoiced for the booking.';

                    trigger OnDrillDown()
                    var
                        SalesHeader: Record "Sales Header";
                    begin
                        SalesHeader.SetRange("No.",InvoiceNo);
                        SalesHeader.SetRange("Document Type",SalesHeader."document type"::Invoice);
                        if SalesHeader.FindFirst then
                          Page.Run(Page::"Sales Invoice",SalesHeader);
                    end;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Invoice)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Create Invoice';
                Image = NewSalesInvoice;
                Promoted = true;
                PromotedCategory = Category4;
                Scope = Repeater;
                ToolTip = 'Create a new sales invoice for the selected booking.';

                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                begin
                    if not ActionAllowed then
                      exit;

                    CreateSalesHeader(SalesHeader,Rec);
                    CreateSalesLine(SalesHeader,Rec);
                    Commit;
                    Page.Run(Page::"Sales Invoice",SalesHeader);
                end;
            }
            action("Invoice Customer")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Create Invoice for Customer';
                Image = SuggestCustomerBill;
                Promoted = true;
                PromotedCategory = Category4;
                ToolTip = 'Create a new sales invoice for all items booked by the customer on the selected booking.';

                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                begin
                    if not ActionAllowed then
                      exit;

                    SetRange("Customer Email","Customer Email");
                    SetRange(Invoiced,false);
                    if FindSet then begin
                      CreateSalesHeader(SalesHeader,Rec);
                      repeat
                        CreateSalesLine(SalesHeader,Rec);
                      until Next = 0;
                    end;
                    Commit;
                    SetRange("Customer Email");
                    Page.Run(Page::"Sales Invoice",SalesHeader);
                end;
            }
            action(MarkInvoiced)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Mark as Invoiced';
                Gesture = None;
                Image = ClearLog;
                Promoted = true;
                PromotedCategory = Category4;
                Scope = Repeater;
                ToolTip = 'Mark the bookings that you have selected as invoiced. This removes the bookings from this view.';

                trigger OnAction()
                var
                    TempBookingItem: Record "Booking Item" temporary;
                    InstructionMgt: Codeunit "Instruction Mgt.";
                begin
                    if not ActionAllowed then
                      exit;

                    if InstructionMgt.ShowConfirm(ConfirmMarkQst,InstructionMgt.MarkBookingAsInvoicedWarningCode) then begin
                      GetSelectedRecords(TempBookingItem);
                      if TempBookingItem.FindSet then
                        repeat
                          TempBookingItem.Invoiced := true;
                          TempBookingItem.Modify;
                        until TempBookingItem.Next = 0;
                    end;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        InvoicedBookingItem: Record "Invoiced Booking Item";
    begin
        if InvoicedBookingItem.Get("Item ID") then
          InvoiceNo := InvoicedBookingItem."Document No."
        else
          InvoiceNo := '';
    end;

    trigger OnInit()
    var
        BookingManager: Codeunit "Booking Manager";
    begin
        if IsEmpty then begin
          BookingManager.GetBookingItems(Rec);
          SetRange(Invoiced,false);
          CurrPage.Update;
        end;
    end;

    var
        InvoiceNo: Code[20];
        ConfirmMarkQst: label 'The bookings that you mark as invoiced will be removed from this view. You will no longer be able to manage them in this window. Do you want to continue?';

    local procedure CreateSalesHeader(var SalesHeader: Record "Sales Header";TempBookingItem: Record "Booking Item" temporary)
    var
        Customer: Record Customer;
        BookingManager: Codeunit "Booking Manager";
    begin
        Customer.SetRange("E-Mail",TempBookingItem."Customer Email");
        if not Customer.FindFirst then begin
          BookingManager.Synchronize(TempBookingItem);
          Customer.FindFirst;
        end;

        SalesHeader.Init;
        SalesHeader.Validate("Document Type",SalesHeader."document type"::Invoice);
        SalesHeader.Validate("Sell-to Customer No.",Customer."No.");
        SalesHeader.Insert(true);
    end;

    local procedure CreateSalesLine(SalesHeader: Record "Sales Header";TempBookingItem: Record "Booking Item" temporary)
    var
        SalesLine: Record "Sales Line";
        InvoicedBookingItem: Record "Invoiced Booking Item";
        BookingServiceMapping: Record "Booking Service Mapping";
        BookingManager: Codeunit "Booking Manager";
        LineNo: Integer;
    begin
        if not BookingServiceMapping.Get(TempBookingItem."Service ID") then begin
          BookingManager.Synchronize(TempBookingItem);
          BookingServiceMapping.Get(TempBookingItem."Service ID");
        end;

        SalesLine.SetRange("Document Type",SalesHeader."document type"::Invoice);
        SalesLine.SetRange("Document No.",SalesHeader."No.");
        if SalesLine.FindLast then
          LineNo := SalesLine."Line No." + 10000
        else
          LineNo := 10000;
        Clear(SalesLine);

        SalesLine.Init;
        SalesLine.Validate("Document Type",SalesHeader."document type"::Invoice);
        SalesLine.Validate("Document No.",SalesHeader."No.");
        SalesLine.Validate("Line No.",LineNo);
        SalesLine.Validate("Sell-to Customer No.",SalesHeader."Sell-to Customer No.");
        SalesLine.Validate(Type,SalesLine.Type::Item);
        SalesLine.Validate("No.",BookingServiceMapping."Item No.");
        SalesLine.Validate(Quantity,(TempBookingItem."End" - TempBookingItem.Start) / 3600000);
        SalesLine.Validate("Unit Price",TempBookingItem.Price);
        SalesLine.Validate(Description,StrSubstNo('%1 - %2',TempBookingItem."Service Name",Dt2Date(TempBookingItem.Start)));
        SalesLine.Insert(true);

        InvoicedBookingItem.Init;
        InvoicedBookingItem."Booking Item ID" := TempBookingItem."Item ID";
        InvoicedBookingItem."Document No." := SalesHeader."No.";
        if not InvoicedBookingItem.Insert then
          InvoicedBookingItem.Modify;
    end;

    local procedure GetSelectedRecords(var TempBookingItem: Record "Booking Item" temporary)
    var
        BookingManager: Codeunit "Booking Manager";
    begin
        if MarkedOnly then begin
          TempBookingItem.Copy(Rec,true);
          TempBookingItem.MarkedOnly(true);
        end else begin
          BookingManager.GetBookingItems(TempBookingItem);
          CurrPage.SetSelectionFilter(TempBookingItem);
        end;
    end;

    local procedure ActionAllowed() Allowed: Boolean
    begin
        Allowed := ("Service Name" <> '') and not IsEmpty;
    end;
}

