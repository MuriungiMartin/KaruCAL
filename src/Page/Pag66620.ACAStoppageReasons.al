#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 66620 "ACA-Stoppage Reasons"
{
    PageType = List;
    SourceTable = UnknownTable66620;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Reason Code";"Reason Code")
                {
                    ApplicationArea = Basic;
                }
                field("Reason Description";"Reason Description")
                {
                    ApplicationArea = Basic;
                }
                field("Hide in Results";"Hide in Results")
                {
                    ApplicationArea = Basic;
                }
                field("Pick Alternate Rubric";"Pick Alternate Rubric")
                {
                    ApplicationArea = Basic;
                }
                field("Exclude Computation";"Exclude Computation")
                {
                    ApplicationArea = Basic;
                }
                field("Change Global";"Change Global")
                {
                    ApplicationArea = Basic;
                }
                field("Global Status";"Global Status")
                {
                    ApplicationArea = Basic;
                }
                field("Move to Reservour";"Move to Reservour")
                {
                    ApplicationArea = Basic;
                }
                field("Combine Discordant Semesters";"Combine Discordant Semesters")
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

