#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51120 "prGross Reconcilliation"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/prGross Reconcilliation.rdlc';

    dataset
    {
        dataitem(UnknownTable61105;UnknownTable61105)
        {
            RequestFilterFields = "Period Filter","Employee Code";
            column(ReportForNavId_6207; 6207)
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
            column(companyinfo_Picture;companyinfo.Picture)
            {
            }
            column(prSalary_Card__prSalary_Card___Employee_Code_;"PRL-Salary Card"."Employee Code")
            {
            }
            column(BasicPay;BasicPay)
            {
            }
            column(GrossPay;GrossPay)
            {
            }
            column(EmployeeName;EmployeeName)
            {
            }
            column(GrossPayPREV;GrossPayPREV)
            {
            }
            column(BasicPayPREV;BasicPayPREV)
            {
            }
            column(Payment_ReconcilliationCaption;Payment_ReconcilliationCaptionLbl)
            {
            }
            column(Basic_Pay_Caption;Basic_Pay_CaptionLbl)
            {
            }
            column(Gross_Pay_Caption;Gross_Pay_CaptionLbl)
            {
            }
            column(Prev_Gross_Pay_Caption;Prev_Gross_Pay_CaptionLbl)
            {
            }
            column(User_Name_Caption;User_Name_CaptionLbl)
            {
            }
            column(Print_Date_Caption;Print_Date_CaptionLbl)
            {
            }
            column(Period_Caption;Period_CaptionLbl)
            {
            }
            column(Page_No_Caption;Page_No_CaptionLbl)
            {
            }
            column(Prev_Basic_Pay_Caption;Prev_Basic_Pay_CaptionLbl)
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
            dataitem(UnknownTable61122;UnknownTable61122)
            {
                DataItemLink = Employee=field("Employee Code");
                DataItemTableView = sorting(Employee,TransCode) order(ascending);
                column(ReportForNavId_5750; 5750)
                {
                }
                column(Monthly_Reconcilliation_TransCode;TransCode)
                {
                }
                column(Monthly_Reconcilliation_Description;Description)
                {
                }
                column(Monthly_Reconcilliation_CurrAmount;CurrAmount)
                {
                }
                column(Monthly_Reconcilliation_PrevAmount;PrevAmount)
                {
                }
                column(No;No)
                {
                }
                column(Monthly_Reconcilliation_Employee;Employee)
                {
                }

                trigger OnAfterGetRecord()
                begin
                       No+=1;
                end;

                trigger OnPreDataItem()
                begin
                       No:=0;
                end;
            }

            trigger OnAfterGetRecord()
            begin

                objEmp.Reset;
                objEmp.SetRange(objEmp."No.","Employee Code");
                if objEmp.Find('-') then
                  EmployeeName:=objEmp."First Name"+' '+objEmp."Middle Name"+' '+objEmp."Last Name";

                BasicPay:=0;
                GrossPay:=0;
                BasicPayPREV:=0;
                GrossPayPREV:=0;

                NetPay:=0;

                PeriodTrans.Reset;
                PeriodTrans.SetRange(PeriodTrans."Employee Code","Employee Code");
                PeriodTrans.SetRange(PeriodTrans."Payroll Period",SelectedPeriod);
                PeriodTrans.SetFilter(PeriodTrans."Group Order",'=1|=4|=9');
                PeriodTrans.SetFilter(PeriodTrans."Sub Group Order",'<=1');
                PeriodTrans.SetCurrentkey(PeriodTrans."Employee Code",PeriodTrans."Period Month",PeriodTrans."Period Year",
                PeriodTrans."Group Order",PeriodTrans."Sub Group Order");
                if PeriodTrans.Find('-') then
                    repeat
                         if PeriodTrans."Group Order"=1 then
                         begin
                            BasicPay:=PeriodTrans.Amount;
                         end;

                         if PeriodTrans."Group Order"=4 then
                         begin
                            GrossPay:=PeriodTrans.Amount; //Gross pay
                         end;

                         if PeriodTrans."Group Order"=9 then
                         begin
                            NetPay:=PeriodTrans.Amount; //Net pay
                         end;
                    until PeriodTrans.Next=0;

                PeriodTransPREV.Reset;
                PeriodTransPREV.SetRange(PeriodTransPREV."Employee Code","Employee Code");
                PeriodTransPREV.SetRange(PeriodTransPREV."Payroll Period",CalcDate('-1M',SelectedPeriod));
                PeriodTransPREV.SetFilter(PeriodTransPREV."Group Order",'=1|=4|=9');
                PeriodTransPREV.SetFilter(PeriodTransPREV."Sub Group Order",'<=1');
                PeriodTransPREV.SetCurrentkey(PeriodTransPREV."Employee Code",PeriodTransPREV."Period Month",PeriodTransPREV."Period Year",
                PeriodTransPREV."Group Order",PeriodTransPREV."Sub Group Order");
                if PeriodTransPREV.Find('-') then
                    repeat
                         if PeriodTransPREV."Group Order"=1 then
                         begin
                            BasicPayPREV:=PeriodTransPREV.Amount;
                         end;

                         if PeriodTransPREV."Group Order"=4 then
                         begin
                            GrossPayPREV:=PeriodTransPREV.Amount; //Gross pay
                         end;

                         if PeriodTransPREV."Group Order"=9 then
                         begin
                            NetPay:=PeriodTransPREV.Amount; //Net pay
                         end;
                    until PeriodTransPREV.Next=0;

                //
                if GrossPayPREV=GrossPay then
                   CurrReport.Skip;


                ReconcilliationTable.DeleteAll;

                if BasicPayPREV<>BasicPay then begin
                   ReconcilliationTable.Init;
                   ReconcilliationTable.Employee:="Employee Code";
                   ReconcilliationTable.TransCode:='BASIC PAY';
                   ReconcilliationTable.CurrAmount:=BasicPay;
                   ReconcilliationTable.PrevAmount:=BasicPayPREV;
                   if BasicPay>BasicPayPREV then
                     ReconcilliationTable.Description:='Increase in Basic Pay'
                   else
                     ReconcilliationTable.Description:='Decrease in Basic Pay';
                   ReconcilliationTable.Insert;
                end;

                if GrossPayPREV<>GrossPay then begin
                   if GrossPayPREV>GrossPay then begin
                      PeriodTransPREV.Reset;
                      PeriodTransPREV.SetRange(PeriodTransPREV."Employee Code","Employee Code");
                      PeriodTransPREV.SetRange(PeriodTransPREV."Payroll Period",CalcDate('-1M',SelectedPeriod));
                      PeriodTransPREV.SetFilter(PeriodTransPREV."Group Order",'=3');
                      PeriodTransPREV.SetCurrentkey(PeriodTransPREV."Employee Code",PeriodTransPREV."Period Month",PeriodTransPREV."Period Year",
                      PeriodTransPREV."Group Order",PeriodTransPREV."Sub Group Order");
                      if PeriodTransPREV.Find('-') then begin
                        repeat
                            PeriodTrans.Reset;
                            PeriodTrans.SetRange(PeriodTrans."Employee Code",PeriodTransPREV."Employee Code");
                            PeriodTrans.SetRange(PeriodTrans."Payroll Period",SelectedPeriod);
                            PeriodTrans.SetRange(PeriodTrans."Transaction Code",PeriodTransPREV."Transaction Code");
                            if PeriodTrans.Find('-') then begin
                              if PeriodTransPREV.Amount<>PeriodTrans.Amount   then begin
                                 ReconcilliationTable.Init;
                                 ReconcilliationTable.Employee:="Employee Code";
                                 ReconcilliationTable.TransCode:=PeriodTrans."Transaction Code";
                                 ReconcilliationTable.CurrAmount:=PeriodTrans.Amount;
                                 ReconcilliationTable.PrevAmount:=PeriodTransPREV.Amount;
                                 ReconcilliationTable.Description:='Changes in '+ PeriodTrans."Transaction Name";
                                 ReconcilliationTable.Insert;
                              end;
                            end else begin
                                 ReconcilliationTable.Init;
                                 ReconcilliationTable.Employee:="Employee Code";
                                 ReconcilliationTable.TransCode:=PeriodTrans."Transaction Code";
                                 ReconcilliationTable.CurrAmount:=PeriodTrans.Amount;
                                 ReconcilliationTable.PrevAmount:=PeriodTransPREV.Amount;
                                 ReconcilliationTable.Description:='Changes in '+ PeriodTrans."Transaction Name";
                                 ReconcilliationTable.Insert;

                            end;

                        until PeriodTransPREV.Next=0;
                      end;

                  end else begin
                      PeriodTrans.Reset;
                      PeriodTrans.SetRange(PeriodTrans."Employee Code","Employee Code");
                      PeriodTrans.SetRange(PeriodTrans."Payroll Period",SelectedPeriod);
                      PeriodTrans.SetFilter(PeriodTrans."Group Order",'=3');
                      PeriodTrans.SetCurrentkey(PeriodTrans."Employee Code",PeriodTrans."Period Month",PeriodTrans."Period Year",
                      PeriodTrans."Group Order",PeriodTrans."Sub Group Order");
                      if PeriodTrans.Find('-') then begin
                        repeat
                            PeriodTransPREV.Reset;
                            PeriodTransPREV.SetRange(PeriodTransPREV."Employee Code",PeriodTrans."Employee Code");
                            PeriodTransPREV.SetRange(PeriodTransPREV."Payroll Period",CalcDate('-1M',SelectedPeriod));
                            PeriodTransPREV.SetRange(PeriodTransPREV."Transaction Code",PeriodTrans."Transaction Code");
                            if PeriodTransPREV.Find('-') then begin
                              if PeriodTransPREV.Amount<>PeriodTrans.Amount   then begin
                                 ReconcilliationTable.Init;
                                 ReconcilliationTable.Employee:="Employee Code";
                                 ReconcilliationTable.TransCode:=PeriodTrans."Transaction Code";
                                 ReconcilliationTable.CurrAmount:=PeriodTrans.Amount;
                                 ReconcilliationTable.PrevAmount:=PeriodTransPREV.Amount;
                                 ReconcilliationTable.Description:='Changes in '+ PeriodTrans."Transaction Name";
                                 ReconcilliationTable.Insert;
                              end;
                            end else begin
                                 ReconcilliationTable.Init;
                                 ReconcilliationTable.Employee:="Employee Code";
                                 ReconcilliationTable.TransCode:=PeriodTrans."Transaction Code";
                                 ReconcilliationTable.CurrAmount:=PeriodTrans.Amount;
                                 ReconcilliationTable.PrevAmount:=PeriodTransPREV.Amount;
                                 ReconcilliationTable.Description:='Changes in '+ PeriodTrans."Transaction Name";
                                 ReconcilliationTable.Insert;

                            end;

                        until PeriodTrans.Next=0;
                       end;

                  end;
                end;

                if NetPay<=0 then
                 CurrReport.Skip;
                 TotBasicPay:=TotBasicPay+BasicPay;
                 TotGrossPay:=TotGrossPay+GrossPay;
                 TotNetPay:=TotNetPay+NetPay;
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

    trigger OnPreReport()
    begin
        PeriodFilter:="PRL-Salary Card".GetFilter("Period Filter");
        if PeriodFilter='' then Error('You must specify the period filter');

        SelectedPeriod:="PRL-Salary Card".GetRangeMin("Period Filter");
        objPeriod.Reset;
        if objPeriod.Get(SelectedPeriod) then PeriodName:=objPeriod."Period Name";


        if companyinfo.Get() then
        companyinfo.CalcFields(companyinfo.Picture);
    end;

    var
        PeriodTrans: Record UnknownRecord61092;
        BasicPay: Decimal;
        GrossPay: Decimal;
        NetPay: Decimal;
        TotBasicPay: Decimal;
        TotGrossPay: Decimal;
        TotNetPay: Decimal;
        EmployeeName: Text[30];
        objEmp: Record UnknownRecord61118;
        objPeriod: Record UnknownRecord61081;
        SelectedPeriod: Date;
        PeriodName: Text[30];
        PeriodFilter: Text[30];
        companyinfo: Record "Company Information";
        PeriodTransPREV: Record UnknownRecord61092;
        BasicPayPREV: Decimal;
        GrossPayPREV: Decimal;
        ReconcilliationTable: Record UnknownRecord61122;
        No: Integer;
        Payment_ReconcilliationCaptionLbl: label 'Payment Reconcilliation';
        Basic_Pay_CaptionLbl: label 'Basic Pay:';
        Gross_Pay_CaptionLbl: label 'Gross Pay:';
        Prev_Gross_Pay_CaptionLbl: label 'Prev Gross Pay:';
        User_Name_CaptionLbl: label 'User Name:';
        Print_Date_CaptionLbl: label 'Print Date:';
        Period_CaptionLbl: label 'Period:';
        Page_No_CaptionLbl: label 'Page No:';
        Prev_Basic_Pay_CaptionLbl: label 'Prev Basic Pay:';
        Prepared_by_______________________________________Date_________________CaptionLbl: label 'Prepared by……………………………………………………..                 Date……………………………………………';
        Checked_by________________________________________Date_________________CaptionLbl: label 'Checked by…………………………………………………..                   Date……………………………………………';
        Authorized_by____________________________________Date_________________CaptionLbl: label 'Authorized by……………………………………………………..              Date……………………………………………';
        Approved_by______________________________________Date_________________CaptionLbl: label 'Approved by……………………………………………………..                Date……………………………………………';
}

