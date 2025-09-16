#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 965 "Time Sheet Line Res. Detail"
{
    Caption = 'Time Sheet Line Res. Detail';
    PageType = StandardDialog;
    SourceTable = "Time Sheet Line";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(Description;Description)
                {
                    ApplicationArea = Jobs;
                    Editable = AllowEdit;
                    ToolTip = 'Specifies a description of the time sheet line.';
                }
                field("Work Type Code";"Work Type Code")
                {
                    ApplicationArea = Jobs;
                    Editable = WorkTypeCodeAllowEdit;
                    ToolTip = 'Specifies which work type the resource applies to. Prices are updated based on this entry.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
        AllowEdit := GetAllowEdit(0,ManagerRole);
        WorkTypeCodeAllowEdit := GetAllowEdit(FieldNo("Work Type Code"),ManagerRole);
    end;

    var
        ManagerRole: Boolean;
        AllowEdit: Boolean;
        WorkTypeCodeAllowEdit: Boolean;


    procedure SetParameters(TimeSheetLine: Record "Time Sheet Line";NewManagerRole: Boolean)
    begin
        Rec := TimeSheetLine;
        Insert;
        ManagerRole := NewManagerRole;
    end;
}

