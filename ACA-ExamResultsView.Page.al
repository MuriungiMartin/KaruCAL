#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 78024 "ACA-Exam Results View"
{
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = false;
    PageType = List;
    SourceTable = UnknownTable61548;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Semester;Semester)
                {
                    ApplicationArea = Basic;
                }
                field(Unit;Unit)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field(Score;Score)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field(Exam;Exam)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field(ExamType;ExamType)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Academic Year";"Academic Year")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(ArchiveScore)
            {
                ApplicationArea = Basic;
                Caption = 'Archive Score';
                Image = DeleteAllBreakpoints;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    Clear(UserSetup);
                    UserSetup.Reset;
                    UserSetup.SetRange("User ID",UserId);
                    if UserSetup.Find('-') then begin
                      UserSetup.TestField("Can Archive Results");
                      Clear(ACAExamResults);
                      ACAExamResults.Reset;
                      ACAExamResults.SetRange("Student No.",Rec."Student No.");
                      ACAExamResults.SetRange(Programme,Rec.Programme);
                      ACAExamResults.SetRange(Stage,Rec.Stage);
                      ACAExamResults.SetRange(Unit,Rec.Unit);
                      ACAExamResults.SetRange(Semester,Rec.Semester);
                      ACAExamResults.SetRange(ExamType,Rec.ExamType);
                      ACAExamResults.SetRange("Reg. Transaction ID",Rec."Reg. Transaction ID");
                      ACAExamResults.SetRange("Entry No",Rec."Entry No");
                      if ACAExamResults.Find('-') then
                      ACAExamResults.Delete(true);
                      end else Error('Access Denied!');
                    if Confirm('Archive unit score?',false) = false then Error('Cancelled!');
                end;
            }
        }
    }

    var
        UserSetup: Record "User Setup";
        ACAExamResults: Record UnknownRecord61548;
}

