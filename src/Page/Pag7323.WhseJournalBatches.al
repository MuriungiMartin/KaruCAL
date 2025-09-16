#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7323 "Whse. Journal Batches"
{
    Caption = 'Whse. Journal Batches';
    DataCaptionExpression = DataCaption;
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Warehouse Journal Batch";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the warehouse journal batch.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the warehouse journal batch.';
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the location where the journal batch applies.';
                }
                field("Reason Code";"Reason Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the reason code of the warehouse journal batch.';
                }
                field("No. Series";"No. Series")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number series code used to assign document numbers to the journal lines in this journal batch.';
                }
                field("Registering No. Series";"Registering No. Series")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number series code used to assign document numbers to the warehouse entries that are registered from this journal batch.';
                }
                field("Assigned User ID";"Assigned User ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ID of the user who is responsible for the document.';
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
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        SetupNewBatch;
    end;

    local procedure DataCaption(): Text[250]
    var
        WhseJnlTemplate: Record "Warehouse Journal Template";
    begin
        if not CurrPage.LookupMode then
          if GetFilter("Journal Template Name") <> '' then
            if GetRangeMin("Journal Template Name") = GetRangemax("Journal Template Name") then
              if WhseJnlTemplate.Get(GetRangeMin("Journal Template Name")) then
                exit(WhseJnlTemplate.Name + ' ' + WhseJnlTemplate.Description);
    end;
}

