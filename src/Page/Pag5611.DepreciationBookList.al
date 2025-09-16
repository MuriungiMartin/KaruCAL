#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5611 "Depreciation Book List"
{
    ApplicationArea = Basic;
    Caption = 'Depreciation Book List';
    CardPageID = "Depreciation Book Card";
    Editable = false;
    PageType = List;
    SourceTable = "Depreciation Book";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code";Code)
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies a code that identifies the depreciation book.';
                }
                field(Description;Description)
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the purpose of the depreciation book.';
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
            group("&Depr. Book")
            {
                Caption = '&Depr. Book';
                Image = DepreciationsBooks;
                action("FA Posting Type Setup")
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'FA Posting Type Setup';
                    Image = Setup;
                    RunObject = Page "FA Posting Type Setup";
                    RunPageLink = "Depreciation Book Code"=field(Code);
                    ToolTip = 'Set up how to handle the write-down, appreciation, custom 1, and custom 2 posting types that you use when posting to fixed assets.';
                }
                action("FA &Journal Setup")
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'FA &Journal Setup';
                    Image = JournalSetup;
                    RunObject = Page "FA Journal Setup";
                    RunPageLink = "Depreciation Book Code"=field(Code);
                    ToolTip = 'Set up the FA general ledger journal, the FA journal, and the insurance journal templates and batches to use when duplicating depreciation entries and acquisition-cost entries and when calculating depreciation or indexing fixed assets.';
                }
            }
        }
    }
}

