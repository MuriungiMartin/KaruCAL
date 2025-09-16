#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68589 "HMS-Radiology View Test Header"
{
    PageType = Document;
    SourceTable = UnknownTable61419;

    layout
    {
        area(content)
        {
            group(Control1)
            {
                field("Radiology No.";"Radiology No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Radiology Area";"Radiology Area")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Link No.";"Link No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Radiology Date";"Radiology Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Radiology Time";"Radiology Time")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Supervisor ID";"Supervisor ID")
                {
                    ApplicationArea = Basic;
                    Editable = false;

                    trigger OnValidate()
                    begin
                        GetSupervisorName("Supervisor ID",SupervisorName);
                    end;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Patient No.";"Patient No.")
                {
                    ApplicationArea = Basic;
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
                field(SupervisorName;SupervisorName)
                {
                    ApplicationArea = Basic;
                    Caption = 'Supervisor Name';
                    Editable = false;
                }
            }
            part(Control1102760004;"HMS-Radiology View Test Line")
            {
                SubPageLink = "Radiology no."=field("Radiology No.");
            }
        }
    }

    actions
    {
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
        SupervisorName: Text[100];
        Patient: Record UnknownRecord61402;
        Supervisor: Record User;


    procedure GetPatientName(var PatientNo: Code[20];var PatientName: Text[100])
    begin
        Patient.Reset;
        PatientName:='';
        if Patient.Get(PatientNo) then
          begin
            PatientName:=Patient.Surname + ' ' + Patient."Middle Name" + ' ' +Patient."Last Name";
          end;
    end;


    procedure GetSupervisorName(var "User ID": Code[20];var SupervisorName: Text[100])
    begin
        Supervisor.Reset;
        SupervisorName:='';
        if Supervisor.Get("User ID") then
          begin
            SupervisorName:=Supervisor."User Name";
          end;
    end;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        GetPatientName("Patient No.",PatientName);
        GetSupervisorName("Supervisor ID",SupervisorName);
    end;
}

