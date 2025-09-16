#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 615 "IC Inbox Transactions"
{
    ApplicationArea = Basic;
    Caption = 'IC Inbox Transactions';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Worksheet;
    SourceTable = "IC Inbox Transaction";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            group(Control25)
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
                    OptionCaption = ' ,Returned by Partner,Created by Partner';

                    trigger OnValidate()
                    begin
                        SetRange("Transaction Source");
                        case ShowLines of
                          Showlines::"Returned by Partner":
                            SetRange("Transaction Source","transaction source"::"Returned by Partner");
                          Showlines::"Created by Partner":
                            SetRange("Transaction Source","transaction source"::"Created by Partner");
                        end;
                        ShowLinesOnAfterValidate;
                    end;
                }
                field(ShowAction;ShowAction)
                {
                    ApplicationArea = Basic;
                    Caption = 'Show Line Action';
                    OptionCaption = 'All,No Action,Accept,Return to IC Partner';

                    trigger OnValidate()
                    begin
                        SetRange("Line Action");
                        case ShowAction of
                          Showaction::"No Action":
                            SetRange("Line Action","line action"::"No Action");
                          Showaction::Accept:
                            SetRange("Line Action","line action"::Accept);
                          Showaction::"Return to IC Partner":
                            SetRange("Line Action","line action"::"Return to IC Partner");
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
            group("&Inbox Transaction")
            {
                Caption = '&Inbox Transaction';
                Image = Import;
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
                    RunPageLink = "Table Name"=const("IC Inbox Transaction"),
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
                            CurrPage.SetSelectionFilter(ICInboxTransaction);
                            if ICInboxTransaction.Find('-') then
                              repeat
                                ICInboxTransaction."Line Action" := ICInboxTransaction."line action"::"No Action";
                                ICInboxTransaction.Modify;
                              until ICInboxTransaction.Next = 0;
                        end;
                    }
                    action(Accept)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Accept';
                        Image = Approve;

                        trigger OnAction()
                        begin
                            CurrPage.SetSelectionFilter(ICInboxTransaction);
                            if ICInboxTransaction.Find('-') then
                              repeat
                                TestField("Transaction Source",ICInboxTransaction."transaction source"::"Created by Partner");
                                ICInboxTransaction.Validate("Line Action",ICInboxTransaction."line action"::Accept);
                                ICInboxTransaction.Modify;
                              until ICInboxTransaction.Next = 0;
                        end;
                    }
                    action("Return to IC Partner")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Return to IC Partner';
                        Image = Return;

                        trigger OnAction()
                        begin
                            CurrPage.SetSelectionFilter(ICInboxTransaction);
                            if ICInboxTransaction.Find('-') then
                              repeat
                                TestField("Transaction Source",ICInboxTransaction."transaction source"::"Created by Partner");
                                ICInboxTransaction."Line Action" := ICInboxTransaction."line action"::"Return to IC Partner";
                                ICInboxTransaction.Modify;
                              until ICInboxTransaction.Next = 0;
                        end;
                    }
                    action(Cancel)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Cancel';
                        Image = Cancel;

                        trigger OnAction()
                        begin
                            CurrPage.SetSelectionFilter(ICInboxTransaction);
                            if ICInboxTransaction.Find('-') then
                              repeat
                                ICInboxTransaction."Line Action" := ICInboxTransaction."line action"::Cancel;
                                ICInboxTransaction.Modify;
                              until ICInboxTransaction.Next = 0;
                        end;
                    }
                }
                separator(Action38)
                {
                }
                action("Complete Line Actions")
                {
                    ApplicationArea = Basic;
                    Caption = 'Complete Line Actions';
                    Ellipsis = true;
                    Image = CompleteLine;

                    trigger OnAction()
                    begin
                        Report.Run(Report::"Complete IC Inbox Action",true,false,Rec);
                        CurrPage.Update(true);
                    end;
                }
                separator(Action9)
                {
                }
                action("Import Transaction File")
                {
                    ApplicationArea = Basic;
                    Caption = 'Import Transaction File';
                    Image = Import;
                    RunObject = Codeunit "IC Inbox Import";
                    RunPageOnRec = true;
                }
            }
        }
    }

    var
        ICInboxTransaction: Record "IC Inbox Transaction";
        PartnerFilter: Code[250];
        ShowLines: Option " ","Returned by Partner","Created by Partner";
        ShowAction: Option All,"No Action",Accept,"Return to IC Partner",Cancel;

    local procedure PartnerFilterOnAfterValidate()
    begin
        SetFilter("IC Partner Code",PartnerFilter);
        CurrPage.Update(false);
    end;

    local procedure ShowLinesOnAfterValidate()
    begin
        CurrPage.Update(false);
    end;

    local procedure ShowActionOnAfterValidate()
    begin
        CurrPage.Update(false);
    end;
}

