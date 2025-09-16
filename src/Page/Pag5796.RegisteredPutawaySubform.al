#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5796 "Registered Put-away Subform"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    Editable = false;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Registered Whse. Activity Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Action Type";"Action Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the action you must perform for the items on the line.';
                    Visible = false;
                }
                field("Source Document";"Source Document")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of document, such as sales order, to which the line relates.';
                }
                field("Source No.";"Source No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the source document from which the activity line originated.';
                }
                field("Due Date";"Due Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the activity should have been completed.';
                }
                field("Serial No.";"Serial No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the serial number that was handled.';
                    Visible = false;
                }
                field("Lot No.";"Lot No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the lot number that was handled.';
                    Visible = false;
                }
                field("Expiration Date";"Expiration Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the expiration date of the serial number that was handled.';
                    Visible = false;
                }
                field("Shelf No.";"Shelf No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the shelf number of the item on the line for information use.';
                    Visible = false;
                }
                field("Zone Code";"Zone Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the zone in which the bin on this line is located.';
                    Visible = false;
                }
                field("Bin Code";"Bin Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the bin on the registered warehouse activity line.';
                    Visible = false;
                }
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the item number of the item to be handled, such as picked or put away.';
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the variant code of the item to be handled.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the item on the line.';
                }
                field("Description 2";"Description 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the item on the line.';
                    Visible = false;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity of the item that was put-away, picked or moved.';
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the unit of measure code of the item on the line.';
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
                action("Whse. Document Line")
                {
                    ApplicationArea = Basic;
                    Caption = 'Whse. Document Line';
                    Image = Line;

                    trigger OnAction()
                    begin
                        ShowWhseLine;
                    end;
                }
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
            }
            group("&Put-away")
            {
                Caption = '&Put-away';
                Image = CreatePutAway;
                action("&Warehouse Entries")
                {
                    ApplicationArea = Basic;
                    Caption = '&Warehouse Entries';
                    Image = BinLedger;

                    trigger OnAction()
                    var
                        RegisteredWhseActivityHdr: Record "Registered Whse. Activity Hdr.";
                    begin
                        RegisteredWhseActivityHdr.Get("Activity Type","No.");
                        ShowWhseEntries(RegisteredWhseActivityHdr."Registering Date");
                    end;
                }
            }
        }
    }

    var
        WMSMgt: Codeunit "WMS Management";

    local procedure ShowSourceLine()
    begin
        WMSMgt.ShowSourceDocLine(
          "Source Type","Source Subtype","Source No.","Source Line No.","Source Subline No.");
    end;

    local procedure ShowBinContents()
    var
        BinContent: Record "Bin Content";
    begin
        BinContent.ShowBinContents("Location Code","Item No.","Variant Code","Bin Code");
    end;

    local procedure ShowWhseLine()
    begin
        WMSMgt.ShowWhseDocLine(
          "Whse. Document Type","Whse. Document No.","Whse. Document Line No.");
    end;
}

