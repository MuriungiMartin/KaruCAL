#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 10127 "Posted Bank Rec. Dep Lines Sub"
{
    Caption = 'Posted Bank Rec. Dep Lines Sub';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = UnknownTable10124;
    SourceTableView = sorting("Bank Account No.","Statement No.","Record Type","Line No.")
                      where("Record Type"=const(Deposit));

    layout
    {
        area(content)
        {
            field("BankRecHdr.""Bank Account No.""";BankRecHdr."Bank Account No.")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Bank Account No.';
                Editable = false;
                ToolTip = 'Specifies the bank account that the bank statement line applies to.';
            }
            field("BankRecHdr.""Statement No.""";BankRecHdr."Statement No.")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Statement No.';
                Editable = false;
                ToolTip = 'Specifies the bank reconciliation statement number that this line applies to.';
            }
            field("BankRecHdr.""Statement Date""";BankRecHdr."Statement Date")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Statement Date';
                Editable = false;
                ToolTip = 'Specifies the bank reconciliation statement date that this line applies to.';
            }
            repeater(Control1)
            {
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the Posting Date field from the Bank Rec. Line table.';
                }
                field("Document Type";"Document Type")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the Document Type field from the Bank Rec. Line table.';
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the number of the bank reconciliation that this line belongs to.';
                }
                field("External Document No.";"External Document No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the external document number for the posted journal line.';
                    Visible = false;
                }
                field("Account Type";"Account Type")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the Account Type field from the Bank Rec. Line table.';
                    Visible = false;
                }
                field("Account No.";"Account No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the Account No. field from the Bank Rec. Line table.';
                    Visible = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies a description of the transaction on the bank reconciliation line.';
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the amount of the item, such as a check, that was deposited.';
                }
                field(Cleared;Cleared)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies if the check on the line has been cleared, as indicated on the bank statement.';

                    trigger OnValidate()
                    begin
                        ClearedOnAfterValidate;
                    end;
                }
                field("Cleared Amount";"Cleared Amount")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the amount that was cleared by the bank, as indicated by the bank statement.';

                    trigger OnValidate()
                    begin
                        ClearedAmountOnAfterValidate;
                    end;
                }
                field("""Cleared Amount"" - Amount";"Cleared Amount" - Amount)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Difference';
                    Editable = false;
                    ToolTip = 'Specifies the difference between the Amount field and the Cleared Amount field.';
                }
                field("Bal. Account Type";"Bal. Account Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the Balance Account Type that will be posted to the general ledger.';
                    Visible = false;
                }
                field("Bal. Account No.";"Bal. Account No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the general ledger customer, vendor, or bank account number the line will be posted to.';
                    Visible = false;
                }
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the currency code for line amounts posted to the general ledger. This field is for adjustment type lines only.';
                    Visible = false;
                }
                field("Currency Factor";"Currency Factor")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies a currency factor for the reconciliation sub-line entry. The value is calculated based on currency code, exchange rate, and the bank record header’s statement date.';
                    Visible = false;
                }
            }
            field(BankStatementCleared;BankRecHdr."Cleared Inc./Dpsts. Per Stmnt.")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Statement';
                Editable = false;
                ToolTip = 'Specifies the bank reconciliation statement that this line applies to.';
            }
            field(TotalCleared;BankRecHdr."Total Cleared Deposits")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Total Cleared';
                Editable = false;
                ToolTip = 'Specifies the total amount of the lines that are marked as cleared.';
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        OnActivateForm;
    end;

    var
        BankRecHdr: Record UnknownRecord10123;


    procedure SetupTotals()
    begin
        if BankRecHdr.Get("Bank Account No.","Statement No.") then
          BankRecHdr.CalcFields("Total Cleared Deposits");
    end;


    procedure LookupLineDimensions()
    begin
        ShowDimensions;
    end;


    procedure GetTableID(): Integer
    var
        "Object": Record "Object";
    begin
        Object.SetRange(Type,Object.Type::Table);
        Object.SetRange(Name,TableName);
        Object.FindFirst;
        exit(Object.ID);
    end;

    local procedure ClearedOnAfterValidate()
    begin
        CurrPage.Update;
        SetupTotals;
    end;

    local procedure ClearedAmountOnAfterValidate()
    begin
        CurrPage.Update;
        SetupTotals;
    end;

    local procedure OnActivateForm()
    begin
        SetupTotals;
    end;
}

