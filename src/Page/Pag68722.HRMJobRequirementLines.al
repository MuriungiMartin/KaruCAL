#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68722 "HRM-Job Requirement Lines"
{
    CardPageID = "HRM-Job Requirements";
    PageType = List;
    SourceTable = UnknownTable61195;

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                field("Qualification Category";"Qualification Category")
                {
                    ApplicationArea = Basic;
                }
                field("Qualification Type";"Qualification Type")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field("Qualification Code";"Qualification Code")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field("Qualification Description";"Qualification Description")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Importance = Promoted;
                }
                field("Grade Attained";"Grade Attained")
                {
                    ApplicationArea = Basic;
                }
                field("Desired Score";"Desired Score")
                {
                    ApplicationArea = Basic;
                }
                field(Priority;Priority)
                {
                    ApplicationArea = Basic;
                }
                field(Mandatory;Mandatory)
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

