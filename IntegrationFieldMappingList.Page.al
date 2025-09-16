#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5361 "Integration Field Mapping List"
{
    Caption = 'Integration Field Mapping List';
    DataCaptionExpression = "Integration Table Mapping Name";
    Editable = false;
    PageType = List;
    SourceTable = "Integration Field Mapping";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Field No.";"Field No.")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    ToolTip = 'Specifies the number of the field in Dynamics NAV.';
                }
                field(FieldName;NAVFieldName)
                {
                    ApplicationArea = Basic;
                    Caption = 'Field Name';
                    ToolTip = 'Specifies the name of the field in Dynamics NAV.';
                }
                field("Integration Table Field No.";"Integration Table Field No.")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    ToolTip = 'Specifies the number of the field in Dynamics CRM.';
                }
                field(IntegrationFieldName;CRMFieldName)
                {
                    ApplicationArea = Basic;
                    Caption = 'Integration Field Name';
                    ToolTip = 'Specifies the name of the field in Dynamics CRM.';
                }
                field(Direction;Direction)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the direction of the synchronization.';
                }
                field("Constant Value";"Constant Value")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the constant value that the mapped field will be set to.';
                }
                field("Validate Field";"Validate Field")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if the field should be validated during assignment in Dynamics NAV. ';
                }
                field("Validate Integration Table Fld";"Validate Integration Table Fld")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if the integration field should be validated during assignment in Dynamics CRM.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        GetFieldCaptions;
    end;

    var
        NAVFieldName: Text;
        CRMFieldName: Text;

    local procedure GetFieldCaptions()
    var
        IntegrationTableMapping: Record "Integration Table Mapping";
    begin
        IntegrationTableMapping.Get("Integration Table Mapping Name");
        NAVFieldName := GetFieldCaption(IntegrationTableMapping."Table ID","Field No.");
        CRMFieldName := GetFieldCaption(IntegrationTableMapping."Integration Table ID","Integration Table Field No.");
    end;

    local procedure GetFieldCaption(TableID: Integer;FieldID: Integer): Text
    var
        "Field": Record "Field";
    begin
        if (TableID <> 0) and (FieldID <> 0) then
          if Field.Get(TableID,FieldID) then
            exit(Field."Field Caption");
        exit('');
    end;
}

