#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68319 "FIN-Posted Staff Claim List"
{
    ApplicationArea = Basic;
    CardPageID = "FIN-Posted Staff Claims";
    Editable = false;
    PageType = List;
    SourceTable = UnknownTable61602;
    SourceTableView = where(Posted=filter(Yes));
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                }
                field(Date;Date)
                {
                    ApplicationArea = Basic;
                }
                field(Payee;Payee)
                {
                    ApplicationArea = Basic;
                }
                field(Cashier;Cashier)
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
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
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Basic;
                }
                field("Total Net Amount";"Total Net Amount")
                {
                    ApplicationArea = Basic;
                    Caption = 'Amount';
                }
                field("Total Net Amount LCY";"Total Net Amount LCY")
                {
                    ApplicationArea = Basic;
                    Caption = 'Amount LCY';
                }
                field("Responsibility Center";"Responsibility Center")
                {
                    ApplicationArea = Basic;
                }
                field(Purpose;Purpose)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Print/Preview")
            {
                ApplicationArea = Basic;
                Caption = 'Print/Preview';
                Image = "Report";
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Reset;
                    SetFilter("No.","No.");
                    Report.Run(69272,true,true,Rec);
                    Reset;
                end;
            }
        }
    }
}

