#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 65211 "Lect Load Batch Lines"
{
    AutoSplitKey = false;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = UnknownTable65201;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                FreezeColumn = "Courses Count";
                field(No;"Lecturer Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'No';
                }
                field("Lecturer Name";"Lecturer Name")
                {
                    ApplicationArea = Basic;
                }
                field("Faculty Name";"Faculty Name")
                {
                    ApplicationArea = Basic;
                }
                field("Department Code";"Department Code")
                {
                    ApplicationArea = Basic;
                }
                field("Department Name";"Department Name")
                {
                    ApplicationArea = Basic;
                }
                field(Campus;Campus)
                {
                    ApplicationArea = Basic;
                }
                field(Phone;Phone)
                {
                    ApplicationArea = Basic;
                    Enabled = false;
                }
                field("Courses Count";"Courses Count")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Approve;Approve)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Reject;Reject)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Reject Reason";"Reject Reason")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Admissible;Admissible)
                {
                    ApplicationArea = Basic;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic;
                    Enabled = false;
                }
                field("Appointment Later Ref. No.";"Appointment Later Ref. No.")
                {
                    ApplicationArea = Basic;
                    Enabled = false;
                }
                field("Appointment Later Ref.";"Appointment Later Ref.")
                {
                    ApplicationArea = Basic;
                    Enabled = false;
                }
                field(Names;HRMEmployeeC.Names)
                {
                    ApplicationArea = Basic;
                    Caption = 'Names';
                }
                field(Number;HRMEmployeeC."No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Number';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(cancelLoad)
            {
                ApplicationArea = Basic;
                Caption = 'Cancel the Load';
                Image = CancelAllLines;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if Rec.Approve then Error('The Load is already approved!');
                    if Confirm('Cancel the Load for '+Rec."Lecturer Code"+'?',false)=false then exit;

                    LectLoadCustProdSource.Reset;
                    LectLoadCustProdSource.SetRange(LectLoadCustProdSource.Lecturer,Rec."Semester Code");
                    LectLoadCustProdSource.SetRange(LectLoadCustProdSource.Programme,Rec."Lecturer Code");
                    if LectLoadCustProdSource.Find('-') then begin
                        LectLoadCustProdSource.DeleteAll;
                      end;

                    Message('The Load details have been deleted.');
                end;
            }
            action(PrinAppointment)
            {
                ApplicationArea = Basic;
                Caption = 'Print Appointment Letter';
                Image = PrintAcknowledgement;
                Promoted = true;
                PromotedIsBig = true;
                ShortCutKey = 'F5';
                Visible = VisibleStatus;

                trigger OnAction()
                var
                    counted: Integer;
                    LectLoadBatchLines: Record UnknownRecord65201;
                begin
                    LectLoadBatchLines.Reset;
                    LectLoadBatchLines.SetRange("Semester Code",Rec."Semester Code");
                    LectLoadBatchLines.SetRange("Lecturer Code",Rec."Lecturer Code");
                    if LectLoadBatchLines.Find('-') then begin
                      if Rec.Approve then
                        Report.Run(65201,true,false,LectLoadBatchLines);
                      end;
                end;
            }
            action(CourseLoad)
            {
                ApplicationArea = Basic;
                Caption = 'Course Loading Summary';
                Image = PrintAcknowledgement;
                Promoted = true;
                PromotedIsBig = true;
                ShortCutKey = 'F5';

                trigger OnAction()
                var
                    counted: Integer;
                    LectLoadBatchLines: Record UnknownRecord65201;
                begin
                    LectLoadBatchLines.Reset;
                    LectLoadBatchLines.SetRange("Semester Code",Rec."Semester Code");
                    //LectLoadBatchLines.SETRANGE("Lecturer Code",Rec."Lecturer Code");
                    if LectLoadBatchLines.Find('-') then begin
                        Report.Run(69270,true,false,LectLoadBatchLines);
                      end;
                end;
            }
            action(ClassList)
            {
                ApplicationArea = Basic;
                Caption = 'Class List';
                Image = List;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Report "Course Class List";
            }
            action(AttendanceList)
            {
                ApplicationArea = Basic;
                Caption = 'Attendance List';
                Image = ListPage;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ACALecturersUnits: Record UnknownRecord65202;
                begin
                    ACALecturersUnits.Reset;
                    ACALecturersUnits.SetRange(Semester,Rec."Semester Code");
                    ACALecturersUnits.SetRange(Lecturer,Rec."Lecturer Code");
                    if ACALecturersUnits.Find('-') then begin
                        Report.Run(65207,true,false,ACALecturersUnits);
                      end;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Clear(EmpName);
        if HRMEmployeeC.Get("Lecturer Code") then begin
          EmpName:=HRMEmployeeC."First Name"+' '+HRMEmployeeC."Middle Name"+' '+HRMEmployeeC."Last Name"
          end;

        if Approve then VisibleStatus:=true else VisibleStatus:=false;
    end;

    var
        LectLoadCustProdSource: Record UnknownRecord65202;
        EmpName: Code[200];
        HRMEmployeeC: Record UnknownRecord61188;
        VisibleStatus: Boolean;
        ACALecturersUnits: Record UnknownRecord65202;
}

