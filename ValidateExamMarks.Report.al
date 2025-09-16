#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51149 "Validate Exam Marks"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(UnknownTable61548;UnknownTable61548)
        {
            column(ReportForNavId_1; 1)
            {
            }
            column(No;"ACA-Exam Results"."Student No.")
            {
            }
            column(Prog;"ACA-Exam Results".Programme)
            {
            }
            column(Stage;"ACA-Exam Results".Stage)
            {
            }
            column(Unit;"ACA-Exam Results".Unit)
            {
            }
            column(Semester;"ACA-Exam Results".Semester)
            {
            }
            column(Trans;"ACA-Exam Results"."Reg. Transaction ID")
            {
            }
            column(Score;"ACA-Exam Results".Score)
            {
            }
            column(Contrib;"ACA-Exam Results".Contribution)
            {
            }
            column(Grade;"ACA-Exam Results".Grade)
            {
            }

            trigger OnAfterGetRecord()
            begin
                  progress.Update(1,"ACA-Exam Results"."Student No.");
                  progress.Update(2,"ACA-Exam Results".Unit);
                    Validate("ACA-Exam Results".Score);
                    Modify;
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
         progress.Open('Processing 3 of 7.\A minute please......\No.: #1########################################\Unit.: #2########################################');
    end;

    var
        progress: Dialog;
}

