#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 50127 "PM Allowances Year - End"
{

    trigger OnRun()
    begin
             /*  FOUND:= FALSE;
               FIND:= EmployeeAssign.FIND('-');
               IF FIND THEN BEGIN
                REPEAT
                 FOUND:= FALSE;
                 EmployeeNo:= EmployeeAssign."Employee No.";
                 Category:= EmployeeAssign.Category;
                 Description:= EmployeeAssign."Description Code";
                 Preferences.FIND('-');
                 Year:= DATE2DMY(Preferences."Year-Start Date",3);
        
                 IF (Year = EmployeeAssign.Year) AND (EmployeeAssign.Closed = FALSE) THEN BEGIN
                  AbsenceAllowance.SETRANGE("Description Code",Description);
                  OK:= AbsenceAllowance.FIND('-');
                  IF OK THEN BEGIN
                  REPEAT
                   IF (Category = AbsenceAllowance.Category) THEN BEGIN
                       FOUND:= TRUE;
        
                         IF (AbsenceAllowance."Allowance Carry Over") THEN
                            CARRYOVER:= TRUE
                         ELSE
                            CARRYOVER:= FALSE;
        
                   END;
                   UNTIL AbsenceAllowance.NEXT = 0;
        
                  IF FOUND THEN BEGIN
                   IF CARRYOVER THEN BEGIN
                      EmployeeAssign."Carried Over To Next Year":= EmployeeAssign.Remaining;
                      EmployeeAssign.Closed:= TRUE;
                      EmployeeAssign.MODIFY;
                   END ELSE BEGIN
                      EmployeeAssign."Carry Over Lost":= EmployeeAssign.Remaining;
                      EmployeeAssign.Closed:= TRUE;
                      EmployeeAssign.MODIFY;
                   END;
                  END ELSE ERROR ('Recheck The Descriptions And Categories Used In Scheduling Absence Allowances.');
                END;
                END;
                UNTIL EmployeeAssign.NEXT = 0;
               END ELSE ERROR('No Absence Allowances Has Been Assigned To Any Employees!!!');
            */

    end;

    var
        EmployeeAssign: Record UnknownRecord61213;
        Find: Boolean;
        OK: Boolean;
        FOUND: Boolean;
        CARRYOVER: Boolean;
        EmployeeNo: Code[20];
        Category: Option Holiday,Sickness,Training,Unauthorised;
        Description: Code[20];
        Year: Integer;
        Preferences: Record UnknownRecord39005717;
}

