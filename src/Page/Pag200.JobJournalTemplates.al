#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 200 "Job Journal Templates"
{
    ApplicationArea = Basic;
    Caption = 'Job Journal Templates';
    PageType = List;
    SourceTable = "Job Journal Template";
    UsageCategory = Administration;

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
                field("No. Series";"No. Series")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the code for the number series that will be used to assign document numbers to journal lines in this job journal template. To see the number series that have been set up in the No. Series table, choose the field.';
                }
                field("Posting No. Series";"Posting No. Series")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the code for the number series that will be used to assign document numbers to ledger entries that are posted from journals using this template.';
                }
                field(Recurring;Recurring)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies whether the journal is to contain recurring entries. Leave the field blank if the journal should not contain recurring entries.';
                }
                field("Source Code";"Source Code")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the source code linked to the job journal template.';

                    trigger OnValidate()
                    begin
                        SourceCodeOnAfterValidate;
                    end;
                }
                field("Reason Code";"Reason Code")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies a reason code that will be inserted on the job journal lines. The program will automatically insert the reason codes on ledger entries.';
                }
                field("Page ID";"Page ID")
                {
                    ApplicationArea = Jobs;
                    LookupPageID = Objects;
                    ToolTip = 'Specifies the number of the page that the program displays when you select this journal.';
                    Visible = false;
                }
                field("Page Caption";"Page Caption")
                {
                    ApplicationArea = Jobs;
                    DrillDown = false;
                    ToolTip = 'Specifies the name of the window that you selected in the Page ID field.';
                    Visible = false;
                }
                field("Test Report ID";"Test Report ID")
                {
                    ApplicationArea = Jobs;
                    LookupPageID = Objects;
                    ToolTip = 'Specifies the test report that is printed when you create a Test Report.';
                    Visible = false;
                }
                field("Test Report Caption";"Test Report Caption")
                {
                    ApplicationArea = Jobs;
                    DrillDown = false;
                    ToolTip = 'Specifies the name of the test report that you selected in the Test Report ID field.';
                    Visible = false;
                }
                field("Posting Report ID";"Posting Report ID")
                {
                    ApplicationArea = Jobs;
                    LookupPageID = Objects;
                    ToolTip = 'Specifies the posting report you want to be associated with this journal. To see the available IDs, choose the field.';
                    Visible = false;
                }
                field("Posting Report Caption";"Posting Report Caption")
                {
                    ApplicationArea = Jobs;
                    DrillDown = false;
                    ToolTip = 'Specifies the name of the posting report that is printed when you print the job journal.';
                    Visible = false;
                }
                field("Force Posting Report";"Force Posting Report")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies whether the program automatically prints a posting report, each time entries in this journal are posted.';
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
                action(Batches)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Batches';
                    Image = Description;
                    RunObject = Page "Job Journal Batches";
                    RunPageLink = "Journal Template Name"=field(Name);
                    ToolTip = 'Set up multiple job journals for a specific template. You can use batches when you need multiple journals of a certain type.';
                }
            }
        }
    }

    local procedure SourceCodeOnAfterValidate()
    begin
        CurrPage.Update(false);
    end;
}

