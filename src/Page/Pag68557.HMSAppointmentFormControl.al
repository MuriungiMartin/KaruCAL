#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68557 "HMS-Appointment Form Control"
{
    InsertAllowed = false;
    PageType = Document;
    SourceTable = UnknownTable61403;
    SourceTableView = where(Status=filter(New|Dispatched));

    layout
    {
        area(content)
        {
            group(Control1)
            {
                field("Appointment No.";"Appointment No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Appointment Date";"Appointment Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Appointment Type";"Appointment Type")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(AppointmentTypeName;AppointmentTypeName)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Patient Type";"Patient Type")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Employee No.";"Employee No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = "Employee No.Enable";
                    Visible = "Employee No.Visible";
                }
                field("Student No.";"Student No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = "Student No.Enable";
                }
                field(PatientName;PatientName)
                {
                    ApplicationArea = Basic;
                    Caption = 'Patient';
                    Editable = false;
                }
                field(Doctor;Doctor)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(DoctorName;DoctorName)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Remarks;Remarks)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Appointment Time";"Appointment Time")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Patient No.";"Patient No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Relative No.";"Relative No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = "Relative No.Enable";
                    Visible = "Relative No.Visible";
                }
                group("Appointment Statistics")
                {
                    Caption = 'Appointment Statistics';
                    field(IntScheduled;IntScheduled)
                    {
                        ApplicationArea = Basic;
                        Caption = 'No. of appointments scheduled';
                        Editable = false;
                    }
                    field(IntCompleted;IntCompleted)
                    {
                        ApplicationArea = Basic;
                        Caption = 'No. of appointments completed';
                        Editable = false;
                    }
                    field(IntRescheduled;IntRescheduled)
                    {
                        ApplicationArea = Basic;
                        Caption = 'No. of appointments rescheduled';
                        Editable = false;
                    }
                    field(IntCancelled;IntCancelled)
                    {
                        ApplicationArea = Basic;
                        Caption = 'No. of appointments cancelled';
                        Editable = false;
                    }
                }
            }
            group("Reschedule details")
            {
                Caption = 'Reschedule details';
                field("ReAppointment Date";"ReAppointment Date")
                {
                    ApplicationArea = Basic;
                    Editable = "ReAppointment DateEditable";
                }
                field("ReAppointment Time";"ReAppointment Time")
                {
                    ApplicationArea = Basic;
                    Editable = "ReAppointment TimeEditable";
                }
                field("ReAppointment Type Code";"ReAppointment Type Code")
                {
                    ApplicationArea = Basic;
                    Editable = ReAppointmentTypeCodeEditable;

                    trigger OnValidate()
                    begin
                        GetAppointmentTypeName(ReAppointmentTypeName,"ReAppointment Type Code");
                    end;
                }
                field(ReAppointmentTypeName;ReAppointmentTypeName)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("ReAppointment Doctor ID";"ReAppointment Doctor ID")
                {
                    ApplicationArea = Basic;
                    Editable = ReAppointmentDoctorIDEditable;

                    trigger OnValidate()
                    begin
                        GetDoctorName("ReAppointment Doctor ID",ReAppointmentDoctorName);
                    end;
                }
                field(ReAppointmentDoctorName;ReAppointmentDoctorName)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
            part(Control1102760014;"HMS-Appointment Form Line")
            {
                SubPageLink = "Patient No."=field("Patient No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Functions")
            {
                Caption = '&Functions';
                action("Reschedule Appointment")
                {
                    ApplicationArea = Basic;
                    Caption = 'Reschedule Appointment';

                    trigger OnAction()
                    begin
                        "ReAppointment DateEditable" :=true;
                        "ReAppointment TimeEditable" :=true;
                        ReAppointmentTypeCodeEditable :=true;
                        ReAppointmentDoctorIDEditable :=true;
                    end;
                }
                action("Cancel Rescheduling")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cancel Rescheduling';

                    trigger OnAction()
                    begin
                        "ReAppointment Date":=0D;
                        "ReAppointment Time":=0T;
                        "ReAppointment Type Code":='';
                        "ReAppointment Doctor ID":='';
                        Modify;
                        "ReAppointment DateEditable" :=not true;
                        "ReAppointment TimeEditable" :=not true;
                        ReAppointmentTypeCodeEditable :=not true;
                        ReAppointmentDoctorIDEditable :=not true;
                    end;
                }
                separator(Action1102760041)
                {
                }
                action("Cancel Appointment")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cancel Appointment';

                    trigger OnAction()
                    begin
                        if Confirm('Do you wish to Cancel the Current Appointment?',false)=false then begin exit end;
                        Status:=Status::Cancelled;
                        Modify;
                        Message('Appointment Cancelled');
                    end;
                }
            }
            action("&Create Appointment")
            {
                ApplicationArea = Basic;
                Caption = '&Create Appointment';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    /*Create an appointment*/
                    if Confirm('Reschedule the Appointment?')=false then begin exit end;
                    HMSSetup.Reset;
                    HMSSetup.Get();
                    NewNo:=NoSeriesMgt.GetNextNo(HMSSetup."Appointment Nos",0D,true);
                    Appointment.Init;
                      Appointment."Appointment No.":=NewNo;
                      Appointment."Appointment Date":="ReAppointment Date";
                      Appointment."Appointment Time":="ReAppointment Time";
                      Appointment."Appointment Type":="Appointment Type";
                      Appointment."Patient Type":="Patient Type";
                      Appointment."Patient No.":="Patient No.";
                      Appointment."Student No.":="Student No.";
                      Appointment."Employee No.":="Employee No.";
                      Appointment."Relative No.":="Relative No.";
                      Appointment.Doctor:=Doctor;
                      Appointment.Remarks:=Remarks;
                      Appointment.Status:=Status::New;
                    Appointment.Insert;
                      "ReAppointment No.":=NewNo;
                      Status:=Status::Rescheduled;
                      Modify;
                      Message('Appointment Rescheduled');

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
        "Relative No.Enable" := true;
        "Employee No.Enable" := true;
        "Student No.Enable" := true;
        "Relative No.Visible" := true;
        "Employee No.Visible" := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        OnAfterGetCurrRecord;
    end;

    var
        AppointmentTypeName: Text[100];
        PatientName: Text[100];
        DoctorName: Text[100];
        IntScheduled: Integer;
        IntCompleted: Integer;
        IntRescheduled: Integer;
        IntCancelled: Integer;
        LastDate: Date;
        LastTime: Time;
        LastAppointmentType: Code[20];
        LastAppointmentDoctor: Code[20];
        ReAppointmentTypeName: Text[30];
        ReAppointmentDoctorName: Text[30];
        Age: Text[100];
        HMSSetup: Record UnknownRecord61386;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Appointment: Record UnknownRecord61403;
        NewNo: Code[20];
        [InDataSet]
        "ReAppointment DateEditable": Boolean;
        [InDataSet]
        "ReAppointment TimeEditable": Boolean;
        [InDataSet]
        ReAppointmentTypeCodeEditable: Boolean;
        [InDataSet]
        ReAppointmentDoctorIDEditable: Boolean;
        [InDataSet]
        "Employee No.Visible": Boolean;
        [InDataSet]
        "Relative No.Visible": Boolean;
        [InDataSet]
        "Student No.Enable": Boolean;
        [InDataSet]
        "Employee No.Enable": Boolean;
        [InDataSet]
        "Relative No.Enable": Boolean;


    procedure CheckPatientType()
    begin
        if "Patient Type"="patient type"::Student then
          begin
            "Student No.Enable" :=false;
            "Employee No.Enable" :=false;
            "Relative No.Enable" :=false;
            "Employee No.Visible" :=false;
            "Relative No.Visible" :=false;
          end
        else
          begin
            "Student No.Enable" :=false;
            "Employee No.Enable" :=false;
            "Relative No.Enable" :=false;
            "Employee No.Visible" :=true;
            "Relative No.Visible" :=true;

          end;
    end;


    procedure GetAppointmentTypeName(var AppointmentTypeName: Text[100];var AppointmentTypeCode: Code[20])
    var
        AppType: Record UnknownRecord61397;
    begin
        AppType.Reset;
        if AppType.Get(AppointmentTypeCode) then
          begin
            AppointmentTypeName:=AppType.Description;
          end;
    end;


    procedure GetPatientNo(var PatientNo: Code[20];var StudentNo: Code[20];var EmployeeNo: Code[20];var RelativeNo: Integer)
    var
        Patient: Record UnknownRecord61402;
    begin
        Patient.Reset;
        if Patient.Get(PatientNo) then
          begin
            StudentNo:=Patient."Student No.";
            EmployeeNo:=Patient."Employee No.";
            RelativeNo:=Patient."Relative No.";
          end;
    end;


    procedure GetPatientName(var PatientNo: Code[20];var PatientName: Text[100])
    var
        Patient: Record UnknownRecord61402;
    begin
        Patient.Reset;
        if Patient.Get(PatientNo) then
          begin
            PatientName:=Patient.Surname + ' ' + Patient."Middle Name" + Patient."Last Name";
          end;
    end;


    procedure GetPatientAge(var PatientNo: Code[20];var Age: Text[100])
    var
        HRDates: Codeunit "HR Dates";
        Patient: Record UnknownRecord61402;
    begin
        Patient.Reset;
        if Patient.Get(PatientNo) then
          begin
            if Patient."Date Of Birth"=0D then
              begin
                Age:='';
              end
            else
              begin
                Age:=HRDates.DetermineAge(Patient."Date Of Birth",Today);
              end;
          end;
    end;


    procedure GetDoctorName(var DoctorCode: Code[20];var DoctorName: Text[100])
    var
        Doctor: Record UnknownRecord61387;
    begin
        Doctor.Reset;
        if Doctor.Get(DoctorCode) then
          begin
            //Doctor.CALCFIELDS(Doctor."Doctor's Name");
            DoctorName:=Doctor."Doctor's Name";
          end;
    end;


    procedure GetAppointmentStats(var PatientNo: Code[20])
    var
        Patient: Record UnknownRecord61402;
    begin
        Patient.Reset;
        if Patient.Get(PatientNo) then
          begin
            Patient.CalcFields(Patient."Appointments Scheduled",Patient."Appointments Completed",Patient."Appointments Rescheduled");
            IntScheduled:=Patient."Appointments Scheduled";
            IntCompleted:=Patient."Appointments Completed";
            IntRescheduled:=Patient."Appointments Rescheduled";
            Patient.CalcFields(Patient."Appointments Cancelled");
            IntCancelled:=Patient."Appointments Cancelled";
          end;
    end;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        CheckPatientType();
        GetAppointmentTypeName(AppointmentTypeName,"Appointment Type");
        GetPatientName("Patient No.",PatientName);
        GetDoctorName(Doctor,DoctorName);
        GetAppointmentStats("Patient No.");
    end;
}

