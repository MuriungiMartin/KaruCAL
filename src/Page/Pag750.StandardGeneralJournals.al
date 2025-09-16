#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 750 "Standard General Journals"
{
    Caption = 'Standard General Journals';
    CardPageID = "Standard General Journal";
    DataCaptionFields = "Journal Template Name";
    PageType = List;
    RefreshOnActivate = true;
    SaveValues = true;
    SourceTable = "Standard General Journal";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code";Code)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies a code to identify the standard general journal that you are about to save.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies a text that indicates the purpose of the standard general journal.';
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
                action(ShowJournal)
                {
                    ApplicationArea = Suite;
                    Caption = '&Show Journal';
                    Image = Journal;
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'Open a journal based on the journal batch that you selected.';

                    trigger OnAction()
                    var
                        StdGenJnl: Record "Standard General Journal";
                    begin
                        StdGenJnl.SetRange("Journal Template Name","Journal Template Name");
                        StdGenJnl.SetRange(Code,Code);

                        Page.Run(Page::"Standard General Journal",StdGenJnl);
                    end;
                }
            }
        }
    }
}

