#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1009 "Job WIP G/L Entries"
{
    ApplicationArea = Basic;
    Caption = 'Job WIP G/L Entries';
    DataCaptionFields = "Job No.";
    Editable = false;
    PageType = List;
    SourceTable = "Job WIP G/L Entry";
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Reversed;Reversed)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies whether the entry has been reversed. If the check box is selected, the entry has been reversed from the G/L.';
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the posting date you entered in the Posting Date field, on the Options FastTab, in the Job Post WIP to G/L batch job.';
                }
                field("WIP Posting Date";"WIP Posting Date")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the posting date you entered in the Posting Date field, on the Options FastTab, in the Job Calculate WIP batch job.';
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the document number you entered in the Document No. field on the Options FastTab in the Job Post WIP to G/L batch job.';
                }
                field("Job No.";"Job No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the number of the job that this WIP general ledger entry is related to.';
                }
                field("Job Complete";"Job Complete")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies whether a job is complete. This check box is selected if the Job WIP G/L Entry was created for a Job with a Completed status.';
                }
                field("Job WIP Total Entry No.";"Job WIP Total Entry No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the entry number from the associated job WIP total.';
                }
                field("G/L Account No.";"G/L Account No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the general ledger account number to which the WIP, on this entry, is posted.';
                }
                field("G/L Bal. Account No.";"G/L Bal. Account No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the general ledger balancing account number that WIP on this entry was posted to.';
                }
                field("Reverse Date";"Reverse Date")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the reverse date. If the WIP on this entry is reversed, you can see the date of the reversal in the Reverse Date field.';
                }
                field("WIP Method Used";"WIP Method Used")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the WIP method that was specified for the job when you ran the Job Calculate WIP batch job.';
                }
                field("WIP Posting Method Used";"WIP Posting Method Used")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the WIP posting method used in the context of the general ledger. The information in this field comes from the setting you have specified on the job card.';
                }
                field(Type;Type)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the WIP type for this entry.';
                }
                field("WIP Entry Amount";"WIP Entry Amount")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the WIP amount that was posted in the general ledger for this entry.';
                }
                field("Job Posting Group";"Job Posting Group")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the posting group related to this entry.';
                }
                field("WIP Transaction No.";"WIP Transaction No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the transaction number assigned to all the entries involved in the same transaction.';
                }
                field(Reverse;Reverse)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies whether the entry has been part of a reverse transaction (correction) made by the reverse function.';
                }
                field("Global Dimension 1 Code";"Global Dimension 1 Code")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the dimension value code that the job G/L entry is linked to. You cannot change the code because the entry has been posted.';
                }
                field("Global Dimension 2 Code";"Global Dimension 2 Code")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the dimension value code that the job G/L entry is linked to. You cannot change the code because the entry has been posted.';
                }
                field("G/L Entry No.";"G/L Entry No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the G/L Entry No. to which this entry is linked.';
                }
                field("Entry No.";"Entry No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the number of the WIP general ledger entry.';
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
            group("Ent&ry")
            {
                Caption = 'Ent&ry';
                Image = Entry;
                action("<Action57>")
                {
                    ApplicationArea = Jobs;
                    Caption = 'WIP Totals';
                    Image = EntriesList;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Job WIP Totals";
                    RunPageLink = "Entry No."=field("Job WIP Total Entry No.");
                    ToolTip = 'View the job''s WIP totals.';
                }
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension=R;
                    ApplicationArea = Jobs;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edits dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                    trigger OnAction()
                    begin
                        ShowDimensions;
                    end;
                }
            }
        }
        area(processing)
        {
            action("&Navigate")
            {
                ApplicationArea = Jobs;
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Find all entries and documents that exist for the document number and posting date on the selected entry or document.';

                trigger OnAction()
                begin
                    Navigate.SetDoc("Posting Date","Document No.");
                    Navigate.Run;
                end;
            }
        }
    }

    var
        Navigate: Page Navigate;
}

