#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 65219 "Lect Posted Load Lines"
{
    ApplicationArea = Basic;
    AutoSplitKey = false;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = UnknownTable65201;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                FreezeColumn = "Courses Count";
                field("Lecturer Code";"Lecturer Code")
                {
                    ApplicationArea = Basic;
                }
                field("Lecturer Name";"Lecturer Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Phone;Phone)
                {
                    ApplicationArea = Basic;
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
                field("Appointment Later Ref. No.";"Appointment Later Ref. No.")
                {
                    ApplicationArea = Basic;
                }
                field("Appointment Later Ref.";"Appointment Later Ref.")
                {
                    ApplicationArea = Basic;
                }
                field("Department Name";"Department Name")
                {
                    ApplicationArea = Basic;
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

    var
        LectLoadCustProdSource: Record UnknownRecord65202;
}

