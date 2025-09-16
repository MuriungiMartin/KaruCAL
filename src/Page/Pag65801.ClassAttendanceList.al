#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 65801 "Class Attendance List"
{
    ApplicationArea = Basic;
    CardPageID = "Class Attendance Card";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = UnknownTable65800;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Attendance Date";"Attendance Date")
                {
                    ApplicationArea = Basic;
                }
                field(Semester;Semester)
                {
                    ApplicationArea = Basic;
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
                field("Class Rep. Reg. No";"Class Rep. Reg. No")
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
                field("Number Present";"Number Present")
                {
                    ApplicationArea = Basic;
                }
                field("Number Absent";"Number Absent")
                {
                    ApplicationArea = Basic;
                }
                field("Captured By";"Captured By")
                {
                    ApplicationArea = Basic;
                }
                field("Class Rep. Mail";"Class Rep. Mail")
                {
                    ApplicationArea = Basic;
                }
                field("Class Rep. Phone";"Class Rep. Phone")
                {
                    ApplicationArea = Basic;
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

    var
        HRMEmployeeC: Record UnknownRecord61188;
        ACAUnitsSubjects: Record UnknownRecord61517;
        UnitName: Code[150];
        LectName: Code[150];
}

