#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 99200 "prPayrollProcessing 13thSlip"
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
        PRLSalaryCard: Record UnknownRecord61105;
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
        curDisabledLimit: Decimal;
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
        HREmp2: Record UnknownRecord61118;
        curNssf_Base_Amount: Decimal;
        intNSSF_BasedOn: Option Gross,Basic;
        curNSSF_Tier: Text;
        PRPeriod: Record UnknownRecord99252;
        TotalSTATUTORIES: Decimal;
        BenifitAmount: Decimal;
        PRTransCode_2: Record UnknownRecord61082;
        PREmpTrans_2: Record UnknownRecord99251;
        PRPeriodTrans: Record UnknownRecord99252;
        MonthlyExpectedWorkHrs: Decimal;
        HoursWorked: Decimal;
        ExpectedWorkHrs: Decimal;
        TaxCharged_1: Decimal;
        SpecialTranAmount: Decimal;
        PrlPeriods: Record UnknownRecord99250;
        PRLEmployeeDaysWorked: Record UnknownRecord99200;
        CurSpecialTaxTotal: Decimal;


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
                curDisabledLimit:=VitalSetup."Disabled Tax Limit";
                MonthlyExpectedWorkHrs:=0;//VitalSetup."Monthly Expected Work Hrs"


        end;
    end;


    procedure fnProcesspayroll(strEmpCode: Code[20];dtDOE: Date;curBasicPay: Decimal;blnPaysPaye: Boolean;blnPaysNssf: Boolean;blnPaysNhif: Boolean;SelectedPeriod: Date;dtOpenPeriod: Date;Membership: Text[30];ReferenceNo: Text[30];dtTermination: Date;blnGetsPAYERelief: Boolean;Dept: Code[20];PayrollCode: Code[20];blnInsuranceCertificate: Boolean;CurrInstalment: Integer)
    var
        TotalCBATaxAmount: Decimal;
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
        prPeriodTransactions: Record UnknownRecord99252;
        intYear: Integer;
        intMonth: Integer;
        LeapYear: Boolean;
        CountDaysofMonth: Integer;
        DaysWorked: Integer;
        prSalaryArrears: Record UnknownRecord61088;
        prEmployeeTransactions: Record UnknownRecord99251;
        prTransactionCodes: Record UnknownRecord61082;
        strExtractedFrml: Text[250];
        SpecialTransType: Option Ignore,"Defined Contribution","Home Ownership Savings Plan","Life Insurance","Owner Occupier Interest","Prescribed Benefit","Salary Arrears","Staff Loan","Value of Quarters",Morgage;
        TransactionType: Option Income,Deduction;
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
        prEmployerDeductions: Record UnknownRecord99253;
        JournalPostingType: Option " ","G/L Account",Customer,Vendor;
        JournalAcc: Code[20];
        Customer: Record Customer;
        JournalPostAs: Option " ",Debit,Credit;
        IsCashBenefit: Decimal;
        PRLSalaryCard: Record UnknownRecord61105;
        _CBA30Amount: Decimal;
        _CBA30OldTax: Decimal;
        _CBAPension: Decimal;
        _CBA30NewTax: Decimal;
        _CBADiff: Decimal;
        _CBABenevollent: Decimal;
    begin
        //Initialize
        PRLSalaryCard.Reset;
        PRLSalaryCard.SetRange("Employee Code",strEmpCode);
        PRLSalaryCard.SetRange("Payroll Period",SelectedPeriod);
        if PRLSalaryCard.Find('-') then begin
          if PRLSalaryCard."Pays PAYE" then blnPaysPaye:=true;
          end;
        CurSpecialTaxTotal:=0;
        //IF curBasicPay=0 THEN EXIT;
        PrlPeriods.Reset;
        PrlPeriods.SetRange("Date Openned",SelectedPeriod);
        PrlPeriods.SetRange("Current Instalment",CurrInstalment);
        if PrlPeriods.Find('-') then begin
          end;
        
        if PrlPeriods."Current Instalment"<>2 then begin
            blnPaysPaye:=false;
            blnPaysNssf:=false;
            blnPaysNhif:=false;
          end else if PrlPeriods."Current Instalment"=2 then begin
            blnPaysPaye:=true;
            blnPaysNssf:=true;
            blnPaysNhif:=true;
            end;
        
        if dtDOE=0D then dtDOE:=CalcDate('1M',Today);
        fnInitialize;
        fnGetJournalDet(strEmpCode);
        
        //PayrollType
        PayrollType:=PayrollCode;
        
        //check if the period selected=current period. If not, do NOT run this function
        if SelectedPeriod <> dtOpenPeriod then exit;
        intMonth:=Date2dmy(SelectedPeriod,2);intYear:=Date2dmy(SelectedPeriod,3);
        
        if curBasicPay =0 then begin
        //Biometrics
        PRLEmployeeDaysWorked.Reset;
        PRLEmployeeDaysWorked.SetRange("Employee Code",strEmpCode);
        PRLEmployeeDaysWorked.SetRange("Payroll Period",SelectedPeriod);
        PRLEmployeeDaysWorked.SetRange("Current Instalment",CurrInstalment);
        if PRLEmployeeDaysWorked.Find('-') then begin
        
        //Calculate Basic Pay based on hrs worked for specific employees
         HREmp2.Reset;
         HREmp2.SetRange(HREmp2."No.",strEmpCode);
        // HREmp2.SETRANGE(HREmp2."Date Filter",CALCDATE('-cm',SelectedPeriod),CALCDATE('cm',SelectedPeriod));
        if HREmp2.Find('-') then
         begin
           end;
          // HREmp2.CALCFIELDS(HREmp2."Total Hours Worked") ;
         //    IF (HREmp2."Based On Hours worked"=HREmp2."Based On Hours worked"::BasedOnWorkedHrs) THEN
         //    BEGIN
         //      ExpectedWorkHrs:=MonthlyExpectedWorkHrs;
         //      HoursWorked:=HREmp2."Total Days Worked";
              //MESSAGE(FORMAT(HoursWorked))  ;
              if PRLEmployeeDaysWorked."Daily Rate"<>0 then
               curBasicPay:=PRLEmployeeDaysWorked."Daily Rate"*PRLEmployeeDaysWorked."Days Worked"
              else curBasicPay:=HREmp2."Daily Rate"*PRLEmployeeDaysWorked."Days Worked";
               //fnCalculatedBasicPay(strEmpCode, intMonth, intYear, curBasicPay,HoursWorked,ExpectedWorkHrs) ;
              end;
              end;// Compute Basic Pay from Attendance
        
          //Calculate Basic Pay based on hrs worked for specific employees
        //Biometrics
        
         curTransAmount := curBasicPay;
                strTransDescription := 'Daily Wage';
                TGroup := 'DAILY WAGE';
         TGroupOrder := 1; TSubGroupOrder := 1;
         fnUpdatePeriodTrans(strEmpCode, 'BPAY', TGroup, TGroupOrder,
         TSubGroupOrder, strTransDescription, curTransAmount, 0, intMonth, intYear,Membership,ReferenceNo,SelectedPeriod,Dept,
         salariesAcc,Journalpostas::Debit,Journalpostingtype::"G/L Account",'',Coopparameters::none,CurrInstalment);
         /*
         //Salary Arrears
         prSalaryArrears.RESET;
         prSalaryArrears.SETRANGE(prSalaryArrears."Employee Code",strEmpCode);
         prSalaryArrears.SETRANGE(prSalaryArrears."Period Month",intMonth);
         prSalaryArrears.SETRANGE(prSalaryArrears."Period Year",intYear);
         IF prSalaryArrears.FIND('-') THEN BEGIN
         REPEAT
              curSalaryArrears := prSalaryArrears."Salary Arrears";
              curPayeArrears := prSalaryArrears."PAYE Arrears";
        
              //Insert [Salary Arrears] into period trans [ARREARS]
              curTransAmount := curSalaryArrears;
              strTransDescription := 'Salary Arrears';
              TGroup := 'ARREARS'; TGroupOrder := 1; TSubGroupOrder := 2;
              fnUpdatePeriodTrans(strEmpCode, prSalaryArrears."Transaction Code", TGroup, TGroupOrder, TSubGroupOrder,
                strTransDescription, curTransAmount, 0, intMonth, intYear,Membership,ReferenceNo,SelectedPeriod,Dept,salariesAcc,
                JournalPostAs::Debit,JournalPostingType::"G/L Account",'',CoopParameters::none);
        
              //Insert [PAYE Arrears] into period trans [PYAR]
              curTransAmount:= curPayeArrears;
              strTransDescription := 'P.A.Y.E Arrears';
              TGroup := 'STATUTORIES'; TGroupOrder := 7; TSubGroupOrder := 4;
              fnUpdatePeriodTrans(strEmpCode, 'PYAR', TGroup, TGroupOrder, TSubGroupOrder,
                 strTransDescription, curTransAmount, 0, intMonth, intYear,Membership,ReferenceNo,SelectedPeriod,Dept,
                 TaxAccount,JournalPostAs::Debit,JournalPostingType::"G/L Account",'',CoopParameters::none)
        
         UNTIL prSalaryArrears.NEXT=0;
         END;
         */
         //Get Earnings
         prEmployeeTransactions.Reset;
         prEmployeeTransactions.SetRange("Employee Code",strEmpCode);
         prEmployeeTransactions.SetRange("Period Month",intMonth);
         prEmployeeTransactions.SetRange("Period Year",intYear);
         prEmployeeTransactions.SetRange("Current Instalment",PrlPeriods."Current Instalment");
         if prEmployeeTransactions.Find('-') then begin
           curTotAllowances:= 0;
           IsCashBenefit:=0;
           repeat
             prTransactionCodes.Reset;
             prTransactionCodes.SetRange(prTransactionCodes."Transaction Code",prEmployeeTransactions."Transaction Code");
             prTransactionCodes.SetRange(prTransactionCodes."Transaction Type",prTransactionCodes."transaction type"::Income);
             prTransactionCodes.SetRange(prTransactionCodes."Special Transactions",prTransactionCodes."special transactions"::Ignore);
             if prTransactionCodes.Find('-') then begin
               curTransAmount:=0; curTransBalance := 0; strTransDescription := ''; strExtractedFrml := '';
               if prTransactionCodes."Is Formula" then begin
                   strExtractedFrml := fnPureFormula(strEmpCode, intMonth, intYear, prTransactionCodes.Formula,CurrInstalment);
                   curTransAmount := ROUND(fnFormulaResult(strExtractedFrml)); //Get the calculated amount
        
               end else begin
                   curTransAmount := prEmployeeTransactions.Amount;
               end;
        
              if prTransactionCodes."Balance Type"=prTransactionCodes."balance type"::None then //[0=None, 1=Increasing, 2=Reducing]
                        curTransBalance := 0;
              if prTransactionCodes."Balance Type"=prTransactionCodes."balance type"::Increasing then
                        curTransBalance := prEmployeeTransactions.Balance+ curTransAmount;
              if prTransactionCodes."Balance Type"= prTransactionCodes."balance type"::Reducing then
                        curTransBalance := prEmployeeTransactions.Balance - curTransAmount;
        
        
                 //Add Non Taxable Here
                 if (not prTransactionCodes.Taxable) and (prTransactionCodes."Special Transactions" =
                 prTransactionCodes."special transactions"::Ignore) then
                     curNonTaxable:=curNonTaxable+curTransAmount;
        
                 //Added to ensure special transaction that are not taxable are not inlcuded in list of Allowances
                 if (not prTransactionCodes.Taxable) and (prTransactionCodes."Special Transactions" <>
                 prTransactionCodes."special transactions"::Ignore) then
                    curTransAmount:=0;
        
                 curTotAllowances := curTotAllowances + curTransAmount; //Sum-up all the allowances
                 curTransAmount := curTransAmount;
                 curTransBalance := curTransBalance;
                 strTransDescription := prTransactionCodes."Transaction Name";
                TGroup := 'EARNINGS'; TGroupOrder := 3; TSubGroupOrder := 0;
        
                 //Get the posting Details
                 JournalPostingType:=Journalpostingtype::" ";JournalAcc:='';
                 if prTransactionCodes.Subledger<>prTransactionCodes.Subledger::" " then begin
                    if prTransactionCodes.Subledger=prTransactionCodes.Subledger::Customer then begin
                        HrEmployee.Get(strEmpCode);
        
                         Customer.Reset;
                        Customer.SetRange(Customer."No.",HrEmployee."No.");
                        if Customer.Find('-') then begin
                           JournalAcc:=Customer."No.";
                           JournalPostingType:=Journalpostingtype::Customer;
                        end;
                    end;
                 end else begin
                    JournalAcc:=prTransactionCodes."GL Account";
                    JournalPostingType:=Journalpostingtype::"G/L Account";
                 end;
        
                  //Get is Cash Benefits
                  if prTransactionCodes."Is Cash" then
                       IsCashBenefit:=IsCashBenefit+curTransAmount;
                 //End posting Details
                 Clear(TotalCBATaxAmount);
                 fnUpdatePeriodTrans(strEmpCode,prTransactionCodes."Transaction Code", TGroup, TGroupOrder, TSubGroupOrder,
                 strTransDescription, curTransAmount, curTransBalance, intMonth, intYear,prEmployeeTransactions.Membership,
                 prEmployeeTransactions."Reference No",SelectedPeriod,Dept,JournalAcc,Journalpostas::Debit,JournalPostingType,'',
                 prTransactionCodes."coop parameters",CurrInstalment);
                 // Insert Tax element if the Transaction is a special Tax Transaction
                 if ((prTransactionCodes."Has Special Tax") and (prTransactionCodes."Special Tax Value (%)">0)) then begin
                 Clear(curTransAmount);
                          curTransAmount :=prEmployeeTransactions.Amount*((prTransactionCodes."Special Tax Value (%)")/100);
                          CurSpecialTaxTotal:=CurSpecialTaxTotal+curTransAmount;
             strTransDescription := prTransactionCodes."Transaction Name";
             TGroup := 'TAXATION'; TGroupOrder := 6; TSubGroupOrder := 1;
             fnUpdatePeriodTrans (strEmpCode, prTransactionCodes."Transaction Code"+'-Tax('+Format(prTransactionCodes."Prorate Payment")+'%', TGroup, TGroupOrder, TSubGroupOrder,
             strTransDescription+'TAX',
             curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,'',Journalpostas::" ",Journalpostingtype::" ",'',
             Coopparameters::none,CurrInstalment)
             end;
        
             end;
           until prEmployeeTransactions.Next=0;
         end;
        
         //Calc GrossPay = (BasicSalary + Allowances + SalaryArrears) [Group Order = 4]
         curGrossPay := (curBasicPay + curTotAllowances + curSalaryArrears);
         curTransAmount := curGrossPay;
         strTransDescription := 'Gross Pay';     //CHANGE GROSS PAY TO BLANK -HOSEA
         TGroup := 'Gross Pay'; TGroupOrder := 4; TSubGroupOrder := 0;  //COMMENTED TO REMOVE GROUP HEADING-HOSEA
         fnUpdatePeriodTrans (strEmpCode, 'GPAY', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription, curTransAmount, 0, intMonth,
          intYear,'','',SelectedPeriod,Dept,'',Journalpostas::" ",Journalpostingtype::" ",'',Coopparameters::none,CurrInstalment);
        
        
        //Get the N.S.S.F amount for the month GBT
         curNssf_Base_Amount :=0;
         if intNSSF_BasedOn =Intnssf_basedon::Gross then //>NSSF calculation can be based on:
                 curNssf_Base_Amount := curGrossPay;
         if intNSSF_BasedOn = Intnssf_basedon::Basic then
                curNssf_Base_Amount := curBasicPay;
        
         //Get the NSSF amount
         if blnPaysNssf then begin
          curNSSF:=fnGetEmployerNSSF(curNssf_Base_Amount);
          curNSSF_Tier:=fnGetEmployeeNSSF_Tier(curNssf_Base_Amount); //Added to Display NSSF TIER
            curTransAmount := curNSSF;
            strTransDescription := 'N.S.S.F';
         TGroup := 'STATUTORIES'; TGroupOrder := 7; TSubGroupOrder := 1;
         fnUpdatePeriodTrans (strEmpCode, 'NSSF', TGroup, TGroupOrder, TSubGroupOrder,
         strTransDescription, curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,NSSFEMPyee,
         Journalpostas::Credit,Journalpostingtype::"G/L Account",'',Coopparameters::NSSF,CurrInstalment);
        
        //Update Employer deductions
         if blnPaysNssf then
          curNSSF:=fnGetEmployerNSSF(curNssf_Base_Amount);
          curTransAmount := curNSSF;
          fnUpdateEmployerDeductions(strEmpCode, 'NSSF',
           'EMP', TGroupOrder, TSubGroupOrder,'', curTransAmount, 0, intMonth, intYear,
            prEmployeeTransactions.Membership, prEmployeeTransactions."Reference No",SelectedPeriod,CurrInstalment);
        
        
        //Get the Defined contribution to post based on the Max Def contrb allowed   ****************All Defined Contributions not included
         curDefinedContrib := curNSSF; //(curNSSF + curPensionStaff + curNonTaxable) - curMorgageReliefAmount
         curTransAmount := curDefinedContrib;
         strTransDescription := 'NSSF';  //change Defined contributions to NSSF-hosea
         TGroup := 'TAXATION'; TGroupOrder:= 6; TSubGroupOrder:= 1;   //CHANGE tax calculations TO APYE INFORMATION-HOSEA // change TGroupOrder :=6 to 7
         fnUpdatePeriodTrans(strEmpCode, 'DEFCON', TGroup, TGroupOrder, TSubGroupOrder,
          strTransDescription, curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,'',Journalpostas::" ",
          Journalpostingtype::" ",'',Coopparameters::none,CurrInstalment);
        
        end;
        
        
        if blnPaysPaye then begin
         //Get the Gross taxable amount
         //>GrossTaxable = Gross + Benefits + nValueofQuarters  ******Confirm CurValueofQuaters
         curGrossTaxable := curGrossPay + curBenefits + curValueOfQuarters;
        
         //>If GrossTaxable = 0 Then TheDefinedToPost = 0
         if curGrossTaxable = 0 then curDefinedContrib := 0;
        
         //Personal Relief
        // if get relief is ticked
        if( blnGetsPAYERelief)then
        begin
         curReliefPersonal := curReliefPersonal + curUnusedRelief; //*****Get curUnusedRelief
         curTransAmount := curReliefPersonal;
         strTransDescription := 'Personal Relief';
         TGroup := 'TAXATION'; TGroupOrder :=6; TSubGroupOrder := 9;//change tax calculations to PAYE INFORMATION -HOSEA // change TGroupOrder :=6 to 7
         fnUpdatePeriodTrans (strEmpCode, 'PSNR', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
          curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,'',Journalpostas::" ",Journalpostingtype::" ",'',
          Coopparameters::none,CurrInstalment);
        end
        else
         curReliefPersonal := 0;
        
        //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
         //>Pension Contribution [self] relief
         PRLSalaryCard.Reset;
         PRLSalaryCard.SetRange("Employee Code",strEmpCode);
         PRLSalaryCard.SetRange("Payroll Period",SelectedPeriod);
         if PRLSalaryCard.Find('-') then if PRLSalaryCard."Pays Pension" then
         curPensionStaff :=(0.03*curBasicPay); //fnGetSpecialTransAmount(strEmpCode, intMonth, intYear,
         //SpecialTransType::"Defined Contribution",FALSE) ;//Self contrib Pension is 1 on [Special Transaction]
         if curPensionStaff > 0 then begin
             if curPensionStaff > curMaxPensionContrib then
                 curTransAmount :=curMaxPensionContrib
             else
                 curTransAmount :=curPensionStaff;
             strTransDescription := 'Pension Relief';
             TGroup := 'TAXATION'; TGroupOrder := 6; TSubGroupOrder := 1; //CHANGE TAX CALCULATIONS TO PAYE INFORMATION -HOSEA
             fnUpdatePeriodTrans (strEmpCode, 'PNSR', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
             curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,'',Journalpostas::" ",Journalpostingtype::" ",'',
             Coopparameters::none,CurrInstalment)
         end;
        
        
        
        
        //if he PAYS paye only*******************I
        if blnPaysPaye and blnGetsPAYERelief then
        begin
          //Get Insurance Relief
         //999999 curInsuranceReliefAmount := fnGetSpecialTransAmount(strEmpCode, intMonth, intYear,
         //9999 SpecialTransType::"Life Insurance",FALSE,CurrInstalment); //Insurance is 3 on [Special Transaction]
        
          //********************************************************************************************************************************************************
          //Added DW - for employees who have brought the Insurance certificate, they are entitled to Insurance relief, Otherwise NO
          //Place a check mark on the Salary Card to YES
          if (curInsuranceReliefAmount > 0) and (blnInsuranceCertificate)then begin
              //Added Hosea - To Cap Insurance Relief to Setup amount
              if curInsuranceReliefAmount > curMaximumRelief then curInsuranceReliefAmount:=curMaximumRelief;
               //Added Hosea - To Cap Insurance Relief to Setup amount
              curTransAmount := ROUND(curInsuranceReliefAmount,1,'<'); //Added DW to round off to nearest shilling
              strTransDescription := 'Insurance Relief';
              TGroup := 'TAXATION'; TGroupOrder := 6; TSubGroupOrder := 8;   //CHANGE tax calculations TO PAYE INFORMATION -HOSEA // change TGroupOrder :=6 to 7
              fnUpdatePeriodTrans (strEmpCode, 'INSR', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
              curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,
              '',Journalpostas::Credit,Journalpostingtype::" ",'',Coopparameters::none,CurrInstalment);
         end;
           //********************************************************************************************************************************************************
        
         //>OOI
          curOOI := fnGetSpecialTransAmount(strEmpCode, intMonth, intYear,
          Specialtranstype::"Owner Occupier Interest",false,CurrInstalment); //Morgage is LAST on [Special Transaction]
          if curOOI > 0 then begin
            if curOOI<=curOOIMaxMonthlyContrb then
              curTransAmount := curOOI
            else
              curTransAmount:=curOOIMaxMonthlyContrb;
        
              strTransDescription := 'Owner Occupier Interest';
              TGroup := 'TAXATION'; TGroupOrder := 6; TSubGroupOrder := 2;   //CHANGE tax calculations TO PAYE INFORMATION -HOSEA  // change TGroupOrder :=6 to 7
              fnUpdatePeriodTrans (strEmpCode, 'OOI', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
              curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,'',Journalpostas::" ",Journalpostingtype::" ",'',
              Coopparameters::none,CurrInstalment);
          end;
        
        //HOSP
          curHOSP := fnGetSpecialTransAmount(strEmpCode, intMonth, intYear,
          Specialtranstype::"Home Ownership Savings Plan",false,CurrInstalment); //Home Ownership Savings Plan
          if curHOSP > 0 then begin
            if curHOSP<=curReliefMorgage then
              curTransAmount := curHOSP
            else
              curTransAmount:=curReliefMorgage;
        
              strTransDescription := 'Home Ownership Savings Plan';
              TGroup := 'TAXATION'; TGroupOrder := 6; TSubGroupOrder := 2;  //CHANGE tax calculations TO PAYE INFORMATION-HOSEA// change TGroupOrder :=6 to 7
              fnUpdatePeriodTrans (strEmpCode, 'HOSP', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
              curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,'',Journalpostas::" ",Journalpostingtype::" ",'',
              Coopparameters::none,CurrInstalment);
          end;
        
        
        //Mortage Relief
           curReliefMorgage := fnGetSpecialTransAmount(strEmpCode, intMonth, intYear,
          Specialtranstype::Morgage,false,CurrInstalment);
          if  curReliefMorgage > 0 then begin
              curTransAmount:= curReliefMorgage;
             strTransDescription := 'Mortgage Relief';
             TGroup := 'TAXATION'; TGroupOrder := 6; TSubGroupOrder :=3;
             fnUpdatePeriodTrans (strEmpCode, 'MORG-RL', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
             curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,
             '',Journalpostas::Credit,Journalpostingtype::" ",'',Coopparameters::none,CurrInstalment)
        
          end;
        
        
        
        
        
        
        //Enter NonTaxable Amount
        if curNonTaxable>0 then begin
              strTransDescription := 'Other Non-Taxable Benefits';
              TGroup := 'TAXATION'; TGroupOrder := 6; TSubGroupOrder := 5;   //CHANGE tax calculations TO PAYE INFORMATION-HOSEA // change TGroupOrder :=6 to 7
              fnUpdatePeriodTrans (strEmpCode, 'NONTAX', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
              curNonTaxable, 0, intMonth, intYear,'','',SelectedPeriod,Dept,'',Journalpostas::" ",Journalpostingtype::" ",'',
              Coopparameters::none,CurrInstalment);
        end;
        
        end;
        
        //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        
         //Get the Taxable amount for calculation of PAYE
         //>prTaxablePay = (GrossTaxable - SalaryArrears) - (TheDefinedToPost + curSelfPensionContrb + MorgageRelief)
        
        BenifitAmount:=0;
        PRTransCode_2.Reset;
        PRTransCode_2.SetRange(PRTransCode_2."Transaction Type",PRTransCode_2."transaction type"::"2");
        if PRTransCode_2.Find('-') then
        begin
        PREmpTrans_2.Reset;
        PREmpTrans_2.SetRange(PREmpTrans_2."Transaction Code",PRTransCode_2."Transaction Code");
        PREmpTrans_2.SetRange(PREmpTrans_2."Employee Code",strEmpCode);
        PREmpTrans_2.SetRange(PREmpTrans_2."Payroll Period",SelectedPeriod);
        if PREmpTrans_2.Find('-') then
        begin
        if PRTransCode_2.Taxable then BenifitAmount:=PREmpTrans_2.Amount;
        //Insert in to PR Period Trans
        strTransDescription := PRTransCode_2."Transaction Name";
        curTransAmount:=PREmpTrans_2.Amount;
        TGroup := 'TAXATION'; TGroupOrder:= 6; TSubGroupOrder:= 1;  //CHANGE tax calculations TO PAYE INFORMATION-HOSEA
        fnUpdatePeriodTrans(strEmpCode, PRTransCode_2."Transaction Code", TGroup, TGroupOrder, TSubGroupOrder,
        strTransDescription, curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,
        '',Journalpostas::Credit,Journalpostingtype::" ",'',Coopparameters::none,CurrInstalment);
        
        end;
        end;
        
        
         if (curPensionStaff+curDefinedContrib) > curMaxPensionContrib then
           curTaxablePay:= curGrossTaxable - (curSalaryArrears + curMaxPensionContrib+curOOI+curHOSP+curNonTaxable)+BenifitAmount
         else
             curTaxablePay:= curGrossTaxable - (curSalaryArrears + curDefinedContrib +curPensionStaff+curOOI+curHOSP+curNonTaxable)+BenifitAmount;
         curTransAmount := curTaxablePay;
         strTransDescription := 'Chargeable Pay';
         TGroup := 'TAXATION'; TGroupOrder := 6; TSubGroupOrder := 6;  //CHANGE tax calculations TO PAYE INFORMATION-HOSEA // change TGroupOrder :=6 to 7
         fnUpdatePeriodTrans (strEmpCode, 'TXBP', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
          curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,'',Journalpostas::" ",Journalpostingtype::" ",'',
          Coopparameters::none,CurrInstalment);
        
         //Get the Tax charged for the month
         // Special tax for disabled employees
         //Check if employee is disabled
        
        
         HREmp2.Reset;
         if HREmp2.Get(strEmpCode) then
         begin
            if HREmp2.Disabled = HREmp2.Disabled::Yes then
            begin
                if curTaxablePay >= curDisabledLimit then
                begin
        
                    //If taxable pay is greater than limit
                    curTaxCharged := fnGetEmployeePaye(curTaxablePay - curDisabledLimit);
                    curTransAmount := curTaxCharged;
                    strTransDescription := 'Tax Charged';
                    TGroup := 'TAXATION'; TGroupOrder := 6; TSubGroupOrder := 7; //CHANGE tax calculations TO PAYE INFORMATION-HOSEA  // change TGroupOrder :=6 to 7
                    fnUpdatePeriodTrans (strEmpCode, 'TXCHRG', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
                    curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,'',Journalpostas::" ",Journalpostingtype::" ",'',
                    Coopparameters::none,CurrInstalment);
                end else
                begin
                    //If taxable pay is lower than limit
                    //curTaxCharged := fnGetEmployeePaye(curTaxablePay);
                    curTaxCharged := 0;
                    curTransAmount := curTaxCharged;
                    strTransDescription := 'Tax Charged';
                    TGroup := 'TAXATION'; TGroupOrder := 6; TSubGroupOrder := 7;//CHANGE tax calculations TO PAYE INFORMATION-HOSEA // change TGroupOrder :=6 to 7
                    fnUpdatePeriodTrans (strEmpCode, 'TXCHRG', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
                    curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,'',Journalpostas::" ",Journalpostingtype::" ",'',
                    Coopparameters::none,CurrInstalment);
                  // END
                end;
            end
        
            else
            begin
        
                //Added for deployed
                   if HREmp2."Employee Type" = HREmp2."employee type"::" " then
                   begin
                      //MESSAGE('i am deployed');
                       curTaxCharged := curTaxablePay * 0.3;   //transfer this to setup
                       curTransAmount := curTaxCharged;
        
                       //Added
                       TaxCharged_1:=curTransAmount;
                       //Added
        
                       strTransDescription := 'Tax Charged';
                       TGroup := 'TAXATION'; TGroupOrder := 6; TSubGroupOrder := 7;   //CHANGE tax calculations TO PAYE INFORMATION-HOSEA  // change TGroupOrder :=6 to 7
                       fnUpdatePeriodTrans (strEmpCode, 'TXCHRG', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
                       curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,
                       '',Journalpostas::Credit,Journalpostingtype::" ",'',Coopparameters::none,CurrInstalment);
        
                end else begin
                //Not deployed
              //  MESSAGE('i am NOT deployed');
                curTaxCharged := fnGetEmployeePaye(curTaxablePay);
                curTransAmount := curTaxCharged;
                strTransDescription := 'Tax Charged';
                TGroup := 'TAXATION'; TGroupOrder := 6; TSubGroupOrder := 7;  //CHANGE tax calculations TO PAYE INFORMATION-HOSEA// change TGroupOrder :=6 to 7
                fnUpdatePeriodTrans (strEmpCode, 'TXCHRG', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
                curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,'',Journalpostas::" ",Journalpostingtype::" ",'',
                Coopparameters::none,CurrInstalment);
                //Not deployed
                end;
            end;
         end;
        
        
        
        //Get the Net PAYE amount to post for the month
         if (curReliefPersonal + curInsuranceReliefAmount) > curMaximumRelief then
         begin
            curPAYE := curTaxCharged - curMaximumRelief;
         end else
         begin
            //******************************************************************************************************************************************
            //Added DW: Only for Employees who have brought their insurance Certificate are entitled to Insurance Relief Otherwise NO
            //Place a check mark on the Salary Card to YES
            if (blnInsuranceCertificate) then
            begin
                curPAYE := curTaxCharged - (curReliefPersonal + curInsuranceReliefAmount)-curReliefMorgage;
            end else begin
                curPAYE := curTaxCharged - (curReliefPersonal);
            end;
        
          end;
          Clear(curPAYE);
        
         if not ((blnPaysPaye) and (CurSpecialTaxTotal>0)) then curPAYE := 0 else curPAYE:=curPAYE+CurSpecialTaxTotal;
         //Get statutory Exemption for the staff. If exempted from tax, set PAYE=0
         curTransAmount := curPAYE;
         if curPAYE<0 then curTransAmount := 0;
         strTransDescription := 'P.A.Y.E';
         TGroup := 'STATUTORIES'; TGroupOrder := 7; TSubGroupOrder := 3;
         fnUpdatePeriodTrans (strEmpCode, 'PAYE', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
          curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,TaxAccount,Journalpostas::Credit,
          Journalpostingtype::"G/L Account",'',Coopparameters::none,CurrInstalment);
        
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
             Init;
             "Employee Code" := strEmpCode;
             "Unused Relief" := curPAYE;
             "Period Month" := intMonth;
             "Period Year" := intYear;
             Insert;
        
             curPAYE:=0;
         end;
        end;
        end;
        
         //Deductions: get all deductions for the month
         //Loans: calc loan deduction amount, interest, fringe benefit (employer deduction), loan balance
         //>Balance = (Openning Bal + Deduction)...//Increasing balance
         //>Balance = (Openning Bal - Deduction)...//Reducing balance
         //>NB: some transactions (e.g Sacco shares) can be made by cheque or cash. Allow user to edit the outstanding balance
        
        // //Get the N.H.I.F amount for the month GBT
         curNhif_Base_Amount :=0;
        
        if intNHIF_BasedOn =Intnhif_basedon::Gross then //>NHIF calculation can be based on
                curNhif_Base_Amount := curGrossPay;
         if intNHIF_BasedOn = Intnhif_basedon::Basic then
                curNhif_Base_Amount := curBasicPay;
         if intNHIF_BasedOn =Intnhif_basedon::"Taxable Pay" then
                curNhif_Base_Amount := curTaxablePay;
        
          //commented by hosea to give right NHIF Amount on Payslip
         //curNhif_Base_Amount :=0;
        // curNhif_Base_Amount := curBasicPay;
        
        if curGrossPay>0 then begin
         if blnPaysNhif then begin
          curNHIF:=fnGetEmployeeNHIF(curNhif_Base_Amount);
          curTransAmount := curNHIF;
          strTransDescription := 'N.H.I.F';
          TGroup := 'STATUTORIES'; TGroupOrder := 7; TSubGroupOrder := 2;
          fnUpdatePeriodTrans (strEmpCode, 'NHIF', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
           curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,
           NHIFEMPyee,Journalpostas::Credit,Journalpostingtype::"G/L Account",'',Coopparameters::none,CurrInstalment);
         end;
         end;
        
          prEmployeeTransactions.Reset;
          prEmployeeTransactions.SetRange(prEmployeeTransactions."Employee Code",strEmpCode);
          prEmployeeTransactions.SetRange(prEmployeeTransactions."Period Month",intMonth);
          prEmployeeTransactions.SetRange(prEmployeeTransactions."Period Year",intYear);
          prEmployeeTransactions.SetRange("Current Instalment",PrlPeriods."Current Instalment");
          //prEmployeeTransactions.SETRANGE(prEmployeeTransactions.Suspended,FALSE);
        
          if prEmployeeTransactions.Find('-') then begin
            curTotalDeductions:= 0;
            repeat
              prTransactionCodes.Reset;
              prTransactionCodes.SetRange(prTransactionCodes."Transaction Code",prEmployeeTransactions."Transaction Code");
              prTransactionCodes.SetRange(prTransactionCodes."Transaction Type",prTransactionCodes."transaction type"::Deduction);
              if prTransactionCodes.Find('-') then begin
                curTransAmount:=0; curTransBalance := 0; strTransDescription := ''; strExtractedFrml := '';
        
                if prTransactionCodes."Is Formula" then begin
                    strExtractedFrml := fnPureFormula(strEmpCode, intMonth, intYear, prTransactionCodes.Formula,CurrInstalment);
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
                // Pension
               if(prTransactionCodes."Special Transactions"=prTransactionCodes."special transactions"::"Defined Contribution") then
               if prTransactionCodes.Pension=true then
                //AND (prTransactionCodes."Deduct Mortgage"=FALSE) THEN
                begin
                 curTransAmount:=(0.03*curBasicPay);//-curNSSF;
                   fnUpdateEmployerDeductions(strEmpCode, prTransactionCodes."Transaction Code",
           'EMP', TGroupOrder, TSubGroupOrder,'', curTransAmount, 0, intMonth, intYear,
            prEmployeeTransactions.Membership, prEmployeeTransactions."Reference No",SelectedPeriod,CurrInstalment);
                end;
        
            //Get the posting Details
                 JournalPostingType:=Journalpostingtype::" ";JournalAcc:='';
                 if prTransactionCodes.Subledger<>prTransactionCodes.Subledger::" " then begin
                    if prTransactionCodes.Subledger=prTransactionCodes.Subledger::Customer then begin
                        Customer.Reset;
                        HrEmployee.Get(strEmpCode);
                        Customer.Reset;
                        //IF prTransactionCodes.CustomerPostingGroup ='' THEN
                          //Customer.SETRANGE(Customer."Employer Code",'KPSS');
        
                        if prTransactionCodes.CustomerPostingGroup <>'' then
                        Customer.SetRange(Customer."Customer Posting Group",prTransactionCodes.CustomerPostingGroup);
        
                        Customer.SetRange(Customer."No.",HrEmployee."No.");
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
                          curTotalDeductions := curTotalDeductions + curTransAmount; //Sum-up all the deductions
                          curTransBalance:=0;
                          strTransCode := prEmployeeTransactions."Transaction Code"+'-INT';
                          strTransDescription := prEmployeeTransactions."Transaction Name"+ 'Interest';
                          TGroup := 'DEDUCTIONS'; TGroupOrder := 8; TSubGroupOrder := 1;  //change other deductions to deductions-hosea //change group from 8 to 6 and subgroup from 1 to 12-hosea
                          fnUpdatePeriodTrans(strEmpCode, strTransCode, TGroup, TGroupOrder, TSubGroupOrder,
                            strTransDescription, curTransAmount, curTransBalance, intMonth, intYear,
                            prEmployeeTransactions.Membership, prEmployeeTransactions."Reference No",SelectedPeriod,Dept,
                            JournalAcc,Journalpostas::Credit,JournalPostingType,prEmployeeTransactions."Loan Number",
                            Coopparameters::"loan Interest",CurrInstalment)
                    end;
                   //Get the Principal Amt
                   curTransAmount:=prEmployeeTransactions."Amortized Loan Total Repay Amt"-curLoanInt;
                    //Modify PREmployeeTransaction Table
                    prEmployeeTransactions.Amount:=curTransAmount;
                    prEmployeeTransactions.Modify;
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
        
                curTotalDeductions := curTotalDeductions + curTransAmount; //Sum-up all the deductions
                curTransAmount := curTransAmount;
                curTransBalance := curTransBalance;
                strTransDescription := prTransactionCodes."Transaction Name";
                TGroup := 'DEDUCTIONS'; TGroupOrder := 8; TSubGroupOrder := 13; //change other deductions to deductions-hosea // change TGroupOrder :=8 to 6
                fnUpdatePeriodTrans (strEmpCode, prEmployeeTransactions."Transaction Code", TGroup, TGroupOrder, TSubGroupOrder,
                 strTransDescription,curTransAmount, curTransBalance, intMonth,
                 intYear, prEmployeeTransactions.Membership, prEmployeeTransactions."Reference No",SelectedPeriod,Dept,
                 JournalAcc,Journalpostas::Credit,JournalPostingType,prEmployeeTransactions."Loan Number",
                 prTransactionCodes."coop parameters",CurrInstalment);
        
        
        
        
        //Check if transaction is loan. Get the Interest on the loan & post it at this point before moving next ****Loan Calculation
                if (prTransactionCodes."Special Transactions"=prTransactionCodes."special transactions"::"Staff Loan") and
                   (prTransactionCodes."Repayment Method" <> prTransactionCodes."repayment method"::Amortized) then begin
        
                     curLoanInt:=fnCalcLoanInterest (strEmpCode, prEmployeeTransactions."Transaction Code",
                    prTransactionCodes."Interest Rate",
                     prTransactionCodes."Repayment Method", prEmployeeTransactions."Original Amount",
                     prEmployeeTransactions.Balance,SelectedPeriod,prTransactionCodes.Welfare);
                      if curLoanInt > 0 then begin
                          curTransAmount := curLoanInt;
                          curTotalDeductions := curTotalDeductions + curTransAmount; //Sum-up all the deductions
                          curTransBalance:=0;
                          strTransCode := prEmployeeTransactions."Transaction Code"+'-INT';
                          strTransDescription := prEmployeeTransactions."Transaction Name"+ 'Interest';
                          TGroup := 'DEDUCTIONS'; TGroupOrder := 8; TSubGroupOrder := 14;   //change other deductions to deductions-hosea // change TGroupOrder :=8 to 6
                          fnUpdatePeriodTrans(strEmpCode, strTransCode, TGroup, TGroupOrder, TSubGroupOrder,
                            strTransDescription, curTransAmount, curTransBalance, intMonth, intYear,
                            prEmployeeTransactions.Membership, prEmployeeTransactions."Reference No",SelectedPeriod,Dept,
                            JournalAcc,Journalpostas::Credit,JournalPostingType,prEmployeeTransactions."Loan Number",
                            Coopparameters::"loan Interest",CurrInstalment)
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
                            prEmployeeTransactions.Membership, prEmployeeTransactions."Reference No",SelectedPeriod,CurrInstalment)
        
                      end;
               //End Fringe Benefits
        
              //Create Employer Deduction
              if (prTransactionCodes."Employer Deduction") or (prTransactionCodes."Include Employer Deduction") then begin
                if prTransactionCodes."Is Formula for employer"<>'' then begin
                    strExtractedFrml := fnPureFormula(strEmpCode, intMonth, intYear,prTransactionCodes."Is Formula for employer",CurrInstalment);
                    curTransAmount := fnFormulaResult(strExtractedFrml); //Get the calculated amount
                end else begin
                    curTransAmount := prEmployeeTransactions."Employer Amount";
                end;
                      if  curTransAmount>0 then
                          fnUpdateEmployerDeductions(strEmpCode, prEmployeeTransactions."Transaction Code",
                           'EMP', TGroupOrder, TSubGroupOrder,'', curTransAmount, 0, intMonth, intYear,
                            prEmployeeTransactions.Membership, prEmployeeTransactions."Reference No",SelectedPeriod,CurrInstalment);
        
        //Added to for employee plus employer contributions NCA
        //Update Balance on PR Period Transaction Table with Pension Contributed from Employer
        PRPeriodTrans.Reset;
        PRPeriodTrans.SetRange(PRPeriodTrans."Employee Code",strEmpCode);
        PRPeriodTrans.SetRange(PRPeriodTrans."Transaction Code",prEmployeeTransactions."Transaction Code");
        PRPeriodTrans.SetRange(PRPeriodTrans."Payroll Period",SelectedPeriod);
        if PRPeriodTrans.Find('-') then
        begin
        if PRPeriodTrans.Balance <> 0 then PRPeriodTrans.Balance += curTransAmount;
        PRPeriodTrans.Modify;
        end;
        //Added to for employee plus employer contributions NCA
        
        
        
        
              end;
              //Employer deductions
        
              end;
        
          until prEmployeeTransactions.Next=0;
             //GET TOTAL DEDUCTIONS
        // // // //     IF CurSpecialTaxTotal>0 THEN BEGIN
        // // // // curTotalDeductions := curTotalDeductions +CurSpecialTaxTotal;
        // // // //        curTransAmount := CurSpecialTaxTotal;
        // // // //        curTransBalance := 0;
        // // // //                 // CurSpecialTaxTotal:=CurSpecialTaxTotal+curTransAmount;
        // // // //     strTransDescription := 'CBA T';
        // // // //     TGroup := 'TAXATION'; TGroupOrder := 6; TSubGroupOrder := 1;
        // // // //     fnUpdatePeriodTrans (strEmpCode, prTransactionCodes."Transaction Code"+'-Tax('+FORMAT(prTransactionCodes."Prorate Payment")+'%', TGroup, TGroupOrder, TSubGroupOrder,
        // // // //     strTransDescription+'TAX',
        // // // //     curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,'',JournalPostAs::" ",JournalPostingType::" ",'',
        // // // //     CoopParameters::none,CurrInstalment)
        // // // //     END;
                          //Added for NCA - To add Statutories to Total Deductions
                          TotalSTATUTORIES:=0;
                          PRPeriod.Reset;
                          PRPeriod.SetRange(PRPeriod."Payroll Period",SelectedPeriod);
                          PRPeriod.SetRange(PRPeriod."Employee Code",strEmpCode);
                          PRPeriod.SetRange("Current Instalment",PrlPeriods."Current Instalment");
                          PRPeriod.SetFilter(PRPeriod."Group Text",'=%1','STATUTORIES|DEDUCTIONS'); //cHANGE STATUTORY DEDUCTIONS TO STATUTORIES-HOSEA
                          if PRPeriod.Find('-') then
                          begin
                              repeat
                                  TotalSTATUTORIES += PRPeriod.Amount;
                              until PRPeriod.Next =0;
                          end;
                          //Added for NCA - To add Statutories to Total Deductions
                          curTransBalance:=0;
                          strTransCode := 'TOT-DED';
                          strTransDescription := 'TOTAL DEDUCTIONS';
                          TGroup := 'DEDUCTION SUMMARY'; TGroupOrder := 8; TSubGroupOrder := 15;//change other deductions to deductions-hosea // change TGroupOrder :=6 to 8
                          fnUpdatePeriodTrans(strEmpCode, strTransCode, TGroup, TGroupOrder, TSubGroupOrder,
                            strTransDescription,(TotalSTATUTORIES), curTransBalance, intMonth, intYear,
                            // (curTotalDeductions+TotalSTATUTORIES-curTotalDeductions), curTransBalance, intMonth, intYear, //ADD -curTotalDeductions -HOSEA
                            prEmployeeTransactions.Membership, prEmployeeTransactions."Reference No",SelectedPeriod,Dept,
                            '',Journalpostas::" ",Journalpostingtype::" ",'',Coopparameters::none,CurrInstalment)
        
             //END GET TOTAL DEDUCTIONS
         end;
        
          //Net Pay: calculate the Net pay for the month in the following manner:
          //>Nett = Gross - (xNssfAmount + curMyNhifAmt + PAYE + PayeArrears + prTotDeductions)
          //...Tot Deductions also include (SumLoan + SumInterest)
          curNetPay := curGrossPay - (curNSSF + curNHIF + curPAYE + curPayeArrears + curTotalDeductions+IsCashBenefit);
        
          //>Nett = Nett - curExcessPension
          //...Excess pension is only used for tax. Staff is not paid the amount hence substract it
          curNetPay := curNetPay; //- curExcessPension
          curTotCompanyDed:=curTotCompanyDed+CurSpecialTaxTotal;
          //>Nett = Nett - cSumEmployerDeductions
          //...Employer Deductions are used for reporting as cost to company BUT dont affect Net pay
          curNetPay := curNetPay - curTotCompanyDed; //******Get Company Deduction*****
        
          curNetRnd_Effect := curNetPay - ROUND(curNetPay);
          curTransAmount := curNetPay;
          strTransDescription := 'Net Pay';
          TGroup := 'NET PAY'; TGroupOrder := 9; TSubGroupOrder := 0;
        
          fnUpdatePeriodTrans(strEmpCode, 'NPAY', TGroup, TGroupOrder, TSubGroupOrder, strTransDescription,
          curTransAmount, 0, intMonth, intYear,'','',SelectedPeriod,Dept,
          PayablesAcc,Journalpostas::Credit,Journalpostingtype::"G/L Account",'',Coopparameters::none,CurrInstalment);
        
          //Rounding Effect: if the Net pay is rounded, take the rounding effect &
          //save it as an earning for the staff for the next month
              //>Insert the Netpay rounding effect into the tblRoundingEffect table
        
        
          //Negative pay: if the NetPay<0 then log the entry
              //>Display an on screen report
              //>Through a pop-up to the user
              //>Send an email to the user or manager
        //END
        
        //END;
        //END; !!!!!!!!!
        Clear(_CBA30OldTax);
        Clear(_CBA30NewTax);
        Clear(_CBA30Amount);
        Clear(_CBAPension);
        Clear(_CBADiff);
        Clear(_CBABenevollent);
        prPeriodTransactions.Reset;
        prPeriodTransactions.SetRange(prPeriodTransactions."Employee Code",strEmpCode);
        prPeriodTransactions.SetRange(prPeriodTransactions."Payroll Period",SelectedPeriod);
        if prPeriodTransactions.Find('-') then begin
          repeat
            begin
              if prPeriodTransactions."Transaction Code"='800-TAX(NO%' then _CBA30OldTax:=prPeriodTransactions.Amount;
              if prPeriodTransactions."Transaction Code"='800' then _CBA30Amount:=prPeriodTransactions.Amount;
              if prPeriodTransactions."Transaction Code"='807' then _CBAPension:=prPeriodTransactions.Amount;
              if prPeriodTransactions."Transaction Code"='806' then _CBABenevollent:=prPeriodTransactions.Amount;
            end;
          until prPeriodTransactions.Next=0;
        end;
        _CBADiff:=_CBA30OldTax-((_CBA30Amount-_CBAPension-_CBABenevollent)*(0.3));
        prPeriodTransactions.Reset;
        prPeriodTransactions.SetRange(prPeriodTransactions."Employee Code",strEmpCode);
        prPeriodTransactions.SetRange(prPeriodTransactions."Payroll Period",SelectedPeriod);
        if prPeriodTransactions.Find('-') then begin
          repeat
            begin
              if prPeriodTransactions."Transaction Code"='800-TAX(NO%' then begin
                  prPeriodTransactions.Amount:=((_CBA30Amount-_CBAPension-_CBABenevollent)*(0.3));
                  end;
              if prPeriodTransactions."Transaction Code"='NPAY' then  begin
                  prPeriodTransactions.Amount:=prPeriodTransactions.Amount+_CBADiff;
                  end;
                  prPeriodTransactions.Modify;
            end;
          until prPeriodTransactions.Next=0;
        end;

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


    procedure fnUpdatePeriodTrans(EmpCode: Code[20];TCode: Code[20];TGroup: Code[20];GroupOrder: Integer;SubGroupOrder: Integer;Description: Text[50];curAmount: Decimal;curBalance: Decimal;Month: Integer;Year: Integer;mMembership: Text[30];ReferenceNo: Text[30];dtOpenPeriod: Date;Department: Code[20];JournalAC: Code[20];PostAs: Option " ",Debit,Credit;JournalACType: Option " ","G/L Account",Customer,Vendor;LoanNo: Code[20];CoopParam: Option "none",shares,loan,"loan Interest","Emergency loan","Emergency loan Interest","School Fees loan","School Fees loan Interest",Welfare,Pension;currentInstalment: Integer)
    var
        prPeriodTransactions: Record UnknownRecord99252;
        prSalCard: Record UnknownRecord61118;
    begin
        if curAmount = 0 then exit;
        prPeriodTransactions.Reset;
        prPeriodTransactions.SetRange("Employee Code",EmpCode);
        prPeriodTransactions.SetRange("Transaction Code",TCode);
        prPeriodTransactions.SetRange("Period Month",Month);
        prPeriodTransactions.SetRange("Period Year",Year);
        prPeriodTransactions.SetRange("Current Instalment",currentInstalment);
        if  prPeriodTransactions.Find('-') then prPeriodTransactions.Delete;
        with prPeriodTransactions do begin
            Init;
            "Employee Code" := EmpCode;
            "Transaction Code" := TCode;
            "Current Instalment":=currentInstalment;
            "Group Text" := TGroup;
            "Transaction Name" := Description;
             Amount := ROUND(curAmount);
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


    procedure fnGetSpecialTransAmount(strEmpCode: Code[20];intMonth: Integer;intYear: Integer;intSpecTransID: Option Ignore,"Defined Contribution","Home Ownership Savings Plan","Life Insurance","Owner Occupier Interest","Prescribed Benefit","Salary Arrears","Staff Loan","Value of Quarters",Morgage,Gratuity,"Insurance Relief","Allowance Recovery";blnCompDedc: Boolean;currInstalment: Integer) SpecialTransAmount: Decimal
    var
        prEmployeeTransactions: Record UnknownRecord99251;
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
           prEmployeeTransactions.SetRange("Current Instalment",currInstalment);
           if prEmployeeTransactions.Find('-') then begin

            //Ignore,Defined Contribution,Home Ownership Savings Plan,Life Insurance,
            //Owner Occupier Interest,Prescribed Benefit,Salary Arrears,Staff Loan,Value of Quarters
              case intSpecTransID of
                Intspectransid::"Defined Contribution":
                  if prTransactionCodes."Is Formula" then begin
                      strExtractedFrml := '';
                      strExtractedFrml := fnPureFormula(strEmpCode, intMonth, intYear, prTransactionCodes.Formula,currInstalment);
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

                Intspectransid::Morgage:
                  begin
                    SpecialTransAmount :=SpecialTransAmount+ curReliefMorgage;

                    if SpecialTransAmount > curReliefMorgage then
                     begin
                      SpecialTransAmount:=curReliefMorgage
                     end;

                  end;

              end;
           end;
         until prTransactionCodes.Next=0;
        end;
        //SpecialTranAmount:=SpecialTransAmount;
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


    procedure fnPureFormula(strEmpCode: Code[20];intMonth: Integer;intYear: Integer;strFormula: Text[250];CurrInstalment: Integer) Formula: Text[250]
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
            TransCodeAmount:=fnGetTransAmount(strEmpCode, TransCode, intMonth, intYear,CurrInstalment);
            //Reset Transcode
             TransCode:='';
            //Get Final Formula
             FinalFormula:=FinalFormula+Format(TransCodeAmount);
            //End Get Transcode
           end;
           end;
           Formula:=FinalFormula;
    end;


    procedure fnGetTransAmount(strEmpCode: Code[20];strTransCode: Code[20];intMonth: Integer;intYear: Integer;CurrentInstal: Integer) TransAmount: Decimal
    var
        prEmployeeTransactions: Record UnknownRecord99252;
        prPeriodTransactions: Record UnknownRecord99251;
    begin
        prEmployeeTransactions.Reset;
        prEmployeeTransactions.SetRange(prEmployeeTransactions."Employee Code",strEmpCode);
        prEmployeeTransactions.SetRange(prEmployeeTransactions."Transaction Code",strTransCode);
        prEmployeeTransactions.SetRange(prEmployeeTransactions."Period Month",intMonth);
        prEmployeeTransactions.SetRange(prEmployeeTransactions."Period Year",intYear);
        //prEmployeeTransactions.SETRANGE(prEmployeeTransactions.Suspended,FALSE);
        prEmployeeTransactions.SetRange("Current Instalment",CurrentInstal);
        if prEmployeeTransactions.FindFirst then begin

          TransAmount:=prEmployeeTransactions.Amount;
         // IF prEmployeeTransactions."No of Units"<>0 THEN
            // TransAmount:=prEmployeeTransactions."No of Units";

        end;
        if TransAmount=0 then begin
        prPeriodTransactions.Reset;
        prPeriodTransactions.SetRange(prPeriodTransactions."Employee Code",strEmpCode);
        prPeriodTransactions.SetRange(prPeriodTransactions."Transaction Code",strTransCode);
        prPeriodTransactions.SetRange(prPeriodTransactions."Period Month",intMonth);
        prPeriodTransactions.SetRange(prPeriodTransactions."Period Year",intYear);
        prPeriodTransactions.SetRange("Current Instalment",CurrentInstal);
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


    procedure fnClosePayrollPeriod(dtOpenPeriod: Date;PayrollCode: Code[20];CurrentInstallment: Integer) Closed: Boolean
    var
        dtOldPeriod: Date;
        intNewMonth: Integer;
        dtNewPeriod: Date;
        intOldMonth: Integer;
        intNewYear: Integer;
        intOldYear: Integer;
        prEmployeeTransactions: Record UnknownRecord99251;
        prPeriodTransactions: Record UnknownRecord99252;
        intMonth: Integer;
        intYear: Integer;
        prTransactionCodes: Record UnknownRecord61082;
        curTransAmount: Decimal;
        curTransBalance: Decimal;
        prEmployeeTrans: Record UnknownRecord99251;
        prPayrollPeriods: Record UnknownRecord99250;
        prNewPayrollPeriods: Record UnknownRecord99250;
        CreateTrans: Boolean;
        ControlInfo: Record UnknownRecord61119;
        prsalCard3: Record UnknownRecord99200;
        prsalCard: Record UnknownRecord99200;
        NextCurrInstalment: Integer;
    begin
        ControlInfo.Get();
        Clear(NextCurrInstalment);

        PrlPeriods.Reset;
        PrlPeriods.SetRange("Date Openned",dtOpenPeriod);
        PrlPeriods.SetRange("Current Instalment",CurrentInstallment);
        if PrlPeriods.Find('-') then begin
          if (PrlPeriods."No. of Instalments"<CurrentInstallment) then NextCurrInstalment:=CurrentInstallment+1
          else NextCurrInstalment:=1;
          end;

        if CurrentInstallment=2 then NextCurrInstalment:=1
        else if  CurrentInstallment=1 then NextCurrInstalment:=2;

        if NextCurrInstalment=1 then begin
        dtNewPeriod := CalcDate('1M', dtOpenPeriod);
        end else if NextCurrInstalment>1 then begin
        dtNewPeriod := dtOpenPeriod;
          end;
        intNewMonth := Date2dmy(dtNewPeriod,2);
        intNewYear := Date2dmy(dtNewPeriod,3);
        intOldMonth:= Date2dmy(dtOpenPeriod,2);
        intOldYear:= Date2dmy(dtOpenPeriod,3);

        intMonth := Date2dmy(dtOpenPeriod,2);
        intYear := Date2dmy(dtOpenPeriod,3);

        prEmployeeTransactions.Reset;
        prEmployeeTransactions.SetRange(prEmployeeTransactions."Period Month",intMonth);
        prEmployeeTransactions.SetRange(prEmployeeTransactions."Period Year",intYear);
        prEmployeeTransactions.SetRange("Current Instalment",CurrentInstallment);
        //Multiple Payroll
        if ControlInfo."Multiple Payroll" then begin
            prEmployeeTransactions.SetRange(prEmployeeTransactions."Payroll Code",PayrollCode);
            end;

        //prEmployeeTransactions.SETRANGE(prEmployeeTransactions."Employee Code",'KPSS091');


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
            if (curTransAmount <> 0) then  //Update the employee transaction table
             begin
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
              "Current Instalment":=NextCurrInstalment;
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
               end;
             end;
          end;
          end
          until prEmployeeTransactions.Next=0;
        prsalCard.Reset;
        prsalCard.SetRange(prsalCard."Payroll Period",dtOpenPeriod);
        if prsalCard.Find('-') then begin
          repeat
          begin

            // HrEmployee.RESET;
           //  HrEmployee.SETRANGE("No.",prsalCard."Employee Code");
           //  IF

        prsalCard3.Reset;
        if not (prsalCard3.Get(prsalCard."Employee Code",dtNewPeriod,NextCurrInstalment)) then begin // Insert the Basic salary details for the current Month
        prsalCard3.Init;
        prsalCard3."Employee Code" := prsalCard."Employee Code";
        prsalCard3."Current Instalment":=NextCurrInstalment;
        prsalCard3."Days Worked":=0;
        prsalCard3."Period Month" := intNewMonth ;
        prsalCard3."Period Year":=  intNewYear;
        prsalCard3."Payroll Period":=dtNewPeriod;
        prsalCard3."Daily Rate":= prsalCard."Daily Rate";
        prsalCard3.Insert;
        end;

          end;
          until prsalCard.Next=0;
        end;


        //END;

        //Update the Period as Closed
        prPayrollPeriods.Reset;
        prPayrollPeriods.SetRange(prPayrollPeriods."Period Month",intMonth);
        prPayrollPeriods.SetRange(prPayrollPeriods."Period Year",intYear);
        prPayrollPeriods.SetRange(prPayrollPeriods."Current Instalment",CurrentInstallment);
        prPayrollPeriods.SetRange(prPayrollPeriods.Closed,false);
        //IF ControlInfo."Multiple Payroll" THEN
           // prPayrollPeriods.SETRANGE(prPayrollPeriods."Payroll Code",PayrollCode);

        if prPayrollPeriods.Find('-') then begin
           prPayrollPeriods.Closed:=true;
          prPayrollPeriods."Closed By":=UserId;
           prPayrollPeriods."Date Closed":=Today;
           prPayrollPeriods.Modify;
        end;

        //Enter a New Period
        with prNewPayrollPeriods do begin
          Init;
            "Period Month":=intNewMonth;
            "Period Year":= intNewYear;
            "Period Name":= Format(dtNewPeriod,0,'<Month Text>')+' - '+Format(intNewYear);
            "Date Openned":= dtNewPeriod;
            "No. of Instalments":=prPayrollPeriods."No. of Instalments";
            "No of Days":=prPayrollPeriods."No of Days";
            "Payslip Message":=prPayrollPeriods."Payslip Message";
            "Current Instalment":=NextCurrInstalment;
            "Instalment Description":=prPayrollPeriods."Instalment Description";
            if NextCurrInstalment=1 then
            "Period Instalment Prefix":="period instalment prefix"::st
            else
            "Period Instalment Prefix":="period instalment prefix"::nd;
            "13thSlips Daily Rate":=prPayrollPeriods."13thSlips Daily Rate";
             Closed :=false;
             //"Payroll Code":=PayrollCode;
            Insert;
        end;
        end;
        //Effect the transactions for the P9
        //fnP9PeriodClosure(intMonth, intYear, dtOpenPeriod,PayrollCode);

        //Take all the Negative pay (Net) for the current month & treat it as a deduction in the new period
        //fnGetNegativePay(intMonth, intYear,dtOpenPeriod);
    end;


    procedure fnGetNegativePay(intMonth: Integer;intYear: Integer;dtOpenPeriod: Date)
    var
        prPeriodTransactions: Record UnknownRecord99252;
        prEmployeeTransactions: Record UnknownRecord99251;
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
        prPeriodTransactions: Record UnknownRecord99252;
        prEmployee: Record UnknownRecord61118;
        p9Pension: Decimal;
    begin
        P9BasicPay := 0; P9Allowances := 0; P9Benefits := 0; P9ValueOfQuarters := 0;
        P9DefinedContribution := 0; P9OwnerOccupierInterest := 0;
        P9GrossPay := 0; P9TaxablePay := 0; P9TaxCharged := 0; P9InsuranceRelief := 0;
        P9TaxRelief := 0; P9Paye := 0; P9NSSF := 0; P9NHIF := 0;
        p9Pension:=0;
        P9Deductions := 0; P9NetPay := 0;

        prEmployee.Reset;
        prEmployee.SetRange(prEmployee.Status,prEmployee.Status::Normal);
        if prEmployee.Find('-') then begin
        repeat

        P9BasicPay := 0; P9Allowances := 0; P9Benefits := 0; P9ValueOfQuarters := 0;
        P9DefinedContribution := 0; P9OwnerOccupierInterest := 0;
        P9GrossPay := 0; P9TaxablePay := 0; P9TaxCharged := 0; P9InsuranceRelief := 0;
        P9TaxRelief := 0; P9Paye := 0; P9NSSF := 0; P9NHIF := 0;
        P9Deductions := 0; P9NetPay := 0; p9Pension:=0;

        prPeriodTransactions.Reset;
        prPeriodTransactions.SetRange(prPeriodTransactions."Period Month",intMonth);
        prPeriodTransactions.SetRange(prPeriodTransactions."Period Year",intYear);
        prPeriodTransactions.SetRange(prPeriodTransactions."Employee Code",prEmployee."No.");
        if prPeriodTransactions.Find('-') then begin
          repeat
            if ((prPeriodTransactions."Transaction Code"='807') or
               (prPeriodTransactions."Transaction Code"='806')) then p9Pension:=p9Pension+prPeriodTransactions.Amount;
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
                 // IF "Sub Group Order" = 1 THEN P9DefinedContribution := Amount; //Defined Contribution
                  if "Sub Group Order" = 9 then P9TaxRelief := Amount; //Tax Relief
                  if "Sub Group Order" = 8 then P9InsuranceRelief := Amount; //Insurance Relief
                  if "Sub Group Order" = 6 then P9TaxablePay := Amount; //Taxable Pay
                  if "Sub Group Order" = 7 then P9TaxCharged := Amount; //Tax Charged
                  if "Sub Group Order" = 1 then P9Paye := P9Paye + Amount;
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

        if P9NetPay <> 0 then
         fnUpdateP9Table (prEmployee."No.", P9BasicPay, P9Allowances, P9Benefits, P9ValueOfQuarters, P9DefinedContribution,
             P9OwnerOccupierInterest, P9GrossPay, P9TaxablePay, P9TaxCharged, P9InsuranceRelief, P9TaxRelief, P9Paye, P9NSSF,
             P9NHIF, P9Deductions, P9NetPay, dtCurPeriod,PayrollCode,p9Pension);

        until prEmployee.Next=0;
        end;
    end;


    procedure fnUpdateP9Table(P9EmployeeCode: Code[20];P9BasicPay: Decimal;P9Allowances: Decimal;P9Benefits: Decimal;P9ValueOfQuarters: Decimal;P9DefinedContribution: Decimal;P9OwnerOccupierInterest: Decimal;P9GrossPay: Decimal;P9TaxablePay: Decimal;P9TaxCharged: Decimal;P9InsuranceRelief: Decimal;P9TaxRelief: Decimal;P9Paye: Decimal;P9NSSF: Decimal;P9NHIF: Decimal;P9Deductions: Decimal;P9NetPay: Decimal;dtCurrPeriod: Date;prPayrollCode: Code[20];p9Pension: Decimal)
    var
        prEmployeeP9Info: Record UnknownRecord99254;
        intYear: Integer;
        intMonth: Integer;
    begin
        intMonth := Date2dmy(dtCurrPeriod,2);
        intYear := Date2dmy(dtCurrPeriod,3);

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
            Allowances:= P9Allowances;
            Benefits:= P9Benefits;
            "Value Of Quarters":= P9ValueOfQuarters;
            "Defined Contribution":= P9DefinedContribution;
            "Owner Occupier Interest":= P9OwnerOccupierInterest;
            "Gross Pay":= P9GrossPay;
            "Taxable Pay":= P9TaxablePay;
            "Tax Charged":= P9TaxCharged;
            "Insurance Relief":= P9InsuranceRelief;
            "Tax Relief":= P9TaxRelief;
            Pension:=p9Pension;
            PAYE:= P9Paye;
            NSSF:= P9NSSF;
            NHIF:= P9NHIF;
            Deductions:= P9Deductions;
            "Net Pay":= P9NetPay;
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
               /*   IF dtTermination<>0D THEN BEGIN
                  IF (DATE2DMY(dtTermination,2)=DATE2DMY(StartDate,2)) AND (DATE2DMY(dtTermination,3)=DATE2DMY(StartDate,3))THEN BEGIN
                      CountDaysofMonth:=fnDaysInMonth(dtTermination);
                      DaysWorked:=fnDaysWorked(dtTermination,TRUE);
                      ProratedBasic := fnBasicPayProrated(EmpCode, startmonth, startYear, P9BasicPay,DaysWorked,CountDaysofMonth)
                  END;
                END;*/
        
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


    procedure fnUpdateEmployerDeductions(EmpCode: Code[20];TCode: Code[20];TGroup: Code[20];GroupOrder: Integer;SubGroupOrder: Integer;Description: Text[50];curAmount: Decimal;curBalance: Decimal;Month: Integer;Year: Integer;mMembership: Text[30];ReferenceNo: Text[30];dtOpenPeriod: Date;currentInstalments: Integer)
    var
        prEmployerDeductions: Record UnknownRecord99253;
    begin

        if curAmount = 0 then exit;
        if not prEmployerDeductions.Get(EmpCode,TCode,Month,Year,dtOpenPeriod,currentInstalments) then begin
        with prEmployerDeductions do begin

            Init;
            "Employee Code" := EmpCode;
            "Current Instalment":=currentInstalments;
            "Transaction Code" := TCode;
             Amount := curAmount;
            "Period Month" := Month;
            "Period Year" := Year;
            "Payroll Period" := dtOpenPeriod;
            Insert;
        end;
        end else begin
          with prEmployerDeductions do begin

            //"Employee Code" := EmpCode;
            //"Transaction Code" := TCode;
             Amount := curAmount;
            //"Period Month" := Month;
            //"Period Year" := Year;
            //"Payroll Period" := dtOpenPeriod;
            Modify;
        end;
        end;
    end;


    procedure fnDisplayFrmlValues(EmpCode: Code[30];intMonth: Integer;intYear: Integer;Formula: Text[50]) curTransAmount: Decimal
    var
        pureformula: Text[50];
    begin
          // pureformula := fnPureFormula(EmpCode, intMonth, intYear, Formula);
          // curTransAmount := fnFormulaResult(pureformula); //Get the calculated amount
    end;


    procedure fnUpdateEmployeeTrans(EmpCode: Code[20];TransCode: Code[20];Amount: Decimal;Month: Integer;Year: Integer;PayrollPeriod: Date)
    var
        prEmployeeTrans: Record UnknownRecord99251;
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


    procedure fnGetSpecialTransAmount2(strEmpCode: Code[20];intMonth: Integer;intYear: Integer;intSpecTransID: Option Ignore,"Defined Contribution","Home Ownership Savings Plan","Life Insurance","Owner Occupier Interest","Prescribed Benefit","Salary Arrears","Staff Loan","Value of Quarters",Morgage;blnCompDedc: Boolean;currentInstalments: Integer)
    var
        prEmployeeTransactions: Record UnknownRecord99251;
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
            prEmployeeTransactions.SetRange("Current Instalment",currentInstalments);
           prEmployeeTransactions.SetRange(prEmployeeTransactions.Suspended,false);
           if prEmployeeTransactions.Find('-') then begin

            //Ignore,Defined Contribution,Home Ownership Savings Plan,Life Insurance,
            //Owner Occupier Interest,Prescribed Benefit,Salary Arrears,Staff Loan,Value of Quarters
              case intSpecTransID of
                Intspectransid::"Defined Contribution":
                  if prTransactionCodes."Is Formula" then begin
                      strExtractedFrml := '';
                      strExtractedFrml := fnPureFormula(strEmpCode, intMonth, intYear, prTransactionCodes.Formula,currentInstalments);
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

              end;
           end;
         until prTransactionCodes.Next=0;
        end;
    end;


    procedure fnCheckPaysPension(pnEmpCode: Code[20];pnPayperiod: Date;currInstalment: Integer) PaysPens: Boolean
    var
        pnTranCode: Record UnknownRecord61082;
        pnEmpTrans: Record UnknownRecord99251;
    begin
             PaysPens:=false;
             pnEmpTrans.Reset;
             pnEmpTrans.SetRange(pnEmpTrans."Employee Code",pnEmpCode);
             pnEmpTrans.SetRange(pnEmpTrans."Payroll Period",pnPayperiod);
             pnEmpTrans.SetRange("Current Instalment",currInstalment);
              if pnEmpTrans.Find('-') then begin
              repeat
              if pnTranCode.Get(pnEmpTrans."Transaction Code") then
              if pnTranCode."coop parameters"=pnTranCode."coop parameters"::Pension then
              PaysPens:=true;
              until pnEmpTrans.Next=0;
              end;
    end;


    procedure fnGetPensionAmount(strEmpCode: Code[20];intMonth: Integer;intYear: Integer;intSpecTransID: Option Ignore,"Defined Contribution","Home Ownership Savings Plan","Life Insurance","Owner Occupier Interest","Prescribed Benefit","Salary Arrears","Staff Loan","Value of Quarters",Morgage,Gratuity,"Insurance Relief";blnCompDedc: Boolean;currInstalment: Integer) SpecialTransAmount: Decimal
    var
        prEmployeeTransactions: Record UnknownRecord99251;
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
             prEmployeeTransactions.SetRange("Current Instalment",currInstalment);
           if prEmployeeTransactions.Find('-') then begin

            //Ignore,Defined Contribution,Home Ownership Savings Plan,Life Insurance,
            //Owner Occupier Interest,Prescribed Benefit,Salary Arrears,Staff Loan,Value of Quarters
              case intSpecTransID of
                Intspectransid::"Defined Contribution":
                if (prTransactionCodes.Pension) then begin
                  if prTransactionCodes."Is Formula" then begin
                      strExtractedFrml := '';
                      strExtractedFrml := fnPureFormula(strEmpCode, intMonth, intYear, prTransactionCodes.Formula,currInstalment);
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


    procedure fnGetEmployeeNSSF(curBaseAmount: Decimal) NSSF: Decimal
    begin

        // // prNSSF.RESET;
        // // prNSSF.SETCURRENTKEY(prNSSF.Tier);
        // // IF prNSSF.FINDFIRST THEN BEGIN
        // // REPEAT
        // // IF ((curBaseAmount>=prNSSF."Lower Limit") AND (curBaseAmount<=prNSSF."Upper Limit")) THEN
        // //    NSSF:= prNSSF."Tier 1 Employee Deduction";//prNSSF."Tier 1 Employee Deduction" + prNSSF."Tier 2 Employee Deduction";
        // // UNTIL prNSSF.NEXT=0;
        // // END;
    end;


    procedure fnGetEmployerNSSF(curBaseAmount: Decimal) NSSF: Decimal
    begin

        // // prNSSF.RESET;
        // // prNSSF.SETCURRENTKEY(prNSSF.Tier);
        // // IF prNSSF.FINDFIRST THEN BEGIN
        // // REPEAT
        // // IF ((curBaseAmount>=prNSSF."Lower Limit") AND (curBaseAmount<=prNSSF."Upper Limit")) THEN
        // //    NSSF:=prNSSF."Tier 1 Employee Deduction";//prNSSF."Tier 1 Employer Contribution" + prNSSF."Tier 2 Employer Contribution";
        // // UNTIL prNSSF.NEXT=0;
        // // END;
    end;


    procedure fnGetEmployeeNSSF_Tier(curBaseAmount: Decimal) NSSF: Text
    begin
        // //
        // // prNSSF.RESET;
        // // prNSSF.SETCURRENTKEY(prNSSF.Tier);
        // // IF prNSSF.FINDFIRST THEN BEGIN
        // // REPEAT
        // // IF ((curBaseAmount>=prNSSF."Lower Limit") AND (curBaseAmount<=prNSSF."Upper Limit")) THEN
        // //    NSSF:='Tier ' + FORMAT(prNSSF.Tier);
        // // UNTIL prNSSF.NEXT=0;
        // // END;
    end;


    procedure fnCalculatedBasicPay(strEmpCode: Code[20];Month: Integer;Year: Integer;BasicSalary: Decimal;HoursWorked: Decimal;ExpectedWorkHours: Decimal) CalculatedBasicAmt: Decimal
    begin
        CalculatedBasicAmt:= ROUND((HoursWorked /ExpectedWorkHours ) * BasicSalary);
    end;
}

