#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 314 "General Posting Setup"
{
    ApplicationArea = Basic;
    Caption = 'General Posting Setup';
    CardPageID = "General Posting Setup Card";
    DataCaptionFields = "Gen. Bus. Posting Group","Gen. Prod. Posting Group";
    Editable = false;
    PageType = List;
    SourceTable = "General Posting Setup";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                FreezeColumn = "Gen. Prod. Posting Group";
                field("Gen. Bus. Posting Group";"Gen. Bus. Posting Group")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the general business posting group that applies to the entry.';
                }
                field("Gen. Prod. Posting Group";"Gen. Prod. Posting Group")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a product posting group code.';
                }
                field("Sales Account";"Sales Account")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number of the general ledger sales account to which the program will post sales transactions with this particular combination of business group and product group.';
                }
                field("Sales Credit Memo Account";"Sales Credit Memo Account")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the general ledger account number to which the program will post transactions involving sales credit memos for this particular combination of business posting group and product posting group.';
                }
                field("Sales Line Disc. Account";"Sales Line Disc. Account")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the general ledger account number to post customer/item and quantity discounts when you post sales transactions with this particular combination of business group and product group.';
                }
                field("Sales Inv. Disc. Account";"Sales Inv. Disc. Account")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the general ledger account number to which to post sales invoice discount amounts when you post sales transactions for this particular combination of business group and product group. To see the account numbers in the';
                }
                field("Sales Pmt. Disc. Debit Acc.";"Sales Pmt. Disc. Debit Acc.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the general ledger account number to post granted sales payment discount amounts when you post payments for sales with this particular combination of business group and product group.';
                }
                field("Sales Pmt. Disc. Credit Acc.";"Sales Pmt. Disc. Credit Acc.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the general ledger account number to which to post reductions in sales payment discount amounts when you post payments for sales with this particular combination of business group and product group.';
                }
                field("Sales Pmt. Tol. Debit Acc.";"Sales Pmt. Tol. Debit Acc.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number of the G/L account to which you want the program to post payment tolerance for purchases with this combination.';
                }
                field("Sales Pmt. Tol. Credit Acc.";"Sales Pmt. Tol. Credit Acc.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number of the G/L account to which you want the program to post payment tolerance for purchases with this combination.';
                }
                field("Sales Prepayments Account";"Sales Prepayments Account")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the general ledger account to post purchase prepayment amounts to.';
                    Visible = false;
                }
                field("Purch. Account";"Purch. Account")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the general ledger account number to which the program will post purchase transactions with this particular combination of business posting group and product posting group.';
                }
                field("Purch. Credit Memo Account";"Purch. Credit Memo Account")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the general ledger account number to which the program will post transactions involving purchase credit memos for this particular combination of business posting group and product posting group.';
                }
                field("Purch. Line Disc. Account";"Purch. Line Disc. Account")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the general ledger account number to which to post purchase line discount amounts with this particular combination of business group and product group.';
                }
                field("Purch. Inv. Disc. Account";"Purch. Inv. Disc. Account")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the general ledger account number to which to post purchase invoice discount amounts with this particular combination of business group and product group.';
                }
                field("Purch. Pmt. Disc. Debit Acc.";"Purch. Pmt. Disc. Debit Acc.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the general ledger account number to which to post reductions in purchase payment discount amounts when you post payments for purchases with this particular combination of business posting group and product posting group.';
                }
                field("Purch. Pmt. Disc. Credit Acc.";"Purch. Pmt. Disc. Credit Acc.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the general ledger account number to which to post received purchase payment discount amounts when you post payments for purchases with this particular combination of business posting group and product posting group.';
                }
                field("Purch. Pmt. Tol. Debit Acc.";"Purch. Pmt. Tol. Debit Acc.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number of the G/L account to which you want the program to post payment tolerance for purchases with this combination.';
                }
                field("Purch. Pmt. Tol. Credit Acc.";"Purch. Pmt. Tol. Credit Acc.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number of the G/L account to which you want the program to post payment tolerance for purchases with this combination.';
                }
                field("Purch. Prepayments Account";"Purch. Prepayments Account")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the general ledger account to post purchase prepayment amounts to.';
                    Visible = false;
                }
                field("COGS Account";"COGS Account")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the general ledger account number to which to post the cost of goods sold with this particular combination of business group and product group.';
                }
                field("COGS Account (Interim)";"COGS Account (Interim)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the interim G/L account to which you want the program to post the expected cost of goods sold with this combination of business group and product group.';
                    Visible = false;
                }
                field("Inventory Adjmt. Account";"Inventory Adjmt. Account")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the general ledger account number to post inventory adjustments with this particular combination of business posting group and product posting group.';
                }
                field("Invt. Accrual Acc. (Interim)";"Invt. Accrual Acc. (Interim)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the G/L account to which you want to post expected inventory adjustments (positive and negative).';
                    Visible = false;
                }
                field("Direct Cost Applied Account";"Direct Cost Applied Account")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the general ledger account number to post the direct cost applied with this particular combination of business posting group and product posting group.';
                }
                field("Overhead Applied Account";"Overhead Applied Account")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the general ledger account number to post the direct cost applied with this particular combination of business posting group and product posting group.';
                }
                field("Purchase Variance Account";"Purchase Variance Account")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the general ledger account number to post the direct cost applied with this particular combination of business posting group and product posting group.';
                }
                field("Purch. FA Disc. Account";"Purch. FA Disc. Account")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the account the line and invoice discount will be posted to when a check mark is placed in the Subtract Disc. in Purch. Inv. field.';
                    Visible = false;
                }
            }
            group(Control52)
            {
                field("Gen. Bus. Posting Group2";"Gen. Bus. Posting Group")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Gen. Bus. Posting Group';
                    Editable = false;
                    ToolTip = 'Specifies a business posting group code.';
                }
                field("Gen. Prod. Posting Group2";"Gen. Prod. Posting Group")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Gen. Prod. Posting Group';
                    Editable = false;
                    ToolTip = 'Specifies a product posting group code.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&Copy")
            {
                ApplicationArea = Basic,Suite;
                Caption = '&Copy';
                Ellipsis = true;
                Image = Copy;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Copy a record with selected fields or all fields from the general posting setup to a new record. Before you start to copy you have to create the new record.';

                trigger OnAction()
                begin
                    CurrPage.SaveRecord;
                    CopyGenPostingSetup.SetGenPostingSetup(Rec);
                    CopyGenPostingSetup.RunModal;
                    Clear(CopyGenPostingSetup);
                end;
            }
        }
    }

    var
        CopyGenPostingSetup: Report "Copy - General Posting Setup";
}

