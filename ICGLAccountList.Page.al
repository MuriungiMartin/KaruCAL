#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 607 "IC G/L Account List"
{
    Caption = 'IC G/L Account List';
    Editable = false;
    PageType = List;
    SourceTable = "IC G/L Account";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                IndentationColumn = NameIndent;
                IndentationControls = Name;
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    Style = Strong;
                    StyleExpr = Emphasize;
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                    Style = Strong;
                    StyleExpr = Emphasize;
                }
                field("Income/Balance";"Income/Balance")
                {
                    ApplicationArea = Basic;
                }
                field("Account Type";"Account Type")
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
                action("&Card")
                {
                    ApplicationArea = Basic;
                    Caption = '&Card';
                    Image = EditLines;
                    RunObject = Page "IC G/L Account Card";
                    RunPageLink = "No."=field("No.");
                    ShortCutKey = 'Shift+F7';
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        NameIndent := 0;
        FormatLine;
    end;

    trigger OnInit()
    begin
        CurrPage.LookupMode := true;
    end;

    var
        [InDataSet]
        Emphasize: Boolean;
        [InDataSet]
        NameIndent: Integer;

    local procedure FormatLine()
    begin
        NameIndent := Indentation;
        Emphasize := "Account Type" <> "account type"::Posting;
    end;
}

