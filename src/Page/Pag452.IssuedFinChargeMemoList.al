#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 452 "Issued Fin. Charge Memo List"
{
    ApplicationArea = Basic;
    Caption = 'Issued Fin. Charge Memo List';
    CardPageID = "Issued Finance Charge Memo";
    DataCaptionFields = "Customer No.";
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Issued Fin. Charge Memo Header";
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
                    ToolTip = 'Specifies the issued finance charge memo number.';
                }
                field("Customer No.";"Customer No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the customer number the finance charge memo is for.';
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the customer the finance charge memo is for.';
                }
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the currency that the issued finance charge memo is in.';
                }
                field("Interest Amount";"Interest Amount")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    ToolTip = 'Specifies the total of the interest amounts on the finance charge memo lines.';
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
                    ToolTip = 'Specifies the city name of the customer the finance charge memo is for.';
                    Visible = false;
                }
                field("No. Printed";"No. Printed")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how many times the finance charge memo has been printed.';
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the dimension value code associated with the finance charge memo.';
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the dimension value code associated with the finance charge memo.';
                    Visible = false;
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
            group("&Memo")
            {
                Caption = '&Memo';
                Image = Notes;
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Fin. Charge Comment Sheet";
                    RunPageLink = Type=const("Issued Finance Charge Memo"),
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
                separator(Action27)
                {
                }
                action(Statistics)
                {
                    ApplicationArea = Basic;
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Issued Fin. Charge Memo Stat.";
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
                ToolTip = 'Prepare to print the document. The report request window for the document opens where you can specify what to include on the print-out.';

                trigger OnAction()
                var
                    IssuedFinChrgMemoHeader: Record "Issued Fin. Charge Memo Header";
                begin
                    CurrPage.SetSelectionFilter(IssuedFinChrgMemoHeader);
                    IssuedFinChrgMemoHeader.PrintRecords(true,false,false);
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
                var
                    IssuedFinChrgMemoHeader: Record "Issued Fin. Charge Memo Header";
                begin
                    IssuedFinChrgMemoHeader := Rec;
                    CurrPage.SetSelectionFilter(IssuedFinChrgMemoHeader);
                    IssuedFinChrgMemoHeader.PrintRecords(false,true,false);
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
        area(reporting)
        {
            action("Finance Charge Memo Nos.")
            {
                ApplicationArea = Basic;
                Caption = 'Finance Charge Memo Nos.';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Finance Charge Memo Nos.";
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
}

