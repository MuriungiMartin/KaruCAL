#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 99407 "POS Sales Header Card"
{
    DeleteAllowed = false;
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "POS Sales Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Editable = edt;
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Posting Description";"Posting Description")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Total Amount";"Total Amount")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Posting date";"Posting date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Cashier;Cashier)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Customer Type";"Customer Type")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Income Account";"Income Account")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Payment Method";"Payment Method")
                {
                    ApplicationArea = Basic;
                }
                field("M-pesa Trans Missing";"M-pesa Trans Missing")
                {
                    ApplicationArea = Basic;
                }
                field("M-Pesa Transaction Number";"M-Pesa Transaction Number")
                {
                    ApplicationArea = Basic;
                }
                field("Till Number";"Till Number")
                {
                    ApplicationArea = Basic;
                }
                field("Cash Account";"Cash Account")
                {
                    ApplicationArea = Basic;
                }
                field("Amount Paid";"Amount Paid")
                {
                    ApplicationArea = Basic;
                }
                field("Bank Account";"Bank Account")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Balance;Balance)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
            group(Control1000000020)
            {
                part(Control1000000015;"POS Sales Lines")
                {
                    Editable = edt;
                    SubPageLink = "Document No."=field("No."),
                                  "Posting date"=field("Posting date"),
                                  "Serving Category"=field("Customer Type");
                }
            }
        }
    }

    actions
    {
                    Report                    ReportCodeunit ""
