#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5200 "Employee/Resource Update"
{
    Permissions = TableData Resource=rimd;

    trigger OnRun()
    begin
    end;

    var
        Res: Record Resource;


    procedure HumanResToRes(OldEmployee: Record Employee;Employee: Record Employee)
    begin
        if (Employee."Resource No." <> '') and
           ((OldEmployee."Resource No." <> Employee."Resource No.") or
            (OldEmployee."Job Title" <> Employee."Job Title") or
            (OldEmployee."First Name" <> Employee."First Name") or
            (OldEmployee."Last Name" <> Employee."Last Name") or
            (OldEmployee.Address <> Employee.Address) or
            (OldEmployee."Address 2" <> Employee."Address 2") or
            (OldEmployee."Post Code" <> Employee."Post Code") or
            (OldEmployee."Social Security No." <> Employee."Social Security No.") or
            (OldEmployee."Employment Date" <> Employee."Employment Date"))
        then
          ResUpdate(Employee)
        else
          exit;
    end;


    procedure ResUpdate(Employee: Record Employee)
    begin
        Res.Get(Employee."Resource No.");
        Res."Job Title" := Employee."Job Title";
        Res.Name := CopyStr(Employee.FullName,1,30);
        Res.Address := Employee.Address;
        Res."Address 2" := Employee."Address 2";
        Res.Validate("Post Code",Employee."Post Code");
        Res."Social Security No." := Employee."Social Security No.";
        Res."Employment Date" := Employee."Employment Date";
        Res.Modify(true)
    end;
}

