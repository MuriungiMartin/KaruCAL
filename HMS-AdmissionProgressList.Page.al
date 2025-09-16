#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68953 "HMS-Admission Progress List"
{
    CardPageID = "HMS Admission Progress";
    InsertAllowed = false;
    PageType = List;
    SourceTable = UnknownTable61426;
    SourceTableView = where(Status=const(Admitted));

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
                    Editable = false;
                }
                field("Admission Time";"Admission Time")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Admission Area";"Admission Area")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Ward;Ward)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Bed;Bed)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Doctor;Doctor)
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
            action("&Initiate Discharge")
            {
                ApplicationArea = Basic;
                Caption = '&Initiate Discharge';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    if Confirm('Do you wish to initiate Patient discharge?',false)=false then begin exit end;


                    DischargeHeader.Reset;
                    DischargeHeader.SetRange(DischargeHeader."Admission No.","Admission No.");
                    if DischargeHeader.Find('-') then begin DischargeHeader.DeleteAll end;
                    DischargeHeader.Reset;
                    DischargeHeader.Init;
                      DischargeHeader."Admission No.":="Admission No.";
                      DischargeHeader."Patient No.":="Patient No.";
                      DischargeHeader."Ward No.":= Ward;
                      DischargeHeader."Bed No.":=Bed;
                      DischargeHeader."Date of Admission":="Admission Date";
                      DischargeHeader."Time Of Admission":="Admission Time";
                    DischargeHeader.Insert();

                    DischargeLine.Reset;
                    DischargeLine.SetRange(DischargeLine."Admission No.","Admission No.");
                    if DischargeLine.Find('-') then begin DischargeLine.DeleteAll end;
                    DischargeProcesses.Reset;
                    if DischargeProcesses.Find('-') then
                      begin
                        repeat
                          DischargeLine.Init;
                            DischargeLine."Admission No.":="Admission No.";
                            DischargeLine."Process Code":=DischargeProcesses.Code;
                            DischargeLine.Validate(DischargeLine."Process Code");
                          DischargeLine.Insert();
                        until DischargeProcesses.Next=0;
                      end;

                    Status:=Status::"Discharge Pending";
                    Modify;
                    Message('Patient Admission Discharge Process Initiated');
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
        DischargeHeader: Record UnknownRecord61431;
        DischargeLine: Record UnknownRecord61432;
        DischargeProcesses: Record UnknownRecord61430;


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

