#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68493 "ACA-Applic. Process Adm Letter"
{
    PageType = Document;
    SourceTable = UnknownTable61358;
    SourceTableView = where(Status=const("Admission Letter"));

    layout
    {
        area(content)
        {
            group("General Information")
            {
                field("Application No.";"Application No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Apptn No./Date/Rcpt No.';
                    Editable = false;
                }
                field("Settlement Type";"Settlement Type")
                {
                    ApplicationArea = Basic;
                    Caption = 'Settlement Type/Academic Year';
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
                    Editable = false;
                }
                field("Other Names";"Other Names")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Date Of Birth";"Date Of Birth")
                {
                    ApplicationArea = Basic;
                    Editable = false;

                    trigger OnValidate()
                    begin
                        /*Display the age of the user*/
                        Age:=GetAge("Date Of Birth");

                    end;
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
                }
                field(Nationality;Nationality)
                {
                    ApplicationArea = Basic;
                    Editable = false;

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
                field("Country of Origin";"Country of Origin")
                {
                    ApplicationArea = Basic;
                    Editable = false;

                    trigger OnValidate()
                    begin
                        /*Get the name of the country of origin name*/
                        CountryOfOriginName:=GetCountry("Country of Origin");

                    end;
                }
                field(CountryOfOriginName;CountryOfOriginName)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Application Date";"Application Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Application Form Receipt No.";"Application Form Receipt No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;

                    trigger OnValidate()
                    begin
                        /*Check if the receipt number is valid or not*/
                        CustEntry.Reset;
                        CustEntry.SetRange(CustEntry."Source Code",'CASHRECJNL');
                        CustEntry.SetRange(CustEntry."Document No.","Application Form Receipt No.");
                        if CustEntry.Find('-') then //record has been located in the database
                          begin
                            /*Check if the receipt number has been used by another student*/
                              Apps.Reset;
                              Apps.SetRange(Apps."Application Form Receipt No.");
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
                field(Age;Age)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
            group("Correspondence Address")
            {
                field("Address for Correspondence1";"Address for Correspondence1")
                {
                    ApplicationArea = Basic;
                    Caption = 'Address 1';
                    Editable = false;
                }
                field("Address for Correspondence2";"Address for Correspondence2")
                {
                    ApplicationArea = Basic;
                    Caption = 'Address 2';
                    Editable = false;
                }
                field("Address for Correspondence3";"Address for Correspondence3")
                {
                    ApplicationArea = Basic;
                    Caption = 'Address 3';
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
            }
            group("First Choice")
            {
                field("First Degree Choice";"First Degree Choice")
                {
                    ApplicationArea = Basic;
                    Editable = false;

                    trigger OnValidate()
                    begin
                        /*Display the name of the programme*/
                        DegreeName1:=GetDegree1("First Degree Choice");
                        recProgramme.Reset;
                        if recProgramme.Get("First Degree Choice") then
                          begin
                            School1:=recProgramme.Faculty;
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
                    Editable = false;
                }
                field("First Choice Semester";"First Choice Semester")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
            group("Second Choice")
            {
                field("Second Degree Choice";"Second Degree Choice")
                {
                    ApplicationArea = Basic;
                    Editable = false;

                    trigger OnValidate()
                    begin
                        /*Display the programme name*/
                        DegreeName2:=GetDegree1("Second Degree Choice");
                        recProgramme.Reset;
                        if recProgramme.Get("Second Degree Choice") then
                          begin
                            "School 2":=recProgramme.Faculty;
                            FacultyName2:=GetFaculty("Second Degree Choice");
                          end;

                    end;
                }
                field(DegreeName2;DegreeName2)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("School 2";"School 2")
                {
                    ApplicationArea = Basic;
                    Caption = 'Faculty';
                    Editable = false;
                }
                field(FacultyName2;FacultyName2)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Second Choice Stage";"Second Choice Stage")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Second Choice Semester";"Second Choice Semester")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
            group(Qualifications)
            {
                field("Former School Code";"Former School Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;

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
                    Editable = false;
                }
                field("Date of Completion";"Date of Completion")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Year of Examination";"Year of Examination")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Examination Body";"Examination Body")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Examination;Examination)
                {
                    ApplicationArea = Basic;
                    Editable = false;

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
                    Editable = false;
                }
                field("Mean Grade Acquired";"Mean Grade Acquired")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = "Mean Grade AcquiredVisible";
                }
                field("Principal Passes";"Principal Passes")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = "Principal PassesVisible";
                }
                field("Points Acquired";"Points Acquired")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = "Points AcquiredVisible";
                }
                field("Subsidiary Passes";"Subsidiary Passes")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = "Subsidiary PassesVisible";
                }
            }
            group(Recommendations)
            {
                field("HOD Recommendations";"HOD Recommendations")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    MultiLine = true;
                }
                field("Admissable Status";"Admissable Status")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Dean Recommendations";"Dean Recommendations")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    MultiLine = true;
                }
                field("Admission Board Recommendation";"Admission Board Recommendation")
                {
                    ApplicationArea = Basic;
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
                    RunObject = Page "ACA-Application Form Academic";
                    RunPageLink = "Application No."=field("Application No.");
                }
                action("Professional Qualifications")
                {
                    ApplicationArea = Basic;
                    Caption = 'Professional Qualifications';
                    RunObject = Page "ACA-Application Form Qualif.";
                    RunPageLink = "Application No."=field("Application No.");
                }
                action("Employment History")
                {
                    ApplicationArea = Basic;
                    Caption = 'Employment History';
                    RunObject = Page "ACA-Application Form Employ.";
                    RunPageLink = "Application No."=field("Application No.");
                }
                action("Academic Referees")
                {
                    ApplicationArea = Basic;
                    Caption = 'Academic Referees';
                    RunObject = Page "ACA-Application Form Acad. Ref";
                    RunPageLink = "Application No."=field("Application No.");
                }
            }
        }
        area(processing)
        {
            action("Print Admission Letter & Fee Structure")
            {
                ApplicationArea = Basic;
                Caption = 'Print Admission Letter & Fee Structure';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Admissions.Reset;
                    Admissions.SetRange(Admissions."Admission No.","Admission No");
                    Report.Run(39005759,true,true,Admissions);
                    Report.Run(39005761,true,true,Admissions);
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
        "Points AcquiredVisible" := true;
        "Mean Grade AcquiredVisible" := true;
        "Subsidiary PassesVisible" := true;
        "Principal PassesVisible" := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        OnAfterGetCurrRecord;
    end;

    var
        DegreeName1: Text[100];
        DegreeName2: Text[100];
        FacultyName1: Text[100];
        FacultyName2: Text[100];
        NationalityName: Text[100];
        CountryOfOriginName: Text[100];
        Age: Text[50];
        FormerSchoolName: Text[30];
        CustEntry: Record "Cust. Ledger Entry";
        Apps: Record UnknownRecord61358;
        recProgramme: Record UnknownRecord61511;
        Admissions: Record UnknownRecord61372;
        [InDataSet]
        "Principal PassesVisible": Boolean;
        [InDataSet]
        "Subsidiary PassesVisible": Boolean;
        [InDataSet]
        "Mean Grade AcquiredVisible": Boolean;
        [InDataSet]
        "Points AcquiredVisible": Boolean;
        Text19074524: label 'Head of Department Recommendations';
        Text19012721: label 'Dean of Faculty Recommendations';


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


    procedure getFormerSchool(var FormerSchoolCode: Code[20]) FormerSchoolName: Text[30]
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
}

