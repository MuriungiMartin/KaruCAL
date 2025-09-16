#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68138 "HMS-Appointments List"
{
    Caption = 'Appointments';
    CardPageID = "HMS-Appointments Header";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = UnknownTable61402;
    SourceTableView = where("Patient Current Location"=filter(Appointment),
                            "Appointment Status"=filter(Appointment));

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
        area(processing)
        {
            group(Activities)
            {
                Caption = 'Activities';
                action("Apointments list")
                {
                    ApplicationArea = Basic;
                    Caption = 'Apointments list';
                    Image = Allocations;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Page "HMS-Appointment Form Line";
                    RunPageLink = "Patient No."=field("Patient No.");
                }
            }
            group("&Send to..")
            {
                Caption = '&Send to..';
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
                     "Appointment Status":="appointment status"::Cleared;
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
                    
                    /*Create an Doctor*/
                    HMSSetup.Reset;
                    HMSSetup.Get();
                    NewNo:=NoSeriesMgt.GetNextNo(HMSSetup."Doctor Room",0D,true);
                    Doctor.Init;
                      Doctor."Treatment No.":=NewNo;
                      Doctor."Treatment Type":=Doctor."treatment type"::Outpatient;
                      Doctor."Treatment Date":=Today;
                      Doctor."Treatment Time" :=Time;
                      Doctor."Patient No." :="Patient No.";
                      Doctor.Status:=Doctor.Status::New;
                      Doctor."Link No.":="Patient No.";
                      Doctor."Link Type":='Appointment';
                      Doctor.Insert;
                     "Patient Current Location":="patient current location"::"Doctor List";
                     "Doctor Visit Status":="doctor visit status"::Doctor;
                     "Appointment Status":="appointment status"::Cleared;
                    
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

