#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 78061 "ACA-Results Workflow Codes"
{
    PageType = List;
    SourceTable = UnknownTable78061;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(WF_Code;WF_Code)
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field(Series;Series)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Approvers;Approvers)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Is Lecture Level";"Is Lecture Level")
                {
                    ApplicationArea = Basic;
                }
                field("Is Active";"Is Active")
                {
                    ApplicationArea = Basic;
                }
                field("Approval Category";"Approval Category")
                {
                    ApplicationArea = Basic;
                }
                field("Department Code";"Department Code")
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

