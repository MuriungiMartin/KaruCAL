#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 1086 "Job Calculate WIP"
{
    Caption = 'Job Calculate WIP';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem(Job;Job)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.","Planning Date Filter","Posting Date Filter";
            column(ReportForNavId_8019; 8019)
            {
            }

            trigger OnAfterGetRecord()
            var
                JobCalculateWIP: Codeunit "Job Calculate WIP";
            begin
                JobCalculateWIP.JobCalcWIP(Job,PostingDate,DocNo);
                CalcFields("WIP Warnings");
                WIPPostedWithWarnings := WIPPostedWithWarnings or "WIP Warnings";
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
                    field(PostingDate;PostingDate)
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Posting Date';
                        ToolTip = 'Specifies the posting date for the document.';
                    }
                    field(DocumentNo;DocNo)
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Document No.';
                        ToolTip = 'Specifies the number of a document that the calculation will apply to.';
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

            JobsSetup.Get;

            JobsSetup.TestField("Job Nos.");
            NoSeriesMgt.InitSeries(JobsSetup."Job WIP Nos.",JobsSetup."Job WIP Nos.",0D,DocNo,NewNoSeriesCode);
        end;
    }

    labels
    {
    }

    trigger OnPostReport()
    var
        WIPPosted: Boolean;
        WIPQst: Text;
    begin
        JobWIPEntry.SetCurrentkey("Job No.");
        JobWIPEntry.SetFilter("Job No.",Job.GetFilter("No."));
        WIPPosted := JobWIPEntry.FindFirst;
        Commit;

        if WIPPosted then begin
          if WIPPostedWithWarnings then
            Message(Text002)
          else
            Message(Text000);
          if Dialog.Confirm(PreviewQst) then begin
            JobWIPEntry.SetRange("Job No.",Job."No.");
            Page.RunModal(Page::"Job WIP Entries",JobWIPEntry);

            WIPQst := StrSubstNo(RunWIPFunctionsQst,'Job Post WIP to G/L');
            if Dialog.Confirm(WIPQst) then
              Report.Run(Report::"Job Post WIP to G/L",false,false,Job)
            else
              Report.RunModal(Report::"Job Post WIP to G/L",true,false,Job);
          end;
        end else
          Message(Text001);
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
        JobWIPEntry: Record "Job WIP Entry";
        JobsSetup: Record "Jobs Setup";
        JobCalculateBatches: Codeunit "Job Calculate Batches";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        PostingDate: Date;
        DocNo: Code[20];
        Text000: label 'WIP was successfully calculated.';
        Text001: label 'There were no new WIP entries created.';
        Text002: label 'WIP was calculated with warnings.';
        WIPPostedWithWarnings: Boolean;
        PreviewQst: label 'Do you want to preview the posting accounts?';
        RunWIPFunctionsQst: label 'You must run the %1 function to post the completion entries for this job. \Do you want to run this function now?', Comment='%1 = The name of the Job Post WIP to G/L report';


    procedure InitializeRequest()
    begin
        PostingDate := WorkDate;
    end;
}

