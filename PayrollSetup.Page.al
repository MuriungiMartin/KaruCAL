#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1660 "Payroll Setup"
{
    Caption = 'Payroll Setup';
    PageType = Card;
    SourceTable = "Payroll Setup";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("User Name";"User Name")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the user account.';
                }
                field("General Journal Template Name";"General Journal Template Name")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the name of the general journal template that is used for import.';
                }
                field("General Journal Batch Name";"General Journal Batch Name")
                {
                    ApplicationArea = Basic,Suite;
                    Enabled = Show;
                    ToolTip = 'Specifies the name of the general journal batch that is used for import.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    var
        PayrollManagement: Codeunit "Payroll Management";
    begin
        Show := PayrollManagement.ShowPayrollForTestInNonSaas;
        if not Show then
          Show := true
    end;

    var
        Show: Boolean;
}

