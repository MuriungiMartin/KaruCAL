#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 50125 "HR Employee/SalespersonUpdate"
{

    trigger OnRun()
    begin
    end;

    var
        SalespersonPurchaser: Record "Salesperson/Purchaser";


    procedure HumanResToSalesPerson(OldEmployee: Record UnknownRecord61188;Employee: Record UnknownRecord61188)
    begin
        if (Employee."Salespers./Purch. Code" <> '') and
           ((OldEmployee."Salespers./Purch. Code" <> Employee."Salespers./Purch. Code") or
            (OldEmployee."Known As" <> Employee."Known As") or
            (OldEmployee."Middle Name" <> Employee."Middle Name") or
            (OldEmployee."Last Name" <> Employee."Last Name"))
        then
          SalesPersonUpdate(Employee)
        else
          exit;
    end;


    procedure SalesPersonUpdate(Employee: Record UnknownRecord61188)
    begin
        SalespersonPurchaser.Get(Employee."Salespers./Purch. Code");
        SalespersonPurchaser.Name := CopyStr(Employee.FullName,1,50);
        SalespersonPurchaser.Modify;
    end;
}

