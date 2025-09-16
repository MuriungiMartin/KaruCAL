#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 6722 "Booking Manager Handler"
{

    trigger OnRun()
    begin
    end;

    var
        BookingSync: Record "Booking Sync";
        O365SyncManagement: Codeunit "O365 Sync. Management";

    local procedure CanHandle(): Boolean
    var
        BookingMgrSetup: Record "Booking Mgr. Setup";
    begin
        if BookingMgrSetup.Get then
          if BookingSync.IsSetup then
            exit(BookingMgrSetup."Booking Mgr. Codeunit" = Codeunit::"Booking Manager Handler");

        exit(false);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Booking Manager", 'OnGetBookingItems', '', false, false)]
    local procedure OnGetBookingItems(var TempBookingItem: Record "Booking Item" temporary)
    var
        BookingItem: Record "Booking Item";
        O365SyncManagement: Codeunit "O365 Sync. Management";
    begin
        if not CanHandle then
          exit;

        O365SyncManagement.RegisterBookingsConnection(BookingSync);
        BookingItem.SetRange(Invoiced,false);
        if BookingItem.FindFirst then
          TempBookingItem.Copy(BookingItem,false);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Booking Manager", 'OnGetBookingMailboxes', '', false, false)]
    local procedure OnGetBookingMailboxes(var TempBookingMailbox: Record "Booking Mailbox" temporary)
    begin
        if not CanHandle then
          exit;

        O365SyncManagement.GetBookingMailboxes(BookingSync,TempBookingMailbox,'');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Booking Manager", 'OnSetBookingItemInvoiced', '', false, false)]
    local procedure OnSetBookingItemInvoiced(InvoicedBookingItem: Record "Invoiced Booking Item")
    var
        BookingItem: Record "Booking Item";
    begin
        if not CanHandle then
          exit;

        // Logic here to update booking item to invoiced and possibly set invoice link
        O365SyncManagement.RegisterBookingsConnection(BookingSync);
        BookingItem.SetRange("Item ID",InvoicedBookingItem."Booking Item ID");
        BookingItem.FindFirst;
        BookingItem.Invoiced := true;
        BookingItem."Invoice No." := InvoicedBookingItem."Document No.";
        BookingItem.Modify;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Booking Manager", 'OnSynchronize', '', false, false)]
    local procedure OnSynchronize(TempBookingItem: Record "Booking Item" temporary)
    var
        BookingSync: Record "Booking Sync";
        O365SyncManagement: Codeunit "O365 Sync. Management";
    begin
        if not CanHandle then
          exit;

        O365SyncManagement.SyncBookingCustomers(BookingSync);
        O365SyncManagement.SyncBookingServices(BookingSync);
    end;
}

