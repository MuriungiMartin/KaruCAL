#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1344 "Vendor Template Card"
{
    Caption = 'Vendor Template';
    CardPageID = "Vendor Template Card";
    DataCaptionExpression = "Template Name";
    PageType = Card;
    PromotedActionCategories = 'New,Process,Reports,Master Data';
    RefreshOnActivate = true;
    SourceTable = "Mini Vendor Template";
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
            group(AddressDetails)
            {
                Caption = 'Address Details';
                field("Post Code";"Post Code")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Promoted;
                    ToolTip = 'Specifies the ZIP code.';
                }
                field(City;City)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the vendor''s city.';
                }
                field("Country/Region Code";"Country/Region Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the country/region of the address.';
                }
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                group(PostingDetails)
                {
                    Caption = 'Posting Details';
                    field("Gen. Bus. Posting Group";"Gen. Bus. Posting Group")
                    {
                        ApplicationArea = Basic,Suite;
                        Importance = Promoted;
                        ToolTip = 'Specifies the vendor''s trade type to link transactions made for this vendor with the appropriate general ledger account according to the general posting setup.';
                    }
                    field("VAT Bus. Posting Group";"VAT Bus. Posting Group")
                    {
                        ApplicationArea = Basic,Suite;
                        ToolTip = 'Specifies the vendor''s tax specification to link transactions made for this vendor with the appropriate general ledger account according to the tax posting setup.';
                    }
                    field("Vendor Posting Group";"Vendor Posting Group")
                    {
                        ApplicationArea = Basic,Suite;
                        Importance = Promoted;
                        ToolTip = 'Specifies the vendor''s market type to link business transactions made for the vendor with the appropriate account in the general ledger.';
                    }
                    field("Invoice Disc. Code";"Invoice Disc. Code")
                    {
                        ApplicationArea = Basic,Suite;
                        Importance = Promoted;
                        ToolTip = 'Specifies the vendor''s invoice discount code. When you set up a new vendor card, the number you have entered in the No. field is automatically inserted.';
                    }
                    field("Prices Including VAT";"Prices Including VAT")
                    {
                        ApplicationArea = Basic,Suite;
                        ToolTip = 'Specifies if the Direct Unit Cost and Line Amount fields on the purchase lines and in purchase reports should be shown with or without tax.';
                    }
                    field("Tax Liable";"Tax Liable")
                    {
                        ApplicationArea = Basic,Suite;
                        ToolTip = 'Specifies if the vendor is liable for sales tax.';
                    }
                }
                group(ForeignTrade)
                {
                    Caption = 'Foreign Trade';
                    field("Currency Code";"Currency Code")
                    {
                        ApplicationArea = Suite;
                        Importance = Promoted;
                        ToolTip = 'Specifies a default currency code for the vendor.';
                    }
                    field("Language Code";"Language Code")
                    {
                        ApplicationArea = Basic,Suite;
                        ToolTip = 'Specifies the language on printouts for this vendor.';
                    }
                }
            }
            group(Payments)
            {
                Caption = 'Payments';
                field("Application Method";"Application Method")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies how to apply payments to entries for this vendor.';
                }
                field("Payment Terms Code";"Payment Terms Code")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Promoted;
                    ToolTip = 'Specifies a code that indicates the payment terms that the vendor usually requires.';
                }
                field("Payment Method Code";"Payment Method Code")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Promoted;
                    ToolTip = 'Specifies how the vendor requires you to submit payment, such as bank transfer or check.';
                }
                field("Fin. Charge Terms Code";"Fin. Charge Terms Code")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies how the vendor calculates finance charges.';
                }
                field("Block Payment Tolerance";"Block Payment Tolerance")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies if the vendor allows payment tolerance.';
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
                    RunPageLink = "Table Id"=const(18),
                                  "Master Record Template Code"=field(Code);
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edits dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        SetDimensionsEnabled;
        SetTemplateEnabled;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        CheckTemplateNameProvided
    end;

    trigger OnOpenPage()
    begin
        if Vendor."No." <> '' then
          CreateConfigTemplateFromExistingVendor(Vendor,Rec);
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
        Vendor: Record Vendor;
        [InDataSet]
        DimensionsEnabled: Boolean;
        ProvideTemplateNameErr: label 'You must enter a %1.', Comment='%1 Template Name';
        TemplateEnabled: Boolean;

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


    procedure CreateFromVend(FromVendor: Record Vendor)
    begin
        Vendor := FromVendor;
    end;
}

