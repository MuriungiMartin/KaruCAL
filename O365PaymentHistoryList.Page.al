#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 2118 "O365 Payment History List"
{
    Caption = 'Payment History';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    ShowFilter = false;
    SourceTable = "O365 Payment History Buffer";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Type;Type)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the type of the entry.';
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the payment received.';
                }
                field("Date Received";"Date Received")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the date the payment is received.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(MarkAsUnpaid)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Mark as unpaid';
                Gesture = LeftSwipe;
                Image = Cancel;
                Promoted = true;
                PromotedIsBig = true;
                Scope = Repeater;
                ToolTip = 'Mark the payment as unpaid.';

                trigger OnAction()
                begin
                    CancelPayment;
                    FillPaymentHistory(SalesInvoiceDocNo,true);
                end;
            }
        }
    }

    var
        SalesInvoiceDocNo: Code[20];


    procedure ShowHistory(SalesInvoiceDocumentNo: Code[20])
    begin
        SalesInvoiceDocNo := SalesInvoiceDocumentNo;
        FillPaymentHistory(SalesInvoiceDocumentNo,true);
    end;
}

