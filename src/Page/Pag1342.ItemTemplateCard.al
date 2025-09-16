#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1342 "Item Template Card"
{
    Caption = 'Item Template';
    CardPageID = "Item Template Card";
    DataCaptionExpression = "Template Name";
    PageType = Card;
    PromotedActionCategories = 'New,Process,Reports,Master Data';
    SourceTable = "Item Template";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Template Name";"Template Name")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the name of the template.';

                    trigger OnValidate()
                    begin
                        SetDimensionsEnabled;
                    end;
                }
                field(TemplateEnabled;TemplateEnabled)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Enabled';
                    ToolTip = 'Specifies if the template is ready to be used';

                    trigger OnValidate()
                    var
                        ConfigTemplateHeader: Record "Config. Template Header";
                    begin
                        if ConfigTemplateHeader.Get(Code) then
                          ConfigTemplateHeader.SetTemplateEnabled(TemplateEnabled);
                    end;
                }
            }
            group("Item Setup")
            {
                Caption = 'Item Setup';
                field("Base Unit of Measure";"Base Unit of Measure")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the unit in which the item is held in inventory. The base unit of measure also serves as the conversion basis for alternate units of measure.';
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies if the item card represents a physical item (Inventory) or a service (Service).';

                    trigger OnValidate()
                    begin
                        SetInventoryPostingGroupEditable;
                    end;
                }
                field("Automatic Ext. Texts";"Automatic Ext. Texts")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies that an extended text will be added on sales or purchase documents for this item.';
                }
            }
            group(Price)
            {
                Caption = 'Price';
                field("Price Includes VAT";"Price Includes VAT")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies if the Unit Price and Line Amount fields on sales document lines for this item should be shown with or without tax.';
                }
                field("Price/Profit Calculation";"Price/Profit Calculation")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies if the Profit Percentage field, the Unit Price field, or neither field is calculated and filled.';
                }
                field("Profit %";"Profit %")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the profit you have made from the customer in the current fiscal year, as a percentage of the customer''s total sales.';
                }
                field("Allow Invoice Disc.";"Allow Invoice Disc.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies if the item should be included in the calculation of an invoice discount on documents where the item is traded.';
                }
                field("Item Disc. Group";"Item Disc. Group")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies an item group code that can be used as a criterion to grant a discount when the item is sold to a certain customer.';
                }
            }
            group(Cost)
            {
                Caption = 'Cost';
                field("Costing Method";"Costing Method")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies links between business transactions made for this item and the general ledger, to account for Tax amounts that result from trade with the item.';
                }
                field("Indirect Cost %";"Indirect Cost %")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the percentage of the item''s last purchase cost that includes indirect costs, such as freight that is associated with the purchase of the item.';
                }
            }
            group("Financial Details")
            {
                Caption = 'Financial Details';
                field("Gen. Prod. Posting Group";"Gen. Prod. Posting Group")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies links between business transactions made for this item and the general ledger, to account for the value of trade with the item.';
                }
                field("VAT Prod. Posting Group";"VAT Prod. Posting Group")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies links between business transactions made for this item and the general ledger, to account for Tax amounts that result from trade.';
                }
                field("Inventory Posting Group";"Inventory Posting Group")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = InventoryPostingGroupEditable;
                    ToolTip = 'Specifies links between business transactions made for the item and an inventory account in the general ledger, to group amounts for that item type.';
                }
                field("Tax Group Code";"Tax Group Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the tax group code for the tax-detail entry.';
                }
            }
            group(Categorization)
            {
                Caption = 'Categorization';
                field("Item Category Code";"Item Category Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the category that the item belongs to.';
                }
                field("Service Item Group";"Service Item Group")
                {
                    ApplicationArea = Basic;
                }
                field("Warehouse Class Code";"Warehouse Class Code")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("Master Data")
            {
                Caption = 'Master Data';
                action("Default Dimensions")
                {
                    ApplicationArea = Suite;
                    Caption = 'Dimensions';
                    Enabled = DimensionsEnabled;
                    Image = Dimensions;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    RunObject = Page "Dimensions Template List";
                    RunPageLink = "Table Id"=const(27),
                                  "Master Record Template Code"=field(Code);
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edits dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        SetInventoryPostingGroupEditable;
        SetDimensionsEnabled;
        SetTemplateEnabled;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        CheckTemplateNameProvided
    end;

    trigger OnOpenPage()
    begin
        if Item."No." <> '' then
          CreateConfigTemplateFromExistingItem(Item,Rec);
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        case CloseAction of
          Action::LookupOK:
            if Code <> '' then
              CheckTemplateNameProvided;
          Action::LookupCancel:
            if Delete(true) then;
        end;
    end;

    var
        Item: Record Item;
        [InDataSet]
        InventoryPostingGroupEditable: Boolean;
        [InDataSet]
        DimensionsEnabled: Boolean;
        ProvideTemplateNameErr: label 'You must enter a %1.', Comment='%1 Template Name';
        TemplateEnabled: Boolean;


    procedure SetInventoryPostingGroupEditable()
    begin
        InventoryPostingGroupEditable := Type = Type::Inventory;
    end;

    local procedure SetDimensionsEnabled()
    begin
        DimensionsEnabled := "Template Name" <> '';
    end;

    local procedure SetTemplateEnabled()
    var
        ConfigTemplateHeader: Record "Config. Template Header";
    begin
        TemplateEnabled := ConfigTemplateHeader.Get(Code) and ConfigTemplateHeader.Enabled;
    end;

    local procedure CheckTemplateNameProvided()
    begin
        if "Template Name" = '' then
          Error(StrSubstNo(ProvideTemplateNameErr,FieldCaption("Template Name")));
    end;


    procedure CreateFromItem(FromItem: Record Item)
    begin
        Item := FromItem;
    end;
}

