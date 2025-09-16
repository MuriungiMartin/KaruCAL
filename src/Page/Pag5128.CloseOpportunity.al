#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5128 "Close Opportunity"
{
    Caption = 'Close Opportunity';
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
            group(General)
            {
                Caption = 'General';
                field(OptionWon;"Action Taken")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Opportunity Status';
                    ToolTip = 'Specifies the action that was taken when the entry was last updated. There are six options:';
                    ValuesAllowed = Won,Lost;

                    trigger OnValidate()
                    var
                        CloseOpportunityCode: Record "Close Opportunity Code";
                    begin
                        if "Action Taken" = "action taken"::Lost then
                          LostActionTakenOnValidate;
                        if "Action Taken" = "action taken"::Won then
                          WonActionTakenOnValidate;

                        case "Action Taken" of
                          "action taken"::Won:
                            begin
                              CalcdCurrentValueLCYEnable := true;
                              if Opp.Get("Opportunity No.") then
                                SalesQuoteEnable := Opp."Sales Document No." <> '';
                            end;
                          "action taken"::Lost:
                            begin
                              CalcdCurrentValueLCYEnable := false;
                              SalesQuoteEnable := false;
                            end;
                        end;

                        UpdateEstimates;
                        case "Action Taken" of
                          "action taken"::Won:
                            begin
                              CloseOpportunityCode.SetRange(Type,CloseOpportunityCode.Type::Won);
                              if CloseOpportunityCode.Count = 1 then begin
                                CloseOpportunityCode.FindFirst;
                                "Close Opportunity Code" := CloseOpportunityCode.Code;
                              end;
                            end;
                          "action taken"::Lost:
                            begin
                              CloseOpportunityCode.SetRange(Type,CloseOpportunityCode.Type::Lost);
                              if CloseOpportunityCode.Count = 1 then begin
                                CloseOpportunityCode.FindFirst;
                                "Close Opportunity Code" := CloseOpportunityCode.Code;
                              end;
                            end;
                        end;
                    end;
                }
                field("Close Opportunity Code";"Close Opportunity Code")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Close Opportunity Code';
                    ToolTip = 'Specifies the code for closing the opportunity.';
                }
                field("Date of Change";"Date of Change")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Closing Date';
                    ToolTip = 'Specifies the date this opportunity entry was last changed.';
                }
                field("Calcd. Current Value (LCY)";"Calcd. Current Value (LCY)")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Sales ($)';
                    Enabled = CalcdCurrentValueLCYEnable;
                    ToolTip = 'Specifies the calculated current value of the opportunity entry.';
                }
                field("Cancel Old To Do";"Cancel Old To Do")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cancel Old To-dos';
                    ToolTip = 'Specifies a to-do is to be canceled from the opportunity.';
                }
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
                ToolTip = 'Finish closing the opportunity.';
                Visible = IsOnMobile;

                trigger OnAction()
                begin
                    CheckStatus;
                    FinishWizard;
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

                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                begin
                    if Opp.Get("Opportunity No.") then begin
                      Opp.ShowQuote;
                      if SalesHeader.Get(SalesHeader."document type"::Quote,Opp."Sales Document No.") then begin
                        "Calcd. Current Value (LCY)" := GetSalesDocValue(SalesHeader);
                        CurrPage.Update;
                      end;
                    end;
                end;
            }
        }
    }

    trigger OnInit()
    begin
        OptionLostEnable := true;
        OptionWonEnable := true;
        SalesQuoteEnable := true;
        CalcdCurrentValueLCYEnable := true;
    end;

    trigger OnOpenPage()
    begin
        UpdateEditable;
        "Cancel Old To Do" := true;
        IsOnMobile := CurrentClientType = Clienttype::Phone;
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        if CloseAction in [Action::OK,Action::LookupOK] then begin
          CheckStatus;
          FinishWizard;
        end;
    end;

    var
        Text000: label 'untitled';
        Cont: Record Contact;
        Opp: Record Opportunity;
        [InDataSet]
        CalcdCurrentValueLCYEnable: Boolean;
        [InDataSet]
        SalesQuoteEnable: Boolean;
        [InDataSet]
        OptionWonEnable: Boolean;
        [InDataSet]
        OptionLostEnable: Boolean;
        IsNotAValidSelectionErr: label '%1 is not a valid selection.', Comment='%1 - Field Value';
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
        if GetFilter("Action Taken") <> '' then begin
          OptionWonEnable := false;
          OptionLostEnable := false;
        end;
    end;

    local procedure WonActionTakenOnValidate()
    begin
        if not OptionWonEnable then
          Error(IsNotAValidSelectionErr,"Action Taken");
    end;

    local procedure LostActionTakenOnValidate()
    begin
        if not OptionLostEnable then
          Error(IsNotAValidSelectionErr,"Action Taken");
    end;
}

