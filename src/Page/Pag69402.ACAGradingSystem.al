#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69402 "ACA-Grading System"
{
    DeleteAllowed = true;
    Editable = true;
    PageType = List;
    SourceTable = UnknownTable61599;
    SourceTableView = sorting(Grade)
                      order(ascending);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Grade;Grade)
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field("Lower Limit";"Lower Limit")
                {
                    ApplicationArea = Basic;
                }
                field("Upper Limit";"Upper Limit")
                {
                    ApplicationArea = Basic;
                }
                field("Graduation Lower Limit";"Graduation Lower Limit")
                {
                    ApplicationArea = Basic;
                }
                field("Graduation Upper Limit";"Graduation Upper Limit")
                {
                    ApplicationArea = Basic;
                }
                field("Up to";"Up to")
                {
                    ApplicationArea = Basic;
                }
                field(Range;Range)
                {
                    ApplicationArea = Basic;
                }
                field(Failed;Failed)
                {
                    ApplicationArea = Basic;
                }
                field(Remarks;Remarks)
                {
                    ApplicationArea = Basic;
                }
                field("Results Exists Status";"Results Exists Status")
                {
                    ApplicationArea = Basic;
                }
                field("Consolidated Prefix";"Consolidated Prefix")
                {
                    ApplicationArea = Basic;
                }
                field("Hide in Summary";"Hide in Summary")
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

