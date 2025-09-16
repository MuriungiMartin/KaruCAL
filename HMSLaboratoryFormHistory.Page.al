#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68624 "HMS Laboratory Form History"
{
    PageType = Document;
    SourceTable = UnknownTable61416;
    SourceTableView = where(Status=const(Completed));

    layout
    {
        area(content)
        {
            group(Control19)
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
                field("Scheduled Date";"Scheduled Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Scheduled Time";"Scheduled Time")
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
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
            group("Laboratory Test Findings")
            {
                Caption = 'Laboratory Test Findings';
                part(Control3;"HMS-Labaratory Test Line")
                {
                    Editable = false;
                    SubPageLink = "Laboratory No."=field("Laboratory No.");
                }
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
        Patient: Record UnknownRecord61402;
        User: Record User;
        PatientName: Text[100];
        SupervisorName: Text[100];
        LabLine: Record UnknownRecord61417;
        blnCompleted: Boolean;


    procedure GetPatientName(var PatientNo: Code[20];var PatientName: Text[100])
    begin
        /*Patient.RESET;
        PatientName:='';
        IF Patient.GET(PatientNo) THEN
          BEGIN
            PatientName:=Patient.Surname + ' ' + Patient."Middle Name" + ' ' + Patient."Last Name";
          END;  */

    end;


    procedure GetSupervisorName(var "User ID": Code[20];var SupervisorName: Text[100])
    begin
        /*User.RESET;
        SupervisorName:='';
        IF User.GET("User ID") THEN
          BEGIN
           // SupervisorName:=User.Name;
          END;*/

    end;

    local procedure OnAfterGetCurrRecord()
    begin
        /*xRec := Rec;
        GetPatientName("Patient No.",PatientName);
        GetSupervisorName("Supervisor ID",SupervisorName);*/

    end;
}

