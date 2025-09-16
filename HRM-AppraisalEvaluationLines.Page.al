#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68888 "HRM-Appraisal Evaluation Lines"
{
    PageType = List;
    SourceTable = UnknownTable61235;
    SourceTableView = where(Category=const("JOB SPECIFIC EVALUATION AREA"));

    layout
    {
        area(content)
        {
            repeater(Control1102755004)
            {
                Editable = false;
            }
            field("Evaluation Code";"Evaluation Code")
            {
                ApplicationArea = Basic;
            }
            field("Evaluation Description";"Evaluation Description")
            {
                ApplicationArea = Basic;
            }
            field(Category;Category)
            {
                ApplicationArea = Basic;
            }
            field("Sub Category";"Sub Category")
            {
                ApplicationArea = Basic;
            }
        }
    }

    actions
    {
    }

    var
        YesNo: Boolean;
        HRAppraisalEvaluations: Record UnknownRecord61123;
        HREmp: Record UnknownRecord61067;
        HRAppraisalRatings: Record UnknownRecord61125;
        TotalScore: Decimal;


    procedure TotScore()
    begin
    end;
}

