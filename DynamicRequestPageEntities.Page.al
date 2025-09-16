#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1535 "Dynamic Request Page Entities"
{
    ApplicationArea = Basic;
    Caption = 'Dynamic Request Page Entities';
    PageType = List;
    SourceTable = "Dynamic Request Page Entity";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Name;Name)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the name of the workflow event condition.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the workflow event condition.';
                }
                field("Table ID";"Table ID")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the ID of the table that the workflow event condition applies to.';
                }
                field("Table Name";"Table Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the table that the workflow event condition applies to.';
                    Visible = false;
                }
                field("Table Caption";"Table Caption")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the caption of the table that the workflow event condition applies to.';
                }
                field("Related Table ID";"Related Table ID")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the ID of the table that the workflow event condition applies to.';
                }
                field("Related Table Name";"Related Table Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the related table that the workflow event condition applies to.';
                    Visible = false;
                }
                field("Related Table Caption";"Related Table Caption")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the caption of the related table that the workflow event condition applies to.';
                }
                field("Sequence No.";"Sequence No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the order of approvers when an approval workflow involves more than one approver.';
                }
            }
        }
    }

    actions
    {
    }
}

