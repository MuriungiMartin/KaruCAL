#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7398 "Internal Movement Subform"
{
    Caption = 'Lines';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Internal Movement Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the item that is available to move from the bin.';

                    trigger OnValidate()
                    begin
                        ItemNoOnAfterValidate;
                    end;
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the variant of the item on the line.';
                    Visible = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the same as the field with the same name in the Whse. Internal Put-away Line table.';
                }
                field("Description 2";"Description 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the second description of the item.';
                    Visible = false;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'This field contains the location code that applies to the internal movement line.';
                }
                field("Shelf No.";"Shelf No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the shelf number that is recorded on the item card or on the stockkeeping unit card of the item that is being moved.';
                    Visible = false;
                }
                field("From Bin Code";"From Bin Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the bin that the items on the internal movement are picked from.';

                    trigger OnValidate()
                    begin
                        FromBinCodeOnAfterValidate;
                    end;
                }
                field("To Bin Code";"To Bin Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the bin where you want items on this internal movement to be placed when they are picked.';
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity of items to be moved. The quantity must be lower than or equal to the bin content.';
                }
                field("Qty. (Base)";"Qty. (Base)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity of units to be moved.';
                    Visible = false;
                }
                field("Due Date";"Due Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the same as the field with the same name in the Whse. Internal Put-away Line table.';

                    trigger OnValidate()
                    begin
                        DueDateOnAfterValidate;
                    end;
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the same as the field with the same name in the Whse. Internal Put-away Line table.';
                }
                field("Qty. per Unit of Measure";"Qty. per Unit of Measure")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the same as the field with the same name in the Whse. Internal Put-away Line table.';
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
                        ShowBinContent;
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
                        OpenItemTrackingLinesForm;
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

    local procedure GetActualSortMethod(): Integer
    var
        InternalMovementHeader: Record "Internal Movement Header";
    begin
        if InternalMovementHeader.Get("No.") then
          exit(InternalMovementHeader."Sorting Method");
    end;

    local procedure ShowBinContent()
    var
        BinContent: Record "Bin Content";
    begin
        BinContent.ShowBinContents("Location Code","Item No.","Variant Code","From Bin Code");
    end;

    local procedure OpenItemTrackingLinesForm()
    begin
        OpenItemTrackingLines;
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

