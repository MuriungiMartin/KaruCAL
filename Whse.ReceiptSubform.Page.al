#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5769 "Whse. Receipt Subform"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    InsertAllowed = false;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Warehouse Receipt Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Source Document";"Source Document")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of document to which the line relates.';
                }
                field("Source No.";"Source No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the source document from which the entry originates.';
                }
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the item that is expected to be received.';
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the variant number of the item in the line.';
                    Visible = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the description of the item in the line.';
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the location where the items should be received.';
                    Visible = false;
                }
                field("Zone Code";"Zone Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the zone in which the items are being received.';
                    Visible = false;
                }
                field("Bin Code";"Bin Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the bin into which the items will be put upon receipt.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        BinCodeOnAfterValidate;
                    end;
                }
                field("Cross-Dock Zone Code";"Cross-Dock Zone Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the zone code that will be used for the quantity of items to be cross-docked.';
                    Visible = false;
                }
                field("Cross-Dock Bin Code";"Cross-Dock Bin Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the bin code that will be used for the quantity of items to be cross-docked.';
                    Visible = false;
                }
                field("Shelf No.";"Shelf No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the shelf number of the item for information use.';
                    Visible = false;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity that should be received.';
                }
                field("Qty. (Base)";"Qty. (Base)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity to be received, in the base unit of measure.';
                    Visible = false;
                }
                field("Qty. to Receive";"Qty. to Receive")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity that you have actually received in this particular receipt.';

                    trigger OnValidate()
                    begin
                        QtytoReceiveOnAfterValidate;
                    end;
                }
                field("Qty. to Cross-Dock";"Qty. to Cross-Dock")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the suggested quantity to put into the cross-dock bin on the put-away document when the receipt is posted.';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        ShowCrossDockOpp(CrossDockOpp2);
                        CurrPage.Update;
                    end;
                }
                field("Qty. Received";"Qty. Received")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity for this line that has been posted as received.';
                    Visible = true;
                }
                field("Qty. to Receive (Base)";"Qty. to Receive (Base)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the Qty. to Receive in the base unit of measure.';
                    Visible = false;
                }
                field("Qty. to Cross-Dock (Base)";"Qty. to Cross-Dock (Base)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the suggested base quantity to put into the cross-dock bin on the put-away document hen the receipt is posted.';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        ShowCrossDockOpp(CrossDockOpp2);
                        CurrPage.Update;
                    end;
                }
                field("Qty. Received (Base)";"Qty. Received (Base)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity received, in the base unit of measure.';
                    Visible = false;
                }
                field("Qty. Outstanding";"Qty. Outstanding")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity that still needs to be handled.';
                    Visible = true;
                }
                field("Qty. Outstanding (Base)";"Qty. Outstanding (Base)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity that still needs to be handled, in the base unit of measure.';
                    Visible = false;
                }
                field("Due Date";"Due Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date on which you expect to receive the items on the line.';
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the unit of measure code of the item on the line.';
                }
                field("Qty. per Unit of Measure";"Qty. per Unit of Measure")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of base units of measure, that are in the unit of measure specified for the item on the line.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action("Source &Document Line")
                {
                    ApplicationArea = Basic;
                    Caption = 'Source &Document Line';
                    Image = SourceDocLine;

                    trigger OnAction()
                    begin
                        ShowSourceLine;
                    end;
                }
                action("&Bin Contents List")
                {
                    AccessByPermission = TableData "Bin Content"=R;
                    ApplicationArea = Basic;
                    Caption = '&Bin Contents List';
                    Image = BinContent;

                    trigger OnAction()
                    begin
                        ShowBinContents;
                    end;
                }
                group("Item Availability by")
                {
                    Caption = 'Item Availability by';
                    Image = ItemAvailability;
                    action("Event")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Event';
                        Image = "Event";

                        trigger OnAction()
                        begin
                            ItemAvailability(ItemAvailFormsMgt.ByEvent);
                        end;
                    }
                    action(Period)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Period';
                        Image = Period;

                        trigger OnAction()
                        begin
                            ItemAvailability(ItemAvailFormsMgt.ByPeriod);
                        end;
                    }
                    action(Variant)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Variant';
                        Image = ItemVariant;

                        trigger OnAction()
                        begin
                            ItemAvailability(ItemAvailFormsMgt.ByVariant);
                        end;
                    }
                    action(Location)
                    {
                        AccessByPermission = TableData Location=R;
                        ApplicationArea = Basic;
                        Caption = 'Location';
                        Image = Warehouse;

                        trigger OnAction()
                        begin
                            ItemAvailability(ItemAvailFormsMgt.ByLocation);
                        end;
                    }
                }
                action(ItemTrackingLines)
                {
                    ApplicationArea = Basic;
                    Caption = 'Item &Tracking Lines';
                    Image = ItemTrackingLines;
                    ShortCutKey = 'Shift+Ctrl+I';

                    trigger OnAction()
                    begin
                        OpenItemTrackingLines;
                    end;
                }
            }
        }
    }

    var
        CrossDockOpp2: Record "Whse. Cross-Dock Opportunity";
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
        Text001: label 'Cross-docking has been disabled for item %1 or location %2.';

    local procedure ShowSourceLine()
    var
        WMSMgt: Codeunit "WMS Management";
    begin
        WMSMgt.ShowSourceDocLine(
          "Source Type","Source Subtype","Source No.","Source Line No.",0);
    end;

    local procedure ShowBinContents()
    var
        BinContent: Record "Bin Content";
    begin
        BinContent.ShowBinContents("Location Code","Item No.","Variant Code","Bin Code");
    end;

    local procedure ItemAvailability(AvailabilityType: Option Date,Variant,Location,Bin,"Event",BOM)
    begin
        ItemAvailFormsMgt.ShowItemAvailFromWhseRcptLine(Rec,AvailabilityType);
    end;


    procedure WhsePostRcptYesNo()
    var
        WhseRcptLine: Record "Warehouse Receipt Line";
    begin
        WhseRcptLine.Copy(Rec);
        Codeunit.Run(Codeunit::"Whse.-Post Receipt (Yes/No)",WhseRcptLine);
        Reset;
        SetCurrentkey("No.","Sorting Sequence No.");
        CurrPage.Update(false);
    end;


    procedure WhsePostRcptPrint()
    var
        WhseRcptLine: Record "Warehouse Receipt Line";
    begin
        WhseRcptLine.Copy(Rec);
        Codeunit.Run(Codeunit::"Whse.-Post Receipt + Print",WhseRcptLine);
        Reset;
        SetCurrentkey("No.","Sorting Sequence No.");
        CurrPage.Update(false);
    end;


    procedure WhsePostRcptPrintPostedRcpt()
    var
        WhseRcptLine: Record "Warehouse Receipt Line";
    begin
        WhseRcptLine.Copy(Rec);
        Codeunit.Run(Codeunit::"Whse.-Post Receipt + Pr. Pos.",WhseRcptLine);
        Reset;
        CurrPage.Update(false);
    end;


    procedure AutofillQtyToReceive()
    var
        WhseRcptLine: Record "Warehouse Receipt Line";
    begin
        WhseRcptLine.Copy(Rec);
        AutofillQtyToReceive(WhseRcptLine);
    end;


    procedure DeleteQtyToReceive()
    var
        WhseRcptLine: Record "Warehouse Receipt Line";
    begin
        WhseRcptLine.Copy(Rec);
        DeleteQtyToReceive(WhseRcptLine);
    end;

    local procedure OpenItemTrackingLines()
    begin
        OpenItemTrackingLines;
    end;

    local procedure ShowCrossDockOpp(var CrossDockOpp: Record "Whse. Cross-Dock Opportunity" temporary)
    var
        CrossDockMgt: Codeunit "Whse. Cross-Dock Management";
        UseCrossDock: Boolean;
    begin
        CrossDockMgt.GetUseCrossDock(UseCrossDock,"Location Code","Item No.");
        if not UseCrossDock then
          Error(Text001,"Item No.","Location Code");
        CrossDockMgt.ShowCrossDock(CrossDockOpp,'',"No.","Line No.","Location Code","Item No.","Variant Code");
    end;

    local procedure BinCodeOnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure QtytoReceiveOnAfterValidate()
    begin
        CurrPage.SaveRecord;
    end;
}

