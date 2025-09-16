#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51103 prPayrollJournalTransfer
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(UnknownTable61105;UnknownTable61105)
        {
            RequestFilterFields = "Period Filter","Employee Code","Period Month";
            column(ReportForNavId_6207; 6207)
            {
            }

            trigger OnAfterGetRecord()
            begin
                //For use when posting Pension and NSSF
                objPeriod.Reset;
                objPeriod.SetRange(objPeriod."Date Opened",SelectedPeriod);
                if objPeriod.Find('-') then begin
                
                //Get the staff details (header)
                objEmp.SetRange(objEmp."No.","Employee Code");
                if objEmp.Find('-') then
                begin
                   strEmpName:='['+"Employee Code"+'] '+objEmp."Last Name"+' '+objEmp."First Name"+' '+objEmp."Middle Name";
                   GlobalDim1:=objEmp."Department Code";
                end;
                
                LineNumber:=LineNumber+10;
                
                
                PeriodTrans.Reset;
                PeriodTrans.SetRange(PeriodTrans."Employee Code","Employee Code");
                PeriodTrans.SetRange(PeriodTrans."Payroll Period",SelectedPeriod);
                if PeriodTrans.Find('-') then begin
                repeat
                
                  if PeriodTrans."Journal Account Code"<>'' then begin
                
                    /* SaccoTransactionType:=SaccoTransactionType::" ";
                
                    IF PeriodTrans."coop parameters" = PeriodTrans."coop parameters"::loan THEN
                       SaccoTransactionType:=SaccoTransactionType::Repayment;
                
                    IF PeriodTrans."coop parameters" = PeriodTrans."coop parameters"::"loan Interest" THEN
                       SaccoTransactionType:=SaccoTransactionType::"Interest Paid";
                
                    IF PeriodTrans."coop parameters" = PeriodTrans."coop parameters"::Welfare THEN
                       SaccoTransactionType:=SaccoTransactionType::"Welfare Contribution";
                
                    IF PeriodTrans."coop parameters" = PeriodTrans."coop parameters"::shares THEN
                       SaccoTransactionType:=SaccoTransactionType::"Deposit Contribution";
                    */
                
                
                // Insert into Journal Details
                
                PayrollJournalDetails.Reset;
                PayrollJournalDetails.SetRange(PayrollJournalDetails."Employee Code",PeriodTrans."Employee Code");
                PayrollJournalDetails.SetRange(PayrollJournalDetails."Transaction Code",PeriodTrans."Transaction Code");
                PayrollJournalDetails.SetRange(PayrollJournalDetails."Period Month",PeriodTrans."Period Month");
                PayrollJournalDetails.SetRange(PayrollJournalDetails."Period Year",PeriodTrans."Period Year");
                if PayrollJournalDetails.Find('-') then begin
                PayrollJournalDetails."G/L Account":=PeriodTrans."Journal Account Code";
                PayrollJournalDetails."Posting Description":=CopyStr(objPeriod."Period Name"+' - '+PeriodTrans."Transaction Name",1,50);
                PayrollJournalDetails.Amount:=PeriodTrans.Amount;
                PayrollJournalDetails."Post as":=PeriodTrans."Post As";
                PayrollJournalDetails."coop parameters":=PeriodTrans."coop parameters";
                PayrollJournalDetails."Journal Account Type":=PeriodTrans."Journal Account Type";
                PayrollJournalDetails.Modify;
                end else begin
                PayrollJournalDetails.Init;
                PayrollJournalDetails."Employee Code":=PeriodTrans."Employee Code";
                PayrollJournalDetails."Transaction Code":=PeriodTrans."Transaction Code";
                PayrollJournalDetails."Period Month":=PeriodTrans."Period Month";
                PayrollJournalDetails."Period Year":=PeriodTrans."Period Year";
                PayrollJournalDetails."Transaction Name":=PeriodTrans."Transaction Name";
                PayrollJournalDetails."G/L Account":=PeriodTrans."Journal Account Code";
                PayrollJournalDetails."Posting Description":=CopyStr(objPeriod."Period Name"+' - '+PeriodTrans."Transaction Name",1,50);
                PayrollJournalDetails.Amount:=PeriodTrans.Amount;
                PayrollJournalDetails."Post as":=PeriodTrans."Post As";
                PayrollJournalDetails."coop parameters":=PeriodTrans."coop parameters";
                PayrollJournalDetails."Journal Account Type":=PeriodTrans."Journal Account Type";
                PayrollJournalDetails.Insert;
                end;// Does not exist, Insert
                
                // Insert into Journal Summary
                PayrollJournalSummary.Reset;
                PayrollJournalSummary.SetRange(PayrollJournalSummary."Transaction Code",PeriodTrans."Transaction Code");
                PayrollJournalSummary.SetRange(PayrollJournalSummary."Period Month",PeriodTrans."Period Month");
                PayrollJournalSummary.SetRange(PayrollJournalSummary."Period YearS",PeriodTrans."Period Year");
                if PayrollJournalSummary.Find('-') then begin
                PayrollJournalSummary."G/L Account":=PeriodTrans."Journal Account Code";
                PayrollJournalSummary."Transaction Name":=PeriodTrans."Transaction Name";
                PayrollJournalSummary."Posting Description":=CopyStr(objPeriod."Period Name"+' - '+PeriodTrans."Transaction Name",1,50);
                PayrollJournalSummary."Post as":=PeriodTrans."Post As";
                PayrollJournalSummary."coop parameters":=PeriodTrans."coop parameters";
                PayrollJournalSummary."Journal Account Type":=PeriodTrans."Journal Account Type";
                PayrollJournalSummary.Modify;
                end else begin
                PayrollJournalSummary.Init;
                PayrollJournalSummary."Transaction Code":=PeriodTrans."Transaction Code";
                PayrollJournalSummary."Transaction Name":=PeriodTrans."Transaction Name";
                PayrollJournalSummary."G/L Account":=PeriodTrans."Journal Account Code";
                PayrollJournalSummary."Period Month":=PeriodTrans."Period Month";
                PayrollJournalSummary."Period YearS":=PeriodTrans."Period Year";
                PayrollJournalSummary."Posting Description":=CopyStr(objPeriod."Period Name"+' - '+PeriodTrans."Transaction Name",1,50);
                PayrollJournalSummary."Post as":=PeriodTrans."Post As";
                PayrollJournalSummary."coop parameters":=PeriodTrans."coop parameters";
                PayrollJournalSummary."Journal Account Type":=PeriodTrans."Journal Account Type";
                PayrollJournalSummary.Insert;
                end;
                
                /*
                
                    //Pension
                    IF PeriodTrans."coop parameters"=PeriodTrans."coop parameters"::Pension THEN BEGIN
                      //Get from Employer Deduction
                      EmployerDed.RESET;
                      EmployerDed.SETRANGE(EmployerDed."Employee Code",PeriodTrans."Employee Code");
                      EmployerDed.SETRANGE(EmployerDed."Transaction Code",PeriodTrans."Transaction Code");
                      EmployerDed.SETRANGE(EmployerDed."Payroll Period",PeriodTrans."Payroll Period");
                      IF EmployerDed.FIND('-') THEN BEGIN
                      //Credit Payables
                          CreateJnlEntry(0,PostingGroup."Pension Employee Acc",
                          GlobalDim1,'',PeriodTrans."Transaction Name"+'-'+PeriodTrans."Employee Code",0,
                          EmployerDed.Amount,PeriodTrans."Post As",'',SaccoTransactionType,PostingGroup."Pension Payable Acc");
                
                      //Debit Staff Expense
                          CreateJnlEntry(0,PostingGroup."Pension Employer Acc",
                          GlobalDim1,'',PeriodTrans."Transaction Name"+'-'+PeriodTrans."Employee Code",EmployerDed.Amount,0,1,'',
                          SaccoTransactionType,PostingGroup."Pension Payable Acc");
                
                      END;
                    END;
                
                    //NSSF
                    IF PeriodTrans."coop parameters"=PeriodTrans."coop parameters"::NSSF THEN BEGIN
                       //Credit Payables
                      //Credit Payables
                
                          CreateJnlEntry(0,PostingGroup."NSSF Employee Account",
                          GlobalDim1,'',PeriodTrans."Transaction Name"+'-'+PeriodTrans."Employee Code",0,PeriodTrans.Amount,
                          PeriodTrans."Post As",'',SaccoTransactionType,PostingGroup."NSSF Payable Acc");
                
                      //Debit Staff Expense
                
                          CreateJnlEntry(0,PostingGroup."NSSF Employer Account",
                          GlobalDim1,'',PeriodTrans."Transaction Name"+'-'+PeriodTrans."Employee Code",PeriodTrans.Amount,0,1,'',
                          SaccoTransactionType,PostingGroup."NSSF Payable Acc");
                
                
                    END;*/
                
                
                  end;
                until PeriodTrans.Next=0;
                end;
                end;

            end;

            trigger OnPostDataItem()
            var
                PensionAmountToPost: Decimal;
                NssfAmountToPost: Decimal;
            begin
                objPeriod.Reset;
                objPeriod.SetRange(objPeriod."Date Opened",SelectedPeriod);
                if objPeriod.Find('-') then begin
                  PayrollJournalSummary.Reset;
                PayrollJournalSummary.SetRange(PayrollJournalSummary."Period Month",objPeriod."Period Month");
                PayrollJournalSummary.SetRange(PayrollJournalSummary."Period YearS",objPeriod."Period Year");
                if PayrollJournalSummary.Find('-') then begin
                  repeat
                    begin
                      PayrollJournalSummary.CalcFields(PayrollJournalSummary.Amount);

                  AmountToDebit:=0;AmountToCredit:=0;
                   if PayrollJournalSummary."Post as" =PayrollJournalSummary."post as"::Debit then
                      AmountToDebit:=PayrollJournalSummary.Amount;

                   if PayrollJournalSummary."Post as" =PayrollJournalSummary."post as"::Credit then
                      AmountToCredit:=PayrollJournalSummary.Amount;

                     if PayrollJournalSummary."Journal Account Type" = 1 then
                        IntegerPostAs:=0;
                     if PayrollJournalSummary."Journal Account Type" = 2 then
                        IntegerPostAs:=1;

                      if not (PayrollJournalSummary."coop parameters"=PayrollJournalSummary."coop parameters"::Pension) then begin
                      if not (PayrollJournalSummary."coop parameters"=PayrollJournalSummary."coop parameters"::NSSF) then begin
                        // Neither NSSF Nor Pension
                     CreateJnlEntry(IntegerPostAs,PayrollJournalSummary."G/L Account",
                     GlobalDim1,'',PayrollJournalSummary."Posting Description",AmountToDebit,AmountToCredit,
                     PayrollJournalSummary."Post as",PayrollJournalSummary."Transaction Code",0,PostingGroup."Net Salary Payable");
                        end else begin
                          // NSSF i.e. has employer Factor for NSSF
                            Clear(NssfAmountToPost);
                           EmployerDed.Reset;
                     // EmployerDed.SETRANGE(EmployerDed."Employee Code",PeriodTrans."Employee Code");
                      EmployerDed.SetRange(EmployerDed."Transaction Code",PayrollJournalSummary."Transaction Code");
                      EmployerDed.SetRange(EmployerDed."Payroll Period",objPeriod."Date Opened");
                      if EmployerDed.Find('-') then begin
                        repeat
                          begin
                          NssfAmountToPost:=NssfAmountToPost+EmployerDed.Amount;
                          end;
                          until EmployerDed.Next=0;

                      //Credit Payables
                          CreateJnlEntry(0,PostingGroup."NSSF Employer Account",
                          GlobalDim1,'','Employer-'+PayrollJournalSummary."Posting Description",0,
                          NssfAmountToPost,PayrollJournalSummary."Post as",PayrollJournalSummary."Transaction Code",0,PostingGroup."NSSF Payable Acc");

                      //Debit Staff Expense
                          CreateJnlEntry(0,PostingGroup."NSSF Employer Account",
                          GlobalDim1,'','Employer-'+PayrollJournalSummary."Posting Description",NssfAmountToPost,0,1,'',
                          0,PostingGroup."NSSF Payable Acc");
                      end;
                          end;

                        end else begin
                          // Pension i.e. has employer Factor
                          Clear(PensionAmountToPost);
                           EmployerDed.Reset;
                     // EmployerDed.SETRANGE(EmployerDed."Employee Code",PeriodTrans."Employee Code");
                      EmployerDed.SetRange(EmployerDed."Transaction Code",PayrollJournalSummary."Transaction Code");
                      EmployerDed.SetRange(EmployerDed."Payroll Period",objPeriod."Date Opened");
                      if EmployerDed.Find('-') then begin
                        repeat
                          begin
                          PensionAmountToPost:=PensionAmountToPost+EmployerDed.Amount;
                          end;
                          until EmployerDed.Next=0;

                      //Credit Payables
                          CreateJnlEntry(0,PostingGroup."Pension Employee Acc",
                          GlobalDim1,'','Employer-'+PayrollJournalSummary."Posting Description",0,
                          PensionAmountToPost,PayrollJournalSummary."Post as",PayrollJournalSummary."Transaction Code",0,PostingGroup."Pension Payable Acc");

                      //Debit Staff Expense
                          CreateJnlEntry(0,PostingGroup."Pension Employer Acc",
                          GlobalDim1,'','Employer-'+PayrollJournalSummary."Posting Description",PensionAmountToPost,0,1,'',
                          0,PostingGroup."Pension Payable Acc");
                      end;
                          end;
                    end;
                    until PayrollJournalSummary.Next=0;
                  end;
                  end;

                PayrollJournalDetails.Reset;
                if PayrollJournalDetails.Find('-') then begin
                  PayrollJournalDetails.DeleteAll
                  end;

                PayrollJournalSummary.Reset;
                if PayrollJournalSummary.Find('-') then begin
                PayrollJournalSummary.DeleteAll
                  end;

                Message('Journals Created Successfully');
            end;

            trigger OnPreDataItem()
            begin
                PostingGroup.Get('PAYROLL');
                PostingGroup.TestField("NSSF Employer Account");
                PostingGroup.TestField("NSSF Employee Account");
                PostingGroup.TestField("Pension Employer Acc");
                PostingGroup.TestField("Pension Employee Acc");
                LineNumber:=10000;

                //Create batch*****************************************************************************
                GenJnlBatch.Reset;
                GenJnlBatch.SetRange(GenJnlBatch."Journal Template Name",'GENERAL');
                GenJnlBatch.SetRange(GenJnlBatch.Name,'SALARIES');
                if GenJnlBatch.Find ('-')=false then
                begin
                 GenJnlBatch.Init;
                 GenJnlBatch."Journal Template Name":='GENERAL';
                 GenJnlBatch.Name:='SALARIES';
                 GenJnlBatch.Insert;
                end;
                // End Create Batch

                // Clear the journal Lines
                GeneraljnlLine.SetRange(GeneraljnlLine."Journal Batch Name",'SALARIES');
                if GeneraljnlLine.Find('-') then
                GeneraljnlLine.DeleteAll;

                "Slip/Receipt No":=UpperCase(objPeriod."Period Name");

                "PRL-Salary Card".SetRange("PRL-Salary Card"."Payroll Period",SelectedPeriod);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(PeriodFilter;PeriodFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Period Filter';
                    Lookup = true;
                    LookupPageID = "PRL-Payroll Periods";
                    TableRelation = "PRL-Payroll Periods";
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

    trigger OnPreReport()
    begin
        //PeriodFilter:="prSalary Card".GETFILTER("Period Filter");
        if PeriodFilter=0D then Error('You must specify the period filter');

        SelectedPeriod:=PeriodFilter;
        objPeriod.Reset;
        if objPeriod.Get(SelectedPeriod) then PeriodName:=objPeriod."Period Name";

        PostingDate:=CalcDate('1M-1D',SelectedPeriod);
    end;

    var
        PeriodTrans: Record UnknownRecord61092;
        objEmp: Record UnknownRecord61118;
        PeriodName: Text[30];
        PeriodFilter: Date;
        SelectedPeriod: Date;
        objPeriod: Record UnknownRecord61081;
        ControlInfo: Record UnknownRecord61119;
        strEmpName: Text[150];
        GeneraljnlLine: Record "Gen. Journal Line";
        GenJnlBatch: Record "Gen. Journal Batch";
        "Slip/Receipt No": Code[50];
        LineNumber: Integer;
        "Salary Card": Record UnknownRecord61105;
        TaxableAmount: Decimal;
        PostingGroup: Record UnknownRecord61114;
        GlobalDim1: Code[10];
        GlobalDim2: Code[10];
        TransCode: Record UnknownRecord61082;
        PostingDate: Date;
        AmountToDebit: Decimal;
        AmountToCredit: Decimal;
        IntegerPostAs: Integer;
        SaccoTransactionType: Option " ","Registration Fee",Loan,Repayment,Withdrawal,"Interest Due","Interest Paid","Welfare Contribution","Deposit Contribution","Loan Penalty","Application Fee","Appraisal Fee",Investment,"Unallocated Funds","Shares Capital","Loan Adjustment",Dividend,"Withholding Tax","Administration Fee","Welfare Contribution 2";
        EmployerDed: Record UnknownRecord61094;
        PeriodFilter2: Code[20];
        PayrollJournalDetails: Record UnknownRecord61837;
        PayrollJournalSummary: Record UnknownRecord61838;


    procedure CreateJnlEntry(AccountType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";AccountNo: Code[20];GlobalDime1: Code[20];GlobalDime2: Code[20];Description: Text[50];DebitAmount: Decimal;CreditAmount: Decimal;PostAs: Option " ",Debit,Credit;LoanNo: Code[20];TransType: Option " ","Registration Fee",Loan,Repayment,Withdrawal,"Interest Due","Interest Paid","Welfare Contribution","Deposit Contribution","Loan Penalty","Application Fee","Appraisal Fee",Investment,"Unallocated Funds","Shares Capital","Loan Adjustment",Dividend,"Withholding Tax","Administration Fee","Welfare Contribution 2";BalAccountNo: Code[20])
    begin

         LineNumber:=LineNumber+100;
         GeneraljnlLine.Init;
         GeneraljnlLine."Journal Template Name":='GENERAL';
         GeneraljnlLine."Journal Batch Name":='SALARIES';
         GeneraljnlLine."Line No.":=LineNumber;
         GeneraljnlLine."Document No.":="Slip/Receipt No";
         //GeneraljnlLine."Loan No":=LoanNo;
         //GeneraljnlLine."Transaction Type":=TransType;
         GeneraljnlLine."Posting Date":=PostingDate;
         GeneraljnlLine."Account Type":=AccountType;
         GeneraljnlLine."Account No.":=AccountNo;
         GeneraljnlLine.Validate(GeneraljnlLine."Account No.");
         GeneraljnlLine.Description:=Description;
         if PostAs = Postas::Debit then begin
         GeneraljnlLine."Debit Amount":=DebitAmount;
         GeneraljnlLine.Validate("Debit Amount");
         end else begin
         GeneraljnlLine."Credit Amount":=CreditAmount;
         GeneraljnlLine.Validate("Credit Amount");
         end;
         GeneraljnlLine."Bal. Account No.":=BalAccountNo;
         GeneraljnlLine."Gen. Bus. Posting Group":='';
         GeneraljnlLine."Gen. Prod. Posting Group":='';
         GeneraljnlLine."Shortcut Dimension 1 Code":='Main';
         GeneraljnlLine.Validate(GeneraljnlLine."Shortcut Dimension 1 Code");
        // GeneraljnlLine."Shortcut Dimension 2 Code":=GlobalDime2;
        // GeneraljnlLine.VALIDATE(GeneraljnlLine."Shortcut Dimension 2 Code");
         if GeneraljnlLine.Amount<>0 then
              GeneraljnlLine.Insert;
    end;
}

