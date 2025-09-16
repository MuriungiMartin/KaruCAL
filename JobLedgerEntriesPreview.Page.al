#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 93 "Job Ledger Entries Preview"
{
    Caption = 'Job Ledger Entries Preview';
    DataCaptionFields = "Job No.";
    Editable = false;
    PageType = List;
    SourceTable = "Job Ledger Entry";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Jobs;
                    Editable = false;
                    ToolTip = 'Specifies the posting date for the entry.';
                }
                field("Entry Type";"Entry Type")
                {
                    ApplicationArea = Jobs;
                    Editable = false;
                    ToolTip = 'Specifies the type of the entry. There are two types of entries:';
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Jobs;
                    Editable = false;
                    ToolTip = 'Specifies the document number on the job ledger entry.';
                }
                field("Job No.";"Job No.")
                {
                    ApplicationArea = Jobs;
                    Editable = false;
                    ToolTip = 'Specifies the number of the job associated with the ledger entry.';
                }
                field("Job Task No.";"Job Task No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the number of the job task associated with the ledger entry.';
                }
                field(Type;Type)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the type of account to which the job ledger entry is posted.';
                }
                field("No.";"No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the number of the account to which the resource, item or general ledger account is posted, depending on your selection in the Type field.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Jobs;
                    Editable = false;
                    ToolTip = 'Specifies the description of the job ledger entry.';
                }
                field("Gen. Bus. Posting Group";"Gen. Bus. Posting Group")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the general business posting group that applies to the entry.';
                    Visible = false;
                }
                field("Gen. Prod. Posting Group";"Gen. Prod. Posting Group")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the general product posting group that applies to the entry.';
                    Visible = false;
                }
                field("Job Posting Group";"Job Posting Group")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the code for the Job posting group that was used when the entry was posted.';
                    Visible = false;
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the item variant code, which is copied to the job ledger entry from a job journal line, a sales line, or a purchase line.';
                    Visible = false;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the relevant location code if an item is posted.';
                    Visible = true;
                }
                field("Work Type Code";"Work Type Code")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies which work type the resource applies to. Prices are updated based on this entry.';
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the code for the unit of measure used for the resource or item posted in the this entry.';
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the quantity that was posted on the entry.';
                }
                field("Direct Unit Cost (LCY)";"Direct Unit Cost (LCY)")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the direct unit cost (in local currency) of the posted entry.';
                    Visible = false;
                }
                field("Unit Cost";"Unit Cost")
                {
                    ApplicationArea = Jobs;
                    Editable = false;
                    ToolTip = 'Specifies the unit cost for the posted entry. The amount is in the currency specified for the job.';
                }
                field("Unit Cost (LCY)";"Unit Cost (LCY)")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the unit cost of the posted entry in local currency. If you update the job ledger costs for item ledger cost adjustments, this field will be adjusted to include the item cost adjustments.';
                }
                field("Total Cost";"Total Cost")
                {
                    ApplicationArea = Jobs;
                    Editable = false;
                    ToolTip = 'Specifies the total cost for the posted entry, in the currency specified for the job.';
                }
                field("Total Cost (LCY)";"Total Cost (LCY)")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the total cost of the posted entry in local currency. If you update the job ledger costs for item ledger cost adjustments, this field will be adjusted to include the item cost adjustments.';
                }
                field("Unit Price";"Unit Price")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the unit price for the posted entry, in the currency specified for the job.';
                }
                field("Unit Price (LCY)";"Unit Price (LCY)")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the unit price (in local currency) of the posted entry.';
                    Visible = false;
                }
                field("Line Amount";"Line Amount")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the net amount (before subtracting the invoice discount amount) that must be paid for the items on the line.';
                }
                field("Line Discount Amount";"Line Discount Amount")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the line discount amount for the posted entry, in the currency specified for the job.';
                }
                field("Line Discount %";"Line Discount %")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the line discount percent of the posted entry.';
                }
                field("Total Price";"Total Price")
                {
                    ApplicationArea = Jobs;
                    Editable = false;
                    ToolTip = 'Specifies the total price for the posted entry, in the currency specified for the job.';
                    Visible = false;
                }
                field("Total Price (LCY)";"Total Price (LCY)")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the total price (in local currency) of the posted entry.';
                    Visible = false;
                }
                field("Line Amount (LCY)";"Line Amount (LCY)")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the net amount in ($) (before subtracting the invoice discount amount) that must be paid for the items on the line.';
                    Visible = false;
                }
                field("Amt. to Post to G/L";"Amt. to Post to G/L")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'This field is used internally.';
                    Visible = false;
                }
                field("Amt. Posted to G/L";"Amt. Posted to G/L")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'This field is used internally.';
                    Visible = false;
                }
                field("Original Unit Cost";"Original Unit Cost")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the unit cost for the posted entry at the time of posting, in the currency specified for the job. No item cost adjustments are included.';
                    Visible = false;
                }
                field("Original Unit Cost (LCY)";"Original Unit Cost (LCY)")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the unit cost of the posted entry in local currency at the time the entry was posted. It does not include any item cost adjustments.';
                    Visible = false;
                }
                field("Original Total Cost";"Original Total Cost")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the total cost for the posted entry at the time of posting, in the currency specified for the job. No item cost adjustments are included.';
                    Visible = false;
                }
                field("Original Total Cost (LCY)";"Original Total Cost (LCY)")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the total cost of the posted entry in local currency at the time the entry was posted. It does not include any item cost adjustments.';
                    Visible = false;
                }
                field("Original Total Cost (ACY)";"Original Total Cost (ACY)")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the total cost of the posted entry in the additional reporting currency at the time of posting. No item cost adjustments are included.';
                    Visible = false;
                }
                field("User ID";"User ID")
                {
                    ApplicationArea = Jobs;
                    Editable = false;
                    ToolTip = 'Specifies the ID of the user who posted the entry.';
                    Visible = false;
                }
                field("Source Code";"Source Code")
                {
                    ApplicationArea = Jobs;
                    Editable = false;
                    ToolTip = 'Specifies the source of the entry. If the entry was posted from a journal line, the code is copied from the Source Code field on the journal line.';
                    Visible = false;
                }
                field("Reason Code";"Reason Code")
                {
                    ApplicationArea = Jobs;
                    Editable = false;
                    ToolTip = 'Specifies the reason code on the entry.';
                    Visible = false;
                }
                field("Serial No.";"Serial No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the serial number if the job ledger entry Specifies an item usage that was posted with serial number tracking.';
                    Visible = false;
                }
                field("Lot No.";"Lot No.")
                {
                    ApplicationArea = Jobs;
                    Editable = false;
                    ToolTip = 'Specifies the lot number if the job ledger entry Specifies an item usage that was posted with lot number tracking.';
                    Visible = false;
                }
                field("Ledger Entry Type";"Ledger Entry Type")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the entry type that the job ledger entry is linked to.';
                }
                field(Adjusted;Adjusted)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies whether a job ledger entry has been modified or adjusted. The value in this field is inserted by the Adjust Cost - Item Entries batch job. The Adjusted check box is selected if applicable.';
                }
                field("DateTime Adjusted";"DateTime Adjusted")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the time stamp of a job ledger entry adjustment or modification.';
                }
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
                        xRec.ShowDimensions;
                    end;
                }
                action("<Action28>")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Show Linked Job Planning Lines';
                    Image = JobLines;
                    ToolTip = 'View the planning lines that are associated with job journal entries that have been posted to the job ledger. This requires that the Apply Usage Link check box has been selected for the job, or is the default setting for all jobs in your organization.';

                    trigger OnAction()
                    var
                        JobUsageLink: Record "Job Usage Link";
                        JobPlanningLine: Record "Job Planning Line";
                    begin
                        JobUsageLink.SetRange("Entry No.","Entry No.");

                        if JobUsageLink.FindSet then
                          repeat
                            JobPlanningLine.Get(JobUsageLink."Job No.",JobUsageLink."Job Task No.",JobUsageLink."Line No.");
                            JobPlanningLine.Mark := true;
                          until JobUsageLink.Next = 0;

                        JobPlanningLine.MarkedOnly(true);
                        Page.Run(Page::"Job Planning Lines",JobPlanningLine);
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if ActiveField = 1 then;
        if ActiveField = 2 then;
        if ActiveField = 3 then;
        if ActiveField = 4 then;
    end;

    var
        ActiveField: Option " ",Cost,CostLCY,PriceLCY,Price;


    procedure SetActiveField(ActiveField2: Integer)
    begin
        ActiveField := ActiveField2;
    end;
}

