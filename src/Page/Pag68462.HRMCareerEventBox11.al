#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68462 "HRM-Career Event Box11"
{
    PageType = Card;

    layout
    {
        area(content)
        {
            label(MessageTextBox)
            {
                ApplicationArea = Basic;
                CaptionClass = FORMAT (MessageText);
                MultiLine = true;
            }
            label(Control1102755000)
            {
                ApplicationArea = Basic;
            }
            field(ReasonText;ReasonText)
            {
                ApplicationArea = Basic;
                Caption = 'Reason';
            }
        }
    }

    actions
    {
    }

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        if CloseAction = Action::No then
          NoOnPush;
        if CloseAction = Action::Yes then
            YesOnPush;
    end;

    var
        MessageText: Text[250];
        ResultEvent: Boolean;
        ReasonText: Text[100];
        CareerHistory: Record UnknownRecord61067;
        ResultReason: Text[100];


    procedure SetMessage(Message: Text[200])
    begin
                      MessageText:= StrSubstNo(Message);
    end;


    procedure ReturnResult() Result: Boolean
    begin
                      Result:= ResultEvent;
    end;


    procedure ReturnReason() ReturnReason: Text[100]
    begin
              ReturnReason := ReasonText;
    end;

    local procedure YesOnPush()
    begin
                      ResultEvent:= true;
    end;

    local procedure NoOnPush()
    begin
                      ResultEvent:= false;
    end;
}

