#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1822 "Setup and Help Resource Visual"
{
    ApplicationArea = Basic;
    Caption = 'Setup and Help Resources';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Details';
    SourceTable = "Assisted Setup";
    SourceTableView = sorting(Order,Visible)
                      where(Visible=const(true));
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Item Type";"Item Type")
                {
                    ApplicationArea = Basic,Suite;
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic,Suite;

                    trigger OnDrillDown()
                    begin
                        Navigate;
                    end;
                }
                field(Icon;Icon)
                {
                    ApplicationArea = Basic,Suite;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Manage)
            {
                Caption = 'Manage';
                action(View)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'View';
                    Image = View;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunPageMode = View;
                    ShortCutKey = 'Return';
                    ToolTip = 'View extension details.';

                    trigger OnAction()
                    begin
                        Navigate;
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        SetRange(Parent,0);
    end;
}

