#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51769 "Remove Billings & Receipts"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Remove Billings & Receipts.rdlc';

    dataset
    {
        dataitem(Customer;Customer)
        {
            DataItemTableView = where("Customer Type"=filter(Student));
            column(ReportForNavId_1; 1)
            {
            }

            trigger OnAfterGetRecord()
            begin
                    // Remove Customer Ledger Entries
                   /*
                    custLedgerEntry.RESET;
                   custLedgerEntry.SETRANGE(custLedgerEntry."Journal Batch Name",'REP');
                
                   //custLedgerEntry.SETRANGE(custLedgerEntry."Customer No.",Customer."No.");
                
                   //custLedgerEntry.setfilter(custLedgerEntry."Posting Date",'>%1',063014);
                   IF custLedgerEntry.FIND('-') THEN BEGIN
                  // message('Cust entries '+format(custLedgerEntry.COUNT));
                    custLedgerEntry.DELETEALL;
                   END;
                
                  // Remove Detailed Customer Ledger Entry
                  DetailedcustLedgerEntry.RESET;
                  DetailedcustLedgerEntry.SETRANGE(DetailedcustLedgerEntry."Journal Batch Name",'REP');
                  //DetailedcustLedgerEntry.SETRANGE(DetailedcustLedgerEntry."Customer No.",Customer."No.");
                
                  //DetailedcustLedgerEntry.setfilter(DetailedcustLedgerEntry."Posting Date",'>%1','06/30/14');
                  IF DetailedcustLedgerEntry.FIND('-') THEN BEGIN
                  //message('Cust entries '+format(DetailedcustLedgerEntry.COUNT));
                  DetailedcustLedgerEntry.DELETEALL;
                  END;
                   */
                
                
                  // Remove G/L Ledger Entries
                  GlLedgerEntry.Reset;
                  GlLedgerEntry.SetRange(GlLedgerEntry."Journal Batch Name",'CRED');
                  //GlLedgerEntry.SETRANGE(GlLedgerEntry."Bal. Account No.",Customer."No.");
                  //GlLedgerEntry.setfilter(GlLedgerEntry."Posting Date",'>%1','06/30/14');
                  if GlLedgerEntry.Find('-') then begin
                  //message('Cust entries '+format(GlLedgerEntry.COUNT));
                  GlLedgerEntry.DeleteAll;
                  end;
                
                  vendledger.Reset;
                  vendledger.SetRange(vendledger."Journal Batch Name",'CRED');
                  if vendledger.Find('-') then begin
                  vendledger.DeleteAll;
                   end;
                
                  Detailedvend.Reset;
                  Detailedvend.SetRange(Detailedvend."Journal Batch Name",'CRED');
                  if Detailedvend.Find('-') then begin
                  Detailedvend.DeleteAll;
                  end;
                
                  /*
                  // Remove Bank Ledger Entries
                  BankLedgerEntry.RESET;
                  BankLedgerEntry.SETRANGE(BankLedgerEntry."Journal Batch Name",'CRED');
                  //BankLedgerEntry.SETRANGE(BankLedgerEntry."Bal. Account No.",Customer."No.");
                  //BankLedgerEntry.setfilter(BankLedgerEntry."Posting Date",'>%1','06/30/14');
                  IF BankLedgerEntry.FIND('-') THEN BEGIN
                  //message('Cust entries '+format(BankLedgerEntry.COUNT));
                   BankLedgerEntry.DELETEALL;
                  END;
                       */

            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        custLedgerEntry: Record "Cust. Ledger Entry";
        DetailedcustLedgerEntry: Record "Detailed Cust. Ledg. Entry";
        BankLedgerEntry: Record "Bank Account Ledger Entry";
        GlLedgerEntry: Record "G/L Entry";
        vendledger: Record "Vendor Ledger Entry";
        Detailedvend: Record "Detailed Vendor Ledg. Entry";
}

