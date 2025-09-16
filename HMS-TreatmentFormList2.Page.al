#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68957 "HMS-Treatment Form List 2"
{
    CardPageID = "HMS Treatment Form History";
    Editable = false;
    PageType = List;
    SourceTable = UnknownTable61407;
    SourceTableView = where(Status=const(Completed));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Treatment No.";"Treatment No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Treatment No.';
                }
                field("Treatment Type";"Treatment Type")
                {
                    ApplicationArea = Basic;
                }
                field("Link No.";"Link No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;

                    trigger OnValidate()
                    begin
                        if "Treatment Type"="treatment type"::Inpatient then
                          begin
                            Observation.Reset;
                            if Observation.Get("Link No.") then
                              begin
                                "Patient No.":=Observation."Patient No.";
                                GetPatientNo(Observation."Patient No.","Student No.","Employee No.","Relative No.");
                                "Link Type":='Observation';
                              end;
                          end
                        else
                          begin
                           Admission.Reset;
                           if Admission.Get("Link No.") then
                            begin
                              "Patient No.":=Admission."Patient No.";
                              GetPatientNo(Admission."Patient No.","Student No.","Employee No.","Relative No.");
                              "Link Type":='Admission';
                            end;
                          end;
                        GetPatientName("Patient No.",PatientName);
                    end;
                }
                field("Treatment Date";"Treatment Date")
                {
                    ApplicationArea = Basic;
                }
                field("Treatment Time";"Treatment Time")
                {
                    ApplicationArea = Basic;
                }
                field("Doctor ID";"Doctor ID")
                {
                    ApplicationArea = Basic;
                    Editable = false;

                    trigger OnValidate()
                    begin
                        GetDoctorName("Doctor ID",DoctorName);
                    end;
                }
                field(DoctorName;DoctorName)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Patient No.";"Patient No.")
                {
                    ApplicationArea = Basic;
                }
                field(PatientName;PatientName)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Student No.";"Student No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Student/Emp/Rel No.';
                    Editable = false;
                }
                field("Employee No.";"Employee No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Treatment Remarks";"Treatment Remarks")
                {
                    ApplicationArea = Basic;
                }
                field("Relative No.";"Relative No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Referral Progress")
            {
                ApplicationArea = Basic;
                Caption = 'Referral Progress';
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "HMS Referral Header Active";
                RunPageLink = "Treatment no."=field("Treatment No.");
            }
            action("Admission Details")
            {
                ApplicationArea = Basic;
                Caption = 'Admission Details';
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "HMS Admission Progress";
                RunPageLink = "Link Type"=const('DOCTOR'),
                              "Link No."=field("Treatment No.");
            }
            action("Radiology Results")
            {
                ApplicationArea = Basic;
                Caption = 'Radiology Results';
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "HMS-Radiology View Test Header";
                RunPageLink = "Link Type"=const('DOCTOR'),
                              "Link No."=field("Treatment No.");
            }
            action("Laboratory Results")
            {
                ApplicationArea = Basic;
                Caption = 'Laboratory Results';
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "HMS-Laboratory View Test";
                RunPageLink = "Request Area"=const(Doctor),
                              "Link No."=field("Treatment No.");
            }
            action("Observation Room")
            {
                ApplicationArea = Basic;
                Caption = 'Observation Room';
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "HMS-Observation Form Header";
                RunPageLink = "Observation No."=field("Link No.");
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        OnAfterGetCurrRecord;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        OnAfterGetCurrRecord;
    end;

    var
        PatientName: Text[100];
        DoctorName: Text[30];
        Patient: Record UnknownRecord61402;
        Doctor: Record UnknownRecord61387;
        Observation: Record UnknownRecord61404;
        Admission: Record UnknownRecord61426;


    procedure GetPatientNo(var PatientNo: Code[20];var "Student No.": Code[20];var "Employee No.": Code[20];var "Relative No.": Integer)
    begin
        Patient.Reset;
        if Patient.Get(PatientNo) then
          begin
            "Student No.":=Patient."Student No.";
            "Employee No.":=Patient."Employee No.";
            "Relative No.":=Patient."Relative No.";
          end;
    end;


    procedure GetDoctorName(var DoctorID: Code[20];var DoctorName: Text[30])
    begin
        Doctor.Reset;
        DoctorName:='';
        if Doctor.Get(DoctorID) then
          begin
            //Doctor.CALCFIELDS(Doctor."Doctor's Name");
            DoctorName:=Doctor."Doctor's Name";
          end;
    end;


    procedure GetPatientName(var PatientNo: Code[20];var PatientName: Text[100])
    begin
        Patient.Reset;
        PatientName:='';
        if Patient.Get(PatientNo) then
          begin
            PatientName:=Patient.Surname + ' ' +Patient."Middle Name" +' ' + Patient."Last Name";
          end;
    end;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        GetPatientName("Patient No.",PatientName);
        GetDoctorName("Doctor ID",DoctorName);
    end;
}

