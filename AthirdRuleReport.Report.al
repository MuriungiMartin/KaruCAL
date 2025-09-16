#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51146 "A third Rule Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/A third Rule Report.rdlc';

    dataset
    {
        dataitem(UnknownTable61092;UnknownTable61092)
        {
            DataItemTableView = where("Transaction Code"=filter(BPAY|GPAY|NPAY));
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(EmpNo;objEmp."No.")
            {
            }
            column(TCode;"PRL-Period Transactions"."Transaction Code")
            {
            }
            column(TName;"PRL-Period Transactions"."Transaction Name")
            {
            }
            column(BasicPay;BasicPay)
            {
            }
            column(Athird;Athird)
            {
            }
            column(NetPay;NetPay)
            {
            }
            column(Variance;Variance)
            {
            }
            column(PeriodName;PeriodName)
            {
            }
            column(companyinfo_Picture;companyinfo.Picture)
            {
            }
            column(EmployeeName;EmployeeName)
            {
            }
            column(Prep;Prepared_by_______________________________________Date_________________CaptionLbl)
            {
            }
            column(Checked;Checked_by________________________________________Date_________________CaptionLbl)
            {
            }
            column(Auth;Authorized_by____________________________________Date_________________CaptionLbl)
            {
            }
            column(approved;Approved_by______________________________________Date_________________CaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Clear(EmployeeName);
                Clear(NetPay);
                Clear(BasicPay);
                Clear(Variance);
                Clear(Athird);
                Clear(Desc);
                Clear(Indexes);

                objEmp.Reset;
                objEmp.SetRange(objEmp."No.","PRL-Period Transactions"."Employee Code");
                if objEmp.Find('-') then
                  EmployeeName:=objEmp."First Name"+' '+objEmp."Middle Name"+' '+objEmp."Last Name";
                 if "PRL-Period Transactions"."Transaction Code"='BPAY' then
                         begin
                            BasicPay:="PRL-Period Transactions".Amount;
                           Desc:='BASIC';
                           Indexes:=1;
                         end;

                         if "PRL-Period Transactions"."Transaction Code"='GPAY' then
                         begin
                            GrossPay:="PRL-Period Transactions".Amount; //Gross pay
                           Desc:='GROSS';
                           Indexes:=2;
                         end;

                         if "PRL-Period Transactions"."Transaction Code"='NPAY' then
                         begin
                            NetPay:="PRL-Period Transactions".Amount; //Net pay
                           Desc:='NET';
                           Indexes:=3;
                         end;
                if BasicPay>0 then
                Athird:=BasicPay*1/3;
                if NetPay>0 then
                Variance:=NetPay-Athird;

                if Athird>0 then begin
                           Desc:='THIRD';
                           Indexes:=4;
                  end;

                if Variance<>0 then  begin

                           Desc:='VARIANCE';
                           Indexes:=5;
                  end;
            end;

            trigger OnPreDataItem()
            begin
                "PRL-Period Transactions".SetFilter("PRL-Period Transactions"."Payroll Period",'=%1',SelectedPeriod);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Period Filter";SelectedPeriod)
                {
                    ApplicationArea = Basic;
                    Caption = 'Period Filter';
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
        objPeriod.SetRange(Closed,false);
        if objPeriod.Find('-') then begin
          SelectedPeriod:=objPeriod."Date Opened";
          end;


        if companyinfo.Get() then
        companyinfo.CalcFields(companyinfo.Picture);
    end;

    trigger OnPreReport()
    begin
        //PeriodFilter:="PRL-Salary Card".GETFILTER("Period Filter");
        if SelectedPeriod=0D then Error('You must specify the period filter');

        objPeriod.Reset;
        if objPeriod.Get(SelectedPeriod) then PeriodName:=objPeriod."Period Name";
    end;

    var
        PeriodTrans: Record UnknownRecord61092;
        BasicPay: Decimal;
        GrossPay: Decimal;
        NetPay: Decimal;
        TotBasicPay: Decimal;
        TotGrossPay: Decimal;
        TotNetPay: Decimal;
        EmployeeName: Text[250];
        objEmp: Record UnknownRecord61118;
        objPeriod: Record UnknownRecord61081;
        SelectedPeriod: Date;
        PeriodName: Text[250];
        companyinfo: Record "Company Information";
        Athird: Decimal;
        Variance: Decimal;
        TotVariance: Decimal;
        A_third_Rule_ReportCaptionLbl: label 'A third Rule Report';
        Basic_Pay_CaptionLbl: label 'Basic Pay:';
        A_THIRD_CaptionLbl: label 'A THIRD:';
        Net_Pay_CaptionLbl: label 'Net Pay:';
        User_Name_CaptionLbl: label 'User Name:';
        Print_Date_CaptionLbl: label 'Print Date:';
        Period_CaptionLbl: label 'Period:';
        Page_No_CaptionLbl: label 'Page No:';
        VarianceCaptionLbl: label 'Variance';
        Prepared_by_______________________________________Date_________________CaptionLbl: label 'Prepared by……………………………………………………..                 Date……………………………………………';
        Checked_by________________________________________Date_________________CaptionLbl: label 'Checked by…………………………………………………..                   Date……………………………………………';
        Authorized_by____________________________________Date_________________CaptionLbl: label 'Authorized by……………………………………………………..              Date……………………………………………';
        Approved_by______________________________________Date_________________CaptionLbl: label 'Approved by……………………………………………………..                Date……………………………………………';
        Totals_CaptionLbl: label 'Totals:';
        Indexes: Integer;
        Desc: Code[20];
}

