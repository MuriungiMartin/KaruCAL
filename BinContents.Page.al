#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7374 "Bin Contents"
{
    ApplicationArea = Basic;
    Caption = 'Bin Contents';
    DataCaptionExpression = DataCaption;
    InsertAllowed = false;
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "Bin Content";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            group(Options)
            {
                Caption = 'Options';
                field(LocationCode;LocationCode)
                {
                    ApplicationArea = Basic;
                    Caption = 'Location Filter';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Location.Reset;
                        Location.SetRange("Bin Mandatory",true);
                        if LocationCode <> '' then
                          Location.Code := LocationCode;
                        if Page.RunModal(Page::"Locations with Warehouse List",Location) = Action::LookupOK then begin
                          Location.TestField("Bin Mandatory",true);
                          LocationCode := Location.Code;
                          DefFilter;
                        end;
                        CurrPage.Update(true);
                    end;

                    trigger OnValidate()
                    begin
                        ZoneCode := '';
                        if LocationCode <> '' then begin
                          if WMSMgt.LocationIsAllowed(LocationCode) then begin
                            Location.Get(LocationCode);
                            Location.TestField("Bin Mandatory",true);
                          end else
                            Error(Text000,UserId);
                        end;
                        DefFilter;
                        LocationCodeOnAfterValidate;
                    end;
                }
                field(ZoneCode;ZoneCode)
                {
                    ApplicationArea = Basic;
                    Caption = 'Zone Filter';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Zone.Reset;
                        if ZoneCode <> '' then
                          Zone.Code := ZoneCode;
                        if LocationCode <> '' then
                          Zone.SetRange("Location Code",LocationCode);
                        if Page.RunModal(0,Zone) = Action::LookupOK then begin
                          ZoneCode := Zone.Code;
                          LocationCode := Zone."Location Code";
                          DefFilter;
                        end;
                        CurrPage.Update(true);
                    end;

                    trigger OnValidate()
                    begin
                        DefFilter;
                        ZoneCodeOnAfterValidate;
                    end;
                }
            }
            repeater(Control37)
            {
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the location code of the bin.';
                    Visible = false;
                }
                field("Zone Code";"Zone Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the zone code of the bin.';
                    Visible = false;
                }
                field("Bin Code";"Bin Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the bin code.';

                    trigger OnValidate()
                    begin
                        CheckQty;
                    end;
                }
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the item that will be stored in the bin.';

                    trigger OnValidate()
                    begin
                        CheckQty;
                    end;
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the variant code for the item in the bin.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        CheckQty;
                    end;
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the unit of measure code of the item in the bin.';
                }
                field("Qty. per Unit of Measure";"Qty. per Unit of Measure")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of base units of measure that are in the unit of measure specified for the item in the bin.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        CheckQty;
                    end;
                }
                field(Default;Default)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if the bin is the default bin for the associated item.';
                }
                field(Dedicated;Dedicated)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if the bin is used as a dedicated bin, which means that its bin content is available only to certain resources.';
                }
                field("Warehouse Class Code";"Warehouse Class Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the warehouse class code. Only items with the same warehouse class can be stored in this bin.';
                }
                field("Bin Type Code";"Bin Type Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the bin type that was selected for this bin.';
                }
                field("Bin Ranking";"Bin Ranking")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the bin ranking.';
                }
                field("Block Movement";"Block Movement")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how the movement of a particular item, or bin content, into or out of this bin, is blocked.';
                }
                field("Min. Qty.";"Min. Qty.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Indicates the minimum number of units of the item that you want to have in the bin at all times.';
                }
                field("Max. Qty.";"Max. Qty.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Indicates the maximum number of units of the item that you want to have in the bin.';
                }
                field(CalcQtyUOM;CalcQtyUOM)
                {
                    ApplicationArea = Basic;
                    Caption = 'Quantity';
                    DecimalPlaces = 0:5;
                }
                field("Quantity (Base)";"Quantity (Base)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how many units of the item, in the base unit of measure, are stored in the bin.';
                }
                field("Pick Quantity (Base)";"Pick Quantity (Base)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how many units of the item, in the base unit of measure, will be picked from the bin.';
                }
                field("ATO Components Pick Qty (Base)";"ATO Components Pick Qty (Base)")
                {
                    ApplicationArea = Basic;
                }
                field("Negative Adjmt. Qty. (Base)";"Negative Adjmt. Qty. (Base)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how many item units, in the base unit of measure, will be posted on journal lines as negative quantities.';
                }
                field("Put-away Quantity (Base)";"Put-away Quantity (Base)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how many units of the item, in the base unit of measure, will be put away in the bin.';
                }
                field("Positive Adjmt. Qty. (Base)";"Positive Adjmt. Qty. (Base)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how many item units, in the base unit of measure, will be posted on journal lines as positive quantities.';
                }
                field(CalcQtyAvailToTakeUOM;CalcQtyAvailToTakeUOM)
                {
                    ApplicationArea = Basic;
                    Caption = 'Available Qty. to Take';
                    DecimalPlaces = 0:5;
                    Editable = false;
                    ToolTip = 'Specifies the quantity of the item that is available in the bin.';
                }
                field("Fixed";Fixed)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that the item (bin content) has been associated with this bin, and that the bin should normally contain the item.';
                }
                field("Cross-Dock Bin";"Cross-Dock Bin")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if the bin content is in a cross-dock bin.';
                }
            }
            group(Control49)
            {
                fixed(Control1903651201)
                {
                    group("Item Description")
                    {
                        Caption = 'Item Description';
                        field(ItemDescription;ItemDescription)
                        {
                            ApplicationArea = Basic;
                            Editable = false;
                            ShowCaption = false;
                        }
                    }
                    group("Qty. on Adjustment Bin")
                    {
                        Caption = 'Qty. on Adjustment Bin';
                        field(CalcQtyonAdjmtBin;CalcQtyonAdjmtBin)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Qty. on Adjustment Bin';
                            DecimalPlaces = 0:5;
                            Editable = false;

                            trigger OnDrillDown()
                            var
                                WhseEntry: Record "Warehouse Entry";
                            begin
                                LocationGet("Location Code");
                                WhseEntry.SetCurrentkey(
                                  "Item No.","Bin Code","Location Code","Variant Code","Unit of Measure Code");
                                WhseEntry.SetRange("Item No.","Item No.");
                                WhseEntry.SetRange("Bin Code",AdjmtLocation."Adjustment Bin Code");
                                WhseEntry.SetRange("Location Code","Location Code");
                                WhseEntry.SetRange("Variant Code","Variant Code");
                                WhseEntry.SetRange("Unit of Measure Code","Unit of Measure Code");

                                Page.RunModal(Page::"Warehouse Entries",WhseEntry);
                            end;
                        }
                    }
                }
            }
        }
        area(factboxes)
        {
            part(Control2;"Lot Numbers by Bin FactBox")
            {
                SubPageLink = "Item No."=field("Item No."),
                              "Variant Code"=field("Variant Code"),
                              "Location Code"=field("Location Code");
                Visible = false;
            }
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
        area(navigation)
        {
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action("Warehouse Entries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Warehouse Entries';
                    Image = BinLedger;
                    RunObject = Page "Warehouse Entries";
                    RunPageLink = "Item No."=field("Item No."),
                                  "Location Code"=field("Location Code"),
                                  "Bin Code"=field("Bin Code"),
                                  "Variant Code"=field("Variant Code");
                    RunPageView = sorting("Item No.","Bin Code","Location Code","Variant Code");
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        GetItemDescr("Item No.","Variant Code",ItemDescription);
        DataCaption := StrSubstNo('%1 ',"Bin Code");
    end;

    trigger OnOpenPage()
    begin
        ItemDescription := '';
        GetWhseLocation(LocationCode,ZoneCode);
    end;

    var
        Location: Record Location;
        AdjmtLocation: Record Location;
        Zone: Record Zone;
        WMSMgt: Codeunit "WMS Management";
        LocationCode: Code[10];
        ZoneCode: Code[10];
        DataCaption: Text[80];
        ItemDescription: Text[50];
        Text000: label 'Location code is not allowed for user %1.';
        LocFilter: Text[250];

    local procedure DefFilter()
    begin
        FilterGroup := 2;
        if LocationCode <> '' then
          SetRange("Location Code",LocationCode)
        else begin
          Clear(LocFilter);
          Clear(Location);
          Location.SetRange("Bin Mandatory",true);
          if Location.Find('-') then
            repeat
              if WMSMgt.LocationIsAllowed(Location.Code) then
                LocFilter := LocFilter + Location.Code + '|';
            until Location.Next = 0;
          if StrLen(LocFilter) <> 0 then
            LocFilter := CopyStr(LocFilter,1,(StrLen(LocFilter) - 1));
          SetFilter("Location Code",LocFilter);
        end;
        if ZoneCode <> '' then
          SetRange("Zone Code",ZoneCode)
        else
          SetRange("Zone Code");
        FilterGroup := 0;
    end;

    local procedure CheckQty()
    begin
        TestField(Quantity,0);
        TestField("Pick Qty.",0);
        TestField("Put-away Qty.",0);
        TestField("Pos. Adjmt. Qty.",0);
        TestField("Neg. Adjmt. Qty.",0);
    end;

    local procedure LocationGet(LocationCode: Code[10])
    begin
        if AdjmtLocation.Code <> LocationCode then
          AdjmtLocation.Get(LocationCode);
    end;

    local procedure LocationCodeOnAfterValidate()
    begin
        CurrPage.Update(true);
    end;

    local procedure ZoneCodeOnAfterValidate()
    begin
        CurrPage.Update(true);
    end;
}

