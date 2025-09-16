#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 65800 "Class Attendance Card"
{
    PageType = Card;
    SourceTable = UnknownTable65800;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Attendance Date";"Attendance Date")
                {
                    ApplicationArea = Basic;
                }
                field(Semester;Semester)
                {
                    ApplicationArea = Basic;
                }
                field("Class Rep. Reg. No";"Class Rep. Reg. No")
                {
                    ApplicationArea = Basic;
                    Caption = 'Class Representative';
                }
                field("Lecturer Code";"Lecturer Code")
                {
                    ApplicationArea = Basic;
                }
                field(LectName;LectName)
                {
                    ApplicationArea = Basic;
                    Caption = 'Lecturer Name';
                    Enabled = false;
                }
                field("Unit Code";"Unit Code")
                {
                    ApplicationArea = Basic;
                }
                field("From Time";"From Time")
                {
                    ApplicationArea = Basic;
                }
                field("To Time";"To Time")
                {
                    ApplicationArea = Basic;
                }
                field("Class Type";"Class Type")
                {
                    ApplicationArea = Basic;
                }
            }
            group(ATtDet)
            {
                Caption = 'Attendance Details';
                part(Control1000000011;"Class Attendance Details Part")
                {
                    Caption = 'Attendance';
                    SubPageLink = Semester=field(Semester),
                                  "Attendance Date"=field("Attendance Date"),
                                  "Lecturer Code"=field("Lecturer Code"),
                                  "Unit Code"=field("Unit Code");
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        Clear(UnitName);
        Clear(LectName);
        //ACAUnitsSubjects.RESET;
        //ACAUnitsSubjects.SETRANGE()

        if HRMEmployeeC.Get("Lecturer Code") then begin
            LectName:=HRMEmployeeC."First Name"+' '+HRMEmployeeC."Middle Name"+' '+HRMEmployeeC."Last Name";
          end;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Attendance Date":=Today;
        ACASemester.Reset;
        ACASemester.SetRange("Current Semester",true);
        if ACASemester.Find('-') then begin
          Semester:=ACASemester.Code;
          end;
        "Captured By":=UserId;
    end;

    var
        HRMEmployeeC: Record UnknownRecord61188;
        ACAUnitsSubjects: Record UnknownRecord61517;
        UnitName: Code[150];
        LectName: Code[150];
        ACASemester: Record UnknownRecord61692;
}

