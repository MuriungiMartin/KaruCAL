#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 126 "Cust. Ledg. Entries Preview"
{
    Caption = 'Cust. Ledg. Entries Preview';
    DataCaptionFields = "Customer No.";
    Editable = false;
    PageType = List;
    SourceTable = "Cust. Ledger Entry";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the customer entry''s posting date.';
                }
                field("Document Type";"Document Type")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the document type that the customer entry belongs to.';
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the entry''s document number.';
                }
                field("Customer No.";"Customer No.")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the customer account number that the entry is linked to.';
                }
                field("Message to Recipient";"Message to Recipient")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the message exported to the payment file when you use the Export Payments to File function in the Payment Journal window.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a description of the customer entry.';
                }
                field("Global Dimension 1 Code";"Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the dimension value code linked to the entry.';
                    Visible = false;
                }
                field("Global Dimension 2 Code";"Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the dimension value code linked to the entry.';
                    Visible = false;
                }
                field("IC Partner Code";"IC Partner Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the code of the intercompany partner that the transaction was with if the entry was posted from an intercompany transaction.';
                    Visible = false;
                }
                field("Salesperson Code";"Salesperson Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the code for the salesperson whom the entry is linked to.';
                    Visible = false;
                }
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the currency code for the amount on the line.';
                }
                field(OriginalAmountFCY;OriginalAmountFCY)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Original Amount';
                    Editable = false;
                    ToolTip = 'Specifies the amount on the customer ledger entry before you post.';

                    trigger OnDrillDown()
                    begin
                        DrilldownAmounts(2);
                    end;
                }
                field(OriginalAmountLCY;OriginalAmountLCY)
                {
                    ApplicationArea = Basic;
                    Caption = 'Original Amount $';
                    Editable = false;
                    Visible = false;

                    trigger OnDrillDown()
                    begin
                        DrilldownAmounts(2);
                    end;
                }
                field(AmountFCY;AmountFCY)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Amount';
                    DrillDown = true;
                    Editable = false;
                    ToolTip = 'Specifies the net amount of all the lines in the customer entry.';

                    trigger OnDrillDown()
                    begin
                        DrilldownAmounts(0);
                    end;
                }
                field(AmountLCY;AmountLCY)
                {
                    ApplicationArea = Basic;
                    Caption = 'Amount $';
                    DrillDown = true;
                    Editable = false;
                    Visible = false;

                    trigger OnDrillDown()
                    begin
                        DrilldownAmounts(0);
                    end;
                }
                field(RemainingAmountFCY;RemainingAmountFCY)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Remaining Amount';
                    Editable = false;
                    ToolTip = 'Specifies the remaining amount on the customer ledger entry before you post.';

                    trigger OnDrillDown()
                    begin
                        DrilldownAmounts(1);
                    end;
                }
                field(RemainingAmountLCY;RemainingAmountLCY)
                {
                    ApplicationArea = Basic;
                    Caption = 'Remaining Amount $';
                    Editable = false;
                    Visible = false;

                    trigger OnDrillDown()
                    begin
                        DrilldownAmounts(1);
                    end;
                }
                field("Bal. Account Type";"Bal. Account Type")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the type of balancing account used on the entry.';
                    Visible = false;
                }
                field("Bal. Account No.";"Bal. Account No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the balancing account number used on the entry.';
                    Visible = false;
                }
                field("Due Date";"Due Date")
                {
                    ApplicationArea = Basic,Suite;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the due date on the entry.';
                }
                field("Pmt. Discount Date";"Pmt. Discount Date")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the date on which the amount in the entry must be paid for a payment discount to be granted.';
                }
                field("Pmt. Disc. Tolerance Date";"Pmt. Disc. Tolerance Date")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the last date the amount in the entry must be paid in order for a payment discount tolerance to be granted.';
                }
                field("Original Pmt. Disc. Possible";"Original Pmt. Disc. Possible")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the discount that the customer can obtain if the entry is applied to before the payment discount date.';
                }
                field("Remaining Pmt. Disc. Possible";"Remaining Pmt. Disc. Possible")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the remaining payment discount that is available if the entry is totally applied to within the payment period.';
                }
                field("Max. Payment Tolerance";"Max. Payment Tolerance")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the maximum tolerated amount the entry can differ from the amount on the invoice or credit memo.';
                }
                field("Payment Method Code";"Payment Method Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the payment method that was used to make the payment that resulted in the entry.';
                }
                field(Open;Open)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies whether the amount on the entry has been fully paid or there is still a remaining amount that must be applied to.';
                }
                field("On Hold";"On Hold")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies when an entry for an unpaid invoice has been posted and you create a finance charge memo or reminder.';
                }
                field("Exported to Payment File";"Exported to Payment File")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies that the entry was created as a result of exporting a payment journal line.';
                }
                field("Source Code";"Source Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the source code that is linked to the entry.';
                    Visible = false;
                }
                field("Reason Code";"Reason Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the reason code on the entry.';
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Ent&ry")
            {
                Caption = 'Ent&ry';
                Image = Entry;
                action(Dimensions)
                {
                    ApplicationArea = Suite;
                    Caption = 'Dimensions';
                    Ellipsis = true;
                    Image = Dimensions;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edits dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                    trigger OnAction()
                    var
                        GenJnlPostPreview: Codeunit "Gen. Jnl.-Post Preview";
                    begin
                        GenJnlPostPreview.ShowDimensions(Database::"Cust. Ledger Entry","Entry No.","Dimension Set ID");
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        StyleTxt := SetStyle;
        CalcAmounts;
    end;

    var
        TempDetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry" temporary;
        StyleTxt: Text;
        AmountFCY: Decimal;
        AmountLCY: Decimal;
        RemainingAmountFCY: Decimal;
        RemainingAmountLCY: Decimal;
        OriginalAmountLCY: Decimal;
        OriginalAmountFCY: Decimal;


    procedure Set(var TempCustLedgerEntry: Record "Cust. Ledger Entry" temporary;var TempDetailedCustLedgEntry2: Record "Detailed Cust. Ledg. Entry" temporary)
    begin
        if TempCustLedgerEntry.FindSet then
          repeat
            Rec := TempCustLedgerEntry;
            Insert;
          until TempCustLedgerEntry.Next = 0;

        if TempDetailedCustLedgEntry2.Find('-') then
          repeat
            TempDetailedCustLedgEntry := TempDetailedCustLedgEntry2;
            TempDetailedCustLedgEntry.Insert;
          until TempDetailedCustLedgEntry2.Next = 0;
    end;


    procedure CalcAmounts()
    begin
        AmountFCY := 0;
        AmountLCY := 0;
        RemainingAmountLCY := 0;
        RemainingAmountFCY := 0;
        OriginalAmountLCY := 0;
        OriginalAmountFCY := 0;

        TempDetailedCustLedgEntry.SetRange("Cust. Ledger Entry No.","Entry No.");
        if TempDetailedCustLedgEntry.FindSet then
          repeat
            if TempDetailedCustLedgEntry."Entry Type" = TempDetailedCustLedgEntry."entry type"::"Initial Entry" then begin
              OriginalAmountFCY += TempDetailedCustLedgEntry.Amount;
              OriginalAmountLCY += TempDetailedCustLedgEntry."Amount (LCY)";
            end;
            if not (TempDetailedCustLedgEntry."Entry Type" in [TempDetailedCustLedgEntry."entry type"::Application,
                                                               TempDetailedCustLedgEntry."entry type"::"Appln. Rounding"])
            then begin
              AmountFCY += TempDetailedCustLedgEntry.Amount;
              AmountLCY += TempDetailedCustLedgEntry."Amount (LCY)";
            end;
            RemainingAmountFCY += TempDetailedCustLedgEntry.Amount;
            RemainingAmountLCY += TempDetailedCustLedgEntry."Amount (LCY)";
          until TempDetailedCustLedgEntry.Next = 0;
    end;

    local procedure DrilldownAmounts(AmountType: Option Amount,"Remaining Amount","Original Amount")
    var
        DetCustLedgEntrPreview: Page "Det. Cust. Ledg. Entr. Preview";
    begin
        case AmountType of
          Amounttype::Amount:
            TempDetailedCustLedgEntry.SetFilter("Entry Type",'<>%1&<>%2',
              TempDetailedCustLedgEntry."entry type"::Application,TempDetailedCustLedgEntry."entry type"::"Appln. Rounding");
          Amounttype::"Original Amount":
            TempDetailedCustLedgEntry.SetRange("Entry Type",TempDetailedCustLedgEntry."entry type"::"Initial Entry");
          Amounttype::"Remaining Amount":
            TempDetailedCustLedgEntry.SetRange("Entry Type");
        end;
        DetCustLedgEntrPreview.Set(TempDetailedCustLedgEntry);
        DetCustLedgEntrPreview.RunModal;
        Clear(DetCustLedgEntrPreview);
    end;
}

