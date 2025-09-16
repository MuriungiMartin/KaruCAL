#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 61842 "Update CourseReg"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Update CourseReg.rdlc';

    dataset
    {
        dataitem(StudBack;UnknownTable61841)
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Clear(Counted);
                ACACourseRegistration.Reset;
                ACACourseRegistration.SetRange(ACACourseRegistration."Student No.",StudBack."Student No.");
                ACACourseRegistration.SetRange(ACACourseRegistration.Semester,'SEM2 19/20');
                if ACACourseRegistration.Find('-') then begin
                  repeat
                    begin
                  Counted:=Counted+1;
                  if Counted>1 then begin
                    ACACourseRegistration.Delete;
                    end;
                  end;
                  until ACACourseRegistration.Next=0;
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
        ACACourseRegistration: Record UnknownRecord61532;
        Counted: Integer;
}

