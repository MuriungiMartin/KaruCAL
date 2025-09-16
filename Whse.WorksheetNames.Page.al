#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7344 "Whse. Worksheet Names"
{
    Caption = 'Whse. Worksheet Names';
    DataCaptionExpression = DataCaption;
    PageType = List;
    SourceTable = "Whse. Worksheet Name";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name you enter for the worksheet.';
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the location code of the warehouse the worksheet should be used for.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the description for the worksheet.';
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
        SetupNewName;
    end;

    local procedure DataCaption(): Text[250]
    var
        WhseWkshTemplate: Record "Whse. Worksheet Template";
    begin
        if not CurrPage.LookupMode then
          if GetFilter("Worksheet Template Name") <> '' then
            if GetRangeMin("Worksheet Template Name") = GetRangemax("Worksheet Template Name") then
              if WhseWkshTemplate.Get(GetRangeMin("Worksheet Template Name")) then
                exit(WhseWkshTemplate.Name + ' ' + WhseWkshTemplate.Description);
    end;
}

