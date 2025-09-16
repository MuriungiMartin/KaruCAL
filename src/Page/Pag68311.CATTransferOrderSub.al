#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68311 "CAT-Transfer Order Sub."
{
    AutoSplitKey = true;
    Caption = 'Transfer Order Subform';
    DelayedInsert = true;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Transfer Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Planning Flexibility";"Planning Flexibility")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Transfer-from Bin Code";"Transfer-from Bin Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Transfer-To Bin Code";"Transfer-To Bin Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    Editable = false;
                }
                field("Reserved Quantity Inbnd.";"Reserved Quantity Inbnd.")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                }
                field("Reserved Quantity Shipped";"Reserved Quantity Shipped")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                }
                field("Reserved Quantity Outbnd.";"Reserved Quantity Outbnd.")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                }
                field("Unit of Measure";"Unit of Measure")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Qty. to Ship";"Qty. to Ship")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    Editable = false;
                }
                field("Quantity Shipped";"Quantity Shipped")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;

                    trigger OnDrillDown()
                    var
                        TransShptLine: Record "Transfer Shipment Line";
                    begin
                        TestField("Document No.");
                        TestField("Item No.");
                        TransShptLine.SetCurrentkey("Transfer Order No.","Item No.","Shipment Date");
                        TransShptLine.SetRange("Transfer Order No.","Document No.");
                        TransShptLine.SetRange("Item No.","Item No.");
                        Page.RunModal(0,TransShptLine);
                    end;
                }
                field("Qty. to Receive";"Qty. to Receive")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;

                    trigger OnValidate()
                    begin
                            if "Qty. to Receive (Base)">"Quantity Shipped" then
                            begin
                              Error('You Can Not Receive More Than Shipped Quantity')
                            end;
                    end;
                }
                field("Quantity Received";"Quantity Received")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;

                    trigger OnDrillDown()
                    var
                        TransRcptLine: Record "Transfer Receipt Line";
                    begin
                        TestField("Document No.");
                        TestField("Item No.");
                        TransRcptLine.SetCurrentkey("Transfer Order No.","Item No.","Receipt Date");
                        TransRcptLine.SetRange("Transfer Order No.","Document No.");
                        TransRcptLine.SetRange("Item No.","Item No.");
                        Page.RunModal(0,TransRcptLine);
                    end;
                }
                field("Shipment Date";"Shipment Date")
                {
                    ApplicationArea = Basic;
                }
                field("Receipt Date";"Receipt Date")
                {
                    ApplicationArea = Basic;
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("ShortcutDimCode[3]";ShortcutDimCode[3])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,3';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupShortcutDimCode(3,ShortcutDimCode[3]);
                    end;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(3,ShortcutDimCode[3]);
                    end;
                }
                field("ShortcutDimCode[4]";ShortcutDimCode[4])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,4';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupShortcutDimCode(4,ShortcutDimCode[4]);
                    end;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(4,ShortcutDimCode[4]);
                    end;
                }
                field("ShortcutDimCode[5]";ShortcutDimCode[5])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,5';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupShortcutDimCode(5,ShortcutDimCode[5]);
                    end;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(5,ShortcutDimCode[5]);
                    end;
                }
                field("ShortcutDimCode[6]";ShortcutDimCode[6])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,6';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupShortcutDimCode(6,ShortcutDimCode[6]);
                    end;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(6,ShortcutDimCode[6]);
                    end;
                }
                field("ShortcutDimCode[7]";ShortcutDimCode[7])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,7';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupShortcutDimCode(7,ShortcutDimCode[7]);
                    end;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(7,ShortcutDimCode[7]);
                    end;
                }
                field("ShortcutDimCode[8]";ShortcutDimCode[8])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,8';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupShortcutDimCode(8,ShortcutDimCode[8]);
                    end;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(8,ShortcutDimCode[8]);
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        ShowShortcutDimCode(ShortcutDimCode);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Clear(ShortcutDimCode);
    end;

    var
        ShortcutDimCode: array [8] of Code[20];


    procedure ShowDimensions()
    begin
        Rec.ShowDimensions;
    end;


    procedure ItemAvailability(AvailabilityType: Option Date,Variant,Location)
    begin
    end;


    procedure ShowReservation()
    begin
        Find;
        Rec.ShowReservation;
    end;


    procedure OpenItemTrackingLines(Direction: Option Outbound,Inbound)
    begin
        OpenItemTrackingLines(Direction);
    end;


    procedure UpdateForm(SetSaveRecord: Boolean)
    begin
        CurrPage.Update(SetSaveRecord);
    end;
}

