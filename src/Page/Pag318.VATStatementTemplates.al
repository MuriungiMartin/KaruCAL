#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 318 "VAT Statement Templates"
{
    ApplicationArea = Basic;
    Caption = 'VAT Statement Templates';
    PageType = List;
    SourceTable = "VAT Statement Template";
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
                    ToolTip = 'Specifies the name of the VAT statement template you are about to create.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the VAT statement template.';
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
                action("Statement Names")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Statement Names';
                    Image = List;
                    RunObject = Page "VAT Statement Names";
                    RunPageLink = "Statement Template Name"=field(Name);
                    ToolTip = 'View or edit special tables to manage the tasks necessary for settling Tax and reporting to the customs and tax authorities.';
                }
            }
        }
    }
}

