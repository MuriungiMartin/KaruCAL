#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 10015 "IRS 1099 Form-Box"
{
    ApplicationArea = Basic;
    Caption = 'IRS 1099 Form-Box';
    PageType = List;
    SourceTable = UnknownTable10010;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the 1099 form and the 1099 box.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a description of the 1099 code.';
                }
                field("Minimum Reportable";"Minimum Reportable")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the minimum value for this box that must be reported to the IRS on a 1099 form.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Update Form Boxes")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Update Form Boxes';
                Image = "1099Form";
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Update the form boxes in the report to map to changed codes in the related table.';

                trigger OnAction()
                begin
                    if not Confirm(DeleteLinesQst,true) then
                      Error('');
                    DeleteAll;
                    InitIRS1099FormBoxes;
                end;
            }
            action("Vendor 1099 Magnetic Media")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Vendor 1099 Magnetic Media';
                Image = Export1099;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Report "Vendor 1099 Magnetic Media";
                ToolTip = 'View the 1099 forms that can be exported. The form information exported by this report is the same as the reports that print 1099 forms. These reports include Vendor 1099 Div, Vendor 1099 Int, and Vendor 1099 Misc.';
            }
        }
        area(reporting)
        {
            action("Vendor 1099 Div")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Vendor 1099 Div';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Vendor 1099 Div";
                ToolTip = 'View the federal form 1099-DIV for dividends and distribution.';
            }
            action("Vendor 1099 Int")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Vendor 1099 Int';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Vendor 1099 Int";
                ToolTip = 'View the federal form 1099-INT for interest income.';
            }
            action("Vendor 1099 Misc")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Vendor 1099 Misc';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Vendor 1099 Misc";
                ToolTip = 'View the federal form 1099-MISC for miscellaneous income.';
            }
            action("Vendor 1099 Information")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Vendor 1099 Information';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Vendor 1099 Information";
                ToolTip = 'View the vendors'' 1099 information. The report includes all 1099 information for the vendors that have been set up using the IRS 1099 Form-Box table. This includes only amounts that have been paid. It does not include amounts billed but not yet paid. You must enter a date filter before you can print this report.';
            }
        }
    }

    var
        DeleteLinesQst: label 'If you proceed, all existing entries will be deleted and recreated. Do you want to continue?';
}

