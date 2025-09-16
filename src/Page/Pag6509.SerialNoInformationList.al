#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 6509 "Serial No. Information List"
{
    Caption = 'Serial No. Information List';
    CardPageID = "Serial No. Information Card";
    Editable = false;
    PageType = List;
    SourceTable = "Serial No. Information";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number that is copied from the Tracking Specification table, when a serial number information record is created.';
                    Visible = false;
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code from the Tracking Specification table, when a serial number information record is created.';
                    Visible = false;
                }
                field("Serial No.";"Serial No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies this number from the Tracking Specification table when a serial number information record is created.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    ToolTip = 'Specifies a description of the serial no. information record.';
                }
                field(Blocked;Blocked)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that a document or journal line carrying the specified serial number cannot be posted.';
                }
                field(Control16;Comment)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that a comment has been recorded for the serial number.';
                }
                field(Inventory;Inventory)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the inventory quantity of the specified serial number.';
                    Visible = false;
                }
                field("Expired Inventory";"Expired Inventory")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the inventory of the serial number with an expiration date before the posting date on the associated document.';
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
            group("&Serial No.")
            {
                Caption = '&Serial No.';
                Image = SerialNo;
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
                        ItemTrackingDocMgt.ShowItemTrackingForMasterData(0,'',"Item No.","Variant Code","Serial No.",'','');
                    end;
                }
                action(Comment)
                {
                    ApplicationArea = Basic;
                    Caption = 'Comment';
                    Image = ViewComments;
                    RunObject = Page "Item Tracking Comments";
                    RunPageLink = Type=const("Serial No."),
                                  "Item No."=field("Item No."),
                                  "Variant Code"=field("Variant Code"),
                                  "Serial/Lot No."=field("Serial No.");

                    trigger OnAction()
                    begin
                        if Insert then;
                    end;
                }
                separator(Action1102601004)
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
                        ItemTracingBuffer.SetRange("Serial No.","Serial No.");
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
                    Navigate.SetTracking("Serial No.",'');
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
        SerialNoInfo: Record "Serial No. Information";
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
    begin
        CurrPage.SetSelectionFilter(SerialNoInfo);
        exit(SelectionFilterManagement.GetSelectionFilterForSerialNoInformation(SerialNoInfo));
    end;
}

