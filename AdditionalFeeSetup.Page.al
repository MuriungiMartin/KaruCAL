#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1050 "Additional Fee Setup"
{
    Caption = 'Additional Fee Setup';
    DataCaptionExpression = PageCaption;
    PageType = List;
    SourceTable = "Additional Fee Setup";

    layout
    {
        area(content)
        {
            repeater(Control15)
            {
                field("Charge Per Line";"Charge Per Line")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Reminder Terms Code";"Reminder Terms Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Reminder Level No.";"Reminder Level No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Basic;
                }
                field("Threshold Remaining Amount";"Threshold Remaining Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Additional Fee Amount";"Additional Fee Amount")
                {
                    ApplicationArea = Basic;
                    CaptionClass = AddFeeCaptionExpression;
                }
                field("Additional Fee %";"Additional Fee %")
                {
                    ApplicationArea = Basic;
                    CaptionClass = AddFeePercCaptionExpression;
                }
                field("Min. Additional Fee Amount";"Min. Additional Fee Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Max. Additional Fee Amount";"Max. Additional Fee Amount")
                {
                    ApplicationArea = Basic;
                }
            }
            part(Chart;"Additional Fee Chart")
            {
                Visible = ShowChart;
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
        if ShowChart then
          CurrPage.Chart.Page.UpdateData;
    end;

    trigger OnAfterGetRecord()
    begin
        if ShowChart then
          CurrPage.Chart.Page.UpdateData;
    end;

    trigger OnOpenPage()
    var
        ReminderLevel: Record "Reminder Level";
    begin
        ShowChart := not FileMgt.IsWebClient;
        if ShowChart then begin
          ReminderLevel.Get("Reminder Terms Code","Reminder Level No.");
          CurrPage.Chart.Page.SetViewMode(ReminderLevel,"Charge Per Line",false);
          CurrPage.Chart.Page.UpdateData;
        end;

        if "Charge Per Line" then
          PageCaption := AddFeePerLineTxt;

        PageCaption += ' ' + ReminderTermsTxt + ' ' + "Reminder Terms Code" + ' ' +
          ReminderLevelTxt + ' ' + Format("Reminder Level No.");

        if "Charge Per Line" then begin
          AddFeeCaptionExpression := AddFeeperLineCaptionTxt;
          AddFeePercCaptionExpression := AddFeeperLineCaptionTxt + ' %';
        end else begin
          AddFeeCaptionExpression := AddFeeCaptionTxt;
          AddFeePercCaptionExpression := AddFeeCaptionTxt + ' %';
        end;
    end;

    var
        FileMgt: Codeunit "File Management";
        PageCaption: Text;
        AddFeePerLineTxt: label 'Additional Fee per Line Setup -';
        ReminderTermsTxt: label 'Reminder Terms:';
        ReminderLevelTxt: label 'Level:';
        ShowChart: Boolean;
        AddFeeCaptionExpression: Text;
        AddFeeperLineCaptionTxt: label 'Additional Fee per Line';
        AddFeeCaptionTxt: label 'Additional Fee';
        AddFeePercCaptionExpression: Text;
}

