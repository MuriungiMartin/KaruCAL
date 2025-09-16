#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 968 "Time Sheet Line Assemb. Detail"
{
    Caption = 'Time Sheet Line Assemb. Detail';
    Editable = false;
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
                field("Assembly Order No.";"Assembly Order No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the assembly order number that is associated with the time sheet line.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies a description of the time sheet line.';
                }
                field(Chargeable;Chargeable)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies if the usage that you are posting is chargeable.';
                }
            }
        }
    }

    actions
    {
    }


    procedure SetParameters(TimeSheetLine: Record "Time Sheet Line")
    begin
        Rec := TimeSheetLine;
        Insert;
    end;
}

