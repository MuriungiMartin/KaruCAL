#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1027 "Job WIP Cockpit"
{
    ApplicationArea = Basic;
    Caption = 'Job WIP Cockpit';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Define,Analyze';
    SourceTable = Job;
    SourceTableView = where(Status=filter(Open|Completed),
                            "WIP Completion Posted"=const(false));
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            repeater(Jobs)
            {
                FreezeColumn = Description;
                field("No.";"No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the number for the job. You can use one of the following methods to fill in the number:';
                }
                field(Description;Description)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies a short description of the job.';
                }
                field("WIP Warnings";"WIP Warnings")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies whether or not there are WIP warnings associated with a job.';
                }
                field("Recog. Costs Amount";"Recog. Costs Amount")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the Recognized Cost amount that was last calculated for the job. The Recognized Cost Amount for the job is the sum of the Recognized Cost Job WIP Entries.';
                }
                field("Recog. Costs G/L Amount";"Recog. Costs G/L Amount")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the total Recognized Cost amount that was last posted to the general ledger for the job. The Recognized Cost G/L amount for the job is the sum of the Recognized Cost Job WIP G/L Entries.';
                }
                field("Recog. Sales Amount";"Recog. Sales Amount")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the recognized sales amount that was last calculated for the job. The Recog. Sales Amount for the job is the sum of the Recognized Sales Job WIP Entries.';
                }
                field("Recog. Sales G/L Amount";"Recog. Sales G/L Amount")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the total Recognized Sales amount that was last posted to the general ledger for the job. The Recognized Sales G/L amount for the job is the sum of the Recognized Sales Job WIP G/L Entries.';
                }
                field("Recog. Costs Amount Difference";"Recog. Costs Amount" - "Recog. Costs G/L Amount")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Recog. Costs Amount Difference';
                    ToolTip = 'Specifies the difference in recognized costs for the job.';
                }
                field("Recog. Sales Amount Difference";"Recog. Sales Amount" - "Recog. Sales G/L Amount")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Recog. Sales Amount Difference';
                    ToolTip = 'Specifies the difference in recognized sales for the job.';
                }
                field("Recog. Profit Amount";CalcRecognizedProfitAmount)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Recog. Profit Amount';
                    ToolTip = 'Specifies the recognized profit amount for the job.';
                }
                field("Recog. Profit G/L Amount";CalcRecognizedProfitGLAmount)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Recog. Profit G/L Amount';
                    ToolTip = 'Specifies the total recognized profit G/L amount for this job.';
                }
                field("Recog. Profit Amount Difference";CalcRecognizedProfitAmount - CalcRecognizedProfitGLAmount)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Recog. Profit Amount Difference';
                    ToolTip = 'Specifies the difference in recognized profit for the job.';
                }
                field("WIP Posting Date";"WIP Posting Date")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the posting date that was entered when the Job Calculate WIP batch job was last run.';
                }
                field("WIP G/L Posting Date";"WIP G/L Posting Date")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the posting date that was entered when the Job Post WIP to general ledger batch job was last run.';
                }
                field("Total WIP Cost Amount";"Total WIP Cost Amount")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the total WIP cost amount that was last calculated for the job. The WIP Cost Amount for the job is the value WIP Cost Job WIP Entries less the value of the Recognized Cost Job WIP Entries. For jobs with WIP Methods of Sales Value or Percentage of Completion, the WIP Cost Amount is normally 0.';
                }
                field("Total WIP Cost G/L Amount";"Total WIP Cost G/L Amount")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the total WIP Cost amount that was last posted to the G/L for the job. The WIP Cost Amount for the job is the value WIP Cost Job WIP G/L Entries less the value of the Recognized Cost Job WIP G/L Entries. For jobs with WIP Methods of Sales Value or Percentage of Completion, the WIP Cost Amount is normally 0.';
                }
                field("Total WIP Cost Difference";"Total WIP Cost Amount" - "Total WIP Cost G/L Amount")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Total WIP Cost Difference';
                    ToolTip = 'Specifies the difference in total WIP costs.';
                }
                field("Total WIP Sales Amount";"Total WIP Sales Amount")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the total WIP Sales amount that was last calculated for the job. The WIP Sales Amount for the job is the value WIP Sales Job WIP Entries less the value of the Recognized Sales Job WIP Entries. For jobs with WIP Methods of Cost Value or Cost of Sales, the WIP Sales Amount is normally 0.';
                }
                field("Total WIP Sales G/L Amount";"Total WIP Sales G/L Amount")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the total WIP Sales amount that was last posted to the general ledger for the job. The WIP Sales Amount for the job is the value WIP Sales Job WIP G/L Entries less the value of the Recognized Sales Job WIP G/L Entries. For jobs with WIP Methods of Cost Value or Cost of Sales, the WIP Sales Amount is normally 0.';
                }
                field("Total WIP Sales Difference";"Total WIP Sales Amount" - "Total WIP Sales G/L Amount")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Total WIP Sales Difference';
                    ToolTip = 'Specifies the difference in total WIP sales.';
                }
            }
            part(Control28;"Job WIP Totals")
            {
                ApplicationArea = Jobs;
                SubPageLink = "Job No."=field("No."),
                              "Posted to G/L"=const(false);
            }
        }
        area(factboxes)
        {
            part(Control34;"Job WIP/Recognition FactBox")
            {
                ApplicationArea = Jobs;
                SubPageLink = "No."=field("No."),
                              "Planning Date Filter"=field("Planning Date Filter"),
                              "Resource Filter"=field("Resource Filter"),
                              "Posting Date Filter"=field("Posting Date Filter"),
                              "Resource Gr. Filter"=field("Resource Gr. Filter");
                Visible = true;
            }
            systempart(Control6;Links)
            {
                Visible = false;
            }
            systempart(Control5;Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("<Action34>")
            {
                Caption = 'Job';
                Image = Job;
                action(Job)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Job';
                    Image = JobLedger;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page "Job Card";
                    RunPageOnRec = true;
                    ToolTip = 'View or edit detailed information about the job.';
                }
                action("Job Task Lines")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Job Task Lines';
                    Image = TaskList;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page "Job Task Lines";
                    RunPageLink = "Job No."=field("No.");
                    ToolTip = 'Plan how you want to set up your planning information. In this window you can specify the tasks involved in a job. To start planning a job or to post usage for a job, you must set up at least one job task.';
                }
                action("<Action31>")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Ledger E&ntries';
                    Image = JobLedger;
                    Promoted = true;
                    PromotedCategory = Category5;
                    RunObject = Page "Job Ledger Entries";
                    RunPageLink = "Job No."=field("No.");
                    RunPageView = sorting("Job No.","Job Task No.","Entry Type","Posting Date");
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View the history of transactions that have been posted for the selected record.';
                }
                action("<Action30>")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Job Statistics";
                    RunPageLink = "No."=field("No.");
                    ShortCutKey = 'F7';
                    ToolTip = 'View statistical information, such as the value of posted entries, for the record.';
                }
            }
            group("W&IP")
            {
                Caption = 'W&IP';
                Image = WIP;
                action("Show Warnings")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Show Warnings';
                    Image = Find;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'View the warning message for lines where the WIP Warnings check box is selected.';

                    trigger OnAction()
                    var
                        Job: Record Job;
                        JobWIPWarning: Record "Job WIP Warning";
                        TempJobWIPWarning: Record "Job WIP Warning" temporary;
                    begin
                        Job.Copy(Rec);
                        CurrPage.SetSelectionFilter(Job);
                        if Job.FindSet then
                          repeat
                            JobWIPWarning.SetRange("Job No.",Job."No.");
                            if JobWIPWarning.FindSet then
                              repeat
                                TempJobWIPWarning := JobWIPWarning;
                                TempJobWIPWarning.Insert;
                              until JobWIPWarning.Next = 0;
                          until Job.Next = 0;
                        Page.RunModal(Page::"Job WIP Warnings",TempJobWIPWarning);
                    end;
                }
                action("WIP Entries")
                {
                    ApplicationArea = Jobs;
                    Caption = 'WIP Entries';
                    Image = WIPEntries;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    RunObject = Page "Job WIP Entries";
                    RunPageLink = "Job No."=field("No.");
                    RunPageView = sorting("Job No.","Job Posting Group","WIP Posting Date");
                    ToolTip = 'View the job''s WIP entries.';
                }
                action("WIP G/L Entries")
                {
                    ApplicationArea = Jobs;
                    Caption = 'WIP G/L Entries';
                    Image = WIPLedger;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    RunObject = Page "Job WIP G/L Entries";
                    RunPageLink = "Job No."=field("No."),
                                  Reversed=const(false);
                    RunPageView = sorting("Job No.");
                    ToolTip = 'View the job''s WIP G/L entries.';
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Calculate WIP")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Calculate WIP';
                    Ellipsis = true;
                    Image = CalculateWIP;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Use a batch job to help you calculate the value of work in process (WIP) on your jobs.';

                    trigger OnAction()
                    var
                        Job: Record Job;
                    begin
                        TestField("No.");
                        Job.Copy(Rec);
                        Job.SetRange("No.","No.");
                        Report.RunModal(Report::"Job Calculate WIP",true,false,Job);
                    end;
                }
                action("Post WIP to G/L")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Post WIP to G/L';
                    Ellipsis = true;
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Post the job WIP totals to the general ledger.';

                    trigger OnAction()
                    var
                        Job: Record Job;
                    begin
                        TestField("No.");
                        Job.Copy(Rec);
                        Job.SetRange("No.","No.");
                        Report.RunModal(Report::"Job Post WIP to G/L",true,false,Job);
                    end;
                }
                action("<Action37>")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Delete WIP Entries';
                    Image = Delete;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Delete all WIP entries for the selected jobs.';

                    trigger OnAction()
                    var
                        Job: Record Job;
                        JobCalculateWIP: Codeunit "Job Calculate WIP";
                    begin
                        if Confirm(Text001) then begin
                          Job.Copy(Rec);
                          CurrPage.SetSelectionFilter(Job);
                          if Job.FindSet then
                            repeat
                              JobCalculateWIP.DeleteWIP(Job);
                            until Job.Next = 0;

                          Message(Text002);
                        end;
                    end;
                }
                action("<Action38>")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Recalculate WIP';
                    Image = CalculateWIP;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Calculate the work in process again. Every time WIP is calculated, an entry is created in the Job WIP Entries window.';

                    trigger OnAction()
                    var
                        Job: Record Job;
                        JobWIPEntry: Record "Job WIP Entry";
                        JobCalculateWIP: Codeunit "Job Calculate WIP";
                        FailedJobs: Text[1024];
                    begin
                        if Confirm(Text003) then begin
                          Job.Copy(Rec);
                          CurrPage.SetSelectionFilter(Job);
                          if Job.FindSet then
                            repeat
                              JobWIPEntry.SetRange("Job No.",Job."No.");
                              if not JobWIPEntry.FindFirst then
                                FailedJobs := FailedJobs + Job."No." + ', '
                              else
                                JobCalculateWIP.JobCalcWIP(Job,Job."WIP Posting Date",JobWIPEntry."Document No.");
                            until Job.Next = 0;

                          if FailedJobs = '' then
                            Message(Text004)
                          else
                            Message(Text005,DelStr(FailedJobs,StrLen(FailedJobs) - 1,StrLen(FailedJobs)));
                        end;
                    end;
                }
            }
        }
        area(reporting)
        {
            action("<Action32>")
            {
                ApplicationArea = Jobs;
                Caption = 'Job WIP To G/L';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                ToolTip = 'View the value of work in process on the jobs that you select compared to the amount that has been posted in the general ledger.';

                trigger OnAction()
                var
                    Job: Record Job;
                begin
                    TestField("No.");
                    Job.Copy(Rec);
                    Job.SetRange("No.","No.");
                    Report.RunModal(Report::"Job WIP To G/L",true,false,Job);
                end;
            }
        }
    }

    var
        Text001: label 'Are you sure that you want to delete the WIP entries for all selected jobs?';
        Text002: label 'WIP Entries were deleted successfully.';
        Text003: label 'Are you sure that you want to recalculate the WIP entries for all selected jobs?';
        Text004: label 'WIP Entries were recalculated successfully.';
        Text005: label 'The recalculation for the following jobs failed because no WIP entries were found: %1.';
}

