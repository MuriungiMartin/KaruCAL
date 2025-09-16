#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 424 "Customer Bank Account List"
{
    Caption = 'Customer Bank Account List';
    CardPageID = "Customer Bank Account Card";
    DataCaptionFields = "Customer No.";
    Editable = false;
    PageType = List;
    SourceTable = "Customer Bank Account";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a code to identify this customer bank account.';
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the name of the bank where the customer has the bank account.';
                }
                field("Post Code";"Post Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ZIP code of the address.';
                    Visible = false;
                }
                field("Country/Region Code";"Country/Region Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the country/region code of the address.';
                    Visible = false;
                }
                field("Phone No.";"Phone No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the telephone number of the bank where the customer has the bank account.';
                }
                field("Fax No.";"Fax No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the fax number associated with the address.';
                    Visible = false;
                }
                field(Contact;Contact)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the name of the bank employee regularly contacted in connection with this bank account.';
                }
                field("Bank Account No.";"Bank Account No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number used by the bank for the bank account.';
                    Visible = false;
                }
                field("SWIFT Code";"SWIFT Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the SWIFT code (international bank identifier code) of the bank where the customer has the account.';
                    Visible = false;
                }
                field(Iban;Iban)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the bank account''s international bank account number.';
                    Visible = false;
                }
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the relevant currency code for the bank account.';
                    Visible = false;
                }
                field("Language Code";"Language Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a code that determines the language associated with this bank account.';
                    Visible = false;
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
            action("Direct Debit Mandates")
            {
                ApplicationArea = Basic;
                Caption = 'Direct Debit Mandates';
                Image = MakeAgreement;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "SEPA Direct Debit Mandates";
                RunPageLink = "Customer No."=field("Customer No."),
                              "Customer Bank Account Code"=field(Code);
                Scope = Repeater;
                ToolTip = 'View or edit direct-debit mandates that you set up to reflect agreements with customers to collect invoice payments from their bank account.';
            }
        }
    }
}

