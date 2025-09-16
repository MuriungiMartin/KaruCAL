#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 112 "Inventory Posting Groups"
{
    ApplicationArea = Basic;
    Caption = 'Inventory Posting Groups';
    PageType = List;
    SourceTable = "Inventory Posting Group";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies an inventory posting group code.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a description of the inventory posting group.';
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
        area(processing)
        {
            action("&Setup")
            {
                ApplicationArea = Basic,Suite;
                Caption = '&Setup';
                Image = Setup;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Inventory Posting Setup";
                RunPageLink = "Invt. Posting Group Code"=field(Code);
                ToolTip = 'Specify the locations for the inventory posting group that you can link to general ledger accounts. Posting groups create links between application areas and the General Ledger application area.';
            }
        }
    }


    procedure GetSelectionFilter(): Text
    var
        InvtPostingGr: Record "Inventory Posting Group";
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
    begin
        CurrPage.SetSelectionFilter(InvtPostingGr);
        exit(SelectionFilterManagement.GetSelectionFilterForInventoryPostingGroup(InvtPostingGr));
    end;
}

