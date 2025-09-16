#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51817 "HRM-Salary Increament Register"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HRM-Salary Increament Register.rdlc';

    dataset
    {
        dataitem(UnknownTable61791;UnknownTable61791)
        {
            column(ReportForNavId_1; 1)
            {
            }
            column(Schedule;'Salary Increament Schedule')
            {
            }
            column(EmployeeNo;"HRM-Salary Increament Register"."Employee No.")
            {
            }
            column(IncreamentMonth;"HRM-Salary Increament Register"."Increament Month")
            {
            }
            column(IncreamentYear;"HRM-Salary Increament Register"."Increament Year")
            {
            }
            column(PreviousBasic;"HRM-Salary Increament Register"."Prev. Salary")
            {
            }
            column(ExpectedBasic;"HRM-Salary Increament Register"."Current Salary")
            {
            }
            column(JobCategory;"HRM-Salary Increament Register"."Job Category")
            {
            }
            column(JobGrade;"HRM-Salary Increament Register"."Job Grade")
            {
            }
            column(Posted;"HRM-Salary Increament Register".Posted)
            {
            }
            column(Reversed;"HRM-Salary Increament Register".Reversed)
            {
            }
            column(Names;names)
            {
            }

            trigger OnAfterGetRecord()
            begin
                  Clear(names);
                  if emps.Get("HRM-Salary Increament Register"."Employee No.") then begin
                  names:=emps."First Name"+' '+emps."Middle Name"+' '+emps."Last Name";
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
        names: Text;
        emps: Record UnknownRecord61118;
}

