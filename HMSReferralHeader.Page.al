#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68609 "HMS Referral Header"
{
    PageType = Document;
    SourceTable = UnknownTable61433;
    SourceTableView = where(Status=const(New));

    layout
    {
        area(content)
        {
            group(Control1)
            {
                field("Treatment no.";"Treatment no.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Date Referred";"Date Referred")
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
                field("Hospital No.";"Hospital No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(HospitalName;HospitalName)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Referral Reason";"Referral Reason")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Referral Remarks";"Referral Remarks")
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
            group("&Functions")
            {
                Caption = '&Functions';
                action("Referral Completed")
                {
                    ApplicationArea = Basic;
                    Caption = 'Referral Completed';
                    Image = Refresh;
                    Promoted = true;

                    trigger OnAction()
                    begin
                        if Confirm('Referrral Confirmed?',true)=false then begin exit end;

                        Status:=Status::Released;
                        Modify;
                        Message('The Referral has been confirmed');
                    end;
                }
                action("Progress Notes")
                {
                    ApplicationArea = Basic;
                    Caption = 'Progress Notes';
                    Image = PutawayLines;
                    Promoted = true;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name"=const(15),
                                  "No."=field("Treatment no.");
                }
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
        HospitalName: Text[100];
        Patient: Record UnknownRecord61402;
        Hospital: Record Vendor;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        PatientName:='';
        HospitalName:='';

        Patient.Reset;
        if Patient.Get("Patient No.") then
          begin
            PatientName:=Patient.Surname + ' ' + Patient."Middle Name" + ' ' + Patient."Last Name";
          end;

        Hospital.Reset;
        if Hospital.Get("Hospital No.") then
          begin
            HospitalName:=Hospital.Name;
          end;
    end;
}

