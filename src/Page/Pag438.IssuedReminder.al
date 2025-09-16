#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 438 "Issued Reminder"
{
    Caption = 'Issued Reminder';
    DeleteAllowed = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Document;
    SourceTable = "Issued Reminder Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                Editable = false;
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the issued reminder number.';
                }
                field("Customer No.";"Customer No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the customer number the reminder is for.';
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
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
                    ToolTip = 'Specifies the posting date that the reminder was issued on.';
                }
                field("Document Date";"Document Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the document date on which the reminder was created.';
                }
                field("Pre-Assigned No.";"Pre-Assigned No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the reminder from which the issued reminder was created.';
                }
                field("Reminder Level";"Reminder Level")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the reminder''s level.';
                }
                field("No. Printed";"No. Printed")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how many times the reminder has been printed.';
                }
            }
            part(ReminderLines;"Issued Reminder Lines")
            {
                Editable = false;
                SubPageLink = "Reminder No."=field("No.");
            }
            group(Posting)
            {
                Caption = 'Posting';
                Editable = false;
                field("Reminder Terms Code";"Reminder Terms Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the reminder terms code for the reminder.';
                }
                field("Fin. Charge Terms Code";"Fin. Charge Terms Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the finance charge terms code for the reminder.';
                }
                field("Due Date";"Due Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when payment of the amount on the reminder is due.';
                }
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the currency code of the issued reminder.';

                    trigger OnAssistEdit()
                    begin
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
                    ToolTip = 'Specifies the dimension value code associated with the reminder.';
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the dimension value code associated with the reminder.';
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
                        IssuedReminderHeader.Copy(Rec);
                        if Page.RunModal(0,IssuedReminderHeader) = Action::LookupOK then
                          Rec := IssuedReminderHeader;
                    end;
                }
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Reminder Comment Sheet";
                    RunPageLink = Type=const("Issued Reminder"),
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
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                    trigger OnAction()
                    begin
                        ShowDimensions;
                    end;
                }
                separator(Action6)
                {
                }
                action(Statistics)
                {
                    ApplicationArea = Basic;
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Issued Reminder Statistics";
                    RunPageLink = "No."=field("No.");
                    ShortCutKey = 'F7';
                }
            }
        }
        area(processing)
        {
            action("&Print")
            {
                ApplicationArea = Basic;
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.';

                trigger OnAction()
                begin
                    CurrPage.SetSelectionFilter(IssuedReminderHeader);
                    IssuedReminderHeader.PrintRecords(true,false,false);
                end;
            }
            action("Send by &Email")
            {
                ApplicationArea = Basic;
                Caption = 'Send by &Email';
                Image = Email;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Prepare to send the document by email. The Send Email window opens prefilled for the customer where you can add or change information before you send the email.';

                trigger OnAction()
                begin
                    IssuedReminderHeader := Rec;
                    CurrPage.SetSelectionFilter(IssuedReminderHeader);
                    IssuedReminderHeader.PrintRecords(false,true,false);
                end;
            }
            action("&Navigate")
            {
                ApplicationArea = Basic;
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Find all entries and documents that exist for the document number and posting date on the selected entry or document.';

                trigger OnAction()
                begin
                    Navigate;
                end;
            }
        }
    }

    var
        IssuedReminderHeader: Record "Issued Reminder Header";
        CurrExchRate: Record "Currency Exchange Rate";
        ChangeExchangeRate: Page "Change Exchange Rate";
}

