#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 36722 "Bank Rec. Dep. Lines - Dyn."
{
    Caption = 'Bank Rec. Dep. Lines';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = UnknownTable10121;
    SourceTableView = sorting("Bank Account No.","Statement No.","Record Type","Line No.")
                      where("Record Type"=const(Deposit));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Collapse Status";"Collapse Status")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the collapse status for the reconciliation line.';
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the Statement Date for Check or Deposit type. For Adjustment type lines, the entry will be the actual date the posting.';
                }
                field("Document Type";"Document Type")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the type of document that the entry on the journal line is.';
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies a document number for the journal line.';
                }
                field("External Document No.";"External Document No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies a document number that refers to the customer''s or vendor''s numbering system.';
                    Visible = false;
                }
                field("Account Type";"Account Type")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the type of account the entry on the journal line will be posted to.';
                    Visible = false;
                }
                field("Account No.";"Account No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the account number the entry on the journal line will be posted to.';
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
                    ToolTip = 'Specifies the amount cleared by the bank, as indicated by the bank statement.';

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
                    Editable = false;
                    ToolTip = 'Specifies the code for the Balance Account Type that will be posted to the G/L.';
                    Visible = false;
                }
                field("Bal. Account No.";"Bal. Account No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies that you can select the number of the G/L, customer, vendor or bank account to which a balancing entry for the line will posted.';
                    Visible = false;
                }
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the currency code for the amounts on the line, as it will be posted to the G/L.';
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
        BankRecHdr: Record UnknownRecord10120;


    procedure SetupTotals()
    begin
        if BankRecHdr.Get("Bank Account No.","Statement No.") then
          BankRecHdr.CalcFields("Total Cleared Deposits");
    end;


    procedure LookupLineDimensions()
    begin
        ShowDimensions;
        CurrPage.SaveRecord;
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


    procedure ExpandCurrLine()
    begin
        ExpandLine(Rec);
        CurrPage.Update(false);
    end;


    procedure CollapseCurrLine()
    begin
        CollapseLines(Rec);
        CurrPage.Update(false);
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

