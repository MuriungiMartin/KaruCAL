#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 50139 "HMS Patient"
{

    trigger OnRun()
    begin
    end;

    var
        Employee: Record UnknownRecord61188;
        Relative: Record UnknownRecord61323;
        PatientRec: Record UnknownRecord61402;
        NewPatientCode: Code[20];
        NoSeriesMgt: Codeunit NoSeriesManagement;
        HMSSetup: Record UnknownRecord61386;
        Benf: Record UnknownRecord61324;


    procedure CopyStudentToHMS(var Admission: Record UnknownRecord61372)
    var
        Patient: Record UnknownRecord61402;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        HMSSetup: Record UnknownRecord61386;
        NewCode: Code[20];
        AdmMedicalCondition: Record UnknownRecord61376;
        AdmImmunization: Record UnknownRecord61378;
        PatMedicalCondition: Record UnknownRecord61435;
        PatImmunization: Record UnknownRecord61436;
    begin
        /*Check if the student is already registered in the system database*/
        Patient.Reset;
        Patient.SetRange(Patient."Student No.",Admission."Admission No.");
        if Patient.Find('-') then
          begin
            //student already exists in the database
          end
        else
          begin
            //get the new patient number from the database
            HMSSetup.Reset;
            HMSSetup.Get();
            NewCode:=NoSeriesMgt.GetNextNo(HMSSetup."Patient Nos",0D,true);
            //copy the details from  the admissions database and into the patient database
            Patient.Init;
              Patient."Patient No.":=NewCode;
              Patient."Date Registered":=Today;
              Patient."Patient Type":=Patient."patient type"::Others;
              Patient."Student No.":=Admission."Admission No.";
              Patient.Surname:=Admission.Surname;
              Patient."Middle Name":=Admission."Other Names";
              Patient.Gender:=Admission.Gender;
              Patient."Date Of Birth":=Admission."Date Of Birth";
              Patient."Marital Status":=Admission."Marital Status";
              Patient.Photo:=Admission.Photo;
              Patient."Correspondence Address 1":=Admission."Correspondence Address 1";
              Patient."Correspondence Address 2":=Admission."Correspondence Address 2";
              Patient."Correspondence Address 3":=Admission."Correspondence Address 3";
              Patient."Telephone No. 1":=Admission."Telephone No. 1";
              Patient."Telephone No. 2":=Admission."Telephone No. 2";
              Patient.Email:=Admission."E-Mail";
              Patient."Fax No.":=Admission."Fax No.";
              Patient."Spouse Name":=Admission."Spouse Name";
              Patient."Spouse Address 1":=Admission."Spouse Address 1";
              Patient."Spouse Address 2":=Admission."Spouse Address 2";
              Patient."Spouse Address 3":=Admission."Spouse Address 3";
              Patient."Place of Birth Village":=Admission."Place Of Birth Village";
              Patient."Place of Birth Location":=Admission."Place Of Birth Location";
              Patient."Place of Birth District":=Admission."Place Of Birth District";
              Patient."Name of Chief":=Admission."Name of Chief";
              Patient."Nearest Police Station":=Admission."Nearest Police Station";
              Patient.Nationality:=Admission.Nationality;
              Patient.Religion:=Admission.Religion;
              Patient."Mother Alive or Dead":=Admission."Mother Alive Or Dead";
              Patient."Mother Full Name":=Admission."Mother Full Name";
              Patient."Mother Occupation":=Admission."Mother Occupation";
              Patient."Father Alive or Dead":=Admission."Father Alive Or Dead";
              Patient."Father Full Name":=Admission."Father Full Name";
              Patient."Father Occupation":=Admission."Father Occupation";
              Patient."Guardian Name":=Admission."Guardian Full Name";
              Patient."Guardian Occupation":=Admission."Guardian Occupation";
              Patient."Physical Impairment Details":=Admission."Physical Impairment Details";
              Patient."Without Glasses R.6":=Admission."Without Glasses R.6";
              Patient."Without Glasses L.6":=Admission."Without Glasses L.6";
              Patient."With Glasses R.6":=Admission."With Glasses R.6";
              Patient."With Glasses L.6":=Admission."With Glasses L.6";
              Patient."Hearing Right Ear":=Admission."Hearing Right Ear";
              Patient."Hearing Left Ear":=Admission."Hearing Left Ear";
              Patient."Condition Of Teeth":=Admission."Condition Of Teeth";
              Patient."Condition Of Throat":=Admission."Condition Of Throat";
              Patient."Condition Of Ears":=Admission."Condition Of Ears";
              Patient."Condition Of Lymphatic Glands":=Admission."Condition Of Lymphatic Glands";
              Patient."Condition Of Nose":=Admission."Condition Of Nose";
              Patient."Circulatory System Pulse":=Admission."Circulatory System Pulse";
              Patient."Examining Officer":=Admission."Examining Officer";
              Patient."Medical Exam Date":=Admission."Medical Exam Date";
              Patient."Medical Details Not Covered":=Admission."Medical Details Not Covered";
              Patient."Emergency Consent Relationship":=Admission."Emergency Consent Relationship";
              Patient."Emergency Consent Full Name":=Admission."Emergency Consent Full Name";
              Patient."Emergency Consent Address 1":=Admission."Emergency Consent Address 1";
              Patient."Emergency Consent Address 2":=Admission."Emergency Consent Address 2";
              Patient."Emergency Consent Address 3":=Admission."Emergency Consent Address 3";
              Patient."Emergency Date of Consent":=Admission."Emergency Date of Consent";
              Patient."Emergency National ID Card No.":=Admission."Emergency National ID Card No.";
              Patient.Height:=Admission.Height;
              Patient.Weight:=Admission.Weight;
            Patient.Insert();
            /*Copy the medical condition from the database*/
            AdmMedicalCondition.Reset;
            AdmMedicalCondition.SetRange(AdmMedicalCondition."Admission No.",Admission."Admission No.");
            if AdmMedicalCondition.Find('-') then
              begin
                repeat
                  PatMedicalCondition.Init;
                    PatMedicalCondition."Patient No.":=NewCode;
                    PatMedicalCondition."Medical Condition":=AdmMedicalCondition."Medical Condition Code";
                    PatMedicalCondition."Date From":=AdmMedicalCondition."Date From";
                    PatMedicalCondition."Date To":=AdmMedicalCondition."Date To";
                    PatMedicalCondition.Yes:=AdmMedicalCondition.Yes;
                    PatMedicalCondition.Details:=AdmMedicalCondition.Details;
                  PatMedicalCondition.Insert;
                until AdmMedicalCondition.Next=0;
              end;
            /*Copy the immunizations from the student admission database to the patient registration*/
            AdmImmunization.Reset;
            AdmImmunization.SetRange(AdmImmunization."Admission No.",Admission."Admission No.");
            if AdmImmunization.Find('-') then
              begin
                repeat
                  PatImmunization.Init;
                    PatImmunization."Patient No.":=NewCode;
                    PatImmunization."Immunization Code":=AdmImmunization."Immunization Code";
                    PatImmunization.Yes:=AdmImmunization.Yes;
                    PatImmunization.Date:=AdmImmunization.Date;
                  PatImmunization.Insert;
                until AdmImmunization.Next=0;
              end;
          end;

    end;


    procedure CopyRegisteredStudentToHMS(var Student: Record Customer)
    var
        Patient: Record UnknownRecord61402;
        HMSSetup: Record UnknownRecord61386;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        NewCode: Code[20];
    begin
        /*Check if the student is already a registered patient*/
        Patient.Reset;
        Patient.SetRange(Patient."Student No.",Student."No.");
        if Patient.Find('-') then
          begin
            exit;
          end;
        
        HMSSetup.Reset;
        HMSSetup.Get();
        NewCode:=NoSeriesMgt.GetNextNo(HMSSetup."Patient Nos",0D,true);
        Patient.Init;
          Patient."Patient No.":=NewCode;
          Patient."Patient Type":=Patient."patient type"::Student;
          Patient."Date Registered":=Today;
          Patient."Student No.":=Student."No.";
          Patient.Surname:=Student.Name;
          Patient.Gender:=Student.Gender;
          Patient."Date Of Birth":=Student."Date Of Birth";
          Patient."Marital Status":=Student."Marital Status";
          Patient."ID Number":=Student."ID No";
          Patient.Photo:=Student.Picture;
          Patient."Correspondence Address 1":=Student.Address;
          Patient."Correspondence Address 2":=Student."Address 2";
          Patient."Telephone No. 1":=Student."Phone No.";
          Patient."Fax No.":=Student."Fax No.";
          Patient.Email:=Student."E-Mail";
          Patient.Nationality:=Student.Citizenship;
          Patient.Religion:=Student.Religion;
        Patient.Insert();

    end;


    procedure CopyEmployeeToHMS()
    begin
        /*This function copies the employees from the hr module to the hospital management module*/
        Employee.Reset;
        if Employee.Find('-') then
          begin
            repeat
            /*Check if the patient exists already in the database*/
            PatientRec.Reset;
            PatientRec.SetRange(PatientRec."Patient Type",PatientRec."patient type"::Employee);
            PatientRec.SetRange(PatientRec."Employee No.",Employee."No.");
            if PatientRec.Find('-') then
              begin
                /*Patient exists hence do nothing*/
              end
            else
              begin
                /*Patient is new*/
                 HMSSetup.Reset;
                 HMSSetup.Get();
                 NewPatientCode:=NoSeriesMgt.GetNextNo(HMSSetup."Patient Nos",0D,true);
                 PatientRec.Init;
                  PatientRec."Patient No.":=NewPatientCode;
                  PatientRec."Patient Type":=PatientRec."patient type"::Employee;
                  PatientRec."Date Registered":=Today;
                  PatientRec."Employee No.":=Employee."No.";
                  PatientRec.Title:=Format(Employee.Title);
                  PatientRec.Surname:=Employee."First Name";
                  PatientRec."Middle Name":=Employee."Middle Name";
                  PatientRec."Last Name":=Employee."Last Name";
                  PatientRec.Gender:=Employee.Gender;
                  PatientRec."Date Of Birth":=Employee."Date Of Birth";
                  PatientRec."Marital Status":=Employee."Marital Status";
                  PatientRec."ID Number":=Employee."ID Number";
                  PatientRec.Photo:=Employee.Picture;
                  PatientRec.Email:=Employee."E-Mail";
                  PatientRec."Telephone No. 1":=Employee."Home Phone Number" +',' + Employee."Cellular Phone Number";
                  PatientRec."Telephone No. 2":=Employee."Work Phone Number" +',' + Employee."Ext.";
                  PatientRec."Correspondence Address 1":=Employee."Postal Address";
                  PatientRec."Correspondence Address 2":=Employee."Residential Address";
                  PatientRec."Correspondence Address 3":=Employee.City + ',' + Employee."Post Code";
                  PatientRec."Fax No.":=Employee."Fax Number";
                 PatientRec.Insert();
              end;
            until Employee.Next=0;
          end;

    end;


    procedure CopyDependantToHMS()
    begin
        /*This function copies the departments from the hr module to the hospital management module*/
        Relative.Reset;
        if Relative.Find('-') then
          begin
          repeat
            /*Check if the patient exists already in the database*/
            PatientRec.Reset;
            PatientRec.SetRange(PatientRec."Patient Type",PatientRec."patient type"::Employee);
            PatientRec.SetRange(PatientRec."Employee No.",Relative."Employee Code");
            PatientRec.SetRange(PatientRec.Surname,Relative.SurName);
            PatientRec.SetRange(PatientRec."Last Name",Relative."Other Names");
            if PatientRec.Find('-') then
              begin
                /*Patient exists hence do nothing*/
              end
            else
              begin
                /*Patient is new*/
                 HMSSetup.Reset;
                 HMSSetup.Get();
                 NewPatientCode:=NoSeriesMgt.GetNextNo(HMSSetup."Patient Nos",0D,true);
                 PatientRec.Init;
                  PatientRec."Patient No.":=NewPatientCode;
                  PatientRec."Patient Type":=PatientRec."patient type"::Dependant;
                  PatientRec."Date Registered":=Today;
                  PatientRec."Employee No.":=Relative."Employee Code";
        //          PatientRec."Relative No.":=Relative."Line No.";
                  PatientRec.Surname:=Relative.SurName;
                  PatientRec."Last Name":=Relative."Other Names";
                  PatientRec."Telephone No. 1":=Relative."Office Tel No";
                  PatientRec."Telephone No. 2":=Relative."Home Tel No";
                  PatientRec."Correspondence Address 1":=Relative.Address;
        //          PatientRec."Correspondence Address 2":=Relative."Postal Address2";
          //        PatientRec."Correspondence Address 3":=Relative."Postal Address3";
                  PatientRec.Blocked:=true;
                 PatientRec.Insert();
              end;
            until Relative.Next=0;
          end;

    end;


    procedure CopyBeneficiarytToHMS()
    begin
        /*This function copies the departments from the hr module to the hospital management module*/
        Benf.Reset;
        if Benf.Find('-') then
          begin
          repeat
            /*Check if the patient exists already in the database*/
            PatientRec.Reset;
            PatientRec.SetRange(PatientRec."Patient Type",PatientRec."patient type"::Employee);
            PatientRec.SetRange(PatientRec."Employee No.",Benf."Employee Code");
            PatientRec.SetRange(PatientRec.Surname,Benf.SurName);
            PatientRec.SetRange(PatientRec."Last Name",Benf."Other Names");
            if PatientRec.Find('-') then
              begin
                /*Patient exists hence do nothing*/
              end
            else
              begin
                /*Patient is new*/
                 HMSSetup.Reset;
                 HMSSetup.Get();
                 NewPatientCode:=NoSeriesMgt.GetNextNo(HMSSetup."Patient Nos",0D,true);
                 PatientRec.Init;
                  PatientRec."Patient No.":=NewPatientCode;
                  PatientRec."Patient Type":=PatientRec."patient type"::Dependant;
                  PatientRec."Date Registered":=Today;
                  PatientRec."Employee No.":=Benf."Employee Code";
        //          PatientRec."Relative No.":=Relative."Line No.";
                  PatientRec.Surname:=Benf.SurName;
                  PatientRec."Last Name":=Benf."Other Names";
                  PatientRec."Telephone No. 1":=Benf."Office Tel No";
                  PatientRec."Telephone No. 2":=Benf."Home Tel No";
                  PatientRec."Correspondence Address 1":=Benf.Address;
                  PatientRec."Date Of Birth":=Benf."Date Of Birth";
        //PatientRec."Correspondence Address 2":=Relative."Postal Address2";
          //
          //PatientRec."Correspondence Address 3":=Relative."Postal Address3";
                  PatientRec.Blocked:=true;
                 PatientRec.Insert();
              end;
            until Benf.Next=0;
          end;

    end;
}

