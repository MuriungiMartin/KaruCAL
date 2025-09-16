#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1251 "Text-to-Account Mapping"
{
    AutoSplitKey = true;
    Caption = 'Text-to-Account Mapping';
    PageType = List;
    SaveValues = true;
    SourceTable = "Text-to-Account Mapping";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Mapping Text";"Mapping Text")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the text on the payment that is used to map the payment to a customer, vendor, or general ledger account when you choose the Apply Automatically function in the Payment Reconciliation Journal window.';
                }
                field("Debit Acc. No.";"Debit Acc. No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the debit account that payments with this text-to-account mapping are matched with when you choose the Apply Automatically function in the Payment Reconciliation Journal window.';
                }
                field("Credit Acc. No.";"Credit Acc. No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the credit account that payments with this text-to-account mapping are applied to when you choose the Apply Automatically function in the Payment Reconciliation Journal window.';
                }
                field("Bal. Source Type";"Bal. Source Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the type of balancing account that payments or incoming document records with this text-to-account mapping are created for. The Bank Account option is used for incoming documents only.';

                    trigger OnValidate()
                    begin
                        EnableBalSourceNo := IsBalSourceNoEnabled;
                    end;
                }
                field("Bal. Source No.";"Bal. Source No.")
                {
                    ApplicationArea = Basic,Suite;
                    Enabled = EnableBalSourceNo;
                    ToolTip = 'Specifies the balancing account in the general ledger or on bank accounts that payments or incoming document records with this text-to-account mapping are created for.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
        EnableBalSourceNo := IsBalSourceNoEnabled;
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        exit(CheckEntriesAreConsistent);
    end;

    var
        EnableBalSourceNo: Boolean;
}

