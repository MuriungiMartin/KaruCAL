#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68575 "HMS-Treatment Form Admission"
{
    PageType = Document;
    SourceTable = UnknownTable61414;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field("Ward No.";"Ward No.")
                {
                    ApplicationArea = Basic;
                }
                field("Bed No.";"Bed No.")
                {
                    ApplicationArea = Basic;
                }
                field("Date Of Admission";"Date Of Admission")
                {
                    ApplicationArea = Basic;
                }
                field("Admission Reason";"Admission Reason")
                {
                    ApplicationArea = Basic;
                }
                field("Admission Remarks";"Admission Remarks")
                {
                    ApplicationArea = Basic;
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
            action("&Place Request")
            {
                ApplicationArea = Basic;
                Caption = '&Place Request';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    /*Ask for user confirmation*/
                    HMSSetup.Reset;
                    HMSSetup.Get();
                    NewNo:=NoSeriesMgt.GetNextNo(HMSSetup."Admission Request Nos",0D,true);
                    if Confirm('Send the admission request?',false)=false then begin exit end;
                    TreatmentHeader.Reset;
                    if TreatmentHeader.Get("Treatment No.") then
                      begin
                        AdmissionHeader.Reset;
                        AdmissionHeader.Init;
                           AdmissionHeader."Admission No.":=NewNo;
                           AdmissionHeader."Admission Date":=Today;
                           AdmissionHeader."Admission Time":=Time;
                           AdmissionHeader."Admission Area":=AdmissionHeader."admission area"::Doctor;
                           AdmissionHeader."Patient No.":=TreatmentHeader."Patient No.";
                           AdmissionHeader."Employee No.":=TreatmentHeader."Treatment No.";
                           AdmissionHeader."Relative No.":=TreatmentHeader."Relative No.";
                           AdmissionHeader.Ward:="Ward No.";
                           AdmissionHeader.Bed:="Bed No.";
                           AdmissionHeader.Doctor:=TreatmentHeader."Doctor ID";
                           AdmissionHeader.Remarks:="Admission Remarks";
                           AdmissionHeader."Admission Reason":="Admission Reason";
                           AdmissionHeader."Student No.":=TreatmentHeader."Student No.";
                           AdmissionHeader."Link Type":='Doctor';
                           AdmissionHeader."Link No.":=TreatmentHeader."Treatment No.";
                        AdmissionHeader.Insert();
                        Message('The Admission Request has been sent');
                      end;

                end;
            }
        }
    }

    var
        TreatmentHeader: Record UnknownRecord61407;
        TreatmentLine: Record UnknownRecord61414;
        AdmissionHeader: Record UnknownRecord61426;
        HMSSetup: Record UnknownRecord61386;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        NewNo: Code[20];
}

