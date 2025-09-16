#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68890 "HRM-Appraisal Goal Setting L"
{
    PageType = List;
    SourceTable = UnknownTable61233;

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                field("Appraisal No";"Appraisal No")
                {
                    ApplicationArea = Basic;
                }
                field("Appraisal Period";"Appraisal Period")
                {
                    ApplicationArea = Basic;
                }
                field("Planned Targets/Objectives";"Planned Targets/Objectives")
                {
                    ApplicationArea = Basic;
                }
                field("Criteria/Target Date";"Criteria/Target Date")
                {
                    ApplicationArea = Basic;
                    Caption = 'Assesment Criteria';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
                             Updatecontrols();
    end;

    trigger OnInit()
    begin
        /*Targets:=TRUE;
        AssesmentCriteria:=TRUE;
        "Agreement With RatingEditable" := TRUE;
        ScoreEditable := TRUE;
        "Appraisal RatingVisible" := TRUE;
         */

    end;

    var
        HRAppraisalGoalSettingH: Record UnknownRecord61120;
        [InDataSet]
        "Appraisal RatingVisible": Boolean;
        [InDataSet]
        ScoreEditable: Boolean;
        [InDataSet]
        "Agreement With RatingEditable": Boolean;
        Targets: Boolean;
        AssesmentCriteria: Boolean;


    procedure Updatecontrols()
    begin
                            /* HRAppraisalGoalSettingH.SETRANGE(HRAppraisalGoalSettingH."Appraisal No","Appraisal No");
                             IF HRAppraisalGoalSettingH.FIND('-') THEN
                             IF HRAppraisalGoalSettingH.Sent=HRAppraisalGoalSettingH.Sent::"At Appraisee" THEN BEGIN
                             IF Sent<>Sent::"At Appraisee" THEN BEGIN
                             Targets:=TRUE;
                             AssesmentCriteria:=TRUE;
                             "Agreement With RatingEditable" :=TRUE;
                             "Appraisal RatingVisible" :=TRUE;
                             ScoreEditable :=TRUE;
                             CurrPage.Updatecontrols();
                             END ELSE BEGIN
                             Targets:=FALSE;
                             AssesmentCriteria:=FALSE;
                             "Agreement With RatingEditable" :=FALSE;
                             ScoreEditable :=FALSE;
                             CurrPage.Updatecontrols();
                             END;
        */

    end;
}

