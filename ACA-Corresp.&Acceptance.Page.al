#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68859 "ACA-Corresp. & Acceptance"
{
    PageType = List;
    SourceTable = UnknownTable61372;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
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
                group("Offer Acceptance")
                {
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
}

