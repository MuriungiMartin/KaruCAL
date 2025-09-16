#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68939 "HMS-Patient Student List"
{
    CardPageID = "HMS Patient Student Card";
    PageType = List;
    SourceTable = UnknownTable61402;
    SourceTableView = where(Blocked=filter(No),
                            "Patient Type"=filter(Student));

    layout
    {
        area(content)
        {
            repeater("Personal details")
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
                    Editable = true;

                    trigger OnValidate()
                    begin
                        CheckPatientType();
                    end;
                }
                field("Student No.";"Student No.")
                {
                    ApplicationArea = Basic;
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
                field("Surname+' '+""Middle Name""+' '+""Last Name""";Surname+' '+"Middle Name"+' '+"Last Name")
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
            repeater("Medical details")
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
        }
    }

    actions
    {
        area(navigation)
        {
        }
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
        "Patient Type":="patient type"::Student;
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

