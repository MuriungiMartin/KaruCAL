#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9194 "Madeira Rebranding Dialog"
{
    Caption = 'Thanks!';
    PageType = NavigatePage;

    layout
    {
        area(content)
        {
            group("Welcome to Dynamics 365 for Financials")
            {
                Caption = 'Welcome to Dynamics 365 for Financials';
                InstructionalText = 'Thanks for evaluating Dynamics 365 for Financials. We hope you''ve enjoyed the experience and want to continue to use the service to manage your business.';
            }
            group(Control7)
            {
                InstructionalText = 'This message is to inform you that Project "Madeira" has been rebranded, and is now called Dynamics 365 for Financials. The terms and conditions have also been updated.';
            }
            group(Control6)
            {
                InstructionalText = 'You are now running in a free 30-day trial period. To continue to use this company after the trial period expires, you will need to purchase Dynamics 365 for Financials.';
                Visible = ProductionCompanyOpened;
            }
            group(Control2)
            {
                InstructionalText = 'To get going, read and accept the Terms & Conditions, and then choose Close.';
            }
            field(LinkLbl;LinkLbl)
            {
                ApplicationArea = Basic,Suite;
                Editable = false;
                ExtendedDatatype = URL;
                MultiLine = false;
                ShowCaption = false;

                trigger OnDrillDown()
                begin
                    Hyperlink(UrlTxt);
                end;
            }
            field(TermsAndConditionsCheckBox;TermsAndConditionsAccepted)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'I accept the Terms & Conditions';
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(ActionOK)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Close';
                Enabled = TermsAndConditionsAccepted;
                InFooterBar = true;
                //The property 'ToolTip' cannot be empty.
                //ToolTip = '';

                trigger OnAction()
                begin
                    CurrPage.Close;
                end;
            }
        }
    }

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        if not TermsAndConditionsAccepted then
          Error(DialogNotConfirmedErr);
    end;

    var
        LinkLbl: label 'Terms & Conditions';
        UrlTxt: label 'http://go.microsoft.com/fwlink/?LinkId=828977', Comment='{locked}';
        ProductionCompanyOpened: Boolean;
        TermsAndConditionsAccepted: Boolean;
        DialogNotConfirmedErr: label 'To continue, confirm you’re aware that Project “Madeira” is now named Microsoft Dynamics 365 for Financials, and that the terms and conditions have changed.';


    procedure SetProductionCompanyOpened(ProductionCompany: Boolean)
    begin
        ProductionCompanyOpened := ProductionCompany;
    end;
}

