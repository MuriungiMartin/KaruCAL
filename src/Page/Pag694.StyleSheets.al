#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 694 "Style Sheets"
{
    Caption = 'Style Sheets';
    DataCaptionExpression = STRSUBSTNO(text001,SendToProgramName,AllObjWithCaption."Object Caption");
    Editable = false;
    PageType = List;
    SourceTable = "Style Sheet";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Name;Name)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Name';
                    ToolTip = 'Specifies the name of the style sheet that you want to import to another program.';
                }
                field(Date;Date)
                {
                    ApplicationArea = Basic;
                    Caption = 'Date';
                    ToolTip = 'Specifies the date that a style sheet was added to the table.';
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

    var
        AllObjWithCaption: Record AllObjWithCaption;
        text001: label '%1 Style Sheets for %2';
        SendToProgramName: Text[250];


    procedure SetParams(NewObjectID: Integer;NewSendToProgramName: Text[250])
    begin
        if not AllObjWithCaption.Get(AllObjWithCaption."object type"::Page,NewObjectID) then
          AllObjWithCaption.Init;
        SendToProgramName := NewSendToProgramName;
    end;
}

