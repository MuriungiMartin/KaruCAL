#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1808 "Data Migration Wizard"
{
    ApplicationArea = Basic;
    Caption = 'Data Migration';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = NavigatePage;
    ShowFilter = false;
    SourceTable = "Data Migrator Registration";
    SourceTableTemporary = true;
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            group(Control96)
            {
                Editable = false;
                Visible = TopBannerVisible and not DoneVisible;
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
                Visible = TopBannerVisible and DoneVisible;
                field("MediaRepositoryDone.Image";MediaRepositoryDone.Image)
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ShowCaption = false;
                }
            }
            group(Control8)
            {
                Visible = IntroVisible;
                group("Welcome to the assisted Data Migration")
                {
                    Caption = 'Welcome to the assisted Data Migration';
                    InstructionalText = 'You can import data from other finance solutions and other data sources, provided that the corresponding extension is available to handle the conversion. To see a list of available extensions, choose the Open Extension Management button.';
                }
                group("Let's go!")
                {
                    Caption = 'Let''s go!';
                    InstructionalText = 'Choose Next to choose your data source.';
                }
            }
            group(Control56)
            {
                Visible = ChooseSourceVisible;
                group("Choose your data source")
                {
                    Caption = 'Choose your data source';
                    InstructionalText = 'From which data source do you want to import data?';
                    field(Description;Description)
                    {
                        ApplicationArea = Basic,Suite;
                        ShowCaption = false;
                        TableRelation = "Data Migrator Registration".Description;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            if Page.RunModal(Page::"Data Migrators",Rec) = Action::LookupOK then begin
                              Text := Description;
                              Clear(DataMigrationSettingsVisible);
                              OnHasSettings(DataMigrationSettingsVisible);
                              exit;
                            end;
                        end;
                    }
                }
            }
            group(Control12)
            {
                Visible = ImportVisible;
                group("Upload your data file.")
                {
                    Caption = 'Upload your data file.';
                    InstructionalText = 'Follow these instructions:';
                    field(Instructions;Instructions)
                    {
                        ApplicationArea = Basic,Suite;
                        Editable = false;
                        MultiLine = true;
                        ShowCaption = false;
                    }
                }
                group(Settings)
                {
                    Caption = 'Settings';
                    InstructionalText = 'You can change the import settings for this data source by choosing Settings in the actions below.';
                    Visible = DataMigrationSettingsVisible;
                }
                group(Control17)
                {
                    InstructionalText = 'Choose Next to select the file containing your data.';
                }
            }
            group(Control14)
            {
                Visible = ApplyVisible;
                part(DataMigrationEntities;"Data Migration Entities")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Apply your imported data.';
                }
                group(Control13)
                {
                    InstructionalText = 'Choose Next to start applying your data.';
                }
            }
            group("POSTING GROUP SETUP")
            {
                Caption = 'POSTING GROUP SETUP';
                Visible = PostingGroupIntroVisible;
                group("Welcome to Posting Group Setup")
                {
                    Caption = 'Welcome to Posting Group Setup';
                    InstructionalText = 'You can setup your posting accounts so when you post Sales and Purchase transactions they post to the correct General Ledger accounts';
                }
                group(Control47)
                {
                    Caption = 'Let''s go!';
                    InstructionalText = 'Choose Next to create Posting Accounts for Purchasing and Sales Transactions';
                }
            }
            group(Control46)
            {
                InstructionalText = 'Select which accounts you want to use when posting';
                Visible = FirstAccountSetupVisible;
                field("Sales Account";SalesAccount)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Sales Account';
                    TableRelation = "G/L Account"."No.";
                }
                field("Sales Credit Memo Account";SalesCreditMemoAccount)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Sales Credit Memo Account';
                    TableRelation = "G/L Account"."No.";
                }
                field("Sales Line Disc. Account";SalesLineDiscAccount)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Sales Line Disc. Account';
                    TableRelation = "G/L Account"."No.";
                }
                field("Sales Inv. Disc. Account";SalesInvDiscAccount)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Sales Inv. Disc. Account';
                    TableRelation = "G/L Account"."No.";
                }
                label(".")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    HideValue = true;
                    ShowCaption = false;
                }
                field("Purch. Account";PurchAccount)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Purch. Account';
                    TableRelation = "G/L Account"."No.";
                }
                field("Purch. Credit Memo Account";PurchCreditMemoAccount)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Purch. Credit Memo Account';
                    TableRelation = "G/L Account"."No.";
                }
                field("Purch. Line Disc. Account";PurchLineDiscAccount)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Purch. Line Disc. Account';
                    TableRelation = "G/L Account"."No.";
                }
                field("Purch. Inv. Disc. Account";PurchInvDiscAccount)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Purch. Inv. Disc. Account';
                    TableRelation = "G/L Account"."No.";
                }
                label("..")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    HideValue = true;
                    ShowCaption = false;
                }
                group(Control50)
                {
                    InstructionalText = 'When importing items, the following accounts need to be entered';
                    Visible = FirstAccountSetupVisible;
                }
                field("COGS Account";COGSAccount)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'COGS Account';
                    TableRelation = "G/L Account"."No.";
                }
                field("Inventory Adjmt. Account";InventoryAdjmtAccount)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Inventory Adjmt. Account';
                    TableRelation = "G/L Account"."No.";
                }
                field("Inventory Account";InventoryAccount)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Inventory Account';
                    TableRelation = "G/L Account"."No.";
                }
            }
            group(Control33)
            {
                InstructionalText = 'Select which accounts you want to use when posting';
                Visible = SecondAccountSetupVisible;
                group(Control32)
                {
                    InstructionalText = 'Customers';
                }
                field("Receivables Account";ReceivablesAccount)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Receivables Account';
                    TableRelation = "G/L Account"."No.";
                }
                field("Service Charge Acc.";ServiceChargeAccount)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Service Charge Acc.';
                    TableRelation = "G/L Account"."No.";
                }
                group(Control29)
                {
                    InstructionalText = 'Vendors';
                }
                field("Payables Account";PayablesAccount)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Payables Account';
                    TableRelation = "G/L Account"."No.";
                }
                field("Purch. Service Charge Acc.";PurchServiceChargeAccount)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Purch. Service Charge Acc.';
                    TableRelation = "G/L Account"."No.";
                }
            }
            group(Control9)
            {
                Visible = DoneVisible;
                group("That's it!")
                {
                    Caption = 'That''s it!';
                    InstructionalText = 'Your data has been imported.';
                    Visible = not ShowErrorsVisible;
                }
                group("Import completed with errors")
                {
                    Caption = 'Import completed with errors';
                    InstructionalText = 'There were errors during import of your data. For more details, choose Show Errors in the actions below.';
                    Visible = ShowErrorsVisible;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(ActionOpenExtensionManagement)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Open Extension Management';
                Image = Setup;
                InFooterBar = true;
                RunObject = Page "Extension Management";
                Visible = Step = Step::Intro;
            }
            action(ActionDownloadTemplate)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Download Template';
                Image = "Table";
                InFooterBar = true;
                Visible = DownloadTemplateVisible and (Step = Step::Import);

                trigger OnAction()
                var
                    Handled: Boolean;
                begin
                    OnDownloadTemplate(Handled);
                    if not Handled then
                      Error('');
                end;
            }
            action(ActionDataMigrationSettings)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Settings';
                Image = Setup;
                InFooterBar = true;
                Visible = DataMigrationSettingsVisible and (Step = Step::Import);

                trigger OnAction()
                var
                    Handled: Boolean;
                begin
                    OnOpenSettings(Handled);
                    if not Handled then
                      Error('');
                end;
            }
            action(ActionOpenAdvancedApply)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Advanced';
                Image = Apply;
                InFooterBar = true;
                Visible = OpenAdvancedApplyVisible and (Step = Step::Apply);

                trigger OnAction()
                var
                    Handled: Boolean;
                begin
                    OnOpenAdvancedApply(TempDataMigrationEntity,Handled);
                    CurrPage.DataMigrationEntities.Page.CopyToSourceTable(TempDataMigrationEntity);
                    if not Handled then
                      Error('');
                end;
            }
            action(ActionShowErrors)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Show Errors';
                Image = ErrorLog;
                InFooterBar = true;
                Visible = ShowErrorsVisible and ((Step = Step::Done) or (Step = Step::ShowPostingGroupDoneStep));

                trigger OnAction()
                var
                    Handled: Boolean;
                begin
                    OnShowErrors(Handled);
                    if not Handled then
                      Error('');
                end;
            }
            separator(Action22)
            {
            }
            action(ActionBack)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Back';
                Enabled = BackEnabled;
                Image = PreviousRecord;
                InFooterBar = true;

                trigger OnAction()
                begin
                    case Step of
                      Step::Apply:
                        TempDataMigrationEntity.DeleteAll;
                    end;
                    NextStep(true);
                end;
            }
            action(ActionNext)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Next';
                Enabled = NextEnabled;
                Image = NextRecord;
                InFooterBar = true;

                trigger OnAction()
                var
                    Handled: Boolean;
                    ListOfAccounts: array [11] of Code[20];
                begin
                    case Step of
                      Step::ChooseSource:
                        begin
                          OnGetInstructions(Instructions,Handled);
                          if not Handled then
                            Error('');
                        end;
                      Step::Import:
                        begin
                          OnValidateSettings;
                          OnDataImport(Handled);
                          if not Handled then
                            Error('');
                          OnSelectDataToApply(TempDataMigrationEntity,Handled);
                          CurrPage.DataMigrationEntities.Page.CopyToSourceTable(TempDataMigrationEntity);
                          TotalNoOfMigrationRecords := GetTotalNoOfMigrationRecords(TempDataMigrationEntity);
                          if not Handled then
                            Error('');
                        end;
                      Step::Apply:
                        begin
                          CurrPage.DataMigrationEntities.Page.CopyFromSourceTable(TempDataMigrationEntity);
                          OnApplySelectedData(TempDataMigrationEntity,Handled);
                          if not Handled then
                            Error('');
                        end;
                      Step::AccountSetup1:
                        begin
                          ListOfAccounts[1] := SalesAccount;
                          ListOfAccounts[2] := SalesCreditMemoAccount;
                          ListOfAccounts[3] := SalesLineDiscAccount;
                          ListOfAccounts[4] := SalesInvDiscAccount;
                          ListOfAccounts[5] := PurchAccount;
                          ListOfAccounts[6] := PurchCreditMemoAccount;
                          ListOfAccounts[7] := PurchLineDiscAccount;
                          ListOfAccounts[8] := PurchInvDiscAccount;
                          ListOfAccounts[9] := COGSAccount;
                          ListOfAccounts[10] := InventoryAdjmtAccount;
                          ListOfAccounts[11] := InventoryAccount;
                          OnGLPostingSetup(ListOfAccounts);
                        end;
                      Step::AccountSetup2:
                        begin
                          ListOfAccounts[1] := ReceivablesAccount;
                          ListOfAccounts[2] := ServiceChargeAccount;
                          ListOfAccounts[3] := PayablesAccount;
                          ListOfAccounts[4] := PurchServiceChargeAccount;
                          OnCustomerVendorPostingSetup(ListOfAccounts);
                        end;
                    end;
                    NextStep(false);
                end;
            }
            action(ActionFinish)
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
                    AssistedSetup.SetStatus(Page::"Data Migration Wizard",AssistedSetup.Status::Completed);
                    CurrPage.Close;
                end;
            }
        }
    }

    trigger OnInit()
    begin
        LoadTopBanners;
    end;

    trigger OnOpenPage()
    begin
        OnRegisterDataMigrator;
        if FindFirst then;
        ResetWizardControls;
        ShowIntroStep;
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    var
        AssistedSetup: Record "Assisted Setup";
    begin
        if CloseAction = Action::OK then
          if AssistedSetup.GetStatus(Page::"Data Migration Wizard") = AssistedSetup.Status::"Not Completed" then
            if not Confirm(DataImportNotCompletedQst,false) then
              Error('');
    end;

    var
        TempDataMigrationEntity: Record "Data Migration Entity" temporary;
        MediaRepositoryStandard: Record "Media Repository";
        MediaRepositoryDone: Record "Media Repository";
        Step: Option Intro,ChooseSource,Import,Apply,Done,PostingGroupIntro,AccountSetup1,AccountSetup2,ShowPostingGroupDoneStep;
        BackEnabled: Boolean;
        NextEnabled: Boolean;
        FinishEnabled: Boolean;
        TopBannerVisible: Boolean;
        IntroVisible: Boolean;
        ChooseSourceVisible: Boolean;
        ImportVisible: Boolean;
        ApplyVisible: Boolean;
        DoneVisible: Boolean;
        DataImportNotCompletedQst: label 'Data Migration has not been completed.\\Are you sure that you want to exit?';
        DownloadTemplateVisible: Boolean;
        DataMigrationSettingsVisible: Boolean;
        OpenAdvancedApplyVisible: Boolean;
        ShowErrorsVisible: Boolean;
        PostingGroupIntroVisible: Boolean;
        FirstAccountSetupVisible: Boolean;
        SecondAccountSetupVisible: Boolean;
        AccountSetupVisible: Boolean;
        Instructions: Text;
        TotalNoOfMigrationRecords: Integer;
        SalesAccount: Code[20];
        SalesCreditMemoAccount: Code[20];
        SalesLineDiscAccount: Code[20];
        SalesInvDiscAccount: Code[20];
        PurchAccount: Code[20];
        PurchCreditMemoAccount: Code[20];
        PurchLineDiscAccount: Code[20];
        PurchInvDiscAccount: Code[20];
        COGSAccount: Code[20];
        InventoryAdjmtAccount: Code[20];
        InventoryAccount: Code[20];
        ReceivablesAccount: Code[20];
        ServiceChargeAccount: Code[20];
        PayablesAccount: Code[20];
        PurchServiceChargeAccount: Code[20];

    local procedure NextStep(Backwards: Boolean)
    begin
        ResetWizardControls;

        if Backwards then
          Step := Step - 1
        else
          Step := Step + 1;

        case Step of
          Step::Intro:
            ShowIntroStep;
          Step::ChooseSource:
            ShowChooseSourceStep;
          Step::Import:
            ShowImportStep;
          Step::Apply:
            ShowApplyStep;
          Step::Done:
            ShowDoneStep;
          Step::PostingGroupIntro:
            ShowPostingGroupIntroStep;
          Step::AccountSetup1:
            ShowFirstAccountStep;
          Step::AccountSetup2:
            ShowSecondAccountStep;
          Step::ShowPostingGroupDoneStep:
            ShowPostingGroupDoneStep;
        end;
        CurrPage.Update(true);
    end;

    local procedure ShowIntroStep()
    begin
        IntroVisible := true;
        BackEnabled := false;
        PostingGroupIntroVisible := false;
    end;

    local procedure ShowChooseSourceStep()
    begin
        ChooseSourceVisible := true;
    end;

    local procedure ShowImportStep()
    begin
        ImportVisible := true;
        OnHasTemplate(DownloadTemplateVisible);
        OnHasSettings(DataMigrationSettingsVisible);
    end;

    local procedure ShowApplyStep()
    begin
        ApplyVisible := true;
        NextEnabled := TotalNoOfMigrationRecords > 0;
        OnHasAdvancedApply(OpenAdvancedApplyVisible);
    end;

    local procedure ShowDoneStep()
    begin
        DoneVisible := true;
        NextEnabled := false;
        FinishEnabled := true;
        BackEnabled := false;
        OnPostingGroupSetup(AccountSetupVisible);
        if AccountSetupVisible then begin
          TempDataMigrationEntity.Reset;
          TempDataMigrationEntity.SetRange("Table ID",15);
          TempDataMigrationEntity.SetRange(Selected,true);
          if TempDataMigrationEntity.FindFirst then begin
            DoneVisible := false;
            NextEnabled := true;
            FinishEnabled := false;
            NextStep(false);
          end;
        end;
        OnHasErrors(ShowErrorsVisible);
    end;

    local procedure ShowPostingGroupIntroStep()
    begin
        DoneVisible := false;
        BackEnabled := false;
        NextEnabled := true;
        PostingGroupIntroVisible := true;
        FirstAccountSetupVisible := false;
        SecondAccountSetupVisible := false;
        FinishEnabled := false;
    end;

    local procedure ShowFirstAccountStep()
    begin
        DoneVisible := false;
        BackEnabled := false;
        NextEnabled := true;
        FirstAccountSetupVisible := true;
        SecondAccountSetupVisible := false;
        PostingGroupIntroVisible := false;
        FinishEnabled := false;
    end;

    local procedure ShowSecondAccountStep()
    begin
        DoneVisible := false;
        BackEnabled := true;
        NextEnabled := true;
        PostingGroupIntroVisible := false;
        FirstAccountSetupVisible := false;
        SecondAccountSetupVisible := true;
        FinishEnabled := false;
    end;

    local procedure ResetWizardControls()
    begin
        // Buttons
        BackEnabled := true;
        NextEnabled := true;
        FinishEnabled := false;
        DownloadTemplateVisible := false;
        DataMigrationSettingsVisible := false;
        OpenAdvancedApplyVisible := false;
        ShowErrorsVisible := false;
        PostingGroupIntroVisible := false;
        FirstAccountSetupVisible := false;
        SecondAccountSetupVisible := false;

        // Tabs
        IntroVisible := false;
        ChooseSourceVisible := false;
        ImportVisible := false;
        ApplyVisible := false;
        DoneVisible := false;
    end;

    local procedure GetTotalNoOfMigrationRecords(var DataMigrationEntity: Record "Data Migration Entity") TotalCount: Integer
    begin
        if DataMigrationEntity.FindSet then
          repeat
            TotalCount += DataMigrationEntity."No. of Records";
          until DataMigrationEntity.Next = 0;
    end;

    local procedure LoadTopBanners()
    begin
        if MediaRepositoryStandard.Get('AssistedSetup-NoText-400px.png',Format(CurrentClientType)) and
           MediaRepositoryDone.Get('AssistedSetupDone-NoText-400px.png',Format(CurrentClientType))
        then
          TopBannerVisible := MediaRepositoryDone.Image.Hasvalue;
    end;

    local procedure ShowPostingGroupDoneStep()
    begin
        DoneVisible := true;
        BackEnabled := false;
        NextEnabled := false;
        OnHasErrors(ShowErrorsVisible);
        FinishEnabled := true;
    end;
}

