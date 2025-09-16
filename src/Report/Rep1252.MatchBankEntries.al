#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 1252 "Match Bank Entries"
{
    Caption = 'Match Bank Entries';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Bank Acc. Reconciliation";"Bank Acc. Reconciliation")
        {
            DataItemTableView = sorting("Bank Account No.","Statement No.");
            column(ReportForNavId_1; 1)
            {
            }

            trigger OnAfterGetRecord()
            begin
                MatchSingle(DateRange);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Control3)
                {
                    field(DateRange;DateRange)
                    {
                        ApplicationArea = Basic,Suite;
                        BlankZero = true;
                        Caption = 'Transaction Date Tolerance (Days)';
                        MinValue = 0;
                        ToolTip = 'Specifies the span of days before and after the bank account ledger entry posting date within which the function will search for matching transaction dates in the bank statement. If you enter 0 or leave the field blank, then the Match Automatically function will only search for matching transaction dates on the bank account ledger entry posting date.';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        DateRange: Integer;
}

