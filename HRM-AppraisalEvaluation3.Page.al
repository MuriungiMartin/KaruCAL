#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68896 "HRM-Appraisal Evaluation 3"
{
    PageType = List;
    SourceTable = UnknownTable61235;
    SourceTableView = where(Category=const("EMPLOYEE PERFORMANCE FACTOR"));

    layout
    {
    }

    actions
    {
    }

    var
        YesNo: Boolean;
        HRAppraisalEvaluations: Record UnknownRecord61235;
        HREmp: Record UnknownRecord61188;
        HRAppraisalRatings: Record UnknownRecord61237;
        TotalScore: Decimal;
        HRLookupValues: Record UnknownRecord61202;


    procedure TotScore()
    begin
    end;
}

