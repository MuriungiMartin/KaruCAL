#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7336 "Whse. Shipment Subform"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    InsertAllowed = false;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Warehouse Shipment Line";

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
                    ToolTip = 'Specifies the source number of the document from which the line originates.';
                }
                field("Source Line No.";"Source Line No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the source line number of the document from which the entry originates.';
                    Visible = false;
                }
                field("Destination Type";"Destination Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of destination associated with the warehouse shipment line.';
                    Visible = false;
                }
                field("Destination No.";"Destination No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the customer, vendor, or location to which the items should be shipped.';
                    Visible = false;
                }
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the item that should be shipped.';
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the variant code of the item in the line, if any.';
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
                    Editable = false;
                    ToolTip = 'Specifies the code of the location from which the items on the line are being shipped.';
                    Visible = false;
                }
                field("Zone Code";"Zone Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the zone where the bin on this shipment line is located.';
                    Visible = false;
                }
                field("Bin Code";"Bin Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the bin in which the items will be placed before shipment.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        BinCodeOnAfterValidate;
                    end;
                }
                field("Shelf No.";"Shelf No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the shelf number of the item for informational use.';
                    Visible = false;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity that should be shipped.';

                    trigger OnValidate()
                    begin
                        QuantityOnAfterValidate;
                    end;
                }
                field("Qty. (Base)";"Qty. (Base)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity that should be shipped, in the base unit of measure.';
                    Visible = false;
                }
                field("Qty. to Ship";"Qty. to Ship")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity that will be shipped when the warehouse shipment is posted.';
                }
                field("Qty. Shipped";"Qty. Shipped")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity of the item on the line that is posted as shipped.';
                }
                field("Qty. to Ship (Base)";"Qty. to Ship (Base)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity, in base units of measure, that will be shipped when the warehouse shipment is posted.';
                    Visible = false;
                }
                field("Qty. Shipped (Base)";"Qty. Shipped (Base)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity that is posted as shipped expressed in the base unit of measure.';
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
                    ToolTip = 'Specifies the quantity that still needs to be handled, expressed in the base unit of measure.';
                    Visible = false;
                }
                field("Pick Qty.";"Pick Qty.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity in pick instructions assigned to be picked for the warehouse shipment line.';
                    Visible = false;
                }
                field("Pick Qty. (Base)";"Pick Qty. (Base)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity, in the base unit of measure, in pick instructions, that is assigned to be picked for the warehouse shipment line.';
                    Visible = false;
                }
                field("Qty. Picked";"Qty. Picked")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how many of the total shipment quantity have been registered as picked.';
                    Visible = false;
                }
                field("Qty. Picked (Base)";"Qty. Picked (Base)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how many of the total shipment quantity in the base unit of measure have been registered as picked.';
                    Visible = false;
                }
                field("Due Date";"Due Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the related warehouse activity, such as a pick, must be completed to ensure items can be shipped by the shipment date.';
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the unit of measure code of the item on the line.';
                }
                field("Qty. per Unit of Measure";"Qty. per Unit of Measure")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of base units of measure that are in the unit of measure specified for the item on the line.';
                }
                field(QtyCrossDockedUOM;QtyCrossDockedUOM)
                {
                    ApplicationArea = Basic;
                    Caption = 'Qty. on Cross-Dock Bin';
                    DecimalPlaces = 0:5;
                    Editable = false;
                    Visible = false;

                    trigger OnDrillDown()
                    begin
                        CrossDockMgt.ShowBinContentsCrossDocked("Item No.","Variant Code","Unit of Measure Code","Location Code",true);
                    end;
                }
                field(QtyCrossDockedUOMBase;QtyCrossDockedUOMBase)
                {
                    ApplicationArea = Basic;
                    Caption = 'Qty. on Cross-Dock Bin (Base)';
                    DecimalPlaces = 0:5;
                    Editable = false;
                    Visible = false;

                    trigger OnDrillDown()
                    begin
                        CrossDockMgt.ShowBinContentsCrossDocked("Item No.","Variant Code","Unit of Measure Code","Location Code",true);
                    end;
                }
                field(QtyCrossDockedAllUOMBase;QtyCrossDockedAllUOMBase)
                {
                    ApplicationArea = Basic;
                    Caption = 'Qty. on Cross-Dock Bin (Base all UOM)';
                    DecimalPlaces = 0:5;
                    Editable = false;
                    Visible = false;

                    trigger OnDrillDown()
                    begin
                        CrossDockMgt.ShowBinContentsCrossDocked("Item No.","Variant Code","Unit of Measure Code","Location Code",false);
                    end;
                }
                field(Control3;"Assemble to Order")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if the warehouse shipment line is for items that are assembled to a sales order before it is shipped.';
                    Visible = false;
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
                action("Assemble to Order")
                {
                    AccessByPermission = TableData "BOM Component"=R;
                    ApplicationArea = Basic;
                    Caption = 'Assemble to Order';
                    Image = AssemblyBOM;

                    trigger OnAction()
                    var
                        ATOLink: Record "Assemble-to-Order Link";
                        ATOSalesLine: Record "Sales Line";
                    begin
                        TestField("Assemble to Order",true);
                        TestField("Source Type",Database::"Sales Line");
                        ATOSalesLine.Get("Source Subtype","Source No.","Source Line No.");
                        ATOLink.ShowAsm(ATOSalesLine);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        CrossDockMgt.CalcCrossDockedItems("Item No.","Variant Code","Unit of Measure Code","Location Code",
          QtyCrossDockedUOMBase,
          QtyCrossDockedAllUOMBase);
        QtyCrossDockedUOM := 0;
        if  "Qty. per Unit of Measure" <> 0 then
          QtyCrossDockedUOM := ROUND(QtyCrossDockedUOMBase / "Qty. per Unit of Measure",0.00001);
    end;

    var
        WMSMgt: Codeunit "WMS Management";
        CrossDockMgt: Codeunit "Whse. Cross-Dock Management";
        QtyCrossDockedUOM: Decimal;
        QtyCrossDockedAllUOMBase: Decimal;
        QtyCrossDockedUOMBase: Decimal;

    local procedure ShowSourceLine()
    begin
        WMSMgt.ShowSourceDocLine("Source Type","Source Subtype","Source No.","Source Line No.",0);
    end;


    procedure PostShipmentYesNo()
    var
        WhseShptLine: Record "Warehouse Shipment Line";
    begin
        WhseShptLine.Copy(Rec);
        Codeunit.Run(Codeunit::"Whse.-Post Ship. (Ship/Invoic)",WhseShptLine);
        Reset;
        SetCurrentkey("No.","Sorting Sequence No.");
        CurrPage.Update(false);
    end;


    procedure PostShipmentPrintYesNo()
    var
        WhseShptLine: Record "Warehouse Shipment Line";
    begin
        WhseShptLine.Copy(Rec);
        Codeunit.Run(Codeunit::"Whse.-Post Shipment + Print",WhseShptLine);
        Reset;
        SetCurrentkey("No.","Sorting Sequence No.");
        CurrPage.Update(false);
    end;


    procedure AutofillQtyToHandle()
    var
        WhseShptLine: Record "Warehouse Shipment Line";
    begin
        WhseShptLine.Copy(Rec);
        AutofillQtyToHandle(WhseShptLine);
    end;


    procedure DeleteQtyToHandle()
    var
        WhseShptLine: Record "Warehouse Shipment Line";
    begin
        WhseShptLine.Copy(Rec);
        DeleteQtyToHandle(WhseShptLine);
    end;

    local procedure ShowBinContents()
    var
        BinContent: Record "Bin Content";
    begin
        BinContent.ShowBinContents("Location Code","Item No.","Variant Code","Bin Code");
    end;


    procedure PickCreate()
    var
        WhseShptHeader: Record "Warehouse Shipment Header";
        WhseShptLine: Record "Warehouse Shipment Line";
        ReleaseWhseShipment: Codeunit "Whse.-Shipment Release";
    begin
        WhseShptLine.Copy(Rec);
        WhseShptHeader.Get(WhseShptLine."No.");
        if WhseShptHeader.Status = WhseShptHeader.Status::Open then
          ReleaseWhseShipment.Release(WhseShptHeader);
        CreatePickDoc(WhseShptLine,WhseShptHeader);
    end;

    local procedure OpenItemTrackingLines()
    begin
        OpenItemTrackingLines;
    end;

    local procedure BinCodeOnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure QuantityOnAfterValidate()
    begin
        CurrPage.Update;
    end;
}

