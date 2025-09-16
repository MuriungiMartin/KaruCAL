#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51105 prEmployeeAdvupdates
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/prEmployeeAdvupdates.rdlc';

    dataset
    {
        dataitem(UnknownTable61105;UnknownTable61105)
        {
            RequestFilterFields = "Period Filter";
            column(ReportForNavId_6207; 6207)
            {
            }

            trigger OnAfterGetRecord()
            begin
                AdvAmount:=0;
                AdvBal:=0;
                AdvRef:='';

                employeeAdvance.Reset;
                employeeAdvance.SetRange(employeeAdvance."Employee Code","Employee Code");
                employeeAdvance.SetRange(employeeAdvance."Payroll Period",SelectedPeriod);
                employeeAdvance.SetRange(employeeAdvance.imported,false);
                employeeAdvance.SetFilter(employeeAdvance.Amount,'<>0');
                employeeAdvance.SetRange(employeeAdvance."Transaction Code",'DED001');

                if employeeAdvance.Find('-') then
                begin
                if employeeAdvance.Count>1 then
                 begin
                  repeat
                   AdvAmount:=AdvAmount+Abs(employeeAdvance.Amount);
                   AdvRef:=AdvRef+'/'+employeeAdvance."Reference No";
                   AdvBal:=AdvBal+employeeAdvance.Balance;
                   //Flag as imported
                   employeeAdvance.imported:=true;
                   employeeAdvance.Modify;
                  until employeeAdvance.Next =0;
                 end else
                 begin
                   AdvAmount:=Abs(employeeAdvance.Amount);
                   AdvRef:=employeeAdvance."Reference No";
                   AdvBal:=employeeAdvance.Balance;
                  //Flag as imported
                  employeeAdvance.imported:=true;
                  employeeAdvance.Modify;
                 end;

                  EmployeeTrans.Init;
                  EmployeeTrans."Employee Code":="Employee Code";
                  EmployeeTrans."Transaction Code":=employeeAdvance."Transaction Code";
                  EmployeeTrans."Period Month":=employeeAdvance."Period Month";
                  EmployeeTrans."Period Year":=employeeAdvance."Period Year";
                  EmployeeTrans."Payroll Period" :=employeeAdvance."Payroll Period" ;
                  EmployeeTrans."Reference No":=AdvRef ;
                  EmployeeTrans."Transaction Name":=employeeAdvance."Transaction Name";
                  EmployeeTrans.Amount:=AdvAmount;
                  EmployeeTrans.Balance:=AdvBal;
                  EmployeeTrans."Original Amount":=employeeAdvance."Original Amount";
                  EmployeeTrans."#of Repayments":=employeeAdvance."#of Repayments";
                  EmployeeTrans.Membership:=employeeAdvance.Membership;
                  EmployeeTrans.Insert;
                 end;

                //**************EARNING
                AdvAmount:=0;
                AdvBal:=0;
                AdvRef:='';


                employeeAdvance.Reset;
                employeeAdvance.SetRange(employeeAdvance."Employee Code","Employee Code");
                employeeAdvance.SetRange(employeeAdvance."Payroll Period",SelectedPeriod);
                employeeAdvance.SetRange(employeeAdvance.imported,false);
                employeeAdvance.SetFilter(employeeAdvance.Amount,'<>0');
                employeeAdvance.SetRange(employeeAdvance."Transaction Code",'EARN001');

                if employeeAdvance.Find('-') then
                begin
                if employeeAdvance.Count>1 then
                 begin
                  repeat
                   AdvAmount:=AdvAmount+Abs(employeeAdvance.Amount);
                   AdvRef:=AdvRef+'/'+employeeAdvance."Reference No";
                   AdvBal:=AdvBal+employeeAdvance.Balance;
                   //Flag as imported
                   employeeAdvance.imported:=true;
                   employeeAdvance.Modify;
                  until employeeAdvance.Next =0;
                 end else
                 begin
                   AdvAmount:=Abs(employeeAdvance.Amount);
                   AdvRef:=employeeAdvance."Reference No";
                   AdvBal:=employeeAdvance.Balance;
                  //Flag as imported
                  employeeAdvance.imported:=true;
                  employeeAdvance.Modify;
                 end;

                  EmployeeTrans.Init;
                  EmployeeTrans."Employee Code":="Employee Code";
                  EmployeeTrans."Transaction Code":=employeeAdvance."Transaction Code";
                  EmployeeTrans."Period Month":=employeeAdvance."Period Month";
                  EmployeeTrans."Period Year":=employeeAdvance."Period Year";
                  EmployeeTrans."Payroll Period" :=employeeAdvance."Payroll Period" ;
                  EmployeeTrans."Reference No":=AdvRef ;
                  EmployeeTrans."Transaction Name":=employeeAdvance."Transaction Name";
                  EmployeeTrans.Amount:=AdvAmount;
                  EmployeeTrans.Balance:=AdvBal;
                  EmployeeTrans."Original Amount":=employeeAdvance."Original Amount";
                  EmployeeTrans."#of Repayments":=employeeAdvance."#of Repayments";
                  EmployeeTrans.Membership:=employeeAdvance.Membership;
                  EmployeeTrans.Insert;
                 end;
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
    end;

    var
        EmployeeTrans: Record UnknownRecord61091;
        strPeriodName: Text[50];
        payperiod: Record UnknownRecord61081;
        PeriodFilter: Text[50];
        SelectedPeriod: Date;
        objPeriod: Record UnknownRecord61081;
        PeriodName: Text[50];
        employeeAdvance: Record UnknownRecord61115;
        EmployeeTrans2: Record UnknownRecord61091;
        AdvAmount: Decimal;
        AdvRef: Text[250];
        AdvBal: Decimal;
}

