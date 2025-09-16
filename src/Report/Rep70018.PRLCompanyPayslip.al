#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 70018 "PRL-Company Payslip"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/PRL-Company Payslip.rdlc';

    dataset
    {
        dataitem(prPeriod_Transactions;UnknownTable61092)
        {
            RequestFilterFields = "Payroll Period";
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
            column(compName;CompanyInfo.Name)
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
            column(abreviation;'')
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
            column(TransCode;prPeriod_Transactions."Transaction Code")
            {
            }
            column(TransName;prPeriod_Transactions."Transaction Name")
            {
            }
            column(TransAmount;prPeriod_Transactions.Amount)
            {
            }
            column(GText;prPeriod_Transactions."Group Text")
            {
            }
            column(GOrder;prPeriod_Transactions."Group Order")
            {
            }
            column(SubGrp;prPeriod_Transactions."Sub Group Order")
            {
            }

            trigger OnAfterGetRecord()
            begin
                
                Clear(rows);
                Clear(rows2);
                //prPeriod_Transactions.RESET;
                //prPeriod_Transactions.SETRANGE("Payroll Period",SelectedPeriod);
                //prPeriod_Transactions.SETFILTER("Group Order",'=1|3|4|7|8|9|0');
                //"prPeriod Transactions".SETFILTER("prPeriod Transactions"."Sub Group Order",'=2');
                
                //IF prPeriod_Transactions.FIND('-') THEN BEGIN
                
                //REPEAT
                //BEGIN
                if prPeriod_Transactions.Amount>0 then begin
                if ((prPeriod_Transactions."Group Order"=4) and (prPeriod_Transactions."Sub Group Order"=0)) then
                  GPY:=prPeriod_Transactions.Amount;
                
                //IF ((prPeriod_Transactions."Group Order"=7) AND
                //((prPeriod_Transactions."Sub Group Order"=3) OR (prPeriod_Transactions."Sub Group Order"=1) OR
                // (prPeriod_Transactions."Sub Group Order"=2)))  THEN
                if ((prPeriod_Transactions."Group Text"='STATUTORIES')) then
                  STAT:=prPeriod_Transactions.Amount;
                
                //IF ((prPeriod_Transactions."Group Order"=8) AND
                //((prPeriod_Transactions."Sub Group Order"=1) OR (prPeriod_Transactions."Sub Group Order"=0))) THEN
                if ((prPeriod_Transactions."Group Text"='DEDUCTIONS')) then
                   DED:=prPeriod_Transactions.Amount;
                
                //IF ((prPeriod_Transactions."Group Order"=9) AND (prPeriod_Transactions."Sub Group Order"=0)) THEN
                if ((prPeriod_Transactions."Transaction Code"='NPAY')) then
                  NETS:=prPeriod_Transactions.Amount;
                
                end;
                
                
                /*
                    IF ((prPeriod_Transactions."Group Order"=1) OR
                    (prPeriod_Transactions."Group Order"=3) OR
                     ((prPeriod_Transactions."Group Order"=4) AND (prPeriod_Transactions."Sub Group Order"<>0))) THEN BEGIN // A Payment
                      CLEAR(countz);
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
                    PayTransAmt[rows]:=PayTransAmt[rows]+prPeriod_Transactions.Amount;
                    END ELSE IF (((prPeriod_Transactions."Group Order"=7) AND ((prPeriod_Transactions."Sub Group Order"<>6)
                    AND (prPeriod_Transactions."Sub Group Order"<>5))) OR
                    ((prPeriod_Transactions."Group Order"=8) AND (prPeriod_Transactions."Sub Group Order"<>9))) THEN BEGIN
                      CLEAR(countz);
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
                    DedTransAmt[rows]:=DedTransAmt[rows]+prPeriod_Transactions.Amount;
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

                prPeriod_Transactions.SetFilter(prPeriod_Transactions."Payroll Period",'=%1',SelectedPeriod);
                prPeriod_Transactions.SetFilter("Group Order",'=1|3|4|7|8|9|0');
                prPeriod_Transactions.SetCurrentkey("Payroll Period","Group Order","Sub Group Order");
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(periodfilter;PeriodFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Period Filter';
                    TableRelation = "PRL-Payroll Periods"."Date Opened";
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

    trigger OnInitReport()
    begin
        objPeriod.Reset;
        objPeriod.SetRange(objPeriod.Closed,false);
        if objPeriod.Find('-') then;
        PeriodFilter:=objPeriod."Date Opened";
    end;

    trigger OnPreReport()
    begin

        SelectedPeriod:=PeriodFilter;
        objPeriod.Reset;
        objPeriod.SetRange(objPeriod."Date Opened",SelectedPeriod);
        if objPeriod.Find('-') then
        begin
            PeriodName:=objPeriod."Period Name";
          Clear(DetDate);
        DetDate:=Format(objPeriod."Period Name");
        end;


        if CompanyInfo.Get() then
        CompanyInfo.CalcFields(CompanyInfo.Picture);
        Clear(rows);
        Clear(GPY);
        Clear(STAT);
        Clear(DED);
        Clear(NETS);
    end;

    var
        DetDate: Text[100];
        found: Boolean;
        countz: Integer;
        PeriodFilter: Date;
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        PeriodTrans: Record UnknownRecord61092;
        objPeriod: Record UnknownRecord61081;
        SelectedPeriod: Date;
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
        PayTrans: Text[250];
        PayTransAmt: Decimal;
        DedTrans: Text[250];
        DedTransAmt: Decimal;
        rows: Integer;
        rows2: Integer;
        GPY: Decimal;
        NETS: Decimal;
        STAT: Decimal;
        DED: Decimal;
        TotalFor: label 'Total for ';
        GroupOrder: label '3';
        TransBal: Text[250];
        Addr: Text[250];
        RecordNo: Integer;
        NoOfColumns: Integer;
        ColumnNo: Integer;
}

