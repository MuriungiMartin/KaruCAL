#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 50124 "HR Employee/Resource"
{

    trigger OnRun()
    begin
    end;

    var
        Res: Record Resource;


    procedure HumanResToRes(OldEmployee: Record UnknownRecord61188;Employee: Record UnknownRecord61188)
    begin
        if (Employee."Resource No." <> '') and
           ((OldEmployee."Resource No." <> Employee."Resource No.") or
            (OldEmployee.Position <> Employee.Position) or
            (OldEmployee."Known As" <> Employee."Known As") or
            (OldEmployee."Last Name" <> Employee."Last Name") or
            (OldEmployee."Postal Address" <> Employee."Postal Address") or
            (OldEmployee."Residential Address" <> Employee."Residential Address") or
            (OldEmployee."Residential Address2" <> Employee."Residential Address2") or
            (OldEmployee."Residential Address3" <> Employee."Residential Address3") or
            (OldEmployee."Post Code" <> Employee."Post Code") or
            (OldEmployee."Post Code2" <> Employee."Post Code2") or
            (OldEmployee."ID Number" <> Employee."ID Number") or
            (OldEmployee."Work Phone Number" <> Employee."Work Phone Number") or
            (OldEmployee."Fax Number" <> Employee."Fax Number") or
            (OldEmployee."E-Mail" <>  Employee."E-Mail") or
            (OldEmployee."Date Of Join" <> Employee."Date Of Join") or
            (OldEmployee."Department Code" <> Employee."Department Code") or
            (OldEmployee.Office <> Employee.Office) or
            (OldEmployee."Primary Skills Category" <> Employee."Primary Skills Category") or
            (OldEmployee.Level <> Employee.Level)) //OR
            //(OldEmployee."Contract Type" <> Employee."Contract Type"))

        then
          ResUpdate(Employee)
        else
          exit;
    end;


    procedure ResUpdate(Employee: Record UnknownRecord61188)
    begin
        /*Res.GET(Employee."Resource No.");
        Res."Job Title" := Employee."Job Title";
        //Res."Job Specification":= Employee."Job Specification";
        Res.Name := COPYSTR(Employee.FullName,1,30);
        Res.VALIDATE(Name);
        //Res."Postal Address" := Employee."Postal Address";
        //Res."Residential Address" := Employee."Residential Address";
        Res.VALIDATE("Post Code",Employee."Post Code");
        Res."Social Security No." := Employee."ID Number";
        Res."Employment Date" := Employee."Date Of Join";
        //Res."Emp No.":= Employee."No.";
        //Res."E-mail":= Employee."E-Mail";
        //Res."Department Code":=Employee."Department Code";
        //Res."Office Code":=Employee.Office;
        //Res.Level := Employee.Level;
        //Res."Employment Status" := Employee."Contract Type" + 1;
        
        //IF Res."Vendor Number" <> '' THEN
        // BEGIN
        //   VendUpdate(Employee);
        // END;
        {
        //IF (Employee."Primary Skills Category" = Employee."Primary Skills Category"::Auditors) OR
        //   (Employee."Primary Skills Category" = Employee."Primary Skills Category"::Certification) THEN
        //  Res.Type := Res.Type::Auditor
        //ELSE IF Employee."Primary Skills Category" = Employee."Primary Skills Category"::Consultants THEN
          Res.Type := Res.Type::Consultant
        ELSE IF Employee."Primary Skills Category" = Employee."Primary Skills Category"::Training THEN
          Res.Type := Res.Type::Trainer
        ELSE IF Employee."Primary Skills Category" = Employee."Primary Skills Category"::"Business Development" THEN
          Res.Type := Res.Type::BDM
        ELSE IF Employee."Primary Skills Category" = Employee."Primary Skills Category"::Administration THEN
          Res.Type := Res.Type::Administrator
        ELSE IF Employee."Primary Skills Category" = Employee."Primary Skills Category"::Marketing THEN
          Res.Type := Res.Type::Marketing
        ELSE IF Employee."Primary Skills Category" = Employee."Primary Skills Category"::Management THEN
          Res.Type := Res.Type::Manager;
        }
        
        
        
        
        
        
        Res.MODIFY(TRUE)
        */

    end;


    procedure VendUpdate(Employee: Record UnknownRecord61188)
    var
        lRec_Vendor: Record Vendor;
    begin
        /*
        IF (Res."No." <> Employee."Resource No.") THEN
           Res.GET(Employee."Resource No.");
        
        lRec_Vendor.GET(Res."Vendor Number");
        lRec_Vendor.Name:=Res.Name;
        lRec_Vendor.VALIDATE(Name);
        lRec_Vendor."Department Code":=Res."Department Code";
        lRec_Vendor."Office Code":=Res."Office Code";
        lRec_Vendor.Address := COPYSTR(Employee."Residential Address", 1, 30);
        lRec_Vendor."Address 2" := Employee."Residential Address2";
        lRec_Vendor.City := Employee."Residential Address3";
        lRec_Vendor."Post Code" := Employee."Post Code2";
        lRec_Vendor."Phone No." := Employee."Work Phone Number";
        lRec_Vendor."Fax No." := Employee."Fax Number";
        lRec_Vendor."E-Mail" := Employee."E-Mail";
        lRec_Vendor.MODIFY;
        */

    end;


    procedure HumanResToUser(OldEmployee: Record UnknownRecord61188;Employee: Record UnknownRecord61188)
    begin
        /*
        IF (Employee."Resource No." <> '') AND
           ((OldEmployee."Known As" <> Employee."Known As") OR
            (OldEmployee."Last Name" <> Employee."Last Name") OR
            (OldEmployee."User ID" <> Employee."User ID"))
        THEN
          UserUpdate(Employee)
        ELSE
          EXIT;
        */

    end;


    procedure UserUpdate(Employee: Record UnknownRecord61188)
    var
        User: Record User;
    begin
        /*User.GET(Employee."User ID");
        User.Name := COPYSTR(Employee.FullName,1,30);
        User.MODIFY(TRUE)
         */

    end;
}

