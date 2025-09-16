#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68580 "HMS-Laboratory Form Test"
{
    PageType = Document;
    SourceTable = UnknownTable61416;

    layout
    {
        area(content)
        {
            group(Control1)
            {
                field("Laboratory No.";"Laboratory No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Lab. Reference No.";"Lab. Reference No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Laboratory Date";"Laboratory Date")
                {
                    ApplicationArea = Basic;
                    Caption = 'Laboratory Date';
                    Editable = false;
                }
                field("Laboratory Time";"Laboratory Time")
                {
                    ApplicationArea = Basic;
                    Caption = 'Laboratory Time';
                    Editable = false;
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
                field("Student No.2";"Student No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Scheduled Date";"Scheduled Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("<Gender>";Patient.Gender)
                {
                    ApplicationArea = Basic;
                    Caption = 'Gender';
                    Description = 'Gender';
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
                field("Relative No.1";"Relative No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Employee No.2";"Employee No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Date of Birth";Patient."Date Of Birth")
                {
                    ApplicationArea = Basic;
                    Caption = 'Date of Birth';
                }
                field(Age;Age)
                {
                    ApplicationArea = Basic;
                    Caption = 'Age';
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
            group("Laboratory Test Findings")
            {
                Caption = 'Laboratory Test Findings';
                part(Control1000000000;"HMS-Labaratory Test Line")
                {
                    SubPageLink = "Laboratory No."=field("Laboratory No.");
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Register Item Usage")
            {
                ApplicationArea = Basic;
                Caption = 'Register Item Usage';
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "HMS Laboratory Item Header";
                RunPageLink = "Laboratory No."=field("Laboratory No.");
            }
            action("&Mark as Completed")
            {
                ApplicationArea = Basic;
                Caption = '&Mark as Completed';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    if Confirm('Mark the Laboratory Test as Completed?',false)=false then exit;
                    blnCompleted:=true;
                    LabLine.Reset;
                    LabLine.SetRange(LabLine."Laboratory No.","Laboratory No.");
                    if LabLine.Find('-') then
                      begin
                        repeat
                          if LabLine.Completed=false then blnCompleted:=false;
                        until LabLine.Next=0;
                      end;

                    if blnCompleted=false then
                      begin
                        Error('Please ensure that all the tests are marked as completed');
                      end
                    else
                      begin
                        Status:=Status::Completed;
                        Modify;
                        Message('Laboratory Test Marked as Completed');
                      end;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        OnAfterGetCurrRecord;
        Patient.Reset;
        Patient.SetRange("Patient No.",Rec."Patient No.");
        if Patient.Find('-') then begin
          end;
        Clear(Age);
        if Patient."Date Of Birth"<>0D then begin
          Age:=HRDates.DetermineAge(Patient."Date Of Birth",Today);
          end;
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
        LabLine: Record UnknownRecord61417;
        blnCompleted: Boolean;
        Age: Text[100];
        HRDates: Codeunit "HR Dates";


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
        /*
        User.RESET;
        SupervisorName:='';
        IF User.GET("User ID") THEN
          BEGIN
            SupervisorName:=User."User Name";
          END;
         */

    end;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        GetPatientName("Patient No.",PatientName);
        GetSupervisorName("Supervisor ID",SupervisorName);
    end;
}

