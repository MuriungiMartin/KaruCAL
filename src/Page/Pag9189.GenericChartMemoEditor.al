#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9189 "Generic Chart Memo Editor"
{
    Caption = 'Generic Chart Memo Editor';
    PageType = List;
    ShowFilter = false;
    SourceTable = "Generic Chart Memo Buffer";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Languages)
            {
                Caption = 'Languages';
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a code. This field is intended only for internal use.';
                    Visible = false;
                }
                field("Language Code";"Language Code")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the language of the chart memo.';
                }
                field("Language Name";"Language Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the language name of the chart memo.';
                }
            }
            group(Memo)
            {
                Caption = 'Memo';
                field(MemoText;MemoText)
                {
                    ApplicationArea = Basic,Suite;
                    ColumnSpan = 2;
                    MultiLine = true;
                    ShowCaption = false;
                    ToolTip = 'Specifies the text of the chart memo.';

                    trigger OnValidate()
                    begin
                        SetMemoText(MemoText)
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
        MemoText := GetMemoText
    end;

    var
        MemoText: Text;


    procedure AssistEdit(var TempGenericChartMemoBuf: Record "Generic Chart Memo Buffer" temporary;MemoCode: Code[10]): Text
    var
        Language: Record Language;
    begin
        Copy(TempGenericChartMemoBuf,true);
        SetRange(Code,MemoCode);
        if Get(MemoCode,Language.GetUserLanguage) then;
        CurrPage.RunModal;
        exit(GetMemo(MemoCode,Language.GetUserLanguage))
    end;
}

