#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 78071 "Update Rubrics for Supp."
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(Rubrics;UnknownTable61739)
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                  Rubrics."Supp. Status Msg1":=Rubrics."Status Msg1";
                  Rubrics."Supp. Status Msg2":=Rubrics."Status Msg2";
                  Rubrics."Supp. Status Msg3":=Rubrics."Status Msg3";
                  Rubrics."Supp. Status Msg4":=Rubrics."Status Msg4";
                  Rubrics."Supp. Status Msg5":=Rubrics."Status Msg5";
                  Rubrics.Modify;
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
}

