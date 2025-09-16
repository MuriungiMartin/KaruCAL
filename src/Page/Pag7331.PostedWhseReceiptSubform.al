#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7331 "Posted Whse. Receipt Subform"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    Editable = false;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Posted Whse. Receipt Line";

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
                field("Due Date";"Due Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date that the receipt line was due.';
                }
                field("Shelf No.";"Shelf No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the shelf number of the item for informational use.';
                    Visible = false;
                }
                field("Zone Code";"Zone Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the zone on this posted receipt line.';
                    Visible = false;
                }
                field("Bin Code";"Bin Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the bin on the posted receipt line.';
                    Visible = false;
                }
                field("Cross-Dock Zone Code";"Cross-Dock Zone Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the zone code used to create the cross-dock put-away for this line when the receipt was posted.';
                    Visible = false;
                }
                field("Cross-Dock Bin Code";"Cross-Dock Bin Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the bin code used to create the cross-dock put-away for this line when the receipt was posted.';
                    Visible = false;
                }
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the item that was received and posted.';
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
                    ToolTip = 'Specifies the description of the item in the line.';
                }
                field("Description 2";"Description 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a second description of the item in the line, if any.';
                    Visible = false;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity that was received.';
                }
                field("Qty. (Base)";"Qty. (Base)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity that was received, in the base unit of measure.';
                    Visible = false;
                }
                field("Qty. Put Away";"Qty. Put Away")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity that is put away.';
                    Visible = false;
                }
                field("Qty. Cross-Docked";"Qty. Cross-Docked")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity of items that was in the Qty. To Cross-Dock field on the warehouse receipt line when it was posted.';
                    Visible = false;
                }
                field("Qty. Put Away (Base)";"Qty. Put Away (Base)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity that is put away, in the base unit of measure.';
                    Visible = false;
                }
                field("Qty. Cross-Docked (Base)";"Qty. Cross-Docked (Base)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the base quantity of items in the Qty. To Cross-Dock (Base) field on the warehouse receipt line when it was posted.';
                    Visible = false;
                }
                field("Put-away Qty.";"Put-away Qty.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity on put-away instructions in the process of being put away.';
                    Visible = false;
                }
                field("Put-away Qty. (Base)";"Put-away Qty. (Base)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity on put-away instructions, in the base unit of measure, in the process of being put away.';
                    Visible = false;
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the unit of measure for the item on the line.';
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
                action("Posted Source Document")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Source Document';
                    Image = PostedOrder;

                    trigger OnAction()
                    begin
                        ShowPostedSourceDoc;
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
        }
    }

    var
        WMSMgt: Codeunit "WMS Management";

    local procedure ShowPostedSourceDoc()
    begin
        WMSMgt.ShowPostedSourceDoc("Posted Source Document","Posted Source No.");
    end;

    local procedure ShowBinContents()
    var
        BinContent: Record "Bin Content";
    begin
        BinContent.ShowBinContents("Location Code","Item No.","Variant Code","Bin Code");
    end;

    local procedure ShowWhseLine()
    begin
        WMSMgt.ShowWhseDocLine(0,"Whse. Receipt No.","Whse Receipt Line No.");
    end;


    procedure PutAwayCreate()
    var
        PostedWhseRcptHdr: Record "Posted Whse. Receipt Header";
        PostedWhseRcptLine: Record "Posted Whse. Receipt Line";
    begin
        PostedWhseRcptHdr.Get("No.");
        PostedWhseRcptLine.Copy(Rec);
        CreatePutAwayDoc(PostedWhseRcptLine,PostedWhseRcptHdr."Assigned User ID");
    end;
}

