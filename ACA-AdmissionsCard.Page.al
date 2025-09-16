#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68230 "ACA-Admissions Card"
{
    PageType = Document;
    SourceTable = UnknownTable61372;
    SourceTableView = where(Status=const(New));

    layout
    {
        area(content)
        {
            group("Student Personal Details")
            {
                Caption = 'Student Personal Details';
                field("Admission Type";"Admission Type")
                {
                    ApplicationArea = Basic;
                    Caption = 'Admission Type/No.';
                    Editable = false;
                }
                label(Control1102755061)
                {
                    ApplicationArea = Basic;
                    CaptionClass = Text19069419;
                    Style = Standard;
                    StyleExpr = true;
                }
                field("Admission No.";"Admission No.")
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
                field("Settlement Type";"Settlement Type")
                {
                    ApplicationArea = Basic;
                }
                field("Academic Year";"Academic Year")
                {
                    ApplicationArea = Basic;
                }
                field("Degree Admitted To";"Degree Admitted To")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        GetDegreeName("Degree Admitted To",DegreeName);
                    end;
                }
                field(DegreeName;DegreeName)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Stage Admitted To";"Stage Admitted To")
                {
                    ApplicationArea = Basic;
                }
                field("Date Of Birth";"Date Of Birth")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        GetAge("Date Of Birth",AgeText);
                    end;
                }
                field(Gender;Gender)
                {
                    ApplicationArea = Basic;
                }
                field("Former School Code";"Former School Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Last School Code';
                }
                field(FormerSchoolName;FormerSchoolName)
                {
                    ApplicationArea = Basic;
                    Caption = 'Last School Name';
                    Editable = false;
                }
                field("Index Number";"Index Number")
                {
                    ApplicationArea = Basic;
                }
                field("Mean Grade";"Mean Grade")
                {
                    ApplicationArea = Basic;
                }
                field("Semester Admitted To";"Semester Admitted To")
                {
                    ApplicationArea = Basic;
                    Caption = 'Semester';
                }
                field(Nationality;Nationality)
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        GetCountry(Nationality,NationalityName);
                    end;
                }
                field("Marital Status";"Marital Status")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        /*Check the mariatl status of the student*/
                        if "Marital Status"="marital status"::Single then
                          begin
                            /*Disable the spouse details*/
                            "Spouse NameEnable" :=false;
                            "Spouse Address 1Enable" :=false;
                            "Spouse Address 2Enable" :=false;
                            "Spouse Address 3Enable" :=false;
                          end
                        else
                          begin
                            /*Enable the spouse details*/
                            "Spouse NameEnable" :=true;
                            "Spouse Address 1Enable" :=true;
                            "Spouse Address 2Enable" :=true;
                            "Spouse Address 3Enable" :=true;
                          end;

                    end;
                }
                field(NationalityName;NationalityName)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Religion;Religion)
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        GetReligionName(Religion,ReligionName);
                    end;
                }
                field(Photo;Photo)
                {
                    ApplicationArea = Basic;
                }
            }
            group("Spouse details if married")
            {
                Caption = 'Spouse details if married';
                field("Spouse Name";"Spouse Name")
                {
                    ApplicationArea = Basic;
                    Enabled = "Spouse NameEnable";
                }
                field("Spouse Address 1";"Spouse Address 1")
                {
                    ApplicationArea = Basic;
                    Enabled = "Spouse Address 1Enable";
                }
                field("Spouse Address 2";"Spouse Address 2")
                {
                    ApplicationArea = Basic;
                    Enabled = "Spouse Address 2Enable";
                }
                field("Spouse Address 3";"Spouse Address 3")
                {
                    ApplicationArea = Basic;
                    Enabled = "Spouse Address 3Enable";
                }
            }
            group("Place Of Birth")
            {
                Caption = 'Place Of Birth';
                label(Control1102755073)
                {
                    ApplicationArea = Basic;
                    CaptionClass = Text19073905;
                    Style = Standard;
                    StyleExpr = true;
                }
                field(Tribe;Tribe)
                {
                    ApplicationArea = Basic;
                }
                field("Place Of Birth Village";"Place Of Birth Village")
                {
                    ApplicationArea = Basic;
                }
                field("Place Of Birth Location";"Place Of Birth Location")
                {
                    ApplicationArea = Basic;
                }
                field("Place Of Birth District";"Place Of Birth District")
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
                field("Physical Impairment Details";"Physical Impairment Details")
                {
                    ApplicationArea = Basic;
                }
                field("Communication to University";"Communication to University")
                {
                    ApplicationArea = Basic;
                }
            }
            group("Correspondence Address")
            {
                Caption = 'Correspondence Address';
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
                field("Fax No.";"Fax No.")
                {
                    ApplicationArea = Basic;
                }
                field("E-Mail";"E-Mail")
                {
                    ApplicationArea = Basic;
                }
                label(Control1102755046)
                {
                    ApplicationArea = Basic;
                    CaptionClass = Text19059485;
                    Style = Standard;
                    StyleExpr = true;
                }
                field("Declaration Full Name";"Declaration Full Name")
                {
                    ApplicationArea = Basic;
                    Caption = 'Name';
                }
                field("Declaration Relationship";"Declaration Relationship")
                {
                    ApplicationArea = Basic;
                    Caption = 'Relationship';
                }
                field("Declaration National ID No";"Declaration National ID No")
                {
                    ApplicationArea = Basic;
                    Caption = 'National Identity Card No.';
                }
                field("Declaration Date";"Declaration Date")
                {
                    ApplicationArea = Basic;
                }
            }
            group("Mother/Father/Guardian Details")
            {
                Caption = 'Mother/Father/Guardian Details';
                field("Mother Alive Or Dead";"Mother Alive Or Dead")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        /*Check if the mother or the father is alive or dead*/
                        if ("Mother Alive Or Dead"="mother alive or dead"::Deceased) and ("Father Alive Or Dead"="father alive or dead"::Deceased) then
                          begin
                            /*Disable the guardian details*/
                            "Guardian Full NameEnable" :=not false;
                            "Guardian OccupationEnable" :=not false;
                          end
                        else if ("Mother Alive Or Dead"="mother alive or dead"::Alive) and ("Father Alive Or Dead"="father alive or dead"::Alive) then
                          begin
                            /*Disable the guardian details*/
                            "Guardian Full NameEnable" :=false;
                            "Guardian OccupationEnable" :=false;
                          end;

                    end;
                }
                field("Mother Full Name";"Mother Full Name")
                {
                    ApplicationArea = Basic;
                }
                field("Mother Occupation";"Mother Occupation")
                {
                    ApplicationArea = Basic;
                }
                field("Father Alive Or Dead";"Father Alive Or Dead")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        /*Check if the mother or the father is alive or dead*/
                        if ("Mother Alive Or Dead"="mother alive or dead"::Deceased) and ("Father Alive Or Dead"="father alive or dead"::Deceased) then
                          begin
                            /*Disable the guardian details*/
                            "Guardian Full NameEnable" :=not false;
                            "Guardian OccupationEnable" :=not false;
                          end
                        else if ("Mother Alive Or Dead"="mother alive or dead"::Alive) and ("Father Alive Or Dead"="father alive or dead"::Alive) then
                          begin
                            /*Disable the guardian details*/
                            "Guardian Full NameEnable" :=false;
                            "Guardian OccupationEnable" :=false;
                          end;

                    end;
                }
                field("Father Full Name";"Father Full Name")
                {
                    ApplicationArea = Basic;
                }
                field("Father Occupation";"Father Occupation")
                {
                    ApplicationArea = Basic;
                }
                field("Guardian Full Name";"Guardian Full Name")
                {
                    ApplicationArea = Basic;
                    Enabled = "Guardian Full NameEnable";
                }
                field("Guardian Occupation";"Guardian Occupation")
                {
                    ApplicationArea = Basic;
                    Enabled = "Guardian OccupationEnable";
                }
                field("Emergency Consent Relationship";"Emergency Consent Relationship")
                {
                    ApplicationArea = Basic;
                }
                field("Emergency Consent Full Name";"Emergency Consent Full Name")
                {
                    ApplicationArea = Basic;
                }
                field("Emergency National ID Card No.";"Emergency National ID Card No.")
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
            }
            group(Acceptance)
            {
                Caption = 'Acceptance';
                label(Control1102755076)
                {
                    ApplicationArea = Basic;
                    CaptionClass = Text19058780;
                    Style = Standard;
                    StyleExpr = true;
                }
                label(Control1102755079)
                {
                    ApplicationArea = Basic;
                    CaptionClass = Text19025049;
                    Style = Standard;
                    StyleExpr = true;
                }
                field("Acceptance Date";"Acceptance Date")
                {
                    ApplicationArea = Basic;
                }
                field("Accepted ?";"Accepted ?")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        /*Check if the student has accepted or rejected the offer*/
                        if "Accepted ?"=true then
                          begin
                            "Family ProblemEnable" :=false;
                            "Health ProblemEnable" :=false;
                            "Overseas ScholarshipEnable" :=false;
                            "Course Not PreferenceEnable" :=false;
                            EmploymentEnable :=false;
                            "Other ReasonEnable" :=false;
                          end
                        else
                          begin
                            "Family ProblemEnable" :=not false;
                            "Health ProblemEnable" :=not false;
                            "Overseas ScholarshipEnable" :=not false;
                            "Course Not PreferenceEnable" :=not false;
                            EmploymentEnable :=not false;
                            "Other ReasonEnable" :=not false;
                          end;

                    end;
                }
                field("Family Problem";"Family Problem")
                {
                    ApplicationArea = Basic;
                    Enabled = "Family ProblemEnable";
                }
                field("Health Problem";"Health Problem")
                {
                    ApplicationArea = Basic;
                    Enabled = "Health ProblemEnable";
                }
                field("Overseas Scholarship";"Overseas Scholarship")
                {
                    ApplicationArea = Basic;
                    Enabled = "Overseas ScholarshipEnable";
                }
                field("Course Not Preference";"Course Not Preference")
                {
                    ApplicationArea = Basic;
                    Enabled = "Course Not PreferenceEnable";
                }
                field(Employment;Employment)
                {
                    ApplicationArea = Basic;
                    Enabled = EmploymentEnable;
                }
                field("Other Reason";"Other Reason")
                {
                    ApplicationArea = Basic;
                    Enabled = "Other ReasonEnable";
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Photo Functions")
            {
                Caption = '&Photo Functions';
                action("&Import Photo")
                {
                    ApplicationArea = Basic;
                    Caption = '&Import Photo';

                    trigger OnAction()
                    begin
                        /*Enable the user to import an image of the student*/
                        HasValue:=Photo.Hasvalue;
                        
                        if Photo.Import('*.bmp',true)<>'' then
                          begin
                            /*User has selected an image*/
                            if HasValue=true then
                              begin
                                if Confirm('Replace Existing Photo?',false)=false then begin exit end;
                              end;
                               CurrPage.SaveRecord;
                          end
                        else
                          begin
                            Error('No Photo Selected');
                          end;

                    end;
                }
                action("&Export Photo")
                {
                    ApplicationArea = Basic;
                    Caption = '&Export Photo';

                    trigger OnAction()
                    begin
                        /*Checkif the record has ny image atttached to the same*/
                        HasValue:=Photo.Hasvalue;
                        
                        if HasValue=false then
                          begin
                            Error('The Admission record does not have a Photo Attached');
                          end;
                        if Photo.Export('*.bmp',true)='' then
                          begin
                            Error('Export Process Cancelled By User');
                          end;

                    end;
                }
                separator(Action1102760138)
                {
                }
                action("Delete Photo")
                {
                    ApplicationArea = Basic;
                    Caption = 'Delete Photo';

                    trigger OnAction()
                    begin
                        /*Check if the admission record has any photo attached to the same*/
                        HasValue:=Photo.Hasvalue;
                        
                        if HasValue=false then
                          begin
                            Error('The Admission record does not have any Photo attached. Operation Cancelled');
                          end;
                        /*Ask for user confirmation*/
                        if Confirm('Delete Admission Photo?',false)=false then begin exit end;
                        /*Clear the picture*/
                        Clear(Photo);
                        CurrPage.SaveRecord;

                    end;
                }
            }
            group(Documents)
            {
                Caption = 'Documents';
                action("Next of Kin")
                {
                    ApplicationArea = Basic;
                    Caption = 'Next of Kin';
                    RunObject = Page "ACA-Admission Form Next Of Kin";
                    RunPageLink = "Admission No."=field("Admission No.");
                }
                action("Emergency Communication")
                {
                    ApplicationArea = Basic;
                    Caption = 'Emergency Communication';
                    RunObject = Page "ACA-Admission Form Emerg. Com";
                    RunPageLink = "Admission No."=field("Admission No.");
                }
                action("Subjects Qualification")
                {
                    ApplicationArea = Basic;
                    Caption = 'Subjects Qualification';
                    RunObject = Page "ACA-Admission Form Academic";
                    RunPageLink = "Admission No."=field("Admission No.");
                }
            }
        }
        area(processing)
        {
            action("&Mark as Filled")
            {
                ApplicationArea = Basic;
                Caption = '&Mark as Filled';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    /*Ask for confirmation  about the filling in*/
                    if Confirm('Mark the Admission Form as Filled?',true)=false then begin exit end;
                    
                    /*Mark the record as filled*/
                    TestField(Campus);
                    TestField("Intake Code");
                    TakeStudentToRegistration();
                    Status:=Status::"Doc. Verification";
                    Modify;
                    Message('The Admission record has been marked as filled');

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
        "Other ReasonEnable" := true;
        EmploymentEnable := true;
        "Course Not PreferenceEnable" := true;
        "Overseas ScholarshipEnable" := true;
        "Health ProblemEnable" := true;
        "Family ProblemEnable" := true;
        "Spouse Address 3Enable" := true;
        "Spouse Address 2Enable" := true;
        "Spouse Address 1Enable" := true;
        "Spouse NameEnable" := true;
        "Guardian OccupationEnable" := true;
        "Guardian Full NameEnable" := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        OnAfterGetCurrRecord;
    end;

    var
        FacultyName: Text[30];
        DegreeName: Text[200];
        AgeText: Text[100];
        NationalityName: Text[30];
        ReligionName: Text[30];
        FormerSchoolName: Text[30];
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
        Text19025049: label 'Reasons for Non-Acceptance of Offer';
        Text19073905: label 'Any information student might think useful to Communicate to the University';
        Text19069419: label 'Last School Attended and Address of School';
        Text19059485: label 'Declaration Form In The Presence Of Parent/Guardian';


    procedure GetCountry(var CountryCode: Code[20];var CountryName: Text[30])
    var
        Country: Record "Country/Region";
    begin
        /*Get the country name and display the result*/
        Country.Reset;
        CountryName:='';
        if Country.Get(CountryCode) then
          begin
            CountryName:=Country.Name;
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


    procedure GetAge(var StartDate: Date;var AgeText: Text[100])
    var
        HRDates: Codeunit "HR Dates";
    begin
        /*Get the age based on the dates inserted*/
        if StartDate=0D then begin StartDate:=Today end;
        
        AgeText:=HRDates.DetermineAge(StartDate,Today);

    end;


    procedure GetReligionName(var ReligionCode: Code[20];var ReligionName: Text[30])
    var
        Religion: Record UnknownRecord61381;
    begin
        /*Get the religion name and display the result*/
        Religion.Reset;
        ReligionName:='';
        if Religion.Get(ReligionCode) then
          begin
            ReligionName:=Religion.Description;
          end;

    end;


    procedure TakeStudentToRegistration()
    begin
        
        
            begin
                Cust.Init;
                Cust."No.":="Admission No.";
                Cust.Name:=CopyStr(Surname + ' ' + "Other Names",1,30);
                Cust."Search Name":=UpperCase(CopyStr(Surname + ' ' + "Other Names",1,30));
                Cust.Address:="Correspondence Address 1";
                Cust."Address 2":=CopyStr("Correspondence Address 2" + ',' +  "Correspondence Address 3",1,30);
                Cust."Phone No.":="Telephone No. 1" + ',' + "Telephone No. 2";
                Cust."Telex No.":="Fax No.";
                Cust."E-Mail":="E-Mail";
                Cust.Gender:=Gender;
                Cust."Date Of Birth":="Date Of Birth";
                Cust."Date Registered":=Today;
                Cust."Customer Type":=Cust."customer type"::Student;
        //        Cust."Student Type":=FORMAT(Enrollment."Student Type");
        //        Cust."ID No":=;
                Cust."Application No." :="Application No.";
                Cust."Marital Status":="Marital Status";
                Cust.Citizenship:=Format(Nationality);
                Cust.Religion:=Format(Religion);
                Cust."ID No":="ID Number";
                Cust."Global Dimension 1 Code":=Campus;
                Cust."Customer Posting Group":='STUDENT';
                Cust.Validate(Cust."Customer Posting Group");
                Cust.Insert();
        
        
                //insert the course registration details
                    CourseRegistration.Reset;
                    CourseRegistration.Init;
                       CourseRegistration."Reg. Transacton ID":='';
                       CourseRegistration.Validate(CourseRegistration."Reg. Transacton ID");
                       CourseRegistration."Student No.":="Admission No.";
                       CourseRegistration.Programme:="Degree Admitted To";
                       CourseRegistration.Semester:="Semester Admitted To";
                       CourseRegistration.Stage:="Stage Admitted To";
                       CourseRegistration."Student Type":=CourseRegistration."student type"::"Full Time";
                       CourseRegistration."Registration Date":=Today;
                       CourseRegistration."Settlement Type":="Settlement Type";
                       CourseRegistration.Session:="Intake Code";
                       //CourseRegistration.VALIDATE(CourseRegistration."Settlement Type");
                    CourseRegistration.Insert;
        
                    CourseRegistration.Reset;
                    CourseRegistration.SetRange(CourseRegistration."Student No.","Admission No.");
                    if CourseRegistration.Find('+') then begin
                    CourseRegistration."Registration Date":=Today;
                    CourseRegistration.Validate(CourseRegistration."Registration Date");
                    //CourseRegistration."Settlement Type":="Settlement Type";
                    //CourseRegistration.VALIDATE(CourseRegistration."Settlement Type");
                    CourseRegistration.Modify;
        
                    end;
        
        
        
                //insert the details related to the next of kin of the student into the database
                    AdminKin.Reset;
                    AdminKin.SetRange(AdminKin."Admission No.","Admission No.");
                    if AdminKin.Find('-') then
                        begin
                            repeat
                                StudentKin.Reset;
                                StudentKin.Init;
                                    StudentKin."Student No":="Admission No.";
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
                if "Mother Alive Or Dead"="mother alive or dead"::Alive then
                        begin
                         if "Mother Full Name"<>'' then begin
                          StudentGuardian.Reset;
                          StudentGuardian.Init;
                          StudentGuardian."Student No.":="Admission No.";
                          StudentGuardian.Names:="Mother Full Name";
                          StudentGuardian.Insert;
                          end;
                        end;
                if "Father Alive Or Dead"="father alive or dead"::Alive then
                        begin
                        if "Father Full Name"<>'' then begin
                          StudentGuardian.Reset;
                          StudentGuardian.Init;
                          StudentGuardian."Student No.":="Admission No.";
                          StudentGuardian.Names:="Father Full Name";
                          StudentGuardian.Insert;
                          end;
                        end;
                if "Guardian Full Name"<>'' then
                        begin
                        if "Guardian Full Name"<>'' then begin
                          StudentGuardian.Reset;
                          StudentGuardian.Init;
                          StudentGuardian."Student No.":="Admission No.";
                          StudentGuardian.Names:="Guardian Full Name";
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

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        /*Display the details from the database*/
        GetFacultyName("Degree Admitted To",FacultyName);
        GetDegreeName("Degree Admitted To",DegreeName);
        GetCountry(Nationality,NationalityName);
        GetReligionName(Religion,ReligionName);
        GetAge("Date Of Birth",AgeText);
        
        /*Check if the mother or the father is alive or dead*/
        if ("Mother Alive Or Dead"="mother alive or dead"::Deceased) and ("Father Alive Or Dead"="father alive or dead"::Deceased) then
          begin
            /*Disable the guardian details*/
            "Guardian Full NameEnable" :=not false;
            "Guardian OccupationEnable" :=not false;
          end
        else if ("Mother Alive Or Dead"="mother alive or dead"::Alive) and ("Father Alive Or Dead"="father alive or dead"::Alive) then
          begin
            /*Disable the guardian details*/
            "Guardian Full NameEnable" :=false;
            "Guardian OccupationEnable" :=false;
          end;
        
        /*Check the mariatl status of the student*/
        if "Marital Status"="marital status"::Single then
          begin
            /*Disable the spouse details*/
            "Spouse NameEnable" :=false;
            "Spouse Address 1Enable" :=false;
            "Spouse Address 2Enable" :=false;
            "Spouse Address 3Enable" :=false;
          end
        else
          begin
            /*Enable the spouse details*/
            "Spouse NameEnable" :=true;
            "Spouse Address 1Enable" :=true;
            "Spouse Address 2Enable" :=true;
            "Spouse Address 3Enable" :=true;
          end;

    end;
}

