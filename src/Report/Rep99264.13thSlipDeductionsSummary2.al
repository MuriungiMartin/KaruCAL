#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 99264 "13thSlip-Deductions Summary 2"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/13thSlip-Deductions Summary 2.rdlc';

    dataset
    {
        dataitem(UnknownTable99252;UnknownTable99252)
        {
            DataItemTableView = where("Employee Category"=filter("13THSLIP"|"13THSLIPS"));
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
            column(abreviation;'MUST')
            {
            }
            column(DetDate;DetDate)
            {
            }
            column(EmpNo;"PRL-13thSlip Period Trans."."Employee Code")
            {
            }
            column(empName;empName)
            {
            }
            column(EmpAmount;"PRL-13thSlip Period Trans.".Amount)
            {
            }
            column("code";"PRL-13thSlip Period Trans."."Transaction Code")
            {
            }
            column(name;"PRL-13thSlip Period Trans."."Transaction Name")
            {
            }
            column(Transaction;"PRL-13thSlip Period Trans."."Transaction Code"+': '+"PRL-13thSlip Period Trans."."Transaction Name")
            {
            }
            column(TotLabel;"PRL-13thSlip Period Trans."."Transaction Code"+': '+"PRL-13thSlip Period Trans."."Transaction Name")
            {
            }

            trigger OnAfterGetRecord()
            begin
                  //  IF NOT (((("prPeriod Transactions"."Group Order"=1) AND
                  //   ("prPeriod Transactions"."Sub Group Order"<>1)) OR
                  //  ("prPeriod Transactions"."Group Order"=3) OR
                  //   (("prPeriod Transactions"."Group Order"=4) AND
                  //    ("prPeriod Transactions"."Sub Group Order"<>0)))) THEN
                  "prPayroll Periods".Reset;
                  "prPayroll Periods".SetRange("prPayroll Periods"."Date Openned",SelectedPeriod);
                  "prPayroll Periods".SetRange("prPayroll Periods"."Current Instalment",NoOfInstalment);
                  if "prPayroll Periods".Find('-') then begin
                Clear(DetDate);
                DetDate:=Format("prPayroll Periods"."Period Name");
                  end;
                
                    Clear(empName);
                    if emps.Get("PRL-13thSlip Period Trans."."Employee Code") then
                    empName:=emps."First Name"+' '+emps."Middle Name"+' '+emps."Last Name";
                if not ( ((("PRL-13thSlip Period Trans."."Group Order"=7) and
                     (("PRL-13thSlip Period Trans."."Sub Group Order"<>6)
                    and ("PRL-13thSlip Period Trans."."Sub Group Order"<>5))) or
                    (("PRL-13thSlip Period Trans."."Group Order"=8) and
                     ("PRL-13thSlip Period Trans."."Sub Group Order"<>9)))) then begin
                      CurrReport.Skip;
                      end;
                
                  /*
                CLEAR(rows);
                CLEAR(rows2);
                "prPeriod Transactions".RESET;
                "prPeriod Transactions".SETRANGE("Payroll Period",SelectedPeriod);
                "prPeriod Transactions".SETFILTER("Group Order",'=1|3|4|7|8|9');
                //"prPeriod Transactions".SETFILTER("prPeriod Transactions"."Sub Group Order",'=2');
                "prPeriod Transactions".SETCURRENTKEY("Payroll Period","Group Order","Sub Group Order");
                IF "prPeriod Transactions".FIND('-') THEN BEGIN
                CLEAR(DetDate);
                DetDate:=FORMAT("prPayroll Periods"."Period Name");
                REPEAT
                BEGIN
                IF "prPeriod Transactions".Amount>0 THEN BEGIN
                IF (("prPeriod Transactions"."Group Order"=4) AND ("prPeriod Transactions"."Sub Group Order"=0)) THEN
                  GPY:=GPY+"prPeriod Transactions".Amount;
                
                IF (("prPeriod Transactions"."Group Order"=7) AND
                (("prPeriod Transactions"."Sub Group Order"=3) OR ("prPeriod Transactions"."Sub Group Order"=1) OR
                 ("prPeriod Transactions"."Sub Group Order"=2)))  THEN
                  STAT:=STAT+"prPeriod Transactions".Amount;
                
                IF (("prPeriod Transactions"."Group Order"=8) AND
                (("prPeriod Transactions"."Sub Group Order"=1) OR ("prPeriod Transactions"."Sub Group Order"=0))) THEN
                   DED:=DED+"prPeriod Transactions".Amount;
                
                IF (("prPeriod Transactions"."Group Order"=9) AND ("prPeriod Transactions"."Sub Group Order"=0)) THEN
                  NETS:=NETS+"prPeriod Transactions".Amount;
                
                
                
                
                
                //TotalsAllowances:=TotalsAllowances+"prPeriod Transactions".Amount;
                    IF ((("prPeriod Transactions"."Group Order"=1) AND
                     ("prPeriod Transactions"."Sub Group Order"<>1)) OR
                    ("prPeriod Transactions"."Group Order"=3) OR
                     (("prPeriod Transactions"."Group Order"=4) AND
                      ("prPeriod Transactions"."Sub Group Order"<>0))) THEN BEGIN // A Payment
                      CLEAR(countz);
                     // countz:=1;
                      CLEAR(found);
                      REPEAT
                     BEGIN
                       countz:=countz+1;
                       IF (PayTrans[countz])="prPeriod Transactions"."Transaction Name" THEN found:=TRUE;
                       END;
                      UNTIL ((countz=(ARRAYLEN(PayTransAmt))) OR ((PayTrans[countz])="prPeriod Transactions"."Transaction Name")
                      OR ((PayTrans[countz])=''));
                     rows:= countz;
                    PayTrans[rows]:="prPeriod Transactions"."Transaction Name";
                    PayTransAmt[rows]:=PayTransAmt[rows]+"prPeriod Transactions".Amount;
                    END ELSE IF ((("prPeriod Transactions"."Group Order"=7) AND
                     (("prPeriod Transactions"."Sub Group Order"<>6)
                    AND ("prPeriod Transactions"."Sub Group Order"<>5))) OR
                    (("prPeriod Transactions"."Group Order"=8) AND
                     ("prPeriod Transactions"."Sub Group Order"<>9))) THEN BEGIN
                      CLEAR(countz);
                     // countz:=1;
                      CLEAR(found);
                      REPEAT
                     BEGIN
                       countz:=countz+1;
                       IF (DedTrans[countz])="prPeriod Transactions"."Transaction Name" THEN found:=TRUE;
                       END;
                      UNTIL ((countz=(ARRAYLEN(DedTransAmt))) OR ((DedTrans[countz])="prPeriod Transactions"."Transaction Name")
                      OR ((DedTrans[countz])=''));
                     rows:= countz;
                    DedTrans[rows]:="prPeriod Transactions"."Transaction Name";
                    DedTransAmt[rows]:=DedTransAmt[rows]+"prPeriod Transactions".Amount;
                    END;
                    END; // If Amount >0;
                END;
                UNTIL "prPeriod Transactions".NEXT=0;
                END;// End prPeriod Transactions Repeat
                // MESSAGE('Heh'+FORMAT(rows)+', '+FORMAT(rows2));
                                      */

            end;

            trigger OnPreDataItem()
            begin

                //LastFieldNo := FIELDNO("Period Year");
                "PRL-13thSlip Period Trans.".SetFilter("PRL-13thSlip Period Trans."."Payroll Period",'=%1',SelectedPeriod);
                "PRL-13thSlip Period Trans.".SetFilter("PRL-13thSlip Period Trans."."Current Instalment",'=%1',NoOfInstalment);
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
                    TableRelation = "PRL-Payroll Periods"."Date Opened" where ("Payroll Code"=filter('13THSLIP'|'13THSLIPS'));
                }
                field(NoOfInstalment;NoOfInstalment)
                {
                    ApplicationArea = Basic;
                    Caption = 'Instalment';
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
        //objPeriod.SETFILTER("Payroll Code",'%1|%2','13thSlip','13thSlipS');
        if objPeriod.Find('-') then begin
        PeriodFilter:=objPeriod."Date Openned";
          NoOfInstalment:=objPeriod."Current Instalment";
          PeriodName:=objPeriod."Period Name";
          end;
    end;

    trigger OnPreReport()
    begin

        SelectedPeriod:=PeriodFilter;


        if CompanyInfo.Get() then
        CompanyInfo.CalcFields(CompanyInfo.Picture);
        Clear(rows);
        Clear(GPY);
        Clear(STAT);
        Clear(DED);
        Clear(NETS);
    end;

    var
        NoOfInstalment: Integer;
        empName: Text[250];
        DetDate: Text[100];
        found: Boolean;
        countz: Integer;
        PeriodFilter: Date;
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        PeriodTrans: Record UnknownRecord99252;
        objPeriod: Record UnknownRecord99250;
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
        PayTrans: array [70] of Text[250];
        PayTransAmt: array [70] of Decimal;
        DedTrans: array [70] of Text[250];
        DedTransAmt: array [70] of Decimal;
        rows: Integer;
        rows2: Integer;
        GPY: Decimal;
        NETS: Decimal;
        STAT: Decimal;
        DED: Decimal;
        TotalFor: label 'Total for ';
        GroupOrder: label '3';
        TransBal: array [2,60] of Text[250];
        Addr: array [2,10] of Text[250];
        RecordNo: Integer;
        NoOfColumns: Integer;
        ColumnNo: Integer;
        emps: Record UnknownRecord61118;
        "prPayroll Periods": Record UnknownRecord99250;
}

