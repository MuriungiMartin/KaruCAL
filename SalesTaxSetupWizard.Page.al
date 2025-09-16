#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 10807 "Sales Tax Setup Wizard"
{
    Caption = 'Sales Tax Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = NavigatePage;
    ShowFilter = false;
    SourceTable = UnknownTable10807;
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            group(Control96)
            {
                Editable = false;
                Visible = TopBannerVisible and not (Step = Step::Done);
                field("MediaRepositoryStandard.Image";MediaRepositoryStandard.Image)
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ShowCaption = false;
                }
            }
            group(Control98)
            {
                Editable = false;
                Visible = TopBannerVisible and (Step = Step::Done);
                field("MediaRepositoryDone.Image";MediaRepositoryDone.Image)
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ShowCaption = false;
                }
            }
            group(Step1)
            {
                Caption = '';
                Visible = Step = Step::Intro;
                group("Para1.1")
                {
                    Caption = 'Welcome to Sales Tax Setup';
                    group("Para1.1.1")
                    {
                        Caption = '';
                        InstructionalText = 'You can create a default tax area code to assign to customers and vendors so that sales tax is automatically calculated in sales or purchase documents.';
                    }
                }
                group("Para1.2")
                {
                    Caption = 'Let''s go!';
                    InstructionalText = 'Choose Next to create a default tax group.';
                }
            }
            group(Step2)
            {
                Caption = '';
                Visible = Step = Step::TaxGroupCreated;
                group("Para2.1")
                {
                    Caption = 'Default tax group created';
                    group("Para2.1.1")
                    {
                        Caption = '';
                        InstructionalText = 'Tax Group of TAXABLE has been created. You will need to assign this group to your items that are taxable.';
                    }
                }
            }
            group(Step3)
            {
                Caption = '';
                Visible = Step = Step::TaxAccounts;
                group("Para3.1")
                {
                    Caption = 'Select which accounts you want to use with this tax group.';
                    field("Tax Account (Sales)";"Tax Account (Sales)")
                    {
                        ApplicationArea = Basic,Suite;

                        trigger OnValidate()
                        begin
                            NextEnabled := ("Tax Account (Sales)" <> '') or ("Tax Account (Purchases)" <> '');
                        end;
                    }
                    field("Tax Account (Purchases)";"Tax Account (Purchases)")
                    {
                        ApplicationArea = Basic,Suite;

                        trigger OnValidate()
                        begin
                            NextEnabled := ("Tax Account (Sales)" <> '') or ("Tax Account (Purchases)" <> '');
                        end;
                    }
                }
            }
            group(Step4)
            {
                Caption = '';
                Visible = Step = Step::TaxRates;
                group("Para4.1")
                {
                    Caption = 'Enter the tax information for your area; then click next.';
                    group("Para4.1.1")
                    {
                        Caption = '';
                        InstructionalText = 'Enter your city tax information';
                        Visible = CityAndCountyVisible;
                        field(City;City)
                        {
                            ApplicationArea = Basic,Suite;
                        }
                        field("City Rate";"City Rate")
                        {
                            ApplicationArea = Basic,Suite;
                            ToolTip = 'Specifies any special sales tax for the city in question.';

                            trigger OnValidate()
                            begin
                                Validate(City);
                            end;
                        }
                    }
                    group("Para4.1.2")
                    {
                        Caption = '';
                        InstructionalText = 'Enter your county tax information';
                        //The GridLayout property is only supported on controls of type Grid
                        //GridLayout = Rows;
                        Visible = CityAndCountyVisible;
                        field(County;County)
                        {
                            ApplicationArea = Basic,Suite;
                        }
                        field("County Rate";"County Rate")
                        {
                            ApplicationArea = Basic,Suite;
                            ToolTip = 'Specifies any special sales tax for the county in question.';

                            trigger OnValidate()
                            begin
                                Validate(County);
                            end;
                        }
                    }
                    group("Para4.1.3")
                    {
                        Caption = '';
                        InstructionalText = 'Enter your state tax information';
                        //The GridLayout property is only supported on controls of type Grid
                        //GridLayout = Rows;
                        field(State;State)
                        {
                            ApplicationArea = Basic,Suite;
                            ToolTip = 'Specifies the status of the document.';
                        }
                        field("State Rate";"State Rate")
                        {
                            ApplicationArea = Basic,Suite;
                            ToolTip = 'Specifies the sales tax in the state in question.';

                            trigger OnValidate()
                            begin
                                Validate(State);
                            end;
                        }
                    }
                }
            }
            group(Step5)
            {
                Caption = '';
                Visible = Step = Step::TaxAreaName;
                group("Para5.1")
                {
                    Caption = 'Enter a name for your new tax area';
                    field("Tax Area Code";"Tax Area Code")
                    {
                        ApplicationArea = Basic,Suite;

                        trigger OnValidate()
                        begin
                            "Tax Area Code" := DelChr("Tax Area Code",'<>',' ');
                            NextEnabled := "Tax Area Code" <> '';
                        end;
                    }
                }
            }
            group(Step6)
            {
                Caption = '';
                Visible = Step = Step::Done;
                group("Para6.1")
                {
                    Caption = 'That''s it!';
                    InstructionalText = 'Choose Finish to create this tax area and assign your customers to the new tax area.';
                    field(AssignToCustomers;AssignToCustomers)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'To Customers';
                    }
                    field(AssignToCustomerTemplates;AssignToCustomerTemplates)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'To Customer Templates';
                    }
                    field(AssignToItemTemplates;AssignToItemTemplates)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'To Item Templates';
                    }
                    field(AssignToVendors;AssignToVendors)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'To Vendors';
                    }
                    field(AssignToLocations;AssignToLocations)
                    {
                        ApplicationArea = Basic;
                        Caption = 'To Locations';
                    }
                    field(AssignToCompanyInfo;AssignToCompanyInfo)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'To Company Information';
                    }
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Back)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Back';
                Enabled = BackEnabled;
                Image = PreviousRecord;
                InFooterBar = true;

                trigger OnAction()
                begin
                    NextStep(true);
                end;
            }
            action(NextStep)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Next';
                Enabled = NextEnabled;
                Image = NextRecord;
                InFooterBar = true;

                trigger OnAction()
                begin
                    NextStep(false);
                end;
            }
            action(Finish)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Finish';
                Enabled = FinishEnabled;
                Image = Approve;
                InFooterBar = true;

                trigger OnAction()
                var
                    AssistedSetup: Record "Assisted Setup";
                begin
                    StoreSalesTaxSetup;
                    AssistedSetup.SetStatus(Page::"Sales Tax Setup Wizard",AssistedSetup.Status::Completed);
                    CurrPage.Close;
                    AssignTaxAreaCode;
                    AssignTaxGroupCode;
                end;
            }
        }
    }

    trigger OnInit()
    begin
        if not Get then begin
          Init;
          Insert;
        end;
        LoadTopBanners;
    end;

    trigger OnOpenPage()
    begin
        ShowIntroStep;
        SetCityAndCountyVisible;
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    var
        AssistedSetup: Record "Assisted Setup";
    begin
        if CloseAction = Action::OK then
          if AssistedSetup.GetStatus(Page::"Sales Tax Setup Wizard") = AssistedSetup.Status::"Not Completed" then
            if not Confirm(NAVNotSetUpQst,false) then
              Error('');
    end;

    var
        MediaRepositoryStandard: Record "Media Repository";
        MediaRepositoryDone: Record "Media Repository";
        ConfigTemplateManagement: Codeunit "Config. Template Management";
        Step: Option Intro,TaxGroupCreated,TaxAccounts,TaxRates,TaxAreaName,Done;
        GeneratedName: Code[20];
        BackEnabled: Boolean;
        NextEnabled: Boolean;
        FinishEnabled: Boolean;
        TopBannerVisible: Boolean;
        NAVNotSetUpQst: label 'Sales tax has not been set up.\\Are you sure that you want to exit?';
        TaxableCodeTxt: label 'TAXABLE', Locked=true;
        TaxableDescriptionTxt: label 'Taxable';
        CityTxt: label 'City of %1, %2', Comment='%1 = Name of city; %2 = State abbreviation';
        CountyTxt: label '%1 County, %2', Comment='%1 = Name of county; %2 = State abbreviation';
        StateTxt: label 'State of %1', Comment='%1 = State abbreviation';
        AssignToCustomers: Boolean;
        AssignToCustomerTemplates: Boolean;
        AssignToItemTemplates: Boolean;
        AssignToVendors: Boolean;
        AssignToCompanyInfo: Boolean;
        AssignToLocations: Boolean;
        CityAndCountyVisible: Boolean;

    local procedure NextStep(Backwards: Boolean)
    begin
        if Backwards then
          Step := Step - 1
        else
          Step := Step + 1;

        case Step of
          Step::Intro:
            ShowIntroStep;
          Step::TaxGroupCreated:
            ShowTaxGroupCreatedStep;
          Step::TaxAccounts:
            ShowTaxAccountsStep;
          Step::TaxRates:
            ShowTaxRatesStep;
          Step::TaxAreaName:
            ShowTaxAreaNameStep;
          Step::Done:
            ShowDoneStep;
        end;
        CurrPage.Update(true);
    end;

    local procedure ShowIntroStep()
    begin
        ResetWizardControls;
        BackEnabled := false;
    end;

    local procedure ShowTaxGroupCreatedStep()
    begin
        ResetWizardControls;
        NextEnabled := true;
    end;

    local procedure ShowTaxAccountsStep()
    begin
        ResetWizardControls;
        NextEnabled := ("Tax Account (Purchases)" <> '') or ("Tax Account (Sales)" <> '');
    end;

    local procedure ShowTaxRatesStep()
    begin
        ResetWizardControls;
    end;

    local procedure ShowTaxAreaNameStep()
    begin
        ResetWizardControls;
        if "Tax Area Code" in ['',GeneratedName] then begin
          GeneratedName := GenerateTaxAreaCode;
          "Tax Area Code" := GeneratedName;
        end;
        NextEnabled := "Tax Area Code" <> '';
    end;

    local procedure ShowDoneStep()
    begin
        ResetWizardControls;
        NextEnabled := false;
        FinishEnabled := true;
    end;

    local procedure ResetWizardControls()
    begin
        // Buttons
        BackEnabled := true;
        NextEnabled := true;
        FinishEnabled := false;
    end;

    local procedure GenerateTaxAreaCode(): Code[20]
    var
        TrucatedCity: Text[18];
        CommaSeparator: Text[2];
    begin
        TrucatedCity := CopyStr(City,1,16);
        if (StrLen(TrucatedCity) > 0) and (StrLen(State) > 0) then
          CommaSeparator := ', ';
        exit(StrSubstNo('%1%2%3',TrucatedCity,CommaSeparator,State));
    end;

    local procedure StoreSalesTaxSetup()
    var
        TaxGroup: Record "Tax Group";
        TaxArea: Record "Tax Area";
    begin
        SetTaxGroup(TaxGroup);
        SetTaxJurisdiction(State,StrSubstNo(StateTxt,State),State);
        SetTaxJurisdiction(County,GetDescription(CountyTxt,County),State);
        SetTaxJurisdiction(City,GetDescription(CityTxt,City),State);
        SetTaxArea(TaxArea);
        SetTaxAreaLine(TaxArea,State);
        SetTaxAreaLine(TaxArea,County);
        SetTaxAreaLine(TaxArea,City);
        SetTaxDetail(State,TaxGroup.Code,"State Rate");
        SetTaxDetail(County,TaxGroup.Code,"County Rate");
        SetTaxDetail(City,TaxGroup.Code,"City Rate");
    end;

    local procedure SetTaxGroup(var TaxGroup: Record "Tax Group")
    begin
        if not TaxGroup.Get(TaxableCodeTxt) then begin
          TaxGroup.Init;
          TaxGroup.Validate(Code,TaxableCodeTxt);
          TaxGroup.Validate(Description,TaxableDescriptionTxt);
          TaxGroup.Insert;
        end;
    end;

    local procedure SetTaxJurisdiction(Jurisdiction: Text[30];Description: Text[50];ReportToCode: Code[10])
    var
        TaxJurisdiction: Record "Tax Jurisdiction";
        JurisdictionCode: Code[10];
    begin
        JurisdictionCode := CopyStr(DelChr(Jurisdiction,'<>',' '),1,10);
        if JurisdictionCode <> '' then begin
          if not TaxJurisdiction.Get(JurisdictionCode) then begin
            TaxJurisdiction.Init;
            TaxJurisdiction.Validate(Code,JurisdictionCode);
            TaxJurisdiction.Insert;
          end;

          TaxJurisdiction.Validate(Description,Description);
          if ReportToCode <> '' then
            TaxJurisdiction.Validate("Report-to Jurisdiction",ReportToCode);
          TaxJurisdiction.Validate("Tax Account (Sales)","Tax Account (Sales)");
          TaxJurisdiction.Validate("Tax Account (Purchases)","Tax Account (Purchases)");
          TaxJurisdiction.Modify;
        end;
    end;

    local procedure SetTaxArea(var TaxArea: Record "Tax Area")
    begin
        if not TaxArea.Get("Tax Area Code") then begin
          TaxArea.Init;
          TaxArea.Validate(Code,"Tax Area Code");
          TaxArea.Validate(Description,"Tax Area Code");
          TaxArea.Insert;
        end;
    end;

    local procedure SetTaxAreaLine(TaxArea: Record "Tax Area";Jurisdiction: Text)
    var
        TaxAreaLine: Record "Tax Area Line";
        JurisdictionCode: Code[10];
    begin
        JurisdictionCode := CopyStr(DelChr(Jurisdiction,'<>',' '),1,10);
        if JurisdictionCode <> '' then
          if not TaxAreaLine.Get(TaxArea.Code,JurisdictionCode) then begin
            TaxAreaLine.Init;
            TaxAreaLine.Validate("Tax Area",TaxArea.Code);
            TaxAreaLine.Validate("Tax Jurisdiction Code",JurisdictionCode);
            TaxAreaLine.Insert;
          end;
    end;

    local procedure SetTaxDetail(Jurisdiction: Text[30];Group: Code[10];Tax: Decimal)
    var
        TaxDetail: Record "Tax Detail";
        JurisdictionCode: Code[10];
    begin
        JurisdictionCode := CopyStr(DelChr(Jurisdiction,'<>',' '),1,10);
        if JurisdictionCode <> '' then
          with TaxDetail do begin
            if not Get(JurisdictionCode,Group,"tax type"::"Sales and Use Tax",Today) then begin
              Init;
              Validate("Tax Jurisdiction Code",JurisdictionCode);
              Validate("Tax Group Code",Group);
              Validate("Tax Type","tax type"::"Sales and Use Tax");
              Validate("Effective Date",Today);
              Insert(true);
            end;

            Validate("Maximum Amount/Qty.",0);
            Validate("Tax Below Maximum",Tax);
            Modify;
          end;
    end;

    local procedure GetDescription(Description: Text;CityOrCounty: Text[30]) Result: Text[50]
    begin
        Result := CopyStr(StrSubstNo(Description,CityOrCounty,State),1,50);
        if State = '' then
          Result := DelChr(Result,'>',', ');
    end;

    local procedure AssignTaxAreaCode()
    var
        Customer: Record Customer;
        Vendor: Record Vendor;
        Location: Record Location;
        DummyCompanyInformation: Record "Company Information";
        AssignTaxAreaToCustomer: Report "Assign Tax Area to Customer";
        AssignTaxAreaToVendor: Report "Assign Tax Area to Vendor";
        AssignTaxAreaToLocation: Report "Assign Tax Area to Location";
    begin
        Commit;
        if AssignToCustomers then begin
          AssignTaxAreaToCustomer.SetTableview(Customer);
          AssignTaxAreaToCustomer.SetDefaultAreaCode("Tax Area Code");
          AssignTaxAreaToCustomer.Run;
          Commit;
        end;
        if AssignToCustomerTemplates then
          ConfigTemplateManagement.ReplaceDefaultValueForAllTemplates(
            Database::Customer,Customer.FieldNo("Tax Area Code"),"Tax Area Code");
        Commit;
        if AssignToVendors then begin
          AssignTaxAreaToVendor.SetTableview(Vendor);
          AssignTaxAreaToVendor.SetDefaultAreaCode("Tax Area Code");
          AssignTaxAreaToVendor.Run;
          Commit;
        end;
        if AssignToLocations then begin
          AssignTaxAreaToLocation.SetTableview(Location);
          AssignTaxAreaToLocation.SetDefaultAreaCode("Tax Area Code");
          AssignTaxAreaToLocation.Run;
          Commit;
        end;
        if AssignToCompanyInfo and DummyCompanyInformation.FindFirst then begin
          DummyCompanyInformation.Validate("Tax Area Code","Tax Area Code");
          DummyCompanyInformation.Modify;
          Commit;
        end;
    end;

    local procedure AssignTaxGroupCode()
    var
        Item: Record Item;
    begin
        if AssignToItemTemplates then
          ConfigTemplateManagement.ReplaceDefaultValueForAllTemplates(
            Database::Item,Item.FieldNo("Tax Group Code"),TaxableCodeTxt);
    end;

    local procedure LoadTopBanners()
    begin
        if MediaRepositoryStandard.Get('AssistedSetup-NoText-400px.png',Format(CurrentClientType)) and
           MediaRepositoryDone.Get('AssistedSetupDone-NoText-400px.png',Format(CurrentClientType))
        then
          TopBannerVisible := MediaRepositoryDone.Image.Hasvalue;
    end;

    local procedure SetCityAndCountyVisible()
    var
        CompanyInformation: Record "Company Information";
    begin
        CompanyInformation.Get;
        CityAndCountyVisible := CompanyInformation."Country/Region Code" <> 'CA';
    end;
}

