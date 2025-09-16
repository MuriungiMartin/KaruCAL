#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51782 Process
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(Customer;Customer)
        {
            column(ReportForNavId_1; 1)
            {
            }

            trigger OnAfterGetRecord()
            begin
                 /* IF COPYSTR("Student Data Buffer"."Stud. No.",1,3)='MBA' THEN BEGIN
                  "Student Data Buffer"."Stud. No.":='MUC-'+"Student Data Buffer"."Stud. No.";
                  "Student Data Buffer".MODIFY;
                  END;     */
                  if Gender>0 then begin
                    Gender:=Gender-1;
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
}

