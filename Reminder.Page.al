#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 434 Reminder
{
    Caption = 'Reminder';
    PageType = Document;
    SourceTable = "Reminder Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the number of the reminder document.';
                    Visible = DocNoVisible;

                    trigger OnAssistEdit()
                    begin
                        if AssistEdit(xRec) then
                          CurrPage.Update;
                    end;
                }
                field("Customer No.";"Customer No.")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the number of the customer you want to post a reminder for.';
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the name of the customer the reminder is for.';
                }
                field(Address;Address)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the address of the customer the reminder is for.';
                }
                field("Address 2";"Address 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies additional address information.';
                }
                field(City;City)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the city name of the customer the reminder is for.';
                }
                field(County;County)
                {
                    ApplicationArea = Basic;
                    Caption = 'State / ZIP Code';
                }
                field("Post Code";"Post Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ZIP code of the address.';
                }
                field(Contact;Contact)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the person you regularly contact when you communicate with the customer the reminder is for.';
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the reminder should be issued.';
                }
                field("Document Date";"Document Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date on which you create the reminder.';
                }
                field("Reminder Level";"Reminder Level")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the reminder''s level.';
                }
                field("Use Header Level";"Use Header Level")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that the condition of the level for the Reminder Level field is applied to all suggested reminder lines.';
                }
                field("Assigned User ID";"Assigned User ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ID of the user who is responsible for the document.';
                }
            }
            part(ReminderLines;"Reminder Lines")
            {
                SubPageLink = "Reminder No."=field("No.");
            }
            group(Posting)
            {
                Caption = 'Posting';
                field("Reminder Terms Code";"Reminder Terms Code")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the customer''s reminder terms code.';
                }
                field("Fin. Charge Terms Code";"Fin. Charge Terms Code")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the customer''s finance charge terms code.';
                }
                field("Due Date";"Due Date")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies when payment of the amount on the reminder is due.';
                }
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the currency code of the reminder.';

                    trigger OnAssistEdit()
                    begin
                        TestField("Posting Date");
                        ChangeExchangeRate.SetParameter(
                          "Currency Code",
                          CurrExchRate.ExchangeRate("Posting Date","Currency Code"),
                          "Posting Date");
                        ChangeExchangeRate.Editable(false);
                        if ChangeExchangeRate.RunModal = Action::OK then;
                        Clear(ChangeExchangeRate);
                    end;
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the dimension value code linked to the purchase.';
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the shortcut dimension value code that the reminder is linked to.';
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
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Reminder")
            {
                Caption = '&Reminder';
                Image = Reminder;
                action(List)
                {
                    ApplicationArea = Basic;
                    Caption = 'List';
                    Image = OpportunitiesList;
                    ShortCutKey = 'Shift+Ctrl+L';

                    trigger OnAction()
                    begin
                        ReminderHeader.Copy(Rec);
                        if Page.RunModal(0,ReminderHeader) = Action::LookupOK then
                          Rec := ReminderHeader;
                    end;
                }
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Reminder Comment Sheet";
                    RunPageLink = Type=const(Reminder),
                                  "No."=field("No.");
                }
                action("C&ustomer")
                {
                    ApplicationArea = Basic;
                    Caption = 'C&ustomer';
                    Image = Customer;
                    RunObject = Page "Customer List";
                    RunPageLink = "No."=field("Customer No.");
                }
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension=R;
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';
                    Enabled = "No." <> '';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                    trigger OnAction()
                    begin
                        ShowDocDim;
                        CurrPage.SaveRecord;
                    end;
                }
                separator(Action32)
                {
                }
                action(Statistics)
                {
                    ApplicationArea = Basic;
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Reminder Statistics";
                    RunPageLink = "No."=field("No.");
                    ShortCutKey = 'F7';
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action(CreateReminders)
                {
                    ApplicationArea = Basic;
                    Caption = 'Create Reminders';
                    Ellipsis = true;
                    Image = CreateReminders;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        Report.RunModal(Report::"Create Reminders");
                    end;
                }
                action(SuggestReminderLines)
                {
                    ApplicationArea = Basic;
                    Caption = 'Suggest Reminder Lines';
                    Ellipsis = true;
                    Image = SuggestReminderLines;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        CurrPage.SetSelectionFilter(ReminderHeader);
                        Report.RunModal(Report::"Suggest Reminder Lines",true,false,ReminderHeader);
                    end;
                }
                action(UpdateReminderText)
                {
                    ApplicationArea = Basic;
                    Caption = 'Update Reminder Text';
                    Ellipsis = true;
                    Image = RefreshText;

                    trigger OnAction()
                    begin
                        CurrPage.SetSelectionFilter(ReminderHeader);
                        Report.RunModal(Report::"Update Reminder Text",true,false,ReminderHeader);
                    end;
                }
            }
            group("&Issuing")
            {
                Caption = '&Issuing';
                Image = Add;
                action(TestReport)
                {
                    ApplicationArea = Basic;
                    Caption = 'Test Report';
                    Ellipsis = true;
                    Image = TestReport;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.';
                    Visible = not IsOfficeAddin;

                    trigger OnAction()
                    begin
                        CurrPage.SetSelectionFilter(ReminderHeader);
                        ReminderHeader.PrintRecords;
                    end;
                }
                action(Issue)
                {
                    ApplicationArea = Basic;
                    Caption = 'Issue';
                    Ellipsis = true;
                    Image = ReleaseDoc;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    begin
                        CurrPage.SetSelectionFilter(ReminderHeader);
                        Report.RunModal(Report::"Issue Reminders",true,true,ReminderHeader);
                    end;
                }
            }
        }
        area(reporting)
        {
            group(Customer)
            {
                Caption = 'Customer';
                Image = "Report";
                action("Customer - Order Summary")
                {
                    ApplicationArea = Basic;
                    Caption = 'Customer - Order Summary';
                    Image = "Report";
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = "Report";
                    RunObject = Report "Customer - Order Summary";
                }
                action("Customer Account Detail")
                {
                    ApplicationArea = Basic;
                    Caption = 'Customer Account Detail';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    RunObject = Report "Customer Account Detail";
                }
                action("Customer Statement")
                {
                    ApplicationArea = Basic;
                    Caption = 'Customer Statement';
                    Image = "Report";
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = "Report";
                    RunObject = Report "Customer Statement";
                }
                action("Aged Accounts Receivable")
                {
                    ApplicationArea = Basic;
                    Caption = 'Aged Accounts Receivable';
                    Image = "Report";
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = "Report";
                    RunObject = Report "Aged Accounts Receivable";
                }
                action("Customer - Payment Receipt")
                {
                    ApplicationArea = Basic;
                    Caption = 'Customer - Payment Receipt';
                    Image = "Report";
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = "Report";
                    RunObject = Report "Customer - Payment Receipt";
                }
                action("Open Customer Entries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Open Customer Entries';
                    Image = "Report";
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = "Report";
                    RunObject = Report "Open Customer Entries";
                }
            }
        }
    }

    trigger OnDeleteRecord(): Boolean
    begin
        CurrPage.SaveRecord;
        exit(ConfirmDeletion);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        if (not DocNoVisible) and ("No." = '') then
          SetCustomerFromFilter;
    end;

    trigger OnOpenPage()
    var
        OfficeMgt: Codeunit "Office Management";
    begin
        SetDocNoVisible;
        IsOfficeAddin := OfficeMgt.IsAvailable;
    end;

    var
        ReminderHeader: Record "Reminder Header";
        CurrExchRate: Record "Currency Exchange Rate";
        ChangeExchangeRate: Page "Change Exchange Rate";
        DocNoVisible: Boolean;
        IsOfficeAddin: Boolean;

    local procedure SetDocNoVisible()
    var
        DocumentNoVisibility: Codeunit DocumentNoVisibility;
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",Reminder,FinChMemo;
    begin
        DocNoVisible := DocumentNoVisibility.SalesDocumentNoIsVisible(Doctype::Reminder,"No.");
    end;
}

