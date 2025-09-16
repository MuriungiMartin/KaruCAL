#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 50119 prPayrollProcessing
{

    trigger OnRun()
    begin
    end;

    var
        Text020: label 'Because of circular references, the program cannot calculate a formula.';
        Text012: label 'You have entered an illegal value or a nonexistent row number.';
        Text013: label 'You have entered an illegal value or a nonexistent column number.';
        Text017: label 'The error occurred when the program tried to calculate:\';
        Text018: label 'Acc. Sched. Line: Row No. = %1, Line No. = %2, Totaling = %3\';
        Text019: label 'Acc. Sched. Column: Column No. = %4, Line No. = %5, Formula  = %6';
        Text023: label 'Formulas ending with a percent sign require %2 %1 on a line before it.';
        curgratuityAmnt: Decimal;
        curgManInsuranceReliefyAmnt: Decimal;
        empsalCard: Record UnknownRecord61105;
        selectedPp: Text;
        VitalSetup: Record UnknownRecord61104;
        curReliefPersonal: Decimal;
        curReliefInsurance: Decimal;
        curReliefMorgage: Decimal;
        curMaximumRelief: Decimal;
        curNssfEmployee: Decimal;
        curNssf_Employer_Factor: Decimal;
        intNHIF_BasedOn: Option Gross,Basic,"Taxable Pay";
        curMaxPensionContrib: Decimal;
        curRateTaxExPension: Decimal;
        curOOIMaxMonthlyContrb: Decimal;
        curOOIDecemberDedc: Decimal;
        curLoanMarketRate: Decimal;
        curLoanCorpRate: Decimal;
        PostingGroup: Record UnknownRecord61114;
        TaxAccount: Code[20];
        salariesAcc: Code[20];
        PayablesAcc: Code[20];
        NSSFEMPyer: Code[20];
        PensionEMPyer: Code[20];
        NSSFEMPyee: Code[20];
        NHIFEMPyer: Code[20];
        NHIFEMPyee: Code[20];
        HrEmployee: Record UnknownRecord61118;
        CoopParameters: Option "none",shares,loan,"loan Interest","Emergency loan","Emergency loan Interest","School Fees loan","School Fees loan Interest",Welfare,Pension,NSSF;
        PayrollType: Code[20];
        RoundUpDif: Decimal;
        RoundDownDiff: Decimal;
        SpecialTranAmount: Decimal;
        EmpSalary: Record UnknownRecord61105;
        txBenefitAmt: Decimal;
        intOldMonth: Integer;
        intOldYear: Integer;
        intMonth: Integer;
        intYear: Integer;
        prsalCard: Record UnknownRecord61105;
        PhDisabled: Boolean;
        curAllRecRel: Decimal;
        InsuranceReliefCeiling: Decimal;
        curDefinedContribh: Decimal;
        NhifInsuApplies: Boolean;
        NHIFInsuranceCap: Decimal;
        NHIFInsurancePercentage: Decimal;
        curNHIFInsuranceReliefAmount: Decimal;
        ReliefhifAmount: Decimal;
        CurHousingLEvy: Decimal;
        CurPensionRelief: Decimal;


    procedure fnInitialize()
    begin
        //Initialize Global Setup Items
        VitalSetup.FindFirst;
        with VitalSetup do begin
                curReliefPersonal := "Tax Relief";
                curReliefInsurance := "Insurance Relief";
                curReliefMorgage := "Mortgage Relief"; //Same as HOSP
                curMaximumRelief := "Max Relief";
                curNssfEmployee := "NSSF Employee";
                curNssf_Employer_Factor:= "NSSF Employer Factor";
                intNHIF_BasedOn := "NHIF Based on";
                curMaxPensionContrib := "Max Pension Contribution";
                curRateTaxExPension := "Tax On Excess Pension";
                curOOIMaxMonthlyContrb := "OOI Deduction";
                curOOIDecemberDedc := "OOI December";
                curLoanMarketRate := "Loan Market Rate";
                curLoanCorpRate := "Loan Corporate Rate";
                InsuranceReliefCeiling:="Insurance Relief Ceiling";
                "Nhif InsuApplies":=true;//NhifInsuApplies;
                "NHIF  InsuranceCap":=5000;//NHIFInsuranceCap;
                "NHI FInsurancePercentage":=15;//NHIFInsurancePercentage;

        end;
        Clear(PhDisabled);
        Clear(curAllRecRel);
        //CLEAR(ReliefhifAmount);
    end;


    procedure fnProcesspayroll(strEmpCode: Code[20];dtDOE: Date;curBasicPay: Decimal;blnPaysPaye: Boolean;blnPaysNssf: Boolean;blnPaysNhif: Boolean;SelectedPeriod: Date;dtOpenPeriod: Date;Membership: Text[30];ReferenceNo: Text[30];dtTermination: Date;blnGetsPAYERelief: Boolean;Dept: Code[20];PayshousingLevy: Boolean)
    var
        CurrLeadingGross: Decimal;
        TaxableExcessPension: Decimal;
        strTableName: Text[50];
        curTransAmount: Decimal;
        curTransBalance: Decimal;
        strTransDescription: Text[50];
        TGroup: Text[30];
        TGroupOrder: Integer;
        TSubGroupOrder: Integer;
        curSalaryArrears: Decimal;
        curPayeArrears: Decimal;
        curGrossPay: Decimal;
        curTotAllowances: Decimal;
        curExcessPension: Decimal;
        curNSSF: Decimal;
        curDefinedContrib: Decimal;
        curPensionStaff: Decimal;
        curNonTaxable: Decimal;
        curGrossTaxable: Decimal;
        curBenefits: Decimal;
        curValueOfQuarters: Decimal;
        curUnusedRelief: Decimal;
        curInsuranceReliefAmount: Decimal;
        curMorgageReliefAmount: Decimal;
        curTaxablePay: Decimal;
        curTaxCharged: Decimal;
        curPAYE: Decimal;
        prPeriodTransactions: Record UnknownRecord61092;
        intYear: Integer;
        intMonth: Integer;
        LeapYear: Boolean;
        CountDaysofMonth: Integer;
        DaysWorked: Integer;
        prSalaryArrears: Record UnknownRecord61088;
        prEmployeeTransactions: Record UnknownRecord61091;
        prTransactionCodes: Record UnknownRecord61082;
        strExtractedFrml: Text[250];
        SpecialTransType: Option Ignore,"Defined Contribution","Home Ownership Savings Plan","Life Insurance","Owner Occupier Interest","Prescribed Benefit","Salary Arrears","Staff Loan","Value of Quarters",Morgage,Gratuity,"Insurance Relief","Allowance Recovery",KUDHEIHA,"Housing Levy",SHIF;
        TransactionType: Option Ignore,"Defined Contribution","Home Ownership Savings Plan","Life Insurance","Owner Occupier Interest","Prescribed Benefit","Salary Arrears","Staff Loan","Value of Quarters",Morgage,Gratuity,"Insurance Relief";
        curPensionCompany: Decimal;
        curTaxOnExcessPension: Decimal;
        prUnusedRelief: Record UnknownRecord61090;
        curNhif_Base_Amount: Decimal;
        curNHIF: Decimal;
        curTotalDeductions: Decimal;
        curNetRnd_Effect: Decimal;
        curNetPay: Decimal;
        curTotCompanyDed: Decimal;
        curOOI: Decimal;
        curHOSP: Decimal;
        curLoanInt: Decimal;
        strTransCode: Text[250];
        fnCalcFringeBenefit: Decimal;
        prEmployerDeductions: Record UnknownRecord61094;
        JournalPostingType: Option " ","G/L Account",Customer,Vendor;
        JournalAcc: Code[20];
        Customer: Record Customer;
        JournalPostAs: Option " ",Debit,Credit;
        IsCashBenefit: Decimal;
        CurrHousingLevyRelief: Decimal;
    begin
        Clear(curDefinedContribh);
        HrEmployee.Reset;
        HrEmployee.SetRange(HrEmployee."No.",strEmpCode);
        if HrEmployee.Find('-') then begin
         PhDisabled:=HrEmployee."Physical Disability";
        end;
        
        CurPensionRelief:=0;
        curPensionStaff:=0;
        //Initialize
        fnInitialize;
        fnGetJournalDet(strEmpCode);
        selectedPp:=Format(SelectedPeriod);
        
        PostingGroup.Reset;
        PostingGroup.SetRange(PostingGroup.Code,'PAYROLL');
        if PostingGroup.Find('-') then
        begin
        
        //check if the period selected=current period. If not, do NOT run this function
        if SelectedPeriod <> dtOpenPeriod then exit;
        intMonth:=Date2dmy(SelectedPeriod,2);
        intYear:=Date2dmy(SelectedPeriod,3);
        //Delete all Records from the prPeriod Transactions for Reprocessing
        prPeriodTransactions.Reset;
        prPeriodTransactions.SetRange(prPeriodTransactions."Employee Code",strEmpCode);
        prPeriodTransactions.SetRange(prPeriodTransactions."Payroll Period",dtOpenPeriod);
        if prPeriodTransactions.Find('-') then
           prPeriodTransactions.DeleteAll;
        
        //Delete all Records from prEmployer Deductions
        prEmployerDeductions.Reset;
        prEmployerDeductions.SetRange(prEmployerDeductions."Employee Code",strEmpCode);
        prEmployerDeductions.SetRange(prEmployerDeductions."Payroll Period",dtOpenPeriod);
        if prEmployerDeductions.Find('-') then
           prEmployerDeductions.DeleteAll;
        
        if ((curBasicPay >0) or (curBasicPay =0)) then
        begin
           //Get the Basic Salary (prorate basc pay if needed) //Termination Remaining
           if (Date2dmy(dtDOE,2)=Date2dmy(dtOpenPeriod,2)) and (Date2dmy(dtDOE,3)=Date2dmy(dtOpenPeriod,3))then begin
              CountDaysofMonth:=fnDaysInMonth(dtDOE);
              DaysWorked:=fnDaysWorked(dtDOE,false);
              curBasicPay := fnBasicPayProrated(strEmpCode, intMonth, intYear, curBasicPay,DaysWorked,CountDaysofMonth)
           end;
        
          //Prorate Basic Pay on    {What if someone leaves within the same month they are employed}
          if dtTermination<>0D then begin
           if (Date2dmy(dtTermination,2)=Date2dmy(dtOpenPeriod,2)) and (Date2dmy(dtTermination,3)=Date2dmy(dtOpenPeriod,3))then begin
             CountDaysofMonth:=fnDaysInMonth(dtTermination);
             DaysWorked:=fnDaysWorked(dtTermination,true);
             curBasicPay := fnBasicPayProrated(strEmpCode, intMonth, intYear, curBasicPay,DaysWorked,CountDaysofMonth)
           end;
          end;
        
         curTransAmount := curBasicPay;
         strTransDescription := 'Basic Pay';
         TGroup := 'BASIC SALARY'; TGroupOrder := 1; TSubGroupOrder := 1;
         salariesAcc:=PostingGroup."Salary Account";
         fnUpdatePeriodTrans(strEmpCode, 'BPAY', TGroup, TGroupOrder,
         TSubGroupOrder, strTransDescription, curTransAmount, 0, intMonth, intYear,Membership,ReferenceNo,SelectedPeriod,Dept,
         salariesAcc,Journalpostas::Debit,Journalpostingtype::"G/L Account",'',Coopparameters::none);
        
         //Salary Arrears
         prSalaryArrears.Reset;
         prSalaryArrears.SetRange(prSalaryArrears."Employee Code",strEmpCode);
         prSalaryArrears.SetRange(prSalaryArrears."Period Month",intMonth);
         prSalaryArrears.SetRange(prSalaryArrears."Period Year",intYear);
         if prSalaryArrears.Find('-') then begin
         repeat
              curSalaryArrears := prSalaryArrears."Salary Arrears";
              curPayeArrears := prSalaryArrears."PAYE Arrears";
        
              //Insert [Salary Arrears] into period trans [ARREARS]
              curTransAmount := curSalaryArrears;
              strTransDescription := 'Salary Arrears';
              TGroup := 'ARREARS'; TGroupOrder := 1; TSubGroupOrder := 2;
              salariesAcc:=PostingGroup."Salary Account";
              fnUpdatePeriodTrans(strEmpCode, prSalaryArrears."Transaction Code", TGroup, TGroupOrder, TSubGroupOrder,
                strTransDescription, curTransAmount, 0, intMonth, intYear,Membership,ReferenceNo,SelectedPeriod,Dept,salariesAcc,
                Journalpostas::Debit,Journalpostingtype::"G/L Account",'',Coopparameters::none);
        
              //Insert [PAYE Arrears] into period trans [PYAR]
              curTransAmount:= curPayeArrears;
              strTransDescription := 'P.A.Y.E Arrears';
              TGroup := 'STATUTORIES'; TGroupOrder := 7; TSubGroupOrder := 4;
              TaxAccount:=PostingGroup."Income Tax Account";
              fnUpdatePeriodTrans(strEmpCode, 'PYAR', TGroup, TGroupOrder, TSubGroupOrder,
                 strTransDescription, curTransAmount, 0, intMonth, intYear,Membership,ReferenceNo,SelectedPeriod,Dept,
                 TaxAccount,Journalpostas::Debit,Journalpostingtype::"G/L Account",'',Coopparameters::none)
        
         until prSalaryArrears.Next=0;
         end;
        
         //Get Earnings
         prEmployeeTransactions.Reset;
         prEmployeeTransactions.SetRange(prEmployeeTransactions."Employee Code",strEmpCode);
         prEmployeeTransactions.SetRange(prEmployeeTransactions."Period Month",intMonth);
         prEmployeeTransactions.SetRange(prEmployeeTransactions."Period Year",intYear);
         prEmployeeTransactions.SetCurrentkey(prEmployeeTransactions."Recovery Priority");
         if prEmployeeTransactions.Find('-') then begin
           curTotAllowances:= 0;
           repeat
             prTransactionCodes.Reset;
             prTransactionCodes.SetRange(prTransactionCodes."Transaction Code",prEmployeeTransactions."Transaction Code");
             prTransactionCodes.SetRange(prTransactionCodes."Transaction Type",prTransactionCodes."transaction type"::Income);
             if prTransactionCodes.Find('-') then begin
               curTransAmount:=0; curTransBalance := 0; strTransDescription := ''; strExtractedFrml := '';
               if prTransactionCodes."Is Formula" then begin
                   strExtractedFrml := fnPureFormula(strEmpCode, intMonth, intYear, prTransactionCodes.Formula);
                   curTransAmount := fnFormulaResult(strExtractedFrml); //Get the calculated amount
        
               end else begin
                   curTransAmount := prEmployeeTransactions.Amount;
               end;
        
              if prTransactionCodes."Balance Type"=prTransactionCodes."balance type"::None then //[0=None, 1=Increasing, 2=Reducing]
                        curTransBalance := 0;
              if prTransactionCodes."Balance Type"=prTransactionCodes."balance type"::Increasing then
                        curTransBalance := prEmployeeTransactions.Balance+ curTransAmount;
              if prTransactionCodes."Balance Type"= prTransactionCodes."balance type"::Reducing then
                        curTransBalance := prEmployeeTransactions.Balance - curTransAmount;
        
        
                 //Prorate Allowances Here
                  //Get the Basic Salary (prorate basc pay if needed) //Termination Remaining
                  if (Date2dmy(dtDOE,2)=Date2dmy(dtOpenPeriod,2)) and (Date2dmy(dtDOE,3)=Date2dmy(dtOpenPeriod,3))then begin
                     CountDaysofMonth:=fnDaysInMonth(dtDOE);
                     DaysWorked:=fnDaysWorked(dtDOE,false);
                     curTransAmount := fnBasicPayProrated(strEmpCode, intMonth, intYear, curTransAmount,DaysWorked,CountDaysofMonth)
                  end;
        
                 //Prorate Basic Pay on    {What if someone leaves within the same month they are employed}
                 if dtTermination<>0D then begin
                  if (Date2dmy(dtTermination,2)=Date2dmy(dtOpenPeriod,2)) and (Date2dmy(dtTermination,3)=Date2dmy(dtOpenPeriod,3))then
        begin
                    CountDaysofMonth:=fnDaysInMonth(dtTermination);
                    DaysWorked:=fnDaysWorked(dtTermination,true);
                    curTransAmount := fnBasicPayProrated(strEmpCode, intMonth, intYear, curTransAmount,DaysWorked,CountDaysofMonth)
                  end;
                 end;
                // Prorate Allowances Here
        
                 //Add Non Taxable Here
                 if (not prTransactionCodes.Taxable) and ((
                 prTransactionCodes."Special Transactions" = prTransactionCodes."special transactions"::Gratuity) or
                 (prTransactionCodes."Special Transactions" =
                 prTransactionCodes."special transactions"::Ignore)) then
                     curNonTaxable:=curNonTaxable+curTransAmount;
        
                 //Added to ensure special transaction that are not taxable are not inlcuded in list of Allowances
                 if (not prTransactionCodes.Taxable) and (prTransactionCodes."Special Transactions" <>
                 prTransactionCodes."special transactions"::Ignore) and
                 (prTransactionCodes."Special Transactions"<>prTransactionCodes."special transactions"::Gratuity) then
                    curTransAmount:=0;
        
                 curTotAllowances := curTotAllowances + curTransAmount; //Sum-up all the allowances
                 curTransAmount := curTransAmount;
                 curTransBalance := curTransBalance;
                 strTransDescription := prTransactionCodes."Transaction Name";
                 TGroup := 'ALLOWANCE'; TGroupOrder := 3; TSubGroupOrder := 0;
        
                 //Get the posting Details
                 JournalPostingType:=Journalpostingtype::" ";JournalAcc:='';
                 if prTransactionCodes.Subledger<>prTransactionCodes.Subledger::" " then begin
                    if prTransactionCodes.Subledger=prTransactionCodes.Subledger::Customer then begin
                        HrEmployee.Get(strEmpCode);
                        Customer.Reset;
                        Customer.SetRange(Customer."No.",strEmpCode);
                        if Customer.Find('-') then begin
                           JournalAcc:=Customer."No.";
                           JournalPostingType:=Journalpostingtype::Customer;
                        end;
                    end;
                 end else begin
                    JournalAcc:=prTransactionCodes."GL Account";
                    JournalPostingType:=Journalpostingtype::"G/L Account";
                 end;
        
                 //End posting Details
        
                 fnUpdatePeriodTrans(strEmpCode,prTransactionCodes."Transaction Code", TGroup, TGroupOrder, TSubGroupOrder,
                 strTransDescription, curTransAmount, curTransBalance, intMonth, intYear,prEmployeeTransactions.Membership,
                 prEmployeeTransactions."Reference No",SelectedPeriod,Dept,JournalAcc,Journalpostas::Debit,JournalPostingType
                 ,'',Coopparameters::none);
        
             end;
           until prEmployeeTransactions.Next=0;
         end;
        
         //Calc GrossPay = (BasicSalary + Allowances + SalaryArrears) [Group Order = 4]
         curGrossPay := (curBasicPay + curTotAllowances + curSalaryArrears);
         curTransAmount := curGrossPay;
         strTransDescription := 'Gross Pay';
         TGroup := 'GROSS PAY'; TGroupOrder := 4; TSubGroupOrder := 0;
         fnUpdatePeriodTrans (strEmpCode, 'GPAY', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription, curTransAmount, 0, intMonth,
          intYear,'','',SelectedPeriod,Dept,'',Journalpostas::" ",Journalpostingtype::" ",'',Coopparameters::none);
        
         //Get the NSSF amount
         if blnPaysNssf then begin
        
           TGroup := 'STATUTORIES';
                        TGroupOrder := 7;
                        TSubGroupOrder := 1;
                        strTransDescription := 'N.S.S.F(I)';
                        curNSSF := fnGetEmployeeNSSFTierI(curGrossPay);
                        curTransAmount := curNSSF;
                        // if curTransAmount > 0 then Error('%1', curTransAmount);
                        fnUpdatePeriodTrans(strEmpCode, 'NSSF(I)', TGroup, TGroupOrder, TSubGroupOrder,
                        strTransDescription, curTransAmount, 0, intMonth, intYear, '', '', SelectedPeriod, Dept, NSSFEMPyee,
                        Journalpostas::Credit, Journalpostingtype::"G/L Account", '', Coopparameters::NSSF);
        
        
                        TGroup := 'STATUTORIES';
                        TGroupOrder := 7;
                        TSubGroupOrder := 1;
                        strTransDescription := 'N.S.S.F(II)';
                        curNSSF := fnGetEmployeeNSSFTierII(curGrossPay);
                        curTransAmount := curNSSF;
                        fnUpdatePeriodTrans(strEmpCode, 'NSSF(II)', TGroup, TGroupOrder, TSubGroupOrder,
                strTransDescription, curTransAmount, 0, intMonth, intYear, '', '', SelectedPeriod, Dept, NSSFEMPyee,
                Journalpostas::Credit, Journalpostingtype::"G/L Account", '', Coopparameters::NSSF);
        
                        //Get the Defined contribution to post based on the Max Def contrb allowed   ****************All Defined Contributions not included
                        //Tier (I) and (II) NSSF
                        //curDefinedContrib := fnGetEmployeeNSSFTierI(curGrossPay); //(curNSSF + curPensionStaff + curNonTaxable) - curMorgageReliefAmount
                        curTransAmount := fnGetEmployeeNSSFTierI(curGrossPay);
                        strTransDescription := 'NSSF(I)';
                        //change Defined contributions to NSSF-hosea
        
        
                        TGroup := 'TAX COMPUTATION';
                        TGroupOrder := 6;
                        TSubGroupOrder := 1;   //CHANGE tax calculations TO APYE INFORMATION-HOSEA // change TGroupOrder :=6 to 7
                        fnUpdatePeriodTrans(strEmpCode, 'DEFCON1', TGroup, TGroupOrder, TSubGroupOrder,
                         strTransDescription, curTransAmount, 0, intMonth, intYear, '', '', SelectedPeriod, Dept, '', Journalpostas::" ",
                         Journalpostingtype::" ", '', Coopparameters::none);
        
                        curTransAmount := fnGetEmployeeNSSFTierII(curGrossPay);
                        strTransDescription := 'NSSF(II)';  //change Defined contributions to NSSF-hosea
                        TGroup := 'TAX COMPUTATION';
                        TGroupOrder := 6;
                        TSubGroupOrder := 1;   //CHANGE tax calculations TO APYE INFORMATION-HOSEA // change TGroupOrder :=6 to 7
                        fnUpdatePeriodTrans(strEmpCode, 'DEFCON2', TGroup, TGroupOrder, TSubGroupOrder,
                         strTransDescription, curTransAmount, 0, intMonth, intYear, '', '', SelectedPeriod, Dept, '', Journalpostas::" ",
                         Journalpostingtype::" ", '', Coopparameters::none);
        
                        curDefinedContrib := fnGetEmployeeNSSFTierI(curGrossPay) + fnGetEmployeeNSSFTierII(curGrossPay); //(curNSSF + curPensionStaff + curNonTaxable) - curMorgageReliefAmount
        
        //                fnUpdatePeriodTrans(strEmpCode, 'NSSF EMPLOYER', 'NSSF EMPLOYER', 11, 0, 'NSSF EMPLOYER', curDefinedContrib, 0, intMonth,
        //                                intYear, '', '', SelectedPeriod, Dept, '', JournalPostAs::" ", JournalPostingType::" ", '', CoopParameters::none);
        
        end;
        
        curNSSF+=fnGetEmployeeNSSFTierI(curGrossPay);
           /*
           curNSSF := curNssfEmployee;
         curTransAmount := curNSSF;
         strTransDescription := 'N.S.S.F';
         TGroup := 'STATUTORIES'; TGroupOrder := 7; TSubGroupOrder := 1;
        NSSFEMPyee:=PostingGroup."NSSF Employee Account";
         fnUpdatePeriodTrans (strEmpCode, 'NSSF', TGroup, TGroupOrder, TSubGroupOrder,
         strTransDescription, curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,NSSFEMPyee,
         JournalPostAs::Credit,JournalPostingType::"G/L Account",'',CoopParameters::none);
        
        
        //Get the Defined contribution to post based on the Max Def contrb allowed   ****************All Defined Contributions not included
         curDefinedContrib := curNSSF; //(curNSSF + curPensionStaff + curNonTaxable) - curMorgageReliefAmount
         curTransAmount := curDefinedContrib;
         strTransDescription := 'Defined Contributions';
         TGroup := 'TAX CALCULATIONS'; TGroupOrder:= 6; TSubGroupOrder:= 1;
         fnUpdatePeriodTrans(strEmpCode, 'DEFCON', TGroup, TGroupOrder, TSubGroupOrder,
          strTransDescription, curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,'',JournalPostAs::" ",
          JournalPostingType::" ",'',CoopParameters::none);*/
        //nhif
        /*curNhif_Base_Amount :=0;
         IF intNHIF_BasedOn =intNHIF_BasedOn::Gross THEN //>NHIF calculation can be based on:
                 curNhif_Base_Amount := curGrossPay;
         IF intNHIF_BasedOn = intNHIF_BasedOn::Basic THEN
                curNhif_Base_Amount := curBasicPay;
         IF intNHIF_BasedOn =intNHIF_BasedOn::"Taxable Pay" THEN
                curNhif_Base_Amount := curTaxablePay;
        
         IF blnPaysNhif THEN BEGIN
          curNHIF:=fnGetEmployeeNHIF(curNhif_Base_Amount);
          curTransAmount := curNHIF;
          NHIFEMPyee:=PostingGroup."NHIF Employee Account";
          strTransDescription := 'N.H.I.F';
          TGroup := 'STATUTORIES'; TGroupOrder := 7; TSubGroupOrder := 2;
          fnUpdatePeriodTrans (strEmpCode, 'NHIF', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
           curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,
           NHIFEMPyee,JournalPostAs::Credit,JournalPostingType::"G/L Account",'',CoopParameters::none);
        
         //Get the Defined contribution to post based on the Max Def contrb allowed   ****************All Defined Contributions not included
        
           curDefinedContribh := (curNHIF*15/100); //(curNSSF + curPensionStaff + curNonTaxable) - curMorgageReliefAmount
         //IF curDefinedContribh>0 THEN BEGIN
         curTransAmount := curDefinedContribh;
         ReliefhifAmount:=curTransAmount;
         strTransDescription := 'NHIF Relief';
         TGroup := 'TAX CALCULATIONS'; TGroupOrder:= 6; TSubGroupOrder:= 8;
         fnUpdatePeriodTrans(strEmpCode, 'DEFCONS', TGroup, TGroupOrder, TSubGroupOrder,
         strTransDescription, curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,'',JournalPostAs::" ",
          JournalPostingType::" ",'',CoopParameters::none);
        
         //END;
         END;*/
         //curDefinedContribh:=0;
        
         //Get the Gross taxable amount
         //>GrossTaxable = Gross + Benefits + nValueofQuarters  ******Confirm CurValueofQuaters
         curGrossTaxable := curGrossPay + curBenefits + curValueOfQuarters;
        
         //>If GrossTaxable = 0 Then TheDefinedToPost = 0
         if curGrossTaxable = 0 then curDefinedContrib := 0;
        
         //Personal Relief
        // if get relief is ticked  - DENNO ADDED
        blnGetsPAYERelief:=blnPaysPaye;
        if blnGetsPAYERelief then
        begin
        
        if curTaxablePay >23999 then begin
         curReliefPersonal := curReliefPersonal + curUnusedRelief; //*****Get curUnusedRelief
         curTransAmount := curReliefPersonal;
         strTransDescription := 'Personal Relief';
         TGroup := 'TAX CALCULATIONS'; TGroupOrder := 6; TSubGroupOrder := 9;
         fnUpdatePeriodTrans (strEmpCode, 'PSNR', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
          curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,'',Journalpostas::" ",Journalpostingtype::" "
          ,'',Coopparameters::none);
        end
        
        end
        else
         curReliefPersonal := 0;
        
        //////////////////////////////////////////////////////////////////////////////////////////////////////
          // Disability tax Exemption
        
        //////////////////////////////////////////////////////////////////////////////////////////////////////
        
        //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
         //>Pension Contribution [self] relief
         curPensionStaff := fnGetSpecialTransAmount(strEmpCode, intMonth, intYear,
         Specialtranstype::"Defined Contribution",false) ;//Self contrib Pension is 1 on [Special Transaction]
         if curPensionStaff > 0 then begin
             if curPensionStaff > curMaxPensionContrib then begin
                 curTransAmount :=curMaxPensionContrib;
                 end
             else
                 curTransAmount :=curPensionStaff;
                 if (curTransAmount+curDefinedContrib) > curMaxPensionContrib then
                 curTransAmount:=curTransAmount-curDefinedContrib;
                 CurPensionRelief:=curTransAmount;
             strTransDescription := 'Pension Relief';
             TGroup := 'TAX CALCULATIONS'; TGroupOrder := 6; TSubGroupOrder := 2;
             fnUpdatePeriodTrans (strEmpCode, 'PNSR', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
             curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,'',Journalpostas::" ",Journalpostingtype::" "
             ,'',Coopparameters::none)
         end;
        
        // Has Gratuity
        Clear(curgratuityAmnt);
         curgratuityAmnt:=fnGetSpecialTransAmount(strEmpCode, intMonth, intYear,
         Specialtranstype::Gratuity,false);
          if curgratuityAmnt > 0 then begin
              curTransAmount := curgratuityAmnt;
              strTransDescription := 'Tax-Gratuity(30%)';
              TGroup := 'TAX CALCULATIONS'; TGroupOrder := 6; TSubGroupOrder := 11;
              fnUpdatePeriodTrans (strEmpCode, 'GRAD', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
              curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,'',Journalpostas::" ",Journalpostingtype::" "
              ,'',Coopparameters::none);
          end;
        
        /// Capture Manually Entered Insurance Relief
        Clear(curgManInsuranceReliefyAmnt);
         curgManInsuranceReliefyAmnt:=fnGetSpecialTransAmount(strEmpCode, intMonth, intYear,
         Specialtranstype::"Insurance Relief",false);
          if curgManInsuranceReliefyAmnt > 0 then begin
              curTransAmount := curgManInsuranceReliefyAmnt;
            if curTransAmount>InsuranceReliefCeiling then curTransAmount:=InsuranceReliefCeiling;
              strTransDescription := 'Insurance Relief';
              TGroup := 'TAX CALCULATIONS'; TGroupOrder := 6; TSubGroupOrder := 10;
              fnUpdatePeriodTrans (strEmpCode, 'INSR', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
              curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,'',Journalpostas::" ",Journalpostingtype::" "
              ,'',Coopparameters::none);
          end;
        
        /// Housing levy relief
        /*CLEAR(CurrHousingLevyRelief);
         CurrHousingLevyRelief:=fnGetSpecialTransAmount(strEmpCode, intMonth, intYear,
         SpecialTransType::"Housing Levy",FALSE);
          IF CurrHousingLevyRelief > 0 THEN BEGIN
              curTransAmount :=ROUND(CurrHousingLevyRelief,0.05,'=');
              strTransDescription := 'Housing Levy Relief';
              TGroup := 'TAX CALCULATIONS'; TGroupOrder := 6; TSubGroupOrder := 10;
              fnUpdatePeriodTrans (strEmpCode, '903', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
              curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,'',JournalPostAs::" ",JournalPostingType::" "
              ,'',CoopParameters::none);
          END;*/
        /// Ends Housing Levy Relief
        Clear(CurHousingLEvy);
        CurHousingLEvy:=fnGetSpecialTransAmount(strEmpCode, intMonth, intYear,
         Specialtranstype::"Housing Levy",false);
         CurHousingLEvy:=ROUND(CurHousingLEvy,0.05,'=');
        
        // Allowances Recovery
         curAllRecRel := fnGetSpecialTransAmount(strEmpCode, intMonth, intYear,
         Specialtranstype::"Allowance Recovery",false) ;
                 curTransAmount :=curAllRecRel;
             strTransDescription := 'All. Rec. Relief';
             TGroup := 'TAX CALCULATIONS'; TGroupOrder := 6; TSubGroupOrder := 4;
             fnUpdatePeriodTrans (strEmpCode, 'ARER', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
             curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,'',Journalpostas::" ",Journalpostingtype::" "
             ,'',Coopparameters::none);
        
        
        //if he PAYS paye only*******************
        if blnPaysPaye then
        begin
          //Get Insurance Relief
          curInsuranceReliefAmount := fnGetSpecialTransAmount(strEmpCode, intMonth, intYear,
          Specialtranstype::"Life Insurance",false); //Insurance is 3 on [Special Transaction]
          if curInsuranceReliefAmount > 0 then begin
              curTransAmount := curInsuranceReliefAmount;
            if curTransAmount>InsuranceReliefCeiling then curTransAmount:=InsuranceReliefCeiling;
              strTransDescription := 'Insurance Relief';
              TGroup := 'TAX CALCULATIONS'; TGroupOrder := 6; TSubGroupOrder := 8;
              fnUpdatePeriodTrans (strEmpCode, 'INSR', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
              curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,'',Journalpostas::" ",Journalpostingtype::" "
              ,'',Coopparameters::none);
          end;
        
        curNhif_Base_Amount :=0;
        
         //IF intNHIF_BasedOn =intNHIF_BasedOn::Gross THEN //>NHIF calculation can be based on:
                 curNhif_Base_Amount := curGrossPay;
        // IF intNHIF_BasedOn = intNHIF_BasedOn::Basic THEN
        //        curNhif_Base_Amount := curBasicPay;
        // IF intNHIF_BasedOn =intNHIF_BasedOn::"Taxable Pay" THEN
        //        curNhif_Base_Amount := curTaxablePay;
        ReliefhifAmount:=0;
         /*IF blnPaysNhif THEN BEGIN
                        curNHIF := fnGetEmployeeNHIF(curNhif_Base_Amount);
                        curTransAmount := curNHIF;
                        NHIFEMPyee := PostingGroup."NHIF Employee Account";
                        strTransDescription := 'N.H.I.F';
                        TGroup := 'STATUTORIES';
                        TGroupOrder := 7;
                        TSubGroupOrder := 2;
                        fnUpdatePeriodTrans(strEmpCode, 'NHIF', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
                         curTransAmount, 0, intMonth, intYear, '', '', SelectedPeriod, Dept,
                         NHIFEMPyee, JournalPostAs::Credit, JournalPostingType::"G/L Account", '', CoopParameters::none);
        
                        ReliefhifAmount:=0;
                        IF blnPaysPaye THEN BEGIN
        
                        //IF curTaxablePay > 23999 THEN BEGIN
                         //Get Insurance Relief
                           //IF ((NhifInsuApplies) AND (NHIFInsurancePercentage > 0)) THEN BEGIN
        
                                //curNHIFInsuranceReliefAmount := ((NHIFInsurancePercentage / 100) * curNHIF);
                                curNHIFInsuranceReliefAmount := ((15/ 100) * curNHIF);
                               // IF curNHIFInsuranceReliefAmount > NHIFInsuranceCap THEN
                                 //   curNHIFInsuranceReliefAmount := NHIFInsuranceCap;
        
                                //IF curNHIFInsuranceReliefAmount > 0 THEN BEGIN
                                    curTransAmount := curNHIFInsuranceReliefAmount;
                                    ReliefhifAmount := curTransAmount;
                                    //MESSAGE('%1',ReliefhifAmount);
                                    strTransDescription := 'NHIF Insurance Relief';
                                    TGroup := 'TAX CALCULATIONS';
                                    TGroupOrder := 6;
                                    TSubGroupOrder := 8;
                                    fnUpdatePeriodTrans(strEmpCode, 'NHIFINSR', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
                                    curTransAmount, 0, intMonth, intYear, '', '', SelectedPeriod, Dept, '', JournalPostAs::" ", JournalPostingType::" "
                                    , '', CoopParameters::none);
                                //END;
                            //END;
                         //END;
        
                       END;
                    END;*/
        
                        curNHIF := fnGetSpecialTransAmount(strEmpCode, intMonth, intYear,
          Specialtranstype::SHIF,false);
                        curTransAmount := ROUND(curNHIF,0.05,'=');
                        NHIFEMPyee := PostingGroup."NHIF Employee Account";
                        strTransDescription := 'SHIF';
                        TGroup := 'STATUTORIES';
                        TGroupOrder := 7;
                        TSubGroupOrder := 2;
                        fnUpdatePeriodTrans(strEmpCode, 'SHIF', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
                         curTransAmount, 0, intMonth, intYear, '', '', SelectedPeriod, Dept,
                         NHIFEMPyee, Journalpostas::Credit, Journalpostingtype::"G/L Account", '', Coopparameters::none);
        
                        ReliefhifAmount:=0;
        //                IF blnPaysPaye THEN BEGIN
        //
        //                //IF curTaxablePay > 23999 THEN BEGIN
        //                 //Get Insurance Relief
        //                   //IF ((NhifInsuApplies) AND (NHIFInsurancePercentage > 0)) THEN BEGIN
        //
        //                        //curNHIFInsuranceReliefAmount := ((NHIFInsurancePercentage / 100) * curNHIF);
        //                        curNHIFInsuranceReliefAmount := ((15/ 100) * curNHIF);
        //                       // IF curNHIFInsuranceReliefAmount > NHIFInsuranceCap THEN
        //                         //   curNHIFInsuranceReliefAmount := NHIFInsuranceCap;
        //
        //                        //IF curNHIFInsuranceReliefAmount > 0 THEN BEGIN
        //                            curTransAmount :=ROUND(curNHIFInsuranceReliefAmount,0.05,'=');
        //                            ReliefhifAmount := ROUND(curTransAmount,0.05,'=');;
        //                            //MESSAGE('%1',ReliefhifAmount);
        //                            strTransDescription := 'SHIF Insurance Relief';
        //                            TGroup := 'TAX CALCULATIONS';
        //                            TGroupOrder := 6;
        //                            TSubGroupOrder := 8;
        //                            fnUpdatePeriodTrans(strEmpCode, 'SHIFINSR', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
        //                            curTransAmount, 0, intMonth, intYear, '', '', SelectedPeriod, Dept, '', JournalPostAs::" ", JournalPostingType::" "
        //                            , '', CoopParameters::none);
        //                        //END;
        //                    //END;
        //                 //END;
        //            END;
        
        
        
         //>OOI
          curOOI := fnGetSpecialTransAmount(strEmpCode, intMonth, intYear,
          Specialtranstype::"Owner Occupier Interest",false); //Morgage is LAST on [Special Transaction]
          if curOOI > 0 then begin
            if curOOI<=curOOIMaxMonthlyContrb then
              curTransAmount := curOOI
            else
              curTransAmount:=curOOIMaxMonthlyContrb;
        
              strTransDescription := 'Owner Occupier Interest';
              TGroup := 'TAX CALCULATIONS'; TGroupOrder := 6; TSubGroupOrder := 3;
              fnUpdatePeriodTrans (strEmpCode, 'OOI', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
              curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,'',Journalpostas::" ",Journalpostingtype::" "
              ,'',Coopparameters::none);
          end;
        
        //HOSP
          curHOSP := fnGetSpecialTransAmount(strEmpCode, intMonth, intYear,
          Specialtranstype::"Home Ownership Savings Plan",false); //Home Ownership Savings Plan
          if curHOSP > 0 then begin
            if curHOSP<=curReliefMorgage then
              curTransAmount := curHOSP
            else
              curTransAmount:=curReliefMorgage;
        
              strTransDescription := 'Home Ownership Savings Plan';
              TGroup := 'TAX CALCULATIONS'; TGroupOrder := 6; TSubGroupOrder := 4;
           //   fnUpdatePeriodTrans (strEmpCode, 'HOSP', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
           //   curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,'',JournalPostAs::" ",JournalPostingType::" "
            //  ,'',CoopParameters::none);
          end;
        
        //Enter NonTaxable Amount
        // Commented By Wanjala
        /*IF curNonTaxable>0 THEN BEGIN
              strTransDescription := 'Other Non-Taxable Benefits';
              TGroup := 'TAX CALCULATIONS'; TGroupOrder := 6; TSubGroupOrder := 5;
              fnUpdatePeriodTrans (strEmpCode, 'NONTAX', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
              curNonTaxable, 0, intMonth, intYear,'','',SelectedPeriod,Dept,'',JournalPostAs::" ",JournalPostingType::" "
              ,'',CoopParameters::none);
        END; */
        
        end;
        
        //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
         //>Company pension, Excess pension, Tax on excess pension
         /*curPensionCompany := fnGetPensionAmount(strEmpCode, intMonth, intYear, SpecialTransType::"Defined Contribution",
         TRUE); //Self contrib Pension is 1 on [Special Transaction]
         IF curPensionCompany > 0 THEN BEGIN
             curTransAmount := curPensionCompany;
             strTransDescription := 'Pension (Company)';
             //Update the Employer deductions table
        
             curExcessPension:= ((curPensionCompany*3) - curMaxPensionContrib);
             IF curExcessPension > 0 THEN BEGIN
            { IF ((curPensionCompany - curMaxPensionContrib)>0) THEN BEGIN
                 curTransAmount := (curPensionCompany - curMaxPensionContrib);
                 strTransDescription := 'Tax Ex. Pension';
                 TGroup := 'STATUTORIES'; TGroupOrder := 7; TSubGroupOrder := 5;
                 fnUpdatePeriodTrans (strEmpCode, 'EXCP', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription, curTransAmount, 0,
                  intMonth,intYear,'','',SelectedPeriod,Dept,'',JournalPostAs::" ",JournalPostingType::" "
                  ,'',CoopParameters::none);
                END;  }
                IF (((curPensionCompany*3) - curMaxPensionContrib)>0) THEN BEGIN
                IF NOT ((curPensionCompany - curMaxPensionContrib)>0) THEN BEGIN
                 curTaxOnExcessPension := (curRateTaxExPension / 100) * ((curPensionCompany*3) - curMaxPensionContrib);
                 END
                ELSE BEGIN curTaxOnExcessPension := (curRateTaxExPension / 100) * ((curPensionCompany*2));
                END;
                 curTransAmount := curTaxOnExcessPension;
                 strTransDescription := 'Tax on Ex. Pension';
                 TGroup := 'STATUTORIES'; TGroupOrder := 7; TSubGroupOrder := 6;
                 fnUpdatePeriodTrans (strEmpCode, 'TXEP', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription, curTransAmount, 0,
                  intMonth,intYear,'','',SelectedPeriod,Dept,'',JournalPostAs::" ",JournalPostingType::" "
                  ,'',CoopParameters::none);
                  END;
             END;
           // clear()
         END;*/
         curPensionCompany := fnGetPensionAmount(strEmpCode, intMonth, intYear, Specialtranstype::"Defined Contribution",
         true); //Self contrib Pension is 1 on [Special Transaction]
         //MESSAGE(FORMAT(curPensionCompany));
         if curPensionCompany > 0 then begin
         if (((curPensionCompany+curNSSF) - curMaxPensionContrib)>0) then begin
                 curTransAmount := ((curPensionCompany+curNSSF) - curMaxPensionContrib);
             //curTransAmount := curPensionCompany;
             curExcessPension:=curTransAmount;
             strTransDescription := 'Pension (Company)';
             //curExcessPension:=curTransAmount;
             //Update the Employer deductions table
        
            // curExcessPension:= ((curPensionCompany) - curMaxPensionContrib);
           //MESSAGE('%1',curExcessPension);
           //  (((curPensionCompany*2+curPensionCompany+CurrVol-curMaxPensionContrib)));
             if curExcessPension > 0 then begin
            /* IF ((curPensionCompany - curMaxPensionContrib)>0) THEN BEGIN
                 curTransAmount := (curPensionCompany - curMaxPensionContrib);
                 strTransDescription := 'Tax Ex. Pension';
                 TGroup := 'STATUTORIES'; TGroupOrder := 7; TSubGroupOrder := 5;
                 fnUpdatePeriodTrans (strEmpCode, 'EXCP', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription, curTransAmount, 0,
                  intMonth,intYear,'','',SelectedPeriod,Dept,'',JournalPostAs::" ",JournalPostingType::" "
                  ,'',CoopParameters::none);
                END;  */
        //        IF (((curPensionCompany*3) - curMaxPensionContrib)>0) THEN BEGIN
        //        IF NOT ((curPensionCompany - curMaxPensionContrib)>0) THEN BEGIN
        //         curTaxOnExcessPension := (curRateTaxExPension / 100) * ((curPensionCompany*3) - curMaxPensionContrib);
        //         END
        //        ELSE BEGIN curTaxOnExcessPension := (curRateTaxExPension / 100) * ((curPensionCompany*2));
        //        END;
                 curTaxOnExcessPension := (curRateTaxExPension / 100) * curExcessPension;
                 curTransAmount := curTaxOnExcessPension;
                 strTransDescription := 'Tax on Ex. Pension';
                 TGroup := 'STATUTORIES'; TGroupOrder := 7; TSubGroupOrder := 6;
                 fnUpdatePeriodTrans (strEmpCode, 'TXEP', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription, curTransAmount, 0,
                  intMonth,intYear,'','',SelectedPeriod,Dept,'',Journalpostas::" ",Journalpostingtype::" "
                  ,'',Coopparameters::none);
                 // END;
                 end;
             end;
           // clear()
         end;
        
        
        //////////////////////////////////////////////////////////////////////////////////////////////////////
          // Disability tax Exemption
        
        //////////////////////////////////////////////////////////////////////////////////////////////////////
        
        
        
         //Get the Taxable amount for calculation of PAYE
         //>prTaxablePay = (GrossTaxable - SalaryArrears) - (TheDefinedToPost + curSelfPensionContrb + MorgageRelief)
        
        
          //Add HOSP and MORTGAGE KIM{}
         if curPensionStaff > curMaxPensionContrib then  begin
          if (disabled_emp(strEmpCode,curGrossTaxable)=true) then
           curTaxablePay:= curGrossTaxable - (curSalaryArrears + curDefinedContrib +CurPensionRelief+curOOI+curHOSP+curNonTaxable+150000+curNHIF+CurHousingLEvy)
          else
          curTaxablePay:= curGrossTaxable - (curSalaryArrears + curDefinedContrib +CurPensionRelief+curOOI+curHOSP+curNonTaxable+curNHIF+CurHousingLEvy);
          end else begin
          if (disabled_emp(strEmpCode,curGrossTaxable)=true) then
           curTaxablePay:= curGrossTaxable - (curSalaryArrears + curDefinedContrib +CurPensionRelief+curOOI+curHOSP+curNonTaxable+150000+curNHIF+CurHousingLEvy)
          else
          curTaxablePay:= curGrossTaxable - (curSalaryArrears + curDefinedContrib +CurPensionRelief+curOOI+curHOSP+curNonTaxable+curNHIF+CurHousingLEvy);
             end;
         curTransAmount := ROUND(curTaxablePay,0.05,'=');
         strTransDescription := 'Taxable Pay';
         TGroup := 'TAX CALCULATIONS'; TGroupOrder := 6; TSubGroupOrder := 6;
         fnUpdatePeriodTrans (strEmpCode, 'TXBP', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
          curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,'',Journalpostas::" ",Journalpostingtype::" "
          ,'',Coopparameters::none);
        
         //Get the Tax charged for the month
         curTaxCharged := fnGetEmployeePaye(curTaxablePay);
         curTransAmount := curTaxCharged;
         strTransDescription := 'Tax Charged';
         TGroup := 'TAX CALCULATIONS'; TGroupOrder := 6; TSubGroupOrder := 7;
         fnUpdatePeriodTrans (strEmpCode, 'TXCHRG', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
         curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,'',Journalpostas::" ",Journalpostingtype::" "
         ,'',Coopparameters::none);
        
        
         //Get the Net PAYE amount to post for the month
         if curTaxablePay >23999 then begin
         if (curReliefPersonal + curInsuranceReliefAmount)>curMaximumRelief then
          curPAYE := curTaxCharged - curMaximumRelief
        else
         curPAYE := curTaxCharged- (curReliefPersonal + curInsuranceReliefAmount + curgManInsuranceReliefyAmnt);
        // IF NOT ((curPensionCompany - curMaxPensionContrib)>0) THEN
         //curPAYE :=curPAYE+curgratuityAmnt+curTaxOnExcessPension;
        
         curPAYE:=curPAYE-ReliefhifAmount;
         end;
        
         //MESSAGE('%1',ReliefhifAmount);
        // ELSEf
        //  curPAYE :=curPAYE+curgratuityAmnt;
        if PhDisabled then curPAYE := 0;
         if not blnPaysPaye then curPAYE := 0; //Get statutory Exemption for the staff. If exempted from tax, set PAYE=0
         curTransAmount := (curPAYE);    //,0,'>'
         if curPAYE<0 then curTransAmount := 0;
         strTransDescription := 'P.A.Y.E';
         TaxAccount:=PostingGroup."Income Tax Account";
         TGroup := 'STATUTORIES'; TGroupOrder := 7; TSubGroupOrder := 3;
         fnUpdatePeriodTrans (strEmpCode, 'PAYE', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
          curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,TaxAccount,Journalpostas::Credit,
          Journalpostingtype::"G/L Account",'',Coopparameters::none);
         // END;
         //Store the unused relief for the current month
         //>If Paye<0 then "Insert into tblprUNUSEDRELIEF
         if curPAYE < 0 then begin
         prUnusedRelief.Reset;
         prUnusedRelief.SetRange(prUnusedRelief."Employee Code",strEmpCode);
         prUnusedRelief.SetRange(prUnusedRelief."Period Month",intMonth);
         prUnusedRelief.SetRange(prUnusedRelief."Period Year",intYear);
         if prUnusedRelief.Find('-') then
            prUnusedRelief.Delete;
        
         prUnusedRelief.Reset;
         with prUnusedRelief do begin
        //     INIT;
        //     "Employee Code" := strEmpCode;
        //     "Unused Relief" := curPAYE;
        //     "Period Month" := intMonth;
        //     "Period Year" := intYear;
        //     INSERT;
         end;
        end;
        
         //Deductions: get all deductions for the month
         //Loans: calc loan deduction amount, interest, fringe benefit (employer deduction), loan balance
         //>Balance = (Openning Bal + Deduction)...//Increasing balance
         //>Balance = (Openning Bal - Deduction)...//Reducing balance
         //>NB: some transactions (e.g Sacco shares) can be made by cheque or cash. Allow user to edit the outstanding balance
        
         //Get the N.H.I.F amount for the month GBT
        /*curNhif_Base_Amount :=0;
        
         IF intNHIF_BasedOn =intNHIF_BasedOn::Gross THEN //>NHIF calculation can be based on:
                 curNhif_Base_Amount := curGrossPay;
         IF intNHIF_BasedOn = intNHIF_BasedOn::Basic THEN
                curNhif_Base_Amount := curBasicPay;
         IF intNHIF_BasedOn =intNHIF_BasedOn::"Taxable Pay" THEN
                curNhif_Base_Amount := curTaxablePay;
        ReliefhifAmount:=0;
         IF blnPaysNhif THEN BEGIN
                        curNHIF := fnGetEmployeeNHIF(curNhif_Base_Amount);
                        curTransAmount := curNHIF;
                        NHIFEMPyee := PostingGroup."NHIF Employee Account";
                        strTransDescription := 'N.H.I.F';
                        TGroup := 'STATUTORIES';
                        TGroupOrder := 7;
                        TSubGroupOrder := 2;
                        fnUpdatePeriodTrans(strEmpCode, 'NHIF', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
                         curTransAmount, 0, intMonth, intYear, '', '', SelectedPeriod, Dept,
                         NHIFEMPyee, JournalPostAs::Credit, JournalPostingType::"G/L Account", '', CoopParameters::none);
        
                        ReliefhifAmount:=0;
                        IF blnPaysPaye THEN BEGIN
                            //Get Insurance Relief
                           //IF ((NhifInsuApplies) AND (NHIFInsurancePercentage > 0)) THEN BEGIN
        
                                //curNHIFInsuranceReliefAmount := ((NHIFInsurancePercentage / 100) * curNHIF);
                                curNHIFInsuranceReliefAmount := ((15/ 100) * curNHIF);
                               // IF curNHIFInsuranceReliefAmount > NHIFInsuranceCap THEN
                                 //   curNHIFInsuranceReliefAmount := NHIFInsuranceCap;
        
                                //IF curNHIFInsuranceReliefAmount > 0 THEN BEGIN
                                    curTransAmount := curNHIFInsuranceReliefAmount;
                                    ReliefhifAmount := curTransAmount;
                                    //MESSAGE('%1',ReliefhifAmount);
                                    strTransDescription := 'NHIF Insurance Relief';
                                    TGroup := 'TAX CALCULATIONS';
                                    TGroupOrder := 6;
                                    TSubGroupOrder := 8;
                                    fnUpdatePeriodTrans(strEmpCode, 'NHIFINSR', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
                                    curTransAmount, 0, intMonth, intYear, '', '', SelectedPeriod, Dept, '', JournalPostAs::" ", JournalPostingType::" "
                                    , '', CoopParameters::none);
                                //END;
                            //END;
                       END;
                    END;*/
        
        
        Clear(CurrLeadingGross);
        CurrLeadingGross:=curGrossPay-curNSSF-curgratuityAmnt-curgManInsuranceReliefyAmnt-curPAYE-curNHIF;
        
          prEmployeeTransactions.Reset;
          prEmployeeTransactions.SetRange(prEmployeeTransactions."Employee Code",strEmpCode);
          prEmployeeTransactions.SetRange(prEmployeeTransactions."Period Month",intMonth);
          prEmployeeTransactions.SetRange(prEmployeeTransactions."Period Year",intYear);
         prEmployeeTransactions.SetCurrentkey(prEmployeeTransactions."Recovery Priority");
          if prEmployeeTransactions.Find('-') then begin
            curTotalDeductions:= 0;
            repeat
              prTransactionCodes.Reset;
              prTransactionCodes.SetRange(prTransactionCodes."Transaction Code",prEmployeeTransactions."Transaction Code");
              prTransactionCodes.SetRange(prTransactionCodes."Transaction Type",prTransactionCodes."transaction type"::Deduction);
              if prTransactionCodes.Find('-') then begin
                curTransAmount:=0; curTransBalance := 0; strTransDescription := ''; strExtractedFrml := '';
        
                if prTransactionCodes."Is Formula" then begin
                    strExtractedFrml := fnPureFormula(strEmpCode, intMonth, intYear, prTransactionCodes.Formula);
                    curTransAmount := fnFormulaResult(strExtractedFrml); //Get the calculated amount
        
                end else begin
                    curTransAmount := prEmployeeTransactions.Amount;
                end;
        
               //**************************If "deduct Premium" is not ticked and the type is insurance- Dennis*****
               if (prTransactionCodes."Special Transactions"=prTransactionCodes."special transactions"::"Life Insurance")
                 and (prTransactionCodes."Deduct Premium"=false) then
                begin
                 curTransAmount:=0;
                end;
        
               //**************************If "deduct Premium" is not ticked and the type is mortgage- Dennis*****
               if(prTransactionCodes."Special Transactions"=prTransactionCodes."special transactions"::Morgage)
                and (prTransactionCodes."Deduct Mortgage"=false) then
                begin
                 curTransAmount:=0;
                end;
        
        // Added By Wanjala
               //**************************If "deduct Premium" is not ticked and the type is mortgage *****
               if(prTransactionCodes."Special Transactions"=prTransactionCodes."special transactions"::Gratuity)
                and (prTransactionCodes."Deduct Mortgage"=false) then
                begin
                 curTransAmount:=prEmployeeTransactions.Amount*0.3;
                end;
        //Add ben
             /*IF(prTransactionCodes."Special Transactions"=prTransactionCodes."Special Transactions"::KUDHEIHA)
                AND (prTransactionCodes.Kudheia=TRUE) AND (prTransactionCodes."Is Formula"=TRUE)THEN
                BEGIN
                 strExtractedFrml := fnPureFormula(strEmpCode, intMonth, intYear, prTransactionCodes.Formula);
                    curTransAmount := fnFormulaResult(strExtractedFrml); //Get the calculated amou
                END ELSE IF curTransAmount >500 THEN
                curTransAmount:=500;
               // END;*/
            //add
        
        
            //Get the posting Details
                 JournalPostingType:=Journalpostingtype::" ";JournalAcc:='';
                 if prTransactionCodes.Subledger<>prTransactionCodes.Subledger::" " then begin
                    if prTransactionCodes.Subledger=prTransactionCodes.Subledger::Customer then begin
                        Customer.Reset;
                       // Customer.SETRANGE(Customer."Payroll/Staff No",strEmpCode);
                        if Customer.Find('-') then begin
                           JournalAcc:=Customer."No.";
                           JournalPostingType:=Journalpostingtype::Customer;
                        end;
                    end;
                 end else begin
                    JournalAcc:=prTransactionCodes."GL Account";
                    JournalPostingType:=Journalpostingtype::"G/L Account";
                 end;
        
                //End posting Details
        
                //Loan Calculation is Amortized do Calculations here -Monthly Principal and Interest Keeps on Changing
                if (prTransactionCodes."Special Transactions"=prTransactionCodes."special transactions"::"Staff Loan") and
                   (prTransactionCodes."Repayment Method" = prTransactionCodes."repayment method"::Amortized) then begin
                   curTransAmount:=0; curLoanInt:=0;
                   curLoanInt:=fnCalcLoanInterest (strEmpCode, prEmployeeTransactions."Transaction Code",
                   prTransactionCodes."Interest Rate",prTransactionCodes."Repayment Method",
                      prEmployeeTransactions."Original Amount",prEmployeeTransactions.Balance,SelectedPeriod,false);
                   //Post the Interest
                   if (curLoanInt<>0) then begin
                          curTransAmount := curLoanInt;
                        //  curTotalDeductions := curTotalDeductions + curLoanInt; //Sum-up all the deductions
                          curTransBalance:=0;
                          strTransCode := prEmployeeTransactions."Transaction Code"+'-INT';
                          strTransDescription := prEmployeeTransactions."Transaction Name"+ ' Interest';
                          TGroup := 'DEDUCTIONS'; TGroupOrder := 8; TSubGroupOrder := 1;
                          fnUpdatePeriodTrans(strEmpCode, strTransCode, TGroup, TGroupOrder, TSubGroupOrder,
                            strTransDescription, curTransAmount, curTransBalance, intMonth, intYear,
                            prEmployeeTransactions.Membership, prEmployeeTransactions."Reference No",SelectedPeriod,Dept,
                            JournalAcc,Journalpostas::Credit,JournalPostingType,'',Coopparameters::none)
                    end;
                   //Get the Principal Amt
                   curTransAmount:=prEmployeeTransactions."Amortized Loan Total Repay Amt"-curLoanInt;
                    //Modify PREmployeeTransaction Table
                    prEmployeeTransactions.Amount:=curTransAmount;
                   // prEmployeeTransactions.MODIFY;
                end;
                //Loan Calculation Amortized
        
                case prTransactionCodes."Balance Type" of //[0=None, 1=Increasing, 2=Reducing]
                    prTransactionCodes."balance type"::None:
                         curTransBalance := 0;
                    prTransactionCodes."balance type"::Increasing:
                        curTransBalance := prEmployeeTransactions.Balance+ curTransAmount;
                   prTransactionCodes."balance type"::Reducing:
                   begin
                        //curTransBalance := prEmployeeTransactions.Balance - curTransAmount;
                        if prEmployeeTransactions.Balance < prEmployeeTransactions.Amount then begin
                             curTransAmount := prEmployeeTransactions.Balance;
                             curTransBalance := 0;
                         end else begin
                             curTransBalance := prEmployeeTransactions.Balance - curTransAmount;
                         end;
                         if curTransBalance < 0 then begin
                             curTransAmount := 0;
                             curTransBalance := 0;
                         end;
                   end
              end;
              // ** Wanjala Tom
              // ** Added to prevent Negative Pay
              if ((CurrLeadingGross>0) and (CurrLeadingGross>curTransAmount)) then begin
              CurrLeadingGross:=CurrLeadingGross-curTransAmount;
                curTotalDeductions := curTotalDeductions + curTransAmount; //Sum-up all the deductions
                curTransAmount := curTransAmount;
                curTransBalance := curTransBalance;
                end else if  ((CurrLeadingGross>0) and ((CurrLeadingGross<curTransAmount) or (CurrLeadingGross=curTransAmount))) then begin
                curTransAmount:=CurrLeadingGross;
                CurrLeadingGross:=0;
                curTotalDeductions := curTotalDeductions + curTransAmount;
                if curTransBalance>0 then
                curTransBalance:=(curTransBalance+(curTransAmount-CurrLeadingGross));
                end else if CurrLeadingGross=0 then begin
                if curTransBalance>0 then
                curTransBalance:=(curTransBalance+(curTransAmount-CurrLeadingGross));
                 curTransAmount:=0;
                end;
        
        
        
                strTransDescription := prTransactionCodes."Transaction Name";
                TGroup := 'DEDUCTIONS'; TGroupOrder := 8; TSubGroupOrder := 0;
                fnUpdatePeriodTrans (strEmpCode, prEmployeeTransactions."Transaction Code", TGroup, TGroupOrder, TSubGroupOrder,
                 strTransDescription,curTransAmount, curTransBalance, intMonth,
                 intYear, prEmployeeTransactions.Membership, prEmployeeTransactions."Reference No",SelectedPeriod,Dept,
                 JournalAcc,Journalpostas::Credit,JournalPostingType,'',Coopparameters::none);
        
        //Check if transaction is loan. Get the Interest on the loan & post it at this point before moving next ****Loan Calculation
                if (prTransactionCodes."Special Transactions"=prTransactionCodes."special transactions"::"Staff Loan") and
                   (prTransactionCodes."Repayment Method" <> prTransactionCodes."repayment method"::Amortized) then begin
        
                     curLoanInt:=fnCalcLoanInterest (strEmpCode, prEmployeeTransactions."Transaction Code",
                    prTransactionCodes."Interest Rate",
                     prTransactionCodes."Repayment Method", prEmployeeTransactions."Original Amount",
                     prEmployeeTransactions.Balance,SelectedPeriod,false);
                      if curLoanInt > 0 then begin
        
                          curTransAmount := curLoanInt;
                          //curTotalDeductions := curTotalDeductions + curTransAmount; //Sum-up all the deductions
                              if ((CurrLeadingGross>0) and (CurrLeadingGross>curTransAmount)) then begin
              CurrLeadingGross:=CurrLeadingGross-curTransAmount;
                curTotalDeductions := curTotalDeductions + curTransAmount; //Sum-up all the deductions
                curTransAmount := curTransAmount;
                curTransBalance := curTransBalance;
                end else if  ((CurrLeadingGross>0) and ((CurrLeadingGross<curTransAmount) or (CurrLeadingGross=curTransAmount))) then begin
                curTransAmount:=CurrLeadingGross;
                CurrLeadingGross:=0;
                curTotalDeductions := curTotalDeductions + curTransAmount;
                if curTransBalance>0 then
                curTransBalance:=(curTransBalance+(curTransAmount-CurrLeadingGross));
                end else if CurrLeadingGross=0 then begin
                if curTransBalance>0 then
                curTransBalance:=(curTransBalance+(curTransAmount-CurrLeadingGross));
                 curTransAmount:=0;
                end;
        
                          curTransBalance:=0;
                          strTransCode := prEmployeeTransactions."Transaction Code"+'-INT';
                          strTransDescription := prEmployeeTransactions."Transaction Name"+ ' Interest';
                          TGroup := 'DEDUCTIONS'; TGroupOrder := 8; TSubGroupOrder := 1;
                          fnUpdatePeriodTrans(strEmpCode, strTransCode, TGroup, TGroupOrder, TSubGroupOrder,
                            strTransDescription, curTransAmount, curTransBalance, intMonth, intYear,
                            prEmployeeTransactions.Membership, prEmployeeTransactions."Reference No",SelectedPeriod,Dept,
                            JournalAcc,Journalpostas::Credit,JournalPostingType,'',Coopparameters::none)
                     end;
               end;
               //End Loan transaction calculation
               //Fringe Benefits and Low interest Benefits
                      if prTransactionCodes."Fringe Benefit" = true then begin
                          if prTransactionCodes."Interest Rate" < curLoanMarketRate then begin
                              fnCalcFringeBenefit := (((curLoanMarketRate - prTransactionCodes."Interest Rate") * curLoanCorpRate) / 1200)
                               * prEmployeeTransactions.Balance;
                          end;
                      end else begin
                          fnCalcFringeBenefit := 0;
                      end;
                      if  fnCalcFringeBenefit>0 then begin
                          fnUpdateEmployerDeductions(strEmpCode, prEmployeeTransactions."Transaction Code"+'-FRG',
                           'EMP', TGroupOrder, TSubGroupOrder,'Fringe Benefit Tax', fnCalcFringeBenefit, 0, intMonth, intYear,
                            prEmployeeTransactions.Membership, prEmployeeTransactions."Reference No",SelectedPeriod)
        
                      end;
               //End Fringe Benefits
        
              //Create Employer Deduction
              if (prTransactionCodes."Employer Deduction") or (prTransactionCodes."Include Employer Deduction") then begin
                if prTransactionCodes."Is Formula for employer"<>'' then begin
                    strExtractedFrml := fnPureFormula(strEmpCode, intMonth, intYear,prTransactionCodes."Is Formula for employer");
                    curTransAmount := fnFormulaResult(strExtractedFrml); //Get the calculated amount
                end else begin
                    curTransAmount := prEmployeeTransactions."Employer Amount";
                end;
                      if  curTransAmount>0 then
                          fnUpdateEmployerDeductions(strEmpCode, prEmployeeTransactions."Transaction Code",
                           'EMP', TGroupOrder, TSubGroupOrder,'', curTransAmount, 0, intMonth, intYear,
                            prEmployeeTransactions.Membership, prEmployeeTransactions."Reference No",SelectedPeriod)
        
              end;
              //Employer deductions
        
              end;
        
          until prEmployeeTransactions.Next=0;
             //GET TOTAL DEDUCTIONS
                          curTransBalance:=0;
                          strTransCode := 'TOT-DED';
                          strTransDescription := 'TOTAL DEDUCTION';
        
                          TGroup := 'DEDUCTIONS'; TGroupOrder := 8; TSubGroupOrder := 9;
                          fnUpdatePeriodTrans(strEmpCode, strTransCode, TGroup, TGroupOrder, TSubGroupOrder,
                            strTransDescription,curTotalDeductions , curTransBalance, intMonth, intYear,
                            // (curTotalDeductions+curPAYE+curNHIF+curNssfEmployee)
                            prEmployeeTransactions.Membership, prEmployeeTransactions."Reference No",SelectedPeriod,Dept,
                            '',Journalpostas::" ",Journalpostingtype::" ",'',Coopparameters::none)
        
             //END GET TOTAL DEDUCTIONS
         end;
        
          //Net Pay: calculate the Net pay for the month in the following manner:
          //>Nett = Gross - (xNssfAmount + curMyNhifAmt + PAYE + PayeArrears + prTotDeductions)
          //...Tot Deductions also include (SumLoan + SumInterest)
          curNetPay := curGrossPay - (curNSSF + curNHIF+ curTaxOnExcessPension+ curPAYE + curPayeArrears + curTotalDeductions);
        
          //>Nett = Nett - curExcessPension
          //...Excess pension is only used for tax. Staff is not paid the amount hence substract it
          curNetPay :=(curNetPay); //- curExcessPension
        
          //>Nett = Nett - cSumEmployerDeductions
          //...Employer Deductions are used for reporting as cost to company BUT dont affect Net pay
          curNetPay := curNetPay - curTotCompanyDed; //******Get Company Deduction*****
        
         /* curNetRnd_Effect := curNetPay - ROUND(curNetPay,1,'=');
          RoundDownDiff:=0;
          RoundUpDif:=0;
          IF curNetRnd_Effect>0 THEN BEGIN
           RoundDownDiff:=ROUND(curNetRnd_Effect,0.01,'=');
          END ELSE BEGIN
            IF curNetRnd_Effect<>0 THEN BEGIN
            RoundUpDif:=((ROUND(curNetRnd_Effect,0.01,'='))*(-1));
            END;
          END;
          IF ((RoundDownDiff<>0) OR (RoundUpDif<>0)) THEN BEGIN
          // Insert the Rounding Effect Into the Salary Card Table For that Specific Month and Year
          empsalCard.RESET;
          empsalCard.SETRANGE(empsalCard."Employee Code",strEmpCode);
          IF empsalCard.FIND('-') THEN BEGIN
            IF RoundDownDiff<>0 THEN BEGIN
              empsalCard."Current Round Down":=RoundDownDiff;
              empsalCard."Current Round Up":=0;
              empsalCard."Current Month":=intMonth;
              empsalCard."Current Year":=intYear;
               empsalCard.MODIFY;
            END ELSE IF RoundUpDif<>0 THEN BEGIN
              empsalCard."Current Round Down":=0;
              empsalCard."Current Round Up":=RoundUpDif;
              empsalCard."Current Month":=intMonth;
              empsalCard."Current Year":=intYear;
              empsalCard.MODIFY;
            END;
          END;
          END ELSE BEGIN
          empsalCard.RESET;
          empsalCard.SETRANGE(empsalCard."Employee Code",strEmpCode);
               IF empsalCard.FIND('-') THEN BEGIN
              empsalCard."Current Round Down":=0;
              empsalCard."Current Round Up":=0;
              empsalCard."Current Month":=intMonth;
              empsalCard."Current Year":=intYear;
              empsalCard.MODIFY;
              END;
          END;*/
         // curNetPay :=
          //curTransAmount :=  ROUND(curNetPay,1,'=');
          curTransAmount :=  (curNetPay);
          strTransDescription := 'Net Pay';
          PayablesAcc:=PostingGroup."Net Salary Payable";
          TGroup := 'NET PAY'; TGroupOrder := 9; TSubGroupOrder := 0;
          fnUpdatePeriodTrans(strEmpCode, 'NPAY', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
          curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,
          PayablesAcc,Journalpostas::Credit,Journalpostingtype::"G/L Account",'',Coopparameters::none);
        
          //Rounding Effect: if the Net pay is rounded, take the rounding effect &
          //save it as an earning for the staff for the next month
              //>Insert the Netpay rounding effect into the tblRoundingEffect table
        
        
          //Negative pay: if the NetPay<0 then log the entry
              //>Display an on screen report
              //>Through a pop-up to the user
              //>Send an email to the user or manager
        end;
        end

    end;


    procedure fnBasicPayProrated(strEmpCode: Code[20];Month: Integer;Year: Integer;BasicSalary: Decimal;DaysWorked: Integer;DaysInMonth: Integer) ProratedAmt: Decimal
    begin
         ProratedAmt:= ROUND((DaysWorked / DaysInMonth) * BasicSalary);
    end;


    procedure fnDaysInMonth(dtDate: Date) DaysInMonth: Integer
    var
        Day: Integer;
        SysDate: Record Date;
        Expr1: Text[30];
        FirstDay: Date;
        LastDate: Date;
        TodayDate: Date;
    begin
        TodayDate:=dtDate;

         Day:=Date2dmy(TodayDate,1);
         Expr1:=Format(-Day)+'D+1D';
         FirstDay:=CalcDate(Expr1,TodayDate);
         LastDate:=CalcDate('1M-1D',FirstDay);

         SysDate.Reset;
         SysDate.SetRange(SysDate."Period Type",SysDate."period type"::Date);
         SysDate.SetRange(SysDate."Period Start",FirstDay,LastDate);
        // SysDate.SETFILTER(SysDate."Period No.",'1..5');
         if SysDate.Find('-') then
            DaysInMonth:=SysDate.Count;
    end;


    procedure fnUpdatePeriodTrans(EmpCode: Code[20];TCode: Code[20];TGroup: Code[20];GroupOrder: Integer;SubGroupOrder: Integer;Description: Text[50];curAmount: Decimal;curBalance: Decimal;Month: Integer;Year: Integer;mMembership: Text[30];ReferenceNo: Text[30];dtOpenPeriod: Date;Department: Code[20];JournalAC: Code[20];PostAs: Option " ",Debit,Credit;JournalACType: Option " ","G/L Account",Customer,Vendor;LoanNo: Code[20];CoopParam: Option "none",shares,loan,"loan Interest","Emergency loan","Emergency loan Interest","School Fees loan","School Fees loan Interest",Welfare,Pension)
    var
        prPeriodTransactions: Record UnknownRecord61092;
        prSalCard: Record UnknownRecord61118;
    begin

        if curAmount = 0 then
          if ((TCode<>'NPAY') and (curBalance=0)) then
            exit;
        with prPeriodTransactions do begin
            Init;
            "Employee Code" := EmpCode;
            "Transaction Code" := TCode;
            "Group Text" := TGroup;
            "Transaction Name" := Description;
           //  Amount := ROUND(curAmount,0.05,'=');
             Amount := (curAmount);
             Balance := curBalance;
            "Original Amount" := Balance;
            "Group Order" := GroupOrder;
            "Sub Group Order" := SubGroupOrder;
             Membership := mMembership;
             "Reference No" := ReferenceNo;
            "Period Month" := Month;
            "Period Year" := Year;
            "Payroll Period" := dtOpenPeriod;
            "Department Code":=Department;
            "Journal Account Type":=JournalACType;
            "Post As":=PostAs;
            "Journal Account Code":=JournalAC;
             "Loan Number":=LoanNo;
             "coop parameters":=CoopParam;
             "Payroll Code":=PayrollType;
             //Paymode
             if prSalCard.Get(EmpCode) then
                "Payment Mode":=prSalCard."Payment Mode";
            Insert;
           //Update the prEmployee Transactions  with the Amount
           fnUpdateEmployeeTrans( "Employee Code","Transaction Code",Amount,"Period Month","Period Year","Payroll Period");
        end;
    end;


    procedure fnGetSpecialTransAmount(strEmpCode: Code[20];intMonth: Integer;intYear: Integer;intSpecTransID: Option Ignore,"Defined Contribution","Home Ownership Savings Plan","Life Insurance","Owner Occupier Interest","Prescribed Benefit","Salary Arrears","Staff Loan","Value of Quarters",Morgage,Gratuity,"Insurance Relief","Allowance Recovery",KUDHEIHA,"Housing Levy",SHIF;blnCompDedc: Boolean) SpecialTransAmount: Decimal
    var
        prEmployeeTransactions: Record UnknownRecord61091;
        prTransactionCodes: Record UnknownRecord61082;
        strExtractedFrml: Text[250];
    begin
        SpecialTransAmount:=0;
        prTransactionCodes.Reset;
        prTransactionCodes.SetRange(prTransactionCodes."Special Transactions",intSpecTransID);
        if prTransactionCodes.Find('-') then begin
        repeat
           prEmployeeTransactions.Reset;
           prEmployeeTransactions.SetRange(prEmployeeTransactions."Employee Code",strEmpCode);
           prEmployeeTransactions.SetRange(prEmployeeTransactions."Transaction Code",prTransactionCodes."Transaction Code");
           prEmployeeTransactions.SetRange(prEmployeeTransactions."Period Month",intMonth);
           prEmployeeTransactions.SetRange(prEmployeeTransactions."Period Year",intYear);
           prEmployeeTransactions.SetRange(prEmployeeTransactions.Suspended,false);
         prEmployeeTransactions.SetCurrentkey(prEmployeeTransactions."Recovery Priority");
           if prEmployeeTransactions.Find('-') then begin
        
            //Ignore,Defined Contribution,Home Ownership Savings Plan,Life Insurance,
            //Owner Occupier Interest,Prescribed Benefit,Salary Arrears,Staff Loan,Value of Quarters
              case intSpecTransID of
                Intspectransid::"Defined Contribution":
                  if prTransactionCodes."Is Formula" then begin
                      strExtractedFrml := '';
                      strExtractedFrml := fnPureFormula(strEmpCode, intMonth, intYear, prTransactionCodes.Formula);
                      SpecialTransAmount := SpecialTransAmount+(fnFormulaResult(strExtractedFrml)); //Get the calculated amount
                  end else
                      SpecialTransAmount := SpecialTransAmount+prEmployeeTransactions.Amount;
        
                Intspectransid::"Allowance Recovery":
                      SpecialTransAmount := SpecialTransAmount+prEmployeeTransactions.Amount;
        
        
                Intspectransid::"Life Insurance":
                    SpecialTransAmount :=SpecialTransAmount+( (curReliefInsurance / 100) * prEmployeeTransactions.Amount);
        
        //
                Intspectransid::"Owner Occupier Interest":
                      SpecialTransAmount := SpecialTransAmount+prEmployeeTransactions.Amount;
        
        
                Intspectransid::"Home Ownership Savings Plan":
                      SpecialTransAmount := SpecialTransAmount+prEmployeeTransactions.Amount;
        
                Intspectransid::Gratuity:
                      SpecialTransAmount := SpecialTransAmount+prEmployeeTransactions.Amount*0.3;
        
                Intspectransid::"Insurance Relief":
                      SpecialTransAmount := SpecialTransAmount+prEmployeeTransactions.Amount;
                Intspectransid::"Housing Levy":
                  begin
                      strExtractedFrml := '';
                      strExtractedFrml := fnPureFormula(strEmpCode, intMonth, intYear, prTransactionCodes.Formula);
                      SpecialTransAmount := SpecialTransAmount+(fnFormulaResult(strExtractedFrml));
                    end;
                Intspectransid::SHIF:
                begin
                  strExtractedFrml := '';
                      strExtractedFrml := fnPureFormula(strEmpCode, intMonth, intYear, prTransactionCodes.Formula);
                      SpecialTransAmount := SpecialTransAmount+(fnFormulaResult(strExtractedFrml));
                  end;
        
        
        
                Intspectransid::Morgage:
                  begin
                    SpecialTransAmount :=SpecialTransAmount+ curReliefMorgage;
        
                    if SpecialTransAmount > curReliefMorgage then
                     begin
                      SpecialTransAmount:=curReliefMorgage
                     end;
                     end;
        
                ///add ben
                 /*intSpecTransID::KUDHEIHA:
                  IF prTransactionCodes."Is Formula" THEN BEGIN
                      strExtractedFrml := '';
                      strExtractedFrml := fnPureFormula(strEmpCode, intMonth, intYear, prTransactionCodes.Formula);
                      SpecialTransAmount := SpecialTransAmount+(fnFormulaResult(strExtractedFrml)); //Get the calculated amount
                  END ELSE
                    IF SpecialTransAmount > 500 THEN
                     BEGIN
                      SpecialTransAmount:=500;
                     END;*/
                 // END;
        
        
              end;
           end else begin
           //handle formularized first time base transactions.
           case intSpecTransID of
                Intspectransid::SHIF:
                begin
                  strExtractedFrml := '';
                      strExtractedFrml := fnPureFormula(strEmpCode, intMonth, intYear, prTransactionCodes.Formula);
                      SpecialTransAmount := SpecialTransAmount+(fnFormulaResult(strExtractedFrml));
                  end;
                  end;
           end;
         until prTransactionCodes.Next=0;
        end;
        SpecialTranAmount:=SpecialTransAmount;

    end;


    procedure fnGetEmployeePaye(curTaxablePay: Decimal) PAYE: Decimal
    var
        prPAYE: Record UnknownRecord61076;
        curTempAmount: Decimal;
        KeepCount: Integer;
    begin
        KeepCount:=0;
        prPAYE.Reset;
        if prPAYE.FindFirst then begin
        if curTaxablePay < prPAYE."PAYE Tier" then exit;
        repeat
         KeepCount+=1;
         curTempAmount:= curTaxablePay;
         if curTaxablePay = 0 then exit;
               if KeepCount = prPAYE.Count then   //this is the last record or loop
                  curTaxablePay := curTempAmount
                else
                   if curTempAmount >= prPAYE."PAYE Tier" then
                    curTempAmount := prPAYE."PAYE Tier"
                   else
                     curTempAmount := curTempAmount;

        PAYE := PAYE + (curTempAmount * (prPAYE.Rate / 100));
        curTaxablePay := curTaxablePay - curTempAmount;

        until prPAYE.Next=0;
        end;
    end;


    procedure fnGetEmployeeNHIF(curBaseAmount: Decimal) NHIF: Decimal
    var
        prNHIF: Record UnknownRecord61075;
    begin
        prNHIF.Reset;
        prNHIF.SetCurrentkey(prNHIF."Tier Code");
        if prNHIF.FindFirst then begin
        repeat
        if ((curBaseAmount>=prNHIF."Lower Limit") and (curBaseAmount<=prNHIF."Upper Limit")) then
            NHIF:=prNHIF.Amount;
        until prNHIF.Next=0;
        end;
    end;


    procedure fnPureFormula(strEmpCode: Code[20];intMonth: Integer;intYear: Integer;strFormula: Text[250]) Formula: Text[250]
    var
        Where: Text[30];
        Which: Text[30];
        i: Integer;
        TransCode: Code[20];
        Char: Text[1];
        FirstBracket: Integer;
        StartCopy: Boolean;
        FinalFormula: Text[250];
        TransCodeAmount: Decimal;
        AccSchedLine: Record "Acc. Schedule Line";
        ColumnLayout: Record "Column Layout";
        CalcAddCurr: Boolean;
        AccSchedMgt: Codeunit AccSchedManagement;
    begin
           TransCode:='';
           for i:=1 to StrLen(strFormula) do begin
           Char:=CopyStr(strFormula,i,1);
           if Char='[' then  StartCopy:=true;

           if StartCopy then TransCode:=TransCode+Char;
           //Copy Characters as long as is not within []
           if not StartCopy then
              FinalFormula:=FinalFormula+Char;
           if Char=']' then begin
            StartCopy:=false;
            //Get Transcode
              Where := '=';
              Which := '[]';
              TransCode := DelChr(TransCode, Where, Which);
            //Get TransCodeAmount
            TransCodeAmount:=fnGetTransAmount(strEmpCode, TransCode, intMonth, intYear);
            //Reset Transcode
             TransCode:='';
            //Get Final Formula
             FinalFormula:=FinalFormula+Format(TransCodeAmount);
            //End Get Transcode
           end;
           end;
           Formula:=FinalFormula;
    end;


    procedure fnGetTransAmount(strEmpCode: Code[20];strTransCode: Code[20];intMonth: Integer;intYear: Integer) TransAmount: Decimal
    var
        prEmployeeTransactions: Record UnknownRecord61091;
        prPeriodTransactions: Record UnknownRecord61092;
    begin
        prEmployeeTransactions.Reset;
        prEmployeeTransactions.SetRange(prEmployeeTransactions."Employee Code",strEmpCode);
        prEmployeeTransactions.SetRange(prEmployeeTransactions."Transaction Code",strTransCode);
        prEmployeeTransactions.SetRange(prEmployeeTransactions."Period Month",intMonth);
        prEmployeeTransactions.SetRange(prEmployeeTransactions."Period Year",intYear);
        prEmployeeTransactions.SetRange(prEmployeeTransactions.Suspended,false);
         prEmployeeTransactions.SetCurrentkey(prEmployeeTransactions."Recovery Priority");
        if prEmployeeTransactions.FindFirst then begin

          TransAmount:=prEmployeeTransactions.Amount;
          if prEmployeeTransactions."No of Units"<>0 then
             TransAmount:=prEmployeeTransactions."No of Units";

        end;
        if TransAmount=0 then begin
        prPeriodTransactions.Reset;
        prPeriodTransactions.SetRange(prPeriodTransactions."Employee Code",strEmpCode);
        prPeriodTransactions.SetRange(prPeriodTransactions."Transaction Code",strTransCode);
        prPeriodTransactions.SetRange(prPeriodTransactions."Period Month",intMonth);
        prPeriodTransactions.SetRange(prPeriodTransactions."Period Year",intYear);
        if prPeriodTransactions.FindFirst then
          TransAmount:=prPeriodTransactions.Amount;
        end;
    end;


    procedure fnFormulaResult(strFormula: Text[250]) Results: Decimal
    var
        AccSchedLine: Record "Acc. Schedule Line";
        ColumnLayout: Record "Column Layout";
        CalcAddCurr: Boolean;
        AccSchedMgt: Codeunit AccSchedManagement;
    begin
        Results:=AccSchedMgt.EvaluateExpression(true,strFormula,AccSchedLine,ColumnLayout,CalcAddCurr);
    end;


    procedure fnClosePayrollPeriod(dtOpenPeriod: Date;PayrollCode: Code[20]) Closed: Boolean
    var
        dtNewPeriod: Date;
        intNewMonth: Integer;
        intNewYear: Integer;
        prEmployeeTransactions: Record UnknownRecord61091;
        prPeriodTransactions: Record UnknownRecord61092;
        intMonth: Integer;
        intYear: Integer;
        prTransactionCodes: Record UnknownRecord61082;
        curTransAmount: Decimal;
        curTransBalance: Decimal;
        prEmployeeTrans: Record UnknownRecord61091;
        prPayrollPeriods: Record UnknownRecord61081;
        prNewPayrollPeriods: Record UnknownRecord61081;
        CreateTrans: Boolean;
        ControlInfo: Record UnknownRecord61119;
        prsalCard3: Record UnknownRecord61105;
    begin
        ControlInfo.Get();

        dtNewPeriod := CalcDate('1M', dtOpenPeriod);
        intNewMonth := Date2dmy(dtNewPeriod,2);
        intNewYear := Date2dmy(dtNewPeriod,3);
        intOldMonth:= Date2dmy(dtOpenPeriod,2);
        intOldYear:= Date2dmy(dtOpenPeriod,3);

        intMonth := Date2dmy(dtOpenPeriod,2);
        intYear := Date2dmy(dtOpenPeriod,3);

        prEmployeeTransactions.Reset;
        prEmployeeTransactions.SetRange(prEmployeeTransactions."Period Month",intMonth);
        prEmployeeTransactions.SetRange(prEmployeeTransactions."Period Year",intYear);

        //Multiple Payroll
        if ControlInfo."Multiple Payroll" then begin
            prEmployeeTransactions.SetRange(prEmployeeTransactions."Payroll Code",PayrollCode);
            end;

        //prEmployeeTransactions.SETRANGE(prEmployeeTransactions."Employee Code",'KPSS091');


         prEmployeeTransactions.SetCurrentkey(prEmployeeTransactions."Recovery Priority");
        if prEmployeeTransactions.Find('-') then begin
          repeat
           prTransactionCodes.Reset;
           prTransactionCodes.SetRange(prTransactionCodes."Transaction Code",prEmployeeTransactions."Transaction Code");
           if prTransactionCodes.Find('-') then begin
            with prTransactionCodes do begin
              case prTransactionCodes."Balance Type" of
                prTransactionCodes."balance type"::None:
                 begin
                  curTransAmount:= prEmployeeTransactions.Amount;
                  curTransBalance:= 0;
                 end;
                prTransactionCodes."balance type"::Increasing:
                 begin
                   curTransAmount := prEmployeeTransactions.Amount;
                   curTransBalance := prEmployeeTransactions.Balance + prEmployeeTransactions.Amount;
                 end;
                prTransactionCodes."balance type"::Reducing:
                 begin
                   curTransAmount := prEmployeeTransactions.Amount;
                   if prEmployeeTransactions.Balance < prEmployeeTransactions.Amount then begin
                       curTransAmount := prEmployeeTransactions.Balance;
                       curTransBalance := 0;
                   end else begin
                       curTransBalance := prEmployeeTransactions.Balance - prEmployeeTransactions.Amount;
                   end;
                   if curTransBalance < 0 then
                    begin
                       curTransAmount:=0;
                       curTransBalance:=0;
                    end;
                  end;
              end;
            end;
           end;

            //For those transactions with Start and End Date Specified
               if (prEmployeeTransactions."Start Date"<>0D) and (prEmployeeTransactions."End Date"<>0D) then begin
                   if prEmployeeTransactions."End Date"<dtNewPeriod then begin
                       curTransAmount:=0;
                       curTransBalance:=0;
                   end;
               end;
            //End Transactions with Start and End Date

          if (prTransactionCodes.Frequency=prTransactionCodes.Frequency::Fixed) and
             (prEmployeeTransactions."Stop for Next Period"=false) then //DENNO ADDED THIS TO CHECK FREQUENCY AND STOP IF MARKED
           begin
            //IF (curTransAmount <> 0) THEN //Update the employee transaction table
            // BEGIN
             if ((prTransactionCodes."Balance Type"=prTransactionCodes."balance type"::Reducing) and (curTransBalance <> 0)) or
              (prTransactionCodes."Balance Type"<>prTransactionCodes."balance type"::Reducing) then
              prEmployeeTransactions.Balance:=curTransBalance;
              prEmployeeTransactions.Modify;


           //Insert record for the next period
            with prEmployeeTrans do begin
            if (prEmployeeTransactions."Transaction Code"<>'D066') then
              if  (prEmployeeTransactions."Transaction Code"<>'P021') then begin
              Init;
              "Employee Code":= prEmployeeTransactions."Employee Code";
              "Transaction Code":= prEmployeeTransactions."Transaction Code";
              "Transaction Name":= prEmployeeTransactions."Transaction Name";
               Amount:= curTransAmount;
               Balance:= curTransBalance;
               "Amortized Loan Total Repay Amt":=prEmployeeTransactions. "Amortized Loan Total Repay Amt";
              "Original Amount":= prEmployeeTransactions."Original Amount";
               Membership:= prEmployeeTransactions.Membership;
              "Reference No":= prEmployeeTransactions."Reference No";
              "Loan Number":=prEmployeeTransactions."Loan Number";
              "Period Month":= intNewMonth;
              "Period Year":= intNewYear;
              "Payroll Period":= dtNewPeriod;
              "Payroll Code" :=PayrollCode;
              "Recurance Index":=prEmployeeTransactions."Recurance Index"-1;
              // Insert only if the counter for the frequnency is not 0
              if (prEmployeeTransactions."Recurance Index"-1)>0 then
               Insert;
               //END;
             end;
          end;
          end
          until prEmployeeTransactions.Next=0;
        prsalCard.Reset;
        prsalCard.SetRange("Payroll Period",dtOpenPeriod);
        if prsalCard.Find('-') then begin
          repeat
          begin
          if prsalCard."Current Round Up">0 then begin
            with prEmployeeTrans do begin
              Init;
              "Employee Code":= prsalCard."Employee Code";
              "Transaction Code":= 'D066';
              "Transaction Name":= 'Rounding Up Effect';
               Amount:= prsalCard."Current Round Up";
              "Period Month":= intNewMonth;
              "Period Year":= intNewYear;
              "Payroll Period":= dtNewPeriod;
              "Payroll Code" :=PayrollCode;
               Insert;
             end;
             end else if prsalCard."Current Round Down">0 then begin
            with prEmployeeTrans do begin
              Init;
              "Employee Code":= prsalCard."Employee Code";
              "Transaction Code":= 'P021';
              "Transaction Name":= 'Rounding Down Effect';
               Amount:= prsalCard."Current Round Down";
              "Period Month":= intNewMonth;
              "Period Year":= intNewYear;
              "Payroll Period":= dtNewPeriod;
              "Payroll Code" :=PayrollCode;
               Insert;
             end;
             end;

        prsalCard3.Reset;
        if not (prsalCard3.Get(prsalCard."Employee Code",dtNewPeriod)) then begin // Insert the Basic salary details for the current Month
        prsalCard3.Init;
        prsalCard3."Employee Code" := prsalCard."Employee Code";
        prsalCard3."Payroll Period" :=dtNewPeriod;
        prsalCard3."Basic Pay" := prsalCard."Basic Pay" ;
        prsalCard3."Payment Mode" := prsalCard."Payment Mode";
        prsalCard3.Currency := prsalCard.Currency;
        prsalCard3."Pays NSSF" :=  prsalCard."Pays NSSF";
        prsalCard3."Pays NHIF" := prsalCard."Pays NHIF";
        prsalCard3."Pays PAYE" := prsalCard."Pays PAYE" ;
        prsalCard3."Payslip Message":= prsalCard."Payslip Message" ;
        prsalCard3."Suspend Pay" := prsalCard."Suspend Pay" ;
        prsalCard3."Suspension Date" :=  prsalCard."Suspension Date" ;
        prsalCard3."Suspension Reasons" := prsalCard."Suspension Reasons";
        prsalCard3.Exists := prsalCard.Exists;
        prsalCard3."Bank Account Number" := prsalCard."Bank Account Number" ;
        prsalCard3."Bank Branch" :=  prsalCard."Bank Branch";
        prsalCard3."Employee's Bank" := prsalCard."Employee's Bank";
        prsalCard."Posting Group":= prsalCard."Posting Group";
        prsalCard3."Pays Pension":= prsalCard."Pays Pension";
        prsalCard3."Current Round Up" := 0;
        prsalCard3."Current Round Down" :=  0;
        prsalCard3."Preveous Round Down"  := prsalCard."Current Round Down";
        prsalCard3."Preveous Round Up"  :=  prsalCard."Current Round Up";
        prsalCard3."Period Month" := intNewMonth ;
        prsalCard3."Period Year" :=  intNewYear;
        prsalCard3."Current Month"  := intOldMonth ;
        prsalCard3."Current Year" := intOldYear;
        prsalCard3.Insert;
        end;

           // prsalCard."Preveous Round Down":=prsalCard."Current Round Down";
           // prsalCard."Preveous Round Up":=prsalCard."Current Round Up";
           // prsalCard."Period Month":=intNewMonth;
           // prsalCard."Period Year":=intNewYear;
           // prsalCard."Current Round Down":=0;
           // prsalCard."Current Round Up":=0;
           // prsalCard."Current Month":=intOldMonth;
           // prsalCard."Current Year":=intOldYear;
           // prsalCard.MODIFY;

          end;
          until prsalCard.Next=0;
        end;

        end;

        //Update the Period as Closed
        prPayrollPeriods.Reset;
        prPayrollPeriods.SetRange(prPayrollPeriods."Period Month",intMonth);
        prPayrollPeriods.SetRange(prPayrollPeriods."Period Year",intYear);
        prPayrollPeriods.SetRange(prPayrollPeriods.Closed,false);
        if ControlInfo."Multiple Payroll" then
            prPayrollPeriods.SetRange(prPayrollPeriods."Payroll Code",PayrollCode);

        if prPayrollPeriods.Find('-') then begin
           prPayrollPeriods.Closed:=true;
           prPayrollPeriods."Date Closed":=Today;
           prPayrollPeriods.Modify;
        end;

        //Enter a New Period
        with prNewPayrollPeriods do begin
          Init;
            "Period Month":=intNewMonth;
            "Period Year":= intNewYear;
            "Period Name":= Format(dtNewPeriod,0,'<Month Text>')+' - '+Format(intNewYear);
            "Date Opened":= dtNewPeriod;
             Closed :=false;
             "Payroll Code":=PayrollCode;
            Insert;
        end;

        //Effect the transactions for the P9
        fnP9PeriodClosure(intMonth, intYear, dtOpenPeriod,PayrollCode);

        //Take all the Negative pay (Net) for the current month & treat it as a deduction in the new period
        fnGetNegativePay(intMonth, intYear,dtOpenPeriod);
    end;


    procedure fnGetNegativePay(intMonth: Integer;intYear: Integer;dtOpenPeriod: Date)
    var
        prPeriodTransactions: Record UnknownRecord61092;
        prEmployeeTransactions: Record UnknownRecord61091;
        intNewMonth: Integer;
        intNewYear: Integer;
        dtNewPeriod: Date;
    begin
        dtNewPeriod := CalcDate('1M', dtOpenPeriod);
        intNewMonth := Date2dmy(dtNewPeriod,2);
        intNewYear := Date2dmy(dtNewPeriod,3);

        prPeriodTransactions.Reset;
        prPeriodTransactions.SetRange(prPeriodTransactions."Period Month",intMonth);
        prPeriodTransactions.SetRange(prPeriodTransactions."Period Year",intYear);
        prPeriodTransactions.SetRange(prPeriodTransactions."Group Order",9);
        prPeriodTransactions.SetFilter(prPeriodTransactions.Amount,'<0');

        if prPeriodTransactions.Find('-') then begin
        repeat
          with  prEmployeeTransactions do begin
            Init;
            "Employee Code":= prPeriodTransactions."Employee Code";
            "Transaction Code":= 'NEGP';
            "Transaction Name":='Negative Pay';
            Amount:= prPeriodTransactions.Amount;
            Balance:= 0;
            "Original Amount":=0;
            "Period Month":= intNewMonth;
            "Period Year":= intNewYear;
            "Payroll Period":=dtNewPeriod;
            Insert;
          end;
        until prPeriodTransactions.Next=0;
        end;
    end;


    procedure fnP9PeriodClosure(intMonth: Integer;intYear: Integer;dtCurPeriod: Date;PayrollCode: Code[20])
    var
        P9EmployeeCode: Code[20];
        P9BasicPay: Decimal;
        P9Allowances: Decimal;
        P9Benefits: Decimal;
        P9ValueOfQuarters: Decimal;
        P9DefinedContribution: Decimal;
        P9OwnerOccupierInterest: Decimal;
        P9GrossPay: Decimal;
        P9TaxablePay: Decimal;
        P9TaxCharged: Decimal;
        P9InsuranceRelief: Decimal;
        P9TaxRelief: Decimal;
        P9Paye: Decimal;
        P9NSSF: Decimal;
        P9NHIF: Decimal;
        P9Deductions: Decimal;
        P9NetPay: Decimal;
        prPeriodTransactions: Record UnknownRecord61092;
        prEmployee: Record UnknownRecord61118;
    begin
        P9BasicPay := 0; P9Allowances := 0; P9Benefits := 0; P9ValueOfQuarters := 0;
        P9DefinedContribution := 0; P9OwnerOccupierInterest := 0;
        P9GrossPay := 0; P9TaxablePay := 0; P9TaxCharged := 0; P9InsuranceRelief := 0;
        P9TaxRelief := 0; P9Paye := 0; P9NSSF := 0; P9NHIF := 0;
        P9Deductions := 0; P9NetPay := 0;

        prEmployee.Reset;
        prEmployee.SetRange(prEmployee.Status,prEmployee.Status::Normal);
        if prEmployee.Find('-') then begin
        repeat

        P9BasicPay := 0; P9Allowances := 0; P9Benefits := 0; P9ValueOfQuarters := 0;
        P9DefinedContribution := 0; P9OwnerOccupierInterest := 0;
        P9GrossPay := 0; P9TaxablePay := 0; P9TaxCharged := 0; P9InsuranceRelief := 0;
        P9TaxRelief := 0; P9Paye := 0; P9NSSF := 0; P9NHIF := 0;
        P9Deductions := 0; P9NetPay := 0;
        prPeriodTransactions.Reset;
        prPeriodTransactions.SetRange(prPeriodTransactions."Period Month",intMonth);
        prPeriodTransactions.SetRange(prPeriodTransactions."Period Year",intYear);
        prPeriodTransactions.SetRange(prPeriodTransactions."Employee Code",prEmployee."No.");
        if prPeriodTransactions.Find('-') then begin
          repeat
          //  IF ((prPeriodTransactions."Sub Group Order"=0) AND (prPeriodTransactions."Group Order"=8)) THEN p9Pension:=prPeriodTransactions.Amount;

          with prPeriodTransactions do begin
            case prPeriodTransactions."Group Order" of
                1: //Basic pay & Arrears
                begin
                  if "Sub Group Order" = 1 then P9BasicPay := Amount; //Basic Pay
                  if "Sub Group Order" = 2 then P9BasicPay := P9BasicPay + Amount; //Basic Pay Arrears
                end;
                3:  //Allowances
                begin
                 P9Allowances := P9Allowances + Amount
                end;
                4: //Gross Pay
                begin
                  P9GrossPay := Amount
                end;
                6: //Taxation
                begin
                  if "Sub Group Order" = 1 then P9DefinedContribution := Amount; //Defined Contribution
                  if "Sub Group Order" = 9 then P9TaxRelief := Amount; //Tax Relief
                  if "Sub Group Order" = 8 then P9InsuranceRelief := Amount; //Insurance Relief
                  if "Sub Group Order" = 6 then P9TaxablePay := Amount; //Taxable Pay
                  if "Sub Group Order" = 7 then P9TaxCharged := Amount; //Tax Charged
                end;
                7: //Statutories
                begin
                  if "Sub Group Order" = 1 then P9NSSF := Amount; //Nssf
                  if "Sub Group Order" = 2 then P9NHIF := Amount; //Nhif
                  if "Sub Group Order" = 3 then P9Paye := Amount; //paye
                  if "Sub Group Order" = 4 then P9Paye := P9Paye + Amount; //Paye Arrears
                end;
                8://Deductions
                begin
                  P9Deductions := P9Deductions + Amount;
                  //IF "Sub Group Order"=0 THEN p9Pension:=Amount;
                end;
                9: //NetPay
                begin
                  P9NetPay := Amount;
                end;
            end;
          end;
          until prPeriodTransactions.Next=0;
        end;
        //Update the P9 Details

        //IF P9NetPay <> 0 THEN
         fnUpdateP9Table (prEmployee."No.", P9BasicPay, P9Allowances, P9Benefits, P9ValueOfQuarters, P9DefinedContribution,
             P9OwnerOccupierInterest, P9GrossPay, P9TaxablePay, P9TaxCharged, P9InsuranceRelief, P9TaxRelief, P9Paye, P9NSSF,
             P9NHIF, P9Deductions, P9NetPay, dtCurPeriod,PayrollCode);

        until prEmployee.Next=0;
        end;
    end;


    procedure fnUpdateP9Table(P9EmployeeCode: Code[20];P9BasicPay: Decimal;P9Allowances: Decimal;P9Benefits: Decimal;P9ValueOfQuarters: Decimal;P9DefinedContribution: Decimal;P9OwnerOccupierInterest: Decimal;P9GrossPay: Decimal;P9TaxablePay: Decimal;P9TaxCharged: Decimal;P9InsuranceRelief: Decimal;P9TaxRelief: Decimal;P9Paye: Decimal;P9NSSF: Decimal;P9NHIF: Decimal;P9Deductions: Decimal;P9NetPay: Decimal;dtCurrPeriod: Date;prPayrollCode: Code[20])
    var
        prEmployeeP9Info: Record UnknownRecord61093;
        intYear: Integer;
        intMonth: Integer;
        PRLEmployeeP913thSlip: Record UnknownRecord99254;
        PRLPayrollPeriods: Page "PRL-Payroll Periods";
    begin
        // // intMonth := DATE2DMY(dtCurrPeriod,2);
        // // intYear := DATE2DMY(dtCurrPeriod,3);
        // // PRLEmployeeP913thSlip.RESET;
        // // PRLEmployeeP913thSlip.SETRANGE("Period Month",intMonth);
        // // PRLEmployeeP913thSlip.SETRANGE("Period Year",intYear);
        // // PRLEmployeeP913thSlip.SETRANGE("Employee Code",P9EmployeeCode);
        // // IF PRLEmployeeP913thSlip.FIND('-') THEN;
        // //
        // // prEmployeeP9Info.RESET;
        // // prEmployeeP9Info.SETRANGE(prEmployeeP9Info."Payroll Period",dtCurrPeriod);
        // // prEmployeeP9Info.SETRANGE(prEmployeeP9Info."Employee Code",P9EmployeeCode);
        // // prEmployeeP9Info.SETRANGE(prEmployeeP9Info."Period Month",intMonth);
        // // prEmployeeP9Info.SETRANGE(prEmployeeP9Info."Period Year",intYear);
        // // prEmployeeP9Info.SETRANGE(prEmployeeP9Info."Payroll Code",prPayrollCode);
        // // IF prEmployeeP9Info.FIND('-') THEN prEmployeeP9Info.DELETE;
        // // WITH prEmployeeP9Info DO BEGIN
        // //    INIT;
        // //  "Employee Code":= P9EmployeeCode;
        // //    "Basic Pay":= P9BasicPay+PRLEmployeeP913thSlip."Basic Pay";
        // //    Allowances:= P9Allowances+PRLEmployeeP913thSlip.Allowances;
        // //    Benefits:= P9Benefits+PRLEmployeeP913thSlip.Benefits;
        // //    "Value Of Quarters":= P9ValueOfQuarters+PRLEmployeeP913thSlip."Value Of Quarters";
        // //    "Defined Contribution":= P9DefinedContribution+PRLEmployeeP913thSlip."Defined Contribution";
        // //    "Owner Occupier Interest":= P9OwnerOccupierInterest+PRLEmployeeP913thSlip."Owner Occupier Interest";
        // //    "Gross Pay":= P9GrossPay+PRLEmployeeP913thSlip."Gross Pay";
        // //    "Taxable Pay":= P9TaxablePay+PRLEmployeeP913thSlip."Taxable Pay";
        // //    "Tax Charged":= P9TaxCharged+PRLEmployeeP913thSlip."Tax Charged";
        // //    "Insurance Relief":= P9InsuranceRelief+PRLEmployeeP913thSlip."Insurance Relief";
        // //    "Tax Relief":= P9TaxRelief+PRLEmployeeP913thSlip."Tax Relief";
        // //    Pension:=p9Pension;//+PRLEmployeeP913thSlip.Pension;//P9DefinedContribution+
        // //    "External Pension":=PRLEmployeeP913thSlip.Pension;
        // //    PAYE:= P9Paye+P9TaxRelief+PRLEmployeeP913thSlip.PAYE;
        // //    NSSF:= P9NSSF;
        // //    NHIF:= P9NHIF;
        // //    Deductions:= P9Deductions+PRLEmployeeP913thSlip.Deductions;
        // //    "Net Pay":= P9NetPay+PRLEmployeeP913thSlip."Net Pay";
        // //    "Period Month":= intMonth;
        // //    "Period Year":= intYear;
        // //    "Payroll Period":= dtCurrPeriod;
        // //    "Payroll Code":=prPayrollCode;
        // //    INSERT;
        // // END;
        intMonth := Date2dmy(dtCurrPeriod,2);
        intYear := Date2dmy(dtCurrPeriod,3);
        ////////////////////////////////////////////////////////////////
          PRLEmployeeP913thSlip.Reset;
          PRLEmployeeP913thSlip.SetRange("Period Month",intMonth);
          PRLEmployeeP913thSlip.SetRange("Period Year",intYear);
          PRLEmployeeP913thSlip.SetRange("Employee Code",P9EmployeeCode);
          if PRLEmployeeP913thSlip.Find('-') then;
        ////////////////////////////////////////////////////////////////
         prEmployeeP9Info.Reset;
         prEmployeeP9Info.SetRange(prEmployeeP9Info."Payroll Period",dtCurrPeriod);
         prEmployeeP9Info.SetRange(prEmployeeP9Info."Employee Code",P9EmployeeCode);
         prEmployeeP9Info.SetRange(prEmployeeP9Info."Period Month",intMonth);
         prEmployeeP9Info.SetRange(prEmployeeP9Info."Period Year",intYear);
         prEmployeeP9Info.SetRange(prEmployeeP9Info."Payroll Code",prPayrollCode);
        if prEmployeeP9Info.Find('-') then prEmployeeP9Info.Delete;
        with prEmployeeP9Info do begin
            Init;
            "Employee Code":= P9EmployeeCode;
            "Basic Pay":= P9BasicPay;
            Allowances:= P9Allowances+PRLEmployeeP913thSlip.Allowances;
            Benefits:= P9Benefits+PRLEmployeeP913thSlip.Benefits;
            "Value Of Quarters":= P9ValueOfQuarters;
            "Defined Contribution":= P9DefinedContribution+PRLEmployeeP913thSlip."Defined Contribution";
            "Owner Occupier Interest":= P9OwnerOccupierInterest;
            "Gross Pay":= P9GrossPay+PRLEmployeeP913thSlip."Gross Pay";
            "Taxable Pay":= P9TaxablePay+PRLEmployeeP913thSlip."Tax Charged";
            "Tax Charged":= P9TaxCharged+PRLEmployeeP913thSlip."Tax Charged";
            "Insurance Relief":= P9InsuranceRelief;
            "Tax Relief":= P9TaxRelief+PRLEmployeeP913thSlip."Tax Relief";
            "External Pension":=PRLEmployeeP913thSlip.Pension;
            PAYE:= P9Paye+PRLEmployeeP913thSlip.PAYE;
            NSSF:= P9NSSF;
            NHIF:= P9NHIF;
            Deductions:= P9Deductions+PRLEmployeeP913thSlip.Deductions;;
            "Net Pay":= P9NetPay+PRLEmployeeP913thSlip."Net Pay";
            "Period Month":= intMonth;
            "Period Year":= intYear;
            "Payroll Period":= dtCurrPeriod;
            "Payroll Code":=prPayrollCode;
            Insert;
        end;
    end;


    procedure fnDaysWorked(dtDate: Date;IsTermination: Boolean) DaysWorked: Integer
    var
        Day: Integer;
        SysDate: Record Date;
        Expr1: Text[30];
        FirstDay: Date;
        LastDate: Date;
        TodayDate: Date;
    begin
        TodayDate:=dtDate;

         Day:=Date2dmy(TodayDate,1);
         Expr1:=Format(-Day)+'D+1D';
         FirstDay:=CalcDate(Expr1,TodayDate);
         LastDate:=CalcDate('1M-1D',FirstDay);

         SysDate.Reset;
         SysDate.SetRange(SysDate."Period Type",SysDate."period type"::Date);
         if not IsTermination then
          SysDate.SetRange(SysDate."Period Start",dtDate,LastDate)
         else
          SysDate.SetRange(SysDate."Period Start",FirstDay,dtDate);
         // SysDate.SETFILTER(SysDate."Period No.",'1..5');
         if SysDate.Find('-') then
            DaysWorked:=SysDate.Count;
    end;


    procedure fnSalaryArrears(EmpCode: Text[30];TransCode: Text[30];CBasic: Decimal;StartDate: Date;EndDate: Date;dtOpenPeriod: Date;dtDOE: Date;dtTermination: Date)
    var
        FirstMonth: Boolean;
        startmonth: Integer;
        startYear: Integer;
        "prEmployee P9 Info": Record UnknownRecord61093;
        P9BasicPay: Decimal;
        P9taxablePay: Decimal;
        P9PAYE: Decimal;
        ProratedBasic: Decimal;
        SalaryArrears: Decimal;
        SalaryVariance: Decimal;
        SupposedTaxablePay: Decimal;
        SupposedTaxCharged: Decimal;
        SupposedPAYE: Decimal;
        PAYEVariance: Decimal;
        PAYEArrears: Decimal;
        PeriodMonth: Integer;
        PeriodYear: Integer;
        CountDaysofMonth: Integer;
        DaysWorked: Integer;
    begin
        fnInitialize;

        FirstMonth := true;
        if EndDate>StartDate then
         begin
          while StartDate < EndDate do
           begin
            //fnGetEmpP9Info
              startmonth:=Date2dmy(StartDate,2);
              startYear:=Date2dmy(StartDate,3);

              "prEmployee P9 Info".Reset;
              "prEmployee P9 Info".SetRange("prEmployee P9 Info"."Employee Code",EmpCode);
              "prEmployee P9 Info".SetRange("prEmployee P9 Info"."Period Month",startmonth);
              "prEmployee P9 Info".SetRange("prEmployee P9 Info"."Period Year",startYear);
              if "prEmployee P9 Info".Find('-') then
               begin
                P9BasicPay:="prEmployee P9 Info"."Basic Pay";
                P9taxablePay:="prEmployee P9 Info"."Taxable Pay";
                P9PAYE:="prEmployee P9 Info".PAYE;

                if P9BasicPay > 0 then   //Staff payment history is available
                 begin
                  if FirstMonth then
                   begin                 //This is the first month in the arrears loop
                    if Date2dmy(StartDate,1) <> 1 then //if the date doesn't start on 1st, we have to prorate the salary
                     begin
                    //ProratedBasic := ProratePay.fnProratePay(P9BasicPay, CBasic, StartDate); ********
                  //Get the Basic Salary (prorate basic pay if needed) //Termination Remaining
                  if (Date2dmy(dtDOE,2)=Date2dmy(StartDate,2)) and (Date2dmy(dtDOE,3)=Date2dmy(StartDate,3))then begin
                      CountDaysofMonth:=fnDaysInMonth(dtDOE);
                      DaysWorked:=fnDaysWorked(dtDOE,false);
                      ProratedBasic := fnBasicPayProrated(EmpCode, startmonth, startYear, P9BasicPay,DaysWorked,CountDaysofMonth)
                  end;

                  //Prorate Basic Pay on    {What if someone leaves within the same month they are employed}
                  if dtTermination<>0D then begin
                  if (Date2dmy(dtTermination,2)=Date2dmy(StartDate,2)) and (Date2dmy(dtTermination,3)=Date2dmy(StartDate,3))then begin
                      CountDaysofMonth:=fnDaysInMonth(dtTermination);
                      DaysWorked:=fnDaysWorked(dtTermination,true);
                      ProratedBasic := fnBasicPayProrated(EmpCode, startmonth, startYear, P9BasicPay,DaysWorked,CountDaysofMonth)
                  end;
                end;

                         SalaryArrears := (CBasic - ProratedBasic)
                     end
                   else
                     begin
                        SalaryArrears := (CBasic - P9BasicPay);
                     end;
                 end;
                 SalaryVariance := SalaryVariance + SalaryArrears;
                 SupposedTaxablePay := P9taxablePay + SalaryArrears;

                 //To calc paye arrears, check if the Supposed Taxable Pay is > the taxable pay for the loop period
                 if SupposedTaxablePay > P9taxablePay then
                  begin
                       SupposedTaxCharged := fnGetEmployeePaye(SupposedTaxablePay);
                       SupposedPAYE := SupposedTaxCharged - curReliefPersonal;
                       PAYEVariance := SupposedPAYE - P9PAYE;
                       PAYEArrears := PAYEArrears + PAYEVariance ;
                  end;
                 FirstMonth := false;               //reset the FirstMonth Boolean to False
               end;
             end;
              StartDate :=CalcDate('+1M',StartDate);
           end;
         if SalaryArrears <> 0 then
           begin
           PeriodYear:=Date2dmy(dtOpenPeriod,3);
           PeriodMonth:=Date2dmy(dtOpenPeriod,2);
            fnUpdateSalaryArrears(EmpCode,TransCode,StartDate,EndDate,SalaryArrears, PAYEArrears,PeriodMonth,PeriodYear,
            dtOpenPeriod);
           end

         end
        else
         Error('The start date must be earlier than the end date');
    end;


    procedure fnUpdateSalaryArrears(EmployeeCode: Text[50];TransCode: Text[50];OrigStartDate: Date;EndDate: Date;SalaryArrears: Decimal;PayeArrears: Decimal;intMonth: Integer;intYear: Integer;payperiod: Date)
    var
        FirstMonth: Boolean;
        ProratedBasic: Decimal;
        SalaryVariance: Decimal;
        PayeVariance: Decimal;
        SupposedTaxablePay: Decimal;
        SupposedTaxCharged: Decimal;
        SupposedPaye: Decimal;
        CurrentBasic: Decimal;
        StartDate: Date;
        "prSalary Arrears": Record UnknownRecord61088;
    begin
         "prSalary Arrears".Reset;
         "prSalary Arrears".SetRange("prSalary Arrears"."Employee Code",EmployeeCode);
         "prSalary Arrears".SetRange("prSalary Arrears"."Transaction Code",TransCode);
         "prSalary Arrears".SetRange("prSalary Arrears"."Period Month",intMonth);
         "prSalary Arrears".SetRange("prSalary Arrears"."Period Year",intYear);
         if "prSalary Arrears".Find('-')=false then
         begin
            "prSalary Arrears".Init;
            "prSalary Arrears"."Employee Code" := EmployeeCode;
            "prSalary Arrears"."Transaction Code" := TransCode;
            "prSalary Arrears"."Start Date" := OrigStartDate;
            "prSalary Arrears"."End Date" := EndDate;
            "prSalary Arrears"."Salary Arrears" := SalaryArrears;
            "prSalary Arrears"."PAYE Arrears" := PayeArrears;
            "prSalary Arrears"."Period Month" := intMonth;
            "prSalary Arrears"."Period Year" := intYear;
            "prSalary Arrears"."Payroll Period" := payperiod;
            "prSalary Arrears".Insert;
         end
    end;


    procedure fnCalcLoanInterest(strEmpCode: Code[20];strTransCode: Code[20];InterestRate: Decimal;RecoveryMethod: Option Reducing,"Straight line",Amortized;LoanAmount: Decimal;Balance: Decimal;CurrPeriod: Date;Welfare: Boolean) LnInterest: Decimal
    var
        curLoanInt: Decimal;
        intMonth: Integer;
        intYear: Integer;
    begin
        intMonth := Date2dmy(CurrPeriod,2);
        intYear := Date2dmy(CurrPeriod,3);

        curLoanInt := 0;



        if InterestRate > 0 then begin
            if RecoveryMethod = Recoverymethod::"Straight line" then //Straight Line Method [1]
                 curLoanInt := (InterestRate / 1200) * LoanAmount;

            if RecoveryMethod = Recoverymethod::Reducing then //Reducing Balance [0]

                 curLoanInt := (InterestRate / 1200) * Balance;

            if RecoveryMethod = Recoverymethod::Amortized then //Amortized [2]
                 curLoanInt := (InterestRate / 1200) * Balance;
        end else
            curLoanInt := 0;

        //Return the Amount
        LnInterest:=ROUND(curLoanInt);
    end;


    procedure fnUpdateEmployerDeductions(EmpCode: Code[20];TCode: Code[20];TGroup: Code[20];GroupOrder: Integer;SubGroupOrder: Integer;Description: Text[50];curAmount: Decimal;curBalance: Decimal;Month: Integer;Year: Integer;mMembership: Text[30];ReferenceNo: Text[30];dtOpenPeriod: Date)
    var
        prEmployerDeductions: Record UnknownRecord61094;
    begin

        if curAmount = 0 then exit;
        with prEmployerDeductions do begin
            Init;
            "Employee Code" := EmpCode;
            "Transaction Code" := TCode;
             Amount := curAmount;
            "Period Month" := Month;
            "Period Year" := Year;
            "Payroll Period" := dtOpenPeriod;
            Insert;
        end;
    end;


    procedure fnDisplayFrmlValues(EmpCode: Code[30];intMonth: Integer;intYear: Integer;Formula: Text[50]) curTransAmount: Decimal
    var
        pureformula: Text[50];
    begin
           pureformula := fnPureFormula(EmpCode, intMonth, intYear, Formula);
           curTransAmount := fnFormulaResult(pureformula); //Get the calculated amount
    end;


    procedure fnUpdateEmployeeTrans(EmpCode: Code[20];TransCode: Code[20];Amount: Decimal;Month: Integer;Year: Integer;PayrollPeriod: Date)
    var
        prEmployeeTrans: Record UnknownRecord61091;
    begin
          /* prEmployeeTrans.RESET;
           prEmployeeTrans.SETRANGE(prEmployeeTrans."Employee Code",EmpCode);
           prEmployeeTrans.SETRANGE(prEmployeeTrans."Transaction Code",TransCode);
           prEmployeeTrans.SETRANGE(prEmployeeTrans."Payroll Period",PayrollPeriod);
           prEmployeeTrans.SETRANGE(prEmployeeTrans."Period Month",Month);
           prEmployeeTrans.SETRANGE(prEmployeeTrans."Period Year",Year);
           IF prEmployeeTrans.FIND('-') THEN BEGIN
             prEmployeeTrans.Amount:=Amount;
             prEmployeeTrans.MODIFY;
           END; */

    end;


    procedure fnGetJournalDet(strEmpCode: Code[20])
    var
        SalaryCard: Record UnknownRecord61118;
    begin
        //Get Payroll Posting Accounts
        if SalaryCard.Get(strEmpCode) then begin
        if PostingGroup.Get(SalaryCard."Posting Group") then
         begin
           //Comment This for the Time Being

           PostingGroup.TestField("Salary Account");
           PostingGroup.TestField("Income Tax Account");
           PostingGroup.TestField("Net Salary Payable");
           PostingGroup.TestField("NSSF Employer Account");
           PostingGroup.TestField("Pension Employer Acc");

          TaxAccount:=PostingGroup."Income Tax Account";
          salariesAcc:=PostingGroup."Salary Account";
          PayablesAcc:=PostingGroup."Net Salary Payable";
          NSSFEMPyer:= PostingGroup."NSSF Employer Account";
          NSSFEMPyee:= PostingGroup."NSSF Employee Account";
          NHIFEMPyee:=PostingGroup."NHIF Employee Account";
          PensionEMPyer:=PostingGroup."Pension Employer Acc";
         end else begin
         Error('Please specify Posting Group in Employee No.  '+strEmpCode);
         end;
        end;
        //End Get Payroll Posting Accounts
    end;


    procedure fnGetSpecialTransAmount2(strEmpCode: Code[20];intMonth: Integer;intYear: Integer;intSpecTransID: Option Ignore,"Defined Contribution","Home Ownership Savings Plan","Life Insurance","Owner Occupier Interest","Prescribed Benefit","Salary Arrears","Staff Loan","Value of Quarters",Morgage,KUDHEIHA;blnCompDedc: Boolean)
    var
        prEmployeeTransactions: Record UnknownRecord61091;
        prTransactionCodes: Record UnknownRecord61082;
        strExtractedFrml: Text[250];
    begin
        SpecialTranAmount:=0;
        prTransactionCodes.Reset;
        prTransactionCodes.SetRange(prTransactionCodes."Special Transactions",intSpecTransID);
        if prTransactionCodes.Find('-') then begin
        repeat
           prEmployeeTransactions.Reset;
           prEmployeeTransactions.SetRange(prEmployeeTransactions."Employee Code",strEmpCode);
           prEmployeeTransactions.SetRange(prEmployeeTransactions."Transaction Code",prTransactionCodes."Transaction Code");
           prEmployeeTransactions.SetRange(prEmployeeTransactions."Period Month",intMonth);
           prEmployeeTransactions.SetRange(prEmployeeTransactions."Period Year",intYear);
           prEmployeeTransactions.SetRange(prEmployeeTransactions.Suspended,false);
         prEmployeeTransactions.SetCurrentkey(prEmployeeTransactions."Recovery Priority");
           if prEmployeeTransactions.Find('-') then begin
        
            //Ignore,Defined Contribution,Home Ownership Savings Plan,Life Insurance,
            //Owner Occupier Interest,Prescribed Benefit,Salary Arrears,Staff Loan,Value of Quarters
              case intSpecTransID of
                Intspectransid::"Defined Contribution":
                  if prTransactionCodes."Is Formula" then begin
                      strExtractedFrml := '';
                      strExtractedFrml := fnPureFormula(strEmpCode, intMonth, intYear, prTransactionCodes.Formula);
                      SpecialTranAmount := SpecialTranAmount+(fnFormulaResult(strExtractedFrml)); //Get the calculated amount
                  end else
                      SpecialTranAmount := SpecialTranAmount+prEmployeeTransactions.Amount;
        
                Intspectransid::"Life Insurance":
                    SpecialTranAmount :=SpecialTranAmount+( (curReliefInsurance / 100) * prEmployeeTransactions.Amount);
        
        //
                Intspectransid::"Owner Occupier Interest":
                      SpecialTranAmount := SpecialTranAmount+prEmployeeTransactions.Amount;
        
        
                Intspectransid::"Home Ownership Savings Plan":
                      SpecialTranAmount := SpecialTranAmount+prEmployeeTransactions.Amount;
        
                Intspectransid::Morgage:
                  begin
                    SpecialTranAmount :=SpecialTranAmount+ curReliefMorgage;
        
                    if SpecialTranAmount > curReliefMorgage then
                     begin
                      SpecialTranAmount:=curReliefMorgage
                     end;
        
                  end;
                //add ben
                  /* intSpecTransID::KUDHEIHA:
                  IF prTransactionCodes."Is Formula" THEN BEGIN
                      strExtractedFrml := '';
                      strExtractedFrml := fnPureFormula(strEmpCode, intMonth, intYear, prTransactionCodes.Formula);
                      SpecialTranAmount := SpecialTranAmount+(fnFormulaResult(strExtractedFrml)); //Get the calculated amount
                  END ELSE
                      IF SpecialTranAmount >500 THEN
                        SpecialTranAmount:=500;*/
        
              end;
           end;
         until prTransactionCodes.Next=0;
        end;

    end;


    procedure fnCheckPaysPension(pnEmpCode: Code[20];pnPayperiod: Date) PaysPens: Boolean
    var
        pnTranCode: Record UnknownRecord61082;
        pnEmpTrans: Record UnknownRecord61091;
    begin
             PaysPens:=false;
             pnEmpTrans.Reset;
             pnEmpTrans.SetRange(pnEmpTrans."Employee Code",pnEmpCode);
             pnEmpTrans.SetRange(pnEmpTrans."Payroll Period",pnPayperiod);
              if pnEmpTrans.Find('-') then begin
              repeat
              if pnTranCode.Get(pnEmpTrans."Transaction Code") then
              if pnTranCode."coop parameters"=pnTranCode."coop parameters"::Pension then
              PaysPens:=true;
              until pnEmpTrans.Next=0;
              end;
    end;


    procedure fnGetPensionAmount(strEmpCode: Code[20];intMonth: Integer;intYear: Integer;intSpecTransID: Option Ignore,"Defined Contribution","Home Ownership Savings Plan","Life Insurance","Owner Occupier Interest","Prescribed Benefit","Salary Arrears","Staff Loan","Value of Quarters",Morgage,Gratuity,"Insurance Relief";blnCompDedc: Boolean) SpecialTransAmount: Decimal
    var
        prEmployeeTransactions: Record UnknownRecord61091;
        prTransactionCodes: Record UnknownRecord61082;
        strExtractedFrml: Text[250];
    begin
        SpecialTransAmount:=0;
        prTransactionCodes.Reset;
        prTransactionCodes.SetRange(prTransactionCodes."Special Transactions",intSpecTransID);
        prTransactionCodes.SetRange(prTransactionCodes.Pension,true);
        if prTransactionCodes.Find('-') then begin
        repeat
           prEmployeeTransactions.Reset;
           prEmployeeTransactions.SetRange(prEmployeeTransactions."Employee Code",strEmpCode);
           prEmployeeTransactions.SetRange(prEmployeeTransactions."Transaction Code",prTransactionCodes."Transaction Code");
           prEmployeeTransactions.SetRange(prEmployeeTransactions."Period Month",intMonth);
           prEmployeeTransactions.SetRange(prEmployeeTransactions."Period Year",intYear);
           prEmployeeTransactions.SetRange(prEmployeeTransactions.Suspended,false);
         prEmployeeTransactions.SetCurrentkey(prEmployeeTransactions."Recovery Priority");
           if prEmployeeTransactions.Find('-') then begin

            //Ignore,Defined Contribution,Home Ownership Savings Plan,Life Insurance,
            //Owner Occupier Interest,Prescribed Benefit,Salary Arrears,Staff Loan,Value of Quarters
              case intSpecTransID of
                Intspectransid::"Defined Contribution":
                if (prTransactionCodes.Pension) then begin
                  if prTransactionCodes."Is Formula" then begin
                      strExtractedFrml := '';
                      strExtractedFrml := fnPureFormula(strEmpCode, intMonth, intYear, prTransactionCodes.Formula);
                      SpecialTransAmount := SpecialTransAmount+(fnFormulaResult(strExtractedFrml)); //Get the calculated amount
                  end else
                      SpecialTransAmount := SpecialTransAmount+prEmployeeTransactions.Amount;
               end;
           end;
           end;
         until prTransactionCodes.Next=0;
        end;
        SpecialTranAmount:=SpecialTransAmount;
    end;


    procedure disabled_emp(var empNo: Code[20];var Gross: Decimal) Dis_A: Boolean
    var
        hrEmp: Record UnknownRecord61118;
    begin
          if hrEmp.Get(empNo) then
          Dis_A:=hrEmp."Physical Disability";
          if Dis_A=true then begin
          if (Gross<=150000) then
            Dis_A:=false;
          end;
    end;

    local procedure fnGetEmployeeNSSFTierI(curBaseAmount: Decimal) NSSF: Decimal
    var
        prNSSF: Record UnknownRecord70074;
        nssfAmount: Decimal;
        NssT1: Decimal;
    begin
        prNSSF.Reset;
                prNSSF.SetCurrentkey(prNSSF."Tier Code");
                if prNSSF.FindFirst then begin
                    repeat
                        if ((curBaseAmount >= prNSSF."Lower Limit") and (curBaseAmount <= prNSSF."Upper limit")) then
                            if prNSSF."Amount Type" = prNSSF."amount type"::"Amount As Percentage" then begin
                                if prNSSF.Amount <> 0 then
                                    nssfAmount := ROUND((prNSSF.Amount / 100) * curBaseAmount, 1);
                                if nssfAmount <= prNSSF."Tier I Limit" then
                                    NSSF := nssfAmount
                                else
                                    NSSF := prNSSF."Tier I Limit"
                            end
                            else begin
                                NSSF := prNSSF."Tier I Limit";
                            end;

                    until prNSSF.Next = 0;
                end;
    end;

    local procedure fnGetEmployeeNSSFTierII(curBaseAmount: Decimal) NSSF: Decimal
    var
        prNSSF: Record UnknownRecord70074;
        nssfAmount: Decimal;
        NssT1: Decimal;
    begin
         prNSSF.Reset;
                prNSSF.SetCurrentkey(prNSSF."Tier Code");
                if prNSSF.FindFirst then begin
                    repeat
                        if ((curBaseAmount >= prNSSF."Lower Limit") and (curBaseAmount <= prNSSF."Upper limit")) then
                            if prNSSF."Amount Type" = prNSSF."amount type"::"Amount As Percentage" then begin
                                if prNSSF.Amount <> 0 then
                                    nssfAmount := ROUND((prNSSF.Amount / 100) * curBaseAmount, 1);
                                if nssfAmount > prNSSF."Tier I Limit" then
                                    NSSF := nssfAmount - prNSSF."Tier I Limit"
                                else
                                    NSSF := 0
                            end
                            else begin
                                NSSF := prNSSF.Amount - prNSSF."Tier I Limit";
                            end;
                    until prNSSF.Next = 0;
                end;
    end;
}

