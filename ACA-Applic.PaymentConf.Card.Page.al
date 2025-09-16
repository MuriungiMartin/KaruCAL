#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68492 "ACA-Applic. Payment Conf. Card"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = UnknownTable61358;
    SourceTableView = where(Status=filter("Provisional Admission"),
                            "Documents Verified"=filter(Yes),
                            "Payments Verified"=filter(No));

    layout
    {
        area(content)
        {
            group("General Information")
            {
                Editable = false;
                field("Application No.";"Application No.")
                {
                    ApplicationArea = Basic;
                }
                field("Application Date";"Application Date")
                {
                    ApplicationArea = Basic;
                }
                field("Enquiry No";"Enquiry No")
                {
                    ApplicationArea = Basic;
                }
                field("Application Form Receipt No.";"Application Form Receipt No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Receipt No.';

                    trigger OnValidate()
                    begin
                        //Check if the receipt number is valid or not
                        exit;
                        CustEntry.Reset;
                        //CustEntry.SETRANGE(CustEntry."Source Code",'CASHRECJNL');
                        CustEntry.SetRange(CustEntry."Document No.","Application Form Receipt No.");
                        if CustEntry.Find('-') then //record has been located in the database
                          begin
                            /*Check if the receipt number has been used by another student*/
                              Apps.Reset;
                              Apps.SetRange(Apps."Application Form Receipt No.","Application Form Receipt No.");
                              if Apps.Find('-') then
                                begin
                                  repeat
                                    if Apps."Application No."<>"Application No." then
                                      begin
                                        Error('Receipt Number already utilised within the System by Application No.' +Format(Apps."Application No."));
                                      end;
                                  until Apps.Next=0;
                                end;
                          end
                        else//record not located within the database
                          begin
                            Error('Receipt Number not located within Valid Receipts');
                          end;

                    end;
                }
                field(Campus;Campus)
                {
                    ApplicationArea = Basic;
                }
                field("Intake Code";"Intake Code")
                {
                    ApplicationArea = Basic;
                }
                field("Academic Year";"Academic Year")
                {
                    ApplicationArea = Basic;
                }
                field("Mode of Study";"Mode of Study")
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

                    trigger OnValidate()
                    begin
                        /*Display the age of the user*/
                        Age:=GetAge("Date Of Birth");

                    end;
                }
                field(Age;Age)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Gender;Gender)
                {
                    ApplicationArea = Basic;
                }
                field("Marital Status";"Marital Status")
                {
                    ApplicationArea = Basic;
                }
                field("ID Number";"ID Number")
                {
                    ApplicationArea = Basic;
                }
                field(Nationality;Nationality)
                {
                    ApplicationArea = Basic;
                    Caption = 'Nationality';

                    trigger OnValidate()
                    begin
                        /*Get the name of the country of nationality*/
                        NationalityName:=GetCountry(Nationality);

                    end;
                }
                field(NationalityName;NationalityName)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(County;County)
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        /*Get the name of the country of nationality*/
                        CountryOfOriginName:=GetCounty(County);

                    end;
                }
                field(CountryOfOriginName;CountryOfOriginName)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Settlement Type";"Settlement Type")
                {
                    ApplicationArea = Basic;
                }
            }
            group("Payments Details")
            {
                Caption = 'Payments Details';
                field("Receipt Slip No.";"Receipt Slip No.")
                {
                    ApplicationArea = Basic;
                }
                field("Date Of Receipt Slip";"Date Of Receipt Slip")
                {
                    ApplicationArea = Basic;
                }
            }
            group("Correspondence Address")
            {
                Editable = false;
                field("Address for Correspondence1";"Address for Correspondence1")
                {
                    ApplicationArea = Basic;
                    Caption = 'Address 1';
                }
                field("Address for Correspondence2";"Address for Correspondence2")
                {
                    ApplicationArea = Basic;
                    Caption = 'Address 2';
                }
                field("Address for Correspondence3";"Address for Correspondence3")
                {
                    ApplicationArea = Basic;
                    Caption = 'Address 3';
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
            }
            group("First Choice")
            {
                Editable = true;
                field("First Degree Choice";"First Degree Choice")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        /*Display the name of the programme*/
                        //DegreeName1:=GetDegree("First Degree Choice");
                        recProgramme.Reset;
                        if recProgramme.Get("First Degree Choice") then
                          begin
                           DegreeName1:=recProgramme.Description;
                            School1:=recProgramme."School Code";
                            FacultyName1:=GetFaculty("First Degree Choice");
                          end;

                    end;
                }
                field(DegreeName1;DegreeName1)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(School1;School1)
                {
                    ApplicationArea = Basic;
                    Caption = 'Faculty';
                    Editable = false;
                }
                field(FacultyName1;FacultyName1)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("First Choice Stage";"First Choice Stage")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        FirstChoiceStageName:=GetStageName("First Choice Stage");
                    end;
                }
                field(FirstChoiceStageName;FirstChoiceStageName)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("First Choice Semester";"First Choice Semester")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        FirstChoiceSemesterName:=GetSemesterName("First Choice Semester");
                    end;
                }
                field(FirstChoiceSemesterName;FirstChoiceSemesterName)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
            group("Second Choice")
            {
                Editable = false;
                field("Second Degree Choice";"Second Degree Choice")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        /*Display the programme name*/
                        //DegreeName2:=GetDegree("Second Degree Choice");
                        recProgramme.Reset;
                        if recProgramme.Get("Second Degree Choice") then
                          begin
                            "School 2":=recProgramme."School Code";
                            FacultyName2:=GetFaculty("Second Degree Choice");
                          end;

                    end;
                }
                field("School 2";"School 2")
                {
                    ApplicationArea = Basic;
                    Caption = 'Faculty';
                    Editable = false;
                }
                field("Second Choice Stage";"Second Choice Stage")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        SecondChoiceStageName:=GetStageName("Second Choice Stage");
                    end;
                }
                field("Second Choice Semester";"Second Choice Semester")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        SecondChoiceStageName:=GetSemesterName("Second Choice Semester");
                    end;
                }
            }
            group(Qualifications)
            {
                Editable = false;
                field("Former School Code";"Former School Code")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        /*Display the name of the former school*/
                        FormerSchoolName:=GetFormerSchool("Former School Code");

                    end;
                }
                field(FormerSchoolName;FormerSchoolName)
                {
                    ApplicationArea = Basic;
                    Editable = false;
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
                field(Examination;Examination)
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
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
                }
                field("Index Number";"Index Number")
                {
                    ApplicationArea = Basic;
                }
                field("Mean Grade Acquired";"Mean Grade Acquired")
                {
                    ApplicationArea = Basic;
                    Visible = "Mean Grade AcquiredVisible";
                }
                field("Principal Passes";"Principal Passes")
                {
                    ApplicationArea = Basic;
                    Visible = "Principal PassesVisible";
                }
                field("Subsidiary Passes";"Subsidiary Passes")
                {
                    ApplicationArea = Basic;
                    Visible = "Subsidiary PassesVisible";
                }
                field("Points Acquired";"Points Acquired")
                {
                    ApplicationArea = Basic;
                    Visible = "Points AcquiredVisible";
                }
            }
            group(Recommendations)
            {
                Editable = false;
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    Caption = 'Approval Status';
                    Editable = false;
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


    procedure GetDegree(var DegreeCode: Code[20]) DegreeName: Text[100]
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
        //DegreeName1:=GetDegree("First Degree Choice");
        //DegreeName2:=GetDegree("Second Degree Choice");
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
        AdminSetup.SetRange(AdminSetup.Degree,"First Degree Choice");
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
                Campus:=Rec.Campus;
                "Marital Status":=Rec."Marital Status";
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

