#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 611 "IC Outbox Transactions"
{
    ApplicationArea = Basic;
    Caption = 'IC Outbox Transactions';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Worksheet;
    SourceTable = "IC Outbox Transaction";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            group(Control31)
            {
                field(PartnerFilter;PartnerFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Partner Filter';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        PartnerList: Page "IC Partner List";
                    begin
                        PartnerList.LookupMode(true);
                        if not (PartnerList.RunModal = Action::LookupOK) then
                          exit(false);
                        Text := PartnerList.GetSelectionFilter;
                        exit(true);
                    end;

                    trigger OnValidate()
                    begin
                        PartnerFilterOnAfterValidate;
                    end;
                }
                field(ShowLines;ShowLines)
                {
                    ApplicationArea = Basic;
                    Caption = 'Show Transaction Source';
                    OptionCaption = ' ,Rejected by Current Company,Created by Current Company';

                    trigger OnValidate()
                    begin
                        SetRange("Transaction Source");
                        case ShowLines of
                          Showlines::"Rejected by Current Company":
                            SetRange("Transaction Source","transaction source"::"Rejected by Current Company");
                          Showlines::"Created by Current Company":
                            SetRange("Transaction Source","transaction source"::"Created by Current Company");
                        end;
                        ShowLinesOnAfterValidate;
                    end;
                }
                field(ShowAction;ShowAction)
                {
                    ApplicationArea = Basic;
                    Caption = 'Show Line Action';
                    OptionCaption = 'All,No Action,Send to IC Partner,Return to Inbox,Create Correction Lines';

                    trigger OnValidate()
                    begin
                        SetRange("Line Action");
                        case ShowAction of
                          Showaction::"No Action":
                            SetRange("Line Action","line action"::"No Action");
                          Showaction::"Send to IC Partner":
                            SetRange("Line Action","line action"::"Send to IC Partner");
                          Showaction::"Return to Inbox":
                            SetRange("Line Action","line action"::"Return to Inbox");
                          Showaction::Cancel:
                            SetRange("Line Action","line action"::Cancel);
                        end;
                        ShowActionOnAfterValidate;
                    end;
                }
            }
            repeater(Control1)
            {
                field("Transaction No.";"Transaction No.")
                {
                    ApplicationArea = Basic;
                }
                field("IC Partner Code";"IC Partner Code")
                {
                    ApplicationArea = Basic;
                }
                field("Source Type";"Source Type")
                {
                    ApplicationArea = Basic;
                }
                field("Document Type";"Document Type")
                {
                    ApplicationArea = Basic;
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic;
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Source";"Transaction Source")
                {
                    ApplicationArea = Basic;
                }
                field("Document Date";"Document Date")
                {
                    ApplicationArea = Basic;
                }
                field("Line Action";"Line Action")
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
            group("&Outbox Transaction")
            {
                Caption = '&Outbox Transaction';
                Image = Export;
                action(Details)
                {
                    ApplicationArea = Basic;
                    Caption = 'Details';
                    Image = View;

                    trigger OnAction()
                    begin
                        ShowDetails;
                    end;
                }
                action(Comments)
                {
                    ApplicationArea = Basic;
                    Caption = 'Comments';
                    Image = ViewComments;
                    RunObject = Page "IC Comment Sheet";
                    RunPageLink = "Table Name"=const("IC Outbox Transaction"),
                                  "Transaction No."=field("Transaction No."),
                                  "IC Partner Code"=field("IC Partner Code"),
                                  "Transaction Source"=field("Transaction Source");
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                group("Set Line Action")
                {
                    Caption = 'Set Line Action';
                    Image = SelectLineToApply;
                    action("No Action")
                    {
                        ApplicationArea = Basic;
                        Caption = 'No Action';
                        Image = Cancel;

                        trigger OnAction()
                        begin
                            CurrPage.SetSelectionFilter(ICOutboxTransaction);
                            if ICOutboxTransaction.Find('-') then
                              repeat
                                ICOutboxTransaction."Line Action" := ICOutboxTransaction."line action"::"No Action";
                                ICOutboxTransaction.Modify;
                              until ICOutboxTransaction.Next = 0;
                        end;
                    }
                    action(SendToICPartner)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Send to IC Partner';
                        Image = SendMail;

                        trigger OnAction()
                        begin
                            CurrPage.SetSelectionFilter(ICOutboxTransaction);
                            if ICOutboxTransaction.Find('-') then
                              repeat
                                ICOutboxTransaction.Validate("Line Action",ICOutboxTransaction."line action"::"Send to IC Partner");
                                ICOutboxTransaction.Modify;
                              until ICOutboxTransaction.Next = 0;
                        end;
                    }
                    action("Return to Inbox")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Return to Inbox';
                        Image = Return;

                        trigger OnAction()
                        begin
                            CurrPage.SetSelectionFilter(ICOutboxTransaction);
                            if ICOutboxTransaction.Find('-') then
                              repeat
                                TestField("Transaction Source",ICOutboxTransaction."transaction source"::"Rejected by Current Company");
                                ICOutboxTransaction."Line Action" := ICOutboxTransaction."line action"::"Return to Inbox";
                                ICOutboxTransaction.Modify;
                              until ICOutboxTransaction.Next = 0;
                        end;
                    }
                    action(Cancel)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Cancel';
                        Image = Cancel;

                        trigger OnAction()
                        begin
                            CurrPage.SetSelectionFilter(ICOutboxTransaction);
                            if ICOutboxTransaction.Find('-') then
                              repeat
                                ICOutboxTransaction."Line Action" := ICOutboxTransaction."line action"::Cancel;
                                ICOutboxTransaction.Modify;
                              until ICOutboxTransaction.Next = 0;
                        end;
                    }
                }
                separator(Action23)
                {
                }
                action("Complete Line Actions")
                {
                    ApplicationArea = Basic;
                    Caption = 'Complete Line Actions';
                    Image = CompleteLine;
                    RunObject = Codeunit "IC Outbox Export";
                }
            }
        }
    }

    var
        ICOutboxTransaction: Record "IC Outbox Transaction";
        PartnerFilter: Code[250];
        ShowLines: Option " ","Rejected by Current Company","Created by Current Company";
        ShowAction: Option All,"No Action","Send to IC Partner","Return to Inbox",Cancel;

    local procedure ShowLinesOnAfterValidate()
    begin
        CurrPage.Update(false);
    end;

    local procedure ShowActionOnAfterValidate()
    begin
        CurrPage.Update(false);
    end;

    local procedure PartnerFilterOnAfterValidate()
    begin
        SetFilter("IC Partner Code",PartnerFilter);
        CurrPage.Update(false);
    end;
}

