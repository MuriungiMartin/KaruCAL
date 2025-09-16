#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 99428 "POS Receipts List (STD)"
{
    ApplicationArea = Basic;
    CardPageID = "Sales Card (Students)";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "POS Sales Header";
    SourceTableView = where("Customer Type"=filter(Student),
                            Posted=filter(false));
    UsageCategory = Lists;

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
                field("Posting Description";"Posting Description")
                {
                    ApplicationArea = Basic;
                }
                field("Customer Type";"Customer Type")
                {
                    ApplicationArea = Basic;
                }
                field("Bank Account";"Bank Account")
                {
                    ApplicationArea = Basic;
                }
                field("Receipt Amount";"Receipt Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Income Account";"Income Account")
                {
                    ApplicationArea = Basic;
                }
                field("Amount Paid";"Amount Paid")
                {
                    ApplicationArea = Basic;
                }
                field(Balance;Balance)
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
                field("Payment Method";"Payment Method")
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
                field(Location;Location)
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
            action(PrintCopy)
            {
                ApplicationArea = Basic;
                Caption = 'Print Copy';
                Image = PrintVoucher;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = false;

                trigger OnAction()
                begin
                    Clear(POSSalesHeader);
                    POSSalesHeader.Reset;
                    POSSalesHeader.SetRange("No.",Rec."No.");
                    if POSSalesHeader.Find('-') then
                      Report.Run(99413,true,false,POSSalesHeader);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.SetFilter(Cashier,UserId);
    end;

    trigger OnOpenPage()
    begin
        Rec.SetFilter(Cashier,UserId);
    end;

    var
        POSSalesHeader: Record "POS Sales Header";
}

