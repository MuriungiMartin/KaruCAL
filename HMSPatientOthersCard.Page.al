#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68639 "HMS Patient Others Card"
{
    PageType = Document;
    SourceTable = UnknownTable61402;
    SourceTableView = where(Blocked=filter(No),
                            "Patient Type"=filter(Others));

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
                    Editable = false;

                    trigger OnValidate()
                    begin
                        CheckPatientType();
                    end;
                }
                field(names;Surname+' '+"Middle Name"+' '+"Last Name")
                {
                    ApplicationArea = Basic;
                    Caption = 'Full Name';
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
            group(Appointments)
            {
                Caption = 'Appointments';
                Editable = true;
            }
            group(Observation)
            {
                Caption = 'Observation';
                Editable = true;
                part(Control1102760115;"HMS Observation SubForm")
                {
                    SubPageLink = "Patient No."=field("Patient No.");
                }
            }
            group(Treatment)
            {
                Caption = 'Treatment';
                Editable = true;
                part(Control1102760118;"HMS Treatment SubForm")
                {
                    SubPageLink = "Patient No."=field("Patient No.");
                }
            }
            group(Laboratory)
            {
                Caption = 'Laboratory';
                Editable = true;
                part(Control1102760116;"HMS Laboratory SubForm")
                {
                    Editable = false;
                    SubPageLink = "Patient No."=field("Patient No.");
                }
            }
            group(Radiology)
            {
                Caption = 'Radiology';
                Editable = true;
                part(Control1102760117;"HMS Radiology SubForm")
                {
                    SubPageLink = "Patient No."=field("Patient No.");
                }
            }
            group(Pharmacy)
            {
                Caption = 'Pharmacy';
                Editable = true;
                part(Control1102760119;"HMS Pharmacy SubForm")
                {
                    SubPageLink = "Patient No."=field("Patient No.");
                }
            }
            group(Admission)
            {
                Caption = 'Admission';
                Editable = true;
                part(Control1102760120;"HMS Admission SubForm")
                {
                    SubPageLink = "Patient No."=field("Patient No.");
                }
            }
            group(Referrals)
            {
                Caption = 'Referrals';
                Editable = true;
                part(Control1102760121;"HMS Referral SubForm")
                {
                    SubPageLink = "Patient No."=field("Patient No.");
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
        "Patient Type":="patient type"::Others;
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

