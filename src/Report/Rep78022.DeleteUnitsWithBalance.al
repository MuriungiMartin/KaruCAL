#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 78022 "Delete Units With Balance"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(UnknownTable61532;UnknownTable61532)
        {
            DataItemTableView = where(Semester=filter("SEM2 20/21"|"SEM 2 20/21"),Balance=filter(>0));
            column(ReportForNavId_1000000001; 1000000001)
            {
            }
            dataitem(UnknownTable61549;UnknownTable61549)
            {
                DataItemLink = "Student No."=field("Student No."),Semester=field(Semester);
                column(ReportForNavId_1000000000; 1000000000)
                {
                }

                trigger OnAfterGetRecord()
                begin

                    "ACA-Student Units".Delete;
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
}

