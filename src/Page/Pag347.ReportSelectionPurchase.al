#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 347 "Report Selection - Purchase"
{
    ApplicationArea = Basic;
    Caption = 'Report Selection - Purchase';
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "Report Selections";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            field(ReportUsage2;ReportUsage2)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Usage';
                OptionCaption = 'Quote,Blanket Order,Order,Invoice,Return Order,Credit Memo,Receipt,Return Shipment,Purchase Document - Test,Prepayment Document - Test,P.Arch. Quote,P.Arch. Order,P. Arch. Return Order,Vendor Remittance';
                ToolTip = 'Specifies which type of document the report is used for.';

                trigger OnValidate()
                begin
                    SetUsageFilter(true);
                end;
            }
            repeater(Control1)
            {
                field(Sequence;Sequence)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a number that indicates where this report is in the printing order.';
                }
                field("Report ID";"Report ID")
                {
                    ApplicationArea = Basic,Suite;
                    LookupPageID = Objects;
                    ToolTip = 'Specifies the ID of the report that the program will print.';
                }
                field("Report Caption";"Report Caption")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDown = false;
                    ToolTip = 'Specifies the name of the report.';
                }
                field("Use for Email Body";"Use for Email Body")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies that summarized information, such as invoice number, due date, and payment service link, will be inserted in the body of the email that you send.';
                }
                field("Use for Email Attachment";"Use for Email Attachment")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies that the related document will be attached to the email.';
                }
                field("Email Body Layout Code";"Email Body Layout Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the ID of the email body layout that is used.';
                    Visible = false;
                }
                field("Email Body Layout Description";"Email Body Layout Description")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a description of the email body layout that is used.';

                    trigger OnDrillDown()
                    var
                        CustomReportLayout: Record "Custom Report Layout";
                    begin
                        if CustomReportLayout.LookupLayoutOK("Report ID") then
                          Validate("Email Body Layout Code",CustomReportLayout.Code);
                    end;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        NewRecord;
    end;

    trigger OnOpenPage()
    begin
        SetUsageFilter(false);
    end;

    var
        ReportUsage2: Option Quote,"Blanket Order","Order",Invoice,"Return Order","Credit Memo",Receipt,"Return Shipment","Purchase Document - Test","Prepayment Document - Test","P.Arch. Quote","P.Arch. Order","P. Arch. Return Order","Vendor Remittance";

    local procedure SetUsageFilter(ModifyRec: Boolean)
    begin
        if ModifyRec then
          if Modify then;
        FilterGroup(2);
        case ReportUsage2 of
          Reportusage2::Quote:
            SetRange(Usage,Usage::"P.Quote");
          Reportusage2::"Blanket Order":
            SetRange(Usage,Usage::"P.Blanket");
          Reportusage2::Order:
            SetRange(Usage,Usage::"P.Order");
          Reportusage2::Invoice:
            SetRange(Usage,Usage::"P.Invoice");
          Reportusage2::"Return Order":
            SetRange(Usage,Usage::"P.Return");
          Reportusage2::"Credit Memo":
            SetRange(Usage,Usage::"P.Cr.Memo");
          Reportusage2::Receipt:
            SetRange(Usage,Usage::"P.Receipt");
          Reportusage2::"Return Shipment":
            SetRange(Usage,Usage::"P.Ret.Shpt.");
          Reportusage2::"Purchase Document - Test":
            SetRange(Usage,Usage::"P.Test");
          Reportusage2::"Prepayment Document - Test":
            SetRange(Usage,Usage::"P.Test Prepmt.");
          Reportusage2::"P.Arch. Quote":
            SetRange(Usage,Usage::"P.Arch. Quote");
          Reportusage2::"P.Arch. Order":
            SetRange(Usage,Usage::"P.Arch. Order");
          Reportusage2::"P. Arch. Return Order":
            SetRange(Usage,Usage::"P. Arch. Return Order");
          Reportusage2::"Vendor Remittance":
            SetRange(Usage,Usage::"V.Remittance");
        end;
        FilterGroup(0);
        CurrPage.Update;
    end;
}

