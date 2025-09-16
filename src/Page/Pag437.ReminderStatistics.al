#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 437 "Reminder Statistics"
{
    Caption = 'Reminder Statistics';
    Editable = false;
    LinksAllowed = false;
    PageType = Card;
    SourceTable = "Reminder Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Remaining Amount";"Remaining Amount")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    ToolTip = 'Specifies the total of the remaining amounts on the reminder lines.';
                }
                field(Interest;Interest)
                {
                    ApplicationArea = Basic;
                    Caption = 'Interest Amount';
                    DrillDown = false;
                }
                field("Additional Fee";"Additional Fee")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    ToolTip = 'Specifies the total of the additional fee amounts on the reminder lines.';
                }
                field(VatAmount;VatAmount)
                {
                    ApplicationArea = Basic;
                    Caption = 'Tax Amount';
                    DrillDown = false;
                }
                field("Add. Fee per Line";"Add. Fee per Line")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                }
                field(ReminderTotal;ReminderTotal)
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    Caption = 'Total';
                }
            }
            group(Customer)
            {
                Caption = 'Customer';
                field("Cust.""Balance (LCY)""";Cust."Balance (LCY)")
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Balance ($)';
                }
                field("Cust.""Credit Limit (LCY)""";Cust."Credit Limit (LCY)")
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Credit Limit ($)';
                }
                field(CreditLimitLCYExpendedPct;CreditLimitLCYExpendedPct)
                {
                    ApplicationArea = Basic;
                    Caption = 'Expended % of Credit Limit ($)';
                    ExtendedDatatype = Ratio;
                    ToolTip = 'Specifies the expended percentage of the credit limit in ($).';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    var
        CustPostingGr: Record "Customer Posting Group";
        GLAcc: Record "G/L Account";
        VATPostingSetup: Record "VAT Posting Setup";
        ReminderLevel: Record "Reminder Level";
        VATInterest: Decimal;
    begin
        CalcFields("Interest Amount","VAT Amount","Add. Fee per Line");
        ReminderTotal := "Remaining Amount" + "Additional Fee" + "Interest Amount" + "VAT Amount" + "Add. Fee per Line";
        VatAmount := "VAT Amount";
        CustPostingGr.Get("Customer Posting Group");
        VATInterest := 0;
        if ReminderLevel.Get("Reminder Terms Code","Reminder Level") then
          if ReminderLevel."Calculate Interest" and ("VAT Amount" <> 0) then begin
            GLAcc.Get(CustPostingGr."Interest Account");
            VATPostingSetup.Get("VAT Bus. Posting Group",GLAcc."VAT Prod. Posting Group");
            VATInterest := VATPostingSetup."VAT %";
            if GLAcc.Get(CustPostingGr."Additional Fee Account") then
              VATPostingSetup.Get("VAT Bus. Posting Group",GLAcc."VAT Prod. Posting Group");
            Interest :=
              (ReminderTotal -
               "Remaining Amount" - ("Additional Fee" + "Add. Fee per Line") * (VATPostingSetup."VAT %" / 100 + 1)) /
              (VATInterest / 100 + 1);
            VatAmount := Interest * VATInterest / 100 + "Additional Fee" * VATPostingSetup."VAT %" / 100 + CalculateLineFeeVATAmount;
          end else
            Interest := "Interest Amount";

        if Cust.Get("Customer No.") then
          Cust.CalcFields("Balance (LCY)")
        else
          Clear(Cust);
        if Cust."Credit Limit (LCY)" = 0 then
          CreditLimitLCYExpendedPct := 0
        else
          CreditLimitLCYExpendedPct := ROUND(Cust."Balance (LCY)" / Cust."Credit Limit (LCY)" * 10000,1);
    end;

    var
        Cust: Record Customer;
        ReminderTotal: Decimal;
        CreditLimitLCYExpendedPct: Decimal;
        Interest: Decimal;
        VatAmount: Decimal;
}

