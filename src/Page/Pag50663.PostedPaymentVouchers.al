#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50663 "Posted Payment Vouchers"
{
    CardPageID = "Posted Payment Header UP";
    DelayedInsert = false;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = UnknownTable60200;
    SourceTableView = where(Status=filter(Posted));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                }
                field(Date;Date)
                {
                    ApplicationArea = Basic;
                }
                field("Currency Factor";"Currency Factor")
                {
                    ApplicationArea = Basic;
                }
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Basic;
                }
                field(Payee;Payee)
                {
                    ApplicationArea = Basic;
                }
                field("On Behalf Of";"On Behalf Of")
                {
                    ApplicationArea = Basic;
                }
                field(Cashier;Cashier)
                {
                    ApplicationArea = Basic;
                }
                field(Posted;Posted)
                {
                    ApplicationArea = Basic;
                }
                field("Date Posted";"Date Posted")
                {
                    ApplicationArea = Basic;
                }
                field("Time Posted";"Time Posted")
                {
                    ApplicationArea = Basic;
                }
                field("Posted By";"Posted By")
                {
                    ApplicationArea = Basic;
                }
                field("Total Payment Amount";"Total Payment Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Paying Bank Account";"Paying Bank Account")
                {
                    ApplicationArea = Basic;
                }
                field("Global Dimension 1 Code";"Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
                field("Payment Type";"Payment Type")
                {
                    ApplicationArea = Basic;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Function Name";"Function Name")
                {
                    ApplicationArea = Basic;
                }
                field("Budget Center Name";"Budget Center Name")
                {
                    ApplicationArea = Basic;
                }
                field("Bank Name";"Bank Name")
                {
                    ApplicationArea = Basic;
                }
                field("No. Series";"No. Series")
                {
                    ApplicationArea = Basic;
                }
                field(Select;Select)
                {
                    ApplicationArea = Basic;
                }
                field("Total VAT Amount";"Total VAT Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Total Witholding Tax Amount";"Total Witholding Tax Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Total Net Amount";"Total Net Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Current Status";"Current Status")
                {
                    ApplicationArea = Basic;
                }
                field("Cheque No.";"Cheque No.")
                {
                    ApplicationArea = Basic;
                }
                field("Pay Mode";"Pay Mode")
                {
                    ApplicationArea = Basic;
                }
                field("Payment Release Date";"Payment Release Date")
                {
                    ApplicationArea = Basic;
                }
                field("No. Printed";"No. Printed")
                {
                    ApplicationArea = Basic;
                }
                field("VAT Base Amount";"VAT Base Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Exchange Rate";"Exchange Rate")
                {
                    ApplicationArea = Basic;
                }
                field("Currency Reciprical";"Currency Reciprical")
                {
                    ApplicationArea = Basic;
                }
                field("Current Source A/C Bal.";"Current Source A/C Bal.")
                {
                    ApplicationArea = Basic;
                }
                field("Cancellation Remarks";"Cancellation Remarks")
                {
                    ApplicationArea = Basic;
                }
                field("Register Number";"Register Number")
                {
                    ApplicationArea = Basic;
                }
                field("From Entry No.";"From Entry No.")
                {
                    ApplicationArea = Basic;
                }
                field("To Entry No.";"To Entry No.")
                {
                    ApplicationArea = Basic;
                }
                field("Invoice Currency Code";"Invoice Currency Code")
                {
                    ApplicationArea = Basic;
                }
                field("Total Payment Amount LCY";"Total Payment Amount LCY")
                {
                    ApplicationArea = Basic;
                }
                field("Document Type";"Document Type")
                {
                    ApplicationArea = Basic;
                }
                field("Shortcut Dimension 3 Code";"Shortcut Dimension 3 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Shortcut Dimension 4 Code";"Shortcut Dimension 4 Code")
                {
                    ApplicationArea = Basic;
                }
                field(Dim3;Dim3)
                {
                    ApplicationArea = Basic;
                }
                field(Dim4;Dim4)
                {
                    ApplicationArea = Basic;
                }
                field("Responsibility Center";"Responsibility Center")
                {
                    ApplicationArea = Basic;
                }
                field("Cheque Type";"Cheque Type")
                {
                    ApplicationArea = Basic;
                }
                field("Total Retention Amount";"Total Retention Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Payment Narration";"Payment Narration")
                {
                    ApplicationArea = Basic;
                }
                field("Total PAYE Amount";"Total PAYE Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Reference No.";"Reference No.")
                {
                    ApplicationArea = Basic;
                }
                field("Cheque Printed";"Cheque Printed")
                {
                    ApplicationArea = Basic;
                }
                field("Apply to Document Type";"Apply to Document Type")
                {
                    ApplicationArea = Basic;
                }
                field("Apply to Document No";"Apply to Document No")
                {
                    ApplicationArea = Basic;
                }
                field("Imprest No.";"Imprest No.")
                {
                    ApplicationArea = Basic;
                }
                field("Claim No.";"Claim No.")
                {
                    ApplicationArea = Basic;
                }
                field("PF No";"PF No")
                {
                    ApplicationArea = Basic;
                }
                field(Semester;Semester)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Functions")
            {
                Caption = '&Functions';
                action("Print/Preview")
                {
                    ApplicationArea = Basic;
                    Caption = 'Print/Preview';
                    Image = PreviewChecks;
                    Promoted = true;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        if Status=Status::Pending then
                           //ERROR('You cannot Print until the document is released for approval');
                        Reset;
                        SetFilter("No.","No.");
                        Report.Run(60137,true,true,Rec);
                        Reset;
                    end;
                }
            }
        }
    }
}

