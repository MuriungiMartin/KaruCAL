#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68522 "ACA-Pending Payments List"
{
    CardPageID = "ACA-Applic. Payment Conf. Card";
    PageType = List;
    SourceTable = UnknownTable61358;
    SourceTableView = where(Status=filter("Provisional Admission"),
                            "Documents Verified"=filter(Yes),
                            "Payments Verified"=filter(No));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Application No.";"Application No.")
                {
                    ApplicationArea = Basic;
                }
                field("Admission No";"Admission No")
                {
                    ApplicationArea = Basic;
                }
                field(Date;Date)
                {
                    ApplicationArea = Basic;
                }
                field("Application Date";"Application Date")
                {
                    ApplicationArea = Basic;
                }
                field(Surname;Surname)
                {
                    ApplicationArea = Basic;
                }
                field("Other Names";"Other Names")
                {
                    ApplicationArea = Basic;
                }
                field("Date Of Birth";"Date Of Birth")
                {
                    ApplicationArea = Basic;
                }
                field(Gender;Gender)
                {
                    ApplicationArea = Basic;
                }
                field("Marital Status";"Marital Status")
                {
                    ApplicationArea = Basic;
                }
                field(Nationality;Nationality)
                {
                    ApplicationArea = Basic;
                }
                field("Country of Origin";"Country of Origin")
                {
                    ApplicationArea = Basic;
                }
                field("Address for Correspondence1";"Address for Correspondence1")
                {
                    ApplicationArea = Basic;
                }
                field("Address for Correspondence2";"Address for Correspondence2")
                {
                    ApplicationArea = Basic;
                }
                field("Address for Correspondence3";"Address for Correspondence3")
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
                field("First Degree Choice";"First Degree Choice")
                {
                    ApplicationArea = Basic;
                }
                field(School1;School1)
                {
                    ApplicationArea = Basic;
                }
                field("Second Degree Choice";"Second Degree Choice")
                {
                    ApplicationArea = Basic;
                }
                field("School 2";"School 2")
                {
                    ApplicationArea = Basic;
                }
                field("Date of Receipt";"Date of Receipt")
                {
                    ApplicationArea = Basic;
                }
                field("User ID";"User ID")
                {
                    ApplicationArea = Basic;
                }
                field(County;County)
                {
                    ApplicationArea = Basic;
                }
                field("Former School Code";"Former School Code")
                {
                    ApplicationArea = Basic;
                }
                field("Date of Admission";"Date of Admission")
                {
                    ApplicationArea = Basic;
                }
                field("Date of Completion";"Date of Completion")
                {
                    ApplicationArea = Basic;
                }
                field("Year of Examination";"Year of Examination")
                {
                    ApplicationArea = Basic;
                }
                field("Examination Body";"Examination Body")
                {
                    ApplicationArea = Basic;
                }
                field("Mean Grade Acquired";"Mean Grade Acquired")
                {
                    ApplicationArea = Basic;
                }
                field("Points Acquired";"Points Acquired")
                {
                    ApplicationArea = Basic;
                }
                field("Principal Passes";"Principal Passes")
                {
                    ApplicationArea = Basic;
                }
                field("Subsidiary Passes";"Subsidiary Passes")
                {
                    ApplicationArea = Basic;
                }
                field(Examination;Examination)
                {
                    ApplicationArea = Basic;
                }
                field("Application Form Receipt No.";"Application Form Receipt No.")
                {
                    ApplicationArea = Basic;
                }
                field("Index Number";"Index Number")
                {
                    ApplicationArea = Basic;
                }
                field("No. Series";"No. Series")
                {
                    ApplicationArea = Basic;
                }
                field("HOD User ID";"HOD User ID")
                {
                    ApplicationArea = Basic;
                }
                field("HOD Date";"HOD Date")
                {
                    ApplicationArea = Basic;
                }
                field("HOD Time";"HOD Time")
                {
                    ApplicationArea = Basic;
                }
                field("HOD Recommendations";"HOD Recommendations")
                {
                    ApplicationArea = Basic;
                }
                field("Dean User ID";"Dean User ID")
                {
                    ApplicationArea = Basic;
                }
                field("Dean Date";"Dean Date")
                {
                    ApplicationArea = Basic;
                }
                field("Dean Time";"Dean Time")
                {
                    ApplicationArea = Basic;
                }
                field("Dean Recommendations";"Dean Recommendations")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
                field(Select;Select)
                {
                    ApplicationArea = Basic;
                }
                field("Batch No.";"Batch No.")
                {
                    ApplicationArea = Basic;
                }
                field("Batch Date";"Batch Date")
                {
                    ApplicationArea = Basic;
                }
                field("Batch Time";"Batch Time")
                {
                    ApplicationArea = Basic;
                }
                field("Admission Board Recommendation";"Admission Board Recommendation")
                {
                    ApplicationArea = Basic;
                }
                field("Admission Board Date";"Admission Board Date")
                {
                    ApplicationArea = Basic;
                }
                field("Admission Board Time";"Admission Board Time")
                {
                    ApplicationArea = Basic;
                }
                field("Admitted Degree";"Admitted Degree")
                {
                    ApplicationArea = Basic;
                }
                field("Admitted Department";"Admitted Department")
                {
                    ApplicationArea = Basic;
                }
                field("Deferred Until";"Deferred Until")
                {
                    ApplicationArea = Basic;
                }
                field("Date Of Meeting";"Date Of Meeting")
                {
                    ApplicationArea = Basic;
                }
                field("Date Of Receipt Slip";"Date Of Receipt Slip")
                {
                    ApplicationArea = Basic;
                }
                field("Receipt Slip No.";"Receipt Slip No.")
                {
                    ApplicationArea = Basic;
                }
                field("Academic Year";"Academic Year")
                {
                    ApplicationArea = Basic;
                }
                field("Admitted To Stage";"Admitted To Stage")
                {
                    ApplicationArea = Basic;
                }
                field("Admitted Semester";"Admitted Semester")
                {
                    ApplicationArea = Basic;
                }
                field("First Choice Stage";"First Choice Stage")
                {
                    ApplicationArea = Basic;
                }
                field("First Choice Semester";"First Choice Semester")
                {
                    ApplicationArea = Basic;
                }
                field("Second Choice Stage";"Second Choice Stage")
                {
                    ApplicationArea = Basic;
                }
                field("Second Choice Semester";"Second Choice Semester")
                {
                    ApplicationArea = Basic;
                }
                field("Intake Code";"Intake Code")
                {
                    ApplicationArea = Basic;
                }
                field("Settlement Type";"Settlement Type")
                {
                    ApplicationArea = Basic;
                }
                field("ID Number";"ID Number")
                {
                    ApplicationArea = Basic;
                }
                field("Date Sent for Approval";"Date Sent for Approval")
                {
                    ApplicationArea = Basic;
                }
                field("Issued Date";"Issued Date")
                {
                    ApplicationArea = Basic;
                }
                field("Post Graduate";"Post Graduate")
                {
                    ApplicationArea = Basic;
                }
                field(Email;Email)
                {
                    ApplicationArea = Basic;
                }
                field(Campus;Campus)
                {
                    ApplicationArea = Basic;
                }
                field("Admissable Status";"Admissable Status")
                {
                    ApplicationArea = Basic;
                }
                field("Mode of Study";"Mode of Study")
                {
                    ApplicationArea = Basic;
                }
                field("Enquiry No";"Enquiry No")
                {
                    ApplicationArea = Basic;
                }
                field("Responsibility Center";"Responsibility Center")
                {
                    ApplicationArea = Basic;
                }
                field("Admit/NotAdmit";"Admit/NotAdmit")
                {
                    ApplicationArea = Basic;
                }
                field("Documents Verified";"Documents Verified")
                {
                    ApplicationArea = Basic;
                }
                field("Documents Verification Remarks";"Documents Verification Remarks")
                {
                    ApplicationArea = Basic;
                }
                field("Medical Verified";"Medical Verified")
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
            group(Documents)
            {
                Caption = 'Documents';
                action("Academic Background Subjects")
                {
                    ApplicationArea = Basic;
                    Caption = 'Academic Background Subjects';
                    Image = History;
                    Promoted = false;
                    RunObject = Page "ACA-Application Form Academic";
                    RunPageLink = "Application No."=field("Application No.");
                }
                action("Professional Qualifications")
                {
                    ApplicationArea = Basic;
                    Caption = 'Professional Qualifications';
                    Image = ProfileCalender;
                    Promoted = false;
                    RunObject = Page "ACA-Application Form Qualif.";
                    RunPageLink = "Application No."=field("Application No.");
                }
                action("Employment History")
                {
                    ApplicationArea = Basic;
                    Caption = 'Employment History';
                    Image = Employee;
                    Promoted = false;
                    RunObject = Page "ACA-Application Form Employ.";
                    RunPageLink = "Application No."=field("Application No.");
                }
                action("Academic Referees")
                {
                    ApplicationArea = Basic;
                    Caption = 'Academic Referees';
                    Image = CustomerContact;
                    Promoted = false;
                    RunObject = Page "ACA-Application Form Acad. Ref";
                    RunPageLink = "Application No."=field("Application No.");
                }
            }
        }
        area(processing)
        {
            group("&Functions")
            {
                Caption = '&Functions';
                action("Generate Reg. No")
                {
                    ApplicationArea = Basic;
                    Caption = 'Generate Reg. No';
                    Image = Filed;
                    Promoted = true;

                    trigger OnAction()
                    begin
                        /*Send the current record to the department approval stage*/
                        if Confirm('Take Admission to Admissions Listings?',true)=false then begin exit end;
                        /*Check if the receipt slip no is entered*/
                        /*
                        IF "Receipt Slip No."='' THEN
                          BEGIN
                           ERROR('Please ensure that the Bank Deposit slip number is inserted');
                          END;
                        {Check if the slip date is inserted}
                        IF "Date Of Receipt Slip"=0D THEN
                          BEGIN
                            ERROR('Please ensure that the Bank Deposit Slip Date is inserted');
                          END;
                         */
                        /*This function transfers the details of the applicant to the admissions database table*/
                        
                        TransferToAdmission(Rec."Admission No");
                        Rec.Status:=Rec.Status::Approved;
                        Validate(Status);
                        "Documents Verified":=true;
                        "Payments Verified":=true;
                        Rec.Modify;
                        Message('Send to pending Admissions confirmation.');

                    end;
                }
            }
        }
    }

    var
        DegreeName1: Text[200];
        DegreeName2: Text[200];
        FacultyName1: Text[200];
        FacultyName2: Text[200];
        NationalityName: Text[200];
        CountryOfOriginName: Text[200];
        Age: Text[200];
        FormerSchoolName: Text[200];
        CustEntry: Record "Cust. Ledger Entry";
        Apps: Record UnknownRecord61358;
        recProgramme: Record UnknownRecord61511;
        FirstChoiceSemesterName: Text[200];
        FirstChoiceStageName: Text[200];
        SecondChoiceSemesterName: Text[200];
        SecondChoiceStageName: Text[200];
        [InDataSet]
        "Principal PassesVisible": Boolean;
        [InDataSet]
        "Subsidiary PassesVisible": Boolean;
        [InDataSet]
        "Mean Grade AcquiredVisible": Boolean;
        [InDataSet]
        "Points AcquiredVisible": Boolean;
        UserMgt: Codeunit "HMS Patient Treatment Mgt";
        Doc_Type: Option LPO,Requisition,Imprest,"Payment Voucher";
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,Admission;
        ApprovalEntries: Page "Approval Entries";
        AppSetup: Record UnknownRecord61367;
        SettlmentType: Record UnknownRecord61522;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Admissions: Record UnknownRecord61372;
        ApplicationSubject: Record UnknownRecord61362;
        AdmissionSubject: Record UnknownRecord61375;
        LineNo: Integer;
        PrintAdmission: Boolean;
        MedicalCondition: Record UnknownRecord61379;
        Immunization: Record UnknownRecord61380;
        AdmissionMedical: Record UnknownRecord61376;
        AdmissionImmunization: Record UnknownRecord61378;
        AdmissionFamily: Record UnknownRecord61377;


    procedure GetCountry(var CountryCode: Code[20]) CountryName: Text[100]
    var
        Country: Record "Country/Region";
    begin
        /*This function gets the country name from the database and returns the resultant string value*/
        Country.Reset;
        if Country.Get(CountryCode) then
          begin
            CountryName:=Country.Name;
          end
        else
          begin
            CountryName:='';
          end;

    end;


    procedure GetDegree1(var DegreeCode: Code[20]) DegreeName: Text[100]
    var
        Programme: Record UnknownRecord61511;
    begin
        /*This function gets the programme name and returns the resultant string*/
        Programme.Reset;
        if Programme.Get(DegreeCode) then
          begin
            DegreeName:=Programme.Description;
          end
        else
          begin
            DegreeName:='';
          end;

    end;


    procedure GetFaculty(var DegreeCode: Code[20]) FacultyName: Text[100]
    var
        Programme: Record UnknownRecord61511;
        DimVal: Record "Dimension Value";
    begin
        /*The function gets and returns the faculty name to the calling client*/
        FacultyName:='';
        Programme.Reset;
        if Programme.Get(DegreeCode) then
          begin
            DimVal.Reset;
            DimVal.SetRange(DimVal."Dimension Code",'FACULTY');
        //    DimVal.SETRANGE(DimVal.Code,Programme."Base Date");
            if DimVal.Find('-') then
              begin
                FacultyName:=DimVal.Name;
              end;
          end;

    end;


    procedure GetAge(var StartDate: Date) AgeText: Text[100]
    var
        HrDates: Codeunit "HR Dates";
    begin
        /*This function gets the age of the applicant and returns the resultant age to the calling client*/
        AgeText:='';
        if StartDate=0D then begin StartDate:=Today end;
        AgeText := HrDates.DetermineAge(StartDate,Today);

    end;


    procedure GetFormerSchool(var FormerSchoolCode: Code[20]) FormerSchoolName: Text[30]
    var
        FormerSchool: Record UnknownRecord61366;
    begin
        /*This function gets the description of the former school and returns the result to the calling client*/
        FormerSchool.Reset;
        FormerSchoolName:='';
        if FormerSchool.Get(FormerSchoolCode) then
          begin
            FormerSchoolName:=FormerSchool.Description;
          end;

    end;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        Age:=GetAge("Date Of Birth");
        NationalityName:=GetCountry(Nationality);
        CountryOfOriginName:=GetCountry("Country of Origin");
        DegreeName1:=GetDegree1("First Degree Choice");
        DegreeName2:=GetDegree1("Second Degree Choice");
        FacultyName1:=GetFaculty("First Degree Choice");
        FacultyName2:=GetFaculty("Second Degree Choice");
        FormerSchoolName:=GetFormerSchool("Former School Code");
        if (Examination=Examination::KCSE) or (Examination=Examination::KCE) or (Examination=Examination::EACE) then
          begin
            "Principal PassesVisible" :=false;
            "Subsidiary PassesVisible" :=false;
            "Mean Grade AcquiredVisible" :=true;
            "Points AcquiredVisible" :=true;
          end
        else
          begin
            "Principal PassesVisible" :=true;
            "Subsidiary PassesVisible" :=true;
            "Mean Grade AcquiredVisible" :=false;
            "Points AcquiredVisible" :=false;
          end;
    end;


    procedure GetStageName(var StageCode: Code[20]) StageName: Text[200]
    var
        Stage: Record UnknownRecord61516;
    begin
        Stage.Reset;
        Stage.SetRange(Stage.Code,StageCode);
        if Stage.Find('-') then
          begin
            StageName:=Stage.Description;
          end;
    end;


    procedure GetSemesterName(var SemesterCode: Code[20]) SemesterName: Text[200]
    var
        Semester: Record UnknownRecord61692;
    begin
        Semester.Reset;
        Semester.SetRange(Semester.Code,SemesterCode);
        if Semester.Find('-') then
          begin
            SemesterName:=Semester.Description;
          end;
    end;


    procedure GetCounty(var CountyCode: Code[20]) CountyName: Text[100]
    var
        CountySetup: Record UnknownRecord61365;
    begin
        /*This function gets the county name from the database and returns the resultant string value*/
        CountySetup.Reset;
        if CountySetup.Get(CountyCode) then
          begin
            CountyName:=CountySetup.Description;
          end
        else
          begin
            CountyName:='';
          end;

    end;


    procedure TransferToAdmission(var AdmissionNumber: Code[20])
    var
        AdminSetup: Record UnknownRecord61371;
        NewAdminCode: Code[20];
    begin
        /*This function transfers the fieldsin the application to the fields in the admissions table*/
        /*Get the new admission code for the selected application*/
        TestField("Settlement Type");
        SettlmentType.Get("Settlement Type");
        if AdmissionNumber='' then begin
        AdminSetup.Reset;
        AdminSetup.SetRange(AdminSetup.Degree,"Admitted Degree");
        if AdminSetup.Find('-') then
          begin
            NewAdminCode:=NoSeriesMgt.GetNextNo(AdminSetup."No. Series",0D,true);
            NewAdminCode:=AdminSetup."Programme Prefix" +  '/' + NewAdminCode +'/' + AdminSetup.Year;
        
            //If Prefix is Needed add this code <<+ AdminSetup."SSP Prefix" >>
          end
        else
          begin
            Error('The Admission Number Setup For Programme ' +Format("Admitted Degree") + ' Does Not Exist');
          end;
          end else NewAdminCode:=AdmissionNumber;
        
        /*Get the record and transfer the details to the admissions database*/
        //ERROR('TEST- '+NewAdminCode);
        with Admissions do
          begin
            /*Transfer the details into the admission database table*/
              Init;
                "Admission No.":=NewAdminCode;
                Validate("Admission No.");
                Date:=Today;
                "Application No.":=Rec."Application No.";
                "Admission Type":=Rec."Settlement Type";
                "Academic Year":=Rec."Academic Year";
                Surname:=Rec.Surname;
                "Other Names":=Rec."Other Names";
                Status:=Status::New;
                "Degree Admitted To":=Rec."Admitted Degree";
                Validate("Degree Admitted To");
                "Date Of Birth":=Rec."Date Of Birth";
                Gender:=Rec.Gender+1;
                "Marital Status":=Rec."Marital Status";
                Campus:=Rec.Campus;
                Nationality:=Rec.Nationality;
                "Correspondence Address 1":=Rec."Address for Correspondence1";
                "Correspondence Address 2":=Rec."Address for Correspondence2";
                "Correspondence Address 3":=Rec."Address for Correspondence3";
                "Telephone No. 1":=Rec."Telephone No. 1";
                "Telephone No. 2":=Rec."Telephone No. 2";
                "Former School Code":=Rec."Former School Code";
                "Index Number":=Rec."Index Number";
                "Stage Admitted To":=Rec."Admitted To Stage";
                "Semester Admitted To":= Rec."Admitted Semester";
                "Settlement Type":=Rec."Settlement Type";
                "Intake Code":=Rec."Intake Code";
                "ID Number":="ID Number";
              Insert();
                Rec."Admission No":=NewAdminCode;
          end;
        /*Get the subject details and transfer the  same to the admissions subject*/
        ApplicationSubject.Reset;
        ApplicationSubject.SetRange(ApplicationSubject."Application No.",Rec."Application No.");
        if ApplicationSubject.Find('-') then
          begin
            /*Get the last number in the admissions table*/
            AdmissionSubject.Reset;
            if AdmissionSubject.Find('+') then
              begin
                LineNo:=AdmissionSubject."Line No."+1;
              end
            else
              begin
                LineNo:=1;
              end;
        
          /*Insert the new records into the database table*/
          repeat
            with AdmissionSubject do
              begin
                Init;
                "Line No.":=LineNo +1;
                "Admission No.":=NewAdminCode;
                "Subject Code":=ApplicationSubject."Subject Code";
                Grade:=Grade;
                Insert();
                LineNo:=LineNo + 1;
              end;
           until ApplicationSubject.Next=0;
          end;
        /*Insert the medical conditions into the admission database table containing the medical condition*/
        MedicalCondition.Reset;
        MedicalCondition.SetRange(MedicalCondition.Mandatory,true);
        if MedicalCondition.Find('-') then
          begin
            /*Get the last line number from the medical condition table for the admissions module*/
            AdmissionMedical.Reset;
            if AdmissionMedical.Find('+') then
              begin
                LineNo:=AdmissionMedical."Line No."+1;
              end
            else
              begin
                LineNo:=1;
              end;
            AdmissionMedical.Reset;
            /*Loop thru the medical conditions*/
            repeat
              AdmissionMedical.Init;
                AdmissionMedical."Line No.":=LineNo+ 1;
                AdmissionMedical."Admission No.":= NewAdminCode;
                AdmissionMedical."Medical Condition Code":=MedicalCondition.Code;
              AdmissionMedical.Insert();
                LineNo:=LineNo +1;
            until MedicalCondition.Next=0;
          end;
        /*Insert the details into the family table*/
        MedicalCondition.Reset;
        MedicalCondition.SetRange(MedicalCondition.Mandatory,true);
        MedicalCondition.SetRange(MedicalCondition.Family,true);
        if MedicalCondition.Find('-') then
          begin
            /*Get the last number in the family table*/
            AdmissionFamily.Reset;
            if AdmissionFamily.Find('+') then
              begin
                LineNo:=AdmissionFamily."Line No.";
              end
            else
              begin
                LineNo:=0;
              end;
            repeat
              AdmissionFamily.Init;
                AdmissionFamily."Line No.":=LineNo + 1;
                AdmissionFamily."Medical Condition Code":=MedicalCondition.Code;
                AdmissionFamily."Admission No.":= NewAdminCode ;
              AdmissionFamily.Insert();
              LineNo:=LineNo +1;
            until MedicalCondition.Next=0;
          end;
        
        /*Insert the immunization details into the database*/
        Immunization.Reset;
        //Immunization.SETRANGE(Immunization.Mandatory,TRUE);
        if Immunization.Find('-') then
          begin
            /*Get the last line number from the database*/
            AdmissionImmunization.Reset;
            if AdmissionImmunization.Find('+') then
              begin
                LineNo:=AdmissionImmunization."Line No."+1;
              end
            else
              begin
                LineNo:=1;
              end;
           /*loop thru the immunizations table adding the details into the admissions table for immunizations*/
           repeat
            AdmissionImmunization.Init;
              AdmissionImmunization."Line No.":=LineNo + 1;
              AdmissionImmunization."Admission No.":= NewAdminCode ;
              AdmissionImmunization."Immunization Code":=Immunization.Code;
            AdmissionImmunization.Insert();
           until Immunization.Next=0;
          end;

    end;
}

