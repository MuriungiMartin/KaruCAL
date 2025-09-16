#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1230 "SEPA Direct Debit Mandates"
{
    Caption = 'SEPA Direct Debit Mandates';
    DataCaptionFields = ID,"Customer No.","Customer Bank Account Code";
    PageType = List;
    SourceTable = "SEPA Direct Debit Mandate";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(ID;ID)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the ID of the direct-debit mandate.';
                }
                field("Customer No.";"Customer No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the customer that the direct-debit mandate is activated for.';
                    Visible = false;
                }
                field("Customer Bank Account Code";"Customer Bank Account Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies customer bank account that the direct-debit mandate is activated for.';
                }
                field("Valid From";"Valid From")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the date when the direct-debit mandate starts.';
                }
                field("Valid To";"Valid To")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the date when the direct-debit mandate ends.';
                }
                field("Date of Signature";"Date of Signature")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies when the direct-debit mandate was signed by the customer.';
                }
                field("Type of Payment";"Type of Payment")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies if the direct-debit transaction is the first or the last according to the expected number of direct-debit transactions that you entered in the Expected Number of Debits field.';
                }
                field("Expected Number of Debits";"Expected Number of Debits")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies how many direct-debit transactions you expect to perform using the direct-debit mandate. This field is used to calculate when to enter First or Last in the Sequence Type field in the Direct Debit Collect. Entries window.';
                }
                field("Debit Counter";"Debit Counter")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    ToolTip = 'Specifies how many direct-debit transactions have been performed using the direct-debit mandate.';
                }
                field(Blocked;Blocked)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies that the direct-debit mandate is blocked and cannot be used to process direct debit collections. For example, you can block a direct-debit mandate because the customer is declared insolvent.';
                }
                field(Closed;Closed)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies that the direct-debit mandate is closed, for example because the date in the Valid To field has been exceeded.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control14;Links)
            {
            }
            systempart(Control15;Notes)
            {
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        if "Customer No." = '' then
          if GetFilter("Customer No.") <> '' then
            Validate("Customer No.",GetRangeMin("Customer No."));
        if "Customer Bank Account Code" = '' then
          if GetFilter("Customer Bank Account Code") <> '' then
            Validate("Customer Bank Account Code",GetRangeMin("Customer Bank Account Code"));
    end;
}

