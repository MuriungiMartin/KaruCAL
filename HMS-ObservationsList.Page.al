#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68144 "HMS-Observations List"
{
    Caption = 'Appointments';
    CardPageID = "HMS-Observations Header";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = UnknownTable61404;
    SourceTableView = where(Closed=filter(No));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Observation No.";"Observation No.")
                {
                    ApplicationArea = Basic;
                }
                field("Observation Type";"Observation Type")
                {
                    ApplicationArea = Basic;
                }
                field("Observation Date";"Observation Date")
                {
                    ApplicationArea = Basic;
                }
                field("Observation Time";"Observation Time")
                {
                    ApplicationArea = Basic;
                }
                field("Patient No.";"Patient No.")
                {
                    ApplicationArea = Basic;
                }
                field("Patient Name";PatientName)
                {
                    ApplicationArea = Basic;
                }
                field("Observation User ID";"Observation User ID")
                {
                    ApplicationArea = Basic;
                }
                field("Observation Remarks";"Observation Remarks")
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
                action("Observation Details")
                {
                    ApplicationArea = Basic;
                    Caption = 'Observation Details';
                    Image = Allocations;
                    Promoted = true;
                    RunObject = Page "HMS-Observation Form Header";
                    RunPageLink = "Patient No."=field("Patient No.");
                }
            }
            group("&Send to..")
            {
                Caption = '&Send to..';
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
                    // "Patient Current Location":="Patient Current Location"::"Doctor List";
                    // "Doctor Visit Status":="Doctor Visit Status"::Doctor;
                     //"Observation Status":="Observation Status"::Cleared;
                    
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

