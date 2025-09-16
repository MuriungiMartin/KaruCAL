#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 425 "Vendor Bank Account Card"
{
    Caption = 'Vendor Bank Account Card';
    PageType = Card;
    SourceTable = "Vendor Bank Account";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Code";Code)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a code to identify this vendor bank account.';
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the name of the bank where the vendor has this bank account.';
                }
                field(Address;Address)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the address of the bank where the vendor has the bank account.';
                }
                field("Address 2";"Address 2")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies additional address information.';
                }
                field(City;City)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the city of the bank where the vendor has the bank account.';
                }
                field(County;County)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'State';
                    ToolTip = 'Specifies the state as a part of the address.';
                }
                field("Post Code";"Post Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the ZIP code.';
                }
                field("Country/Region Code";"Country/Region Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the country/region of the address.';
                }
                field("Phone No.";"Phone No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the telephone number of the bank where the vendor has the bank account.';
                }
                field(Contact;Contact)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the name of the bank employee regularly contacted in connection with this bank account.';
                }
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the relevant currency code for the bank account.';
                }
                field("Bank Code";"Bank Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the bank code for the vendor bank account.';
                }
                field("Bank Branch No.";"Bank Branch No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number of the bank branch.';
                }
                field("Bank Account No.";"Bank Account No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number used by the bank for the bank account.';
                }
                field("Transit No.";"Transit No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a bank identification number of your own choice.';
                }
                field("Use for Electronic Payments";"Use for Electronic Payments")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies if this vendor bank account will be the one that will be used for electronic payments. Be sure to select only one per vendor.';
                }
            }
            group(Communication)
            {
                Caption = 'Communication';
                field("Fax No.";"Fax No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the fax number of the bank where the vendor has the bank account.';
                }
                field("E-Mail";"E-Mail")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the email address associated with the bank account.';
                }
                field("Home Page";"Home Page")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the home page address associated with the bank account.';
                }
            }
            group(Transfer)
            {
                Caption = 'Transfer';
                field("SWIFT Code";"SWIFT Code")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the SWIFT code (international bank identifier code) of the bank where the vendor has the account.';
                }
                field(Iban;Iban)
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the bank account''s international bank account number.';
                }
                field("Bank Clearing Standard";"Bank Clearing Standard")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the format standard to be used in bank transfers if you use the Bank Clearing Code field to identify you as the sender.';
                }
                field("Bank Clearing Code";"Bank Clearing Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the code for bank clearing that is required according to the format standard you selected in the Bank Clearing Standard field.';
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
    }
}

