#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5381 "CRM Sales Order Subform"
{
    Caption = 'Lines';
    Editable = false;
    PageType = ListPart;
    SourceTable = "CRM Salesorderdetail";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                FreezeColumn = ProductIdName;
                field(ProductIdName;ProductIdName)
                {
                    ApplicationArea = Suite;
                    Caption = 'Product Id';
                    Editable = false;

                    trigger OnDrillDown()
                    var
                        CRMProduct: Record "CRM Product";
                    begin
                        CRMProduct.SetRange(StateCode,CRMProduct.Statecode::Active);
                        Page.Run(Page::"CRM Product List",CRMProduct);
                    end;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Suite;
                    Caption = 'Quantity';
                    ToolTip = 'Specifies the quantity of the item on the sales line.';
                }
                field(UoMIdName;UoMIdName)
                {
                    ApplicationArea = Suite;
                    Caption = 'Unit of Measure';
                    Editable = false;
                    ToolTip = 'Specifies the unit in which the item is held in inventory.';

                    trigger OnDrillDown()
                    var
                        CRMUomschedule: Record "CRM Uomschedule";
                    begin
                        CRMUomschedule.SetRange(StateCode,CRMUomschedule.Statecode::Active);
                        Page.Run(Page::"CRM UnitGroup List",CRMUomschedule);
                    end;
                }
                field(PricePerUnit;PricePerUnit)
                {
                    ApplicationArea = Suite;
                    Caption = 'Price Per Unit';
                }
                field(BaseAmount;BaseAmount)
                {
                    ApplicationArea = Suite;
                    Caption = 'Amount';
                    ToolTip = 'Specifies the net amount of all the lines.';
                }
                field(ExtendedAmount;ExtendedAmount)
                {
                    ApplicationArea = Suite;
                    Caption = 'Extended Amount';
                    ToolTip = 'Specifies the sales amount without rounding.';
                }
                field(VolumeDiscountAmount;VolumeDiscountAmount)
                {
                    ApplicationArea = Suite;
                    Caption = 'Volume Discount';
                }
                field(ManualDiscountAmount;ManualDiscountAmount)
                {
                    ApplicationArea = Suite;
                    Caption = 'Manual Discount';
                    ToolTip = 'Specifies that the sales order is subject to manual discount.';
                }
                field(Tax;Tax)
                {
                    ApplicationArea = Suite;
                    Caption = 'Tax';
                }
                field(CreatedOn;CreatedOn)
                {
                    ApplicationArea = Suite;
                    Caption = 'Created On';
                    ToolTip = 'Specifies when the sales order was created.';
                }
                field(ModifiedOn;ModifiedOn)
                {
                    ApplicationArea = Suite;
                    Caption = 'Modified On';
                    ToolTip = 'Specifies when the sales order was last modified.';
                }
                field(SalesRepIdName;SalesRepIdName)
                {
                    ApplicationArea = Suite;
                    Caption = 'Sales Rep';
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        Page.Run(Page::"CRM Systemuser List");
                    end;
                }
                field(TransactionCurrencyIdName;TransactionCurrencyIdName)
                {
                    ApplicationArea = Suite;
                    Caption = 'Currency';
                    Editable = false;
                    ToolTip = 'Specifies the currency that amounts are shown in.';

                    trigger OnDrillDown()
                    var
                        CRMTransactioncurrency: Record "CRM Transactioncurrency";
                    begin
                        CRMTransactioncurrency.SetRange(StateCode,CRMTransactioncurrency.Statecode::Active);
                        Page.Run(Page::"CRM TransactionCurrency List",CRMTransactioncurrency);
                    end;
                }
                field(ExchangeRate;ExchangeRate)
                {
                    ApplicationArea = Suite;
                    Caption = 'Exchange Rate';
                    ToolTip = 'Specifies the currency exchange rate.';
                }
                field(QuantityShipped;QuantityShipped)
                {
                    ApplicationArea = Suite;
                    Caption = 'Quantity Shipped';
                }
                field(QuantityBackordered;QuantityBackordered)
                {
                    ApplicationArea = Suite;
                    Caption = 'Quantity Back Ordered';
                }
                field(QuantityCancelled;QuantityCancelled)
                {
                    ApplicationArea = Suite;
                    Caption = 'Quantity Canceled';
                }
                field(ProductDescription;ProductDescription)
                {
                    ApplicationArea = Suite;
                    Caption = 'Write-In Product';
                    Importance = Additional;
                    ToolTip = 'Specifies if the item is a write-in product.';
                }
                field(ShipTo_Name;ShipTo_Name)
                {
                    ApplicationArea = Suite;
                    Caption = 'Ship To Name';
                    Visible = false;
                }
                field(ShipTo_Line1;ShipTo_Line1)
                {
                    ApplicationArea = Suite;
                    Caption = 'Ship To Street 1';
                    Importance = Additional;
                    Visible = false;
                }
                field(ShipTo_Line2;ShipTo_Line2)
                {
                    ApplicationArea = Suite;
                    Caption = 'Ship To Street 2';
                    Importance = Additional;
                    Visible = false;
                }
                field(ShipTo_Line3;ShipTo_Line3)
                {
                    ApplicationArea = Suite;
                    Caption = 'Ship To Street 3';
                    Importance = Additional;
                    Visible = false;
                }
                field(ShipTo_City;ShipTo_City)
                {
                    ApplicationArea = Suite;
                    Caption = 'Ship To City';
                    Importance = Additional;
                    Visible = false;
                }
                field(ShipTo_StateOrProvince;ShipTo_StateOrProvince)
                {
                    ApplicationArea = Suite;
                    Caption = 'Ship To State/Province';
                    Importance = Additional;
                    Visible = false;
                }
                field(ShipTo_Country;ShipTo_Country)
                {
                    ApplicationArea = Suite;
                    Caption = 'Ship To Country/Region';
                    Importance = Additional;
                    ToolTip = 'Specifies the country/region of the address.';
                    Visible = false;
                }
                field(ShipTo_PostalCode;ShipTo_PostalCode)
                {
                    ApplicationArea = Suite;
                    Caption = 'Ship To ZIP/Postal Code';
                    Importance = Additional;
                    Visible = false;
                }
                field(WillCall;WillCall)
                {
                    ApplicationArea = Suite;
                    Caption = 'Ship To';
                    Importance = Additional;
                    Visible = false;
                }
                field(ShipTo_Telephone;ShipTo_Telephone)
                {
                    ApplicationArea = Suite;
                    Caption = 'Ship To Phone';
                    Visible = false;
                }
                field(ShipTo_Fax;ShipTo_Fax)
                {
                    ApplicationArea = Suite;
                    Caption = 'Ship To Fax';
                    Importance = Additional;
                    Visible = false;
                }
                field(ShipTo_FreightTermsCode;ShipTo_FreightTermsCode)
                {
                    ApplicationArea = Suite;
                    Caption = 'Freight Terms';
                    Importance = Additional;
                    ToolTip = 'Specifies the shipment method.';
                    Visible = false;
                }
                field(ShipTo_ContactName;ShipTo_ContactName)
                {
                    ApplicationArea = Suite;
                    Caption = 'Ship To Contact Name';
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }
}

