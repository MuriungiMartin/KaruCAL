#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5201 "Employee/Salesperson Update"
{
    Permissions = TableData "Salesperson/Purchaser"=rimd;

    trigger OnRun()
    begin
    end;

    var
        SalespersonPurchaser: Record "Salesperson/Purchaser";


    procedure HumanResToSalesPerson(OldEmployee: Record Employee;Employee: Record Employee)
    begin
        if (Employee."Salespers./Purch. Code" <> '') and
           ((OldEmployee."Salespers./Purch. Code" <> Employee."Salespers./Purch. Code") or
            (OldEmployee."First Name" <> Employee."First Name") or
            (OldEmployee."Middle Name" <> Employee."Middle Name") or
            (OldEmployee."Last Name" <> Employee."Last Name"))
        then
          SalesPersonUpdate(Employee)
        else
          exit;
    end;

    local procedure SalesPersonUpdate(Employee: Record Employee)
    begin
        SalespersonPurchaser.Get(Employee."Salespers./Purch. Code");
        SalespersonPurchaser.Name := CopyStr(Employee.FullName,1,50);
        SalespersonPurchaser.Modify
    end;
}

