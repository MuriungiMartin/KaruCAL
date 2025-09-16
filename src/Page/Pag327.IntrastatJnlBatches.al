#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 327 "Intrastat Jnl. Batches"
{
    Caption = 'Intrastat Jnl. Batches';
    DataCaptionExpression = DataCaption;
    PageType = List;
    SourceTable = "Intrastat Jnl. Batch";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the Intrastat journal.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies some information about the Intrastat journal.';
                }
                field("Statistics Period";"Statistics Period")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the statistics period the report will cover.';
                }
                field("Currency Identifier";"Currency Identifier")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a code that identifies the currency of the Intrastat report.';
                }
                field("Amounts in Add. Currency";"Amounts in Add. Currency")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that you use an additional reporting currency in the general ledger and that you want to report Intrastat in this currency.';
                    Visible = false;
                }
                field(Reported;Reported)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether the entry has already been reported to the tax authorities.';
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
        area(processing)
        {
            action(EditJournal)
            {
                ApplicationArea = Basic;
                Caption = 'Edit Journal';
                Image = OpenJournal;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ShortCutKey = 'Return';

                trigger OnAction()
                begin
                    IntraJnlManagement.TemplateSelectionFromBatch(Rec);
                end;
            }
        }
    }

    trigger OnInit()
    begin
        SetRange("Journal Template Name");
    end;

    trigger OnOpenPage()
    begin
        IntraJnlManagement.OpenJnlBatch(Rec);
    end;

    var
        IntraJnlManagement: Codeunit IntraJnlManagement;

    local procedure DataCaption(): Text[250]
    var
        IntraJnlTemplate: Record "Intrastat Jnl. Template";
    begin
        if not CurrPage.LookupMode then
          if (GetFilter("Journal Template Name") <> '') and (GetFilter("Journal Template Name") <> '''''') then
            if GetRangeMin("Journal Template Name") = GetRangemax("Journal Template Name") then
              if IntraJnlTemplate.Get(GetRangeMin("Journal Template Name")) then
                exit(IntraJnlTemplate.Name + ' ' + IntraJnlTemplate.Description);
    end;
}

