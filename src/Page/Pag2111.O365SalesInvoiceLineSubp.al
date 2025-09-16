#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 2111 "O365 Sales Invoice Line Subp."
{
    Caption = 'Invoice Line';
    PageType = ListPart;
    SourceTable = "Sales Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number of the record.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field(LocalDescription;LocalDescription)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Description';
                    Editable = CurrPageEditable;
                    Importance = Promoted;
                    Lookup = true;
                    ShowMandatory = true;
                    Visible = CardOpen;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupDescription(Text);
                    end;

                    trigger OnValidate()
                    begin
                        SetHideValidationDialog(true);
                        Validate(Description,LocalDescription);

                        if IsLookupRequested then begin
                          if not LookupDescription(LocalDescription) then
                            Error('');
                        end else
                          LocalDescription := Description;

                        RedistributeTotalsOnAfterValidate;
                        if LocalDescription <> '' then
                          DescriptionSelected := true;
                    end;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a description of the item or service on the line.';
                    Visible = not CardOpen;

                    trigger OnValidate()
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Unit of Measure";"Unit of Measure")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = DescriptionSelected;
                    ToolTip = 'Specifies the unit of measure code for the item.';

                    trigger OnValidate()
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic,Suite;
                    Editable = DescriptionSelected;

                    trigger OnValidate()
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Unit Price";"Unit Price")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = DescriptionSelected;
                    ToolTip = 'Specifies the price for one unit on the sales line.';

                    trigger OnValidate()
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Tax Group Code";"Tax Group Code")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = DescriptionSelected;
                    Importance = Additional;
                    ToolTip = 'Specifies the tax group code for the tax-detail entry.';

                    trigger OnValidate()
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field(TaxRate;TaxRate)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Tax %';
                    DecimalPlaces = 0:3;
                    Editable = CurrPageEditable and DescriptionSelected;
                    MinValue = 0;
                    ToolTip = 'Specifies the Tax % that was used on the sales or purchase lines with this Tax Identifier.';

                    trigger OnValidate()
                    var
                        TaxDetail: Record "Tax Detail";
                    begin
                        TaxDetail.SetSalesTaxRate("Tax Area Code","Tax Group Code",TaxRate);
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic,Suite;
                    Editable = DescriptionSelected;
                    ToolTip = 'Specifies the sum of amounts in the Line Amount field on the sales lines. It is used to calculate the invoice discount of the sales document.';
                }
                field("Amount Including VAT";"Amount Including VAT")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = DescriptionSelected;
                    ToolTip = 'Specifies the total of the amounts in all the amount fields on the invoice, in the currency of the invoice. The amount includes Tax.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
        CalculateTotals;
        CurrPageEditable := CurrPage.Editable;

        DescriptionSelected := Description <> '';
    end;

    trigger OnAfterGetRecord()
    var
        TaxDetail: Record "Tax Detail";
    begin
        TaxRate := TaxDetail.GetSalesTaxRate("Tax Area Code","Tax Group Code");
        LocalDescription := Description;
    end;

    trigger OnClosePage()
    begin
        CardOpen := false;
    end;

    trigger OnInit()
    begin
        SalesSetup.Get;
        Currency.InitRoundingPrecision;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        SalesLine: Record "Sales Line";
    begin
        Type := Type::Item;
        SalesLine.SetRange("Document Type","Document Type");
        SalesLine.SetRange("Document No.","Document No.");
        if SalesLine.FindLast then;
        "Line No." := SalesLine."Line No." + 10000;
        LocalDescription := '';
        TaxRate := 0;
    end;

    trigger OnOpenPage()
    begin
        CardOpen := true;
    end;

    var
        Currency: Record Currency;
        SalesSetup: Record "Sales & Receivables Setup";
        TotalSalesHeader: Record "Sales Header";
        TotalSalesLine: Record "Sales Line";
        DocumentTotals: Codeunit "Document Totals";
        LocalDescription: Text[50];
        VATAmount: Decimal;
        TaxRate: Decimal;
        CardOpen: Boolean;
        CurrPageEditable: Boolean;
        DescriptionSelected: Boolean;

    local procedure CalculateTotals()
    begin
        GetTotalSalesHeader;
        if SalesSetup."Calc. Inv. Discount" and ("Document No." <> '') and (TotalSalesHeader."Customer Posting Group" <> '') then
          Codeunit.Run(Codeunit::"Sales-Calc. Discount",Rec);

        DocumentTotals.CalculateSalesTotals(TotalSalesLine,VATAmount,Rec);
    end;

    local procedure RedistributeTotalsOnAfterValidate()
    begin
        CurrPage.SaveRecord;

        TotalSalesHeader.Get("Document Type","Document No.");
        DocumentTotals.SalesRedistributeInvoiceDiscountAmounts(Rec,VATAmount,TotalSalesLine);
        CurrPage.Update;
    end;

    local procedure GetTotalSalesHeader()
    begin
        if not TotalSalesHeader.Get("Document Type","Document No.") then
          Clear(TotalSalesHeader);
        if Currency.Code <> TotalSalesHeader."Currency Code" then
          if not Currency.Get(TotalSalesHeader."Currency Code") then
            Currency.InitRoundingPrecision;
    end;

    local procedure LookupDescription(Text: Text): Boolean
    var
        Item: Record Item;
        O365SalesItemLookup: Page "O365 Sales Item Lookup";
    begin
        if Text <> '' then begin
          Item.SetRange(Description,Text);
          if Item.FindFirst then;
          Item.SetRange(Description);
        end;

        O365SalesItemLookup.LookupMode(true);
        O365SalesItemLookup.SetRecord(Item);

        if O365SalesItemLookup.RunModal = Action::LookupOK then begin
          O365SalesItemLookup.GetRecord(Item);
          SetHideValidationDialog(true);
          LocalDescription := Item.Description;
          Validate(Description,LocalDescription);
          if LocalDescription <> '' then
            DescriptionSelected := true;
          exit(true);
        end;

        exit(false);
    end;
}

