#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 446 "Finance Charge Memo"
{
    Caption = 'Finance Charge Memo';
    PageType = Document;
    SourceTable = "Finance Charge Memo Header";

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
                    ToolTip = 'Specifies the number of the finance charge memo.';
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
                    ToolTip = 'Specifies the number of the customer you want to create a finance charge memo for.';
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the name of the customer the finance charge memo is for.';
                }
                field(Address;Address)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the address of the customer the finance charge memo is for.';
                }
                field("Address 2";"Address 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies additional address information.';
                }
                field(City;City)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the city name of the customer the finance charge memo is for.';
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
                    ToolTip = 'Specifies the name of the person you regularly contact when you communicate with the customer the finance charge memo is for.';
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the date when the finance charge memo should be issued.';
                }
                field("Document Date";"Document Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when you created the finance charge memo.';
                }
                field("Assigned User ID";"Assigned User ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ID of the user who is responsible for the document.';
                }
            }
            part(FinChrgMemoLines;"Finance Charge Memo Lines")
            {
                SubPageLink = "Finance Charge Memo No."=field("No.");
            }
            group(Posting)
            {
                Caption = 'Posting';
                field("Fin. Charge Terms Code";"Fin. Charge Terms Code")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the customer''s finance charge terms code.';
                }
                field("Due Date";"Due Date")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies when payment of the amount on the finance charge memo is due.';
                }
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the currency code of the finance charge memo.';

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
                    ToolTip = 'Specifies the dimension value code linked to the finance charge memo.';
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the shortcut dimension value code that the finance charge memo is linked to.';
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
                action(List)
                {
                    ApplicationArea = Basic;
                    Caption = 'List';
                    Image = OpportunitiesList;
                    ShortCutKey = 'Shift+Ctrl+L';

                    trigger OnAction()
                    begin
                        FinChrgMemoHeader.Copy(Rec);
                        if Page.RunModal(0,FinChrgMemoHeader) = Action::LookupOK then
                          Rec := FinChrgMemoHeader;
                    end;
                }
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
                action(CreateFinanceChargeMemos)
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
                action(SuggestFinChargeMemoLines)
                {
                    ApplicationArea = Basic;
                    Caption = 'Suggest Fin. Charge Memo Lines';
                    Ellipsis = true;
                    Image = SuggestLines;

                    trigger OnAction()
                    begin
                        CurrPage.SetSelectionFilter(FinChrgMemoHeader);
                        Report.RunModal(Report::"Suggest Fin. Charge Memo Lines",true,false,FinChrgMemoHeader);
                    end;
                }
                action(UpdateFinChargeText)
                {
                    ApplicationArea = Basic;
                    Caption = 'Update Finance Charge Text';
                    Ellipsis = true;
                    Image = RefreshText;

                    trigger OnAction()
                    begin
                        CurrPage.SetSelectionFilter(FinChrgMemoHeader);
                        Report.RunModal(Report::"Update Finance Charge Text",true,false,FinChrgMemoHeader);
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
                        CurrPage.SetSelectionFilter(FinChrgMemoHeader);
                        FinChrgMemoHeader.PrintRecords;
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
            action("Finance Charge Memo")
            {
                ApplicationArea = Basic;
                Caption = 'Finance Charge Memo';
                Image = FinChargeMemo;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Finance Charge Memo";
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
        CurrPage.SaveRecord;
        exit(ConfirmDeletion);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        if (not DocNoVisible) and ("No." = '') then
          SetCustomerFromFilter;
    end;

    trigger OnOpenPage()
    begin
        SetDocNoVisible;
    end;

    var
        FinChrgMemoHeader: Record "Finance Charge Memo Header";
        CurrExchRate: Record "Currency Exchange Rate";
        ChangeExchangeRate: Page "Change Exchange Rate";
        DocNoVisible: Boolean;

    local procedure SetDocNoVisible()
    var
        DocumentNoVisibility: Codeunit DocumentNoVisibility;
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",Reminder,FinChMemo;
    begin
        DocNoVisible := DocumentNoVisibility.SalesDocumentNoIsVisible(Doctype::FinChMemo,"No.");
    end;
}

