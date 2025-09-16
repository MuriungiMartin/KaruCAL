#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 2126 "O365 Email CC Listpart"
{
    Caption = 'CC';
    PageType = ListPart;
    SourceTable = "O365 Email Setup";
    SourceTableView = where(RecipientType=const(CC));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Email;Email)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the CC  recipient address on all new invoices';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        RecipientType := Recipienttype::CC;
    end;
}

