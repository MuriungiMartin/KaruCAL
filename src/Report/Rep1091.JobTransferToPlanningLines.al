#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 1091 "Job Transfer To Planning Lines"
{
    Caption = 'Job Transfer To Planning Lines';
    ProcessingOnly = true;

    dataset
    {
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(TransferTo;LineType)
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Transfer To';
                        OptionCaption = 'Budget,Billable,Both Budget and Billable';
                        ToolTip = 'Specifies the type of planning lines that should be created.';
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

    trigger OnPreReport()
    begin
        JobCalcBatches.TransferToPlanningLine(JobLedgEntry,LineType + 1);
    end;

    var
        JobLedgEntry: Record "Job Ledger Entry";
        JobCalcBatches: Codeunit "Job Calculate Batches";
        LineType: Option Budget,Billable,"Both Budget and Billable";


    procedure GetJobLedgEntry(var JobLedgEntry2: Record "Job Ledger Entry")
    begin
        JobLedgEntry.Copy(JobLedgEntry2);
    end;
}

