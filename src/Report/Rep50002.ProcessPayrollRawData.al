#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 50002 "Process Payroll Raw Data"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("EFT Batch Header";"EFT Batch Header")
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                payPeriod.Reset;
                payPeriod.SetRange(payPeriod.Closed,false);
                if payPeriod.Find('-') then begin
                  end;

                if not Emps.Get("Raw Payroll"."Emp. No") then begin
                Emps.Init;
                Emps."No.":="Raw Payroll"."Emp. No";
                Emps."Search Name":="Raw Payroll"."Full Name";
                Emps."First Name":="Raw Payroll"."F. Name";
                Emps."Middle Name":="Raw Payroll"."M. Name";
                Emps."Last Name":="Raw Payroll"."L. Name";
                //Emps.FullName:="Raw Payroll"."Full Name";
                Emps."Department Code":="Raw Payroll".Dept;
                Emps.Insert;
                end;

                SalCard.Init;
                SalCard."Employee Code":="Raw Payroll"."Emp. No";
                SalCard."Payroll Period":=payPeriod."Date Opened";
                SalCard."Basic Pay":="Raw Payroll".Basic;
                SalCard."Payment Mode":=SalCard."payment mode"::Cheque;
                SalCard."Pays NSSF":=true;
                SalCard."Pays NHIF":=true;
                SalCard."Pays PAYE":=true;
                SalCard."Posting Group":='PAYROLL';
                SalCard."Period Month":=8;
                SalCard."Period Year":=2017;
                SalCard."Current Month":=8;
                SalCard."Current Year":=2017;
                SalCard.Insert;

                PeriodTrans.Reset;
                PeriodTrans."Employee Code":="Raw Payroll"."Emp. No";
                PeriodTrans."Transaction Code":='A001';
                PeriodTrans.Validate("Transaction Code");
                PeriodTrans."Payroll Code":='PAYROLL';
                PeriodTrans."Payroll Period":=payPeriod."Date Opened";
                PeriodTrans."Period Month":=8;
                PeriodTrans."Period Year":=2017;
                PeriodTrans.Amount:="Raw Payroll".A001;
                PeriodTrans."Recurance Index":=999;
                PeriodTrans.Insert;

                PeriodTrans.Reset;
                PeriodTrans."Employee Code":="Raw Payroll"."Emp. No";
                PeriodTrans."Transaction Code":='A002';
                PeriodTrans.Validate("Transaction Code");
                PeriodTrans."Payroll Code":='PAYROLL';
                PeriodTrans."Payroll Period":=payPeriod."Date Opened";
                PeriodTrans."Period Month":=8;
                PeriodTrans."Period Year":=2017;
                PeriodTrans.Amount:="Raw Payroll".A002;
                PeriodTrans."Recurance Index":=999;
                PeriodTrans.Insert;

                PeriodTrans.Reset;
                PeriodTrans."Employee Code":="Raw Payroll"."Emp. No";
                PeriodTrans."Transaction Code":='A003';
                PeriodTrans.Validate("Transaction Code");
                PeriodTrans."Payroll Code":='PAYROLL';
                PeriodTrans."Payroll Period":=payPeriod."Date Opened";
                PeriodTrans."Period Month":=8;
                PeriodTrans."Period Year":=2017;
                PeriodTrans.Amount:="Raw Payroll".A003;
                PeriodTrans."Recurance Index":=999;
                PeriodTrans.Insert;

                PeriodTrans.Reset;
                PeriodTrans."Employee Code":="Raw Payroll"."Emp. No";
                PeriodTrans."Transaction Code":='A004';
                PeriodTrans.Validate("Transaction Code");
                PeriodTrans."Payroll Code":='PAYROLL';
                PeriodTrans."Payroll Period":=payPeriod."Date Opened";
                PeriodTrans."Period Month":=8;
                PeriodTrans."Period Year":=2017;
                PeriodTrans.Amount:="Raw Payroll".A004;
                PeriodTrans."Recurance Index":=999;
                PeriodTrans.Insert;

                PeriodTrans.Reset;
                PeriodTrans."Employee Code":="Raw Payroll"."Emp. No";
                PeriodTrans."Transaction Code":='A005';
                PeriodTrans.Validate("Transaction Code");
                PeriodTrans."Payroll Code":='PAYROLL';
                PeriodTrans."Payroll Period":=payPeriod."Date Opened";
                PeriodTrans."Period Month":=8;
                PeriodTrans."Period Year":=2017;
                PeriodTrans.Amount:="Raw Payroll".A005;
                PeriodTrans."Recurance Index":=999;
                PeriodTrans.Insert;

                PeriodTrans.Reset;
                PeriodTrans."Employee Code":="Raw Payroll"."Emp. No";
                PeriodTrans."Transaction Code":='D001';
                PeriodTrans.Validate("Transaction Code");
                PeriodTrans."Payroll Code":='PAYROLL';
                PeriodTrans."Payroll Period":=payPeriod."Date Opened";
                PeriodTrans."Period Month":=8;
                PeriodTrans."Period Year":=2017;
                PeriodTrans.Amount:="Raw Payroll".D001;
                PeriodTrans."Recurance Index":=999;
                PeriodTrans.Insert;

                PeriodTrans.Reset;
                PeriodTrans."Employee Code":="Raw Payroll"."Emp. No";
                PeriodTrans."Transaction Code":='D002';
                PeriodTrans.Validate("Transaction Code");
                PeriodTrans."Payroll Code":='PAYROLL';
                PeriodTrans."Payroll Period":=payPeriod."Date Opened";
                PeriodTrans."Period Month":=8;
                PeriodTrans."Period Year":=2017;
                PeriodTrans.Amount:="Raw Payroll".D002;
                PeriodTrans."Recurance Index":=999;
                PeriodTrans.Insert;

                PeriodTrans.Reset;
                PeriodTrans."Employee Code":="Raw Payroll"."Emp. No";
                PeriodTrans."Transaction Code":='D003';
                PeriodTrans.Validate("Transaction Code");
                PeriodTrans."Payroll Code":='PAYROLL';
                PeriodTrans."Payroll Period":=payPeriod."Date Opened";
                PeriodTrans."Period Month":=8;
                PeriodTrans."Period Year":=2017;
                PeriodTrans.Amount:="Raw Payroll".D003;
                PeriodTrans."Recurance Index":=999;
                PeriodTrans.Insert;

                PeriodTrans.Reset;
                PeriodTrans."Employee Code":="Raw Payroll"."Emp. No";
                PeriodTrans."Transaction Code":='D004';
                PeriodTrans.Validate("Transaction Code");
                PeriodTrans."Payroll Code":='PAYROLL';
                PeriodTrans."Payroll Period":=payPeriod."Date Opened";
                PeriodTrans."Period Month":=8;
                PeriodTrans."Period Year":=2017;
                PeriodTrans.Amount:="Raw Payroll".D004;
                PeriodTrans."Recurance Index":=999;
                PeriodTrans.Insert;

                PeriodTrans.Reset;
                PeriodTrans."Employee Code":="Raw Payroll"."Emp. No";
                PeriodTrans."Transaction Code":='D005';
                PeriodTrans.Validate("Transaction Code");
                PeriodTrans."Payroll Code":='PAYROLL';
                PeriodTrans."Payroll Period":=payPeriod."Date Opened";
                PeriodTrans."Period Month":=8;
                PeriodTrans."Period Year":=2017;
                PeriodTrans.Amount:="Raw Payroll".D005;
                PeriodTrans."Recurance Index":=999;
                PeriodTrans.Insert;

                PeriodTrans.Reset;
                PeriodTrans."Employee Code":="Raw Payroll"."Emp. No";
                PeriodTrans."Transaction Code":='D006';
                PeriodTrans.Validate("Transaction Code");
                PeriodTrans."Payroll Code":='PAYROLL';
                PeriodTrans."Payroll Period":=payPeriod."Date Opened";
                PeriodTrans."Period Month":=8;
                PeriodTrans."Period Year":=2017;
                PeriodTrans.Amount:="Raw Payroll".D006;
                PeriodTrans."Recurance Index":=999;
                PeriodTrans.Insert;

                PeriodTrans.Reset;
                PeriodTrans."Employee Code":="Raw Payroll"."Emp. No";
                PeriodTrans."Transaction Code":='D007';
                PeriodTrans.Validate("Transaction Code");
                PeriodTrans."Payroll Code":='PAYROLL';
                PeriodTrans."Payroll Period":=payPeriod."Date Opened";
                PeriodTrans."Period Month":=8;
                PeriodTrans."Period Year":=2017;
                PeriodTrans.Amount:="Raw Payroll".D007;
                PeriodTrans."Recurance Index":=999;
                PeriodTrans.Insert;

                PeriodTrans.Reset;
                PeriodTrans."Employee Code":="Raw Payroll"."Emp. No";
                PeriodTrans."Transaction Code":='D008';
                PeriodTrans.Validate("Transaction Code");
                PeriodTrans."Payroll Code":='PAYROLL';
                PeriodTrans."Payroll Period":=payPeriod."Date Opened";
                PeriodTrans."Period Month":=8;
                PeriodTrans."Period Year":=2017;
                PeriodTrans.Amount:="Raw Payroll".D008;
                PeriodTrans."Recurance Index":=999;
                PeriodTrans.Insert;

                PeriodTrans.Reset;
                PeriodTrans."Employee Code":="Raw Payroll"."Emp. No";
                PeriodTrans."Transaction Code":='D009';
                PeriodTrans.Validate("Transaction Code");
                PeriodTrans."Payroll Code":='PAYROLL';
                PeriodTrans."Payroll Period":=payPeriod."Date Opened";
                PeriodTrans."Period Month":=8;
                PeriodTrans."Period Year":=2017;
                PeriodTrans.Amount:="Raw Payroll".D009;
                PeriodTrans."Recurance Index":=999;
                PeriodTrans.Insert;

                PeriodTrans.Reset;
                PeriodTrans."Employee Code":="Raw Payroll"."Emp. No";
                PeriodTrans."Transaction Code":='D010';
                PeriodTrans.Validate("Transaction Code");
                PeriodTrans."Payroll Code":='PAYROLL';
                PeriodTrans."Payroll Period":=payPeriod."Date Opened";
                PeriodTrans."Period Month":=8;
                PeriodTrans."Period Year":=2017;
                PeriodTrans.Amount:="Raw Payroll".D010;
                PeriodTrans."Recurance Index":=999;
                PeriodTrans.Insert;

                PeriodTrans.Reset;
                PeriodTrans."Employee Code":="Raw Payroll"."Emp. No";
                PeriodTrans."Transaction Code":='D011';
                PeriodTrans.Validate("Transaction Code");
                PeriodTrans."Payroll Code":='PAYROLL';
                PeriodTrans."Payroll Period":=payPeriod."Date Opened";
                PeriodTrans."Period Month":=8;
                PeriodTrans."Period Year":=2017;
                PeriodTrans.Amount:="Raw Payroll".D011;
                PeriodTrans."Recurance Index":=999;
                PeriodTrans.Insert;
                PeriodTrans.Reset;
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
        Emps: Record UnknownRecord61118;
        SalCard: Record UnknownRecord61105;
        PeriodTrans: Record UnknownRecord61091;
        payPeriod: Record UnknownRecord61081;
}

