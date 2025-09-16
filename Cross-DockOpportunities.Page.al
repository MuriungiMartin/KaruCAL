#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5783 "Cross-Dock Opportunities"
{
    AutoSplitKey = true;
    Caption = 'Cross-Dock Opportunities';
    InsertAllowed = false;
    PageType = Worksheet;
    PopulateAllFields = true;
    SourceTable = "Whse. Cross-Dock Opportunity";

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
                    Editable = false;
                    ToolTip = 'Specifies the item number of the items that can be cross-docked.';
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the variant code of the items that can be cross-docked.';
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the location on the warehouse receipt line related to this cross-dock opportunity.';
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the unit of measure code of the items that can be cross-docked.';
                }
                field("Qty. per Unit of Measure";"Qty. per Unit of Measure")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of base units of measure in which the item has been received.';
                }
            }
            repeater(Control1)
            {
                field("To Source Document";"To Source Document")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the type of source document for which the cross-dock opportunity can be used, such as sales order.';
                }
                field("To Source No.";"To Source No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the source document for which items can be cross-docked.';
                }
                field("Qty. Needed";"Qty. Needed")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity that is still needed on the document for which the items can be cross-docked.';
                    Visible = true;
                }
                field("Qty. Needed (Base)";"Qty. Needed (Base)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity that is needed to complete the outbound source document line, in the base unit of measure.';
                    Visible = false;
                }
                field("Pick Qty.";"Pick Qty.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity of the item that is on pick instructions for the outbound source document, but that has not yet been registered as picked.';
                    Visible = false;
                }
                field("Pick Qty. (Base)";"Pick Qty. (Base)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity of the item that is on pick instructions for the outbound source document, but that has not yet been registered as picked.';
                    Visible = false;
                }
                field("Qty. to Cross-Dock";"Qty. to Cross-Dock")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity that is ready to cross-dock.';

                    trigger OnValidate()
                    begin
                        CalcValues;
                        QtytoCrossDockOnAfterValidate;
                    end;
                }
                field("Qty. to Cross-Dock (Base)";"Qty. to Cross-Dock (Base)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity, in the base units of measure, that is ready to cross-dock.';
                    Visible = false;
                }
                field("To-Src. Unit of Measure Code";"To-Src. Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the unit of measure code on the source document line that needs the cross-dock opportunity item.';
                    Visible = true;
                }
                field("To-Src. Qty. per Unit of Meas.";"To-Src. Qty. per Unit of Meas.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity of base units of measure, on the source document line, that needs the cross-dock opportunity items.';
                    Visible = false;
                }
                field("Due Date";"Due Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the outbound warehouse activity should be started.';
                }
                field("Unit of Measure Code2";"Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the unit of measure code of the items that can be cross-docked.';
                    Visible = false;
                }
                field("Qty. per Unit of Measure2";"Qty. per Unit of Measure")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of base units of measure in which the item has been received.';
                    Visible = false;
                }
                field("Reserved Quantity";"Reserved Quantity")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of units of the item on the line reserved for the source document line.';
                }
                field("Reserved Qty. (Base)";"Reserved Qty. (Base)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of units of the item on the line reserved for the related source document line.';
                    Visible = false;
                }
                field("""Qty. Needed (Base)"" - ""Qty. to Cross-Dock (Base)""";"Qty. Needed (Base)" - "Qty. to Cross-Dock (Base)")
                {
                    ApplicationArea = Basic;
                    Caption = 'Rem. Qty. to Cross-Dock (Base)';
                    DecimalPlaces = 0:5;
                    Editable = false;
                }
            }
            group(Control67)
            {
                fixed(Control1903900601)
                {
                    group("Total Qty. To Handle (Base)")
                    {
                        Caption = 'Total Qty. To Handle (Base)';
                        field(QtyToHandleBase;QtyToHandleBase)
                        {
                            ApplicationArea = Basic;
                            DecimalPlaces = 0:5;
                            Editable = false;
                            ShowCaption = false;
                        }
                        field(Text000;Text000)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Qty. on Cross-Dock Bin (Base)';
                            Visible = false;
                        }
                        field("Qty. to be Cross-Docked on Receipt Line";Text000)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Qty. to be Cross-Docked on Receipt Line';
                            Visible = false;
                        }
                    }
                    group("Total Qty. To Be Cross-Docked")
                    {
                        Caption = 'Total Qty. To Be Cross-Docked';
                        field("Qty. Cross-Docked (Base)";"Qty. Cross-Docked (Base)")
                        {
                            ApplicationArea = Basic;
                            Caption = 'Total Qty. To Be Cross-Docked';
                            DecimalPlaces = 0:5;
                            DrillDown = false;
                            Editable = false;
                            MultiLine = true;
                            ToolTip = 'Specifies the quantity, in the base units of measure, that have been cross-docked.';
                        }
                        field(QtyOnCrossDockBase;QtyOnCrossDockBase)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Qty. To Handle (Base)';
                            DecimalPlaces = 0:5;
                            Editable = false;
                        }
                        field(QtyToBeCrossDockedBase;QtyToBeCrossDockedBase)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Qty. To Handle (Base)';
                            DecimalPlaces = 0:5;
                            Editable = false;
                        }
                    }
                    group("Total Rem. Qty. to Cross-Dock (Base)")
                    {
                        Caption = 'Total Rem. Qty. to Cross-Dock (Base)';
                        field("""Total Qty. Needed (Base)"" - ""Qty. Cross-Docked (Base)""";"Total Qty. Needed (Base)" - "Qty. Cross-Docked (Base)")
                        {
                            ApplicationArea = Basic;
                            Caption = 'Total Rem. Qty. to Cross-Dock (Base)';
                            DecimalPlaces = 0:5;
                            Editable = false;
                            MultiLine = true;
                        }
                        field(Control43;Text000)
                        {
                            ApplicationArea = Basic;
                            Visible = false;
                        }
                        field(Control51;Text000)
                        {
                            ApplicationArea = Basic;
                            Visible = false;
                        }
                    }
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
                action("Source &Document Line")
                {
                    ApplicationArea = Basic;
                    Caption = 'Source &Document Line';
                    Image = SourceDocLine;

                    trigger OnAction()
                    var
                        WMSMgt: Codeunit "WMS Management";
                    begin
                        WMSMgt.ShowSourceDocLine(
                          "To Source Type","To Source Subtype","To Source No.","To Source Line No.","To Source Subline No.");
                    end;
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Refresh &Cross-Dock Opportunities")
                {
                    ApplicationArea = Basic;
                    Caption = 'Refresh &Cross-Dock Opportunities';
                    Image = Refresh;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        CrossDockMgt: Codeunit "Whse. Cross-Dock Management";
                        Dummy: Decimal;
                    begin
                        if Confirm(Text001,false,WhseCrossDockOpportunity.TableCaption) then begin
                          CrossDockMgt.SetTemplate(TemplateName2,NameNo2,LocationCode2);
                          CrossDockMgt.CalculateCrossDockLine(
                            Rec,ItemNo2,VariantCode2,
                            QtyNeededSumBase,Dummy,QtyOnCrossDockBase,
                            LineNo2,QtyToHandleBase);
                        end;
                    end;
                }
                action("Autofill Qty. to Cross-Dock")
                {
                    ApplicationArea = Basic;
                    Caption = 'Autofill Qty. to Cross-Dock';
                    Image = AutofillQtyToHandle;

                    trigger OnAction()
                    begin
                        AutoFillQtyToCrossDock(Rec);
                        CurrPage.Update;
                    end;
                }
                action(Reserve)
                {
                    ApplicationArea = Basic;
                    Caption = 'Reserve';
                    Image = Reserve;

                    trigger OnAction()
                    begin
                        ShowReservation;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        CalcValues;
        CalcFields("Qty. Cross-Docked (Base)");
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        "Item No." := ItemNo2;
        "Source Template Name" := TemplateName2;
        "Source Name/No." := NameNo2;
        "Source Line No." := LineNo2;
        "Variant Code" := VariantCode2;
        "Location Code" := LocationCode2;
    end;

    trigger OnOpenPage()
    begin
        CalcValues;
    end;

    var
        WhseCrossDockOpportunity: Record "Whse. Cross-Dock Opportunity";
        CrossDockMgt: Codeunit "Whse. Cross-Dock Management";
        QtyToHandleBase: Decimal;
        QtyNeededSumBase: Decimal;
        QtyOnCrossDockBase: Decimal;
        Text001: label 'The current %1 lines will be deleted, do you want to continue?';
        ItemNo2: Code[20];
        VariantCode2: Code[10];
        LocationCode2: Code[10];
        TemplateName2: Code[10];
        NameNo2: Code[20];
        LineNo2: Integer;
        QtyToBeCrossDockedBase: Decimal;
        UOMCode2: Code[10];
        QtyPerUOM2: Decimal;
        Text000: label 'Placeholder';


    procedure SetValues(ItemNo: Code[20];VariantCode: Code[10];LocationCode: Code[10];TemplateName: Code[10];NameNo: Code[20];LineNo: Integer;UOMCode: Code[10];QtyPerUOM: Decimal)
    begin
        ItemNo2 := ItemNo;
        VariantCode2 := VariantCode;
        LocationCode2 := LocationCode;
        TemplateName2 := TemplateName;
        NameNo2 := NameNo;
        LineNo2 := LineNo;
        UOMCode2 := UOMCode;
        QtyPerUOM2 := QtyPerUOM;
    end;

    local procedure CalcValues()
    var
        ReceiptLine: Record "Warehouse Receipt Line";
        Dummy: Decimal;
    begin
        CrossDockMgt.CalcCrossDockedItems(ItemNo2,VariantCode2,'',LocationCode2,Dummy,QtyOnCrossDockBase);
        QtyOnCrossDockBase += CrossDockMgt.CalcCrossDockReceivedNotPutAway(LocationCode2,ItemNo2,VariantCode2);

        if TemplateName2 = '' then begin
          ReceiptLine.Get(NameNo2,LineNo2);
          QtyToHandleBase := ReceiptLine."Qty. to Receive (Base)";
        end;

        CalcFields("Qty. Cross-Docked (Base)","Total Qty. Needed (Base)");
        QtyToBeCrossDockedBase := "Qty. Cross-Docked (Base)" - QtyOnCrossDockBase;
        if QtyToBeCrossDockedBase < 0 then
          QtyToBeCrossDockedBase := 0;

        "Item No." := ItemNo2;
        "Variant Code" := VariantCode2;
        "Location Code" := LocationCode2;
        "Unit of Measure Code" := UOMCode2;
        "Qty. per Unit of Measure" := QtyPerUOM2;
    end;


    procedure GetValues(var QtyToCrossDock: Decimal)
    begin
        QtyToCrossDock := QtyToBeCrossDockedBase;
    end;

    local procedure QtytoCrossDockOnAfterValidate()
    begin
        CurrPage.Update;
    end;
}

