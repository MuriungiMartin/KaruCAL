#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 1093 "Job Create Sales Invoice"
{
    Caption = 'Job Create Sales Invoice';
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
                JobCreateInvoice.CreateSalesInvoiceJT(
                  "Job Task",PostingDate,InvoicePerTask,NoOfInvoices,OldJobNo,OldJTNo,false);
            end;

            trigger OnPostDataItem()
            begin
                JobCreateInvoice.CreateSalesInvoiceJT(
                  "Job Task",PostingDate,InvoicePerTask,NoOfInvoices,OldJobNo,OldJTNo,true);
            end;

            trigger OnPreDataItem()
            begin
                NoOfInvoices := 0;
                OldJobNo := '';
                OldJTNo := '';
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
                    field(JobChoice;JobChoice)
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Create Invoice per';
                        OptionCaption = 'Job,Job Task';
                        ToolTip = 'Specifies, if you select the Job Task option, that you want to create one invoice per job task rather than the one invoice per job that is created by default.';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            PostingDate := WorkDate;
        end;
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        JobCalcBatches.EndCreateInvoice(NoOfInvoices);
    end;

    trigger OnPreReport()
    begin
        JobCalcBatches.BatchError(PostingDate,Text000);
        InvoicePerTask := JobChoice = Jobchoice::"Job Task";
        JobCreateInvoice.DeleteSalesInvoiceBuffer;
    end;

    var
        JobCreateInvoice: Codeunit "Job Create-Invoice";
        JobCalcBatches: Codeunit "Job Calculate Batches";
        PostingDate: Date;
        NoOfInvoices: Integer;
        InvoicePerTask: Boolean;
        JobChoice: Option Job,"Job Task";
        OldJobNo: Code[20];
        OldJTNo: Code[20];
        Text000: label 'A', Comment='A';
}

