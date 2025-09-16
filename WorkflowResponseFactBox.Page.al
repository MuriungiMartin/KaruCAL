#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1525 "Workflow Response FactBox"
{
    Caption = 'Workflow Response FactBox';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = "Workflow Step Buffer";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Response Description";"Response Description")
                {
                    ApplicationArea = Suite;
                    ShowCaption = false;
                    ToolTip = 'Specifies the workflow response.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnFindRecord(Which: Text): Boolean
    var
        CurrFilterGroup: Integer;
    begin
        CurrFilterGroup := FilterGroup(0);
        SetRange("Parent Event Step ID");
        SetRange("Workflow Code");
        FilterGroup(4);
        if (ParentEventStepID <> GetRangemax("Parent Event Step ID")) or (WorkflowCode <> GetRangemax("Workflow Code")) then begin
          ParentEventStepID := GetRangemax("Parent Event Step ID");
          WorkflowCode := GetRangemax("Workflow Code");
          ClearBuffer;
        end;
        FilterGroup(CurrFilterGroup);

        if IsEmpty then
          PopulateTableFromEvent(WorkflowCode,ParentEventStepID);

        exit(Find(Which));
    end;

    var
        ParentEventStepID: Integer;
        WorkflowCode: Code[20];


    procedure UpdateData()
    begin
        if (ParentEventStepID = 0) or (WorkflowCode = '') then
          exit;

        ClearBuffer;
        PopulateTableFromEvent(WorkflowCode,ParentEventStepID);
        CurrPage.Update(false);
    end;
}

