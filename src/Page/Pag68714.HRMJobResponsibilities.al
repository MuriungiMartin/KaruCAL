#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68714 "HRM-Job Responsibilities"
{
    Caption = 'HR Job Responsibilities';
    DeleteAllowed = true;
    InsertAllowed = true;
    ModifyAllowed = true;
    PageType = Card;
    PromotedActionCategories = 'New,Process,Reports,Qualification';
    SourceTable = UnknownTable61192;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'Job Details';
                field("Job ID";"Job ID")
                {
                    ApplicationArea = Basic;
                }
                field("Responsibility Code";"Responsibility Code")
                {
                    ApplicationArea = Basic;
                }
                field("Responsibility Description";"Responsibility Description")
                {
                    ApplicationArea = Basic;
                }
                field(Remarks;Remarks)
                {
                    ApplicationArea = Basic;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1102755013;Outlook)
            {
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Import Evaluation Areas")
            {
                ApplicationArea = Basic;
                Image = Import;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                begin

                    //DELETE RESPONSIBILITIES PREVIOUSLY IMPORTED
                    HRJobResponsibilities.Reset;
                    HRJobResponsibilities.SetRange(HRJobResponsibilities."Job ID","Job ID");
                    if HRJobResponsibilities.Find('-') then
                    HRJobResponsibilities.DeleteAll;

                    //IMPORT EVALUATION AREAS FOR THIS JOB
                    HRAppraisalEvaluationAreas.Reset;
                    HRAppraisalEvaluationAreas.SetRange(HRAppraisalEvaluationAreas."Assign To","Job ID");
                    if HRAppraisalEvaluationAreas.Find('-') then
                    HRAppraisalEvaluationAreas.FindFirst;
                    begin
                         HRJobResponsibilities.Reset;
                              repeat
                                  HRJobResponsibilities.Init;
                                  HRJobResponsibilities."Job ID":="Job ID";
                                  HRJobResponsibilities."Responsibility Code":=HRAppraisalEvaluationAreas.Code;
                                  HRJobResponsibilities."Responsibility Description":= HRAppraisalEvaluationAreas.Description;
                                  HRJobResponsibilities.Insert();
                              until HRAppraisalEvaluationAreas.Next=0;
                    end;
                end;
            }
        }
    }

    var
        HRJobResponsibilities: Record UnknownRecord61192;
        HRAppraisalEvaluationAreas: Record UnknownRecord61236;
}

