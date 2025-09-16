#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69008 "HRM-Appraisal Evaluation Line"
{
    PageType = List;
    SourceTable = UnknownTable61235;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Evaluation Code";"Evaluation Code")
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
                field("Evaluation Description";"Evaluation Description")
                {
                    ApplicationArea = Basic;
                }
                field(Score;Score)
                {
                    ApplicationArea = Basic;
                }
                field(Comments;Comments)
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

