#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 6508 "Lot No. Information List"
{
    Caption = 'Lot No. Information List';
    CardPageID = "Lot No. Information Card";
    Editable = false;
    PageType = List;
    SourceTable = "Lot No. Information";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies this number from the Tracking Specification table when a lot number information record is created.';
                    Visible = false;
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the content of this field from the Tracking Specification table when a lot no. information record is created.';
                    Visible = false;
                }
                field("Lot No.";"Lot No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies this number from the Tracking Specification table when a lot number information record is created.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    ToolTip = 'Specifies a description of the lot no. information record.';
                }
                field("Test Quality";"Test Quality")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quality of a given lot if you have inspected the items.';
                }
                field("Certificate Number";"Certificate Number")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number provided by the supplier to indicate that the batch or lot meets the specified requirements.';
                }
                field(Blocked;Blocked)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that a document or journal line carrying the specified lot number cannot be posted.';
                }
                field(Control16;Comment)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that a comment has been recorded for the lot number.';
                }
                field(Inventory;Inventory)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the inventory quantity of the specified lot number.';
                    Visible = false;
                }
                field("Expired Inventory";"Expired Inventory")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the inventory of the lot number with an expiration date before the posting date on the associated document.';
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
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Lot No.")
            {
                Caption = '&Lot No.';
                Image = Lot;
                action("Item &Tracking Entries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Item &Tracking Entries';
                    Image = ItemTrackingLedger;
                    ShortCutKey = 'Shift+Ctrl+I';

                    trigger OnAction()
                    var
                        ItemTrackingDocMgt: Codeunit "Item Tracking Doc. Management";
                    begin
                        ItemTrackingDocMgt.ShowItemTrackingForMasterData(0,'',"Item No.","Variant Code",'',"Lot No.",'');
                    end;
                }
                action(Comment)
                {
                    ApplicationArea = Basic;
                    Caption = 'Comment';
                    Image = ViewComments;
                    RunObject = Page "Item Tracking Comments";
                    RunPageLink = Type=const("Lot No."),
                                  "Item No."=field("Item No."),
                                  "Variant Code"=field("Variant Code"),
                                  "Serial/Lot No."=field("Lot No.");

                    trigger OnAction()
                    begin
                        if Insert then;
                    end;
                }
                separator(Action1102601003)
                {
                }
                action("&Item Tracing")
                {
                    ApplicationArea = Basic;
                    Caption = '&Item Tracing';
                    Image = ItemTracing;

                    trigger OnAction()
                    var
                        ItemTracingBuffer: Record "Item Tracing Buffer";
                        ItemTracing: Page "Item Tracing";
                    begin
                        Clear(ItemTracing);
                        ItemTracingBuffer.SetRange("Item No.","Item No.");
                        ItemTracingBuffer.SetRange("Variant Code","Variant Code");
                        ItemTracingBuffer.SetRange("Lot No.","Lot No.");
                        ItemTracing.InitFilters(ItemTracingBuffer);
                        ItemTracing.FindRecords;
                        ItemTracing.RunModal;
                    end;
                }
            }
        }
        area(processing)
        {
            action(Navigate)
            {
                ApplicationArea = Basic;
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    Navigate: Page Navigate;
                begin
                    Navigate.SetTracking('',"Lot No.");
                    Navigate.Run;
                end;
            }
        }
    }

    trigger OnInit()
    begin
        CurrPage.LookupMode := true;
    end;


    procedure GetSelectionFilter(): Text
    var
        LotNoInfo: Record "Lot No. Information";
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
    begin
        CurrPage.SetSelectionFilter(LotNoInfo);
        exit(SelectionFilterManagement.GetSelectionFilterForLotNoInformation(LotNoInfo));
    end;
}

