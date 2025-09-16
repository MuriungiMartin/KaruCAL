#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68952 "HMS-Admission Form Header List"
{
    CardPageID = "HMS Admission Form Header";
    PageType = List;
    SourceTable = UnknownTable61426;
    SourceTableView = where(Status=const(New));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Admission No.";"Admission No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Admission Date";"Admission Date")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field("Admission Time";"Admission Time")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field("Admission Area";"Admission Area")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Ward;Ward)
                {
                    ApplicationArea = Basic;
                }
                field(Bed;Bed)
                {
                    ApplicationArea = Basic;
                }
                field(Doctor;Doctor)
                {
                    ApplicationArea = Basic;
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
                field("Employee No.";"Employee No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Employee No./Relative No.';
                    Editable = false;
                }
                field("Relative No.";"Relative No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Student No.";"Student No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Admission Reason";"Admission Reason")
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
            action("&Admit Patient")
            {
                ApplicationArea = Basic;
                Caption = '&Admit Patient';
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    if Confirm('Admit Patient?',true)=false then begin exit end;
                    Status:=Status::Admitted;
                    Modify;
                    Message('Patient Admitted');
                end;
            }
            action("&Cancel Admission")
            {
                ApplicationArea = Basic;
                Caption = '&Cancel Admission';
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    if Confirm('Cancel the Admission Request?',false)=false then begin exit end;
                    //Status:=Status::Cancelled;
                    Modify;
                    Message('Admission Request Cancelled');
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
        PatientName: Text[100];
        Patient: Record UnknownRecord61402;


    procedure GetPatientName(var PatientNo: Code[20];var PatientName: Text[100])
    begin
        Patient.Reset;
        PatientName:='';
        if Patient.Get(PatientNo) then
          begin
            PatientName:=Patient.Surname + ' ' + Patient."Middle Name" + ' ' +Patient."Last Name";
          end;
    end;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        GetPatientName("Patient No.",PatientName);
    end;
}

