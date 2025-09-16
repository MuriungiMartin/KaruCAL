#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68507 "ACA-Admission Form Filled"
{
    PageType = Document;
    SourceTable = UnknownTable61372;
    SourceTableView = where(Status=const("Doc. Verification"));

    layout
    {
        area(content)
        {
            field("Admission Type";"Admission Type")
            {
                ApplicationArea = Basic;
                Editable = false;
            }
            field(Surname;Surname)
            {
                ApplicationArea = Basic;
                Editable = false;
            }
            field("Other Names";"Other Names")
            {
                ApplicationArea = Basic;
                Editable = false;
            }
            field("Settlement Type";"Settlement Type")
            {
                ApplicationArea = Basic;
                Editable = false;
            }
            field("Degree Admitted To";"Degree Admitted To")
            {
                ApplicationArea = Basic;
                Editable = false;

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
                Editable = false;

                trigger OnValidate()
                begin
                    GetAge("Date Of Birth",AgeText);
                end;
            }
            field(AgeText;AgeText)
            {
                ApplicationArea = Basic;
                Editable = false;
            }
            field(Gender;Gender)
            {
                ApplicationArea = Basic;
                Editable = false;
            }
            field("Marital Status";"Marital Status")
            {
                ApplicationArea = Basic;
                Editable = false;

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
            field("Spouse Name";"Spouse Name")
            {
                ApplicationArea = Basic;
                Editable = false;
                Enabled = "Spouse NameEnable";
            }
            field("Spouse Address 1";"Spouse Address 1")
            {
                ApplicationArea = Basic;
                Editable = false;
                Enabled = "Spouse Address 1Enable";
            }
            field("Spouse Address 2";"Spouse Address 2")
            {
                ApplicationArea = Basic;
                Editable = false;
                Enabled = "Spouse Address 2Enable";
            }
            field("Spouse Address 3";"Spouse Address 3")
            {
                ApplicationArea = Basic;
                Editable = false;
                Enabled = "Spouse Address 3Enable";
            }
            field(Tribe;Tribe)
            {
                ApplicationArea = Basic;
                Editable = false;
            }
            field("Place Of Birth Village";"Place Of Birth Village")
            {
                ApplicationArea = Basic;
                Editable = false;
            }
            field("Place Of Birth Location";"Place Of Birth Location")
            {
                ApplicationArea = Basic;
                Editable = false;
            }
            field("Place Of Birth District";"Place Of Birth District")
            {
                ApplicationArea = Basic;
                Editable = false;
            }
            field("Name of Chief";"Name of Chief")
            {
                ApplicationArea = Basic;
                Editable = false;
            }
            field("Nearest Police Station";"Nearest Police Station")
            {
                ApplicationArea = Basic;
                Editable = false;
            }
            field("Declaration Full Name";"Declaration Full Name")
            {
                ApplicationArea = Basic;
                Caption = 'Name';
                Editable = false;
            }
            field("Declaration Relationship";"Declaration Relationship")
            {
                ApplicationArea = Basic;
                Caption = 'Relationship';
                Editable = false;
            }
            field("Declaration National ID No";"Declaration National ID No")
            {
                ApplicationArea = Basic;
                Caption = 'National Identity Card No.';
                Editable = false;
            }
            field("Declaration Date";"Declaration Date")
            {
                ApplicationArea = Basic;
                Editable = false;
            }
            field("Acceptance Date";"Acceptance Date")
            {
                ApplicationArea = Basic;
                Editable = false;
            }
            field("Accepted ?";"Accepted ?")
            {
                ApplicationArea = Basic;
                Editable = false;

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
                Editable = false;
                Enabled = "Family ProblemEnable";
            }
            field("Health Problem";"Health Problem")
            {
                ApplicationArea = Basic;
                Editable = false;
                Enabled = "Health ProblemEnable";
            }
            field("Overseas Scholarship";"Overseas Scholarship")
            {
                ApplicationArea = Basic;
                Editable = false;
                Enabled = "Overseas ScholarshipEnable";
            }
            field("Course Not Preference";"Course Not Preference")
            {
                ApplicationArea = Basic;
                Editable = false;
                Enabled = "Course Not PreferenceEnable";
            }
            field(Employment;Employment)
            {
                ApplicationArea = Basic;
                Editable = false;
                Enabled = EmploymentEnable;
            }
            field("Other Reason";"Other Reason")
            {
                ApplicationArea = Basic;
                Editable = false;
                Enabled = "Other ReasonEnable";
            }
            field("Admission No.";"Admission No.")
            {
                ApplicationArea = Basic;
                Editable = false;
            }
            field("Semester Admitted To";"Semester Admitted To")
            {
                ApplicationArea = Basic;
            }
            field(Nationality;Nationality)
            {
                ApplicationArea = Basic;
                Editable = false;

                trigger OnValidate()
                begin
                    GetCountry(Nationality,NationalityName);
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
                Editable = false;

                trigger OnValidate()
                begin
                    GetReligionName(Religion,ReligionName);
                end;
            }
            field(ReligionName;ReligionName)
            {
                ApplicationArea = Basic;
                Editable = false;
            }
            field("Correspondence Address 1";"Correspondence Address 1")
            {
                ApplicationArea = Basic;
                Editable = false;
            }
            field("Correspondence Address 2";"Correspondence Address 2")
            {
                ApplicationArea = Basic;
                Editable = false;
            }
            field("Correspondence Address 3";"Correspondence Address 3")
            {
                ApplicationArea = Basic;
                Editable = false;
            }
            field("Telephone No. 1";"Telephone No. 1")
            {
                ApplicationArea = Basic;
                Editable = false;
            }
            field("Telephone No. 2";"Telephone No. 2")
            {
                ApplicationArea = Basic;
                Editable = false;
            }
            field("Fax No.";"Fax No.")
            {
                ApplicationArea = Basic;
                Editable = false;
            }
            field("E-Mail";"E-Mail")
            {
                ApplicationArea = Basic;
                Editable = false;
            }
            field("Emergency Consent Relationship";"Emergency Consent Relationship")
            {
                ApplicationArea = Basic;
                Caption = 'Relationship';
                Editable = false;
            }
            field("Emergency Consent Full Name";"Emergency Consent Full Name")
            {
                ApplicationArea = Basic;
                Caption = 'Full  Name';
                Editable = false;
            }
            field("Emergency National ID Card No.";"Emergency National ID Card No.")
            {
                ApplicationArea = Basic;
                Caption = 'National ID Card No';
                Editable = false;
            }
            field("Emergency Consent Address 1";"Emergency Consent Address 1")
            {
                ApplicationArea = Basic;
                Caption = 'Address 1';
                Editable = false;
            }
            field("Emergency Consent Address 2";"Emergency Consent Address 2")
            {
                ApplicationArea = Basic;
                Caption = 'Address 2';
                Editable = false;
            }
            field("Emergency Consent Address 3";"Emergency Consent Address 3")
            {
                ApplicationArea = Basic;
                Caption = 'Address 3';
                Editable = false;
            }
            field("Emergency Date of Consent";"Emergency Date of Consent")
            {
                ApplicationArea = Basic;
                Caption = 'Date of Consent';
                Editable = false;
            }
            field("Mother Alive Or Dead";"Mother Alive Or Dead")
            {
                ApplicationArea = Basic;
                Editable = false;

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
                Editable = false;
            }
            field("Mother Occupation";"Mother Occupation")
            {
                ApplicationArea = Basic;
                Editable = false;
            }
            field("Father Alive Or Dead";"Father Alive Or Dead")
            {
                ApplicationArea = Basic;
                Editable = false;

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
                Editable = false;
            }
            field("Father Occupation";"Father Occupation")
            {
                ApplicationArea = Basic;
                Editable = false;
            }
            field("Guardian Full Name";"Guardian Full Name")
            {
                ApplicationArea = Basic;
                Editable = false;
                Enabled = "Guardian Full NameEnable";
            }
            field("Guardian Occupation";"Guardian Occupation")
            {
                ApplicationArea = Basic;
                Editable = false;
                Enabled = "Guardian OccupationEnable";
            }
            field(Photo;Photo)
            {
                ApplicationArea = Basic;
            }
            label(Control1102755220)
            {
                ApplicationArea = Basic;
                CaptionClass = Text19025049;
                Style = Standard;
                StyleExpr = true;
            }
            label(Control1102755209)
            {
                ApplicationArea = Basic;
                CaptionClass = Text19058780;
                Style = Standard;
                StyleExpr = true;
            }
            label(Control1102755188)
            {
                ApplicationArea = Basic;
                CaptionClass = Text19059485;
                Style = Standard;
                StyleExpr = true;
            }
        }
    }

    actions
    {
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
        Text19059485: label 'Declaration Form In The Presence Of Parent/Guardian';
        Text19058780: label 'Acceptance of Offer/Non-Acceptance of Offer';
        Text19025049: label 'Reasons for Non-Acceptance of Offer';


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
            DimVal.SetRange(DimVal.Code,Programme."School Code");
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

