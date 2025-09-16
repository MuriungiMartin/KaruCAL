#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 63901 "Sync. Hospital Data"
{

    trigger OnRun()
    begin
        if  Confirm('Sync Data?',true)=false then Error('Cancelled!');
        HRMEmployeeC.Reset;
        HRMEmployeeC.SetRange(Status,HRMEmployeeC.Status::Active);
        if HRMEmployeeC.Find('-') then begin
            repeat
                begin
                  HMISPatient.Reset;
                  HMISPatient.SetRange("Patient No.",HRMEmployeeC."No.");
                  if HMISPatient.Find('-') then begin
                      HMISPatient.Validate("Patient No.");
                      HMISPatient."Employee No.":=HRMEmployeeC."No.";
                      HMISPatient.Modify;
                    end else begin
                      HMISPatient.Init;
                      HMISPatient."Patient Type":=HMISPatient."patient type"::Employee;
                      HMISPatient."Patient No.":=HRMEmployeeC."No.";
                      HMISPatient."Employee No.":=HRMEmployeeC."No.";
                      HMISPatient.Insert;
                      HMISPatient.Validate("Patient No.");
                    HMISPatient.Modify;
                      end;
                end;
              until HRMEmployeeC.Next=0;
          end;

        Customer.Reset;
        Customer.SetFilter(Status,'%1|%2',Customer.Status::Current,Customer.Status::Registration);
        Customer.SetRange("Customer Posting Group",'STUDENT');
        if Customer.Find('-') then begin
            repeat
                begin
                  HMISPatient.Reset;
                  HMISPatient.SetRange("Patient No.",Customer."No.");
                  HMISPatient.SetRange("Patient Type",HMISPatient."patient type"::Student);
                  if HMISPatient.Find('-') then begin
                     HMISPatient.Validate("Patient No.");
                    HMISPatient.Surname:=Customer.Name;
                    if Customer.Gender=Customer.Gender::Female then
                      HMISPatient.Gender:= HMISPatient.Gender::Female
                    else  if Customer.Gender=Customer.Gender::Male then
                      HMISPatient.Gender:=HMISPatient.Gender::Male;
                    HMISPatient.Modify;
                    end else begin
                      HMISPatient.Init;
                      HMISPatient."Patient Type":=HMISPatient."patient type"::Student;
                      HMISPatient."Patient No.":=Customer."No.";
                    HMISPatient.Surname:=Customer.Name;
                    if Customer.Gender=Customer.Gender::Female then
                      HMISPatient.Gender:=HMISPatient.Gender::Female
                    else  if Customer.Gender=Customer.Gender::Male then
                      HMISPatient.Gender:=HMISPatient.Gender::Male;
                      HMISPatient.Insert;
                      HMISPatient.Validate("Patient No.");
                      end;
                end;
              until Customer.Next=0;
          end;
        // Sync Beneficiers & Dependants
        HRMEmployeeBeneficiaries.Reset;
        if HRMEmployeeBeneficiaries.Find('-') then begin
            repeat
                begin
                  HMISPatient.Reset;
                  HMISPatient.SetRange(Surname,HRMEmployeeBeneficiaries.SurName);
                  HMISPatient.SetRange("Last Name",HRMEmployeeBeneficiaries."Other Names");
                  HMISPatient.SetRange("Employee No.",HRMEmployeeBeneficiaries."Employee Code");
                  if HMISPatient.Find('-') then begin
                      HMISPatient."Patient Type":=HMISPatient."patient type"::Dependant;
                      HMISPatient."Employee No.":=HRMEmployeeBeneficiaries."Employee Code";
                      HMISPatient."ID Number":=HRMEmployeeBeneficiaries."ID No/Passport No";
                      HMISPatient."Date Of Birth":=HRMEmployeeBeneficiaries."Date Of Birth";
                      HMISPatient.Surname:=HRMEmployeeBeneficiaries.SurName;
                      HMISPatient."Last Name":=HRMEmployeeBeneficiaries."Other Names";
                      HMISPatient.Registered:=true;
                      HMISPatient.Modify;
                    end else begin
                     HMSSetup.Get;
                     HMSSetup.TestField("Patient Nos");
                      HMISPatient.Init;
                      HMISPatient."Patient Type":=HMISPatient."patient type"::Dependant;
                      HMISPatient."Patient No.":=NoSeriesManagement.GetNextNo(HMSSetup."Patient Nos",Today,true);
                      HMISPatient."Employee No.":=HRMEmployeeBeneficiaries."Employee Code";
                      HMISPatient."Date Registered":=Today;
                      HMISPatient."ID Number":=HRMEmployeeBeneficiaries."ID No/Passport No";
                      HMISPatient."Date Of Birth":=HRMEmployeeBeneficiaries."Date Of Birth";
                      HMISPatient.Surname:=HRMEmployeeBeneficiaries.SurName;
                      HMISPatient."Last Name":=HRMEmployeeBeneficiaries."Other Names";
                      HMISPatient."Depandant Principle Member":=HRMEmployeeBeneficiaries."Employee Code";
                      HMISPatient.Registered:=true;
                      HMISPatient.Insert;
                      end;
                end;
              until HRMEmployeeBeneficiaries.Next=0;
          end;
    end;

    var
        HRMEmployeeC: Record UnknownRecord61188;
        Customer: Record Customer;
        HMISPatient: Record UnknownRecord61402;
        HMSSetup: Record UnknownRecord61386;
        NoSeriesManagement: Codeunit NoSeriesManagement;
        HRMEmployeeBeneficiaries: Record UnknownRecord61324;
}

