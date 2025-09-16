#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7355 "Internal Put-away Subform"
{
    Caption = 'Lines';
    DelayedInsert = true;
    InsertAllowed = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Whse. Internal Put-away Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the item that you want to put away and have entered on the line.';

                    trigger OnValidate()
                    begin
                        ItemNoOnAfterValidate;
                    end;
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the variant number of the item in the line, if any.';
                    Visible = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the description of the item on the line.';
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the location of the internal put-away line.';
                    Visible = false;
                }
                field("From Zone Code";"From Zone Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Indicates the zone from which the items to be put away should be taken.';
                    Visible = false;
                }
                field("From Bin Code";"From Bin Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Indicates the bin from which the items to be put away should be taken.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        FromBinCodeOnAfterValidate;
                    end;
                }
                field("Shelf No.";"Shelf No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the shelf number that is recorded on the item card or the stockkeeping unit card of the item being moved.';
                    Visible = false;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity that should be put away.';
                }
                field("Qty. (Base)";"Qty. (Base)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity that should be put away, in the base unit of measure.';
                    Visible = false;
                }
                field("Qty. Outstanding";"Qty. Outstanding")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity that still needs to be handled.';
                    Visible = true;
                }
                field("Qty. Put Away";"Qty. Put Away")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity of the line that is registered as put away.';
                }
                field("Qty. Put Away (Base)";"Qty. Put Away (Base)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity of the line that is registered as put away, in the base unit of measure.';
                    Visible = false;
                }
                field("Put-away Qty.";"Put-away Qty.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity in the put-away instructions that is assigned to be put away.';
                }
                field("Put-away Qty. (Base)";"Put-away Qty. (Base)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity in the put-away instructions assigned to be put away, in the base unit of measure.';
                    Visible = false;
                }
                field("Qty. Outstanding (Base)";"Qty. Outstanding (Base)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity that still needs to be handled, expressed in the base unit of measure.';
                    Visible = false;
                }
                field("Due Date";"Due Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the due date of the line.';

                    trigger OnValidate()
                    begin
                        DueDateOnAfterValidate;
                    end;
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of unit of measure of the item on the line.';
                }
                field("Qty. per Unit of Measure";"Qty. per Unit of Measure")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of base units of measure, that are in the unit of measure, specified for the item on the line.';
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
                action("Bin Contents List")
                {
                    ApplicationArea = Basic;
                    Caption = 'Bin Contents List';
                    Image = BinContent;

                    trigger OnAction()
                    begin
                        ShowBinContents;
                    end;
                }
                action("Item &Tracking Lines")
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

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        SetUpNewLine(xRec);
    end;

    var
        SortMethod: Option " ",Item,"Shelf/Bin No.","Due Date";

    local procedure ShowBinContents()
    var
        BinContent: Record "Bin Content";
    begin
        BinContent.ShowBinContents("Location Code","Item No.","Variant Code","From Bin Code");
    end;


    procedure PutAwayCreate()
    var
        WhseInternalPutAwayHeader: Record "Whse. Internal Put-away Header";
        WhseInternalPutAwayLine: Record "Whse. Internal Put-away Line";
        ReleaseWhseInternalPutAway: Codeunit "Whse. Int. Put-away Release";
    begin
        WhseInternalPutAwayLine.Copy(Rec);
        WhseInternalPutAwayHeader.Get("No.");
        if WhseInternalPutAwayHeader.Status = WhseInternalPutAwayHeader.Status::Open then
          ReleaseWhseInternalPutAway.Release(WhseInternalPutAwayHeader);
        CreatePutAwayDoc(WhseInternalPutAwayLine);
    end;

    local procedure GetActualSortMethod(): Decimal
    var
        WhseInternalPutAwayHeader: Record "Whse. Internal Put-away Header";
    begin
        if WhseInternalPutAwayHeader.Get("No.") then
          exit(WhseInternalPutAwayHeader."Sorting Method");
        exit(0);
    end;

    local procedure ItemNoOnAfterValidate()
    begin
        if GetActualSortMethod = Sortmethod::Item then
          CurrPage.Update;
    end;

    local procedure FromBinCodeOnAfterValidate()
    begin
        if GetActualSortMethod = Sortmethod::"Shelf/Bin No." then
          CurrPage.Update;
    end;

    local procedure DueDateOnAfterValidate()
    begin
        if GetActualSortMethod = Sortmethod::"Due Date" then
          CurrPage.Update;
    end;
}

