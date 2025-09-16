#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1111 "Cost Center Card"
{
    Caption = 'Cost Center Card';
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "Cost Center";

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
                field("Cost Subtype";"Cost Subtype")
                {
                    ApplicationArea = Basic;
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
                field("Responsible Person";"Responsible Person")
                {
                    ApplicationArea = Basic;
                }
                field("Balance at Date";"Balance at Date")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field("Balance to Allocate";"Balance to Allocate")
                {
                    ApplicationArea = Basic;
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
            group("&Cost Center")
            {
                Caption = '&Cost Center';
                Image = CostCenter;
                action("E&ntries")
                {
                    ApplicationArea = Basic;
                    Caption = 'E&ntries';
                    Image = Entries;
                    RunObject = Page "Cost Entries";
                    RunPageLink = "Cost Center Code"=field(Code);
                    RunPageView = sorting("Cost Center Code","Cost Type No.",Allocated,"Posting Date");
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
                          CostType.SetFilter("Cost Center Filter",Code)
                        else
                          CostType.SetFilter("Cost Center Filter",Totaling);

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

