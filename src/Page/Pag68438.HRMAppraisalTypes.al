#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68438 "HRM-Appraisal Types"
{
    PageType = ListPart;
    SourceTable = UnknownTable61325;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field("Max. Weighting";"Max. Weighting")
                {
                    ApplicationArea = Basic;
                }
                field("Max. Score";"Max. Score")
                {
                    ApplicationArea = Basic;
                }
                field("Use Template";"Use Template")
                {
                    ApplicationArea = Basic;
                }
                field("Template Link";"Template Link")
                {
                    ApplicationArea = Basic;
                }
                field(Remarks;Remarks)
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
            group(Appraisal)
            {
                Caption = 'Appraisal';
                action("Appraisal Format")
                {
                    ApplicationArea = Basic;
                    Caption = 'Appraisal Format';
                    RunObject = Page "HRM-Appraisal Formats";
                    RunPageLink = "Appraisal Code"=field(Code);
                }
            }
        }
    }
}

