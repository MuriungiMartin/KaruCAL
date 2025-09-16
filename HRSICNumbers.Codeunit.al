#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 50130 "HR SIC Numbers"
{

    trigger OnRun()
    begin
    end;

    var
        SICNumbers: Record UnknownRecord61235;
        EmpSICNumbers: Record UnknownRecord61236;
        Found: Boolean;
        OK: Boolean;
        Employee: Record UnknownRecord61188;
        OKEmp: Boolean;


    procedure GetSICNumbers(EmpNo: Code[20];sic: Integer)
    begin
                 OKEmp:= Employee.Get(EmpNo);
                 Found := SICNumbers.Find('-');
                 case sic of
                  1 : begin
                   OK := FindEmployee(EmpNo);
                   if ((Found) and (not OK)) then begin

                    repeat
                      EmpSICNumbers.Init;
                      EmpSICNumbers.Code:= EmpNo;
                      EmpSICNumbers.Description:= SICNumbers."SIC Code Level 4";
                      EmpSICNumbers."Include in Evaluation Form":= SICNumbers."Employee No";
                      EmpSICNumbers.SubSection:= SICNumbers."Evaluation Code";
                      EmpSICNumbers."Section Description":= SICNumbers."Evaluation Description";
                      if OKEmp then begin
                       EmpSICNumbers."Employee First Name":= Employee."Known As";
                       EmpSICNumbers."Objective Type":= Employee."Last Name";
                      end;
                      EmpSICNumbers.Insert;

                    until SICNumbers.Next = 0;
                  end;
                 end;
                 2: begin

                    repeat
                      EmpSICNumbers.Init;
                      EmpSICNumbers.Code:= EmpNo;
                      EmpSICNumbers.Description:= SICNumbers."SIC Code Level 4";
                      EmpSICNumbers."Include in Evaluation Form":= SICNumbers."Employee No";
                      EmpSICNumbers.SubSection:= SICNumbers."Evaluation Code";
                      EmpSICNumbers."Section Description":= SICNumbers."Evaluation Description";
                      if OKEmp then begin
                       EmpSICNumbers."Employee First Name":= Employee."Known As";
                       EmpSICNumbers."Objective Type":= Employee."Last Name";
                      end;
                      EmpSICNumbers.Insert;

                    until SICNumbers.Next = 0;
                   end;
                 end;
    end;


    procedure FindEmployee(EmpNo: Code[20]) FoundEmp: Boolean
    var
        EmployeeNumber: Code[20];
    begin
                  Found:= EmpSICNumbers.Find('-');

                   if (Found) then begin
                   while ((FoundEmp = false) and (EmpSICNumbers.Next <> 0)) do begin
                       EmployeeNumber:= EmpSICNumbers.Code;
                        if (EmployeeNumber = EmpNo) then begin
                          FoundEmp:= true
                        end else FoundEmp:= false;
                        EmpSICNumbers.Next;
                    end;
                   end;
    end;


    procedure DeleteSICNumbers(EmpNo: Code[20])
    begin
                    EmpSICNumbers.SetRange(Code,EmpNo);
                    EmpSICNumbers.DeleteAll;
    end;
}

