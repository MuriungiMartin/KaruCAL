#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 436 "Reminder List"
{
    ApplicationArea = Basic;
    Caption = 'Reminder List';
    CardPageID = Reminder;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Reminder Header";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the reminder document.';
                }
                field("Customer No.";"Customer No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the customer you want to post a reminder for.';
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the customer the reminder is for.';
                }
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the currency code of the reminder.';
                }
                field("Remaining Amount";"Remaining Amount")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    ToolTip = 'Specifies the total of the remaining amounts on the reminder lines.';
                }
                field("Post Code";"Post Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ZIP code of the address.';
                    Visible = false;
                }
                field(City;City)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the city name of the customer the reminder is for.';
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the dimension value code linked to the purchase.';
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the shortcut dimension value code that the reminder is linked to.';
                    Visible = false;
                }
                field("Assigned User ID";"Assigned User ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ID of the user who is responsible for the document.';
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
                separator(Action8)
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
                        CurrPage.Update(false);
                    end;
                }
            }
        }
        area(reporting)
        {
            action("Reminder Nos.")
            {
                ApplicationArea = Basic;
                Caption = 'Reminder Nos.';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Reminder Nos.";
            }
            action("Reminder Test")
            {
                ApplicationArea = Basic;
                Caption = 'Reminder Test';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";

                trigger OnAction()
                begin
                    CurrPage.SetSelectionFilter(ReminderHeader);
                    Report.RunModal(Report::"Reminder - Test",true,true,ReminderHeader);
                end;
            }
            action("Customer - Balance to Date")
            {
                ApplicationArea = Basic;
                Caption = 'Customer - Balance to Date';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Customer - Balance to Date";
            }
            action("Customer - Detail Trial Bal.")
            {
                ApplicationArea = Basic;
                Caption = 'Customer - Detail Trial Bal.';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Customer - Detail Trial Bal.";
            }
        }
    }

    trigger OnDeleteRecord(): Boolean
    begin
        exit(ConfirmDeletion);
    end;

    var
        ReminderHeader: Record "Reminder Header";


    procedure GetSelectionFilter(): Text
    var
        ReminderHeader: Record "Reminder Header";
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
    begin
        CurrPage.SetSelectionFilter(ReminderHeader);
        exit(SelectionFilterManagement.GetSelectionFilterForIssueReminder(ReminderHeader));
    end;
}

