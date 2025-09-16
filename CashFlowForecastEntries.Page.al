#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 850 "Cash Flow Forecast Entries"
{
    ApplicationArea = Basic;
    Caption = 'Cash Flow Forecast Entries';
    Editable = false;
    PageType = List;
    SourceTable = "Cash Flow Forecast Entry";
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(Control1000)
            {
                field("Cash Flow Date";"Cash Flow Date")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the cash flow date that the entry is posted to.';
                }
                field(Overdue;Overdue)
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Cash Flow Forecast No.";"Cash Flow Forecast No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a number for the cash flow forecast.';
                }
                field("Cash Flow Account No.";"Cash Flow Account No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number of the cash flow account that the forecast entry is posted to.';
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the document that represents the forecast entry.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a description of the cash flow forecast entry.';

                    trigger OnDrillDown()
                    begin
                        ShowSource(false);
                    end;
                }
                field("Source Type";"Source Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the source type that applies to the source number that is shown in the Source No. field.';
                }
                field("Source No.";"Source No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies where the entry originated.';

                    trigger OnDrillDown()
                    begin
                        ShowSource(true);
                    end;
                }
                field("Payment Discount";"Payment Discount")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the possible payment discount for the cash flow forecast.';
                }
                field("Global Dimension 1 Code";"Global Dimension 1 Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies a global dimension. Global dimensions are the dimensions that you analyze most frequently.';
                }
                field("Amount (LCY)";"Amount (LCY)")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the amount of the forecast line in $. Revenues are entered without a plus or minus sign. Expenses are entered with a minus sign.';
                }
                field("Global Dimension 2 Code";"Global Dimension 2 Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies a global dimension. Global dimensions are the dimensions that you analyze most frequently.';
                    Visible = false;
                }
                field("User ID";"User ID")
                {
                    ApplicationArea = Basic;
                }
                field("Entry No.";"Entry No.")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Ent&ry")
            {
                Caption = 'Ent&ry';
                Image = Entry;
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension=R;
                    ApplicationArea = Suite;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edits dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                    trigger OnAction()
                    begin
                        ShowDimensions;
                    end;
                }
                action(GLDimensionOverview)
                {
                    ApplicationArea = Suite;
                    Caption = 'G/L Dimension Overview';
                    Image = Dimensions;
                    ToolTip = 'View an overview of general ledger entries and dimensions.';

                    trigger OnAction()
                    begin
                        Page.Run(Page::"CF Entries Dim. Overview",Rec);
                    end;
                }
            }
            action(ShowSource)
            {
                ApplicationArea = Basic,Suite;
                Caption = '&Show';
                Image = View;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunPageMode = View;
                ToolTip = 'View the actual cash flow forecast entries.';

                trigger OnAction()
                begin
                    ShowSource(false);
                end;
            }
        }
    }

    trigger OnFindRecord(Which: Text): Boolean
    begin
        exit(Find(Which));
    end;

    trigger OnNextRecord(Steps: Integer): Integer
    begin
        exit(Next(Steps));
    end;
}

