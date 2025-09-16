#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 6721 "Booking Manager"
{

    trigger OnRun()
    begin
    end;


    procedure GetBookingItems(var TempBookingItem: Record "Booking Item" temporary)
    begin
        OnGetBookingItems(TempBookingItem);
    end;


    procedure GetBookingMailboxes(var TempBookingMailbox: Record "Booking Mailbox" temporary)
    begin
        OnGetBookingMailboxes(TempBookingMailbox);
    end;


    procedure GetBookingServiceForBooking(TempBookingItem: Record "Booking Item" temporary;var TempBookingService: Record "Booking Service" temporary)
    begin
        OnGetBookingServiceForBooking(TempBookingItem,TempBookingService);
    end;


    procedure InvoiceBookingItems()
    var
        TempBookingItem: Record "Booking Item" temporary;
    begin
        GetBookingItems(TempBookingItem);
        TempBookingItem.SetRange(Invoiced,false);
        TempBookingItem.SetFilter(Start,'<%1',CurrentDatetime);
        Page.Run(Page::"Booking Items",TempBookingItem);
    end;


    procedure SetBookingItemInvoiced(InvoicedBookingItem: Record "Invoiced Booking Item")
    begin
        OnSetBookingItemInvoiced(InvoicedBookingItem);
    end;


    procedure Synchronize(TempBookingItem: Record "Booking Item" temporary)
    begin
        OnSynchronize(TempBookingItem);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', false, false)]
    local procedure OnAfterPostSalesDoc(var SalesHeader: Record "Sales Header";var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";SalesShptHdrNo: Code[20];RetRcpHdrNo: Code[20];SalesInvHdrNo: Code[20];SalesCrMemoHdrNo: Code[20])
    var
        InvoicedBookingItem: Record "Invoiced Booking Item";
    begin
        InvoicedBookingItem.SetRange("Document No.",SalesHeader."No.");
        if InvoicedBookingItem.FindSet then
          repeat
            InvoicedBookingItem."Document No." := SalesInvHdrNo;
            InvoicedBookingItem.Posted := true;
            InvoicedBookingItem.Modify;
            SetBookingItemInvoiced(InvoicedBookingItem);
          until InvoicedBookingItem.Next = 0;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeDeleteEvent', '', false, false)]
    local procedure OnDeleteSalesInvoice(var Rec: Record "Sales Header";RunTrigger: Boolean)
    var
        InvoicedBookingItem: Record "Invoiced Booking Item";
    begin
        if RunTrigger then begin
          InvoicedBookingItem.SetRange("Document No.",Rec."No.");
          InvoicedBookingItem.DeleteAll;
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnGetBookingItems(var TempBookingItem: Record "Booking Item" temporary)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnGetBookingMailboxes(var TempBookingMailbox: Record "Booking Mailbox" temporary)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnGetBookingServiceForBooking(TempBookingItem: Record "Booking Item" temporary;var TempBookingService: Record "Booking Service" temporary)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnSetBookingItemInvoiced(InvoicedBookingItem: Record "Invoiced Booking Item")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnSynchronize(TempBookingItem: Record "Booking Item" temporary)
    begin
    end;
}

