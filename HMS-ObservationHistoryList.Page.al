#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68146 "HMS-Observation History List"
{
    CardPageID = "HMS Observation Form Header Cl";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = UnknownTable61404;
    SourceTableView = where(Closed=const(Yes));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Observation No.";"Observation No.")
                {
                    ApplicationArea = Basic;
                }
                field("Patient No.";"Patient No.")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field("Observation Type";"Observation Type")
                {
                    ApplicationArea = Basic;
                }
                field("Link No.";"Link No.")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        if "Observation Type"="observation type"::Appointment then
                          begin
                            GetAppointmentDetails();
                          end
                    end;
                }
                field("Observation Date";"Observation Date")
                {
                    ApplicationArea = Basic;
                }
                field("Observation Time";"Observation Time")
                {
                    ApplicationArea = Basic;
                }
                field("Observation User ID";"Observation User ID")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(ObservationUserIDName;ObservationUserIDName)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Observation Remarks";"Observation Remarks")
                {
                    ApplicationArea = Basic;
                }
                field(Closed;Closed)
                {
                    ApplicationArea = Basic;
                    Caption = 'Released';
                    Editable = false;
                }
                field("Student No.";"Student No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Employee No.";"Employee No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Relative No.";"Relative No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(PatientName;PatientName)
                {
                    ApplicationArea = Basic;
                    Caption = 'Patient Name';
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        //OnAfterGetCurrRecord;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        OnAfterGetCurrRecord;
    end;

    var
        PatientName: Text[100];
        ObservationUserIDName: Text[30];
        Appointment: Record UnknownRecord61403;
        Patient: Record UnknownRecord61402;
        User: Record User;


    procedure GetAppointmentDetails()
    begin
        /*Get the appointment details from the database*/
        Appointment.Reset;
        if Appointment.Get("Link No.") then
          begin
            "Patient No.":=Appointment."Patient No.";
            "Student No.":=Appointment."Student No.";
            "Employee No.":=Appointment."Employee No.";
            "Relative No.":=Appointment."Relative No.";
            "Link Type" :='Appointment';
            GetPatientName("Patient No.",PatientName);
          end;

    end;


    procedure GetVisitDetails()
    begin
    end;


    procedure GetAdmissionDetails()
    begin
    end;


    procedure GetPatientName(var PatientNo: Code[20];var PatientName: Text[100])
    begin
        Patient.Reset;
        PatientName:='';
        if Patient.Get(PatientNo) then
          begin
            PatientName:=Patient.Surname + ' ' + Patient."Middle Name" + ' ' + Patient."Last Name";
          end;
    end;


    procedure GetUserName()
    begin
        User.Reset;
        if User.Get("Observation User ID") then
          begin
            ObservationUserIDName:=User."User Name";
          end;
    end;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;

        //VALIDATE("Patient No.");
        GetPatientName("Patient No.",PatientName);
        GetUserName;
    end;
}

