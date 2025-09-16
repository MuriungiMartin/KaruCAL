#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51038 "Payroll - Allowances Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Payroll - Allowances Report.rdlc';

    dataset
    {
        dataitem(UnknownTable61082;UnknownTable61082)
        {
            DataItemTableView = sorting("Transaction Code") order(ascending);
            column(ReportForNavId_6955; 6955)
            {
            }

            trigger OnAfterGetRecord()
            begin
                    prPeriodTransactions.Reset;
                    prPeriodTransactions.SetRange(prPeriodTransactions."Transaction Code","PRL-Transaction Codes"."Transaction Code");
                    prPeriodTransactions.SetRange(prPeriodTransactions."Payroll Period",periods);
                   // prPeriodTransactions.SETRANGE(prPeriodTransactions."Department Code",Department);
                    prPeriodTransactions.SetRange(prPeriodTransactions."Group Order",3);
                    prPeriodTransactions.SetRange(prPeriodTransactions."Sub Group Order",0);

                    if prPeriodTransactions.Find('-') then begin
                      counts:=counts+1;
                      TransName[1,counts]:="PRL-Transaction Codes"."Transaction Name";
                      Transcode[1,counts]:="PRL-Transaction Codes"."Transaction Code";
                    end;
            end;
        }
        dataitem(UnknownTable61118;UnknownTable61118)
        {
            DataItemTableView = sorting("No.") order(ascending) where("Exists in HR"=const(1));
            RequestFilterFields = "Period Filter";
            column(ReportForNavId_8631; 8631)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(USERID;UserId)
            {
            }
            column(TransName_1_5_;TransName[1,5])
            {
            }
            column(TransName_1_4_;TransName[1,4])
            {
            }
            column(TransName_1_3_;TransName[1,3])
            {
            }
            column(TransName_1_2_;TransName[1,2])
            {
            }
            column(TransName_1_1_;TransName[1,1])
            {
            }
            column(PAYROLL_SUMMARY_FOR_THE_PERIOD_STARTING____FORMAT_periods_______EARNINGS_;'PAYROLL SUMMARY FOR THE PERIOD STARTING '+(Format(periods))+' - EARNINGS')
            {
            }
            column(KENYA_WATER_INSITUTE_;'KENYA WATER INSITUTE')
            {
            }
            column(TransName_1_5__Control1102755028;TransName[1,5])
            {
            }
            column(TransName_1_4__Control1102755031;TransName[1,4])
            {
            }
            column(TransName_1_3__Control1102755032;TransName[1,3])
            {
            }
            column(TransName_1_2__Control1102755036;TransName[1,2])
            {
            }
            column(TransName_1_1__Control1102755037;TransName[1,1])
            {
            }
            column(CONTINUATION______________________;'.................CONTINUATION.....................')
            {
            }
            column(No_________First_Name_______Middle_Name_______Last_Name_;"No."+': '+"First Name"+' '+"Middle Name"+' '+"Last Name")
            {
            }
            column(TranscAmount_1_1_;TranscAmount[1,1])
            {
            }
            column(TranscAmount_1_2_;TranscAmount[1,2])
            {
            }
            column(TranscAmount_1_3_;TranscAmount[1,3])
            {
            }
            column(TranscAmount_1_4_;TranscAmount[1,4])
            {
            }
            column(TranscAmount_1_5_;TranscAmount[1,5])
            {
            }
            column(GPay;GPay)
            {
            }
            column(BPay;BPay)
            {
            }
            column(NetPay;NetPay)
            {
            }
            column(TranscAmountTotal_1_1_;TranscAmountTotal[1,1])
            {
            }
            column(TranscAmountTotal_1_2_;TranscAmountTotal[1,2])
            {
            }
            column(TranscAmountTotal_1_3_;TranscAmountTotal[1,3])
            {
            }
            column(TranscAmountTotal_1_4_;TranscAmountTotal[1,4])
            {
            }
            column(TranscAmountTotal_1_5_;TranscAmountTotal[1,5])
            {
            }
            column(GpayTotal;GpayTotal)
            {
            }
            column(NetPayTotal;NetPayTotal)
            {
            }
            column(BpayTotal;BpayTotal)
            {
            }
            column(PRINTED_BY_NAME_SIGNATURE_DESIGNATION_DATE;'PRINTED BY NAME:........................................................................................ SIGNATURE:................................... DESIGNATION:...................................... DATE:.......................................')
            {
            }
            column(CHECKED_BY_NAME_SIGNATURE_DESIGNATION_DATE;'CHECKED BY NAME:........................................................................................ SIGNATURE:................................... DESIGNATION:...................................... DATE:.......................................')
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(EMPLOYEE_NAMECaption;EMPLOYEE_NAMECaptionLbl)
            {
            }
            column(Gross_PayCaption;Gross_PayCaptionLbl)
            {
            }
            column(Basic_PayCaption;Basic_PayCaptionLbl)
            {
            }
            column(Net_PayCaption;Net_PayCaptionLbl)
            {
            }
            column(EMPLOYEE_NAMECaption_Control1102755046;EMPLOYEE_NAMECaption_Control1102755046Lbl)
            {
            }
            column(Gross_PayCaption_Control1102755047;Gross_PayCaption_Control1102755047Lbl)
            {
            }
            column(Basic_PayCaption_Control1102755048;Basic_PayCaption_Control1102755048Lbl)
            {
            }
            column(Net_PayCaption_Control1102755049;Net_PayCaption_Control1102755049Lbl)
            {
            }
            column(TOTALS_Caption;TOTALS_CaptionLbl)
            {
            }
            column(HR_Employee_No_;"No.")
            {
            }

            trigger OnAfterGetRecord()
            begin
                 TransCount:=0;
                 showdet:=true;
                 NetPay:=0;
                  payeamount:=0;
                  nssfam:=0;
                  nhifamt:=0;
                  GPay:=0;
                  BPay:=0;

                 Clear(TranscAmount);
                repeat
                begin
                TransCount:=TransCount+1;
                    prPeriodTransactions.Reset;
                   prPeriodTransactions.SetRange(prPeriodTransactions."Payroll Period",periods);
                   prPeriodTransactions.SetRange(prPeriodTransactions."Employee Code","HRM-Employee (D)"."No.");
                prPeriodTransactions.SetRange(prPeriodTransactions."Transaction Code",Transcode[1,TransCount]);
                if prPeriodTransactions.Find('-') then begin
                TranscAmount[1,TransCount]:=prPeriodTransactions.Amount;
                  end;
                repeat
                begin
                TranscAmountTotal[1,TransCount]:=((TranscAmountTotal[1,TransCount])+TranscAmount[1,TransCount]);
                end;
                until prPeriodTransactions.Next=0;

                end;
                until TransCount = CompressArray(TransName);



                    prPeriodTransactions.Reset;
                   prPeriodTransactions.SetRange(prPeriodTransactions."Payroll Period",periods);
                  // prPeriodTransactions.SETRANGE(prPeriodTransactions."Department Code",Department);
                   prPeriodTransactions.SetRange(prPeriodTransactions."Employee Code","HRM-Employee (D)"."No.");
                //prPeriodTransactions.SETRANGE(prPeriodTransactions."Transaction Name",'Net Pay');
                if prPeriodTransactions.Find('-') then begin
                repeat
                begin
                if prPeriodTransactions."Transaction Code"='NPAY' then begin
                  NetPay:=prPeriodTransactions.Amount;
                  NetPayTotal:=(NetPayTotal+(prPeriodTransactions.Amount));
                  end else if prPeriodTransactions."Transaction Code"='PAYE' then begin
                  payeamount:=prPeriodTransactions.Amount;;
                  payeamountTotal:=(payeamountTotal+(prPeriodTransactions.Amount));
                  end else if prPeriodTransactions."Transaction Code"='NSSF' then begin
                  nssfam:=prPeriodTransactions.Amount;;
                  nssfamTotal:=(nssfamTotal+(prPeriodTransactions.Amount));
                  end else if prPeriodTransactions."Transaction Code"='NHIF' then begin
                  nhifamt:=prPeriodTransactions.Amount;;
                  nhifamtTotal:=(nhifamtTotal+(prPeriodTransactions.Amount));
                  end  else if prPeriodTransactions."Transaction Code"='GPAY' then begin
                  GPay:=prPeriodTransactions.Amount;
                  GpayTotal:=(GpayTotal+(prPeriodTransactions.Amount));
                  end else if prPeriodTransactions."Transaction Code"='BPAY' then begin
                  BPay:=prPeriodTransactions.Amount;
                  BpayTotal:=(BpayTotal+(prPeriodTransactions.Amount));
                  end;
                  end;
                  until prPeriodTransactions.Next=0;

                end;

                if "HRM-Employee (D)"."No."='' then showdet:=false;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(Period_Filter;periods)
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

    trigger OnPreReport()
    begin
         if periods=0D then Error('Please Specify the Period first.');
         counts:=0;
         NetPayTotal:=0;
         payeamountTotal:=0;
          nssfamTotal:=0;
          nhifamtTotal:=0;
          GpayTotal:=0;
          BpayTotal:=0;

         Clear(TranscAmountTotal);
    end;

    var
        prPayrollPeriods: Record UnknownRecord61081;
        periods: Date;
        counts: Integer;
        prPeriodTransactions: Record UnknownRecord61092;
        TransName: array [1,100] of Text[100];
        Transcode: array [1,100] of Code[50];
        TransCount: Integer;
        TranscAmount: array [1,100] of Decimal;
        TranscAmountTotal: array [1,100] of Decimal;
        NetPay: Decimal;
        NetPayTotal: Decimal;
        showdet: Boolean;
        payeamount: Decimal;
        payeamountTotal: Decimal;
        nssfam: Decimal;
        nssfamTotal: Decimal;
        nhifamt: Decimal;
        nhifamtTotal: Decimal;
        GPay: Decimal;
        GpayTotal: Decimal;
        BPay: Decimal;
        BpayTotal: Decimal;
        Department: Code[10];
        CurrReport_PAGENOCaptionLbl: label 'Page';
        EMPLOYEE_NAMECaptionLbl: label 'EMPLOYEE NAME';
        Gross_PayCaptionLbl: label 'Gross Pay';
        Basic_PayCaptionLbl: label 'Basic Pay';
        Net_PayCaptionLbl: label 'Net Pay';
        EMPLOYEE_NAMECaption_Control1102755046Lbl: label 'EMPLOYEE NAME';
        Gross_PayCaption_Control1102755047Lbl: label 'Gross Pay';
        Basic_PayCaption_Control1102755048Lbl: label 'Basic Pay';
        Net_PayCaption_Control1102755049Lbl: label 'Net Pay';
        TOTALS_CaptionLbl: label 'TOTALS:';
}

