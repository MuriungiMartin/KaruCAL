#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68313 "CAT-Left Over Dialog"
{
    PageType = Card;

    layout
    {
        area(content)
        {
            field("Menu Date";"Menu Date")
            {
                ApplicationArea = Basic;
                Caption = 'Menu Date';
            }
            label(Control1000000002)
            {
                ApplicationArea = Basic;
                CaptionClass = Text19053507;
                Style = Standard;
                StyleExpr = true;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Cancel)
            {
                ApplicationArea = Basic;
                Caption = 'Cancel';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                        CurrPage.Close;
                end;
            }
            action(Ok)
            {
                ApplicationArea = Basic;
                Caption = 'Ok';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                       DailyMenu.Reset;
                       DailyMenu.SetRange(DailyMenu."Menu Date","Menu Date");
                       if DailyMenu.Find('-') then
                       begin
                        repeat
                         if DailyMenu."Remaining Qty">0 then
                           begin
                             TodayMenu.SetRange(TodayMenu."Menu Date",Today);
                             if TodayMenu.Find('-') then
                             begin
                               repeat
                                 if TodayMenu.Menu=DailyMenu.Menu then
                                 begin
                                    TodayMenu."Remaining Qty":=TodayMenu."Remaining Qty" + DailyMenu."Remaining Qty";
                                    TodayMenu.Modify;
                                 end;
                               until TodayMenu.Next=0;
                              end;
                             if TodayMenu.Find('-') then
                             begin
                              repeat
                               TodayMenu.Reset;
                               TodayMenu.SetRange(TodayMenu.Menu,DailyMenu.Menu);
                               if TodayMenu.Find('-') then
                               begin
                               end
                               else begin
                                TodayMenu.Init;
                                TodayMenu.Menu:=DailyMenu.Menu;
                                TodayMenu."Menu Date":=Today;
                                TodayMenu.Description:=DailyMenu.Description;
                                TodayMenu.Units:=DailyMenu.Units;
                                TodayMenu."Menu Qty":=DailyMenu."Menu Qty";
                                TodayMenu."Prod Qty":=DailyMenu."Remaining Qty";
                                TodayMenu."Remaining Qty":=DailyMenu."Remaining Qty";
                                TodayMenu.Posted:=false;
                                TodayMenu.Init;
                              end;
                             until TodayMenu.Next=0;
                            end;
                          end;
                        until DailyMenu.Next=0;
                      end;
                      Message('Menu Updated Sussfully');
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
             "Menu Date":=Today;
              "Menu Date":="Menu Date"-1;
    end;

    var
        "Menu Date": Date;
        "Food Menu": Record UnknownRecord61167;
        DailyMenu: Record UnknownRecord61169;
        TodayMenu: Record UnknownRecord61169;
        Text19053507: label 'Enter The Left Over Date';
}

