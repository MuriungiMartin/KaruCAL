#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68735 "HRM-Job Shortlist Qualif."
{
    PageType = List;
    SourceTable = UnknownTable61211;

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                field("ShortList Type";"ShortList Type")
                {
                    ApplicationArea = Basic;
                }
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field("Achievable Values";"Achievable Values")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Weight;Weight)
                {
                    ApplicationArea = Basic;
                }
                field("Minimum Score";"Minimum Score")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }
}

