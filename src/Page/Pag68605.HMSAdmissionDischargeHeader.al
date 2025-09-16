#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68605 "HMS Admission Discharge Header"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Document;
    SourceTable = UnknownTable61431;
    SourceTableView = where(Status=const(New));

    layout
    {
        area(content)
        {
            group(Control1)
            {
                field("Admission No.";"Admission No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Discharge Date";"Discharge Date")
                {
                    ApplicationArea = Basic;
                    Caption = 'Discharge Date/Time';
                    Editable = false;
                }
                field("Discharge Time";"Discharge Time")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Patient No.";"Patient No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(PatientName;PatientName)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Date of Admission";"Date of Admission")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Time Of Admission";"Time Of Admission")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Ward No.";"Ward No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Bed No.";"Bed No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Doctor ID";"Doctor ID")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        Doctor.Reset;
                        if Doctor.Get("Doctor ID") then
                          begin
                            Doctor.CalcFields(Doctor."Doctor's Name");
                            DoctorName:=Doctor."Doctor's Name";
                          end;
                    end;
                }
                field(DoctorName;DoctorName)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Nurse ID";"Nurse ID")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        User.Reset;
                        if User.Get("Nurse ID") then
                          begin
                          //  NurseName:=User.Name;
                          end;
                    end;
                }
                field(NurseName;NurseName)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Remarks;Remarks)
                {
                    ApplicationArea = Basic;
                }
            }
            part(Control1102760003;"HMS Admission Discharge Line")
            {
                SubPageLink = "Admission No."=field("Admission No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&Discharge")
            {
                ApplicationArea = Basic;
                Caption = '&Discharge';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    if Confirm('Discharge Patient?',false)=false then begin exit end;
                    Lines.Reset;
                    Lines.SetRange(Lines."Admission No.","Admission No.");
                    if Lines.Find('-') then
                      begin
                        repeat
                          Lines.CalcFields(Lines.Mandatory);
                          blnMand:=Lines.Mandatory;
                          if blnMand<>Lines.Done then
                            begin
                              Message('Please ensure that the Mandatory processes are finished first');
                            end;
                        until Lines.Next=0;
                      end;

                    Admission.Reset;
                    if Admission.Get("Admission No.") then
                      begin
                        Admission.Status:=Admission.Status::Discharged;
                        Admission.Modify;
                        "Discharge Date":=Today;
                        "Discharge Time":=Time;
                        Status:=Status::Completed;
                        Modify;
                      end;
                end;
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
        PatientName: Text[200];
        DoctorName: Text[200];
        NurseName: Text[200];
        Doctor: Record UnknownRecord61387;
        User: Record User;
        Patient: Record UnknownRecord61402;
        Lines: Record UnknownRecord61432;
        blnMand: Boolean;
        Admission: Record UnknownRecord61426;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        Doctor.Reset;
        DoctorName:='';
        if Doctor.Get("Doctor ID") then
          begin
            Doctor.CalcFields(Doctor."Doctor's Name");
            DoctorName:=Doctor."Doctor's Name";
          end;
        User.Reset;
        NurseName:='';
        if User.Get("Nurse ID") then
          begin
           // NurseName:=User.Name;
          end;
        Patient.Reset;
        PatientName:='';
        if Patient.Get("Patient No.") then
          begin
            PatientName:=Patient.Surname + ' ' +Patient."Middle Name" + ' ' +Patient."Last Name";
          end;
    end;
}

