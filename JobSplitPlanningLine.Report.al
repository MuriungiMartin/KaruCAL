#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 1088 "Job Split Planning Line"
{
    Caption = 'Job Split Planning Line';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem("Job Task";"Job Task")
        {
            DataItemTableView = sorting("Job No.","Job Task No.");
            RequestFilterFields = "Job No.","Job Task No.","Planning Date Filter";
            column(ReportForNavId_2969; 2969)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Clear(CalcBatches);
                NoOfLinesSplit += CalcBatches.SplitLines("Job Task");
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        if NoOfLinesSplit <> 0 then begin
          Message(Text000,NoOfLinesSplit);
        end else
          Message(Text001);
    end;

    trigger OnPreReport()
    begin
        NoOfLinesSplit := 0;
    end;

    var
        CalcBatches: Codeunit "Job Calculate Batches";
        NoOfLinesSplit: Integer;
        Text000: label '%1 planning line(s) successfully split.';
        Text001: label 'There were no planning lines to split.';
}

