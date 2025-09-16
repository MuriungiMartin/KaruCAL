#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 70287 "Student Balances Per Semester"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Student Balances Per Semester.rdlc';

    dataset
    {
        dataitem(UnknownTable61532;UnknownTable61532)
        {
            DataItemTableView = sorting("Student No.") order(ascending) where(Reversed=const(No));
            RequestFilterFields = Semester,Stage;
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(StudNo;"ACA-Course Registration"."Student No.")
            {
            }
            column(stype;"ACA-Course Registration"."Settlement Type")
            {
            }
            column(DebitAmount;DebitAmount)
            {
            }
            column(CreditAmount;CreditAmount)
            {
            }
            column(Balance;Balance)
            {
            }
            column(Sequence;sn)
            {
            }
            column(Status;"ACA-Course Registration".Status)
            {
            }
            column(CustName;CustName)
            {
            }
            column(OpeningBalance;OpeningBalance)
            {
            }
            column(ClosingBalance;ClosingBalance)
            {
            }

            trigger OnAfterGetRecord()
            begin
                sn:=sn+1;
                OpeningBalance:=0;
                ClosingBalance:=0;
                DebitAmount:=0;
                CreditAmount:=0;
                Balance:=0;
                /*Sem.RESET;
                Sem.SETRANGE(Code,SemesterFilter);
                IF Sem.FIND('-') THEN BEGIN
                  StarDate:=Sem.From;
                  EndDate:=Sem."Registration Deadline";*/
                //  DetailedLedgers.SETRANGE("Customer No.","ACA-Course Registration"."Student No.");
                //  DetailedLedgers.SETFILTER("Posting Date",'%1..%2',StarDate,EndDate);
                //  DetailedLedgers.SETFILTER("Entry Type",'%1',DetailedLedgers."Entry Type"::"Initial Entry");
                // IF  DetailedLedgers.FIND('-') THEN BEGIN
                //  DetailedLedgers.CALCSUMS("Debit Amount");
                //  DebitAmount:=DetailedLedgers."Debit Amount";
                //  DetailedLedgers.CALCSUMS("Credit Amount");
                //  CreditAmount:=DetailedLedgers."Credit Amount";
                //  Balance:=-CreditAmount+DebitAmount;
                //  END;
                
                  //.END;
                  Cust.Reset;
                  Cust.SetRange("No.","ACA-Course Registration"."Student No.");
                  if Cust.Find('-') then begin
                  CustName:=Cust.Name;
                  end;
                
                OpeningBalance:=0;
                ClosingBalance:=0;
                
                CustRec.Reset;
                CustRec.SetRange(CustRec."No.","ACA-Course Registration"."Student No.");
                CustRec.SetFilter("Date Filter",'%1..%2',StarDate,EndDate);
                CustRec.SetAutocalcFields(Balance,"Credit Amount","Debit Amount");
                if CustRec.FindFirst then begin
                  DebitAmount:=CustRec."Debit Amount";
                  CreditAmount:=CustRec."Credit Amount";
                  Balance:=DebitAmount-CreditAmount;
                end;
                
                
                CustRec.Reset;
                CustRec.SetRange(CustRec."No.","ACA-Course Registration"."Student No.");
                CustRec.SetFilter("Date Filter",'..%1',CalcDate('-1D',StarDate));
                CustRec.SetAutocalcFields(Balance);
                if CustRec.FindFirst then begin
                OpeningBalance:=CustRec.Balance;
                end;
                
                CustRec.Reset;
                CustRec.SetRange(CustRec."No.","ACA-Course Registration"."Student No.");
                CustRec.SetFilter("Date Filter",'..%1',EndDate);
                CustRec.SetAutocalcFields(Balance);
                if CustRec.FindFirst then begin
                ClosingBalance:=CustRec.Balance;
                end;

            end;

            trigger OnPreDataItem()
            begin
                //"ACA-Course Registration".SETFILTER(Semester,'%1',SemesterFilter);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Start Date";StarDate)
                {
                    ApplicationArea = Basic;
                }
                field(EndDate;EndDate)
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
        DebitAmount: Decimal;
        CreditAmount: Decimal;
        Balance: Decimal;
        DetailedLedgers: Record "Detailed Cust. Ledg. Entry";
        Cust: Record Customer;
        CustName: Text[250];
        SemesterFilter: Code[20];
        StarDate: Date;
        EndDate: Date;
        Sem: Record UnknownRecord61692;
        sn: Integer;
        OpeningBalance: Decimal;
        ClosingBalance: Decimal;
        CustRec: Record Customer;
}

