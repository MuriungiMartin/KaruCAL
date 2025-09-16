#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 78094 "Transfer Archived Results"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(UnknownTable77216;UnknownTable77216)
        {
            RequestFilterFields = "Student No.","Academic Year",Semester,Stage;
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                ExamResults.Init;
                ExamResults.TransferFields("ACA-Exam Results Audit");
                ExamResults.Insert(true);
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

    var
        ExamResults: Record UnknownRecord61548;
}

