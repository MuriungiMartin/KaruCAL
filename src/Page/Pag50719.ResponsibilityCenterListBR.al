#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50719 "Responsibility Center List BR"
{
    Caption = 'Responsibility Center List';
    Editable = true;
    PageType = Card;
    SourceTable = UnknownTable60213;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Resp. Ctr.")
            {
                Caption = '&Resp. Ctr.';
                action(Card)
                {
                    ApplicationArea = Basic;
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page "Core Value";
                    RunPageLink = Code=field(Code);
                    ShortCutKey = 'Shift+F7';
                }
                group(Dimensions)
                {
                    Caption = 'Dimensions';
                    action("Dimensions-Single")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Dimensions-Single';
                        RunObject = Page "Default Dimensions";
                        RunPageLink = "Table ID"=const(5714),
                                      "No."=field(Code);
                        ShortCutKey = 'Shift+Ctrl+D';
                    }
                    action("Dimensions-&Multiple")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Dimensions-&Multiple';

                        trigger OnAction()
                        var
                            RespCenter: Record "Responsibility Center";
                            DefaultDimMultiple: Page "Default Dimensions-Multiple";
                        begin
                            CurrPage.SetSelectionFilter(RespCenter);
                            DefaultDimMultiple.SetMultiRespCenter(RespCenter);
                            DefaultDimMultiple.RunModal;
                        end;
                    }
                }
            }
        }
    }
}

