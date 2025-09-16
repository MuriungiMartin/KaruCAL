#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1529 "Workflow Overview"
{
    Caption = 'Workflow Overview';
    DataCaptionFields = "Workflow Code","Record ID";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    ShowFilter = false;
    SourceTable = "Workflow Step Instance";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                IndentationColumn = Indent;
                IndentationControls = Description;
                field(Description;Description)
                {
                    ApplicationArea = Suite;
                    Caption = 'Workflow Step';
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the workflow step instance.';
                }
                field(Status;Status)
                {
                    ApplicationArea = Suite;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the status of the workflow step instance. Active means that the step instance in ongoing. Completed means that the workflow step instance is done. Ignored means that the workflow step instance was skipped in favor of another path.';
                }
                field("Last Modified Date-Time";"Last Modified Date-Time")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the date and time when a user last participated in the workflow step instance.';
                }
                field("Last Modified By User ID";"Last Modified By User ID")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the user who last participated in the workflow step instance.';
                }
                field(WorkflowRecord;WorkflowRecord)
                {
                    ApplicationArea = Basic;
                    Caption = 'Record';
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
        UpdatePageControls;
    end;

    trigger OnAfterGetRecord()
    begin
        UpdatePageControls;
    end;

    var
        StyleTxt: Text;
        WorkflowRecord: Text;
        Indent: Integer;

    local procedure GetDescription(): Text
    var
        WorkflowEvent: Record "Workflow Event";
        WorkflowStepArgument: Record "Workflow Step Argument";
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
    begin
        case Type of
          Type::"Event":
            begin
              if WorkflowEvent.Get("Function Name") then
                exit(WorkflowEvent.Description);
            end;
          Type::Response:
            begin
              if WorkflowStepArgument.Get(Argument) then
                exit(WorkflowResponseHandling.GetDescription(WorkflowStepArgument));
            end;
        end;
        exit('');
    end;

    local procedure GetStyle(): Text
    begin
        case Status of
          Status::Completed:
            exit('Favorable');
          Status::Active:
            exit('');
          else
            exit('Subordinate');
        end;
    end;

    local procedure UpdatePageControls()
    begin
        if Type = Type::"Event" then
          Indent := 0
        else
          Indent := 2;

        Description := CopyStr(GetDescription,1,MaxStrLen(Description));
        StyleTxt := GetStyle;
        WorkflowRecord := Format("Record ID",0,1);
    end;
}

