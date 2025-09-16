#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1650 "Curr. Exch. Rate Service List"
{
    ApplicationArea = Basic;
    Caption = 'Currency Exchange Rate Services';
    CardPageID = "Curr. Exch. Rate Service Card";
    Editable = false;
    ModifyAllowed = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Setup';
    SourceTable = "Curr. Exch. Rate Update Setup";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                Caption = 'General';
                field("Code";Code)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the setup of a service to update currency exchange rates.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the setup of a service to update currency exchange rates.';
                }
                field(Enabled;Enabled)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies if the currency exchange rate service is enabled. Only one service can be enabled at a time.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Enable)
            {
                ApplicationArea = Suite;
                Caption = 'Enable';
                Image = Default;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Enable a service for keeping your for currency exchange rates up to date. You can then change the job that controls how often exchange rates are updated.';

                trigger OnAction()
                begin
                    Validate(Enabled,true);
                    Modify(true);
                end;
            }
            action(TestUpdate)
            {
                ApplicationArea = Suite;
                Caption = 'Preview';
                Image = ReviewWorksheet;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ToolTip = 'Test the setup of the currency exchange rate service to make sure the service is working.';

                trigger OnAction()
                var
                    TempCurrencyExchangeRate: Record "Currency Exchange Rate" temporary;
                    UpdateCurrencyExchangeRates: Codeunit "Update Currency Exchange Rates";
                begin
                    UpdateCurrencyExchangeRates.GenerateTempDataFromService(TempCurrencyExchangeRate,Rec);
                    Page.Run(Page::"Currency Exchange Rates",TempCurrencyExchangeRate);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        if IsEmpty then
          Codeunit.Run(Codeunit::"Set Up Curr Exch Rate Service");
    end;
}

