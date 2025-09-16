#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5653 "Insurance Jnl. Template List"
{
    Caption = 'Insurance Jnl. Template List';
    Editable = false;
    PageType = List;
    SourceTable = "Insurance Journal Template";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Name;Name)
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the name of the journal template you are creating.';
                }
                field(Description;Description)
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the journal template that you are creating.';
                }
                field("Test Report ID";"Test Report ID")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the report that will be printed if you choose to print a test report from a journal batch.';
                    Visible = false;
                }
                field("Page ID";"Page ID")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the ID of the window used by the program for batches under this journal template.';
                    Visible = false;
                }
                field("Posting Report ID";"Posting Report ID")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the posting report that is printed when you click Post and Print from a journal batch.';
                    Visible = false;
                }
                field("Force Posting Report";"Force Posting Report")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies whether a report is printed automatically when you post.';
                    Visible = false;
                }
                field("Source Code";"Source Code")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the source code linked to the journal template.';
                    Visible = false;
                }
                field("Reason Code";"Reason Code")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies which reason code is linked to the journal template.';
                    Visible = false;
                }
                field("Test Report Caption";"Test Report Caption")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the name of the report specified in the Test Report ID field.';
                    Visible = false;
                }
                field("Page Caption";"Page Caption")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the name of the window specified in the Page ID field.';
                    Visible = false;
                }
                field("Posting Report Caption";"Posting Report Caption")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the name of the report specified in the Posting Report ID field.';
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

