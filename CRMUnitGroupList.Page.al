#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5362 "CRM UnitGroup List"
{
    ApplicationArea = Basic;
    Caption = 'Microsoft Dynamics CRM Unit Groups';
    Editable = false;
    PageType = List;
    SourceTable = "CRM Uomschedule";
    SourceTableView = sorting(Name);
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                field(Name;Name)
                {
                    ApplicationArea = Suite;
                    Caption = 'Name';
                    StyleExpr = FirstColumnStyle;
                    ToolTip = 'Specifies the name of the record.';
                }
                field(BaseUoMName;BaseUoMName)
                {
                    ApplicationArea = Suite;
                    Caption = 'Base Unit Name';
                    ToolTip = 'Specifies the base unit of measure of the Dynamics CRM record.';
                }
                field(StateCode;StateCode)
                {
                    ApplicationArea = Suite;
                    Caption = 'Status';
                }
                field(StatusCode;StatusCode)
                {
                    ApplicationArea = Suite;
                    Caption = 'Status Reason';
                }
                field(Coupled;Coupled)
                {
                    ApplicationArea = Suite;
                    Caption = 'Coupled';
                    ToolTip = 'Specifies if the Dynamics CRM record is coupled to Dynamics NAV.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    var
        CRMIntegrationRecord: Record "CRM Integration Record";
        RecordID: RecordID;
    begin
        if CRMIntegrationRecord.FindRecordIDFromID(UoMScheduleId,Database::"Unit of Measure",RecordID) then
          if CurrentlyCoupledCRMUomschedule.UoMScheduleId = UoMScheduleId then begin
            Coupled := 'Current';
            FirstColumnStyle := 'Strong';
          end else begin
            Coupled := 'Yes';
            FirstColumnStyle := 'Subordinate';
          end
        else begin
          Coupled := 'No';
          FirstColumnStyle := 'None';
        end;
    end;

    trigger OnInit()
    begin
        Codeunit.Run(Codeunit::"CRM Integration Management");
    end;

    var
        CurrentlyCoupledCRMUomschedule: Record "CRM Uomschedule";
        Coupled: Text;
        FirstColumnStyle: Text;


    procedure SetCurrentlyCoupledCRMUomschedule(CRMUomschedule: Record "CRM Uomschedule")
    begin
        CurrentlyCoupledCRMUomschedule := CRMUomschedule;
    end;
}

