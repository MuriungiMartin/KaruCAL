#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51091 "Receipts Correction"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Receipts Correction.rdlc';

    dataset
    {
        dataitem(UnknownTable61538;UnknownTable61538)
        {
            DataItemTableView = sorting("Receipt No.");
            RequestFilterFields = "Student No.";
            column(ReportForNavId_5672; 5672)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(USERID;UserId)
            {
            }
            column(Receipt__Student_No__;"Student No.")
            {
            }
            column(Receipt__Receipt_No__;"Receipt No.")
            {
            }
            column(Receipt_Date;Date)
            {
            }
            column(Receipt_Amount;Amount)
            {
            }
            column(ReceiptCaption;ReceiptCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Receipt__Student_No__Caption;FieldCaption("Student No."))
            {
            }
            column(Receipt__Receipt_No__Caption;FieldCaption("Receipt No."))
            {
            }
            column(Receipt_DateCaption;FieldCaption(Date))
            {
            }
            column(Receipt_AmountCaption;FieldCaption(Amount))
            {
            }

            trigger OnAfterGetRecord()
            begin
                  DetL.Reset;
                  DetL.SetRange(DetL."Customer No.","ACA-Receipt"."Student No.");
                  DetL.SetRange(DetL."Posting Date","ACA-Receipt"."Transaction Date");
                  DetL.SetRange(DetL."Document No.",'REC-07044');
                  if DetL.Find('-') then begin
                  repeat
                 // if DetL."Document No."<>Receipt."Receipt No." then begin
                 // if (DetL.Amount=Receipt.Amount) or (DetL.Amount=-Receipt.Amount) then begin
                  DetL."Document No.":="ACA-Receipt"."Receipt No.";
                  DetL.Modify;
                 // end;
                 // end;
                  until DetL.Next=0;
                  end;

                  CustL.Reset;
                  CustL.SetRange(CustL."Customer No.","ACA-Receipt"."Student No.") ;
                  CustL.SetRange(CustL."Posting Date","ACA-Receipt"."Transaction Date");
                  CustL.SetFilter(CustL."Document No.",'REC-07044');
                  if CustL.Find('-') then begin
                  //if CustL."Document No."<>Receipt."Receipt No." then begin
                  CustL."Document No.":="ACA-Receipt"."Receipt No.";
                  CustL.Modify;
                 // end;
                  end;

                   BankL.Reset;
                   BankL.SetRange(BankL."Bal. Account No.","ACA-Receipt"."Student No.");
                   BankL.SetRange(BankL."Posting Date","ACA-Receipt"."Transaction Date");
                   BankL.SetRange(BankL."Document No.",'REC-07044');
                   if BankL.Find('-') then begin
                   BankL."Document No.":="ACA-Receipt"."Receipt No.";
                   BankL.Modify;
                   end;

                   GLE.Reset;
                   GLE.SetRange(GLE."Bal. Account No.","ACA-Receipt"."Student No.");
                   GLE.SetRange(GLE."Posting Date","ACA-Receipt"."Transaction Date");
                   GLE.SetRange(GLE."Document No.",'REC-07044');
                   if GLE.Find('-') then begin
                   GLE."Document No.":="ACA-Receipt"."Receipt No.";
                   GLE.Modify;
                   end;
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
        CustL: Record "Cust. Ledger Entry";
        DetL: Record "Detailed Cust. Ledg. Entry";
        BankL: Record "Bank Account Ledger Entry";
        GLE: Record "G/L Entry";
        ReceiptCaptionLbl: label 'Receipt';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

