#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68445 "HRM-Performance Plan"
{
    PageType = ListPart;
    SourceTable = UnknownTable61332;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Key Responsibility";"Key Responsibility")
                {
                    ApplicationArea = Basic;
                }
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                }
                field("Key Indicators";"Key Indicators")
                {
                    ApplicationArea = Basic;
                }
                field("Agreed Target Date";"Agreed Target Date")
                {
                    ApplicationArea = Basic;
                }
                field(Weighting;Weighting)
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        if AppraisalTypes.Get("Appraisal Type") then
                        begin
                           if Weighting > AppraisalTypes."Max. Weighting" then
                           begin
                           Message('%1','Value connot be more than the Max. Weighting');
                           Weighting:=AppraisalTypes."Max. Weighting";
                           end;
                        end;
                    end;
                }
                field("Results Achieved Comments";"Results Achieved Comments")
                {
                    ApplicationArea = Basic;
                }
                field("Score/Points";"Score/Points")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        if AppraisalTypes.Get("Appraisal Type") then
                        begin
                           if "Score/Points" > AppraisalTypes."Max. Score" then
                           begin
                           Message('%1','Value connot be more than the Max. Score');
                           "Score/Points":=AppraisalTypes."Max. Score";
                           end;
                        end;
                    end;
                }
            }
        }
    }

    actions
    {
    }

    var
        AppraisalTypes: Record UnknownRecord61325;
}

