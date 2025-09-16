#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 753 "Standard Item Journals"
{
    Caption = 'Standard Item Journals';
    CardPageID = "Standard Item Journal";
    DataCaptionFields = "Journal Template Name";
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "Standard Item Journal";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code";Code)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the code of the record.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the record in the line of the journal.';
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
            group("&Standard")
            {
                Caption = '&Standard';
                Image = Journal;
                action("&Show Journal")
                {
                    ApplicationArea = Suite;
                    Caption = '&Show Journal';
                    Image = Journal;
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'Open a journal based on the journal batch that you selected.';

                    trigger OnAction()
                    var
                        StdItemJnl: Record "Standard Item Journal";
                    begin
                        StdItemJnl.SetRange("Journal Template Name","Journal Template Name");
                        StdItemJnl.SetRange(Code,Code);

                        Page.Run(Page::"Standard Item Journal",StdItemJnl);
                    end;
                }
            }
        }
    }
}

