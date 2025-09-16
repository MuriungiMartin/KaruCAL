#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 2117 "O365 Mark As Paid"
{
    Caption = 'Mark as paid';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = StandardDialog;
    ShowFilter = false;
    SourceTable = "Payment Registration Buffer";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'Payment';
                field("Rem. Amt. after Discount";"Rem. Amt. after Discount")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the amount that still needs to be paid.';
                }
                field("Amount Received";"Amount Received")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the payment received.';
                }
                field("Remaining Amount";"Remaining Amount")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the amount that has not been paid.';
                }
                field("Date Received";"Date Received")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the date the payment is received.';
                }
            }
            part(SalesHistoryListPart;"O365 Payment History ListPart")
            {
                ApplicationArea = Basic,Suite;
                Visible = SalesHistoryHasEntries;
            }
        }
    }

    actions
    {
    }

    var
        SalesHistoryHasEntries: Boolean;


    procedure SetPaymentRegistrationBuffer(var TempPaymentRegistrationBuffer: Record "Payment Registration Buffer" temporary)
    begin
        Copy(TempPaymentRegistrationBuffer,true);
        SalesHistoryHasEntries := CurrPage.SalesHistoryListPart.Page.ShowHistory("Document No.");
    end;
}

