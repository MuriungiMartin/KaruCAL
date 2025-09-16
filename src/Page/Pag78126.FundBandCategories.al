#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 78126 "Fund Band Categories"
{
    ApplicationArea = Basic;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Funding Band Categories";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Band Code";"Band Code")
                {
                    ApplicationArea = Basic;
                }
                field("Band Description";"Band Description")
                {
                    ApplicationArea = Basic;
                }
                field("Scholarship Percentage";"Scholarship Percentage")
                {
                    ApplicationArea = Basic;
                }
                field("Loan Percentage";"Loan Percentage")
                {
                    ApplicationArea = Basic;
                }
                field("Household Percentage";"Household Percentage")
                {
                    ApplicationArea = Basic;
                }
                field("Academic Year";"Academic Year")
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

