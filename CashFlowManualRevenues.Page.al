#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 857 "Cash Flow Manual Revenues"
{
    ApplicationArea = Basic;
    Caption = 'Cash Flow Manual Revenues';
    PageType = List;
    SourceTable = "Cash Flow Manual Revenue";
    SourceTableView = sorting("Starting Date")
                      order(ascending);
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1000)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the code of the record.';
                    Visible = false;
                }
                field("Cash Flow Account No.";"Cash Flow Account No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number of the cash flow account that the entry on the manual revenue line is registered to.';
                    Visible = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a description of the cash flow forecast entry.';
                }
                field("Starting Date";"Starting Date")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Date';
                    ShowMandatory = true;
                    ToolTip = 'Specifies the date of the cash flow entry.';
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the total amount in $ that the manual revenue consists of. The entered amount is the amount which is registered in the given time period per recurring frequency.';
                }
                field(Recurrence;Recurrence)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Recurrence';
                    OptionCaption = ' ,Daily,Weekly,Monthly,Quarterly,Yearly';
                    ToolTip = 'Specifies a date formula for calculating the period length. The content of the field determines how often the entry on the manual revenue line is registered. For example, if the line must be registered every month, you can enter 1M.';

                    trigger OnValidate()
                    var
                        RecurringFrequency: Text;
                    begin
                        RecurringFrequency := CashFlowManagement.RecurrenceToRecurringFrequency(Recurrence);
                        Evaluate("Recurring Frequency",RecurringFrequency);
                        EnableControls;
                    end;
                }
                field("Recurring Frequency";"Recurring Frequency")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies how often the entry on the manual revenue line is registered, if the journal template used is set up to be recurring';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        CashFlowManagement.RecurringFrequencyToRecurrence("Recurring Frequency",Recurrence);
                    end;
                }
                field("Ending Date";"Ending Date")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'End By';
                    Enabled = EndingDateEnabled;
                    ToolTip = 'Specifies the last date from which manual revenues should be registered for the cash flow forecast.';
                }
                field("Global Dimension 1 Code";"Global Dimension 1 Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies a global dimension. Global dimensions are the dimensions that you analyze most frequently.';
                    Visible = false;
                }
                field("Global Dimension 2 Code";"Global Dimension 2 Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies a global dimension. Global dimensions are the dimensions that you analyze most frequently.';
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Revenues")
            {
                Caption = '&Revenues';
                Image = Dimensions;
                action(Dimensions)
                {
                    ApplicationArea = Suite;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID"=const(849),
                                  "No."=field(Code);
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        GetRecord;
    end;

    trigger OnAfterGetRecord()
    begin
        GetRecord;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        CurrPage.SaveRecord;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        EnableControls;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        CreateNewRecord;
    end;

    var
        CashFlowManagement: Codeunit "Cash Flow Management";
        Recurrence: Option " ",Daily,Weekly,Monthly,Quarterly,Yearly;
        EndingDateEnabled: Boolean;
        RevTxt: label 'REV', Comment='Abbreviation of Revenue, used as prefix for code (e.g. REV000001)';

    local procedure CreateNewRecord()
    var
        CashFlowManualRevenue: Record "Cash Flow Manual Revenue";
        CashFlowAccount: Record "Cash Flow Account";
        CashFlowCode: Code[10];
    begin
        CashFlowManualRevenue.SetFilter(Code,'%1',RevTxt + '0*');
        if not CashFlowManualRevenue.FindLast then
          CashFlowCode := RevTxt + '000001'
        else
          CashFlowCode := IncStr(CashFlowManualRevenue.Code);

        CashFlowAccount.SetRange("Source Type",CashFlowAccount."source type"::"Cash Flow Manual Revenue");
        if not CashFlowAccount.FindFirst then
          exit;

        Code := CashFlowCode;
        "Cash Flow Account No." := CashFlowAccount."No.";
        Recurrence := Recurrence::" ";
        "Starting Date" := WorkDate;
        "Ending Date" := 0D;
    end;

    local procedure GetRecord()
    begin
        EnableControls;
        CashFlowManagement.RecurringFrequencyToRecurrence("Recurring Frequency",Recurrence);
    end;

    local procedure EnableControls()
    begin
        EndingDateEnabled := (Recurrence <> Recurrence::" ");
        if not EndingDateEnabled then
          "Ending Date" := 0D;
    end;
}

