#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 598 "XBRL Line Constants"
{
    AutoSplitKey = true;
    Caption = 'XBRL Line Constants';
    DataCaptionExpression = GetCaption;
    PageType = List;
    SourceTable = "XBRL Line Constant";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Starting Date";"Starting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date on which the constant amount on this line comes into effect. The constant amount on this line applies from this date until the date in the Starting Date field on the next line.';
                }
                field("Constant Amount";"Constant Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the amount that will be exported if the source type is Constant.';
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

    local procedure GetCaption(): Text[250]
    var
        XBRLLine: Record "XBRL Taxonomy Line";
    begin
        if not XBRLLine.Get("XBRL Taxonomy Name","XBRL Taxonomy Line No.") then
          exit('');

        Copyfilter("Label Language Filter",XBRLLine."Label Language Filter");
        XBRLLine.CalcFields(Label);
        if XBRLLine.Label = '' then
          XBRLLine.Label := XBRLLine.Name;
        exit(XBRLLine.Label);
    end;
}

