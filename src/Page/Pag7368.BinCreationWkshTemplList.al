#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7368 "Bin Creation Wksh. Templ. List"
{
    Caption = 'Bin Creation Wksh. Templ. List';
    Editable = false;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "Bin Creation Wksh. Template";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the bin creation worksheet template you are creating.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the warehouse worksheet template you are creating.';
                }
                field("Page ID";"Page ID")
                {
                    ApplicationArea = Basic;
                    LookupPageID = Objects;
                    ToolTip = 'Specifies the number of the window used by the program for the warehouse worksheet.';
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
                action(Names)
                {
                    ApplicationArea = Basic;
                    Caption = 'Names';
                    Image = Description;
                    RunObject = Page "Bin Creation Wksh. Names";
                    RunPageLink = "Worksheet Template Name"=field(Name);
                }
            }
        }
    }
}

