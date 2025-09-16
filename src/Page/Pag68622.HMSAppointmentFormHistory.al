#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68622 "HMS Appointment Form History"
{
    Editable = false;
    PageType = Document;
    SourceTable = UnknownTable61403;
    SourceTableView = where(Status=const(Completed));

    layout
    {
        area(content)
        {
            group(Control1)
            {
                field("Appointment No.";"Appointment No.")
                {
                    ApplicationArea = Basic;
                }
                field("Appointment Date";"Appointment Date")
                {
                    ApplicationArea = Basic;
                }
                field("Appointment Time";"Appointment Time")
                {
                    ApplicationArea = Basic;
                }
                field("Appointment Type";"Appointment Type")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        GetAppointmentTypeName(AppointmentTypeName,"Appointment Type");
                    end;
                }
                field(AppointmentTypeName;AppointmentTypeName)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Patient Type";"Patient Type")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        CheckPatientType();
                    end;
                }
                field("Patient No.";"Patient No.")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        GetPatientName("Patient No.",PatientName);
                        GetPatientNo("Patient No.","Student No.","Employee No.","Relative No.");
                        GetAppointmentStats("Patient No.");
                    end;
                }
                field("Employee No.";"Employee No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Employee/Relative No.';
                    Enabled = "Employee No.Enable";
                    Visible = "Employee No.Visible";
                }
                field("Relative No.";"Relative No.")
                {
                    ApplicationArea = Basic;
                    Enabled = "Relative No.Enable";
                    Visible = "Relative No.Visible";
                }
                field("Student No.";"Student No.")
                {
                    ApplicationArea = Basic;
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

                    trigger OnValidate()
                    begin
                        GetDoctorName(Doctor,DoctorName);
                    end;
                }
                field(DoctorName;DoctorName)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Remarks;Remarks)
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    Editable = false;
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
                action("Dispatch To Observation Room")
                {
                    ApplicationArea = Basic;
                    Caption = 'Dispatch To Observation Room';

                    trigger OnAction()
                    begin
                        if Confirm('Dispatch selected Appoiintment to Observation?',false)=false then begin exit end;
                          "Dispatch To":="dispatch to"::Observation;
                          "Dispatch Date":=Today;
                          "Dispatch Time":=Time;
                          Modify;
                          Message('Selected Appointment has been dispatched to the Observation Room.')
                    end;
                }
                action("Dispatch To Doctor")
                {
                    ApplicationArea = Basic;
                    Caption = 'Dispatch To Doctor';

                    trigger OnAction()
                    begin
                        if Confirm('Dispatch selected Appoiintment to Doctor?',false)=false then begin exit end;
                          "Dispatch To":="dispatch to"::Doctor;
                          "Dispatch Date":=Today;
                          "Dispatch Time":=Time;
                          Modify;
                          Message('Selected Appointment has been dispatched to the Doctor.')
                    end;
                }
                separator(Action1102760027)
                {
                }
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
        Age: Text[100];
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
        if AppType.Get(AppointmentTypeCode) then begin AppointmentTypeName:=AppType.Description end;
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
            Doctor.CalcFields(Doctor."Doctor's Name");
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
        GetDoctorName(Doctor,DoctorName);
        GetPatientNo("Patient No.","Student No.","Employee No.","Relative No.");
        GetPatientName("Patient No.",PatientName);
        GetPatientAge("Patient No.",Age);
        GetAppointmentStats("Patient No.");
    end;
}

