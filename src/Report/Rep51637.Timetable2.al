#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51637 "Time table2"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Time table2.rdlc';

    dataset
    {
        dataitem(UnknownTable61540;UnknownTable61540)
        {
            column(ReportForNavId_1; 1)
            {
            }
            column(Department;"ACA-Time Table".DPTNM)
            {
            }
            column(Programme;"ACA-Time Table".progname)
            {
            }
            column(Stage;"ACA-Time Table".Stage)
            {
            }
            column(Day;"ACA-Time Table"."Day of Week")
            {
            }
            column(Time;"ACA-Time Table".Period)
            {
            }
            column(UnitCode;"ACA-Time Table".Unit)
            {
            }
            column(Description;"ACA-Time Table".unitNm)
            {
            }
            column(Venue;"ACA-Time Table"."Lecture Room")
            {
            }
            column(Lecturer;"ACA-Time Table".LecturerNM)
            {
            }
            column(Daycode;"ACA-Time Table"."Day of Week")
            {
            }
            column(pic;info.Picture)
            {
            }
            column(Companyname;info.Name)
            {
            }
            column(college;info."Name 2")
            {
            }
            column(campus;"ACA-Time Table"."Campus Code")
            {
            }
            column(Session;"ACA-Time Table".semNM)
            {
            }
            column(dep;dpt)
            {
            }

            trigger OnAfterGetRecord()
            begin
                     info.Reset;
                     if info.Find('-') then
                    info.CalcFields(Picture);

                     dpt:=UpperCase("ACA-Time Table".DPTNM);
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
        info: Record "Company Information";
        dpt: Text[200];
        UnitRec: Record UnknownRecord61517;
        Un: Code[100];
}

