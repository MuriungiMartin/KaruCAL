#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 2107 "O365 Sales Customer Card"
{
    Caption = 'Customer';
    PageType = Card;
    PromotedActionCategories = 'New,Process,Report,Details';
    SourceTable = Customer;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(Name;Name)
                {
                    ApplicationArea = Basic,Suite;
                    ShowMandatory = true;
                }
                field("E-Mail";"E-Mail")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Promoted;
                    ToolTip = 'Specifies the customer''s email address.';
                }
                field("Phone No.";"Phone No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the customer''s telephone number.';
                }
                field("Balance (LCY)";"Balance (LCY)")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Balance';
                    DrillDown = false;
                    Importance = Additional;
                    Lookup = false;
                }
                field("Balance Due (LCY)";"Balance Due (LCY)")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Balance Due';
                    DrillDown = false;
                    Importance = Additional;
                    Lookup = false;
                    ToolTip = 'Specifies payments from the customer that are overdue per today''s date.';
                }
                field("Sales (LCY)";"Sales (LCY)")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Sales';
                    DrillDown = false;
                    Importance = Additional;
                    Lookup = false;
                    ToolTip = 'Specifies the total net amount of sales to the customer in $.';
                }
            }
            group("Address & Contact")
            {
                Caption = 'Address & Contact';
                group(AddressDetails)
                {
                    Caption = 'Address';
                    field(Address;Address)
                    {
                        ApplicationArea = Basic,Suite;
                        ToolTip = 'Specifies the customer''s address. This address will appear on all sales documents for the customer.';
                    }
                    field("Post Code";"Post Code")
                    {
                        ApplicationArea = Basic,Suite;
                        Importance = Promoted;
                        ToolTip = 'Specifies the ZIP Code.';
                    }
                    field(City;City)
                    {
                        ApplicationArea = Basic,Suite;
                        ToolTip = 'Specifies the customer''s city.';
                    }
                    field("Country/Region Code";"Country/Region Code")
                    {
                        ApplicationArea = Basic,Suite;
                        ToolTip = 'Specifies the country/region of the address.';
                    }
                    field(ShowMap;ShowMapLbl)
                    {
                        ApplicationArea = Basic,Suite;
                        Editable = false;
                        ShowCaption = false;
                        Style = StrongAccent;
                        StyleExpr = true;
                        ToolTip = 'Specifies the customer''s address on your preferred map website.';

                        trigger OnDrillDown()
                        begin
                            CurrPage.Update(true);
                            DisplayMap;
                        end;
                    }
                }
            }
            group("Tax Information")
            {
                Caption = 'Tax Information';
                field("Tax Liable";"Tax Liable")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Tax Area Code";"Tax Area Code")
                {
                    ApplicationArea = Basic,Suite;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(NewSalesInvoice)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'New Invoice';
                Image = NewSalesInvoice;
                Promoted = true;
                PromotedIsBig = true;
                RunPageMode = Create;
                Scope = Repeater;
                ToolTip = 'Create a new invoice for the customer.';

                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                begin
                    SalesHeader.Init;
                    SalesHeader.Validate("Document Type",SalesHeader."document type"::Invoice);
                    SalesHeader.Validate("Sell-to Customer No.","No.");
                    SalesHeader.Insert(true);
                    Commit;

                    Page.Run(Page::"O365 Sales Invoice",SalesHeader);
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        MiniCustomerTemplate: Record "Mini Customer Template";
        Customer: Record Customer;
        DocumentNoVisibility: Codeunit DocumentNoVisibility;
    begin
        if GuiAllowed then begin
          if "No." = '' then begin
            if not DocumentNoVisibility.CustomerNoSeriesIsDefault then
              exit;

            if not MiniCustomerTemplate.NewCustomerFromTemplate(Customer) then begin
              CurrPage.Close;
              exit;
            end;
          end;
          CurrPage.Close;
          Page.Run(Page::"O365 Sales Customer Card",Customer);
        end;
    end;

    var
        ShowMapLbl: label 'Show on Map';
}

