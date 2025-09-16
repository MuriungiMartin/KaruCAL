#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1 "Company Information"
{
    ApplicationArea = Basic;
    Caption = 'Company Information';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    PromotedActionCategories = 'New,Process,Report,Application Settings,System Settings,Currencies,Codes,Regional Settings';
    SourceTable = "Company Information";
    UsageCategory = Tasks;

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
                    ToolTip = 'Specifies the company''s name and corporate form. For example, Inc. or Ltd.';
                }
                field(Address;Address)
                {
                    ApplicationArea = Basic,Suite;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the company''s address.';
                }
                field("Address 2";"Address 2")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies additional address information.';
                }
                field(City;City)
                {
                    ApplicationArea = Basic,Suite;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the company''s city.';
                }
                field(County;County)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'State';
                    ShowMandatory = true;
                    ToolTip = 'Specifies the state as a part of the address.';
                }
                field("Post Code";"Post Code")
                {
                    ApplicationArea = Basic,Suite;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the ZIP code.';
                }
                field("Country/Region Code";"Country/Region Code")
                {
                    ApplicationArea = Basic,Suite;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the country/region of the address.';
                }
                field("Phone No.";"Phone No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the company''s telephone number.';
                }
                field("Federal ID No.";"Federal ID No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the company''s taxpayer identification number.';
                }
                field("Industrial Classification";"Industrial Classification")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the company''s industrial classification code.';
                }
                field(Picture;Picture)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the picture that has been set up for the company, such as a company logo.';

                    trigger OnValidate()
                    begin
                        CurrPage.SaveRecord;
                    end;
                }
            }
            group(Communication)
            {
                Caption = 'Communication';
                field("Phone No.2";"Phone No.")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the company''s telephone number.';
                }
                field("Fax No.";"Fax No.")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the company''s fax number.';
                }
                field("E-Mail";"E-Mail")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the company''s email address.';
                }
                field("Home Page";"Home Page")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the company''s home page address.';
                }
                field("IC Partner Code";"IC Partner Code")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    ToolTip = 'Specifies your company''s intercompany partner code.';
                }
                field("IC Inbox Type";"IC Inbox Type")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    ToolTip = 'Specifies what type of intercompany inbox you have, either File Location or Database.';
                }
                field("IC Inbox Details";"IC Inbox Details")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    ToolTip = 'Specifies details about the location of your intercompany inbox, which can transfer intercompany transactions into your company.';
                }
            }
            group(Payments)
            {
                Caption = 'Payments';
                field("Bank Name";"Bank Name")
                {
                    ApplicationArea = Basic,Suite;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the name of the bank the company uses.';
                }
                field("Bank Branch No.";"Bank Branch No.")
                {
                    ApplicationArea = Basic,Suite;
                    ShowMandatory = IBANMissing;
                    ToolTip = 'Specifies the bank''s branch number.';

                    trigger OnValidate()
                    begin
                        SetShowMandatoryConditions
                    end;
                }
                field("Bank Account No.";"Bank Account No.")
                {
                    ApplicationArea = Basic,Suite;
                    ShowMandatory = IBANMissing;
                    ToolTip = 'Specifies the company''s bank account number.';

                    trigger OnValidate()
                    begin
                        SetShowMandatoryConditions
                    end;
                }
                field("Payment Routing No.";"Payment Routing No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the company''s payment routing number.';
                }
                field("Giro No.";"Giro No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the company''s giro number.';
                }
                field("SWIFT Code";"SWIFT Code")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the SWIFT code (international bank identifier code) of your primary bank.';

                    trigger OnValidate()
                    begin
                        SetShowMandatoryConditions
                    end;
                }
                field(Iban;Iban)
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ShowMandatory = BankBranchNoOrAccountNoMissing;
                    ToolTip = 'Specifies the international bank account number of your primary bank account.';

                    trigger OnValidate()
                    begin
                        SetShowMandatoryConditions
                    end;
                }
            }
            group(Shipping)
            {
                Caption = 'Shipping';
                field("Ship-to Name";"Ship-to Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the location to which items for the company should be shipped.';
                }
                field("Ship-to Address";"Ship-to Address")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the address of the location to which items for the company should be shipped.';
                }
                field("Ship-to Address 2";"Ship-to Address 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies additional address information.';
                }
                field("Ship-to City";"Ship-to City")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the city of the address.';
                }
                field("Ship-to County";"Ship-to County")
                {
                    ApplicationArea = Basic;
                    Caption = 'Ship-to State';
                }
                field("Ship-to Post Code";"Ship-to Post Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ZIP code of the address.';
                }
                field("Ship-to Country/Region Code";"Ship-to Country/Region Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the country/region code of the address.';
                }
                field("Ship-to Contact";"Ship-to Contact")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the contact person to whom items for the company should be shipped.';
                }
                field("Ship-to UPS Zone";"Ship-to UPS Zone")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ship-to United Parcel Service (UPS) zone for the company.';
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the location code that corresponds to the company''s ship-to address.';
                }
                field("Responsibility Center";"Responsibility Center")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the default responsibility center.';
                }
                field("Check-Avail. Period Calc.";"Check-Avail. Period Calc.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a date formula that defines the length of the period after the planned shipment date on demand lines in which the system checks availability for the demand line in question.';
                }
                field("Check-Avail. Time Bucket";"Check-Avail. Time Bucket")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how frequently the system checks supply-demand events to discover if the item on the demand line is available on its shipment date.';
                }
                field("Base Calendar Code";"Base Calendar Code")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    ToolTip = 'Specifies the code for the base calendar that you want to assign to your company.';
                }
                field("Customized Calendar";CalendarMgmt.CustomizedCalendarExistText(CustomizedCalendar."source type"::Company,'','',"Base Calendar Code"))
                {
                    ApplicationArea = Basic;
                    Caption = 'Customized Calendar';
                    DrillDown = true;
                    Editable = false;
                    ToolTip = 'Specifies whether or not your company has set up a customized calendar.';

                    trigger OnDrillDown()
                    begin
                        CurrPage.SaveRecord;
                        TestField("Base Calendar Code");
                        CalendarMgmt.ShowCustomizedCalendar(CustomizedCalEntry."source type"::Company,'','',"Base Calendar Code");
                    end;
                }
                field("Cal. Convergence Time Frame";"Cal. Convergence Time Frame")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how dates based on calendar and calendar-related documents are calculated.';
                }
            }
            group(Tax)
            {
                Caption = 'Tax';
                field("VAT Registration No.";"VAT Registration No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the company''s tax registration number.';
                }
                field("QST Registration No.";"QST Registration No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the registration number for Quebec Sales Tax.';
                }
                field("Tax Area Code";"Tax Area Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a tax area code for the company.';
                }
                field("Tax Exemption No.";"Tax Exemption No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies if the company''s tax exemption number. If the company has been registered exempt for sales and use tax this number would have been assigned by the taxing authority.';
                }
                field("Tax Scheme";"Tax Scheme")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the tax scheme that the company complies with.';
                }
                field("Provincial Tax Area Code";"Provincial Tax Area Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the tax area code for self assessed Provincial Sales Tax for the company.';
                }
                field("RFC No.";"RFC No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the federal registration number for taxpayers.';
                }
                field("CURP No.";"CURP No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the unique fiscal card identification number. The CURP number must contain 18 digits.';
                }
                field("State Inscription";"State Inscription")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the tax ID number that is assigned by state tax authorities to every person or corporation.';
                }
                field("Software Identification Code";"Software Identification Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the software identification code for the company.';
                }
                field(GLN;GLN)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies your company in connection with electronic document exchange.';
                }
                field("Allow Blank Payment Info.";"Allow Blank Payment Info.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies if you are allowed to create a sales invoice without filling the setup fields on this FastTab.';
                }
                field(BankAccountPostingGroup;BankAcctPostingGroup)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = ' Bank Account Posting Group';
                    Lookup = true;
                    TableRelation = "Bank Account Posting Group".Code;
                    ToolTip = 'Specifies a code for the bank account posting group for the company''s bank account.';
                }
            }
            group("System Indicator")
            {
                Caption = 'System Indicator';
                field(Control100;"System Indicator")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how you want to use the system indicator when you are working with different versions of Microsoft Dynamics NAV.';

                    trigger OnValidate()
                    begin
                        SystemIndicatorOnAfterValidate;
                    end;
                }
                field("System Indicator Style";"System Indicator Style")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if you want to apply a certain style to the system indicator.';
                }
                field("System Indicator Text";SystemIndicatorText)
                {
                    ApplicationArea = Basic;
                    Caption = 'System Indicator Text';
                    Editable = SystemIndicatorTextEditable;

                    trigger OnValidate()
                    begin
                        "Custom System Indicator Text" := SystemIndicatorText;
                        SystemIndicatorTextOnAfterVali;
                    end;
                }
            }
            group("User Experience")
            {
                Caption = 'User Experience';
                Visible = Experience = Experience::Custom;
                field(ExperienceCustom;Experience)
                {
                    AccessByPermission = TableData "Application Area Setup"=IM;
                    ApplicationArea = All;
                    BlankZero = true;
                    Caption = 'Experience';
                    OptionCaption = ',,,,,Basic,,,,,,,,,,Suite,,,,,Custom';
                    ToolTip = 'Specifies for which application areas fields and actions are shown in the user interface. This is a way to simplify the product by hiding UI elements for features that you do not use.';

                    trigger OnValidate()
                    var
                        ApplicationAreaSetup: Record "Application Area Setup";
                    begin
                        ApplicationAreaSetup.SetExperienceTierCurrentCompany(Experience);
                        Message(ReSignInMsg);
                    end;
                }
            }
            group(Control38)
            {
                Caption = 'User Experience';
                Visible = Experience <> Experience::Custom;
                field(Experience;Experience)
                {
                    AccessByPermission = TableData "Application Area Setup"=IM;
                    ApplicationArea = All;
                    BlankZero = true;
                    Caption = 'Experience';
                    OptionCaption = ',,,,,Basic,,,,,,,,,,Suite,,,,,Custom';
                    ToolTip = 'Specifies for which application areas fields and actions are shown in the user interface. This is a way to simplify the product by hiding UI elements for features that you do not use.';

                    trigger OnValidate()
                    var
                        ApplicationAreaSetup: Record "Application Area Setup";
                    begin
                        ApplicationAreaSetup.SetExperienceTierCurrentCompany(Experience);
                        Message(ReSignInMsg);
                    end;
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
            action("Responsibility Centers")
            {
                ApplicationArea = Basic;
                Caption = 'Responsibility Centers';
                Image = Position;
                RunObject = Page "Responsibility Center List";
                ToolTip = 'Set up responsibility centers to administer business operations that cover multiple locations, such as a sales offices or a purchasing departments.';
            }
            action("Report Layouts")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Report Layouts';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedOnly = true;
                RunObject = Page "Report Layout Selection";
                ToolTip = 'Specify the layout to use on reports when viewing, printing, and saving them. The layout defines things like text font, field placement, or background.';
            }
            group("Application Settings")
            {
                Caption = 'Application Settings';
                group(Setup)
                {
                    Caption = 'Setup';
                    Image = Setup;
                    action("General Ledger Setup")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'General Ledger Setup';
                        Image = JournalSetup;
                        Promoted = true;
                        PromotedCategory = Category4;
                        PromotedIsBig = true;
                        RunObject = Page "General Ledger Setup";
                        ToolTip = 'Define your general accounting policies, such as the allowed posting period and how payments are processed. Set up your default dimensions for financial analysis.';
                    }
                    action("Sales & Receivables Setup")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Sales & Receivables Setup';
                        Image = ReceivablesPayablesSetup;
                        RunObject = Page "Sales & Receivables Setup";
                        ToolTip = 'Define your general policies for sales invoicing and returns, such as when to show credit and stockout warnings and how to post sales discounts. Set up your number series for creating customers and different sales documents.';
                    }
                    action("Purchases & Payables Setup")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Purchases & Payables Setup';
                        Image = Purchase;
                        RunObject = Page "Purchases & Payables Setup";
                        ToolTip = 'Define your general policies for purchase invoicing and returns, such as whether to require vendor invoice numbers and how to post purchase discounts. Set up your number series for creating vendors and different purchase documents.';
                    }
                    action("Inventory Setup")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Inventory Setup';
                        Image = InventorySetup;
                        RunObject = Page "Inventory Setup";
                        ToolTip = 'Define your general inventory policies, such as whether to allow negative inventory and how to post and adjust item costs. Set up your number series for creating new inventory items or services.';
                    }
                    action("Fixed Assets Setup")
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'Fixed Assets Setup';
                        Image = FixedAssets;
                        RunObject = Page "Fixed Asset Setup";
                        ToolTip = 'Define your accounting policies for fixed assets, such as the allowed posting period and whether to allow posting to main assets. Set up your number series for creating new fixed assets.';
                    }
                    action("Human Resources Setup")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Human Resources Setup';
                        Image = HRSetup;
                        RunObject = Page "Human Resources Setup";
                        ToolTip = 'Set up number series for creating new employee cards and define if employment time is measured by days or hours.';
                    }
                    action("Jobs Setup")
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Jobs Setup';
                        Image = Job;
                        RunObject = Page "Jobs Setup";
                        ToolTip = 'Define your accounting policies for jobs, such as which WIP method to use and whether to update job item costs automatically.';
                    }
                }
                action("No. Series")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'No. Series';
                    Image = NumberSetup;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    RunObject = Page "No. Series";
                    ToolTip = 'Set up the number series from which a new number is automatically assigned to new cards and documents, such as item cards and sales invoices.';
                }
            }
            group("System Settings")
            {
                Caption = 'System Settings';
                action(Users)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Users';
                    Image = Users;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    RunObject = Page Users;
                    ToolTip = 'Set up the employees who will work in in this company.';
                }
                action("Permission Sets")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Permission Sets';
                    Image = Permission;
                    RunObject = Page "Permission Sets";
                    ToolTip = 'View or edit which feature objects that users need to access and set up the related permissions in permission sets that you can assign to the users of the database.';
                }
                action("SMTP Mail Setup")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'SMTP Mail Setup';
                    Image = MailSetup;
                    RunObject = Page "SMTP Mail Setup";
                    ToolTip = 'Set up the integration and security of the mail server at your site that handles email.';
                }
            }
            separator(Action1030000)
            {
            }
            action("Account Identifier")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Account Identifier';
                Image = Description;
                RunObject = Page "Account Identifiers";
                ToolTip = 'View or change account identifiers. Each identifier includes a program identifier, reference number, and business number.';
            }
            group(Currencies)
            {
                Caption = 'Currencies';
                action(Action27)
                {
                    ApplicationArea = Suite;
                    Caption = 'Currencies';
                    Image = Currencies;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    RunObject = Page Currencies;
                    ToolTip = 'Set up the different currencies that you trade in by defining which general ledger accounts the involved transactions are posted to and how the foreign currency amounts are rounded.';
                }
            }
            group("Regional Settings")
            {
                Caption = 'Regional Settings';
                action("Countries/Regions")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Countries/Regions';
                    Image = CountryRegion;
                    RunObject = Page "Countries/Regions";
                    ToolTip = 'Set up the country/regions where your different business partners are located, so that you can assign Country/Region codes to business partners where special local procedures are required.';
                }
                action("ZIP Codes")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'ZIP Codes';
                    Image = MailSetup;
                    Promoted = true;
                    PromotedCategory = Category8;
                    PromotedIsBig = true;
                    RunObject = Page "Post Codes";
                    ToolTip = 'Set up the ZIP codes of cities where your business partners are located.';
                }
                action("Online Map Setup")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Online Map Setup';
                    Image = MapSetup;
                    RunObject = Page "Online Map Setup";
                    ToolTip = 'Define which map provider to use and how routes and distances are displayed when you choose the Online Map field on business documents.';
                }
                action(Languages)
                {
                    ApplicationArea = Basic;
                    Caption = 'Languages';
                    Image = Language;
                    Promoted = true;
                    PromotedCategory = Category7;
                    PromotedIsBig = true;
                    RunObject = Page Languages;
                    ToolTip = 'Set up the languages that are spoken by your different business partners, so that you can print item names or descriptions in the relevant language.';
                }
            }
            group(Codes)
            {
                Caption = 'Codes';
                action("Source Codes")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Source Codes';
                    Image = CodesList;
                    RunObject = Page "Source Codes";
                    ToolTip = 'Set up codes for your different types of business transactions, so that you can track the source of the transactions in an audit.';
                }
                action("Reason Codes")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Reason Codes';
                    Image = CodesList;
                    RunObject = Page "Reason Codes";
                    ToolTip = 'Set up codes that specify reasons why entries were created, such as Return, to specify why a purchase credit memo was posted.';
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        UpdateSystemIndicator;
    end;

    trigger OnAfterGetRecord()
    var
        ApplicationAreaSetup: Record "Application Area Setup";
    begin
        ApplicationAreaSetup.GetExperienceTierCurrentCompany(Experience);
    end;

    trigger OnClosePage()
    var
        ApplicationAreaSetup: Record "Application Area Setup";
        BankAccount: Record "Bank Account";
    begin
        if ApplicationAreaSetup.IsFoundationEnabled then
          CompanyInformationMgt.UpdateCompanyBankAccount(Rec,BankAcctPostingGroup,BankAccount);
    end;

    trigger OnInit()
    begin
        SetShowMandatoryConditions;
    end;

    trigger OnOpenPage()
    begin
        ShowMigrationMessage;
        Reset;
        if not Get then begin
          Init;
          Insert;
        end;
    end;

    var
        CustomizedCalEntry: Record "Customized Calendar Entry";
        CustomizedCalendar: Record "Customized Calendar Change";
        CalendarMgmt: Codeunit "Calendar Management";
        CompanyInformationMgt: Codeunit "Company Information Mgt.";
        Experience: Option ,,,,,Basic,,,,,,,,,,Suite,,,,,Custom;
        SystemIndicatorText: Text[250];
        [InDataSet]
        SystemIndicatorTextEditable: Boolean;
        IBANMissing: Boolean;
        BankBranchNoOrAccountNoMissing: Boolean;
        BankAcctPostingGroup: Code[10];
        ReSignInMsg: label 'You must sign out and then sign in again to have the changes take effect.', Comment='"sign out" and "sign in" are the same terms as shown in the Dynamics NAV client.';

    local procedure UpdateSystemIndicator()
    var
        IndicatorStyle: Option;
    begin
        GetSystemIndicator(SystemIndicatorText,IndicatorStyle); // IndicatorStyle is not used
        SystemIndicatorTextEditable := CurrPage.Editable and ("System Indicator" = "system indicator"::"Custom Text");
    end;

    local procedure SystemIndicatorTextOnAfterVali()
    begin
        UpdateSystemIndicator
    end;

    local procedure SystemIndicatorOnAfterValidate()
    begin
        UpdateSystemIndicator
    end;

    local procedure SetShowMandatoryConditions()
    begin
        BankBranchNoOrAccountNoMissing := ("Bank Branch No." = '') or ("Bank Account No." = '');
        IBANMissing := Iban = ''
    end;

    local procedure ShowMigrationMessage()
    begin
        Message('ALERT!!!!!!!!!!!!!!!!!!!,We are migrating to BUSINESS CENTRAL TOMORROW.Hence Operations Done Here from Tomorrow will not be saved' +
                  'Ensure you have a link and Log In Credentials.');
    end;
}

