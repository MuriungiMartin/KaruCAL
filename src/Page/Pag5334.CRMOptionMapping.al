#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5334 "CRM Option Mapping"
{
    Caption = 'CRM Option Mapping';
    Editable = false;
    PageType = List;
    ShowFilter = false;
    SourceTable = "CRM Option Mapping";
    SourceTableView = sorting("Integration Table ID","Integration Field ID","Option Value");

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Record";RecordIDText)
                {
                    ApplicationArea = Suite;
                    Caption = 'Record';
                    ToolTip = 'Specifies the record in Dynamics NAV that is mapped to the option value in Dynamics CRM.';
                }
                field("Option Value";"Option Value")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the numeric value of the mapped option value in Dynamics CRM.';
                }
                field("Option Value Caption";"Option Value Caption")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the caption of the mapped option value in Dynamics CRM.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        RecordIDText := Format("Record ID");
    end;

    var
        RecordIDText: Text;
}

