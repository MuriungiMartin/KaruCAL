#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 6504 "Serial No. Information Card"
{
    Caption = 'Serial No. Information Card';
    PageType = Card;
    PopulateAllFields = true;
    SourceTable = "Serial No. Information";

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
                    ToolTip = 'Specifies the number that is copied from the Tracking Specification table, when a serial number information record is created.';
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code from the Tracking Specification table, when a serial number information record is created.';
                }
                field("Serial No.";"Serial No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies this number from the Tracking Specification table when a serial number information record is created.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the serial no. information record.';
                }
                field(Blocked;Blocked)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that a document or journal line carrying the specified serial number cannot be posted.';
                }
            }
            group(Inventory)
            {
                Caption = 'Inventory';
                field(Control19;Inventory)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the inventory quantity of the specified serial number.';
                }
                field("Expired Inventory";"Expired Inventory")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the inventory of the serial number with an expiration date before the posting date on the associated document.';
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
                    ShortCutKey = 'Ctrl+F7';

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
                separator(Action24)
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
                        SelectedRecord: Record "Serial No. Information";
                        ShowRecords: Record "Serial No. Information";
                        FocusOnRecord: Record "Serial No. Information";
                        ItemTrackingMgt: Codeunit "Item Tracking Management";
                        SerialNoInfoList: Page "Serial No. Information List";
                    begin
                        ShowRecords.SetRange("Item No.","Item No.");
                        ShowRecords.SetRange("Variant Code","Variant Code");

                        FocusOnRecord.Copy(ShowRecords);
                        FocusOnRecord.SetRange("Serial No.",TrackingSpec."Serial No.");

                        SerialNoInfoList.SetTableview(ShowRecords);

                        if FocusOnRecord.FindFirst then
                          SerialNoInfoList.SetRecord(FocusOnRecord);
                        if SerialNoInfoList.RunModal = Action::LookupOK then begin
                          SerialNoInfoList.GetRecord(SelectedRecord);
                          ItemTrackingMgt.CopySerialNoInformation(SelectedRecord,"Serial No.");
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
                    Navigate.SetTracking("Serial No.",'');
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
        TrackingSpec."Serial No." := CurrentTrackingSpec."Serial No.";
        ShowButtonFunctions := true;
    end;
}

