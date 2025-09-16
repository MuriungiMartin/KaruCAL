#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 50129 "HR Employee Development Plans"
{

    trigger OnRun()
    begin
    end;

    var
        DevelopmentPlanTable: Record UnknownRecord61232;
        Found: Boolean;
        OK: Boolean;
        EmployeeSkillsPlan: Record UnknownRecord61234;


    procedure GetDevPlan(DevPlanCode: Code[10];EmpNo: Code[20];Year: Integer)
    begin

                  DevelopmentPlanTable.SetRange("Appraisal No",DevPlanCode);
                  OK :=DevelopmentPlanTable.Find('-');
                  if OK then begin
                    repeat
                         EmployeeSkillsPlan.Init;
                         EmployeeSkillsPlan."Member No.":= EmpNo;
                         EmployeeSkillsPlan."Member Name":= DevPlanCode;
                         EmployeeSkillsPlan."Primary Skills Category":= DevelopmentPlanTable."Overal Rating Desc";
                         EmployeeSkillsPlan."Accreditation Status":= DevelopmentPlanTable."SuperVisor Email";
                         EmployeeSkillsPlan.Role:= DevelopmentPlanTable.Supervisor;
                         EmployeeSkillsPlan."Objective Of Intervention":= DevelopmentPlanTable."Appraisal Type";
                         EmployeeSkillsPlan.Institution:= DevelopmentPlanTable."Appraisal Period";
                         EmployeeSkillsPlan."Scheduled Year":= Year;
                         EmployeeSkillsPlan."NQF Course Title":= DevelopmentPlanTable.Status;
                         EmployeeSkillsPlan."NQF Level":= DevelopmentPlanTable.Recommendations;
                         EmployeeSkillsPlan."Date Appointed":= DevelopmentPlanTable."No Series";
                         EmployeeSkillsPlan.Grade:= DevelopmentPlanTable."Appraisal Stage";
                         EmployeeSkillsPlan.Active:= DevelopmentPlanTable.Sent;
                         EmployeeSkillsPlan.Committee:= DevelopmentPlanTable."User ID";
                         EmployeeSkillsPlan."Member type":= DevelopmentPlanTable.Picture;
                         EmployeeSkillsPlan.Insert;
                     until DevelopmentPlanTable.Next = 0;
                    end;
                   DevelopmentPlanTable.SetRange("Appraisal No");
    end;
}

