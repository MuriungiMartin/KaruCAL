#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69048 "HRM-Job Applicants - Appt. Res"
{
    PageType = List;
    SourceTable = UnknownTable61668;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Applicant No";"Applicant No")
                {
                    ApplicationArea = Basic;
                }
                field(Stage;Stage)
                {
                    ApplicationArea = Basic;
                }
                field("Interview Code";"Interview Code")
                {
                    ApplicationArea = Basic;
                }
                field("Interview Description";"Interview Description")
                {
                    ApplicationArea = Basic;
                }
                field(Score;Score)
                {
                    ApplicationArea = Basic;
                }
                field(Interviwer;Interviwer)
                {
                    ApplicationArea = Basic;
                }
                field("Interviewer Name";"Interviewer Name")
                {
                    ApplicationArea = Basic;
                }
                field(comments;comments)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Load Interview Details")
            {
                Caption = 'Load Interview Details';
                action(Action1000000000)
                {
                    ApplicationArea = Basic;
                    Caption = 'Load Interview Details';
                    Image = ApplicationWorksheet;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = false;

                    trigger OnAction()
                    begin
                        RecruitmentReq.SetRange(RecruitmentReq."Stage Code",Stage);
                        if RecruitmentReq.Find('-') then begin
                        repeat
                         Stage:= RecruitmentReq."Stage Code" ;
                         "Interview Code":=RecruitmentReq."Qualification Code";
                         "Interview Description":=RecruitmentReq."Qualification Description";
                         until RecruitmentReq.Next=0;

                        end;
                    end;
                }
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Stage:=Appt.Stage;
    end;

    var
        RecruitmentReq: Record UnknownRecord61209;
        Appt: Record UnknownRecord61667;
}

