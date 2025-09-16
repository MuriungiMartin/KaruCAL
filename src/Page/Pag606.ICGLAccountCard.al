#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 606 "IC G/L Account Card"
{
    Caption = 'IC G/L Account Card';
    PageType = Card;
    SourceTable = "IC G/L Account";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                }
                field("Account Type";"Account Type")
                {
                    ApplicationArea = Basic;
                }
                field("Income/Balance";"Income/Balance")
                {
                    ApplicationArea = Basic;
                }
                field(Blocked;Blocked)
                {
                    ApplicationArea = Basic;
                }
                field("Map-to G/L Acc. No.";"Map-to G/L Acc. No.")
                {
                    ApplicationArea = Basic;
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
            group("IC A&ccount")
            {
                Caption = 'IC A&ccount';
                Image = Intercompany;
                action("&List")
                {
                    ApplicationArea = Basic;
                    Caption = '&List';
                    Image = OpportunitiesList;
                    RunObject = Page "IC G/L Account List";
                    ShortCutKey = 'Shift+Ctrl+L';
                }
            }
        }
    }
}

