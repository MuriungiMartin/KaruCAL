#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 6505 "Lot No. Information Card"
{
    Caption = 'Lot No. Information Card';
    PageType = Card;
    PopulateAllFields = true;
    SourceTable = "Lot No. Information";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies this number from the Tracking Specification table when a lot number information record is created.';
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the content of this field from the Tracking Specification table when a lot no. information record is created.';
                }
                field("Lot No.";"Lot No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies this number from the Tracking Specification table when a lot number information record is created.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
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
            }
            group(Inventory)
            {
                Caption = 'Inventory';
                field(Control23;Inventory)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the inventory quantity of the specified lot number.';
                }
                field("Expired Inventory";"Expired Inventory")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the inventory of the lot number with an expiration date before the posting date on the associated document.';
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
                separator(Action28)
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
            group(ButtonFunctions)
            {
                Caption = 'F&unctions';
                Image = "Action";
                Visible = ButtonFunctionsVisible;
                action(CopyInfo)
                {
                    ApplicationArea = Basic;
                    Caption = 'Copy &Info';
                    Ellipsis = true;
                    Image = CopySerialNo;

                    trigger OnAction()
                    var
                        SelectedRecord: Record "Lot No. Information";
                        ShowRecords: Record "Lot No. Information";
                        FocusOnRecord: Record "Lot No. Information";
                        ItemTrackingMgt: Codeunit "Item Tracking Management";
                        LotNoInfoList: Page "Lot No. Information List";
                    begin
                        ShowRecords.SetRange("Item No.","Item No.");
                        ShowRecords.SetRange("Variant Code","Variant Code");

                        FocusOnRecord.Copy(ShowRecords);
                        FocusOnRecord.SetRange("Lot No.",TrackingSpec."Lot No.");

                        LotNoInfoList.SetTableview(ShowRecords);

                        if FocusOnRecord.FindFirst then
                          LotNoInfoList.SetRecord(FocusOnRecord);
                        if LotNoInfoList.RunModal = Action::LookupOK then begin
                          LotNoInfoList.GetRecord(SelectedRecord);
                          ItemTrackingMgt.CopyLotNoInformation(SelectedRecord,"Lot No.");
                        end;
                    end;
                }
            }
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

    trigger OnOpenPage()
    begin
        SetRange("Date Filter",00000101D,WorkDate);
        if ShowButtonFunctions then
          ButtonFunctionsVisible := true;
    end;

    var
        TrackingSpec: Record "Tracking Specification";
        ShowButtonFunctions: Boolean;
        [InDataSet]
        ButtonFunctionsVisible: Boolean;


    procedure Init(CurrentTrackingSpec: Record "Tracking Specification")
    begin
        TrackingSpec := CurrentTrackingSpec;
        ShowButtonFunctions := true;
    end;


    procedure InitWhse(CurrentTrackingSpec: Record "Whse. Item Tracking Line")
    begin
        TrackingSpec."Lot No." := CurrentTrackingSpec."Lot No.";
        ShowButtonFunctions := true;
    end;
}

