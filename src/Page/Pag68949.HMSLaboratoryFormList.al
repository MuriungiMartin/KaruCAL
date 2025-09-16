#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68949 "HMS-Laboratory Form List"
{
    CardPageID = "HMS-Laboratory Form Header";
    PageType = List;
    SourceTable = UnknownTable61416;
    SourceTableView = where(Status=const(New));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Laboratory No.";"Laboratory No.")
                {
                    ApplicationArea = Basic;
                }
                field("Lab. Reference No.";"Lab. Reference No.")
                {
                    ApplicationArea = Basic;
                }
                field("Laboratory Date";"Laboratory Date")
                {
                    ApplicationArea = Basic;
                    Caption = 'Laboratory Date';
                }
                field("Laboratory Time";"Laboratory Time")
                {
                    ApplicationArea = Basic;
                    Caption = 'Laboratory Time';
                }
                field("Request Area";"Request Area")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Link No.";"Link No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Link No.';
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
                field("Scheduled Date";"Scheduled Date")
                {
                    ApplicationArea = Basic;
                }
                field("Scheduled Time";"Scheduled Time")
                {
                    ApplicationArea = Basic;
                }
                field("Supervisor ID";"Supervisor ID")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        GetSupervisorName("Supervisor ID",SupervisorName);
                    end;
                }
                field(SupervisorName;SupervisorName)
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
                field("Employee No.1";"Employee No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Relative No.";"Relative No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Student No.1";"Student No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&Forward for Findings")
            {
                ApplicationArea = Basic;
                Caption = '&Forward for Findings';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    /*Ask for userconfirmation*/
                    if Confirm('Forward the Laboratory Request?',true)=false then begin exit end;
                    Status:=Status::Forwarded;
                    Modify;
                    Message('Laboratory Test Request Forwarded');

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
        Patient: Record UnknownRecord61402;
        User: Record User;
        PatientName: Text[100];
        SupervisorName: Text[100];


    procedure GetPatientName(var PatientNo: Code[20];var PatientName: Text[100])
    begin
        Patient.Reset;
        PatientName:='';
        if Patient.Get(PatientNo) then
          begin
            PatientName:=Patient.Surname + ' ' + Patient."Middle Name" + ' ' + Patient."Last Name";
          end;
    end;


    procedure GetSupervisorName(var "User ID": Code[20];var SupervisorName: Text[100])
    begin
        User.Reset;
        SupervisorName:='';
        if User.Get("User ID") then
          begin
            SupervisorName:=User."Full Name";
          end;
    end;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        GetPatientName("Patient No.",PatientName);
        //GetSupervisorName("Supervisor ID",SupervisorName);
    end;
}

