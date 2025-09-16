#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 293 "Req. Worksheet Templates"
{
    ApplicationArea = Basic;
    Caption = 'Req. Worksheet Templates';
    PageType = List;
    SourceTable = "Req. Wksh. Template";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the requisition worksheet template you are creating.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the requisition worksheet template you are creating.';
                }
                field(Recurring;Recurring)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether the requisition worksheet template will be a recurring requisition worksheet.';
                }
                field("Page ID";"Page ID")
                {
                    ApplicationArea = Basic;
                    LookupPageID = Objects;
                    ToolTip = 'Specifies the window number the requisition worksheet template appears in.';
                    Visible = false;
                }
                field("Page Caption";"Page Caption")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    ToolTip = 'Specifies the requisition worksheet''s window name.';
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Te&mplate")
            {
                Caption = 'Te&mplate';
                Image = Template;
                action("Requisition Worksheet Names")
                {
                    ApplicationArea = Basic;
                    Caption = 'Requisition Worksheet Names';
                    Image = Description;
                    RunObject = Page "Req. Wksh. Names";
                    RunPageLink = "Worksheet Template Name"=field(Name);
                }
            }
        }
    }
}

