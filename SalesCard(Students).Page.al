#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 99429 "Sales Card (Students)"
{
    DeleteAllowed = false;
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "POS Sales Header";
    SourceTableView = where("Customer Type"=filter(Student),
                            Posted=filter(false));

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
                field(Cashier;Cashier)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Posting date";"Posting date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Total Amount";"Total Amount")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Amount Paid";"Amount Paid")
                {
                    ApplicationArea = Basic;
                }
                field("Payment Method";"Payment Method")
                {
                    ApplicationArea = Basic;
                }
                field("Till Number";"Till Number")
                {
                    ApplicationArea = Basic;
                }
                field("M-Pesa Transaction Number";"M-Pesa Transaction Number")
                {
                    ApplicationArea = Basic;
                    Caption = 'Transaction Code';
                }
                field(Balance;Balance)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
            group(Control1000000008)
            {
                part(Control1000000015;"POS Sales Lines")
                {
                    SubPageLink = "Document No."=field("No."),
                                  "Serving Category"=field("Customer Type"),
                                  "Posting date"=field("Posting date");
                }
            }
        }
    }

