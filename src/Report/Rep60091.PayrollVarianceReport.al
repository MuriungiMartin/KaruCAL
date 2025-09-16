#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 60091 "Payroll Variance Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Payroll Variance Report.rdlc';

    dataset
    {
        dataitem(UnknownTable61092;UnknownTable61092)
        {
            DataItemTableView = sorting("Payroll Period","Group Order","Sub Group Order") order(ascending) where("Group Order"=filter(<>6));
            column(ReportForNavId_1; 1)
            {
            }
            column(USERID;UserId)
            {
            }
            column(TODAY;Today)
            {
            }
            column(CurrPerName;PeriodName1)
            {
            }
            column(PrevPerName;PeriodName2)
            {
            }
            column(PeriodFilters;"PRL-Period Transactions"."Payroll Period")
            {
            }
            column(PrevAmount;PeriodTrans1.Amount)
            {
            }
            column(pic;companyinfo.Picture)
            {
            }
            column(Gtext;"PRL-Period Transactions"."Group Text")
            {
            }
            column(EmpCode;"PRL-Period Transactions"."Employee Code")
            {
            }
            column(TransCode;"PRL-Period Transactions"."Transaction Code")
            {
            }
            column(TransName;UpperCase("PRL-Period Transactions"."Transaction Name"))
            {
            }
            column(TransAmount;"PRL-Period Transactions".Amount)
            {
            }
            column(VarianceAmount;"PRL-Period Transactions".Amount-PeriodTrans1.Amount)
            {
            }
            column(GO;"PRL-Period Transactions"."Group Order")
            {
            }
            column(SGO;"PRL-Period Transactions"."Sub Group Order")
            {
            }
            column(EmployeeName;EmployeeName)
            {
            }
            column(Prepared_by_______________________________________Date_________________Caption;Prepared_by_______________________________________Date_________________CaptionLbl)
            {
            }
            column(Checked_by________________________________________Date_________________Caption;Checked_by________________________________________Date_________________CaptionLbl)
            {
            }
            column(Authorized_by____________________________________Date_________________Caption;Authorized_by____________________________________Date_________________CaptionLbl)
            {
            }
            column(Approved_by______________________________________Date_________________Caption;Approved_by______________________________________Date_________________CaptionLbl)
            {
            }
            column(seq;seq)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Clear(Variance);
                seq:=seq+1;
                objEmp.Reset;
                objEmp.SetRange(objEmp."No.","PRL-Period Transactions"."Employee Code");
                if objEmp.Find('-') then
                  EmployeeName:=objEmp."First Name"+' '+objEmp."Middle Name"+' '+objEmp."Last Name";
                Clear(statAmount);
                /*
                IF "PRL-Period Transactions"."Transaction Code"='TOT-DED' THEN BEGIN
                  PeriodTrans.RESET;
                  PeriodTrans.SETRANGE(PeriodTrans."Employee Code","PRL-Period Transactions"."Employee Code");
                  PeriodTrans.SETRANGE(PeriodTrans."Group Text",'STATUTORIES');
                  PeriodTrans.SETRANGE(PeriodTrans."Payroll Period",StartPeriods);
                  IF PeriodTrans.FIND('-') THEN BEGIN
                    REPEAT
                      BEGIN
                        statAmount:=statAmount+PeriodTrans.Amount;
                      END;
                      UNTIL PeriodTrans.NEXT=0;
                    END;
                "PRL-Period Transactions".Amount:=statAmount+"PRL-Period Transactions".Amount;
                  END;*/
                
                  PeriodTrans1.Reset;
                  PeriodTrans1.SetRange(PeriodTrans1."Employee Code","PRL-Period Transactions"."Employee Code");
                  PeriodTrans1.SetRange(PeriodTrans1."Transaction Code","PRL-Period Transactions"."Transaction Code");
                  PeriodTrans1.SetRange(PeriodTrans1."Payroll Period",EndPeriods);
                  if PeriodTrans1.Find('-') then begin
                  /*
                    IF PeriodTrans1."Transaction Code"='TOT-DED' THEN BEGIN
                  PeriodTrans.RESET;
                  PeriodTrans.SETRANGE(PeriodTrans."Employee Code","PRL-Period Transactions"."Employee Code");
                  PeriodTrans.SETRANGE(PeriodTrans."Group Text",'STATUTORIES');
                  PeriodTrans.SETRANGE(PeriodTrans."Payroll Period",EndPeriods);
                  IF PeriodTrans.FIND('-') THEN BEGIN
                    REPEAT
                      BEGIN
                        statAmount:=statAmount+PeriodTrans.Amount;
                      END;
                      UNTIL PeriodTrans.NEXT=0;
                    END;
                PeriodTrans1.Amount:=statAmount+PeriodTrans1.Amount;
                  END;*/
                    end;
                
                if "PRL-Period Transactions"."Transaction Code"  ='BPAY' then "PRL-Period Transactions"."Transaction Name":='BASIC';
                if "PRL-Period Transactions"."Transaction Code"  ='GPAY' then "PRL-Period Transactions"."Transaction Name":='GROSS';
                if "PRL-Period Transactions"."Transaction Code"  ='TOT-DED' then "PRL-Period Transactions"."Transaction Name":='DEDUCTIONS';
                if "PRL-Period Transactions"."Transaction Code"  ='NPAY' then "PRL-Period Transactions"."Transaction Name":='NET';
                
                if (("PRL-Period Transactions".Amount-PeriodTrans1.Amount)=0) then CurrReport.Skip;

            end;

            trigger OnPreDataItem()
            begin
                "PRL-Period Transactions".SetFilter("PRL-Period Transactions"."Payroll Period",'%1',StartPeriods);
                Clear(seq);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(StartPeriods;StartPeriods)
                {
                    ApplicationArea = Basic;
                    Caption = 'Start Period';
                    TableRelation = "PRL-Payroll Periods"."Date Opened";

                    trigger OnValidate()
                    begin
                        if StartPeriods<>0D then begin
                           PayPeriods2.Reset;
                            PayPeriods2.SetRange("Period Month",Date2dmy((CalcDate ('<CM-2M+1D>', StartPeriods)),2));
                            PayPeriods2.SetRange("Period Year",Date2dmy((CalcDate ('<CM-2M+1D>', StartPeriods)),3));
                            if PayPeriods2.Find('-') then begin
                              EndPeriods:=PayPeriods2."Date Opened";
                              end else begin
                                EndPeriods:=0D;
                                end;
                          end else begin
                            PayPeriods2.Reset;
                            PayPeriods2.SetRange(Closed,false);
                            if PayPeriods2.Find('-') then begin
                              EndPeriods:=PayPeriods2."Date Opened";
                              end else begin
                                EndPeriods:=0D;
                                end;
                            end;

                        //currp
                    end;
                }
                field(EndPeriods;EndPeriods)
                {
                    ApplicationArea = Basic;
                    Caption = 'End Period';
                    Editable = false;
                    Enabled = false;
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

        if companyinfo.Get() then
        companyinfo.CalcFields(companyinfo.Picture);
        objPeriod.Reset;
        objPeriod.SetRange(Closed,false);
        if objPeriod.Find('-') then begin
          StartPeriods:=objPeriod."Date Opened";

         if StartPeriods<>0D then begin
           PayPeriods2.Reset;
            PayPeriods2.SetRange("Period Month",Date2dmy((CalcDate ('<CM-2M+1D>', StartPeriods)),2));
            PayPeriods2.SetRange("Period Year",Date2dmy((CalcDate ('<CM-2M+1D>', StartPeriods)),3));
            if PayPeriods2.Find('-') then begin
              EndPeriods:=PayPeriods2."Date Opened";
              end else begin
                EndPeriods:=0D;
                end;
          end else begin
            PayPeriods2.Reset;
            PayPeriods2.SetRange(Closed,false);
            if PayPeriods2.Find('-') then begin
              EndPeriods:=PayPeriods2."Date Opened";
              end else begin
                EndPeriods:=0D;
                end;
            end;
          end;
    end;

    trigger OnPreReport()
    begin
        if StartPeriods=0D then Error('Specify the start period!');
        objPeriod.Reset;
        if objPeriod.Get(StartPeriods) then PeriodName1:=objPeriod."Period Name";

        objPeriod.Reset;
        if objPeriod.Get(EndPeriods) then PeriodName2:=objPeriod."Period Name";
    end;

    var
        PeriodTrans: Record UnknownRecord61092;
        PeriodTrans1: Record UnknownRecord61092;
        EmployeeName: Text[100];
        objEmp: Record UnknownRecord61118;
        objPeriod: Record UnknownRecord61081;
        SelectedPeriod: Date;
        PeriodName1: Text[30];
        PeriodName2: Text[30];
        PeriodFilter: Text[30];
        companyinfo: Record "Company Information";
        Gross_and_Net_pay_scheduleCaptionLbl: label 'Gross and Net pay schedule';
        Basic_Pay_CaptionLbl: label 'Basic Pay:';
        Gross_Pay_CaptionLbl: label 'Gross Pay:';
        Net_Pay_CaptionLbl: label 'Net Pay:';
        User_Name_CaptionLbl: label 'User Name:';
        Print_Date_CaptionLbl: label 'Print Date:';
        Period_CaptionLbl: label 'Period:';
        Page_No_CaptionLbl: label 'Page No:';
        Prepared_by_______________________________________Date_________________CaptionLbl: label 'Prepared by……………………………………………………..                 Date……………………………………………';
        Checked_by________________________________________Date_________________CaptionLbl: label 'Checked by…………………………………………………..                   Date……………………………………………';
        Authorized_by____________________________________Date_________________CaptionLbl: label 'Authorized by……………………………………………………..              Date……………………………………………';
        Approved_by______________________________________Date_________________CaptionLbl: label 'Approved by……………………………………………………..                Date……………………………………………';
        Totals_CaptionLbl: label 'Totals:';
        StartPeriods: Date;
        EndPeriods: Date;
        statAmount: Decimal;
        seq: Integer;
        PayPeriods2: Record UnknownRecord61081;
        PayPeriods1: Record UnknownRecord61081;
        Variance: Decimal;
}

