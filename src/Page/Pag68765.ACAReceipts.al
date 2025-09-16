#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68765 "ACA-Receipts"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = Worksheet;
    SourceTable = UnknownTable61538;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                Editable = true;
                field("Receipt No.";"Receipt No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Bank Slip/Cheque No";"Bank Slip/Cheque No")
                {
                    ApplicationArea = Basic;
                }
                field(Reversed;Reversed)
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field(Date;Date)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Transaction Date";"Transaction Date")
                {
                    ApplicationArea = Basic;
                }
                field("Payment Mode";"Payment Mode")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("User ID";"User ID")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Payment By";"Payment By")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Preview)
            {
                ApplicationArea = Basic;
                Caption = 'Preview';
                Image = Receipt;
                Promoted = true;
                PromotedCategory = "Report";

                trigger OnAction()
                begin
                    TestField(Reversed,false);
                    Receipts.Reset;
                    Receipts.SetRange(Receipts."Receipt No.","Receipt No.");
                    if Receipts.Find('-') then
                    //REPORT.RUN(39005949,TRUE,FALSE,Receipts);
                    Report.Run(51524,true,false,Receipts);
                end;
            }
        }
    }

    var
        Receip: Record UnknownRecord61538;
        Receipts: Record UnknownRecord61538;
}

