#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68143 "HMS-Appointment History Lists"
{
    PageType = List;
    SourceTable = UnknownTable61403;
    SourceTableView = where(Status=filter(<>New));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Appointment No.";"Appointment No.")
                {
                    ApplicationArea = Basic;
                }
                field("Patient Type";"Patient Type")
                {
                    ApplicationArea = Basic;
                }
                field("Patient No.";"Patient No.")
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
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
                field("ReAppointment No.";"ReAppointment No.")
                {
                    ApplicationArea = Basic;
                }
                field("ReAppointment Date";"ReAppointment Date")
                {
                    ApplicationArea = Basic;
                }
                field("ReAppointment Time";"ReAppointment Time")
                {
                    ApplicationArea = Basic;
                }
                field("ReAppointment Type Code";"ReAppointment Type Code")
                {
                    ApplicationArea = Basic;
                }
                field("ReAppointment Doctor ID";"ReAppointment Doctor ID")
                {
                    ApplicationArea = Basic;
                }
                field("Treatment Status";"Treatment Status")
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
                separator(Action16)
                {
                }
            }
        }
    }

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
           // Doctor.CALCFIELDS(Doctor."Doctor's Name");
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

