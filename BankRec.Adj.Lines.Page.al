#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 36723 "Bank Rec. Adj. Lines"
{
    AutoSplitKey = true;
    Caption = 'Bank Rec. Adj. Lines';
    PageType = ListPart;
    SourceTable = UnknownTable10121;
    SourceTableView = sorting("Bank Account No.","Statement No.","Record Type","Line No.")
                      where("Record Type"=const(Adjustment));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the Statement Date for Check or Deposit type. For Adjustment type lines, the entry will be the actual date the posting.';
                }
                field("Document Type";"Document Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the type of document that the entry on the journal line is.';
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a document number for the journal line.';
                }
                field("External Document No.";"External Document No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a document number that refers to the customer''s or vendor''s numbering system.';
                    Visible = false;
                }
                field("Account Type";"Account Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the type of account the entry on the journal line will be posted to.';
                }
                field("Account No.";"Account No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the account number the entry on the journal line will be posted to.';

                    trigger OnValidate()
                    begin
                        AccountNoOnAfterValidate;
                    end;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a description of the transaction on the bank reconciliation line.';
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the amount of the item, such as a check, that was deposited.';

                    trigger OnValidate()
                    begin
                        AmountOnAfterValidate;
                    end;
                }
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the currency code for the amounts on the line, as it will be posted to the G/L.';
                    Visible = false;
                }
                field("Currency Factor";"Currency Factor")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a currency factor for the reconciliation sub-line entry. The value is calculated based on currency code, exchange rate, and the bank record header’s statement date.';
                    Visible = false;
                }
                field("Bal. Account Type";"Bal. Account Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the code for the Balance Account Type that will be posted to the G/L.';
                }
                field("Bal. Account No.";"Bal. Account No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies that you can select the number of the G/L, customer, vendor or bank account to which a balancing entry for the line will posted.';

                    trigger OnValidate()
                    begin
                        BalAccountNoOnAfterValidate;
                    end;
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the dimension value code the journal line is linked to.';
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the dimension value code the journal line is linked to.';
                    Visible = false;
                }
                field("ShortcutDimCode[3]";ShortcutDimCode[3])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,3';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(3),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(3,ShortcutDimCode[3]);
                    end;
                }
                field("ShortcutDimCode[4]";ShortcutDimCode[4])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,4';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(4),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(4,ShortcutDimCode[4]);
                    end;
                }
                field("ShortcutDimCode[5]";ShortcutDimCode[5])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,5';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(5),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(5,ShortcutDimCode[5]);
                    end;
                }
                field("ShortcutDimCode[6]";ShortcutDimCode[6])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,6';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(6),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(6,ShortcutDimCode[6]);
                    end;
                }
                field("ShortcutDimCode[7]";ShortcutDimCode[7])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,7';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(7),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(7,ShortcutDimCode[7]);
                    end;
                }
                field("ShortcutDimCode[8]";ShortcutDimCode[8])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,8';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(8),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(8,ShortcutDimCode[8]);
                    end;
                }
                field("Adj. Source Record ID";"Adj. Source Record ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies what type of Bank Rec. Line record was the source for the created Adjustment line. The valid types are Check or Deposit.';
                    Visible = false;
                }
                field("Adj. Source Document No.";"Adj. Source Document No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the Document number from the Bank Rec. Line record that was the source for the created Adjustment line.';
                    Visible = false;
                }
            }
            field(Text000;Text000)
            {
                ApplicationArea = Basic;
                Editable = false;
                Visible = false;
            }
            field(Control1020019;Text000)
            {
                ApplicationArea = Basic;
                Editable = false;
                Visible = false;
            }
            field(AccName;AccName)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Account Name';
                Editable = false;
                ToolTip = 'Specifies the name of the bank account.';
            }
            field(BalAccName;BalAccName)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Bal. Account Name';
                ToolTip = 'Specifies the name of the balancing account.';
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        ShowShortcutDimCode(ShortcutDimCode);
        AfterGetCurrentRecord;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        SetUpNewLine(xRec,0,BelowxRec);
        AfterGetCurrentRecord;
    end;

    trigger OnOpenPage()
    begin
        OnActivateForm;
    end;

    var
        AccName: Text[50];
        BalAccName: Text[50];
        ShortcutDimCode: array [8] of Code[20];
        LastBankRecLine: Record UnknownRecord10121;
        Text000: label 'Placeholder';


    procedure SetupTotals()
    begin
        // IF BankRecHdr.GET("Bank Account No.","Statement No.") THEN
        // BankRecHdr.CALCFIELDS("Total Adjustments","Total Balanced Adjustments");
        // CurrForm.TotalAdjustments.UPDATE;
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


    procedure GetAccounts(var BankRecLine: Record UnknownRecord10121;var AccName: Text[50];var BalAccName: Text[50])
    var
        GLAcc: Record "G/L Account";
        Cust: Record Customer;
        Vend: Record Vendor;
        BankAcc: Record "Bank Account";
        FA: Record "Fixed Asset";
    begin
        if (BankRecLine."Account Type" <> LastBankRecLine."Account Type") or
           (BankRecLine."Account No." <> LastBankRecLine."Account No.")
        then begin
          AccName := '';
          if BankRecLine."Account No." <> '' then
            case BankRecLine."Account Type" of
              BankRecLine."account type"::"G/L Account":
                if GLAcc.Get(BankRecLine."Account No.") then
                  AccName := GLAcc.Name;
              BankRecLine."account type"::Customer:
                if Cust.Get(BankRecLine."Account No.") then
                  AccName := Cust.Name;
              BankRecLine."account type"::Vendor:
                if Vend.Get(BankRecLine."Account No.") then
                  AccName := Vend.Name;
              BankRecLine."account type"::"Bank Account":
                if BankAcc.Get(BankRecLine."Account No.") then
                  AccName := BankAcc.Name;
              BankRecLine."account type"::"Fixed Asset":
                if FA.Get(BankRecLine."Account No.") then
                  AccName := FA.Description;
            end;
        end;

        if (BankRecLine."Bal. Account Type" <> LastBankRecLine."Bal. Account Type") or
           (BankRecLine."Bal. Account No." <> LastBankRecLine."Bal. Account No.")
        then begin
          BalAccName := '';
          if BankRecLine."Bal. Account No." <> '' then
            case BankRecLine."Bal. Account Type" of
              BankRecLine."bal. account type"::"G/L Account":
                if GLAcc.Get(BankRecLine."Bal. Account No.") then
                  BalAccName := GLAcc.Name;
              BankRecLine."bal. account type"::Customer:
                if Cust.Get(BankRecLine."Bal. Account No.") then
                  BalAccName := Cust.Name;
              BankRecLine."bal. account type"::Vendor:
                if Vend.Get(BankRecLine."Bal. Account No.") then
                  BalAccName := Vend.Name;
              BankRecLine."bal. account type"::"Bank Account":
                if BankAcc.Get(BankRecLine."Bal. Account No.") then
                  BalAccName := BankAcc.Name;
              BankRecLine."bal. account type"::"Fixed Asset":
                if FA.Get(BankRecLine."Bal. Account No.") then
                  BalAccName := FA.Description;
            end;
        end;

        LastBankRecLine := BankRecLine;
    end;

    local procedure AccountNoOnAfterValidate()
    begin
        GetAccounts(Rec,AccName,BalAccName);
        ShowShortcutDimCode(ShortcutDimCode);
    end;

    local procedure AmountOnAfterValidate()
    begin
        CurrPage.Update(true);
        SetupTotals;
    end;

    local procedure BalAccountNoOnAfterValidate()
    begin
        GetAccounts(Rec,AccName,BalAccName);
        ShowShortcutDimCode(ShortcutDimCode);
    end;

    local procedure AfterGetCurrentRecord()
    begin
        xRec := Rec;
        GetAccounts(Rec,AccName,BalAccName);
    end;

    local procedure OnActivateForm()
    begin
        SetupTotals;
    end;
}

