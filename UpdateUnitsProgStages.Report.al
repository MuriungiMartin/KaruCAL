#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51461 "Update Units Prog/Stages"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(Progs;UnknownTable61511)
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            dataitem(ProgUnits;UnknownTable61517)
            {
                DataItemLink = "Programme Code"=field(Code);
                DataItemTableView = where("Default Exam Category"=filter(""));
                RequestFilterFields = "Programme Code","Stage Code";
                column(ReportForNavId_2955; 2955)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    ProgUnits."Exam Category":=Progs."Exam Category";
                    ProgUnits."Default Exam Category":=Progs."Exam Category";
                    ProgUnits.Modify;
                end;
            }
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
        Units_SubjectsCaptionLbl: label 'Units/Subjects';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

