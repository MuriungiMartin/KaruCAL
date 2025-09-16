#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 983 "Payment Registration Details"
{
    Caption = 'Payment Registration Details';
    DataCaptionExpression = PageCaption;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = ListPlus;
    PromotedActionCategories = 'New,Process,Report,Navigate';
    SourceTable = "Payment Registration Buffer";

    layout
    {
        area(content)
        {
            group("Document Name")
            {
                Caption = 'Document Name';
                field(Name;Name)
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    StyleExpr = true;
                    ToolTip = 'Specifies the name of the customer or vendor that the payment relates to.';

                    trigger OnDrillDown()
                    var
                        Customer: Record Customer;
                    begin
                        Customer.Get("Source No.");
                        Page.Run(Page::"Customer Card",Customer);
                    end;
                }
            }
            group("Document Details")
            {
                Caption = 'Document Details';
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the number of the document that the payment relates to.';

                    trigger OnDrillDown()
                    begin
                        Navigate;
                    end;
                }
                field("Document Type";"Document Type")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the type of document that the payment relates to.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the invoice transaction that the payment relates to.';
                }
                field("Due Date";"Due Date")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    StyleExpr = DueDateStyle;
                    ToolTip = 'Specifies the payment due date on the related document.';
                }
            }
            group("Payment Discount")
            {
                Caption = 'Payment Discount';
                field("Pmt. Discount Date";"Pmt. Discount Date")
                {
                    ApplicationArea = Basic,Suite;
                    StyleExpr = PmtDiscStyle;
                    ToolTip = 'Specifies the date on which the amount on the document must be paid before the payment discount is granted.';

                    trigger OnValidate()
                    begin
                        SetUserInteractions;
                    end;
                }
                field("Remaining Amount";"Remaining Amount")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    StyleExpr = PmtDiscStyle;
                    ToolTip = 'Specifies the amount that remains to be paid on the document.';
                }
                field("Rem. Amt. after Discount";"Rem. Amt. after Discount")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the remaining amount after the payment discount is deducted.';
                }
            }
            group(Warning)
            {
                Caption = 'Warning';
                fixed(Control21)
                {
                    group(Control20)
                    {
                        field(Control16;Warning)
                        {
                            ApplicationArea = Basic,Suite;
                            Editable = false;
                            ShowCaption = false;
                            Style = Unfavorable;
                            StyleExpr = true;
                            ToolTip = 'Specifies a warning about the payment, such as past due date.';
                        }
                    }
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("New Document")
            {
                Caption = 'New Document';
                action(FinanceChargeMemo)
                {
                    ApplicationArea = Basic;
                    Caption = 'Finance Charge Memo';
                    Image = FinChargeMemo;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Page "Finance Charge Memo";
                    RunPageLink = "Customer No."=field("Source No.");
                    RunPageMode = Create;
                    ToolTip = 'Create a finance charge memo for the customer on the selected line, for example, to issue a finance charge for late payment.';
                }
            }
            group(ActionGroup19)
            {
                Caption = 'Navigate';
                action(Navigate)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Navigate';
                    Image = Navigate;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Find all entries and documents that exist for the document number and posting date on the selected entry or document.';

                    trigger OnAction()
                    begin
                        Navigate;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetUserInteractions;
    end;

    trigger OnOpenPage()
    begin
        PageCaption := '';
    end;

    var
        PmtDiscStyle: Text;
        DueDateStyle: Text;
        Warning: Text;
        PageCaption: Text;

    local procedure SetUserInteractions()
    begin
        PmtDiscStyle := GetPmtDiscStyle;
        DueDateStyle := GetDueDateStyle;
        Warning := GetWarning;
    end;
}

