#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7369 "Bin Creation Wksh. Names"
{
    Caption = 'Bin Creation Wksh. Names';
    DataCaptionExpression = DataCaption;
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Bin Creation Wksh. Name";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a name for the worksheet.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description for the worksheet.';
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the location code for which the worksheet should be used.';
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

    local procedure DataCaption(): Text[250]
    var
        BinCreateWkshTmpl: Record "Bin Creation Wksh. Template";
    begin
        if not CurrPage.LookupMode then
          if GetFilter("Worksheet Template Name") <> '' then
            if GetRangeMin("Worksheet Template Name") = GetRangemax("Worksheet Template Name") then
              if BinCreateWkshTmpl.Get(GetRangeMin("Worksheet Template Name")) then
                exit(BinCreateWkshTmpl.Name + ' ' + BinCreateWkshTmpl.Description);
    end;
}

