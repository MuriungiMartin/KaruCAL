#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68812 "HRM-Train Need Analysis List"
{
    CardPageID = "HRM-TNA Card";
    Editable = false;
    PageType = List;
    SourceTable = UnknownTable61242;

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
                    Style = StrongAccent;
                    StyleExpr = true;
                }
                field("Need Source";"Need Source")
                {
                    ApplicationArea = Basic;
                }
                field("Individual Course";"Individual Course")
                {
                    ApplicationArea = Basic;
                }
                field("Proposed End Date";"Proposed End Date")
                {
                    ApplicationArea = Basic;
                }
                field("Cost Of Training";"Cost Of Training")
                {
                    ApplicationArea = Basic;
                }
            }
        }
        area(factboxes)
        {
            part(Control1102755002;"HRM-Trainings Factbox")
            {
                SubPageLink = "Application No"=field(Code);
            }
        }
    }

    actions
    {
    }
}

