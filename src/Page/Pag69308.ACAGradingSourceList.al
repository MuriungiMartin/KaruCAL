#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69308 "ACA-Grading Source List"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = UnknownTable66659;

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
                field("Exam Catregory";"Exam Catregory")
                {
                    ApplicationArea = Basic;
                }
                field("Total Score";"Total Score")
                {
                    ApplicationArea = Basic;
                }
                field(Grade;Grade)
                {
                    ApplicationArea = Basic;
                }
                field(Pass;Pass)
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
            }
        }
    }

    actions
    {
    }
}

