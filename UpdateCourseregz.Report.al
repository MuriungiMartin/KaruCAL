#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 61841 "Update Course regz."
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Update Course regz..rdlc';

    dataset
    {
        dataitem(Creg;UnknownTable61532)
        {
            DataItemTableView = where(Semester=filter("SEM2 19/20"));
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                StudentNoBackup.Reset;
                StudentNoBackup.SetRange(StudentNoBackup."Student No.",Creg."Student No.");
                if not (StudentNoBackup.Find('-')) then begin
                  StudentNoBackup.Init;
                  StudentNoBackup."Student No.":=Creg."Student No.";
                  StudentNoBackup.Insert;
                end;
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
        StudentNoBackup: Record UnknownRecord61841;
}

