#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1340 "Config Templates"
{
    ApplicationArea = Basic;
    Caption = 'Templates';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Manage';
    SourceTable = "Config. Template Header";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater("Repeater")
            {
                field(Template;Code)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the configuration template.';
                }
                field("Template Name";Description)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a description of the template.';
                }
                field(Enabled;Enabled)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies if the template is ready to be used';
                    Visible = not NewMode;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(NewCustomerTemplate)
            {
                ApplicationArea = All;
                Caption = 'New';
                Image = NewDocument;
                RunObject = Page "Cust. Template Card";
                RunPageMode = Create;
                ToolTip = 'Create a new template for a customer card.';
                Visible = CreateCustomerActionVisible;
            }
            action(NewVendorTemplate)
            {
                ApplicationArea = All;
                Caption = 'New';
                Image = NewDocument;
                RunObject = Page "Vendor Template Card";
                RunPageMode = Create;
                ToolTip = 'Create a new template for a vendor card.';
                Visible = CreateVendorActionVisible;
            }
            action(NewItemTemplate)
            {
                ApplicationArea = All;
                Caption = 'New';
                Image = NewDocument;
                RunObject = Page "Item Template Card";
                RunPageMode = Create;
                ToolTip = 'Create a new template for an item card.';
                Visible = CreateItemActionVisible;
            }
            action(NewConfigTemplate)
            {
                ApplicationArea = All;
                Caption = 'New';
                Image = NewDocument;
                RunObject = Page "Config. Template Header";
                RunPageMode = Create;
                ToolTip = 'Create a new configuration template.';
                Visible = CreateConfigurationTemplateActionVisible;
            }
        }
        area(processing)
        {
            action("Edit Template")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Edit';
                Image = Edit;
                Scope = Repeater;
                ShortCutKey = 'Return';
                ToolTip = 'Edit the selected template.';

                trigger OnAction()
                var
                    TempMiniCustomerTemplate: Record "Mini Customer Template" temporary;
                    TempItemTemplate: Record "Item Template" temporary;
                    TempMiniVendorTemplate: Record "Mini Vendor Template" temporary;
                begin
                    case "Table ID" of
                      Database::Customer:
                        begin
                          TempMiniCustomerTemplate.InitializeTempRecordFromConfigTemplate(TempMiniCustomerTemplate,Rec);
                          Page.Run(Page::"Cust. Template Card",TempMiniCustomerTemplate);
                        end;
                      Database::Item:
                        begin
                          TempItemTemplate.InitializeTempRecordFromConfigTemplate(TempItemTemplate,Rec);
                          Page.Run(Page::"Item Template Card",TempItemTemplate);
                        end;
                      Database::Vendor:
                        begin
                          TempMiniVendorTemplate.InitializeTempRecordFromConfigTemplate(TempMiniVendorTemplate,Rec);
                          Page.Run(Page::"Vendor Template Card",TempMiniVendorTemplate);
                        end;
                      else
                        Page.Run(Page::"Config. Template Header",Rec);
                    end;
                end;
            }
            action(Delete)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Delete';
                Image = Delete;
                ToolTip = 'Delete the selected template.';

                trigger OnAction()
                begin
                    if Confirm(StrSubstNo(DeleteQst,Code)) then
                      Delete(true);
                end;
            }
        }
    }

    trigger OnDeleteRecord(): Boolean
    begin
        case "Table ID" of
          Database::Customer,
          Database::Item:
            ConfigTemplateManagement.DeleteRelatedTemplates(Code,Database::"Default Dimension");
        end;
    end;

    trigger OnOpenPage()
    var
        FilterValue: Text;
    begin
        FilterValue := GetFilter("Table ID");

        if not Evaluate(FilteredTableId,FilterValue) then
          FilteredTableId := 0;

        UpdateActionsVisibility;
        UpdatePageCaption;

        if NewMode then
          UpdateSelection;
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        if NewMode and (CloseAction = Action::LookupOK) then
          SaveSelection;
    end;

    var
        ConfigTemplateManagement: Codeunit "Config. Template Management";
        CreateCustomerActionVisible: Boolean;
        CreateVendorActionVisible: Boolean;
        CreateItemActionVisible: Boolean;
        CreateConfigurationTemplateActionVisible: Boolean;
        NewMode: Boolean;
        FilteredTableId: Integer;
        ConfigurationTemplatesCap: label 'Configuration Templates';
        CustomerTemplatesCap: label 'Customer Templates';
        VendorTemplatesCap: label 'Vendor Templates';
        ItemTemplatesCap: label 'Item Templates';
        SelectConfigurationTemplatesCap: label 'Select a template';
        SelectCustomerTemplatesCap: label 'Select a template for a new customer';
        SelectVendorTemplatesCap: label 'Select a template for a new vendor';
        SelectItemTemplatesCap: label 'Select a template for a new item';
        DeleteQst: label 'Delete %1?', Comment='%1 - configuration template code';

    local procedure UpdateActionsVisibility()
    begin
        CreateCustomerActionVisible := false;
        CreateItemActionVisible := false;
        CreateConfigurationTemplateActionVisible := false;
        CreateVendorActionVisible := false;

        case FilteredTableId of
          Database::Customer:
            CreateCustomerActionVisible := true;
          Database::Item:
            CreateItemActionVisible := true;
          Database::Vendor:
            CreateVendorActionVisible := true;
          else
            CreateConfigurationTemplateActionVisible := true;
        end;
    end;

    local procedure UpdatePageCaption()
    var
        PageCaption: Text;
    begin
        if not NewMode then
          case FilteredTableId of
            Database::Customer:
              PageCaption := CustomerTemplatesCap;
            Database::Vendor:
              PageCaption := VendorTemplatesCap;
            Database::Item:
              PageCaption := ItemTemplatesCap;
            else
              PageCaption := ConfigurationTemplatesCap;
          end
        else
          case FilteredTableId of
            Database::Customer:
              PageCaption := SelectCustomerTemplatesCap;
            Database::Vendor:
              PageCaption := SelectVendorTemplatesCap;
            Database::Item:
              PageCaption := SelectItemTemplatesCap;
            else
              PageCaption := SelectConfigurationTemplatesCap;
          end;

        CurrPage.Caption(PageCaption);
    end;

    local procedure UpdateSelection()
    var
        ConfigTemplateHeader: Record "Config. Template Header";
        TemplateSelectionMgt: Codeunit "Template Selection Mgt.";
        TemplateCode: Code[10];
    begin
        case FilteredTableId of
          Database::Customer:
            TemplateSelectionMgt.GetLastCustTemplateSelection(TemplateCode);
          Database::Vendor:
            TemplateSelectionMgt.GetLastVendorTemplateSelection(TemplateCode);
          Database::Item:
            TemplateSelectionMgt.GetLastItemTemplateSelection(TemplateCode);
        end;

        if not (TemplateCode = '') then
          if ConfigTemplateHeader.Get(TemplateCode) then
            SetPosition(ConfigTemplateHeader.GetPosition);
    end;

    local procedure SaveSelection()
    var
        TemplateSelectionMgt: Codeunit "Template Selection Mgt.";
    begin
        case FilteredTableId of
          Database::Customer:
            TemplateSelectionMgt.SaveCustTemplateSelectionForCurrentUser(Code);
          Database::Vendor:
            TemplateSelectionMgt.SaveVendorTemplateSelectionForCurrentUser(Code);
          Database::Item:
            TemplateSelectionMgt.SaveItemTemplateSelectionForCurrentUser(Code);
        end;
    end;


    procedure SetNewMode()
    begin
        NewMode := true;
    end;
}

