#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 61105 "Validate User Permissions"
{
    // Check Access Permissions


    trigger OnRun()
    begin
    end;


    procedure validateUser(var RecType: Option " ",GL,Cust,Item,Supp,FA,Emp,Sal,CourseReg,prTrans,EmpTrans)
    var
        Usersetup: Record "User Setup";
    begin
        if not Usersetup.Get(UserId) then Error('You are not a Legitimate user. Please consult the system administrator.');
        if RecType=Rectype::FA then if not (Usersetup."Create FA" = true) then Error('You do not have permission to work on Fixed Assets.');
        if RecType=Rectype::Cust then if not (Usersetup."Create Customer" = true) then Error('You do not have permission to work on Customers.');
        if RecType=Rectype::Emp then if not (Usersetup."Create Employee" = true) then Error('You do not have permission to work on Employees.');
        if RecType=Rectype::CourseReg then if not (Usersetup."Create Course_Reg" = true) then Error('You do not have permission to work on Course Registrations.');
        if RecType=Rectype::GL then if not (Usersetup."Create GL" = true) then Error('You do not have permission to work on GL.');
        if RecType=Rectype::Item then if not (Usersetup."Create Items" = true) then Error('You do not have permission to work on Items.');
        if RecType=Rectype::Sal then if not (Usersetup."Create Salary" = true) then Error('You do not have permission to work on Salaries.');
        if RecType=Rectype::Supp then if not (Usersetup."Create Supplier" = true) then Error('You do not have permission to work on Suppliers');
        if RecType=Rectype::EmpTrans then if not (Usersetup."Create Emp. Transactions" = true) then Error('You do not have permission to work on Emp. transactions');
        if RecType=Rectype::prTrans then if not (Usersetup."Create PR Transactions" = true) then Error('You do not have permission to work on Transactions');
    end;
}

