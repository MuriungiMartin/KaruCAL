#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68850 "ACA-New Admissions List"
{
    CardPageID = "ACA-Admission Form Header GOK";
    DelayedInsert = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = UnknownTable61372;
    SourceTableView = where(Status=filter(New));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Admission No.";"Admission No.")
                {
                    ApplicationArea = Basic;
                }
                field(Date;Date)
                {
                    ApplicationArea = Basic;
                }
                field("Application No.";"Application No.")
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
                field("Faculty Admitted To";"Faculty Admitted To")
                {
                    ApplicationArea = Basic;
                }
                field("Degree Admitted To";"Degree Admitted To")
                {
                    ApplicationArea = Basic;
                }
                field("Correspondence Address 1";"Correspondence Address 1")
                {
                    ApplicationArea = Basic;
                }
                field("Telephone No. 1";"Telephone No. 1")
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
                field("ID Number";"ID Number")
                {
                    ApplicationArea = Basic;
                }
                field("Settlement Type";"Settlement Type")
                {
                    ApplicationArea = Basic;
                }
                field("Intake Code";"Intake Code")
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
                action("Next of Kin")
                {
                    ApplicationArea = Basic;
                    Caption = 'Next of Kin';
                    Image = ContactReference;
                    RunObject = Page "ACA-Admission Form Next Of Kin";
                    RunPageLink = "Admission No."=field("Admission No.");
                }
                action("Emergency Communication")
                {
                    ApplicationArea = Basic;
                    Caption = 'Emergency Communication';
                    Image = ContactPerson;
                    RunObject = Page "ACA-Admission Form Emerg. Com";
                    RunPageLink = "Admission No."=field("Admission No.");
                }
                action("Subjects Qualification")
                {
                    ApplicationArea = Basic;
                    Caption = 'Subjects Qualification';
                    Image = QualificationOverview;
                    RunObject = Page "ACA-Admission Form Academic";
                    RunPageLink = "Admission No."=field("Admission No.");
                }
            }
        }
        area(processing)
        {
            action("&Mark as Admitted")
            {
                ApplicationArea = Basic;
                Caption = '&Mark as Admitted';
                Image = Confirm;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    /*Ask for confirmation  about the filling in*/
                    if Confirm('Mark the Admission Form as Filled?',true)=false then begin exit end;
                    
                    /*Mark the record as filled*/
                    TakeStudentToRegistration();
                    Status:=Status::"Doc. Verification";
                    Modify;
                    Message('The Admission record has been marked as filled');

                end;
            }
        }
    }

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
        Text19071252: label 'Ever suffered or had symptoms of the following';
        Text19025049: label 'Reasons for Non-Acceptance of Offer';
        Text19049741: label 'Medical details not covered by above';
        Text19069419: label 'Last School Attended and Address of School';
        Text19015920: label 'Family member ever suffered from';
        Text19012476: label 'Immunizations received';
        Text19059485: label 'Declaration Form In The Presence Of Parent/Guardian';
        Text19079474: label 'Part II (Completed by a medical practioner)';


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
                Cust."Application No." :="Admission No.";
                Cust."Marital Status":="Marital Status";
                Cust.Citizenship:=Format(Nationality);
                Cust.Religion:=Format(Religion);
                Cust."Application Method":=Cust."application method"::"Apply to Oldest";
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
                       //CourseRegistration.VALIDATE(CourseRegistration."Settlement Type");
                    CourseRegistration.Insert;
        
                    CourseRegistration.Reset;
                    CourseRegistration.SetRange(CourseRegistration."Student No.","Admission No.");
                  //  CourseRegistration.SETRANGE();
                    if CourseRegistration.Find('+') then begin
                    CourseRegistration."Registration Date":=Today;
                    CourseRegistration.Validate(CourseRegistration."Registration Date");
                    CourseRegistration."Settlement Type":="Settlement Type";
                    CourseRegistration.Validate(CourseRegistration."Settlement Type");
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

