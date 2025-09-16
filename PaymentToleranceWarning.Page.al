#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 591 "Payment Tolerance Warning"
{
    Caption = 'Payment Tolerance Warning';
    InstructionalText = 'An action is requested regarding the Payment Tolerance Warning.';
    PageType = ConfirmationDialog;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            field(Posting;Posting)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Regarding the Balance amount, do you want to:';
                OptionCaption = ',Post the Balance as Payment Tolerance?,Leave a Remaining Amount?';
            }
            group(Details)
            {
                Caption = 'Details';
                InstructionalText = 'Posting this application will create an outstanding balance. You can close all entries by posting the balance as a payment tolerance amount.';
                field(PostingDate;PostingDate)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Posting Date';
                    Editable = false;
                    ToolTip = 'Specifies the posting date of the document to be paid.';
                }
                field(CustVendNo;CustVendNo)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'No';
                    Editable = false;
                    ToolTip = 'Specifies the number of the record that the payment tolerance warning refers to.';
                }
                field(DocNo;DocNo)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Document No.';
                    Editable = false;
                    ToolTip = 'Specifies the document that the payment is for.';
                }
                field(CurrencyCode;CurrencyCode)
                {
                    ApplicationArea = Suite;
                    Caption = 'Currency Code';
                    Editable = false;
                    ToolTip = 'Specifies the code for the currency that amounts are shown in.';
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Amount';
                    Editable = false;
                    ToolTip = 'Specifies the amount that the payment tolerance warning refers to.';
                }
                field(AppliedAmount;AppliedAmount)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Applied Amount';
                    Editable = false;
                    ToolTip = 'Specifies the applied amount that the payment tolerance warning refers to.';
                }
                field(BalanceAmount;BalanceAmount)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Balance';
                    Editable = false;
                    ToolTip = 'Specifies the payment amount that the customer owes for completed sales.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        Posting := Posting::"Remaining Amount";

        if BalanceAmount = 0 then
          BalanceAmount := Amount + AppliedAmount;
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        if CloseAction = Action::No then
          NoOnPush;
        if CloseAction = Action::Yes then
          YesOnPush;
    end;

    var
        PostingDate: Date;
        CustVendNo: Code[20];
        DocNo: Code[20];
        CurrencyCode: Code[10];
        Amount: Decimal;
        AppliedAmount: Decimal;
        BalanceAmount: Decimal;
        Posting: Option " ","Payment Tolerance Accounts","Remaining Amount";
        NewPostingAction: Integer;


    procedure SetValues(ShowPostingDate: Date;ShowCustVendNo: Code[20];ShowDocNo: Code[20];ShowCurrencyCode: Code[10];ShowAmount: Decimal;ShowAppliedAmount: Decimal;ShowBalance: Decimal)
    begin
        PostingDate := ShowPostingDate;
        CustVendNo := ShowCustVendNo;
        DocNo := ShowDocNo;
        CurrencyCode := ShowCurrencyCode;
        Amount := ShowAmount;
        AppliedAmount := ShowAppliedAmount;
        BalanceAmount := ShowBalance;
    end;


    procedure GetValues(var PostingAction: Integer)
    begin
        PostingAction := NewPostingAction
    end;

    local procedure YesOnPush()
    begin
        if Posting = Posting::"Payment Tolerance Accounts" then
          NewPostingAction := 1
        else
          if Posting = Posting::"Remaining Amount" then
            NewPostingAction := 2;
    end;

    local procedure NoOnPush()
    begin
        NewPostingAction := 3;
    end;


    procedure InitializeOption(OptionValue: Integer)
    begin
        NewPostingAction := OptionValue;
    end;
}

