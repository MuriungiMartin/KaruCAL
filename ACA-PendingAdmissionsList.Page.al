#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68483 "ACA-Pending Admissions List"
{
    CardPageID = "ACA-Applic. Documents Verif.";
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = UnknownTable61358;
    SourceTableView = where(Status=filter("Provisional Admission"),
                            "Documents Verified"=filter(No),
                            "Settlement Type"=filter(KUCCPS|NFM));

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
                field("Data Updated";"Data Updated")
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
                field("Receipt Slip No.";"Receipt Slip No.")
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
                    Promoted = true;
                    RunObject = Page "ACA-Application Form Academic";
                    RunPageLink = "Application No."=field("Application No.");
                }
                action("Professional Qualifications")
                {
                    ApplicationArea = Basic;
                    Caption = 'Professional Qualifications';
                    Image = ProfileCalender;
                    Promoted = true;
                    RunObject = Page "ACA-Application Form Qualif.";
                    RunPageLink = "Application No."=field("Application No.");
                }
                action("Employment History")
                {
                    ApplicationArea = Basic;
                    Caption = 'Employment History';
                    Image = Employee;
                    Promoted = true;
                    RunObject = Page "ACA-Application Form Employ.";
                    RunPageLink = "Application No."=field("Application No.");
                }
                action("Academic Referees")
                {
                    ApplicationArea = Basic;
                    Caption = 'Academic Referees';
                    Image = CustomerContact;
                    Promoted = true;
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
                action("Admit Student")
                {
                    ApplicationArea = Basic;
                    Caption = 'Admit Student';
                    Image = PostApplication;
                    Promoted = true;

                    trigger OnAction()
                    begin
                        /*Send the current record to the department approval stage*/
                        if Confirm('Mark as Documents Verified?',true)=false then begin exit end;
                        
                        TestField("Documents Verification Remarks");
                        //TESTFIELD("Receipt Slip No.");
                        TestField(County);
                        TestField("ID Number");
                        TestField("Date Of Birth");
                        
                        
                        
                        Rec.Status:=Rec.Status::Approved;
                        Validate(Status);
                        "Documents Verified":=true;
                        "Payments Verified":=true;
                        Modify;
                        
                        
                        TransferToAdmission(Rec."Admission No");
                        
                        Message('The Application has been sent to ''Pending Admission Confirmation''');

                    end;
                }
                action(UpdateData)
                {
                    ApplicationArea = Basic;
                    Caption = 'Update Data';
                    Image = UpdateDescription;
                    Promoted = true;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ACAApplicFormHeader: Record UnknownRecord61358;
                        KUCCPSImports: Record UnknownRecord70082;
                    begin
                        if Confirm('Update Data?',true) = false then Error('Updating cancelled by user');
                        Clear(ACAApplicFormHeader);
                        ACAApplicFormHeader.Reset;
                        ACAApplicFormHeader.SetRange("Data Updated",false);
                        if ACAApplicFormHeader.Find('-') then
                          Report.Run(99901,false,false,ACAApplicFormHeader);
                        Message('Data updated successfully!');
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
        FacultyName: Text[30];
        DegreeName: Text[200];
        AgeText: Text[100];
        ReligionName: Text[30];
        HasValue: Boolean;
        Cust: Record Customer;
        CourseRegistration: Record UnknownRecord61532;
        StudentKin: Record UnknownRecord61528;
        AdminKin: Record UnknownRecord61373;
        StudentGuardian: Record UnknownRecord61530;
        [InDataSet]
        "Guardian Full NameEnable": Boolean;
        [InDataSet]
        "Guardian OccupationEnable": Boolean;
        [InDataSet]
        "Spouse NameEnable": Boolean;
        [InDataSet]
        "Spouse Address 1Enable": Boolean;
        [InDataSet]
        "Spouse Address 2Enable": Boolean;
        [InDataSet]
        "Spouse Address 3Enable": Boolean;
        [InDataSet]
        "Family ProblemEnable": Boolean;
        [InDataSet]
        "Health ProblemEnable": Boolean;
        [InDataSet]
        "Overseas ScholarshipEnable": Boolean;
        [InDataSet]
        "Course Not PreferenceEnable": Boolean;
        [InDataSet]
        EmploymentEnable: Boolean;
        [InDataSet]
        "Other ReasonEnable": Boolean;
        Text19058780: label 'Acceptance of Offer/Non-Acceptance of Offer';
        Text19071252: label 'Ever suffered or had symptoms of the following';
        Text19025049: label 'Reasons for Non-Acceptance of Offer';
        Text19049741: label 'Medical details not covered by above';
        Text19069419: label 'Last School Attended and Address of School';
        Text19015920: label 'Family member ever suffered from';
        Text19012476: label 'Immunizations received';
        Text19059485: label 'Declaration Form In The Presence Of Parent/Guardian';
        Text19079474: label 'Part II (Completed by a medical practioner)';


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
        Customer: Record Customer;
        AdmformHeader: Record UnknownRecord61372;
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
          end else
          begin
            Error('The Admission Number Setup For Programme ' +Format("Admitted Degree") + ' Does Not Exist');
          end;
          end else NewAdminCode:=AdmissionNumber;
           Cust.Init;
                Cust."No.":=Rec."Admission No";
                Cust.Name:=CopyStr(Rec.Surname + ' ' + Rec."Other Names",1,80);
                Cust."Search Name":=UpperCase(CopyStr(Rec.Surname + ' ' + Rec."Other Names",1,80));
                Cust.Address:=Rec."Address for Correspondence1";
                if Rec."Address for Correspondence3"<>'' then
                Cust."Address 2":=CopyStr(Rec."Address for Correspondence2" + ',' +  Rec."Address for Correspondence3",1,30);
              //  IF Rec."Telephone No. 2"<>'' THEN
                Cust."Phone No.":=Rec."Telephone No. 1" ;
                //+ Rec."Telephone No. 2";
              //  Cust."Telex No.":=Rec."Fax No.";
        
                Cust."E-Mail":=Rec.Email;
                Cust.Gender:=Rec.Gender;
                Cust."Date Of Birth":=Rec."Date Of Birth";
                Cust."Date Registered":=Today;
                Cust."Customer Type":=Cust."customer type"::Student;
        //        Cust."Student Type":=FORMAT(Enrollment."Student Type");
        Cust."Date Of Birth":=Rec."Date Of Birth";
               // Cust."ID No":=Rec."ID Number";
                Cust."Application No." :=Rec."Admission No";
                Cust."Marital Status":=Rec."Marital Status";
                Cust.Citizenship:=Format(Rec.Nationality);
                Cust."Current Programme":=Rec."Admitted Degree";
                Cust."Current Semester":=Rec."Admitted Semester";
                Cust."Current Stage":=Rec."Admitted To Stage";
               // Cust.Religion:=FORMAT(Rec.Religion);
                Cust."Application Method":=Cust."application method"::"Apply to Oldest";
                Cust."Customer Posting Group":='STUDENT';
                Cust.Validate(Cust."Customer Posting Group");
                Cust."Gen. Bus. Posting Group":='LOCAL';
                Cust."ID No":=Rec."ID Number";
                Cust.Password:=Rec."ID Number";
                Cust."Changed Password":=true;
                Cust."Global Dimension 1 Code":=Rec.Campus;
                Cust.County:=Rec.County;
                Cust.Status:=Cust.Status::"New Admission";
                Customer.Reset;
                Customer.SetRange("No.",Rec."Admission No");
                if not Customer.FindFirst then
                Cust.Insert();
        
        ////////////////////////////////////////////////////////////////////////////////////////
        
          Cust.Reset;
          Cust.SetRange("No.",Rec."Admission No");
          Customer.SetFilter("Date Registered",'=%1',Today);
          if Cust.Find('-') then begin
                Cust.Status:=Cust.Status::"New Admission";
            if Rec.Gender=Rec.Gender::Female then begin
              Cust.Gender:=Cust.Gender::Female;
              end else begin
                 Cust.Gender:=Cust.Gender::Male;
                end;
                Cust.Modify;
                end;
        
         Cust.Reset;
          Cust.SetRange("No.",Rec."Admission No");
          Cust.SetFilter("Date Registered",'=%1',Today);
          if Cust.Find('-') then begin
          CourseRegistration.Reset;
          CourseRegistration.SetRange("Student No.",Rec."Admission No");
          CourseRegistration.SetRange("Settlement Type",Rec."Settlement Type");
          CourseRegistration.SetRange(Programme,Rec."First Degree Choice");
          CourseRegistration.SetRange(Semester,Rec."Admitted Semester");
          if not CourseRegistration.Find('-') then begin
                    CourseRegistration.Init;
                       CourseRegistration."Reg. Transacton ID":='';
                       CourseRegistration.Validate(CourseRegistration."Reg. Transacton ID");
                       CourseRegistration."Student No.":=Rec."Admission No";
                       CourseRegistration.Programme:=Rec."Admitted Degree";
                       CourseRegistration.Semester:=Rec."Admitted Semester";
                       CourseRegistration.Stage:=Rec."Admitted To Stage";
                       CourseRegistration."Year Of Study":=1;
                       CourseRegistration."Student Type":=CourseRegistration."student type"::"Full Time";
                       CourseRegistration."Registration Date":=Today;
                       CourseRegistration."Settlement Type":=Rec."Settlement Type";
                       CourseRegistration."Academic Year":=GetCurrYear();
        
                       //CourseRegistration.VALIDATE(CourseRegistration."Settlement Type");
                    CourseRegistration.Insert;
          CourseRegistration.Reset;
          CourseRegistration.SetRange("Student No.",Rec."Admission No");
          CourseRegistration.SetRange("Settlement Type",Rec."Settlement Type");
          CourseRegistration.SetRange(Programme,Rec."First Degree Choice");
          CourseRegistration.SetRange(Semester,Rec."Admitted Semester");
          if  CourseRegistration.Find('-') then begin
                    CourseRegistration."Settlement Type":=Rec."Settlement Type";
                    CourseRegistration.Validate(CourseRegistration."Settlement Type");
                    CourseRegistration."Academic Year":=GetCurrYear();
                    CourseRegistration."Registration Date":=Today;
                    CourseRegistration.Validate(CourseRegistration."Registration Date");
                    CourseRegistration.Modify;
        
                    end;
                    end else begin
                        CourseRegistration.Reset;
          CourseRegistration.SetRange("Student No.",Rec."Admission No");
          CourseRegistration.SetRange("Settlement Type",Rec."Settlement Type");
          CourseRegistration.SetRange(Programme,Rec."First Degree Choice");
          CourseRegistration.SetRange(Semester,Rec."Admitted Semester");
          CourseRegistration.SetFilter(Posted,'=%1',false);
          if  CourseRegistration.Find('-') then begin
                    CourseRegistration."Settlement Type":=Rec."Settlement Type";
                    CourseRegistration.Validate(CourseRegistration."Settlement Type");
                    CourseRegistration."Academic Year":=GetCurrYear();
                    CourseRegistration."Registration Date":=Today;
                    CourseRegistration.Validate(CourseRegistration."Registration Date");
                    CourseRegistration.Modify;
        
                    end;
                      end;
        
        ////Allocate Hostel
        CreateHostelBooking(Cust);
                    end;
        /*
                //insert the course registration details
                    CourseRegistration.RESET;
                    CourseRegistration.INIT;
                       CourseRegistration."Reg. Transacton ID":='';
                       CourseRegistration.VALIDATE(CourseRegistration."Reg. Transacton ID");
                       CourseRegistration."Student No.":=Rec."Admission No";
                       CourseRegistration.Programme:=Rec."Admitted Degree";
                       CourseRegistration.Semester:=Rec."Admitted Semester";
                       CourseRegistration.Stage:=Rec."Admitted To Stage";
                       CourseRegistration."Student Type":=CourseRegistration."Student Type"::"Full Time";
                       CourseRegistration."Registration Date":=TODAY;
                       CourseRegistration."Settlement Type":=Rec."Settlement Type";
                       CourseRegistration."Academic Year":=GetCurrYear();
        
                       //CourseRegistration.VALIDATE(CourseRegistration."Settlement Type");
                    CourseRegistration.INSERT;
        
                    CourseRegistration.RESET;
                    CourseRegistration.SETRANGE(CourseRegistration."Student No.",Admissions."Admission No.");
                    IF CourseRegistration.FIND('+') THEN BEGIN
                    CourseRegistration."Settlement Type":=Rec."Settlement Type";
                    CourseRegistration.VALIDATE(CourseRegistration."Settlement Type");
                    CourseRegistration."Academic Year":=GetCurrYear();
                    CourseRegistration."Registration Date":=TODAY;
                    CourseRegistration.VALIDATE(CourseRegistration."Registration Date");
                    CourseRegistration.MODIFY;
        
                    END;*/
        ////////////////////////////////////////////////////////////////////////////////////////
        
        /*Get the record and transfer the details to the admissions database*/
        //ERROR('TEST- '+NewAdminCode);
            /*Transfer the details into the admission database table*/
              Init;
                Admissions."Admission No.":=NewAdminCode;
                Admissions.Validate("Admission No.");
                Admissions.Date:=Today;
                Admissions."Application No.":=Rec."Application No.";
                Admissions."Admission Type":=Rec."Settlement Type";
                Admissions."Academic Year":=Rec."Academic Year";
                Admissions.Surname:=Rec.Surname;
                Admissions."Other Names":=Rec."Other Names";
                Admissions.Status:=Admissions.Status::Admitted;
                Admissions."Degree Admitted To":=Rec."Admitted Degree";
                Admissions.Validate("Degree Admitted To");
                Admissions."Date Of Birth":=Rec."Date Of Birth";
                Admissions.Gender:=Rec.Gender+1;
                Admissions."Marital Status":=Rec."Marital Status";
                Admissions.County:=Rec.County;
                Admissions.Campus:=Rec.Campus;
                Admissions.Nationality:=Rec.Nationality;
                Admissions."Correspondence Address 1":=Rec."Address for Correspondence1";
                Admissions."Correspondence Address 2":=Rec."Address for Correspondence2";
                Admissions."Correspondence Address 3":=Rec."Address for Correspondence3";
                Admissions."Telephone No. 1":=Rec."Telephone No. 1";
               Admissions."Telephone No. 2":=Rec."Telephone No. 2";
                Admissions."Former School Code":=Rec."Former School Code";
                Admissions."Index Number":=Rec."Index Number";
                Admissions."Stage Admitted To":=Rec."Admitted To Stage";
                Admissions."Semester Admitted To":= Rec."Admitted Semester";
                Admissions."Settlement Type":=Rec."Settlement Type";
                Admissions."Intake Code":=Rec."Intake Code";
                Admissions."ID Number":=Rec."ID Number";
                Admissions."E-Mail":=Rec.Email;
               // Admissions."Telephone No. 1":=Rec."Telephone No. 1";
               // Admissions."Telephone No. 2":=Rec."Telephone No. 1";
               AdmformHeader.Reset;
               AdmformHeader.SetRange("Application No.",Rec."Application No.");
               if not AdmformHeader.FindFirst then
              Admissions.Insert();
                Rec."Admission No":=NewAdminCode;
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
        
        TakeStudentToRegistration(NewAdminCode);

    end;


    procedure TakeStudentToRegistration(var AdmissNo: Code[20])
    begin
        Admissions.Reset;
        Admissions.SetRange("Admission No.",AdmissNo);
        if Admissions.Find('-') then begin
                  /*  Cust.INIT;
                Cust."No.":=Admissions."Admission No.";
                Cust.Name:=COPYSTR(Admissions.Surname + ' ' + Admissions."Other Names",1,30);
                Cust."Search Name":=UPPERCASE(COPYSTR(Admissions.Surname + ' ' + Admissions."Other Names",1,30));
                Cust.Address:=Admissions."Correspondence Address 1";
                Cust."Address 2":=COPYSTR(Admissions."Correspondence Address 2" + ',' +  Admissions."Correspondence Address 3",1,30);
                Cust."Phone No.":=Admissions."Telephone No. 1" + ',' + Admissions."Telephone No. 2";
                Cust."Telex No.":=Admissions."Fax No.";
                Cust."E-Mail":=Admissions."E-Mail";
                Cust.Gender:=Admissions.Gender;
                Cust."Date Of Birth":=Admissions."Date Of Birth";
                Cust."Date Registered":=TODAY;
                Cust."Customer Type":=Cust."Customer Type"::Student;
        //        Cust."Student Type":=FORMAT(Enrollment."Student Type");
        Cust."Date Of Birth":=Admissions."Date Of Birth";
                Cust."ID No":=Rec."ID Number";
                Cust."Application No." :=Admissions."Admission No.";
                Cust."Marital Status":=Admissions."Marital Status";
                Cust.Citizenship:=FORMAT(Admissions.Nationality);
                Cust.Religion:=FORMAT(Admissions.Religion);
                Cust."Application Method":=Cust."Application Method"::"Apply to Oldest";
                Cust."Customer Posting Group":='STUDENT';
                Cust.VALIDATE(Cust."Customer Posting Group");
                Cust."ID No":=Admissions."ID Number";
                Cust."Global Dimension 1 Code":=Admissions.Campus;
                Cust.County:=Admissions.County;
                Cust.INSERT();
                */
        
        
        
        
                //insert the details related to the next of kin of the student into the database
                    AdminKin.Reset;
                    AdminKin.SetRange(AdminKin."Admission No.",Admissions."Admission No.");
                    if AdminKin.Find('-') then
                        begin
                            repeat
                                StudentKin.Reset;
                                StudentKin.Init;
                                    StudentKin."Student No":=Admissions."Admission No.";
                                    StudentKin.Relationship:=AdminKin.Relationship;
                                    StudentKin.Name:=AdminKin."Full Name";
                                    //StudentKin."Other Names":=EnrollmentNextofKin."Other Names";
                                    //StudentKin."ID No/Passport No":=EnrollmentNextofKin."ID No/Passport No";
                                    //StudentKin."Date Of Birth":=EnrollmentNextofKin."Date Of Birth";
                                    //StudentKin.Occupation:=EnrollmentNextofKin.Occupation;
                                    StudentKin."Office Tel No":=AdminKin."Telephone No. 1";
                                    StudentKin."Home Tel No":=AdminKin."Telephone No. 2";
                                    //StudentKin.Remarks:=EnrollmentNextofKin.Remarks;
                                StudentKin.Insert;
                            until AdminKin.Next=0;
                        end;
        
                //insert the details in relation to the guardian/sponsor into the database in relation to the current student
                if Admissions."Mother Alive Or Dead"=Admissions."mother alive or dead"::Alive then
                        begin
                         if Admissions."Mother Full Name"<>'' then begin
                          StudentGuardian.Reset;
                          StudentGuardian.Init;
                          StudentGuardian."Student No.":=Admissions."Admission No.";
                          StudentGuardian.Names:=Admissions."Mother Full Name";
                          StudentGuardian.Insert;
                          end;
                        end;
                if Admissions."Father Alive Or Dead"=Admissions."father alive or dead"::Alive then
                        begin
                        if Admissions."Father Full Name"<>'' then begin
                          StudentGuardian.Reset;
                          StudentGuardian.Init;
                          StudentGuardian."Student No.":=Admissions."Admission No.";
                          StudentGuardian.Names:=Admissions."Father Full Name";
                          StudentGuardian.Insert;
                          end;
                        end;
                if Admissions."Guardian Full Name"<>'' then
                        begin
                        if Admissions."Guardian Full Name"<>'' then begin
                          StudentGuardian.Reset;
                          StudentGuardian.Init;
                          StudentGuardian."Student No.":=Admissions."Admission No.";
                          StudentGuardian.Names:=Admissions."Guardian Full Name";
                          StudentGuardian.Insert;
                          end;
                        end;
        
        /*
        
                //insert the details in relation to the student history as detailed in the application
                    EnrollmentEducationHistory.RESET;
                    EnrollmentEducationHistory.SETRANGE(EnrollmentEducationHistory."Enquiry No.",Enrollment."Enquiry No.");
                    IF EnrollmentEducationHistory.FIND('-') THEN
                        BEGIN
                            REPEAT
                                EducationHistory.RESET;
                                EducationHistory.INIT;
                                    EducationHistory."Student No.":=Rec."No.";
                                    EducationHistory.From:=EnrollmentEducationHistory.From;
                                    EducationHistory."To":=EnrollmentEducationHistory."To";
                                    EducationHistory.Qualifications:=EnrollmentEducationHistory.Qualifications;
                                    EducationHistory.Instituition:=EnrollmentEducationHistory.Instituition;
                                    EducationHistory.Remarks:=EnrollmentEducationHistory.Remarks;
                                    EducationHistory."Aggregate Result/Award":=EnrollmentEducationHistory."Aggregate Result/Award";
                                EducationHistory.INSERT;
                            UNTIL EnrollmentEducationHistory.NEXT=0;
                        END;
                //update the status of the application
                    Enrollment."Registration No":=Rec."No.";
                    Enrollment.Status:=Enrollment.Status::Admitted;
                    Enrollment.MODIFY;
        
         */
        end;

    end;


    procedure GetSchoolName(var SchoolCode: Code[20];var SchoolName: Text[30])
    var
        FormerSchool: Record UnknownRecord61366;
    begin
        /*Get the former school name and display the results*/
        FormerSchool.Reset;
        SchoolName:='';
        if FormerSchool.Get(SchoolCode) then
          begin
            SchoolName:=FormerSchool.Description;
          end;

    end;


    procedure GetDegreeName(var DegreeCode: Code[20];var DegreeName: Text[200])
    var
        Programme: Record UnknownRecord61511;
    begin
        /*get the degree name and display the results*/
        Programme.Reset;
        DegreeName:='';
        if Programme.Get(DegreeCode) then
          begin
            DegreeName:=Programme.Description;
          end;

    end;


    procedure GetFacultyName(var DegreeCode: Code[20];var FacultyName: Text[30])
    var
        Programme: Record UnknownRecord61511;
        DimVal: Record "Dimension Value";
    begin
        /*Get the faculty name and return the result*/
        Programme.Reset;
        FacultyName:='';
        
        if Programme.Get(DegreeCode) then
          begin
            DimVal.Reset;
            DimVal.SetRange(DimVal."Dimension Code",'FACULTY');
            DimVal.SetRange(DimVal.Code,Programme.Faculty);
            if DimVal.Find('-') then
              begin
                FacultyName:=DimVal.Name;
              end;
          end;

    end;


    procedure GetReligionName(var ReligionCode: Code[20];var ReligionName: Text[30])
    var
        Religion: Record UnknownRecord61658;
    begin
        /*Get the religion name and display the result*/
        Religion.Reset;
        Religion.SetRange(Religion."Title Code",ReligionCode);
        Religion.SetRange(Religion.Category,Religion.Category::Religions);
        
        ReligionName:='';
        if Religion.Find('-') then
          begin
            ReligionName:=Religion.Description;
          end;

    end;


    procedure GetCurrYear() CurrYear: Text
    var
        acadYear: Record UnknownRecord61382;
    begin
        acadYear.Reset;
        acadYear.SetRange(acadYear.Current,true);
        if acadYear.Find('-') then begin
          CurrYear:=acadYear.Code;
        end else Error('No current academic year specified.');
    end;


    procedure CreateHostelBooking(CustomerRec: Record Customer)
    var
        KuccpsImport: Record UnknownRecord70082;
        HostelRoom: Record "ACA-Students Hostel Rooms";
    begin
        KuccpsImport.Reset;
        KuccpsImport.SetRange(KuccpsImport.Index,Rec."Application No.");
        KuccpsImport.SetRange(KuccpsImport.Accomodation,KuccpsImport.Accomodation::Resident);
        KuccpsImport.SetAutocalcFields("Receipt Amount");
        KuccpsImport.SetFilter("Receipt Amount",'>%1',0);
        if KuccpsImport.FindFirst then begin
          KuccpsImport.CalcFields("Receipt Amount",KuccpsImport.Billable_Amount);
        //    IF KuccpsImport."Receipt Amount"=0 THEN BEGIN
        //      ERROR('You have no made the payment for Resident. Kindly select non-resident to proceed.');
        //      END;
          if KuccpsImport."Receipt Amount" >=KuccpsImport.Billable_Amount then begin
          HostelRoom.Init;
          HostelRoom.Student:=CustomerRec."No.";
          HostelRoom.Validate(Student);
        //    IF CustomerRec.Gender=CustomerRec.Gender::Female THEN
        //    HostelRoom.Gender:=HostelRoom.Gender::Female ELSE
        //    IF  CustomerRec.Gender=CustomerRec.Gender::Male THEN
        //    HostelRoom.Gender:=HostelRoom.Gender::Male;
        HostelRoom.CalcFields(Gender);
          HostelRoom."Hostel No":=KuccpsImport."Assigned Block";
          HostelRoom.Validate("Hostel No");
          HostelRoom."Room No":=KuccpsImport."Assigned Room";
         // HostelRoom.VALIDATE("Room No");
          HostelRoom."Space No":=KuccpsImport."Assigned Space";
          HostelRoom."Student Name":=CustomerRec.Name;
          HostelRoom.Charges:=KuccpsImport.Billable_Amount;
            HostelRoom.Insert(true);
          end else Error('Insufficient receipt amount!');
          end;
    end;
}

