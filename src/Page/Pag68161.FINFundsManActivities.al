#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68161 "FIN-Funds Man. Activities"
{
    Caption = 'Activities';
    PageType = CardPart;
    SourceTable = UnknownTable61073;

    layout
    {
        area(content)
        {
            cuegroup("Pending Payment Documents")
            {
                Caption = 'Pending Payment Documents';
                field("Interbank Not Posted";"Interbank Not Posted")
                {
                    ApplicationArea = Basic;
                    Caption = 'Interbank Transfers';
                }
                field("PV Not Posted";"PV Not Posted")
                {
                    ApplicationArea = Basic;
                    Caption = 'Payment Vouchers';
                }
                field("PCV Not Posted";"PCV Not Posted")
                {
                    ApplicationArea = Basic;
                    Caption = 'Petty Cash Vouchers';
                }
                field("Store Req. Not Posted";"Store Req. Not Posted")
                {
                    ApplicationArea = Basic;
                    Caption = 'Store Requisitions';
                }

                actions
                {
                    action("Bank & Cash Transfer")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Bank & Cash Transfer';
                        RunObject = Page "FIN-Bank & Cash Trans. List";
                    }
                    action(Receipt)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Receipt';
                        RunObject = Page "FIN-Receipts List";
                        RunPageView = where(Posted=const(false));
                    }
                    action("Payment Voucher ")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Payment Vouchers';
                        Image = CreateReminders;
                        RunObject = Page "FIN-Payment Vouchers List";
                    }
                    action("Petty Cash Vouchers")
                    {
                        ApplicationArea = Basic;
                        RunObject = Page "FIN-Petty Cash Vouchers List";
                    }
                }
            }
            cuegroup("Pending Travel Documents")
            {
                Caption = 'Pending Travel Documents';
                field("Staff Travel Not Posted";"Staff Travel Not Posted")
                {
                    ApplicationArea = Basic;
                    Caption = 'Travel Advance';
                }
                field("Staff TA Not Posted";"Staff TA Not Posted")
                {
                    ApplicationArea = Basic;
                    Caption = 'Travel Accounting';
                }
                field("Other Advance Not Posted";"Other Advance Not Posted")
                {
                    ApplicationArea = Basic;
                    Caption = 'Other Advance';
                }
                field("Staff Claim Not Posted";"Staff Claim Not Posted")
                {
                    ApplicationArea = Basic;
                    Caption = 'Staff Claim';
                }

                actions
                {
                    action("Staff Travel Advance")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Staff Travel Advance';
                        RunObject = Page "FIN-Travel Advance Vouch List";
                    }
                    action("Travel Advance Accounting")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Travel Advance Accounting';
                        RunObject = Page "FIN-Travel Advances Acct. List";
                    }
                    action("Staff Claims")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Staff Claims';
                        RunObject = Page "FIN-Staff Claim List";
                    }
                    action("Other Advances")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Other Advances';
                        RunObject = Page "FIN-Staff Adv. Request List";
                    }
                    action("Other Advances Accounting")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Other Advances Accounting';
                        RunObject = Page "FIN-Staff Advance Surr. List";
                    }
                }
            }
            cuegroup("Document Approval")
            {
                Caption = 'Document Approval';
                field("Interbank Pending Approval";"Interbank Pending Approval")
                {
                    ApplicationArea = Basic;
                    Caption = 'Interbank Transfers';
                }
                field("PV Pending Approval";"PV Pending Approval")
                {
                    ApplicationArea = Basic;
                    Caption = 'Payment Vouchers';
                }
                field("PCV Pending Approval";"PCV Pending Approval")
                {
                    ApplicationArea = Basic;
                    Caption = 'Petty Cash Vouchers';
                }
                field("Staff Travel Pending Approval";"Staff Travel Pending Approval")
                {
                    ApplicationArea = Basic;
                    Caption = 'Staff Travel Advance';
                }
                field("Staff TA Pending Approval";"Staff TA Pending Approval")
                {
                    ApplicationArea = Basic;
                    Caption = 'Staff Travel Advance Accounting';
                }
                field("Approval Entries";"Approval Entries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Approval Entries';
                    DrillDownPageID = "Approval Entries";
                    LookupPageID = "Approval Entries";
                }
            }
            cuegroup(Control30)
            {
                field("Other Advance Pending Approval";"Other Advance Pending Approval")
                {
                    ApplicationArea = Basic;
                    Caption = 'Other Advance';
                }
                field("Staff Claim Pending Approval";"Staff Claim Pending Approval")
                {
                    ApplicationArea = Basic;
                    Caption = 'Staff Claims';
                }
                field("Requisitions Pending Approval";"Requisitions Pending Approval")
                {
                    ApplicationArea = Basic;
                    Caption = 'Purchase Requisitions';
                }
                field("Store Req. Pending Approval";"Store Req. Pending Approval")
                {
                    ApplicationArea = Basic;
                    Caption = 'Store Requisitions';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        Reset;
        if not Get then begin
          Init;
          Insert;
        end;

        SetFilter("Due Date Filter",'<=%1',WorkDate);
        SetFilter("Overdue Date Filter",'<%1',WorkDate);
    end;
}

