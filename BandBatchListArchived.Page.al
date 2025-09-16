#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 78128 "Band Batch List Archived"
{
    CardPageID = "Fund Band Batch Card";
    DeleteAllowed = false;
    PageType = List;
    SourceTable = "Fund Band Batch";
    SourceTableView = where(Archived=const(true));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Editable = false;
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic;
                }
                field("Academic Year";"Academic Year")
                {
                    ApplicationArea = Basic;
                }
                field(Remarks;Remarks)
                {
                    ApplicationArea = Basic;
                }
                field("Student Count";"Student Count")
                {
                    ApplicationArea = Basic;
                }
                field("Created DateTime";"Created DateTime")
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

