#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 1085 "Job Post WIP to G/L"
{
    Caption = 'Job Post WIP to G/L';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem(Job;Job)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            column(ReportForNavId_8019; 8019)
            {
            }

            trigger OnAfterGetRecord()
            begin
                JobCalculateWIP.CalcGLWIP("No.",JustReverse,DocNo,PostingDate,ReplacePostDate);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(ReversalPostingDate;PostingDate)
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Reversal Posting Date';
                        ToolTip = 'Specifies the posting date for the general ledger entries that are posted by this function.';
                    }
                    field(ReversalDocumentNo;DocNo)
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Reversal Document No.';
                        ToolTip = 'Specifies a document number for the general ledger entries that are posted by this function.';
                    }
                    field(ReverseOnly;JustReverse)
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Reverse Only';
                        ToolTip = 'Specifies that you want to reverse previously posted WIP, but not to post new WIP to the general ledger. This is useful, for example, when you have calculated and posted WIP for a job with an incorrect date and want to reverse the incorrect postings without posting new WIP entries.';
                    }
                    field(UseReversalDate;ReplacePostDate)
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Use Reversal Date';
                        ToolTip = 'Specifies if you want to use the reversal date as the posting date for both the reversal of the previous WIP calculation and the posting date for the new WIP calculation. This is useful when you want to calculate and post the historical WIP for a period that is already closed. You can reverse the old postings and post the new calculation in an open period by choosing a reversal date in the open period.';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        var
            NewNoSeriesCode: Code[10];
        begin
            if PostingDate = 0D then
              PostingDate := WorkDate;
            DocNo := '';

            JobsSetup.Get;

            JobsSetup.TestField("Job Nos.");
            NoSeriesMgt.InitSeries(JobsSetup."Job WIP Nos.",JobsSetup."Job WIP Nos.",0D,DocNo,NewNoSeriesCode);

            ReplacePostDate := false;
            JustReverse := false;
        end;
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        Commit;
        Message(WIPSuccessfullyPostedMsg);
    end;

    trigger OnPreReport()
    var
        NewNoSeriesCode: Code[10];
    begin
        JobsSetup.Get;

        if DocNo = '' then begin
          JobsSetup.TestField("Job Nos.");
          NoSeriesMgt.InitSeries(JobsSetup."Job WIP Nos.",JobsSetup."Job WIP Nos.",0D,DocNo,NewNoSeriesCode);
        end;

        if PostingDate = 0D then
          PostingDate := WorkDate;

        JobCalculateBatches.BatchError(PostingDate,DocNo);
    end;

    var
        JobsSetup: Record "Jobs Setup";
        JobCalculateWIP: Codeunit "Job Calculate WIP";
        JobCalculateBatches: Codeunit "Job Calculate Batches";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        PostingDate: Date;
        DocNo: Code[20];
        JustReverse: Boolean;
        WIPSuccessfullyPostedMsg: label 'WIP was successfully posted to G/L.';
        ReplacePostDate: Boolean;


    procedure InitializeRequest(NewDocNo: Code[20])
    begin
        DocNo := NewDocNo;
        PostingDate := WorkDate
    end;
}

