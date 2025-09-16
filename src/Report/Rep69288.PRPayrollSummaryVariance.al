#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 69288 "PR Payroll Summary - Variance"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/PR Payroll Summary - Variance.rdlc';

    dataset
    {
        dataitem(UnknownTable61082;UnknownTable61082)
        {
            column(ReportForNavId_1; 1)
            {
            }
            column(TransactionCode_PRTransactionCodes;"PRL-Transaction Codes"."Transaction Code")
            {
            }
            column(TransactionName_PRTransactionCodes;"PRL-Transaction Codes"."Transaction Name")
            {
            }
            column(TransactionType_PRTransactionCodes;"PRL-Transaction Codes"."Transaction Type")
            {
            }
            column(Amount;Amount)
            {
            }
            column(PeriodFilter;PeriodFilter)
            {
            }
            column(CompInfoName;CompInfo.Name)
            {
            }
            column(CompInfoAddress;CompInfo.Address)
            {
            }
            column(CompInfoCity;CompInfo.City)
            {
            }
            column(CompInfoPicture;CompInfo.Picture)
            {
            }
            column(CompInfoEMail;CompInfo."E-Mail")
            {
            }
            column(CompInfoHomePage;CompInfo."Home Page")
            {
            }
            column(PeriodName;PeriodName)
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(AppliedFilters;AppliedFilters)
            {
            }
            column(Variant_PeriodFilter;Variant_PeriodFilter)
            {
            }
            column(Variant_PeriodAmount;Variant_PeriodAmount)
            {
            }
            column(Variance_Amount;Variance_Amount)
            {
            }
            column(Cur_No_Assigned;Cur_No_Assigned)
            {
            }
            column(Var_No_Assigned;Var_No_Assigned)
            {
            }
            column(VarC_No_Assigned;VarC_No_Assigned)
            {
            }
            column(Cur_PNAME;Cur_PNAME)
            {
            }
            column(Var_PNAME;Var_PNAME)
            {
            }
            column(Num_I;Num_I)
            {
            }
            column(Num_D;Num_D)
            {
            }
            column(Variance_AmountPercentage;Variance_AmountPercentage)
            {
            }

            trigger OnAfterGetRecord()
            begin
                //Initialize {

                Amount:=0;
                Variant_PeriodAmount:=0;
                Variance_Amount:=0;
                Variance_AmountPercentage:=0;

                CurPeriod_Zero:=false;
                VarPeriod_Zero:=false;

                Cur_No_Assigned:=0;
                Var_No_Assigned:=0;
                VarC_No_Assigned:=0;

                //Selected Period
                fn_SR_PeriodTrans;
                if PRPeriodTrans.Find('-') then
                begin
                    Cur_No_Assigned:=PRPeriodTrans.Count;
                    PRPeriodTrans.CalcSums(PRPeriodTrans.Amount);
                    Amount:=PRPeriodTrans.Amount;
                end;

                //Variant Period
                fn_SR_Variant_PeriodTrans;
                if PRPeriodTrans.Find('-') then
                begin
                    Var_No_Assigned:=PRPeriodTrans.Count;
                    PRPeriodTrans.CalcSums(PRPeriodTrans.Amount);
                    Variant_PeriodAmount:=PRPeriodTrans.Amount;
                end;

                //Variance
                Variance_Amount:=Amount - Variant_PeriodAmount;
                VarC_No_Assigned:=Cur_No_Assigned - Var_No_Assigned;

                //Output Bool
                if Amount = 0 then CurPeriod_Zero := true;
                if Variant_PeriodAmount = 0 then VarPeriod_Zero := true;
                if VarPeriod_Zero and CurPeriod_Zero then CurrReport.Skip;


                //Variance Percentage
                if  Variant_PeriodAmount <> 0 then Variance_AmountPercentage:=(Variance_Amount / Variant_PeriodAmount) * 100;

                //Counter
                if "PRL-Transaction Codes"."Transaction Type" = "PRL-Transaction Codes"."transaction type"::Income then Num_I += 1;
                if "PRL-Transaction Codes"."Transaction Type" = "PRL-Transaction Codes"."transaction type"::Deduction then Num_D += 1;
            end;

            trigger OnPreDataItem()
            begin
                //Skip this trans code
                SetFilter("PRL-Transaction Codes"."Transaction Code",'<>%1','E31');
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(PeriodFilter;PeriodFilter)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Period Filter';
                        TableRelation = "PRL-Payroll Periods";
                    }
                    field(Variant_PeriodFilter;Variant_PeriodFilter)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Variant Period Filter';
                        TableRelation = "PRL-Payroll Periods";
                    }
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
             PRLPayrollPeriods.Reset;
        PRLPayrollPeriods.SetRange(Closed,false);
        if PRLPayrollPeriods.Find('-') then begin
          PeriodFilter:=PRLPayrollPeriods."Date Opened";
          end else Error('No Open period in the filters');

        PRLPayrollPeriodsCurr.Reset;
        PRLPayrollPeriodsCurr.SetRange("Date Opened",PeriodFilter);
        if PRLPayrollPeriodsCurr.Find('-') then begin
        CurrentMonth:=PRLPayrollPeriodsCurr."Period Month";
        CurrentYear:=PRLPayrollPeriodsCurr."Period Year";

        if CurrentMonth=1 then begin
          PrevMonth:=12;
          PrevYear:=CurrentYear-1;
          end else begin
            PrevMonth:=CurrentMonth-1;
            PrevYear:=CurrentYear;
            end;
          end;

        PRLPayrollPeriodsPrev.Reset;
        PRLPayrollPeriodsPrev.SetRange("Period Month",PrevMonth);
        PRLPayrollPeriodsPrev.SetRange("Period Year",PrevYear);
        if PRLPayrollPeriodsPrev.Find('-') then begin
          Variant_PeriodFilter:=PRLPayrollPeriodsPrev."Date Opened";
          end;
    end;

    trigger OnPreReport()
    begin
        //HRCodeunit.fn_HRPRAccessList(USERID);

        if ((Variant_PeriodFilter=0D) or (PeriodFilter=0D)) then Error('Specify Periods');
        //Dann

        //Init
        Cur_PNAME:='';
        Var_PNAME:='';

        Num_I:=0;
        Num_D:=0;

        //Default Payroll Period
        if PeriodFilter = 0D then
        begin
          PRPayrollPeriods.Reset;
          PRPayrollPeriods.SetRange(PRPayrollPeriods.Closed,false);
          if PRPayrollPeriods.Find('-') then PeriodFilter:=PRPayrollPeriods."Date Opened";
        end;

        //Variant Period Filter
        if Variant_PeriodFilter = 0D then
        begin
          Variant_PeriodFilter:=CalcDate('-1M',PeriodFilter); //Prev Period
        end;

        //Use Period Name - Curr P
        PRPayrollPeriods.Reset;
        PRPayrollPeriods.SetRange(PRPayrollPeriods."Date Opened",PeriodFilter);
        if PRPayrollPeriods.Find('-') then Cur_PNAME:=PRPayrollPeriods."Period Name";

        //Use Period Name - Var Period
        PRPayrollPeriods.Reset;
        PRPayrollPeriods.SetRange(PRPayrollPeriods."Date Opened",Variant_PeriodFilter);
        if PRPayrollPeriods.Find('-') then Var_PNAME:=PRPayrollPeriods."Period Name";

        //Save Filters
        if DepartmentCode <> '' then txt_DirectorateFilter :='Directorate Code: ' + DepartmentCode;

        AppliedFilters:='APPLIED FILTER(s) ='+ 'Payroll Period: ' + Format(Cur_PNAME)
                        + txt_DirectorateFilter
                        + "PRL-Transaction Codes".GetFilters;

        //Company Info
        fnCompanyInfo;
    end;

    var
        PRPeriodTrans: Record UnknownRecord61092;
        PeriodFilter: Date;
        Amount: Decimal;
        CompInfo: Record "Company Information";
        PeriodName: Text[30];
        DepartmentCode: Code[10];
        PRPayrollPeriods: Record UnknownRecord61081;
        AppliedFilters: Text;
        Variant_PeriodFilter: Date;
        Variant_PeriodAmount: Decimal;
        Variance_Amount: Decimal;
        Variance_AmountPercentage: Decimal;
        CurPeriod_Zero: Boolean;
        VarPeriod_Zero: Boolean;
        Cur_No_Assigned: Integer;
        Var_No_Assigned: Integer;
        VarC_No_Assigned: Integer;
        Num_I: Integer;
        Num_D: Integer;
        Cur_PNAME: Text;
        Var_PNAME: Text;
        txt_DirectorateFilter: Text;
        txt_VarPeriodFilter: Text;
        HRCodeunit: Codeunit "HR CheckList";
        PRLVarianceTransCodeBuff: Record UnknownRecord61840;
        PRLVarianceTransCodeBuff2: Record UnknownRecord61840;
        PeriFilter: Date;
        PRLPayrollPeriods: Record UnknownRecord61081;
        PRLPayrollPeriodsCurr: Record UnknownRecord61081;
        PRLPayrollPeriodsPrev: Record UnknownRecord61081;
        PRLPeriodTransactions: Record UnknownRecord61092;
        PRLPeriodTransactionsCurr: Record UnknownRecord61092;
        PRLPeriodTransactionsPrev: Record UnknownRecord61092;
        HRMEmployeeD: Record UnknownRecord61118;
        CurrentMonth: Integer;
        CurrentYear: Integer;
        PrevMonth: Integer;
        PrevYear: Integer;
        CurrentAmount: Integer;
        PrevAmounts: Integer;
        "Emp|No": Integer;
        EmpName: Integer;


    procedure fnCompanyInfo()
    begin
        CompInfo.Reset;
        if CompInfo.Get then
        CompInfo.CalcFields(CompInfo.Picture);
    end;

    local procedure fn_SR_PeriodTrans()
    begin
        PRPeriodTrans.Reset;
        PRPeriodTrans.SetCurrentkey("Employee Code","Transaction Code","Period Month"
                                    ,"Period Year",Membership,"Reference No");
        PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code","PRL-Transaction Codes"."Transaction Code");
        PRPeriodTrans.SetRange(PRPeriodTrans."Payroll Period",PeriodFilter);
        if DepartmentCode <> '' then
        begin
           // PRPeriodTrans.SETRANGE(PRPeriodTrans."Global Dimension 1 Code",DepartmentCode);
        end;
    end;

    local procedure fn_SR_Variant_PeriodTrans()
    begin
        PRPeriodTrans.Reset;
        PRPeriodTrans.SetCurrentkey("Employee Code","Transaction Code","Period Month"
                                    ,"Period Year",Membership,"Reference No");
        PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code","PRL-Transaction Codes"."Transaction Code");
        PRPeriodTrans.SetRange(PRPeriodTrans."Payroll Period",Variant_PeriodFilter);
        if DepartmentCode <> '' then
        begin
           // PRPeriodTrans.SETRANGE(PRPeriodTrans."Global Dimension 1 Code",DepartmentCode);
        end;
    end;
}

