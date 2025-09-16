#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 77736 "Table filters"
{
    PageType = List;
    SourceTable = "Table Filter";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Table Number";"Table Number")
                {
                    ApplicationArea = Basic;
                }
                field("Line No.";"Line No.")
                {
                    ApplicationArea = Basic;
                }
                field("Table Name";"Table Name")
                {
                    ApplicationArea = Basic;
                }
                field("Field Number";"Field Number")
                {
                    ApplicationArea = Basic;
                }
                field("Field Name";"Field Name")
                {
                    ApplicationArea = Basic;
                }
                field("Field Caption";"Field Caption")
                {
                    ApplicationArea = Basic;
                }
                field("Field Filter";"Field Filter")
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

