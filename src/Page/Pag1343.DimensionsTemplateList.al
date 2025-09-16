#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1343 "Dimensions Template List"
{
    Caption = 'Dimension Templates';
    PageType = List;
    SourceTable = "Dimensions Template";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Dimension Code";"Dimension Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the code for the default dimension.';
                }
                field("Dimension Value Code";"Dimension Value Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the dimension value code to suggest as the default dimension.';
                }
                field("<Dimension Value Code>";"Value Posting")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies how default dimensions and their values must be used.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    var
        TempDimensionsTemplate: Record "Dimensions Template" temporary;
        MasterRecordCodeFilter: Text;
        MasterRecordCodeWithRightLenght: Code[10];
        TableFilterId: Text;
        TableID: Integer;
    begin
        MasterRecordCodeFilter := GetFilter("Master Record Template Code");
        TableFilterId := GetFilter("Table Id");

        if (MasterRecordCodeFilter = '') or (TableFilterId = '') then
          Error(CannotRunPageDirectlyErr);

        MasterRecordCodeWithRightLenght := CopyStr(MasterRecordCodeFilter,1,10);
        Evaluate(TableID,TableFilterId);

        TempDimensionsTemplate.InitializeTemplatesFromMasterRecordTemplate(MasterRecordCodeWithRightLenght,Rec,TableID);
    end;

    var
        CannotRunPageDirectlyErr: label 'This page cannot be run directly. You must open it with the action on the appropriate page.';
}

