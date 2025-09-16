#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 326 "Intrastat Jnl. Template List"
{
    Caption = 'Intrastat Jnl. Template List';
    Editable = false;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "Intrastat Jnl. Template";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the Intrastat journal template.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the Intrastat journal template.';
                }
                field("Page ID";"Page ID")
                {
                    ApplicationArea = Basic;
                    LookupPageID = Objects;
                    ToolTip = 'Specifies the number of the window (form) in which the program displays the Intrastat journal lines.';
                    Visible = false;
                }
                field("Checklist Report ID";"Checklist Report ID")
                {
                    ApplicationArea = Basic;
                    LookupPageID = Objects;
                    ToolTip = 'Specifies the checklist that can be printed if you click Actions, Print in the intrastate journal window and then select Checklist Report.';
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
    }
}

