#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 966 "Time Sheet Line Job Detail"
{
    Caption = 'Time Sheet Line Job Detail';
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
                field("Job No.";"Job No.")
                {
                    ApplicationArea = Jobs;
                    Editable = AllowEdit;
                    ToolTip = 'Specifies the number for the job associated with the time sheet line.';
                }
                field("Job Task No.";"Job Task No.")
                {
                    ApplicationArea = Jobs;
                    Editable = AllowEdit;
                    ToolTip = 'Specifies the number for the job task associated with the time sheet line.';
                }
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
                field(Chargeable;Chargeable)
                {
                    ApplicationArea = Jobs;
                    Editable = ChargeableAllowEdit;
                    ToolTip = 'Specifies if the usage that you are posting is chargeable.';
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
        ChargeableAllowEdit := GetAllowEdit(FieldNo(Chargeable),ManagerRole);
    end;

    var
        ManagerRole: Boolean;
        AllowEdit: Boolean;
        WorkTypeCodeAllowEdit: Boolean;
        ChargeableAllowEdit: Boolean;


    procedure SetParameters(TimeSheetLine: Record "Time Sheet Line";NewManagerRole: Boolean)
    begin
        Rec := TimeSheetLine;
        Insert;
        ManagerRole := NewManagerRole;
    end;
}

