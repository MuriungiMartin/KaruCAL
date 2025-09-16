#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51764 "Bank Payments Report mst"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Bank Payments Report mst.rdlc';

    dataset
    {
        dataitem("Bank Account";"Bank Account")
        {
            column(ReportForNavId_1102755000; 1102755000)
            {
            }
            dataitem(UnknownTable61421;UnknownTable61421)
            {
                DataItemLink = "Paying Bank Account"=field("No."),"Payment Release Date"=field("Date Filter"),"Global Dimension 1 Code"=field("Global Dimension 1 Filter"),"Shortcut Dimension 2 Code"=field("Global Dimension 2 Filter");
                column(ReportForNavId_1102755001; 1102755001)
                {
                }
                column(No_PaymentsHeader;"Payments Header"."No.")
                {
                }
                column(Cashier_PaymentsHeader;"Payments Header".Cashier)
                {
                }
                column(TotalNetAmount_PaymentsHeader;"Payments Header"."Total Net Amount")
                {
                }
                column(ChequeNo_PaymentsHeader;"Payments Header"."Cheque No.")
                {
                }
                column(PayMode_PaymentsHeader;"Payments Header"."Pay Mode")
                {
                }
                dataitem(PVLedgers;"Bank Account Ledger Entry")
                {
                    DataItemLink = "Document No."=field("No.");
                    column(ReportForNavId_1102755030; 1102755030)
                    {
                    }
                    column(EntryNo_PVLedgers;PVLedgers."Entry No.")
                    {
                    }
                    column(BankAccountNo_PVLedgers;PVLedgers."Bank Account No.")
                    {
                    }
                    column(PostingDate_PVLedgers;PVLedgers."Posting Date")
                    {
                    }
                    column(DocumentType_PVLedgers;PVLedgers."Document Type")
                    {
                    }
                    column(DocumentNo_PVLedgers;PVLedgers."Document No.")
                    {
                    }
                    column(Description_PVLedgers;PVLedgers.Description)
                    {
                    }
                    column(CurrencyCode_PVLedgers;PVLedgers."Currency Code")
                    {
                    }
                    column(Amount_PVLedgers;PVLedgers.Amount)
                    {
                    }
                    column(RemainingAmount_PVLedgers;PVLedgers."Remaining Amount")
                    {
                    }
                }

                trigger OnPreDataItem()
                begin
                    SetRange("Pay Mode","Payment Mode");
                end;
            }
            dataitem(UnknownTable61455;UnknownTable61455)
            {
                DataItemLink = "Paying Bank Account"=field("No."),"Payment Release Date"=field("Date Filter"),"Global Dimension 1 Code"=field("Global Dimension 1 Filter"),"Shortcut Dimension 2 Code"=field("Global Dimension 2 Filter");
                column(ReportForNavId_1102755002; 1102755002)
                {
                }
                column(No_StaffAdvanceHeader;"Staff Advance Header"."No.")
                {
                }
                column(Cashier_StaffAdvanceHeader;"Staff Advance Header".Cashier)
                {
                }
                column(TotalNetAmount_StaffAdvanceHeader;"Staff Advance Header"."Total Net Amount")
                {
                }
                column(ChequeNo_StaffAdvanceHeader;"Staff Advance Header"."Cheque No.")
                {
                }
                column(PayMode_StaffAdvanceHeader;"Staff Advance Header"."Pay Mode")
                {
                }

                trigger OnPreDataItem()
                begin
                    SetRange("Pay Mode","Payment Mode");
                end;
            }
            dataitem(UnknownTable61414;UnknownTable61414)
            {
                DataItemLink = "Paying Account"=field("No."),"Date Posted"=field("Date Filter"),"Source Depot Code"=field("Global Dimension 1 Filter"),"Source Department Code"=field("Global Dimension 2 Filter");
                column(ReportForNavId_1102755003; 1102755003)
                {
                }
                column(ExternalDocNo_InterBankTransfers;"InterBank Transfers"."External Doc No.")
                {
                }
                column(No_InterBankTransfers;"InterBank Transfers".No)
                {
                }
                column(PayMode_InterBankTransfers;"InterBank Transfers"."Pay Mode")
                {
                }
                column(Amount_InterBankTransfers;"InterBank Transfers".Amount)
                {
                }

                trigger OnPreDataItem()
                begin
                    SetRange("Pay Mode","Payment Mode");
                end;
            }
            dataitem(UnknownTable61450;UnknownTable61450)
            {
                DataItemLink = "Paying Bank Account"=field("No."),"Payment Release Date"=field("Date Filter"),"Global Dimension 1 Code"=field("Global Dimension 1 Filter"),"Shortcut Dimension 2 Code"=field("Global Dimension 2 Filter");
                column(ReportForNavId_1102755004; 1102755004)
                {
                }
                column(Cashier_ImprestHeader;"Imprest Header".Cashier)
                {
                }
                column(No_ImprestHeader;"Imprest Header"."No.")
                {
                }
                column(TotalNetAmount_ImprestHeader;"Imprest Header"."Total Net Amount")
                {
                }
                column(ChequeNo_ImprestHeader;"Imprest Header"."Cheque No.")
                {
                }
                column(PayMode_ImprestHeader;"Imprest Header"."Pay Mode")
                {
                }

                trigger OnPreDataItem()
                begin
                    SetRange("Pay Mode","Payment Mode");
                end;
            }
            dataitem(UnknownTable61457;UnknownTable61457)
            {
                DataItemLink = "Paying Bank Account"=field("No."),"Imprest Issue Date"=field("Date Filter"),"Global Dimension 1 Code"=field("Global Dimension 1 Filter"),"Shortcut Dimension 2 Code"=field("Global Dimension 2 Filter");
                column(ReportForNavId_1102755005; 1102755005)
                {
                }
                column(No_StaffAdvanceSurrenderHeader;"Staff Advance Surrender Header".No)
                {
                }
                column(PayMode_StaffAdvanceSurrenderHeader;"Staff Advance Surrender Header"."Pay Mode")
                {
                }
                column(ChequeNo_StaffAdvanceSurrenderHeader;"Staff Advance Surrender Header"."Cheque No")
                {
                }
                column(Cashier_StaffAdvanceSurrenderHeader;"Staff Advance Surrender Header".Cashier)
                {
                }
                column(Amount_StaffAdvanceSurrenderHeader;"Staff Advance Surrender Header".Amount)
                {
                }

                trigger OnPreDataItem()
                begin
                    SetRange("Pay Mode","Payment Mode");
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Payment mode";"Payment Mode")
                {
                    ApplicationArea = Basic;
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        "Payment Mode": Option " ",Cash,Cheque,EFT,"Letter of Credit","Custom 3","Custom 4","Custom 5";
}

