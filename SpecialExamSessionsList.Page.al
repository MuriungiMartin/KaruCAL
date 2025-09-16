#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 78000 "Special Exam Sessions List"
{
    ApplicationArea = Basic;
    PageType = List;
    SourceTable = UnknownTable69220;
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Academic Year";"Academic Year")
                {
                    ApplicationArea = Basic;
                }
                field(Semester;Semester)
                {
                    ApplicationArea = Basic;
                }
                field("Exam Session";"Exam Session")
                {
                    ApplicationArea = Basic;
                }
                field(Category;Category)
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Special/Supp Units")
            {
                ApplicationArea = Basic;
                Caption = 'Special/Supp Units';
                Image = DocumentEdit;
                Promoted = true;
                PromotedIsBig = true;
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Category:=Category::"Special Exams";
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Category:=Category::"Special Exams";
    end;
}

