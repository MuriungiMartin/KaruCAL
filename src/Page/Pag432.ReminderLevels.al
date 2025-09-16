#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 432 "Reminder Levels"
{
    Caption = 'Reminder Levels';
    DataCaptionFields = "Reminder Terms Code";
    PageType = List;
    SourceTable = "Reminder Level";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Reminder Terms Code";"Reminder Terms Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the reminder terms code for the reminder.';
                    Visible = ReminderTermsCodeVisible;
                }
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of this reminder level.';
                }
                field("Grace Period";"Grace Period")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the length of the grace period for this reminder level.';
                }
                field("Due Date Calculation";"Due Date Calculation")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a formula that determines how to calculate the due date on the reminder.';
                }
                field("Calculate Interest";"Calculate Interest")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether interest should be calculated on the reminder lines.';
                }
                field("Additional Fee (LCY)";"Additional Fee (LCY)")
                {
                    ApplicationArea = Basic;
                    Enabled = AddFeeFieldsEnabled;
                    ToolTip = 'Specifies the amount of the additional fee in $ that will be added on the reminder.';
                }
                field("Add. Fee per Line Amount (LCY)";"Add. Fee per Line Amount (LCY)")
                {
                    ApplicationArea = Basic;
                    Enabled = AddFeeFieldsEnabled;
                }
                field("Add. Fee Calculation Type";"Add. Fee Calculation Type")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        CheckAddFeeCalcType;
                    end;
                }
                field("Add. Fee per Line Description";"Add. Fee per Line Description")
                {
                    ApplicationArea = Basic;
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
        area(navigation)
        {
            group("&Level")
            {
                Caption = '&Level';
                Image = ReminderTerms;
                action(BeginningText)
                {
                    ApplicationArea = Basic;
                    Caption = 'Beginning Text';
                    Image = BeginningText;
                    RunObject = Page "Reminder Text";
                    RunPageLink = "Reminder Terms Code"=field("Reminder Terms Code"),
                                  "Reminder Level"=field("No."),
                                  Position=const(Beginning);
                }
                action(EndingText)
                {
                    ApplicationArea = Basic;
                    Caption = 'Ending Text';
                    Image = EndingText;
                    RunObject = Page "Reminder Text";
                    RunPageLink = "Reminder Terms Code"=field("Reminder Terms Code"),
                                  "Reminder Level"=field("No."),
                                  Position=const(Ending);
                }
                separator(Action21)
                {
                }
                action(Currencies)
                {
                    ApplicationArea = Basic;
                    Caption = 'Currencies';
                    Enabled = AddFeeFieldsEnabled;
                    Image = Currency;
                    RunObject = Page "Currencies for Reminder Level";
                    RunPageLink = "Reminder Terms Code"=field("Reminder Terms Code"),
                                  "No."=field("No.");
                }
            }
            group(Setup)
            {
                Caption = 'Setup';
                action("Additional Fee")
                {
                    ApplicationArea = Basic;
                    Caption = 'Additional Fee';
                    Enabled = AddFeeSetupEnabled;
                    Image = SetupColumns;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Additional Fee Setup";
                    RunPageLink = "Charge Per Line"=const(false),
                                  "Reminder Terms Code"=field("Reminder Terms Code"),
                                  "Reminder Level No."=field("No.");
                }
                action("Additional Fee per Line")
                {
                    ApplicationArea = Basic;
                    Caption = 'Additional Fee per Line';
                    Enabled = AddFeeSetupEnabled;
                    Image = SetupLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Additional Fee Setup";
                    RunPageLink = "Charge Per Line"=const(true),
                                  "Reminder Terms Code"=field("Reminder Terms Code"),
                                  "Reminder Level No."=field("No.");
                }
                action("View Additional Fee Chart")
                {
                    ApplicationArea = Basic;
                    Caption = 'View Additional Fee Chart';
                    Image = Forecast;

                    trigger OnAction()
                    var
                        AddFeeChart: Page "Additional Fee Chart";
                    begin
                        if FileMgt.IsWebClient then
                          Error(ChartNotAvailableInWebErr,ProductName.Short);

                        AddFeeChart.SetViewMode(Rec,false,true);
                        AddFeeChart.RunModal;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        CheckAddFeeCalcType;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        NewRecord;
    end;

    trigger OnOpenPage()
    begin
        ReminderTerms.SetFilter(Code,GetFilter("Reminder Terms Code"));
        ShowColumn := true;
        if ReminderTerms.FindFirst then begin
          ReminderTerms.SetRecfilter;
          if ReminderTerms.GetFilter(Code) = GetFilter("Reminder Terms Code") then
            ShowColumn := false;
        end;
        ReminderTermsCodeVisible := ShowColumn;
    end;

    var
        ReminderTerms: Record "Reminder Terms";
        FileMgt: Codeunit "File Management";
        ShowColumn: Boolean;
        [InDataSet]
        ReminderTermsCodeVisible: Boolean;
        AddFeeSetupEnabled: Boolean;
        AddFeeFieldsEnabled: Boolean;
        ChartNotAvailableInWebErr: label 'The chart cannot be shown in the %1 Web client. To see the chart, use the %1 Windows client.', Comment='%1 - product name';

    local procedure CheckAddFeeCalcType()
    begin
        if "Add. Fee Calculation Type" = "add. fee calculation type"::Fixed then begin
          AddFeeSetupEnabled := false;
          AddFeeFieldsEnabled := true;
        end else begin
          AddFeeSetupEnabled := true;
          AddFeeFieldsEnabled := false;
        end;
    end;
}

