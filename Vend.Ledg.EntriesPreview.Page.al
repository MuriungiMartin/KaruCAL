#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 128 "Vend. Ledg. Entries Preview"
{
    Caption = 'Vendor Entries Preview';
    DataCaptionFields = "Vendor No.";
    Editable = false;
    PageType = List;
    SourceTable = "Vendor Ledger Entry";
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
                    ToolTip = 'Specifies the vendor entry''s posting date.';
                }
                field("Document Type";"Document Type")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the document type that the vendor entry belongs to.';
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the vendor entry''s document number.';
                }
                field("External Document No.";"External Document No.")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the external document number that was entered on the purchase header or journal line.';
                }
                field("Vendor No.";"Vendor No.")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the number of the vendor account that the entry is linked to.';
                }
                field("Message to Recipient";"Message to Recipient")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the message exported to the payment file when you use the Export Payments to File function in the Payment Journal window.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies a description of the vendor entry.';
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
                    ToolTip = 'Specifies the customer''s IC partner code, if the customer is one of your intercompany partners.';
                    Visible = false;
                }
                field("Purchaser Code";"Purchaser Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the code for the purchaser whom the entry is linked to.';
                    Visible = false;
                }
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the currency code for the amount on the line.';
                }
                field("Payment Method Code";"Payment Method Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the payment method that was used to make the payment that resulted in the entry.';
                }
                field("Payment Reference";"Payment Reference")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the payment of the purchase invoice.';
                }
                field("Creditor No.";"Creditor No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the vendor who sent the purchase invoice.';
                }
                field(OriginalAmountFCY;OriginalAmountFCY)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Original Amount';
                    Editable = false;
                    ToolTip = 'Specifies the amount on the vendor ledger entry before you post.';

                    trigger OnDrillDown()
                    begin
                        DrilldownAmounts(2);
                    end;
                }
                field(OriginalAmountLCY;OriginalAmountLCY)
                {
                    ApplicationArea = Basic;
                    Caption = 'Original Amount ($)';
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
                    Editable = false;
                    ToolTip = 'Specifies the net amount of all the lines in the vendor entry.';

                    trigger OnDrillDown()
                    begin
                        DrilldownAmounts(0);
                    end;
                }
                field(AmountLCY;AmountLCY)
                {
                    ApplicationArea = Basic;
                    Caption = 'Amount ($)';
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
                    ToolTip = 'Specifies the remaining amount on the vendor ledger entry before you post.';

                    trigger OnDrillDown()
                    begin
                        DrilldownAmounts(1);
                    end;
                }
                field(RemainingAmountLCY;RemainingAmountLCY)
                {
                    ApplicationArea = Basic;
                    Caption = 'Remaining Amount ($)';
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
                    ToolTip = 'Specifies the latest date the amount in the entry must be paid in order for payment discount tolerance to be granted.';
                }
                field("Original Pmt. Disc. Possible";"Original Pmt. Disc. Possible")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the discount that you can obtain if the entry is applied to before the payment discount date.';
                }
                field("Remaining Pmt. Disc. Possible";"Remaining Pmt. Disc. Possible")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the remaining payment discount which can be received if the payment is made before the payment discount date.';
                }
                field("Max. Payment Tolerance";"Max. Payment Tolerance")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the maximum tolerated amount the entry can differ from the amount on the invoice or credit memo.';
                }
                field(Open;Open)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies whether the amount on the entry has been fully paid or there is still a remaining amount that must be applied to.';
                }
                field("On Hold";"On Hold")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies when a vendor ledger has been invoiced and you run the Suggest Vendor Payments batch job.';
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
                        GenJnlPostPreview.ShowDimensions(Database::"Vendor Ledger Entry","Entry No.","Dimension Set ID");
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        StyleTxt := SetStyle;
        CalcAmounts(AmountFCY,AmountLCY,RemainingAmountFCY,RemainingAmountLCY,OriginalAmountFCY,OriginalAmountLCY);
    end;

    var
        TempDetailedVendLedgEntry: Record "Detailed Vendor Ledg. Entry" temporary;
        StyleTxt: Text;
        AmountFCY: Decimal;
        AmountLCY: Decimal;
        RemainingAmountFCY: Decimal;
        RemainingAmountLCY: Decimal;
        OriginalAmountLCY: Decimal;
        OriginalAmountFCY: Decimal;


    procedure Set(var TempVendLedgerEntry: Record "Vendor Ledger Entry" temporary;var TempDetailedVendLedgEntry2: Record "Detailed Vendor Ledg. Entry" temporary)
    begin
        if TempVendLedgerEntry.FindSet then
          repeat
            Rec := TempVendLedgerEntry;
            Insert;
          until TempVendLedgerEntry.Next = 0;

        if TempDetailedVendLedgEntry2.FindSet then
          repeat
            TempDetailedVendLedgEntry := TempDetailedVendLedgEntry2;
            TempDetailedVendLedgEntry.Insert;
          until TempDetailedVendLedgEntry2.Next = 0;
    end;

    local procedure CalcAmounts(var AmountFCY: Decimal;var AmountLCY: Decimal;var RemainingAmountFCY: Decimal;var RemainingAmountLCY: Decimal;var OriginalAmountFCY: Decimal;var OriginalAmountLCY: Decimal)
    begin
        AmountFCY := 0;
        AmountLCY := 0;
        RemainingAmountLCY := 0;
        RemainingAmountFCY := 0;
        OriginalAmountLCY := 0;
        OriginalAmountFCY := 0;

        TempDetailedVendLedgEntry.SetRange("Vendor Ledger Entry No.","Entry No.");
        if TempDetailedVendLedgEntry.FindSet then
          repeat
            if TempDetailedVendLedgEntry."Entry Type" = TempDetailedVendLedgEntry."entry type"::"Initial Entry" then begin
              OriginalAmountFCY += TempDetailedVendLedgEntry.Amount;
              OriginalAmountLCY += TempDetailedVendLedgEntry."Amount (LCY)";
            end;
            if not (TempDetailedVendLedgEntry."Entry Type" in [TempDetailedVendLedgEntry."entry type"::Application,
                                                               TempDetailedVendLedgEntry."entry type"::"Appln. Rounding"])
            then begin
              AmountFCY += TempDetailedVendLedgEntry.Amount;
              AmountLCY += TempDetailedVendLedgEntry."Amount (LCY)";
            end;
            RemainingAmountFCY += TempDetailedVendLedgEntry.Amount;
            RemainingAmountLCY += TempDetailedVendLedgEntry."Amount (LCY)";
          until TempDetailedVendLedgEntry.Next = 0;
    end;

    local procedure DrilldownAmounts(AmountType: Option Amount,"Remaining Amount","Original Amount")
    var
        DetailedVendEntriesPreview: Page "Detailed Vend. Entries Preview";
    begin
        case AmountType of
          Amounttype::Amount:
            TempDetailedVendLedgEntry.SetFilter("Entry Type",'<>%1&<>%2',
              TempDetailedVendLedgEntry."entry type"::Application,TempDetailedVendLedgEntry."entry type"::"Appln. Rounding");
          Amounttype::"Original Amount":
            TempDetailedVendLedgEntry.SetRange("Entry Type",TempDetailedVendLedgEntry."entry type"::"Initial Entry");
          Amounttype::"Remaining Amount":
            TempDetailedVendLedgEntry.SetRange("Entry Type");
        end;
        DetailedVendEntriesPreview.Set(TempDetailedVendLedgEntry);
        DetailedVendEntriesPreview.RunModal;
        Clear(DetailedVendEntriesPreview);
    end;
}

