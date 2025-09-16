#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68111 "HMS-Triage Rec. List"
{
    CardPageID = "ACA-Catering Funds Transfer";
    Editable = true;
    InsertAllowed = false;
    PageType = List;
    SourceTable = UnknownTable61402;
    SourceTableView = where("Patient Current Location"=filter(Triage),
                            "Triage Status"=filter(Triage));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Patient No.";"Patient No.")
                {
                    ApplicationArea = Basic;
                }
                field("Patient Type";"Patient Type")
                {
                    ApplicationArea = Basic;
                }
                field("Patient Ref. No.";"Patient Ref. No.")
                {
                    ApplicationArea = Basic;
                }
                field(Surname;Surname)
                {
                    ApplicationArea = Basic;
                }
                field("Middle Name";"Middle Name")
                {
                    ApplicationArea = Basic;
                }
                field("Last Name";"Last Name")
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
                }
                field("ID Number";"ID Number")
                {
                    ApplicationArea = Basic;
                }
                field("Date Registered";"Date Registered")
                {
                    ApplicationArea = Basic;
                }
                field("Correspondence Address 1";"Correspondence Address 1")
                {
                    ApplicationArea = Basic;
                }
                field("Telephone No. 1";"Telephone No. 1")
                {
                    ApplicationArea = Basic;
                }
                field(Email;Email)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(TriageMeasurements)
            {
                ApplicationArea = Basic;
                Caption = 'TriageMeasurements';
                Image = LineDescription;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "HMS-Triage Recordings Lines";
                RunPageLink = "Patient No"=field("Patient No.");
            }
            group("&Send to..")
            {
                Caption = '&Send to..';
            }
            action(sendToAppointment)
            {
                ApplicationArea = Basic;
                Caption = 'Appointment';
                Image = AddAction;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if Confirm('Dispatch selected Patient to Appointment?',false)=false then begin exit end;
                    /*Create an appointment*/
                    HMSSetup.Reset;
                    HMSSetup.Get();
                    NewNo:=NoSeriesMgt.GetNextNo(HMSSetup."Appointment Nos",0D,true);
                    Appointment.Init;
                      Appointment."Appointment No.":=NewNo;
                      Appointment."Appointment Date":=Today;
                      Appointment."Appointment Time":=Time;
                      //Appointment."Appointment Type":=Appointment."Appointment Type"::Registration;
                      Appointment."Patient Type":="Patient Type";
                      Appointment."Patient No.":="Patient No.";
                      Appointment.Doctor:='';
                      //Appointment.Remarks:=Remarks;
                      Appointment.Status:=Appointment.Status::New;
                    Appointment.Insert;
                     "Patient Current Location":="patient current location"::Appointment;
                     "Appointment Status":="appointment status"::Appointment;
                     "Triage Status":="triage status"::Cleared;
                      Modify;
                      Message('Selected Patient has been dispatched to the Appointment Room.!')
                      // Create An Appointment

                end;
            }
            action(sendToObservation)
            {
                ApplicationArea = Basic;
                Caption = 'Observation Room';
                Image = Allocations;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if Confirm('Dispatch selected Patient to Observation?',false)=false then begin exit end;
                     "Patient Current Location":="patient current location"::Observation;
                     "Observation Status":="observation status"::Observation;
                     "Registration Status":="registration status"::Cleared;
                    /*Create an observation*/
                    HMSSetup.Reset;
                    HMSSetup.Get();
                    NewNo:=NoSeriesMgt.GetNextNo(HMSSetup."Observation Nos",0D,true);
                    Observation.Init;
                      Observation."Observation No.":=NewNo;
                      Observation."Observation Date":=Today;
                      Observation."Observation Time":=Time;
                      //observation."Appointment Type":=observation."Appointment Type"::Registration;
                     // observation."Patient Type":="Patient Type";
                      Observation."Patient No.":="Patient No.";
                      Observation."Link No.":="Patient No.";
                      //observationRemarks:=Remarks;
                      Observation.Status:=Observation.Status::New;
                      Observation.Insert;
                     "Patient Current Location":="patient current location"::Observation;
                     "Observation Status":="observation status"::Observation;
                     "Triage Status":="triage status"::Cleared;
                      Modify;
                      Message('Selected Patient has been dispatched to the Observation Room.!')

                end;
            }
            action(sendToDoctorList)
            {
                ApplicationArea = Basic;
                Caption = 'Doctor''s list';
                Image = Register;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if Confirm('Dispatch selected Patient to the Doctor''s List?',false)=false then begin exit end;
                     "Patient Current Location":="patient current location"::"Doctor List";
                     "Doctor Visit Status":="doctor visit status"::Doctor;
                     "Registration Status":="registration status"::Cleared;
                    
                    /*Create an Doctor*/
                    HMSSetup.Reset;
                    HMSSetup.Get();
                    NewNo:=NoSeriesMgt.GetNextNo(HMSSetup."Visit Nos",0D,true);
                    Doctor.Init;
                      Doctor."Treatment No.":=NewNo;
                      Doctor."Treatment Type":=Doctor."treatment type"::Outpatient;
                      Doctor."Treatment Date":=Today;
                      Doctor."Treatment Time" :=Time;
                      Doctor."Patient No." :="Patient No.";
                      Doctor.Status:=Doctor.Status::New;
                      Doctor."Link No.":="Patient No.";
                      Doctor."Link Type":='Registration';
                      Doctor.Insert;
                     "Patient Current Location":="patient current location"::"Doctor List";
                     "Doctor Visit Status":="doctor visit status"::Doctor;
                     "Triage Status":="triage status"::Cleared;
                    
                      Modify;
                      Message('Selected Patient has been dispatched to the Doctor''s List!.')

                end;
            }
        }
    }

    var
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
        Observation: Record UnknownRecord61404;
        Doctor: Record UnknownRecord61407;
}

