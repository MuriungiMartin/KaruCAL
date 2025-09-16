#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7353 "Whse. Worksheet Templates"
{
    ApplicationArea = Basic;
    Caption = 'Whse. Worksheet Templates';
    PageType = List;
    SourceTable = "Whse. Worksheet Template";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name you enter for the warehouse worksheet template you are creating.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the description of the warehouse worksheet template you are creating.';
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies information about the activity you can plan in the warehouse worksheets that will be defined by this template.';
                }
                field("Page ID";"Page ID")
                {
                    ApplicationArea = Basic;
                    LookupPageID = Objects;
                    ToolTip = 'Specifies the window number used by the program for the warehouse worksheet.';
                }
                field("Page Caption";"Page Caption")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    ToolTip = 'Specifies the name of the page with the Page ID entered on the line.';
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
                action(Names)
                {
                    ApplicationArea = Basic;
                    Caption = 'Names';
                    Image = Description;
                    RunObject = Page "Whse. Worksheet Names";
                    RunPageLink = "Worksheet Template Name"=field(Name);
                }
            }
        }
    }
}

