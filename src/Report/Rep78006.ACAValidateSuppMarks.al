#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 78006 "ACA-Validate Supp. Marks"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(UnknownTable78003;UnknownTable78003)
        {
            column(ReportForNavId_1; 1)
            {
            }

            trigger OnAfterGetRecord()
            begin
                   progress.Update(1,"Aca-Special Exams Results"."Student No.");
                  progress.Update(2,"Aca-Special Exams Results".Unit);
                    "Aca-Special Exams Results".Validate("Aca-Special Exams Results".Score);
                    "Aca-Special Exams Results".Modify;
            end;

            trigger OnPreDataItem()
            begin
                //"ACA-Exam Results".SETRANGE("ACA-Exam Results"."User Name",UserID);
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
         progress.Close;
    end;

    trigger OnPreReport()
    begin
        progress.Open('Processing 5 of 7. \A minute please......\No.: #1########################################\Unit: #2########################################');
    end;

    var
        progress: Dialog;
}

