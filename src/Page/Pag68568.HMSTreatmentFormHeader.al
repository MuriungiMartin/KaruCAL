#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68568 "HMS-Treatment Form Header"
{
    PageType = Document;
    SourceTable = UnknownTable61407;
    SourceTableView = where(Status=filter(New));

    layout
    {
        area(content)
        {
            group(Control1)
            {
                field("Treatment No.";"Treatment No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Treatment No.';
                }
                field("Treatment Location";"Treatment Location")
                {
                    ApplicationArea = Basic;
                }
                field("Treatment Type";"Treatment Type")
                {
                    ApplicationArea = Basic;
                }
                field(Direct;Direct)
                {
                    ApplicationArea = Basic;
                }
                field("Link No.";"Link No.")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        if ("Treatment Type"="treatment type"::Outpatient) and (Direct=false) then
                          begin
                            Observation.Reset;
                            if Observation.Get("Link No.") then
                              begin
                                "Patient No.":=Observation."Patient No.";
                                GetPatientNo(Observation."Patient No.","Student No.","Employee No.","Relative No.");
                                "Link Type":='Observation';
                              end;
                          end
                        else if ("Treatment Type"="treatment type"::Outpatient) and (Direct=true) then
                          begin
                            Appointment.Reset;
                            if Appointment.Get("Link No.") then
                              begin
                                "Patient No.":=Appointment."Patient No.";
                                "Student No.":=Appointment."Student No.";
                                "Employee No.":=Appointment."Employee No.";
                                GetPatientNo(Appointment."Patient No.","Student No.","Employee No.","Relative No.");
                                "Link Type":='Appointment';
                              end;
                          end
                        else if "Treatment Type"="treatment type"::Inpatient then
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

                    trigger OnValidate()
                    begin
                        GetDoctorName("Doctor ID",DoctorName);
                    end;
                }
                field("Patient No.";"Patient No.")
                {
                    ApplicationArea = Basic;
                }
                field("Student No.";"Student No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Student/Emp/Rel No.';
                    Editable = false;
                }
                field("Treatment Remarks";"Treatment Remarks")
                {
                    ApplicationArea = Basic;
                }
                field("Employee No.";"Employee No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'PF No.';
                    Editable = false;
                }
                field(DoctorName;DoctorName)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(PatientName;PatientName)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Employee No.2";"Employee No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Relative No.";"Relative No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
            group(Processes)
            {
                Caption = 'Processes';
                part(Control1102760003;"HMS-Treatment Form Processes")
                {
                    SubPageLink = "Treatment No."=field("Treatment No.");
                }
            }
            group(Symptoms)
            {
                Caption = 'Symptoms';
                part(Control1000000000;"HMS Observation Symptoms")
                {
                    SubPageLink = "Treatment No."=field("Treatment No.");
                }
            }
            group(Signs)
            {
                Caption = 'Signs';
                part(Control1102760039;"HMS Observation Signs")
                {
                    SubPageLink = "Treatment No."=field("Treatment No.");
                }
            }
            group(Control1904423301)
            {
                Caption = 'History';
                part(Control1102760030;"HMS Treatment History")
                {
                    SubPageLink = "Treatment No."=field("Treatment No.");
                }
            }
            group(Laboratory)
            {
                Caption = 'Laboratory';
                part(Control1102760004;"HMS-Treatment Form Laboratory")
                {
                    SubPageLink = "Treatment No."=field("Treatment No.");
                }
            }
            group(Radiology)
            {
                Caption = 'Radiology';
                part(Control1102760006;"HMS-Treatment Form Radiology")
                {
                    SubPageLink = "Treatment No."=field("Treatment No.");
                }
            }
            group(Diagnosis)
            {
                Caption = 'Diagnosis';
                part(Control1102760007;"HMS-Treatment Form Diagnosis")
                {
                    SubPageLink = "Treatment No."=field("Treatment No.");
                }
            }
            group(Procedures)
            {
                Caption = 'Procedures';
                part(Control1102760008;"HMS-Treatment Form Injection")
                {
                    SubPageLink = "Treatment No."=field("Treatment No.");
                }
            }
            group(Prescription)
            {
                Caption = 'Prescription';
                part(Control1102760005;"HMS-Treatment Form Drug")
                {
                    SubPageLink = "Treatment No."=field("Treatment No.");
                }
            }
            group(Referrals)
            {
                Caption = 'Referrals';
                part(Control1102760038;"HMS-Treatment Form Referral")
                {
                    SubPageLink = "Treatment No."=field("Treatment No.");
                }
            }
            group("Sick Off")
            {
                Caption = 'Sick Off';
                part(Control1000000003;"HMS Off Duty")
                {
                    SubPageLink = "Treatment No."=field("Treatment No.");
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&Mark as Completed")
            {
                ApplicationArea = Basic;
                Caption = '&Mark as Completed';
                Image = Close;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    /*Ask for confirmation*/
                    if Confirm('Mark the Treatment as Completed?',false)=false then begin exit end;
                    TestField("Treatment Date");
                    Status:=Status::Completed;
                    Modify;
                    Message('Treatment Marked as Completed');

                end;
            }
            action("Referral Progress")
            {
                ApplicationArea = Basic;
                Caption = 'Referral Progress';
                Image = RefreshLines;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "HMS Referral Header Active";
                RunPageLink = "Treatment no."=field("Treatment No.");
            }
            action("Admission Details")
            {
                ApplicationArea = Basic;
                Caption = 'Admission Details';
                Image = RegisteredDocs;
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
                Image = ResourceJournal;
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
                Image = AdjustEntries;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "HMS-Labaratory Test Line";

                trigger OnAction()
                begin

                    Labrecords.Reset;
                    Labrecords.SetRange(Labrecords."Patient No.","Patient No.");
                    Labrecords.SetRange(Labrecords.Status, Labrecords.Status::Completed);
                    if Labrecords.Find('-') then begin
                    LabResults.SetTableview(Labrecords);
                    LabResults.Run;
                    end;
                end;
            }
            action("Observation Room")
            {
                ApplicationArea = Basic;
                Caption = 'Observation Room';
                Image = Allocations;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    ObservationRec.Reset;
                    ObservationRec.SetRange(ObservationRec."Patient No.","Patient No.");
                    ObservationRec.SetRange(ObservationRec."Observation No.","Link No.");
                    if ObservationRec.Find('-') then
                      begin
                      ObservationForm.SetTableview(ObservationRec);
                      ObservationForm.Run;
                      end
                     else
                      Message('No Observation details available for this patient!');
                end;
            }
            action(History)
            {
                ApplicationArea = Basic;
                Caption = 'History';
                RunObject = Page "HMS-Treatment History List";
                RunPageLink = "Patient No."=field("Patient No.");
            }
        }
    }

    trigger OnInit()
    begin
        /*
        "Off Duty CommentsEnable" := TRUE;
        "Light Duty DaysEnable" := TRUE;
        "Off Duty DaysEnable" := TRUE;
        */

    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
           Direct:=true;
           "Treatment Type":="treatment type"::Outpatient;
          // "Doctor ID":=USERID;
    end;

    var
        PatientName: Text[100];
        DoctorName: Text[30];
        Patient: Record UnknownRecord61402;
        Doctor: Record UnknownRecord61387;
        Observation: Record UnknownRecord61404;
        Admission: Record UnknownRecord61426;
        Appointment: Record UnknownRecord61403;
        Labrecords: Record UnknownRecord61416;
        ObservationRec: Record UnknownRecord61404;
        [InDataSet]
        "Off Duty DaysEnable": Boolean;
        [InDataSet]
        "Light Duty DaysEnable": Boolean;
        [InDataSet]
        "Off Duty CommentsEnable": Boolean;
        LabResults: Page "HMS Laboratory Form History";
        ObservationForm: Page "HMS Observation Form Header Cl";


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

