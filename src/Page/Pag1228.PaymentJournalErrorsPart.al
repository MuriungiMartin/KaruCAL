#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1228 "Payment Journal Errors Part"
{
    Caption = 'Payment Journal Errors Part';
    Editable = false;
    PageType = ListPart;
    SourceTable = "Payment Jnl. Export Error Text";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Error Text";"Error Text")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDown = true;
                    ToolTip = 'Specifies the error that is shown in the Payment Journal window in case payment lines cannot be exported.';

                    trigger OnDrillDown()
                    begin
                        Page.RunModal(Page::"Payment File Error Details",Rec);
                    end;
                }
            }
        }
    }

    actions
    {
    }
}

