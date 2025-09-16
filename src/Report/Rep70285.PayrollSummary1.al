#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 70285 "Payroll Summary 1"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Payroll Summary 1.rdlc';

    dataset
    {
        dataitem(prPeriod_Transactions;UnknownTable61092)
        {
            RequestFilterFields = "Period Year";
            column(ReportForNavId_1; 1)
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(COMPANYNAME_Control1102755015;COMPANYNAME)
            {
            }
            column(COMPANYNAME_Control1102756027;COMPANYNAME)
            {
            }
            column(COMPANYNAME_Control1102756028;COMPANYNAME)
            {
            }
            column(CompanyInfo_Picture;CompanyInfo.Picture)
            {
            }
            column(CompanyInfo_Picture_Control1102756014;CompanyInfo.Picture)
            {
            }
            column(PayrollSummary;'COMPANY PAYROLL SUMMARY')
            {
            }
            column(PeriodNamez;'PERIOD:  '+PeriodName)
            {
            }
            column(TransDesc;'TRANSACTION DESC.')
            {
            }
            column(payments;'PAYMENTS')
            {
            }
            column(deductions;'DEDUCTIONS')
            {
            }
            column(kirinyagatitle;COMPANYNAME)
            {
            }
            column(abreviation;'KARATINA UNIVERSITY')
            {
            }
            column(DetDate;DetDate)
            {
            }
            column(GPY;GPY)
            {
            }
            column(NETS;NETS)
            {
            }
            column(STAT;STAT)
            {
            }
            column(DED;DED)
            {
            }
            column(TransTypes;TransTypes)
            {
            }
            column(TransCode;prPeriod_Transactions."Transaction Code")
            {
            }
            column(TransName;prPeriod_Transactions."Transaction Name")
            {
            }
            column(TransAmount;prPeriod_Transactions.Amount)
            {
            }
            column(DeductionAmnt;DeductionAmnt)
            {
            }
            column(PaymentAmount;PaymentAmount)
            {
            }
            column(Go;prPeriod_Transactions."Group Order")
            {
            }
            column(SGO;prPeriod_Transactions."Sub Group Order")
            {
            }
            column(ProvidentEmployer;ProvidentEmployer*2)
            {
            }
            column(PensionEmployer;PensionEmployer*2)
            {
            }
            column(NSSFEmployer;NSSFEmployer)
            {
            }
            column(PeriodYear;PerTrans."Period Year")
            {
            }
            column(pcode;PerTrans."Payroll Code")
            {
            }

            trigger OnAfterGetRecord()
            begin
                Clear(DeductionAmnt);
                Clear(GPY);
                Clear(STAT);
                Clear(DED);
                Clear(NETS);
                
                //IF ((prPeriod_Transactions."Group Order"=4) AND (prPeriod_Transactions."Sub Group Order"=0)) THEN
                  //GPY:=prPeriod_Transactions.Amount;
                if (prPeriod_Transactions."Transaction Code"='GPAY' ) then
                   GPY:=prPeriod_Transactions.Amount;
                //IF  THEN
                 // STAT:=prPeriod_Transactions.Amount;
                
                //IF ((prPeriod_Transactions."Group Order"=8) AND
                //((prPeriod_Transactions."Sub Group Order"=1) OR (prPeriod_Transactions."Sub Group Order"=0))) THEN
                 /*IF (((prPeriod_Transactions."Group Order"=7) AND
                ((prPeriod_Transactions."Sub Group Order"=3) OR (prPeriod_Transactions."Sub Group Order"=1) OR
                 (prPeriod_Transactions."Sub Group Order"=2))) OR
                 (prPeriod_Transactions."Transaction Code"='TOT-DED' )) THEN */
                
                
                //IF ((prPeriod_Transactions."Group Order"=9) AND (prPeriod_Transactions."Sub Group Order"=0)) THEN
                if (prPeriod_Transactions."Transaction Code"='NPAY' ) then
                  NETS:=prPeriod_Transactions.Amount;
                
                
                Clear(TransTypes);
                if (prPeriod_Transactions."Group Text" in ['INCOME','ALLOWANCE','ALLOWANCES','BASIC SALARY']) then TransTypes:='PAYMENTS';
                if (prPeriod_Transactions."Group Text" in ['STATUTORIES','DEDUCTIONS']) then begin
                TransTypes:='DEDUCTIONS';
                DED:=prPeriod_Transactions.Amount;
                end;
                
                  if TransTypes='' then begin
                   // IF NOT ((prPeriod_Transactions."Transaction Code"='NPAY') OR (prPeriod_Transactions."Transaction Code"='TOT-DED')) THEN
                  //  CurrReport.SKIP;
                    end;
                
                if (prPeriod_Transactions."Group Text" in ['INCOME','ALLOWANCE','ALLOWANCES','BASIC SALARY']) then PaymentAmount:=prPeriod_Transactions.Amount;
                if (prPeriod_Transactions."Group Text" in ['STATUTORIES','DEDUCTIONS']) then DeductionAmnt:=prPeriod_Transactions.Amount;
                
                if ((prPeriod_Transactions."Transaction Code"='TOT-DED')) then
                    CurrReport.Skip;
                /*
                
                //TotalsAllowances:=TotalsAllowances+"prPeriod Transactions".Amount;
                    IF ((prPeriod_Transactions."Group Order"=1) OR
                    (prPeriod_Transactions."Group Order"=3) OR
                     ((prPeriod_Transactions."Group Order"=4) AND (prPeriod_Transactions."Sub Group Order"<>0))) THEN BEGIN // A Payment
                     { CLEAR(countz);
                     // countz:=1;
                      CLEAR(found);
                      REPEAT
                     BEGIN
                       countz:=countz+1;
                       IF (PayTrans[countz])=prPeriod_Transactions."Transaction Name" THEN found:=TRUE;
                       END;
                      UNTIL ((countz=(ARRAYLEN(PayTransAmt))) OR ((PayTrans[countz])=prPeriod_Transactions."Transaction Name")
                      OR ((PayTrans[countz])=''));
                     rows:= countz;
                    PayTrans[rows]:=prPeriod_Transactions."Transaction Name";
                    PayTransAmt[rows]:=PayTransAmt[rows]+prPeriod_Transactions.Amount;}
                    //TransTypes:='INCOME';
                    END ELSE IF (((prPeriod_Transactions."Group Order"=7) AND ((prPeriod_Transactions."Sub Group Order"<>6)
                    AND (prPeriod_Transactions."Sub Group Order"<>5))) OR
                    ((prPeriod_Transactions."Group Order"=8) AND (prPeriod_Transactions."Sub Group Order"<>9))) THEN BEGIN
                    {  CLEAR(countz);
                     // countz:=1;
                      CLEAR(found);
                     // prPeriod_Transactions.setcurrentkey("Transaction Name");
                      REPEAT
                     BEGIN
                       countz:=countz+1;
                       IF (DedTrans[countz])=prPeriod_Transactions."Transaction Name" THEN found:=TRUE;
                       END;
                      UNTIL ((countz=(ARRAYLEN(DedTransAmt))) OR ((DedTrans[countz])=prPeriod_Transactions."Transaction Name")
                      OR ((DedTrans[countz])=''));
                     rows:= countz;
                    DedTrans[rows]:=prPeriod_Transactions."Transaction Name";
                    DedTransAmt[rows]:=DedTransAmt[rows]+prPeriod_Transactions.Amount;}
                
                    END;
                    END; // If Amount >0;
                END;
                UNTIL prPeriod_Transactions.NEXT=0;
                END;// End prPeriod_Transactions Repeat
                // MESSAGE('Heh'+FORMAT(rows)+', '+FORMAT(rows2));
                */

            end;

            trigger OnPreDataItem()
            begin

                //LastFieldNo := FIELDNO("Period Year");
                //"PRL-Payroll Periods".SETFILTER("PRL-Payroll Periods"."Date Opened",'=%1',SelectedPeriod);
                //prPeriod_Transactions.SETFILTER("Period Year",'=%1',SelectedPeriod);
                // Get Benevolent, Pension;, and NSSF
                //NSSFEmployer
                PerTrans.Reset;
                PerTrans.CopyFilters(prPeriod_Transactions);
                PerTrans.SetRange("Payroll Code","Payroll Code");
                PerTrans.SetFilter("Group Text",'%1|%2','DEDUCTIONS','STATUTORIES');
                PerTrans.SetRange("Transaction Code",'NSSF');

                if PerTrans.Find('-') then begin
                  PerTrans.CalcSums(Amount);
                  NSSFEmployer:=PerTrans.Amount;
                  end;

                //Provident
                PerTrans.Reset;
                PerTrans.CopyFilters(prPeriod_Transactions);
                PerTrans.SetFilter("Group Text",'%1|%2','DEDUCTIONS','STATUTORIES');
                PerTrans.SetFilter("Transaction Code",'%1|%2|%3','592','817','806');
                if PerTrans.Find('-') then begin
                  PerTrans.CalcSums(Amount);
                  ProvidentEmployer:=PerTrans.Amount;
                  end;

                //Pension
                PerTrans.Reset;
                PerTrans.CopyFilters(prPeriod_Transactions);
                PerTrans.SetFilter("Group Text",'%1|%2','DEDUCTIONS','STATUTORIES');
                PerTrans.SetFilter("Transaction Code",'%1|%2|%3|%4|%5|%6|%7','16','690','692','694','737','807','808');
                if PerTrans.Find('-') then begin
                  PerTrans.CalcSums(Amount);
                  PensionEmployer:=PerTrans.Amount;
                  end;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        /*objPeriod.RESET;
        objPeriod.SETRANGE(objPeriod.Closed,FALSE);
        IF objPeriod.FIND('-') THEN;
        PeriodFilter:=objPeriod."Date Opened";*/

    end;

    trigger OnPreReport()
    begin
        
        /*SelectedPeriod:=PeriodFilter;
        objPeriod.RESET;
        //objPeriod.SETRANGE(objPeriod."Date Opened",SelectedPeriod);
        IF objPeriod.FIND('-') THEN
        BEGIN
            PeriodName:=objPeriod."Period Name";
        CLEAR(DetDate);
        DetDate:=FORMAT(objPeriod."Period Name");
        END;*/
        
        
        if CompanyInfo.Get() then
        //CompanyInfo.CALCFIELDS(CompanyInfo.Picture);
        Clear(rows);
        Clear(GPY);
        Clear(STAT);
        Clear(DED);
        Clear(NETS);

    end;

    var
        PerTrans: Record UnknownRecord61092;
        ProvidentEmployer: Decimal;
        PensionEmployer: Decimal;
        NSSFEmployer: Decimal;
        DetDate: Text[100];
        found: Boolean;
        countz: Integer;
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        objPeriod: Record UnknownRecord61081;
        PeriodName: Text[30];
        CompanyInfo: Record "Company Information";
        TotalsAllowances: Decimal;
        Dept: Boolean;
        PaymentDesc: Text[200];
        DeductionDesc: Text[200];
        GroupText1: Text[200];
        GroupText2: Text[200];
        PaymentAmount: Decimal;
        DeductAmount: Decimal;
        PayTrans: array [100] of Text[250];
        PayTransAmt: array [100] of Decimal;
        DedTrans: array [100] of Text[250];
        DedTransAmt: array [100] of Decimal;
        rows: Integer;
        rows2: Integer;
        GPY: Decimal;
        NETS: Decimal;
        STAT: Decimal;
        DED: Decimal;
        TotalFor: label 'Total for ';
        GroupOrder: label '3';
        TransBal: array [2,100] of Text[250];
        Addr: array [2,10] of Text[250];
        RecordNo: Integer;
        NoOfColumns: Integer;
        ColumnNo: Integer;
        TransTypes: Code[20];
        PayAmount: Decimal;
        DeductionAmnt: Decimal;
}

