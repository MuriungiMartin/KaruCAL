#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5966 "Service Quote Lines"
{
    AutoSplitKey = true;
    Caption = 'Service Quote Lines';
    DataCaptionFields = "Document Type","Document No.";
    DelayedInsert = true;
    PageType = Worksheet;
    PopulateAllFields = true;
    SourceTable = "Service Line";

    layout
    {
        area(content)
        {
            field(SelectionFilter;SelectionFilter)
            {
                ApplicationArea = Basic;
                Caption = 'Service Quote Lines Filter';
                OptionCaption = 'All,Per Selected Service Item Line,Service Item Line Non-Related';
                ToolTip = 'Specifies a selection filter.';

                trigger OnValidate()
                begin
                    SelectionFilterOnAfterValidate;
                end;
            }
            repeater(Control1)
            {
                field("Service Item Line No.";"Service Item Line No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the service item line number linked to this service line.';
                    Visible = false;
                }
                field("Service Item No.";"Service Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the service item number linked to this service line.';
                }
                field("Service Item Serial No.";"Service Item Serial No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the service item serial number linked to this line.';
                    Visible = false;
                }
                field("Service Item Line Description";"Service Item Line Description")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    ToolTip = 'Specifies the description of the service item line in the service order.';
                    Visible = false;
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of the service line.';

                    trigger OnValidate()
                    begin
                        NoOnAfterValidate;
                    end;
                }
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of an item, general ledger account, resource code, cost, or standard text.';

                    trigger OnValidate()
                    begin
                        NoOnAfterValidate;
                    end;
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a code of a variant set up for the item on this line.';
                    Visible = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the description of an item, resource, cost, or a standard text on the line.';
                }
                field(Nonstock;Nonstock)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that the item is a nonstock item.';
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of one unit of measure of the item, resource time, or cost on this line.';
                }
                field("Description 2";"Description 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies an additional description of the item, resource, or cost.';
                    Visible = false;
                }
                field("Substitution Available";"Substitution Available")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Indicates whether a substitute is available for the item.';
                    Visible = false;
                }
                field("Work Type Code";"Work Type Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a code for the type of work performed by the resource registered on this line.';
                    Visible = false;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Indicates the inventory location from where the items on the line should be taken and where they should be registered.';
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    DecimalPlaces = 0:5;
                    ToolTip = 'Specifies the number of item units, resource hours, cost on the service line.';

                    trigger OnValidate()
                    begin
                        QuantityOnAfterValidate;
                    end;
                }
                field("Fault Reason Code";"Fault Reason Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the fault reason for this service line.';
                    Visible = false;
                }
                field("Fault Area Code";"Fault Area Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the fault area associated with this line.';
                    Visible = FaultAreaCodeVisible;
                }
                field("Symptom Code";"Symptom Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the symptom associated with this line.';
                    Visible = SymptomCodeVisible;
                }
                field("Fault Code";"Fault Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the fault associated with this line.';
                    Visible = FaultCodeVisible;
                }
                field("Resolution Code";"Resolution Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the resolution associated with this line.';
                    Visible = ResolutionCodeVisible;
                }
                field("Serv. Price Adjmt. Gr. Code";"Serv. Price Adjmt. Gr. Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the service price adjustment group code that applies to this line.';
                    Visible = false;
                }
                field("Unit Price";"Unit Price")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    ToolTip = 'Specifies the price per item unit, resource, or cost on the line.';
                }
                field("Line Discount %";"Line Discount %")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    ToolTip = 'Specifies the discount defined for a particular group, item, or combination of the two.';
                }
                field("Line Discount Amount";"Line Discount Amount")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    ToolTip = 'Specifies the amount of discount calculated for this line.';
                }
                field("Line Discount Type";"Line Discount Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of the line discount assigned to this line.';
                }
                field("Allow Invoice Disc.";"Allow Invoice Disc.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that the invoice discount will be calculated for the line.';
                    Visible = false;
                }
                field("Inv. Discount Amount";"Inv. Discount Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the invoice discount amount that is calculated on the line.';
                    Visible = false;
                }
                field("Line Amount";"Line Amount")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    ToolTip = 'Specifies the net amount (excluding the invoice discount amount) on the line, in the currency of the service document.';
                }
                field("Tax Liable";"Tax Liable")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field("Tax Area Code";"Tax Area Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Tax Group Code";"Tax Group Code")
                {
                    ApplicationArea = Basic;
                }
                field("Exclude Warranty";"Exclude Warranty")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that the warranty discount is excluded on this line.';
                }
                field("Exclude Contract Discount";"Exclude Contract Discount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that the contract discount is excluded for the item, resource, or cost on this line.';
                }
                field(Warranty;Warranty)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that a warranty discount is available on this line of type Item or Resource.';
                }
                field("Warranty Disc. %";"Warranty Disc. %")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    ToolTip = 'Specifies the percentage of the warranty discount that is valid for the items or resources on this line.';
                    Visible = false;
                }
                field("Contract No.";"Contract No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the number of the contract, if the service order originated from a service contract.';
                }
                field("Contract Disc. %";"Contract Disc. %")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    ToolTip = 'Specifies the contract discount percentage that is valid for the items, resources, and costs on this line.';
                    Visible = false;
                }
                field("VAT %";"VAT %")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    ToolTip = 'Specifies the Tax percentage used to calculate Amount Including Tax on this line.';
                    Visible = false;
                }
                field("VAT Base Amount";"VAT Base Amount")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    ToolTip = 'Specifies the amount that serves as a base for calculating Amount Including Tax.';
                    Visible = false;
                }
                field("Amount Including VAT";"Amount Including VAT")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the net amount, including Tax, for this line.';
                    Visible = false;
                }
                field("Unit Cost (LCY)";"Unit Cost (LCY)")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    ToolTip = 'Specifies the cost per item unit, resource, or cost on the line.';
                    Visible = false;
                }
                field("Gen. Bus. Posting Group";"Gen. Bus. Posting Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the customer general business posting group.';
                    Visible = false;
                }
                field("Gen. Prod. Posting Group";"Gen. Prod. Posting Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the general product posting group.';
                    Visible = false;
                }
                field("Posting Group";"Posting Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the inventory posting group assigned to the item.';
                    Visible = false;
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the service line should be posted.';
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the Shortcut Dimension 1, which is defined in the Shortcut Dimension 1 Code field in the General Ledger Setup window.';
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the Shortcut Dimension 2, which is specified in the Shortcut Dimension 2 Code field in the General Ledger Setup window.';
                    Visible = false;
                }
                field("ShortcutDimCode[3]";ShortcutDimCode[3])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,3';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(3),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(3,ShortcutDimCode[3]);
                    end;
                }
                field("ShortcutDimCode[4]";ShortcutDimCode[4])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,4';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(4),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(4,ShortcutDimCode[4]);
                    end;
                }
                field("ShortcutDimCode[5]";ShortcutDimCode[5])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,5';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(5),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(5,ShortcutDimCode[5]);
                    end;
                }
                field("ShortcutDimCode[6]";ShortcutDimCode[6])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,6';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(6),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(6,ShortcutDimCode[6]);
                    end;
                }
                field("ShortcutDimCode[7]";ShortcutDimCode[7])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,7';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(7),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(7,ShortcutDimCode[7]);
                    end;
                }
                field("ShortcutDimCode[8]";ShortcutDimCode[8])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,8';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(8),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(8,ShortcutDimCode[8]);
                    end;
                }
            }
        }
        area(factboxes)
        {
            part(Control1904739907;"Service Line FactBox")
            {
                SubPageLink = "Document Type"=field("Document Type"),
                              "Document No."=field("Document No."),
                              "Line No."=field("Line No.");
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
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension=R;
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                    trigger OnAction()
                    begin
                        ShowDimensions;
                        CurrPage.SaveRecord;
                    end;
                }
                separator(Action129)
                {
                    Caption = '';
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
                            ItemAvailFormsMgt.ShowItemAvailFromServLine(Rec,ItemAvailFormsMgt.ByEvent);
                        end;
                    }
                    action(Period)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Period';
                        Image = Period;

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromServLine(Rec,ItemAvailFormsMgt.ByPeriod);
                        end;
                    }
                    action(Variant)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Variant';
                        Image = ItemVariant;

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromServLine(Rec,ItemAvailFormsMgt.ByVariant);
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
                            ItemAvailFormsMgt.ShowItemAvailFromServLine(Rec,ItemAvailFormsMgt.ByLocation);
                        end;
                    }
                    action("BOM Level")
                    {
                        ApplicationArea = Basic;
                        Caption = 'BOM Level';
                        Image = BOMLevel;

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromServLine(Rec,ItemAvailFormsMgt.ByBOM);
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
                separator(Action130)
                {
                    Caption = '';
                }
                action("Select Item &Substitution")
                {
                    ApplicationArea = Basic;
                    Caption = 'Select Item &Substitution';
                    Image = SelectItemSubstitution;

                    trigger OnAction()
                    begin
                        ShowItemSub;
                        CurrPage.Update(true);
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
                action(CalculateInvoiceDiscount)
                {
                    ApplicationArea = Basic;
                    Caption = 'Calculate &Invoice Discount';
                    Image = CalculateInvoiceDiscount;

                    trigger OnAction()
                    begin
                        Codeunit.Run(Codeunit::"Service-Disc. (Yes/No)",Rec);
                    end;
                }
                action("Get Price")
                {
                    ApplicationArea = Basic;
                    Caption = 'Get Price';
                    Image = Price;

                    trigger OnAction()
                    begin
                        ShowPrices;
                        CurrPage.Update;
                    end;
                }
                action("Get Li&ne Discount")
                {
                    ApplicationArea = Basic;
                    Caption = 'Get Li&ne Discount';
                    Image = LineDiscount;

                    trigger OnAction()
                    begin
                        ShowLineDisc;
                        CurrPage.Update;
                    end;
                }
                separator(Action131)
                {
                }
                action("Insert &Ext. Text")
                {
                    AccessByPermission = TableData "Extended Text Header"=R;
                    ApplicationArea = Basic;
                    Caption = 'Insert &Ext. Text';
                    Image = Text;

                    trigger OnAction()
                    begin
                        InsertExtendedText(true);
                    end;
                }
                action("Insert &Starting Fee")
                {
                    ApplicationArea = Basic;
                    Caption = 'Insert &Starting Fee';
                    Image = InsertStartingFee;

                    trigger OnAction()
                    begin
                        InsertStartFee;
                    end;
                }
                action("Insert &Travel Fee")
                {
                    ApplicationArea = Basic;
                    Caption = 'Insert &Travel Fee';
                    Image = InsertTravelFee;

                    trigger OnAction()
                    begin
                        InsertTravelFee;
                    end;
                }
                action("Split &Resource Line")
                {
                    ApplicationArea = Basic;
                    Caption = 'Split &Resource Line';
                    Image = Split;

                    trigger OnAction()
                    begin
                        SplitResourceLine;
                    end;
                }
                action("Nonstoc&k Items")
                {
                    AccessByPermission = TableData "Nonstock Item"=R;
                    ApplicationArea = Basic;
                    Caption = 'Nonstoc&k Items';
                    Image = NonStockItem;

                    trigger OnAction()
                    begin
                        ShowNonstock;
                        CurrPage.Update;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        ShowShortcutDimCode(ShortcutDimCode);
    end;

    trigger OnDeleteRecord(): Boolean
    var
        ReserveServLine: Codeunit "Service Line-Reserve";
    begin
        if (Quantity <> 0) and ItemExists("No.") then begin
          Commit;
          if not ReserveServLine.DeleteLineConfirm(Rec) then
            exit(false);
          ReserveServLine.DeleteLine(Rec);
        end;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        "Line No." := GetNextLineNo(xRec,BelowxRec);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Clear(ShortcutDimCode);
        ServHeader.Get("Document Type","Document No.");
        if ServHeader."Link Service to Service Item" then
          if SelectionFilter <> Selectionfilter::"Lines Not Item Related" then
            Validate("Service Item Line No.",ServItemLineNo)
          else
            Validate("Service Item Line No.",0)
        else
          Validate("Service Item Line No.",0);
    end;

    trigger OnOpenPage()
    begin
        Clear(SelectionFilter);
        SetSelectionFilter;

        ServMgtSetup.Get;
        case ServMgtSetup."Fault Reporting Level" of
          ServMgtSetup."fault reporting level"::None:
            begin
              FaultAreaCodeVisible := false;
              SymptomCodeVisible := false;
              FaultCodeVisible := false;
              ResolutionCodeVisible := false;
            end;
          ServMgtSetup."fault reporting level"::Fault:
            begin
              FaultAreaCodeVisible := false;
              SymptomCodeVisible := false;
              FaultCodeVisible := true;
              ResolutionCodeVisible := true;
            end;
          ServMgtSetup."fault reporting level"::"Fault+Symptom":
            begin
              FaultAreaCodeVisible := false;
              SymptomCodeVisible := true;
              FaultCodeVisible := true;
              ResolutionCodeVisible := true;
            end;
          ServMgtSetup."fault reporting level"::"Fault+Symptom+Area (IRIS)":
            begin
              FaultAreaCodeVisible := true;
              SymptomCodeVisible := true;
              FaultCodeVisible := true;
              ResolutionCodeVisible := true;
            end;
        end;
    end;

    var
        ServMgtSetup: Record "Service Mgt. Setup";
        ServHeader: Record "Service Header";
        SalesPriceCalcMgt: Codeunit "Sales Price Calc. Mgt.";
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
        ShortcutDimCode: array [8] of Code[20];
        ServItemLineNo: Integer;
        SelectionFilter: Option "All Service Lines","Lines per Selected Service Item","Lines Not Item Related";
        [InDataSet]
        FaultAreaCodeVisible: Boolean;
        [InDataSet]
        SymptomCodeVisible: Boolean;
        [InDataSet]
        FaultCodeVisible: Boolean;
        [InDataSet]
        ResolutionCodeVisible: Boolean;


    procedure Initialize(ServItemLine: Integer)
    begin
        ServItemLineNo := ServItemLine;
    end;


    procedure SetSelectionFilter()
    begin
        case SelectionFilter of
          Selectionfilter::"All Service Lines":
            SetRange("Service Item Line No.");
          Selectionfilter::"Lines per Selected Service Item":
            SetRange("Service Item Line No.",ServItemLineNo);
          Selectionfilter::"Lines Not Item Related":
            SetRange("Service Item Line No.",0);
        end;
        CurrPage.Update(false);
    end;

    local procedure InsertExtendedText(Unconditionally: Boolean)
    var
        TransferExtendedText: Codeunit "Transfer Extended Text";
    begin
        if TransferExtendedText.ServCheckIfAnyExtText(Rec,Unconditionally) then begin
          CurrPage.SaveRecord;
          TransferExtendedText.InsertServExtText(Rec);
        end;
        if TransferExtendedText.MakeUpdate then
          CurrPage.Update;
    end;

    local procedure InsertStartFee()
    var
        ServOrderMgt: Codeunit ServOrderManagement;
    begin
        Clear(ServOrderMgt);
        if ServOrderMgt.InsertServCost(Rec,1,false) then
          CurrPage.Update;
    end;

    local procedure InsertTravelFee()
    var
        ServOrderMgt: Codeunit ServOrderManagement;
    begin
        Clear(ServOrderMgt);
        if ServOrderMgt.InsertServCost(Rec,0,false) then
          CurrPage.Update;
    end;

    local procedure ShowPrices()
    begin
        ServHeader.Get("Document Type","Document No.");
        Clear(SalesPriceCalcMgt);
        SalesPriceCalcMgt.GetServLinePrice(ServHeader,Rec);
    end;

    local procedure ShowLineDisc()
    begin
        ServHeader.Get("Document Type","Document No.");
        Clear(SalesPriceCalcMgt);
        SalesPriceCalcMgt.GetServLineLineDisc(ServHeader,Rec);
    end;

    local procedure NoOnAfterValidate()
    begin
        InsertExtendedText(false);
    end;

    local procedure QuantityOnAfterValidate()
    begin
        if Reserve = Reserve::Always then begin
          CurrPage.SaveRecord;
          AutoReserve(true);
        end;
    end;

    local procedure SelectionFilterOnAfterValidate()
    begin
        CurrPage.Update;
        SetSelectionFilter;
    end;
}

