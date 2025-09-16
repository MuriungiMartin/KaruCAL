#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68064 "PRL-List Transactions"
{
    PageType = List;
    SourceTable = UnknownTable61091;

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                field("Employee Code";"Employee Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Transaction Code";"Transaction Code")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        blnIsLoan:=false;
                        if objTransCodes.Get("Transaction Code") then
                          "Transaction Name":=objTransCodes."Transaction Name";
                          "Payroll Period":=SelectedPeriod;
                          "Period Month":=PeriodMonth;
                          "Period Year":=PeriodYear;
                          if objTransCodes."Special Transactions"=8 then blnIsLoan:=true;
                        
                        /*IF objTransCodes."Is Formula"=TRUE THEN
                        BEGIN
                         empCode:="Employee Code";
                         CLEAR(objOcx);
                         curTransAmount:=objOcx.fnDisplayFrmlValues(empCode,PeriodMonth,PeriodYear,objTransCodes.Formula);
                         Amount:=curTransAmount;
                        END;
                        */
                        //*************ENTER IF EMPLOYER DEDUCTION IS SET UP
                        curTransAmount:=0;
                        /*
                        IF objTransCodes."Include Employer Deduction"=TRUE THEN
                        BEGIN
                          curTransAmount:=objOcx.fnDisplayFrmlValues(empCode,PeriodMonth,PeriodYear,objTransCodes."Is Formula for employer");
                          "Employer Amount":=curTransAmount;
                        END;
                        */

                    end;
                }
                field("Transaction Name";"Transaction Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("No of Units";"No of Units")
                {
                    ApplicationArea = Basic;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        if (blnIsLoan=true) and (Balance>0) and (Amount>0) then
                        begin
                            "#of Repayments":=ROUND(Balance/Amount,1,'>');
                            "#of Repayments":=ROUND("#of Repayments",1,'>');
                        end;
                    end;
                }
                field(Balance;Balance)
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        if (blnIsLoan=true) and (Balance>0) and (Amount>0) then
                        begin
                            "#of Repayments":=ROUND(Balance/Amount,1,'>');
                            "#of Repayments":=ROUND("#of Repayments",1,'>');
                        end;
                    end;
                }
                field("Recurance Index";"Recurance Index")
                {
                    ApplicationArea = Basic;
                }
                field("Loan Termination Reason";"Loan Termination Reason")
                {
                    ApplicationArea = Basic;
                }
                field("Loan Termination Date";"Loan Termination Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Loan Terminated by";"Loan Terminated by")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("#of Repayments";"#of Repayments")
                {
                    ApplicationArea = Basic;
                    Editable = true;

                    trigger OnValidate()
                    begin
                        if blnIsLoan=true then
                        begin
                            "#of Repayments":=ROUND(Balance/Amount,1,'>');
                            "#of Repayments":=ROUND("#of Repayments",1,'>');
                        end;
                    end;
                }
                field("Amortized Loan Total Repay Amt";"Amortized Loan Total Repay Amt")
                {
                    ApplicationArea = Basic;
                }
                field("Payroll Period";"Payroll Period")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Period Month";"Period Month")
                {
                    ApplicationArea = Basic;
                }
                field("Period Year";"Period Year")
                {
                    ApplicationArea = Basic;
                }
                field(Membership;Membership)
                {
                    ApplicationArea = Basic;
                }
                field("Loan Number";"Loan Number")
                {
                    ApplicationArea = Basic;
                }
                field("Reference No";"Reference No")
                {
                    ApplicationArea = Basic;
                }
                field("Start Date";"Start Date")
                {
                    ApplicationArea = Basic;
                }
                field("End Date";"End Date")
                {
                    ApplicationArea = Basic;
                }
                field(Suspended;Suspended)
                {
                    ApplicationArea = Basic;
                }
                field("Stop for Next Period";"Stop for Next Period")
                {
                    ApplicationArea = Basic;
                }
                field("Employer Amount";"Employer Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Employer Balance";"Employer Balance")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        objPeriod.Reset;
        objPeriod.SetRange(objPeriod.Closed,false);
        if objPeriod.Find('-') then
        begin
            SelectedPeriod:=objPeriod."Date Opened";
            PeriodName:=objPeriod."Period Name";
            PeriodMonth:=objPeriod."Period Month";
            PeriodYear:=objPeriod."Period Year";
            //objEmpTrans.RESET;
            //objEmpTrans.SETRANGE("Payroll Period",SelectedPeriod);
        end;

        //Filter per period  - Dennis
        SetFilter("Payroll Period",Format(objPeriod."Date Opened"));
    end;

    var
        objTransCodes: Record UnknownRecord61082;
        SelectedPeriod: Date;
        objPeriod: Record UnknownRecord61081;
        PeriodName: Text[30];
        PeriodTrans: Record UnknownRecord61092;
        PeriodMonth: Integer;
        PeriodYear: Integer;
        blnIsLoan: Boolean;
        objEmpTrans: Record UnknownRecord61091;
        transType: Text[30];
        objOcx: Codeunit "BankAcc.Recon. PostNew";
        strExtractedFrml: Text[30];
        curTransAmount: Decimal;
        empCode: Text[30];
}

