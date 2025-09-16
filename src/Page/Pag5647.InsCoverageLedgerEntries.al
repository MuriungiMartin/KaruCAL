#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5647 "Ins. Coverage Ledger Entries"
{
    ApplicationArea = Basic;
    Caption = 'Ins. Coverage Ledger Entries';
    DataCaptionFields = "Insurance No.";
    Editable = false;
    PageType = List;
    SourceTable = "Ins. Coverage Ledger Entry";
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the entry''s posting date.';
                }
                field("Document Type";"Document Type")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the document type that the entry belongs to.';
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the document number on the entry.';
                }
                field("Insurance No.";"Insurance No.")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the number of the insurance policy the entry is linked to.';
                }
                field("FA No.";"FA No.")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the number of the fixed asset that the insurance entry is linked to.';
                }
                field("FA Description";"FA Description")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies a description of the fixed asset that the insurance entry is linked to.';
                    Visible = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies a description of the entry.';
                }
                field("Global Dimension 1 Code";"Global Dimension 1 Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the dimension value code the entry is linked to.';
                    Visible = false;
                }
                field("Global Dimension 2 Code";"Global Dimension 2 Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the dimension value code the entry is linked to.';
                    Visible = false;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the amount of the entry.';
                }
                field("Index Entry";"Index Entry")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies that this entry is an index entry.';
                    Visible = false;
                }
                field("Disposed FA";"Disposed FA")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies that the fixed asset linked to this entry has been disposed of.';
                }
                field("User ID";"User ID")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the ID of the user associated with the entry.';
                    Visible = false;
                }
                field("Source Code";"Source Code")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the source code linked to the entry.';
                    Visible = false;
                }
                field("Reason Code";"Reason Code")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the reason code on the entry.';
                    Visible = false;
                }
                field("Entry No.";"Entry No.")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the entry number the program has given the entry.';
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
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension=R;
                    ApplicationArea = Suite;
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
                ApplicationArea = FixedAssets;
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

