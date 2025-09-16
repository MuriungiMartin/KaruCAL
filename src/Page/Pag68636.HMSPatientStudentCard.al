#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68636 "HMS Patient Student Card"
{
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = UnknownTable61402;

    layout
    {
        area(content)
        {
            group("Personal details")
            {
                Caption = 'Personal details';
                Editable = true;
                field("Patient No.";"Patient No.")
                {
                    ApplicationArea = Basic;
                }
                field("Date Registered";"Date Registered")
                {
                    ApplicationArea = Basic;
                }
                field("Patient Type";"Patient Type")
                {
                    ApplicationArea = Basic;
                    Editable = true;

                    trigger OnValidate()
                    begin
                        CheckPatientType();
                    end;
                }
                field("Student No.";"Student No.")
                {
                    ApplicationArea = Basic;
                }
                field("Employee No.";"Employee No.")
                {
                    ApplicationArea = Basic;
                }
                field("Relative No.";"Relative No.")
                {
                    ApplicationArea = Basic;
                }
                field("Global Dimension 1 Code";"Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Global Dimension 2 Code";"Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                }
                field(Title;Title)
                {
                    ApplicationArea = Basic;
                }
                field(names;Surname+' '+"Middle Name"+' '+"Last Name")
                {
                    ApplicationArea = Basic;
                    Caption = 'Full Name';
                }
                field(Gender;Gender)
                {
                    ApplicationArea = Basic;
                }
                field("Date Of Birth";"Date Of Birth")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        if "Date Of Birth"<>0D then
                          begin
                            Age:=HRDates.DetermineAge("Date Of Birth",Today);
                          end;
                    end;
                }
                field("Marital Status";"Marital Status")
                {
                    ApplicationArea = Basic;
                }
                field("ID Number";"ID Number")
                {
                    ApplicationArea = Basic;
                }
                field(Age;Age)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Photo;Photo)
                {
                    ApplicationArea = Basic;
                }
                field(Blocked;Blocked)
                {
                    ApplicationArea = Basic;
                }
            }
            group("Medical details")
            {
                Caption = 'Medical details';
                Editable = true;
                field("Examining Officer";"Examining Officer")
                {
                    ApplicationArea = Basic;
                }
                field("Medical Exam Date";"Medical Exam Date")
                {
                    ApplicationArea = Basic;
                }
                field("Medical Details Not Covered";"Medical Details Not Covered")
                {
                    ApplicationArea = Basic;
                }
                field(Height;Height)
                {
                    ApplicationArea = Basic;
                }
                field(Weight;Weight)
                {
                    ApplicationArea = Basic;
                }
                field("Emergency Consent Relationship";"Emergency Consent Relationship")
                {
                    ApplicationArea = Basic;
                }
                field("Emergency Consent Full Name";"Emergency Consent Full Name")
                {
                    ApplicationArea = Basic;
                }
                field("Emergency Consent Address 1";"Emergency Consent Address 1")
                {
                    ApplicationArea = Basic;
                }
                field("Emergency Consent Address 2";"Emergency Consent Address 2")
                {
                    ApplicationArea = Basic;
                }
                field("Emergency Consent Address 3";"Emergency Consent Address 3")
                {
                    ApplicationArea = Basic;
                }
                field("Emergency Date of Consent";"Emergency Date of Consent")
                {
                    ApplicationArea = Basic;
                }
                field("Emergency National ID Card No.";"Emergency National ID Card No.")
                {
                    ApplicationArea = Basic;
                }
                field("Physical Impairment Details";"Physical Impairment Details")
                {
                    ApplicationArea = Basic;
                }
                field("Blood Group";"Blood Group")
                {
                    ApplicationArea = Basic;
                }
                field("Without Glasses R.6";"Without Glasses R.6")
                {
                    ApplicationArea = Basic;
                }
                field("Without Glasses L.6";"Without Glasses L.6")
                {
                    ApplicationArea = Basic;
                }
                field("With Glasses R.6";"With Glasses R.6")
                {
                    ApplicationArea = Basic;
                }
                field("With Glasses L.6";"With Glasses L.6")
                {
                    ApplicationArea = Basic;
                }
                field("Hearing Right Ear";"Hearing Right Ear")
                {
                    ApplicationArea = Basic;
                }
                field("Hearing Left Ear";"Hearing Left Ear")
                {
                    ApplicationArea = Basic;
                }
                field("Condition Of Teeth";"Condition Of Teeth")
                {
                    ApplicationArea = Basic;
                }
                field("Condition Of Throat";"Condition Of Throat")
                {
                    ApplicationArea = Basic;
                }
                field("Condition Of Ears";"Condition Of Ears")
                {
                    ApplicationArea = Basic;
                }
                field("Condition Of Lymphatic Glands";"Condition Of Lymphatic Glands")
                {
                    ApplicationArea = Basic;
                }
                field("Condition Of Nose";"Condition Of Nose")
                {
                    ApplicationArea = Basic;
                }
                field("Circulatory System Pulse";"Circulatory System Pulse")
                {
                    ApplicationArea = Basic;
                }
            }
            group("Historical Medical Conditions")
            {
                Caption = 'Historical Medical Conditions';
                Editable = true;
                part(Control1102760127;"HMS Patient Medical Condition")
                {
                    SubPageLink = "Patient No."=field("Patient No.");
                }
            }
            group("Historical Immunizations")
            {
                Caption = 'Historical Immunizations';
                Editable = true;
                part(Control1102760126;"HMS Patient Immunization")
                {
                    SubPageLink = "Patient No."=field("Patient No.");
                }
            }
            group("Spouse details (If Married)")
            {
                Caption = 'Spouse details (If Married)';
                Editable = true;
                field("Spouse Name";"Spouse Name")
                {
                    ApplicationArea = Basic;
                }
                field("Spouse Address 1";"Spouse Address 1")
                {
                    ApplicationArea = Basic;
                }
                field("Spouse Address 2";"Spouse Address 2")
                {
                    ApplicationArea = Basic;
                }
                field("Spouse Address 3";"Spouse Address 3")
                {
                    ApplicationArea = Basic;
                }
                field("Spouse Telephone No. 1";"Spouse Telephone No. 1")
                {
                    ApplicationArea = Basic;
                }
                field("Spouse Telephone No. 2";"Spouse Telephone No. 2")
                {
                    ApplicationArea = Basic;
                }
                field("Spouse Email";"Spouse Email")
                {
                    ApplicationArea = Basic;
                }
                field("Spouse Fax";"Spouse Fax")
                {
                    ApplicationArea = Basic;
                }
            }
            group("Correspondence Address")
            {
                Caption = 'Correspondence Address';
                Editable = true;
                field("Place of Birth Village";"Place of Birth Village")
                {
                    ApplicationArea = Basic;
                }
                field("Place of Birth Location";"Place of Birth Location")
                {
                    ApplicationArea = Basic;
                }
                field("Place of Birth District";"Place of Birth District")
                {
                    ApplicationArea = Basic;
                }
                field("Name of Chief";"Name of Chief")
                {
                    ApplicationArea = Basic;
                }
                field("Nearest Police Station";"Nearest Police Station")
                {
                    ApplicationArea = Basic;
                }
                field("Correspondence Address 1";"Correspondence Address 1")
                {
                    ApplicationArea = Basic;
                }
                field("Correspondence Address 2";"Correspondence Address 2")
                {
                    ApplicationArea = Basic;
                }
                field("Correspondence Address 3";"Correspondence Address 3")
                {
                    ApplicationArea = Basic;
                }
                field("Telephone No. 1";"Telephone No. 1")
                {
                    ApplicationArea = Basic;
                }
                field("Telephone No. 2";"Telephone No. 2")
                {
                    ApplicationArea = Basic;
                }
                field(Email;Email)
                {
                    ApplicationArea = Basic;
                }
                field("Fax No.";"Fax No.")
                {
                    ApplicationArea = Basic;
                }
            }
            group("Parent Details")
            {
                Caption = 'Parent Details';
                Editable = true;
                field("Mother Alive or Dead";"Mother Alive or Dead")
                {
                    ApplicationArea = Basic;
                }
                field("Mother Full Name";"Mother Full Name")
                {
                    ApplicationArea = Basic;
                }
                field("Mother Occupation";"Mother Occupation")
                {
                    ApplicationArea = Basic;
                }
                field("Father Alive or Dead";"Father Alive or Dead")
                {
                    ApplicationArea = Basic;
                }
                field("Father Full Name";"Father Full Name")
                {
                    ApplicationArea = Basic;
                }
                field("Father Occupation";"Father Occupation")
                {
                    ApplicationArea = Basic;
                }
                field("Guardian Name";"Guardian Name")
                {
                    ApplicationArea = Basic;
                }
                field("Guardian Occupation";"Guardian Occupation")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
        }
        area(processing)
        {
            action(Statistics)
            {
                ApplicationArea = Basic;
                Caption = 'Statistics';
                Image = Statistics;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "HMS-Patient Card";
                RunPageLink = "Patient No."=field("Patient No.");
            }
            action(SyncRecs)
            {
                ApplicationArea = Basic;
                Caption = 'Sync Records';
                Image = SuggestWorkMachCost;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    HRMEmployeeC: Record UnknownRecord61188;
                    Customer: Record Customer;
                    HMISPatient: Record UnknownRecord61402;
                    HMSSetup: Record UnknownRecord61386;
                    NoSeriesManagement: Codeunit NoSeriesManagement;
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
                                HMISPatient.Modify;
                                end else begin
                                  HMISPatient.Init;
                                  HMISPatient."Patient Type":=HMISPatient."patient type"::Employee;
                                  HMISPatient."Patient No.":=HRMEmployeeC."No.";
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
                    //        IF HRMEmployeeBeneficiaries."Employee Code"='0366' THEN
                    //          HMISPatient.RESET;
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
                      /*HRMEmployeeKin.RESET;
                    IF HRMEmployeeKin.FIND('-') THEN BEGIN
                        REPEAT
                            BEGIN
                              HMISPatient.RESET;
                              HMISPatient.SETRANGE("Patient No.",HRMEmployeeKin."ID No/Passport No");
                              IF HMISPatient.FIND('-') THEN BEGIN
                                 HMISPatient.VALIDATE("Patient No.");
                                HMISPatient.MODIFY;
                                END ELSE BEGIN
                                  HMISPatient.INIT;
                                  HMISPatient."Patient Type":=HMISPatient."Patient Type"::Dependant;
                                  HMISPatient."Patient No.":=HRMEmployeeKin."ID No/Passport No";
                                  HMISPatient.INSERT;
                                  //HMISPatient.VALIDATE("Patient Type");
                                  HMISPatient.VALIDATE("Patient No.");
                                HMISPatient.MODIFY;
                                  END;
                            END;
                          UNTIL HRMEmployeeKin.NEXT=0;
                      END;*/
                    CurrPage.Update;

                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        OnAfterGetCurrRecord;
    end;

    trigger OnInit()
    begin
        "Relative No.Enable" := true;
        "Employee No.Enable" := true;
        "Student No.Enable" := true;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        "Patient Type":="patient type"::Student;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        OnAfterGetCurrRecord;
    end;

    var
        HasValue: Boolean;
        HRDates: Codeunit "HR Dates";
        Age: Text[100];
        [InDataSet]
        "Student No.Enable": Boolean;
        [InDataSet]
        "Employee No.Enable": Boolean;
        [InDataSet]
        "Relative No.Enable": Boolean;
        HRMEmployeeKin: Record UnknownRecord61323;
        HRMEmployeeBeneficiaries: Record UnknownRecord61324;


    procedure CheckPatientType()
    begin
        if "Patient Type"="patient type"::Others then
          begin
            "Student No.Enable" :=true;
            "Employee No.Enable" :=false;
            "Relative No.Enable" :=false;
          end
        else
          begin
            "Student No.Enable" :=false;
            "Employee No.Enable" :=true;
            "Relative No.Enable" :=true;
          end;
    end;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        CheckPatientType();
        if "Date Of Birth"<>0D then
          begin
            Age:=HRDates.DetermineAge("Date Of Birth",Today);
          end;
    end;
}

