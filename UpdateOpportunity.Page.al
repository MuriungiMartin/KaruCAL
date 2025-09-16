#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5129 "Update Opportunity"
{
    Caption = 'Update Opportunity';
    DataCaptionExpression = Caption;
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = Card;
    SourceTable = "Opportunity Entry";

    layout
    {
        area(content)
        {
            field("Action type";"Action Type")
            {
                ApplicationArea = RelationshipMgmt;
                ToolTip = 'Specifies options that you can take when you reenter an opportunity to update it in the Update Opportunity window. Certain options are not available, depending on what stage you are in for your opportunity. For example, if you are in stage 1, you cannot select the Previous option.';
                ValuesAllowed = First,Next,Previous,Skip,Jump,Update;

                trigger OnValidate()
                begin
                    if "Action Type" = "action type"::Update then
                      UpdateActionTypeOnValidate;
                    if "Action Type" = "action type"::Jump then
                      JumpActionTypeOnValidate;
                    if "Action Type" = "action type"::Skip then
                      SkipActionTypeOnValidate;
                    if "Action Type" = "action type"::Previous then
                      PreviousActionTypeOnValidate;
                    if "Action Type" = "action type"::Next then
                      NextActionTypeOnValidate;
                    if "Action Type" = "action type"::First then
                      FirstActionTypeOnValidate;

                    WizardActionTypeValidate2;
                    UpdateCntrls;
                end;
            }
            field("Sales Cycle Stage";"Sales Cycle Stage")
            {
                ApplicationArea = RelationshipMgmt;
                CaptionClass = FORMAT("Sales Cycle Stage Description");
                Editable = SalesCycleStageEditable;
                ToolTip = 'Specifies the sales cycle stage currently of the opportunity.';

                trigger OnLookup(var Text: Text): Boolean
                begin
                    LookupSalesCycleStage;
                    ValidateSalesCycleStage;
                end;

                trigger OnValidate()
                begin
                    WizardSalesCycleStageValidate2;
                    SalesCycleStageOnAfterValidate;
                end;
            }
            field("Date of Change";"Date of Change")
            {
                ApplicationArea = RelationshipMgmt;
                ToolTip = 'Specifies the date this opportunity entry was last changed.';
            }
            field("Estimated Value (LCY)";"Estimated Value (LCY)")
            {
                ApplicationArea = RelationshipMgmt;
                Caption = 'Estimated sales value ($)';
                ToolTip = 'Specifies the estimated value of the opportunity entry.';
            }
            field("Chances of Success %";"Chances of Success %")
            {
                ApplicationArea = RelationshipMgmt;
                Caption = 'Chances of Success (%)';
                ToolTip = 'Specifies the chances of success of the opportunity entry.';
            }
            field("Estimated Close Date";"Estimated Close Date")
            {
                ApplicationArea = RelationshipMgmt;
                Caption = 'Estimated Closing Date';
                ToolTip = 'Specifies the estimated date when the opportunity entry will be closed.';
            }
            field("Cancel Old To Do";"Cancel Old To Do")
            {
                ApplicationArea = Basic;
                Caption = 'Cancel Existing Open To-dos';
                Enabled = CancelOldToDoEnable;
                ToolTip = 'Specifies a to-do is to be canceled from the opportunity.';
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Finish)
            {
                ApplicationArea = RelationshipMgmt;
                Caption = '&Finish';
                Image = Approve;
                InFooterBar = true;
                Promoted = true;
                ToolTip = 'Finish updating the opportunity.';
                Visible = IsOnMobile;

                trigger OnAction()
                begin
                    FinishPage;
                    CurrPage.Close;
                end;
            }
            action(SalesQuote)
            {
                ApplicationArea = Basic;
                Caption = '&Sales Quote';
                Enabled = SalesQuoteEnable;
                Image = Quote;
                InFooterBar = true;
                Promoted = true;
                ToolTip = 'Create a sales quote based on the opportunity.';

                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                begin
                    if Opp.Get("Opportunity No.") then begin
                      Opp.ShowQuote;
                      if SalesHeader.Get(SalesHeader."document type"::Quote,Opp."Sales Document No.") then begin
                        "Estimated Value (LCY)" := GetSalesDocValue(SalesHeader);
                        CurrPage.Update;
                      end;
                    end;
                end;
            }
        }
    }

    trigger OnInit()
    begin
        CancelOldToDoEnable := true;
        SalesQuoteEnable := true;
        OptionSixEnable := true;
        OptionFiveEnable := true;
        OptionFourEnable := true;
        OptionThreeEnable := true;
        OptionTwoEnable := true;
        OptionOneEnable := true;
        SalesCycleStageEditable := true;
    end;

    trigger OnOpenPage()
    begin
        IsOnMobile := CurrentClientType = Clienttype::Phone;
        CreateStageList;
        UpdateEditable;
        if Opp.Get("Opportunity No.") then
          if Opp."Sales Document No." <> '' then
            SalesQuoteEnable := true
          else
            SalesQuoteEnable := false;

        UpdateCntrls;
        UpdateEstimatedValues;
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        if CloseAction in [Action::OK,Action::LookupOK] then
          FinishPage;
    end;

    var
        Text000: label 'untitled';
        Cont: Record Contact;
        SalesCycleStage: Record "Sales Cycle Stage";
        Opp: Record Opportunity;
        [InDataSet]
        SalesCycleStageEditable: Boolean;
        [InDataSet]
        OptionOneEnable: Boolean;
        [InDataSet]
        OptionTwoEnable: Boolean;
        [InDataSet]
        OptionThreeEnable: Boolean;
        [InDataSet]
        OptionFiveEnable: Boolean;
        [InDataSet]
        OptionFourEnable: Boolean;
        [InDataSet]
        OptionSixEnable: Boolean;
        [InDataSet]
        SalesQuoteEnable: Boolean;
        [InDataSet]
        CancelOldToDoEnable: Boolean;
        Text666: label '%1 is not a valid selection.';
        IsOnMobile: Boolean;

    local procedure Caption(): Text[260]
    var
        CaptionStr: Text[260];
    begin
        if Cont.Get("Contact Company No.") then
          CaptionStr := CopyStr(Cont."No." + ' ' + Cont.Name,1,MaxStrLen(CaptionStr));
        if Cont.Get("Contact No.") then
          CaptionStr := CopyStr(CaptionStr + ' ' + Cont."No." + ' ' + Cont.Name,1,MaxStrLen(CaptionStr));
        if CaptionStr = '' then
          CaptionStr := Text000;

        exit(CaptionStr);
    end;

    local procedure UpdateEditable()
    begin
        OptionOneEnable := NoOfSalesCyclesFirst > 0;
        OptionTwoEnable := NoOfSalesCyclesNext > 0;
        OptionThreeEnable := NoOfSalesCyclesPrev > 0;
        OptionFourEnable := NoOfSalesCyclesSkip > 1;
        OptionFiveEnable := NoOfSalesCyclesUpdate > 0;
        OptionSixEnable := NoOfSalesCyclesJump > 1;
    end;

    local procedure UpdateCntrls()
    var
        ToDo: Record "To-do";
    begin
        case "Action Type" of
          "action type"::First:
            begin
              SalesCycleStageEditable := false;
              CancelOldToDoEnable := false;
            end;
          "action type"::Next:
            begin
              SalesCycleStageEditable := false;
              CancelOldToDoEnable := true;
            end;
          "action type"::Previous:
            begin
              SalesCycleStageEditable := false;
              CancelOldToDoEnable := true;
            end;
          "action type"::Skip:
            begin
              SalesCycleStageEditable := true;
              CancelOldToDoEnable := true;
            end;
          "action type"::Update:
            begin
              SalesCycleStageEditable := false;
              CancelOldToDoEnable := false;
            end;
          "action type"::Jump:
            begin
              SalesCycleStageEditable := true;
              CancelOldToDoEnable := true;
            end;
        end;
        ToDo.Reset;
        ToDo.SetCurrentkey("Opportunity No.");
        ToDo.SetRange("Opportunity No.","Opportunity No.");
        if ToDo.FindFirst then
          CancelOldToDoEnable := true;
        Modify;
    end;

    local procedure SalesCycleStageOnAfterValidate()
    begin
        if SalesCycleStage.Get("Sales Cycle Code","Sales Cycle Stage") then
          "Sales Cycle Stage Description" := SalesCycleStage.Description;
    end;

    local procedure FirstActionTypeOnValidate()
    begin
        if not OptionOneEnable then
          Error(Text666,"Action Type");
    end;

    local procedure NextActionTypeOnValidate()
    begin
        if not OptionTwoEnable then
          Error(Text666,"Action Type");
    end;

    local procedure PreviousActionTypeOnValidate()
    begin
        if not OptionThreeEnable then
          Error(Text666,"Action Type");
    end;

    local procedure SkipActionTypeOnValidate()
    begin
        if not OptionFourEnable then
          Error(Text666,"Action Type");
    end;

    local procedure JumpActionTypeOnValidate()
    begin
        if not OptionSixEnable then
          Error(Text666,"Action Type");
    end;

    local procedure UpdateActionTypeOnValidate()
    begin
        if not OptionFiveEnable then
          Error(Text666,"Action Type");
    end;

    local procedure FinishPage()
    begin
        CheckStatus2;
        FinishWizard2;
    end;

    local procedure UpdateEstimatedValues()
    var
        SalesCycleStage: Record "Sales Cycle Stage";
        SalesHeader: Record "Sales Header";
    begin
        if SalesCycleStage.Get("Sales Cycle Code","Sales Cycle Stage") then
          "Estimated Close Date" := CalcDate(SalesCycleStage."Date Formula","Date of Change");

        if SalesHeader.Get(SalesHeader."document type"::Quote,Opp."Sales Document No.") then
          "Estimated Value (LCY)" := GetSalesDocValue(SalesHeader);

        Modify;
    end;
}

