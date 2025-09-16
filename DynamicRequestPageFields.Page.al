#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1536 "Dynamic Request Page Fields"
{
    ApplicationArea = Basic;
    Caption = 'Dynamic Request Page Fields';
    PageType = List;
    SourceTable = "Dynamic Request Page Field";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Table ID";"Table ID")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the ID of the table for the field that the workflow event condition applies to.';
                }
                field("Table Name";"Table Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the table for the field that the workflow event condition applies to.';
                    Visible = false;
                }
                field("Table Caption";"Table Caption")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the caption of the table for the field that the workflow event condition applies to.';
                }
                field("Field ID";"Field ID")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the ID of the field that the workflow event condition applies to.';
                }
                field("Field Name";"Field Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the field that the workflow event condition applies to.';
                    Visible = false;
                }
                field("Field Caption";"Field Caption")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the caption of the field that the workflow event condition applies to.';
                }
            }
        }
    }

    actions
    {
    }
}

