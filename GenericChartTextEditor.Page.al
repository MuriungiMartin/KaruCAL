#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9185 "Generic Chart Text Editor"
{
    Caption = 'Generic Chart Text Editor';
    PageType = List;
    ShowFilter = false;
    SourceTable = "Generic Chart Captions Buffer";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a code. This field is intended only for internal use.';
                    Visible = false;
                }
                field("Language Code";"Language Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the language of the measure caption that is shown next to the y-axis of the generic chart.';
                }
                field("Language Name";"Language Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the language of the measure caption that is shown next to the y-axis of the generic chart.';
                }
                field(Text;Caption)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the caption that is shown next to the y-axis to describe the selected measure.';
                }
            }
        }
    }

    actions
    {
    }


    procedure AssistEdit(var TempGenericChartCaptionsBuf: Record "Generic Chart Captions Buffer" temporary;CaptionCode: Code[10]): Text
    var
        Language: Record Language;
    begin
        Copy(TempGenericChartCaptionsBuf,true);
        SetRange(Code,CaptionCode);
        if Get(CaptionCode,Language.GetUserLanguage) then;
        CurrPage.RunModal;
        exit(GetCaption(CaptionCode,Language.GetUserLanguage))
    end;
}

