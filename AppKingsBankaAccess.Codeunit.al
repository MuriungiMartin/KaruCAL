#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 50100 AppKingsBankaAccess
{

    trigger OnRun()
    begin
        //MESSAGE('%1',FORMAT(GetStudent('104P08095')));

        //MESSAGE('%1',FORMAT(InsertBankTransactions('104P08095',300.00,'ertty')));
        //MESSAGE('%1',FORMAT(InsertBankTransactions('testtrans','104P08095','Description','Cheque N0',
        //TODAY,300.0,'test1234','cyrus munyao','24470677','Y1S1')));
    end;

    var
        "Student Record": Record Customer;
        "Bank Transactions": Record UnknownRecord61640;


    procedure GetStudent(StudentNo: Text) Exists: Boolean
    begin
         "Student Record".Reset;
         Exists:=false;
         "Student Record".SetRange("Student Record"."No.",StudentNo);
         if "Student Record".Find('-') then
         Exists:=true;
        exit(Exists);
    end;


    procedure InsertBankTransactions(TransactionCode: Text;StudentNo: Text;Description: Text;"Cheque No": Text;TransactionDate: Date;TransactionAmount: Decimal;ReceiptNo: Text;Name: Text;IDNumber: Text;Stage: Text) Response: Text
    begin
          Response:='FAILED;Transaction failed';
         "Bank Transactions".Init;
         if GetStudent(StudentNo)=false then begin
            Error('Transaction student Registration number not found.');
         end
         else
         begin
          "Bank Transactions".Reset;
          "Bank Transactions".SetRange("Bank Transactions"."Transaction Code",TransactionCode);
          if "Bank Transactions".Find('-') then begin
          Error('Duplicate bank refernce number detected.');
            Response:='FAILED;Transaction code already exists';
          exit(Response);
          end;

           "Bank Transactions"."Transaction Code":=TransactionCode;
           "Bank Transactions".Date:=TransactionDate;
           "Bank Transactions".Description:=Description;
           "Bank Transactions".Amount:=TransactionAmount;
           "Bank Transactions".Posted:=false;
           "Bank Transactions"."Receipt No":=ReceiptNo;
           "Bank Transactions"."Student No.":=StudentNo;
           "Bank Transactions".Unallocated:=true;
           "Bank Transactions"."Cheque No":="Cheque No";
           "Bank Transactions".Name:=Name;
           "Bank Transactions".IDNo:=IDNumber;
           "Bank Transactions"."Stud Exist":=1;
           "Bank Transactions".Stage:=Stage;
          "Bank Transactions".Insert(true);
          "Bank Transactions".Reset;
          "Bank Transactions".SetRange("Bank Transactions"."Transaction Code",TransactionCode);
          if "Bank Transactions".Find('-') then
          Response:='OK;Transaction Successful';

          end;

        exit(Response);
    end;


    procedure GetStudentDetails(StudentNo: Text) stringValue: Text[400]
    begin
         "Student Record".Reset;
         "Student Record".SetRange("Student Record"."No.",StudentNo);
         if "Student Record".Find('-') then begin
         stringValue:="Student Record"."No."+';'+"Student Record"."Search Name";
         end;
         if(stringValue='') then
         Error('Student Registration Number could not be found in our system');
         exit(stringValue);
    end;
}

