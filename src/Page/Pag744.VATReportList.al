#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 744 "VAT Report List"
{
    Caption = 'Tax Report List';
    CardPageID = "VAT Report";
    Editable = false;
    PageType = List;
    SourceTable = "VAT Report Header";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the unique number for the tax report.';
                }
                field("VAT Report Config. Code";"VAT Report Config. Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the appropriate configuration code.';
                }
                field("VAT Report Type";"VAT Report Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies if the tax report is a standard report, or if it is related to a previously submitted tax report.';
                }
                field("Start Date";"Start Date")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the start date of the report period for the tax report.';
                }
                field("End Date";"End Date")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the end date of the report period for the tax report.';
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the status of the tax report.';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action(Card)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Card';
                    Image = EditLines;
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'View or change detailed information about the Tax report.';

                    trigger OnAction()
                    begin
                        Page.Run(Page::"VAT Report",Rec);
                    end;
                }
            }
        }
    }
}

