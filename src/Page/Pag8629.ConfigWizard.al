#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 8629 "Config. Wizard"
{
    Caption = 'Welcome to RapidStart Services for Microsoft Dynamics NAV';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = Card;
    PromotedActionCategories = 'New,Process,Report,Step 4,Step 5';
    ShowFilter = false;
    SourceTable = "Config. Setup";

    layout
    {
        area(content)
        {
            group("Step 1. Enter your company details.")
            {
                Caption = 'Step 1. Enter your company details.';
                group(Control5)
                {
                    field(Name;Name)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Name (Required)';
                        ToolTip = 'Specifies the name of your company that you are configuring.';
                    }
                    field(Address;Address)
                    {
                        ApplicationArea = Basic,Suite;
                        ToolTip = 'Specifies an address for the company that you are configuring.';
                    }
                    field("Address 2";"Address 2")
                    {
                        ApplicationArea = Basic,Suite;
                        ToolTip = 'Specifies another line in which you can enter the address of the company that you are configuring.';
                    }
                    field("Post Code";"Post Code")
                    {
                        ApplicationArea = Basic,Suite;
                        ToolTip = 'Specifies the ZIP code for the company that you are configuring.';
                    }
                    field(City;City)
                    {
                        ApplicationArea = Basic,Suite;
                        ToolTip = 'Specifies the city where the company that you are configuring is located.';
                    }
                    field("Country/Region Code";"Country/Region Code")
                    {
                        ApplicationArea = Basic,Suite;
                        ToolTip = 'Specifies the country/region code for your company. To see the country/region codes in the Country/Region table, choose the field.';
                    }
                    field("VAT Registration No.";"VAT Registration No.")
                    {
                        ApplicationArea = Basic,Suite;
                        ToolTip = 'Specifies the customer''s tax registration number.';
                    }
                    field("Industrial Classification";"Industrial Classification")
                    {
                        ApplicationArea = Basic,Suite;
                        ToolTip = 'Specifies the type of industry that the company that you are configuring is.';
                    }
                }
                field(Picture;Picture)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the picture that has been set up for the company, for example, a company logo.';
                }
            }
            group("Step 2. Enter communication details.")
            {
                Caption = 'Step 2. Enter communication details.';
                field("Phone No.2";"Phone No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the telephone number of the company that you are configuring.';
                }
                field("Fax No.";"Fax No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies fax number of the company that you are configuring.';
                }
                field("E-Mail";"E-Mail")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the email address of the company that you are configuring.';
                }
                field("Home Page";"Home Page")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the Internet home page address of the company that you are configuring. You can enter a maximum of 80 characters, both numbers and letters.';
                }
            }
            group("Step 3. Enter payment details.")
            {
                Caption = 'Step 3. Enter payment details.';
                field("Bank Name";"Bank Name")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the name of the bank the company uses.';
                }
                field("Bank Branch No.";"Bank Branch No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the branch number of the bank that the company that you are configuring uses.';
                }
                field("Bank Account No.";"Bank Account No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the bank account number of the company that you are configuring.';
                }
                field("Payment Routing No.";"Payment Routing No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the payment routing number of the company that you are configuring.';
                }
                field("Giro No.";"Giro No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the giro number of the company that you are configuring.';
                }
                field("SWIFT Code";"SWIFT Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the SWIFT code (international bank identifier code) of the primary bank of the company that you are configuring.';
                }
                field(Iban;Iban)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the international bank account number of the primary bank account of the company that you are configuring.';
                }
            }
            group("Step 4. Select package.")
            {
                Caption = 'Step 4. Select package.';
                group(Control2)
                {
                    field("Package File Name";"Package File Name")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Select the configuration package you want to load:';
                        Editable = false;
                        ToolTip = 'Specifies the name of the configuration package that you have created.';

                        trigger OnAssistEdit()
                        var
                            FileMgt: Codeunit "File Management";
                            ConfigXMLExchange: Codeunit "Config. XML Exchange";
                        begin
                            if ConfigVisible then
                              Error(Text005);

                            "Package File Name" :=
                              CopyStr(
                                FileMgt.OpenFileDialog(
                                  Text004,'',ConfigXMLExchange.GetFileDialogFilter),1,MaxStrLen("Package File Name"));

                            if "Package File Name" <> '' then begin
                              Validate("Package File Name");
                              ApplyVisible := true;
                            end else
                              ApplyVisible := false;
                        end;

                        trigger OnValidate()
                        begin
                            if "Package File Name" = '' then
                              ApplyVisible := false;

                            CurrPage.Update;
                        end;
                    }
                    field("Package Code";"Package Code")
                    {
                        ApplicationArea = Basic,Suite;
                        ToolTip = 'Specifies the code of the configuration package.';
                    }
                    field("Package Name";"Package Name")
                    {
                        ApplicationArea = Basic,Suite;
                        Editable = false;
                        ToolTip = 'Specifies the name of the package that contains the configuration information.';
                    }
                    label("Choose Apply Package action to load the data from the configuration to Microsoft Dynamics NAV tables.")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Choose Apply Package action to load the data from the configuration to Microsoft Dynamics NAV tables.';
                    }
                    label("Choose Configuration Worksheet if you want to edit and modify applied data.")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Choose Configuration Worksheet if you want to edit and modify applied data.';
                    }
                }
            }
            group("Step 5. Select profile.")
            {
                Caption = 'Step 5. Select profile.';
                group(Control11)
                {
                    group(Control9)
                    {
                        label(ProfileText)
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = 'If you are finished setting up your company, select the profile that you want to use as your default, and then choose the OK button to close the Wizard.';
                        }
                        field("Your Profile Code";"Your Profile Code")
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = 'Select the profile that you want to use after the setup has completed.';
                            ShowCaption = false;
                            ToolTip = 'Specifies the profile code for your configuration solution and package.';
                        }
                    }
                    label(Control3)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'If you still need to change setup data, do not change the profile. Choose the OK button to close the wizard, and then use the configuration worksheet to continue setting up Microsoft Dynamics NAV.';
                        Style = Attention;
                        StyleExpr = true;
                    }
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("Actions")
            {
                Caption = 'Actions';
                action("Apply Package")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Apply Package';
                    Enabled = ApplyVisible;
                    Image = Apply;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Import the configuration package and apply the package database data at the same time.';

                    trigger OnAction()
                    begin
                        if CompleteWizard then
                          ConfigVisible := true
                        else
                          Error(Text003);
                    end;
                }
                action("Configuration Worksheet")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Configuration Worksheet';
                    Enabled = ConfigVisible;
                    Image = SetupLines;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    RunObject = Page "Config. Worksheet";
                    ToolTip = 'Open the Configuration Worksheet window.';
                }
            }
            group(Setup)
            {
                Caption = 'Setup';
                action(Users)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Users';
                    Image = User;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    RunObject = Page Users;
                }
                action("Users Personalization")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Users Personalization';
                    Image = UserSetup;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    RunObject = Page "User Personalization List";
                }
            }
        }
    }

    trigger OnClosePage()
    begin
        SelectDefaultRoleCenter("Your Profile Code");
    end;

    trigger OnOpenPage()
    begin
        Reset;
        if not Get then begin
          Init;
          Insert;
        end else begin
          "Package File Name" := '';
          "Package Name" := '';
          "Package Code" := '';
          Modify;
        end;
    end;

    var
        Text003: label 'Select a package to run the Apply Package function.';
        Text004: label 'Select a package file.';
        ApplyVisible: Boolean;
        ConfigVisible: Boolean;
        Text005: label 'A package has already been selected and applied.';
}

