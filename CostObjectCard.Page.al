#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1112 "Cost Object Card"
{
    Caption = 'Cost Object Card';
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "Cost Object";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field("Line Type";"Line Type")
                {
                    ApplicationArea = Basic;
                }
                field(Totaling;Totaling)
                {
                    ApplicationArea = Basic;
                }
                field(Comment;Comment)
                {
                    ApplicationArea = Basic;
                }
                field("Net Change";"Net Change")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field("Sorting Order";"Sorting Order")
                {
                    ApplicationArea = Basic;
                }
                field("Blank Line";"Blank Line")
                {
                    ApplicationArea = Basic;
                }
                field("New Page";"New Page")
                {
                    ApplicationArea = Basic;
                }
                field(Blocked;Blocked)
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
            group("&Cost Object")
            {
                Caption = '&Cost Object';
                Image = Costs;
                action("E&ntries")
                {
                    ApplicationArea = Basic;
                    Caption = 'E&ntries';
                    Image = Entries;
                    RunObject = Page "Cost Entries";
                    RunPageLink = "Cost Object Code"=field(Code);
                    RunPageView = sorting("Cost Object Code","Cost Type No.",Allocated,"Posting Date");
                    ShortCutKey = 'Ctrl+F7';
                }
                separator(Action4)
                {
                }
                action("&Balance")
                {
                    ApplicationArea = Basic;
                    Caption = '&Balance';
                    Image = Balance;
                    ShortCutKey = 'F7';

                    trigger OnAction()
                    var
                        CostType: Record "Cost Type";
                    begin
                        if Totaling = '' then
                          CostType.SetFilter("Cost Object Filter",Code)
                        else
                          CostType.SetFilter("Cost Object Filter",Totaling);

                        Page.Run(Page::"Cost Type Balance",CostType);
                    end;
                }
            }
        }
        area(processing)
        {
            action("Dimension Values")
            {
                ApplicationArea = Basic;
                Caption = 'Dimension Values';
                Image = Dimensions;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Dimension Values";
            }
        }
    }
}

