#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 695 "Confirm Financial Void"
{
    Caption = 'Confirm Financial Void';
    PageType = ConfirmationDialog;

    layout
    {
        area(content)
        {
            label(Control19)
            {
                ApplicationArea = Basic,Suite;
                CaptionClass = FORMAT(Text002);
                Editable = false;
            }
            field(VoidDate;VoidDate)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Void Date';
                ToolTip = 'Specifies the date that the void entry will be posted regardless of the void type that is selected. All of the unapply postings will also use the Void Date, if the Unapply and Void Check type is selected.';

                trigger OnValidate()
                begin
                    if VoidDate < CheckLedgerEntry."Check Date" then
                      Error(Text000,CheckLedgerEntry.FieldCaption("Check Date"));
                end;
            }
            field(VoidType;VoidType)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Type of Void';
                OptionCaption = 'Unapply and void check,Void check only';
                ToolTip = 'Specifies how checks are voided. Unapply and Void Check: The payment will be unapplied so that the vendor ledger entry for the invoice will be open, and the payment will be reversed by the voided check. Void Check Only: The vendor ledger entry will still be closed by the payment entry, and the voided check entry will be open.';
            }
            group(Details)
            {
                Caption = 'Details';
                field("CheckLedgerEntry.""Bank Account No.""";CheckLedgerEntry."Bank Account No.")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Bank Account No.';
                    Editable = false;
                    ToolTip = 'Specifies the bank account.';
                }
                field("CheckLedgerEntry.""Check No.""";CheckLedgerEntry."Check No.")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Check No.';
                    Editable = false;
                    ToolTip = 'Specifies the check number to be voided.';
                }
                field("CheckLedgerEntry.""Bal. Account No.""";CheckLedgerEntry."Bal. Account No.")
                {
                    ApplicationArea = Basic,Suite;
                    CaptionClass = FORMAT(STRSUBSTNO(Text001,CheckLedgerEntry."Bal. Account Type"));
                    Editable = false;
                }
                field("CheckLedgerEntry.Amount";CheckLedgerEntry.Amount)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Amount';
                    Editable = false;
                    ToolTip = 'Specifies the amount to be voided.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        CurrPage.LookupMode := true;
    end;

    trigger OnOpenPage()
    begin
        with CheckLedgerEntry do begin
          VoidDate := "Check Date";
          if "Bal. Account Type" in ["bal. account type"::Vendor,"bal. account type"::Customer] then
            VoidType := Voidtype::"Unapply and void check"
          else
            VoidType := Voidtype::"Void check only";
        end;
    end;

    var
        CheckLedgerEntry: Record "Check Ledger Entry";
        VoidDate: Date;
        VoidType: Option "Unapply and void check","Void check only";
        Text000: label 'Void Date must not be before the original %1.';
        Text001: label '%1 No.';
        Text002: label 'Do you want to void this check?';


    procedure SetCheckLedgerEntry(var NewCheckLedgerEntry: Record "Check Ledger Entry")
    begin
        CheckLedgerEntry := NewCheckLedgerEntry;
    end;


    procedure GetVoidDate(): Date
    begin
        exit(VoidDate);
    end;


    procedure GetVoidType(): Integer
    begin
        exit(VoidType);
    end;


    procedure InitializeRequest(VoidCheckdate: Date;VoiceCheckType: Option)
    begin
        VoidDate := VoidCheckdate;
        VoidType := VoiceCheckType;
    end;
}

