#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51098 prGrossNetPay
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/prGrossNetPay.rdlc';

    dataset
    {
        dataitem(UnknownTable61092;UnknownTable61092)
        {
            DataItemTableView = sorting("Payroll Period","Group Order","Sub Group Order") order(ascending) where("Transaction Code"=filter(BPAY|GPAY|"TOT-DED"|NPAY));
            column(ReportForNavId_1; 1)
            {
            }
            column(USERID;UserId)
            {
            }
            column(TODAY;Today)
            {
            }
            column(PeriodName;PeriodName)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
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
                seq:=seq+1;
                objEmp.Reset;
                objEmp.SetRange(objEmp."No.","PRL-Period Transactions"."Employee Code");
                if objEmp.Find('-') then
                  EmployeeName:=objEmp."First Name"+' '+objEmp."Middle Name"+' '+objEmp."Last Name";
                Clear(statAmount);
                if "PRL-Period Transactions"."Transaction Code"='TOT-DED' then begin
                  PeriodTrans.Reset;
                  PeriodTrans.SetRange(PeriodTrans."Employee Code","PRL-Period Transactions"."Employee Code");
                  PeriodTrans.SetRange(PeriodTrans."Group Text",'STATUTORIES');
                  PeriodTrans.SetRange(PeriodTrans."Payroll Period",SelectedPeriod);
                  if PeriodTrans.Find('-') then begin
                    repeat
                      begin
                        statAmount:=statAmount+PeriodTrans.Amount;
                      end;
                      until PeriodTrans.Next=0;
                    end;
                "PRL-Period Transactions".Amount:=statAmount+"PRL-Period Transactions".Amount;
                  end;
                if "PRL-Period Transactions"."Transaction Code"  ='BPAY' then "PRL-Period Transactions"."Transaction Name":='BASIC';
                if "PRL-Period Transactions"."Transaction Code"  ='GPAY' then "PRL-Period Transactions"."Transaction Name":='GROSS';
                if "PRL-Period Transactions"."Transaction Code"  ='TOT-DED' then "PRL-Period Transactions"."Transaction Name":='DEDUCTIONS';
                if "PRL-Period Transactions"."Transaction Code"  ='NPAY' then "PRL-Period Transactions"."Transaction Name":='NET';
            end;

            trigger OnPreDataItem()
            begin
                "PRL-Period Transactions".SetFilter("PRL-Period Transactions"."Payroll Period",'=%1',SelectedPeriod);
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
                field(Periods;Periods)
                {
                    ApplicationArea = Basic;
                    Caption = 'Payroll Period';
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
          Periods:=objPeriod."Date Opened"
          end;
    end;

    trigger OnPreReport()
    begin

        SelectedPeriod:=Periods;
        objPeriod.Reset;
        if objPeriod.Get(SelectedPeriod) then PeriodName:=objPeriod."Period Name";

        if SelectedPeriod=0D then Error('Specify The Periods!');
    end;

    var
        PeriodTrans: Record UnknownRecord61092;
        EmployeeName: Text[100];
        objEmp: Record UnknownRecord61118;
        objPeriod: Record UnknownRecord61081;
        SelectedPeriod: Date;
        PeriodName: Text[30];
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
        Periods: Date;
        statAmount: Decimal;
        seq: Integer;
}

