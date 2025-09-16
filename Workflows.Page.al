#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1500 Workflows
{
    ApplicationArea = Basic;
    Caption = 'Workflows';
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Manage';
    RefreshOnActivate = true;
    SourceTable = "Workflow Buffer";
    SourceTableTemporary = true;
    SourceTableView = where(Template=const(false));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                IndentationColumn = Indentation;
                IndentationControls = Description;
                ShowAsTree = true;
                field(Description;Description)
                {
                    ApplicationArea = Suite;
                    StyleExpr = DescriptionStyle;
                    ToolTip = 'Specifies a description of the workflow.';
                }
                field("Category Code";"Category Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'This field is used internally.';
                    Visible = false;
                }
                field("Workflow Code";"Workflow Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'This field is used internally.';
                    Visible = false;
                }
                field(Enabled;Enabled)
                {
                    ApplicationArea = Suite;
                    BlankZero = true;
                    ToolTip = 'Specifies if the workflow is enabled.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control7;Notes)
            {
                Visible = false;
            }
            systempart(Control8;Links)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(New)
            {
                Caption = 'New';
                action(NewAction)
                {
                    ApplicationArea = Suite;
                    Caption = 'New';
                    Image = NewDocument;
                    Promoted = true;
                    PromotedCategory = New;
                    PromotedIsBig = true;
                    ToolTip = 'Create a new workflow.';

                    trigger OnAction()
                    var
                        Workflow: Record Workflow;
                        WorkflowPage: Page Workflow;
                    begin
                        if IsEmpty then begin
                          Clear(Rec);
                          Insert;
                        end;
                        Workflow.SetRange(Template,false);
                        if Workflow.IsEmpty then
                          Workflow.Insert;
                        Workflow.FilterGroup := 2;
                        WorkflowPage.SetOpenNew(true);
                        WorkflowPage.SetTableview(Workflow);
                        WorkflowPage.SetRecord(Workflow);
                        WorkflowPage.Run;
                    end;
                }
                action(CopyFromTemplate)
                {
                    ApplicationArea = Suite;
                    Caption = 'New Workflow from Template';
                    Image = Copy;
                    Promoted = true;
                    PromotedCategory = New;
                    PromotedIsBig = true;
                    ToolTip = 'Create a new workflow quickly using a template.';

                    trigger OnAction()
                    var
                        TempWorkflowBuffer: Record "Workflow Buffer" temporary;
                    begin
                        if IsEmpty then begin
                          Clear(Rec);
                          Insert;
                        end;
                        if Page.RunModal(Page::"Workflow Templates",TempWorkflowBuffer) = Action::LookupOK then begin
                          CopyWorkflow(TempWorkflowBuffer);

                          // If first workflow on an empty page
                          if Count = 1 then
                            Rec := TempWorkflowBuffer;

                          RefreshTempWorkflowBuffer;
                        end;
                    end;
                }
                action(CopyWorkflow)
                {
                    ApplicationArea = Suite;
                    Caption = 'Copy Workflow';
                    Enabled = "Workflow Code" <> '';
                    Image = Copy;
                    Promoted = true;
                    PromotedCategory = New;
                    PromotedIsBig = true;
                    ToolTip = 'Copy an existing workflow.';

                    trigger OnAction()
                    begin
                        CopyWorkflow(Rec);
                    end;
                }
            }
            group(Manage)
            {
                Caption = 'Manage';
                action(EditAction)
                {
                    ApplicationArea = Suite;
                    Caption = 'Edit';
                    Enabled = "Workflow Code" <> '';
                    Image = Edit;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ShortCutKey = 'Return';
                    ToolTip = 'Edit an existing workflow.';

                    trigger OnAction()
                    var
                        Workflow: Record Workflow;
                    begin
                        if Workflow.Get("Workflow Code") then
                          Page.Run(Page::Workflow,Workflow);
                    end;
                }
                action(ViewAction)
                {
                    ApplicationArea = Suite;
                    Caption = 'View';
                    Enabled = "Workflow Code" <> '';
                    Image = View;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'View an existing workflow.';

                    trigger OnAction()
                    var
                        Workflow: Record Workflow;
                        WorkflowPage: Page Workflow;
                    begin
                        Workflow.Get("Workflow Code");
                        WorkflowPage.SetRecord(Workflow);
                        WorkflowPage.SetOpenView(true);
                        WorkflowPage.Run;
                    end;
                }
                action(DeleteAction)
                {
                    ApplicationArea = Suite;
                    Caption = 'Delete';
                    Enabled = "Workflow Code" <> '';
                    Image = Delete;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Delete the record.';

                    trigger OnAction()
                    begin
                        Delete(true);
                        CurrPage.Update(false);
                    end;
                }
            }
            group(Process)
            {
                Caption = 'Process';
                action(ImportWorkflow)
                {
                    ApplicationArea = Suite;
                    Caption = 'Import from File';
                    Image = Import;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Import workflow from a file.';

                    trigger OnAction()
                    var
                        Workflow: Record Workflow;
                        TempBlob: Record TempBlob;
                        FileManagement: Codeunit "File Management";
                    begin
                        if FileManagement.BLOBImport(TempBlob,'') <> '' then begin
                          Workflow.ImportFromBlob(TempBlob);
                          RefreshTempWorkflowBuffer;
                        end;
                    end;
                }
                action(ExportWorkflow)
                {
                    ApplicationArea = Suite;
                    Caption = 'Export to File';
                    Enabled = ExportEnabled;
                    Image = Export;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Export the workflow to a file that can be imported in another Dynamics NAV database.';

                    trigger OnAction()
                    var
                        Workflow: Record Workflow;
                        TempBlob: Record TempBlob;
                        FileManagement: Codeunit "File Management";
                        "Filter": Text;
                    begin
                        Filter := GetFilterFromSelection;
                        if Filter = '' then
                          exit;
                        Workflow.SetFilter(Code,Filter);
                        Workflow.ExportToBlob(TempBlob);
                        FileManagement.BLOBExport(TempBlob,'*.xml',true);
                    end;
                }
            }
        }
        area(navigation)
        {
            action(ViewTemplates)
            {
                ApplicationArea = Suite;
                Caption = 'View Templates';
                Ellipsis = true;
                Image = ViewPage;
                RunObject = Page "Workflow Templates";
                ToolTip = 'View the existing workflow templates.';
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        RefreshTempWorkflowBufferRow;
    end;

    trigger OnAfterGetRecord()
    begin
        RefreshTempWorkflowBuffer;
        ExportEnabled := not IsEmpty;
        if "Workflow Code" = '' then
          DescriptionStyle := 'Strong'
        else
          DescriptionStyle := 'Standard';
    end;

    trigger OnOpenPage()
    begin
        WorkflowSetup.InitWorkflow;
        if not WorkflowBufferInitialized then
          InitBufferForWorkflows(Rec);
    end;

    var
        WorkflowSetup: Codeunit "Workflow Setup";
        DescriptionStyle: Text;
        ExportEnabled: Boolean;
        Refresh: Boolean;
        WorkflowBufferInitialized: Boolean;

    local procedure RefreshTempWorkflowBuffer()
    var
        Workflow: Record Workflow;
        TempWorkflowBuffer: Record "Workflow Buffer" temporary;
        WorkflowCode: Code[20];
        CurrentWorkflowChanged: Boolean;
        WorkflowCountChanged: Boolean;
    begin
        WorkflowCode := "Workflow Code";
        if Workflow.Get(WorkflowCode) then
          CurrentWorkflowChanged := ("Category Code" <> Workflow.Category) or (Description <> Workflow.Description)
        else
          CurrentWorkflowChanged := WorkflowCode <> '';

        Workflow.SetRange(Template,false);

        TempWorkflowBuffer.Copy(Rec,true);
        TempWorkflowBuffer.Reset;
        TempWorkflowBuffer.SetFilter("Workflow Code",'<>%1','');
        TempWorkflowBuffer.SetRange(Template,false);

        WorkflowCountChanged := Workflow.Count <> TempWorkflowBuffer.Count;

        if CurrentWorkflowChanged or WorkflowCountChanged then begin
          InitBufferForWorkflows(Rec);
          Refresh := true;
        end;
    end;

    local procedure RefreshTempWorkflowBufferRow()
    var
        Workflow: Record Workflow;
    begin
        if Refresh then begin
          CurrPage.Update(false);
          Refresh := false;
          exit;
        end;

        if "Workflow Code" = '' then
          exit;

        Workflow.Get("Workflow Code");
        "Category Code" := Workflow.Category;
        Description := Workflow.Description;
        Modify;
    end;

    local procedure GetFilterFromSelection() "Filter": Text
    var
        TempWorkflowBuffer: Record "Workflow Buffer" temporary;
    begin
        TempWorkflowBuffer.Copy(Rec,true);
        CurrPage.SetSelectionFilter(TempWorkflowBuffer);

        if TempWorkflowBuffer.FindSet then
          repeat
            if TempWorkflowBuffer."Workflow Code" <> '' then
              if Filter = '' then
                Filter := TempWorkflowBuffer."Workflow Code"
              else
                Filter := StrSubstNo('%1|%2',Filter,TempWorkflowBuffer."Workflow Code");
          until TempWorkflowBuffer.Next = 0;
    end;


    procedure SetWorkflowBufferRec(var TempWorkflowBuffer: Record "Workflow Buffer" temporary)
    begin
        WorkflowBufferInitialized := true;
        InitBufferForWorkflows(Rec);
        CopyFilters(TempWorkflowBuffer);
        if StrLen(GetFilter("Workflow Code")) > 0 then
          SetFilter("Workflow Code",TempWorkflowBuffer.GetFilter("Workflow Code") + '|''''');
        if FindLast then;
    end;
}

