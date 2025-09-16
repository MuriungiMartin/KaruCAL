#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51868 "Phamancy History Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Phamancy History Report.rdlc';

    dataset
    {
        dataitem(UnknownTable61407;UnknownTable61407)
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(Treatment_No;"HMS-Treatment Form Header"."Treatment No.")
            {
            }
            column(Treatmen_Type;"HMS-Treatment Form Header"."Treatment Type")
            {
            }
            column(Treatment_Date;"HMS-Treatment Form Header"."Treatment Date")
            {
            }
            column(Doctor_ID;"HMS-Treatment Form Header"."Doctor ID")
            {
            }
            column(Patient_No;"HMS-Treatment Form Header"."Patient No.")
            {
            }
            column(Student_No;"HMS-Treatment Form Header"."Student No.")
            {
            }
            column(Employee_No;"HMS-Treatment Form Header"."Employee No.")
            {
            }
            column(Relative_No;"HMS-Treatment Form Header"."Relative No.")
            {
            }
            column(Treatment_Remarks;"HMS-Treatment Form Header"."Treatment Remarks")
            {
            }
            column(Status;"HMS-Treatment Form Header".Status)
            {
            }
            column(Treatment_Location;"HMS-Treatment Form Header"."Treatment Location")
            {
            }
            column(Pharmacy_Status;"HMS-Treatment Form Header"."Pharmacy Status")
            {
            }
            column(Patient;"HMS-Treatment Form Header"."Patient Type")
            {
            }
            column(Surname;"HMS-Treatment Form Header".Surname)
            {
            }
            column(Middle_Name;"HMS-Treatment Form Header"."Middle Name")
            {
            }
            column(Last_Name;"HMS-Treatment Form Header"."Last Name")
            {
            }
            column(Log;comp.Picture)
            {
            }
            column(CompName;comp.Name)
            {
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

    trigger OnInitReport()
    begin
        comp.Reset;
        if comp.FindFirst then begin
          comp.CalcFields(Picture);
        end;
    end;

    var
        comp: Record "Company Information";
}

