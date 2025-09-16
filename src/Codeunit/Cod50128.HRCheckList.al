#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 50128 "HR CheckList"
{

    trigger OnRun()
    begin
    end;

    var
        CheckListItems: Record UnknownRecord61247;
        CheckList: Record UnknownRecord61246;
        Found: Boolean;
        Found1: Boolean;
        ItemText: Text[100];
        Number: Integer;
        Employee: Record UnknownRecord61188;
        OKEmp: Boolean;
        ExitInterviewCheckList: Record UnknownRecord61253;
        "ExitInterviewCheckList Items": Record UnknownRecord61252;


    procedure GetItems(EmployeeNo: Code[20];type: Integer)
    var
        FoundEmployee: Boolean;
    begin
                 OKEmp:= Employee.Get(EmployeeNo);
                 Found := CheckListItems.Find('-');
                 case type of
                  1: begin
                     FoundEmployee:= FindEmp(EmployeeNo);
                     if ((Found) and (FoundEmployee = false)) then begin
                     repeat
                      ItemText:= CheckListItems."Induction Code";
                      CheckList.Init;
                      CheckList."Induction Code":= EmployeeNo;
                      CheckList."Staff Names":= ItemText;
                      if OKEmp then begin
                       CheckList."Department Code":= Employee."First Name";
                       CheckList."Department Name":= Employee."Last Name";
                      end;
                      CheckList.Insert;

                     until CheckListItems.Next = 0;
                     end;
                    end;
                   2: begin
                     repeat
                      ItemText:= CheckListItems."Induction Code";
                      CheckList.Init;
                      CheckList."Induction Code":= EmployeeNo;
                      CheckList."Staff Names":= ItemText;
                      if OKEmp then begin
                       CheckList."Department Code":= Employee."First Name";
                       CheckList."Department Name":= Employee."Last Name";
                      end;
                      CheckList.Insert;

                     until CheckListItems.Next = 0;
                     end;
                   end;
    end;


    procedure FindEmp(EmpNo: Code[20]) FoundEmp: Boolean
    var
        EmployeeNumber: Code[20];
    begin
                  Found:= CheckList.Find('-');

                   if (Found) then begin
                   while ((FoundEmp = false) and (CheckList.Next <> 0)) do begin
                       EmployeeNumber:= CheckList."Induction Code";
                        if (EmployeeNumber = EmpNo) then begin
                          FoundEmp:= true
                        end else FoundEmp:= false;
                        CheckList.Next;
                    end;
                   end;
    end;


    procedure DeleteEmpList(EmpNo: Code[20])
    begin
                      CheckList.SetRange("Induction Code",EmpNo);
                      CheckList.DeleteAll;
    end;


    procedure GetExitInterviewItems(EmployeeNo: Code[20];type: Integer)
    var
        FoundEmployee: Boolean;
    begin
                 OKEmp:= Employee.Get(EmployeeNo);
                 Found := "ExitInterviewCheckList Items".Find('-');
                 case type of
                  1: begin
                     FoundEmployee:= FindExitInterviewEmp(EmployeeNo);
                     if ((Found) and (FoundEmployee = false)) then begin
                     repeat
                      ItemText:= "ExitInterviewCheckList Items"."Claim Type";
                      ExitInterviewCheckList.Init;
                      ExitInterviewCheckList."Job ID":= EmployeeNo;
                      ExitInterviewCheckList."No of Posts":= ItemText;
                      if OKEmp then begin
                       CheckList."Department Code":= Employee."First Name";
                       CheckList."Department Name":= Employee."Last Name";
                      end;
                      ExitInterviewCheckList.Insert;

                     until CheckListItems.Next = 0;
                     end;
                    end;
                   2: begin
                     repeat
                      ItemText:= "ExitInterviewCheckList Items"."Claim Type";
                      ExitInterviewCheckList.Init;
                      ExitInterviewCheckList."Job ID":= EmployeeNo;
                      ExitInterviewCheckList."No of Posts":= ItemText;
                      if OKEmp then begin
                       CheckList."Department Code":= Employee."First Name";
                       CheckList."Department Name":= Employee."Last Name";
                      end;
                      ExitInterviewCheckList.Insert;

                     until "ExitInterviewCheckList Items".Next = 0;
                     end;
                   end;
    end;


    procedure FindExitInterviewEmp(EmpNo: Code[20]) FoundEmp: Boolean
    var
        EmployeeNumber: Code[20];
    begin
                  Found:= ExitInterviewCheckList.Find('-');

                   if (Found) then begin
                     while ((FoundEmp = false) and (ExitInterviewCheckList.Next <> 0)) do
                     begin
                       EmployeeNumber:= ExitInterviewCheckList."Job ID";
                       if (EmployeeNumber = EmpNo) then begin
                         FoundEmp:= true
                       end else FoundEmp:= false;
                       ExitInterviewCheckList.Next;
                     end;
                   end;
    end;


    procedure DeleteExitInterviewEmp(EmpNo: Code[20])
    begin
                      ExitInterviewCheckList.SetRange("Job ID",EmpNo);
                      ExitInterviewCheckList.DeleteAll;
    end;
}

