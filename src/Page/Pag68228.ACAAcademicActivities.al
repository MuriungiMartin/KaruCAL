#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68228 "ACA-Academic Activities"
{
    Caption = 'Activities';
    PageType = CardPart;
    SourceTable = "Finance Cue";

    layout
    {
        area(content)
        {
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        Reset;
        if not Get then begin
          Init;
          Insert;
        end;

        SetFilter("Due Date Filter",'<=%1',WorkDate);
        SetFilter("Overdue Date Filter",'<%1',WorkDate);
    end;
}

