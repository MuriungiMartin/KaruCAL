#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 275 "Job Journal Template List"
{
    Caption = 'Job Journal Template List';
    Editable = false;
    PageType = List;
    SourceTable = "Job Journal Template";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Name;Name)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the name of this journal template. You can enter a maximum of 10 characters, both numbers and letters.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies a description of the job journal template for easy identification.';
                }
                field("Test Report ID";"Test Report ID")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the test report that is printed when you create a Test Report.';
                    Visible = false;
                }
                field("Page ID";"Page ID")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the number of the page that the program displays when you select this journal.';
                    Visible = false;
                }
                field("Posting Report ID";"Posting Report ID")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the posting report you want to be associated with this journal. To see the available IDs, choose the field.';
                    Visible = false;
                }
                field("Force Posting Report";"Force Posting Report")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies whether the program automatically prints a posting report, each time entries in this journal are posted.';
                    Visible = false;
                }
                field("Source Code";"Source Code")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the source code linked to the job journal template.';
                    Visible = false;
                }
                field("Reason Code";"Reason Code")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies a reason code that will be inserted on the job journal lines. The program will automatically insert the reason codes on ledger entries.';
                    Visible = false;
                }
                field("Test Report Caption";"Test Report Caption")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the name of the test report that you selected in the Test Report ID field.';
                    Visible = false;
                }
                field("Page Caption";"Page Caption")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the name of the window that you selected in the Page ID field.';
                    Visible = false;
                }
                field("Posting Report Caption";"Posting Report Caption")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the name of the posting report that is printed when you print the job journal.';
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

