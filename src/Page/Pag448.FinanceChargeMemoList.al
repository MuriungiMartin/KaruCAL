#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 448 "Finance Charge Memo List"
{
    ApplicationArea = Basic;
    Caption = 'Finance Charge Memo List';
    CardPageID = "Finance Charge Memo";
    InsertAllowed = false;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "Finance Charge Memo Header";
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
                    ToolTip = 'Specifies the number of the finance charge memo.';
                }
                field("Customer No.";"Customer No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the customer you want to create a finance charge memo for.';
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the customer the finance charge memo is for.';
                }
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the currency code of the finance charge memo.';
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
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the dimension value code linked to the finance charge memo.';
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the shortcut dimension value code that the finance charge memo is linked to.';
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
                    RunPageLink = Type=const("Finance Charge Memo"),
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
                    RunObject = Page "Finance Charge Memo Statistics";
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
                action("Create Finance Charge Memos")
                {
                    ApplicationArea = Basic;
                    Caption = 'Create Finance Charge Memos';
                    Ellipsis = true;
                    Image = CreateFinanceChargememo;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        Report.RunModal(Report::"Create Finance Charge Memos");
                    end;
                }
                action("Suggest Fin. Charge Memo Lines")
                {
                    ApplicationArea = Basic;
                    Caption = 'Suggest Fin. Charge Memo Lines';
                    Ellipsis = true;
                    Image = SuggestLines;

                    trigger OnAction()
                    begin
                        CurrPage.SetSelectionFilter(FinChrgMemoHeader);
                        Report.RunModal(Report::"Suggest Fin. Charge Memo Lines",true,false,FinChrgMemoHeader);
                        FinChrgMemoHeader.Reset;
                    end;
                }
                action("Update Finance Charge Text")
                {
                    ApplicationArea = Basic;
                    Caption = 'Update Finance Charge Text';
                    Ellipsis = true;
                    Image = RefreshText;

                    trigger OnAction()
                    begin
                        CurrPage.SetSelectionFilter(FinChrgMemoHeader);
                        Report.RunModal(Report::"Update Finance Charge Text",true,false,FinChrgMemoHeader);
                        FinChrgMemoHeader.Reset;
                    end;
                }
            }
            group("&Issuing")
            {
                Caption = '&Issuing';
                Image = Add;
                action("Test Report")
                {
                    ApplicationArea = Basic;
                    Caption = 'Test Report';
                    Ellipsis = true;
                    Image = TestReport;
                    ToolTip = 'View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.';

                    trigger OnAction()
                    begin
                        CurrPage.SetSelectionFilter(FinChrgMemoHeader);
                        FinChrgMemoHeader.PrintRecords;
                        FinChrgMemoHeader.Reset;
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
                        CurrPage.SetSelectionFilter(FinChrgMemoHeader);
                        Report.RunModal(Report::"Issue Finance Charge Memos",true,true,FinChrgMemoHeader);
                        FinChrgMemoHeader.Reset;
                        CurrPage.Update(false);
                    end;
                }
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
            action("Finance Charge Memo Test")
            {
                ApplicationArea = Basic;
                Caption = 'Finance Charge Memo Test';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Finance Charge Memo - Test";
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

    var
        FinChrgMemoHeader: Record "Finance Charge Memo Header";
}

