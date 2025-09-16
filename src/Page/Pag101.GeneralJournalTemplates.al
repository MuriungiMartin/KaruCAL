#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 101 "General Journal Templates"
{
    ApplicationArea = Basic;
    Caption = 'General Journal Templates';
    PageType = List;
    SourceTable = "Gen. Journal Template";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Name;Name)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the name of the journal template you are creating.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a brief description of the journal template you are creating.';
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the journal type. The type determines what the window will look like.';
                }
                field(Recurring;Recurring)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies whether the journal template will be a recurring journal.';
                }
                field("Bal. Account Type";"Bal. Account Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the code for the balancing account type that should be used in this general journal template.';
                }
                field("Bal. Account No.";"Bal. Account No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number of the balancing account that should be used in this general journal template.';
                }
                field("No. Series";"No. Series")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the code for the number series that will be used to assign document numbers to journal lines in this general journal template.';
                }
                field("Posting No. Series";"Posting No. Series")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the code for the number series that will be used to assign document numbers to ledger entries that are posted from journals using this template.';
                }
                field("Source Code";"Source Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the code linked to the journal template.';
                }
                field("Reason Code";"Reason Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a reason code that will be inserted on the journal lines.';
                }
                field("Force Doc. Balance";"Force Doc. Balance")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies whether transactions that are posted in the general journal must balance by document number and document type, in addition to balancing by date.';
                }
                field("Copy VAT Setup to Jnl. Lines";"Copy VAT Setup to Jnl. Lines")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies whether the program to calculate tax for accounts and balancing accounts on the journal line of the selected journal template.';

                    trigger OnValidate()
                    begin
                        if "Copy VAT Setup to Jnl. Lines" <> xRec."Copy VAT Setup to Jnl. Lines" then
                          if not Confirm(Text001,true,FieldCaption("Copy VAT Setup to Jnl. Lines")) then
                            Error(Text002);
                    end;
                }
                field("Allow VAT Difference";"Allow VAT Difference")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies whether to allow the manual adjustment of tax amounts in journals.';

                    trigger OnValidate()
                    begin
                        if "Allow VAT Difference" <> xRec."Allow VAT Difference" then
                          if not Confirm(Text001,true,FieldCaption("Allow VAT Difference")) then
                            Error(Text002);
                    end;
                }
                field("Page ID";"Page ID")
                {
                    ApplicationArea = Basic;
                    LookupPageID = Objects;
                    ToolTip = 'Specifies the window number used by the program for this journal template.';
                    Visible = false;
                }
                field("Page Caption";"Page Caption")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    ToolTip = 'Specifies the name of the journal template''s window.';
                    Visible = false;
                }
                field("Test Report ID";"Test Report ID")
                {
                    ApplicationArea = Basic;
                    LookupPageID = Objects;
                    ToolTip = 'Specifies the test report that is printed when you click Test Report.';
                    Visible = false;
                }
                field("Test Report Caption";"Test Report Caption")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    ToolTip = 'Specifies the name of the test report that is printed when you print a journal under this journal template.';
                    Visible = false;
                }
                field("Posting Report ID";"Posting Report ID")
                {
                    ApplicationArea = Basic;
                    LookupPageID = Objects;
                    ToolTip = 'Specifies the posting report that is printed when you choose Post and Print.';
                    Visible = false;
                }
                field("Posting Report Caption";"Posting Report Caption")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    ToolTip = 'Specifies the name of the report that is printed when you print the journal.';
                    Visible = false;
                }
                field("Force Posting Report";"Force Posting Report")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether a report is printed automatically when you post.';
                    Visible = false;
                }
                field("Cust. Receipt Report ID";"Cust. Receipt Report ID")
                {
                    ApplicationArea = Basic;
                    LookupPageID = Objects;
                    ToolTip = 'Specifies how to print customer receipts when you post.';
                    Visible = false;
                }
                field("Cust. Receipt Report Caption";"Cust. Receipt Report Caption")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    ToolTip = 'Specifies how to print customer receipts when you post.';
                    Visible = false;
                }
                field("Vendor Receipt Report ID";"Vendor Receipt Report ID")
                {
                    ApplicationArea = Basic;
                    LookupPageID = Objects;
                    ToolTip = 'Specifies how to print customer receipts when you post.';
                    Visible = false;
                }
                field("Vendor Receipt Report Caption";"Vendor Receipt Report Caption")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    ToolTip = 'Specifies how to print vendor receipts when you post.';
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
                    ApplicationArea = Basic,Suite;
                    Caption = 'Batches';
                    Image = Description;
                    RunObject = Page "General Journal Batches";
                    RunPageLink = "Journal Template Name"=field(Name);
                    ToolTip = 'Set up multiple general journals for a specific template. You can use batches when you need multiple journals of a certain type.';
                }
            }
        }
    }

    var
        Text001: label 'Do you want to update the %1 field on all general journal batches?';
        Text002: label 'Canceled.';
}

