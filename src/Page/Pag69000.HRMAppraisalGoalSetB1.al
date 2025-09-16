#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69000 "HRM-Appraisal Goal Set. (B1)"
{
    PageType = List;
    SourceTable = UnknownTable61233;

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                field("Planned Targets/Objectives";"Planned Targets/Objectives")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Criteria/Target Date";"Criteria/Target Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Score;Score)
                {
                    ApplicationArea = Basic;
                }
                field("Target Points (Total=100)";"Target Points (Total=100)")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        "Agreement With RatingEditable" := true;
        ScoreVisible := true;
        "Appraisal RatingVisible" := true;
    end;

    trigger OnOpenPage()
    begin

                             HRAppraisalGoalSettingH.SetRange("Appraisal No","Appraisal No");
                             if HRAppraisalGoalSettingH.Find('-') then
                             if HRAppraisalGoalSettingH.Status=HRAppraisalGoalSettingH.Status::Open then begin
                             "Agreement With RatingEditable" :=false;
                             "Appraisal RatingVisible" :=false;
                             ScoreVisible :=false;
                             end else begin
                             "Agreement With RatingEditable" :=true;
                             end;
    end;

    var
        HRAppraisalGoalSettingH: Record UnknownRecord61232;
        [InDataSet]
        "Appraisal RatingVisible": Boolean;
        [InDataSet]
        ScoreVisible: Boolean;
        [InDataSet]
        "Agreement With RatingEditable": Boolean;
}

