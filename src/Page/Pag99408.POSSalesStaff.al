#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 99408 "POS Sales Staff"
{
    ApplicationArea = Basic;
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "POS Sales Header";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No.";"No.")
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
                field("Payment Method";"Payment Method")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field("Till Number";"Till Number")
                {
                    ApplicationArea = Basic;
                    Caption = 'Till Number/Service ID';
                }
                field("M-pesa Trans Missing";"M-pesa Trans Missing")
                {
                    ApplicationArea = Basic;
                }
                field("M-Pesa Transaction Number";"M-Pesa Transaction Number")
                {
                    ApplicationArea = Basic;
                    Caption = 'Transaction Code';
                }
                field("Amount Paid";"Amount Paid")
                {
                    ApplicationArea = Basic;
                }
                field("Total Amount";"Total Amount")
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
            group(Control1000000008)
            {
                part(Control1000000018;"POS Sales Lines")
                {
                    SubPageLink = "Document No."=field("No."),
                                  "Posting date"=field("Posting date"),
                                  "Serving Category"=field("Customer Type");
                }
            }
        }
    }

    actions
    {
                    ReportReportCodeunit ""
