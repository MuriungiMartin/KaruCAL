#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68886 "HRM-Appraisal Goal (B)"
{
    PageType = Document;
    PromotedActionCategories = 'New,Process,Reports,Functions,NextPage';
    SourceTable = UnknownTable61232;
    SourceTableView = where(Status=const(Approved));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Appraisal No";"Appraisal No")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field("Employee No";"Employee No")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field("Employee Name";"Employee Name")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field(Supervisor;Supervisor)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Importance = Promoted;
                }
                field("Appraisal Period";"Appraisal Period")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field("Appraisal Stage";"Appraisal Stage")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    Style = StrongAccent;
                    StyleExpr = true;
                }
            }
            part("PERSONAL GOALS/OBJECTIVES";"HRM-Appraisal Goal Set. (B1)")
            {
                Caption = 'PERSONAL GOALS/OBJECTIVES';
                SubPageLink = "Appraisal No"=field("Appraisal No");
            }
            part(SF;"HRM-Appraisal Evaluation Line")
            {
                Caption = 'PERSONAL PROFESSIONAL ATTRIBUTES';
                SubPageLink = "Appraisal No"=field("Appraisal No");
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Functions")
            {
                Caption = '&Functions';
            }
        }
        area(processing)
        {
            action("&Next Page")
            {
                ApplicationArea = Basic;
                Caption = '&Next Page';
                Image = NextSet;
                Promoted = true;
                PromotedCategory = Category5;
                RunObject = Page "HRM-Appraisal Goal Setting";
                RunPageLink = "Appraisal No"=field("Appraisal No");

                trigger OnAction()
                begin
                    //FORM.RUNMODAL(39005843
                    //PAGE.RUN(39003985,Rec);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
                                  if HREmp.Get("Employee No") then
;

    var
        HRAppraisalEvaluationAreas: Record UnknownRecord61124;
        HRAppraisalEvaluations: Record UnknownRecord61123;
        HRAppraisalEvaluationsF: Page "HRM-Appraisal Evaluation Lines";
        HREmp: Record UnknownRecord61067;
}

