#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 6704 "Booking Mailbox List"
{
    Caption = 'Booking Mailbox List';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Booking Mailbox";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Service Address";SmtpAddress)
                {
                    ApplicationArea = Basic,Suite;
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Display Name";"Display Name")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the full name of the booking mailbox.';
                }
            }
        }
    }

    actions
    {
    }


    procedure SetMailboxes(var TempBookingMailbox: Record "Booking Mailbox" temporary)
    begin
        TempBookingMailbox.Reset;
        if TempBookingMailbox.FindSet then
          repeat
            Init;
            TransferFields(TempBookingMailbox);
            Insert;
          until TempBookingMailbox.Next = 0;
    end;
}

