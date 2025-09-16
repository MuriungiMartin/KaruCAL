#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 99269 "13thSlip-NSSF Report (B)"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/13thSlip-NSSF Report (B).rdlc';

    dataset
    {
        dataitem(UnknownTable61118;UnknownTable61118)
        {
            column(ReportForNavId_1000000009; 1000000009)
            {
            }
            column(CompName;CompanyInformation.Name)
            {
            }
            column(CompAddress;CompanyInformation.Address)
            {
            }
            column(CompPhone1;CompanyInformation."Phone No.")
            {
            }
            column(CompPhone2;CompanyInformation."Phone No. 2")
            {
            }
            column(CompEmail;CompanyInformation."E-Mail")
            {
            }
            column(CompPage;CompanyInformation."Home Page")
            {
            }
            column(CompPin;CompanyInformation."Company P.I.N")
            {
            }
            column(Pic;CompanyInformation.Picture)
            {
            }
            column(CompRegNo;CompanyInformation."Registration No.")
            {
            }
            column(PerName;PRLPayrollPeriods."Period Name"+' ('+Format(NoOfInstalments)+')')
            {
            }
            column(pfNo;"HRM-Employee (D)"."No.")
            {
            }
            column(EmpPin;"HRM-Employee (D)"."PIN Number")
            {
            }
            column(EmpId;"HRM-Employee (D)"."ID Number")
            {
            }
            column(FName;"HRM-Employee (D)"."Last Name")
            {
            }
            column(MName;"HRM-Employee (D)"."Middle Name")
            {
            }
            column(LName;"HRM-Employee (D)"."First Name")
            {
            }
            column(EmployeeAmount;PRLPeriodTransactions.Amount)
            {
            }
            column(EmployerAmount;PRLEmployerDeductions.Amount)
            {
            }
            column(NHIFNo;"HRM-Employee (D)"."NHIF No.")
            {
            }
            column(Gtot;Gtoto)
            {
            }
            column(SaccoSh;SaccoSh)
            {
            }
            column(SaccoLoanRep;SaccoLoanRep)
            {
            }
            column(LoanInt;LoanInt)
            {
            }
            column(XmasSav;XmasSav)
            {
            }
            column(PapoUpesi;PapoUpesi)
            {
            }
            column(region;"HRM-Employee (D)".Region)
            {
            }
            column(seq;seq)
            {
            }
            column(NssFNo;"HRM-Employee (D)"."NSSF No.")
            {
            }
            column(CurrGross;CurrGross)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Clear(SaccoSh);
                Clear(SaccoLoanRep);
                Clear(LoanInt);
                Clear(XmasSav);
                Clear(PapoUpesi);
                Clear(CurrGross);
                Clear(NSSFAmount);
                /*//Shares
                PRLPeriodTransactions.RESET;
                PRLPeriodTransactions.SETRANGE(PRLPeriodTransactions."Employee Code","HRM-Employee (D)"."No.");
                PRLPeriodTransactions.SETRANGE(PRLPeriodTransactions."Transaction Code",'NSSF');
                PRLPeriodTransactions.SETRANGE(PRLPeriodTransactions."Group Text",'STATUTORIES');
                PRLPeriodTransactions.SETRANGE(PRLPeriodTransactions."Payroll Period",datefilter);
                IF PRLPeriodTransactions.FIND('-') THEN BEGIN
                NSSFAmount:=PRLPeriodTransactions.Amount;
                  END;
                  */
                //Gross
                PRLPeriodTransactions.Reset;
                PRLPeriodTransactions.SetRange(PRLPeriodTransactions."Employee Code","HRM-Employee (D)"."No.");
                PRLPeriodTransactions.SetRange(PRLPeriodTransactions."Transaction Code",'GPAY');
                PRLPeriodTransactions.SetRange(PRLPeriodTransactions."Payroll Period",datefilter);
                PRLPeriodTransactions.SetRange("Current Instalment",NoOfInstalments);
                if PRLPeriodTransactions.Find('-') then begin
                CurrGross:=PRLPeriodTransactions.Amount;
                  end;
                /*
                //Loan Interest
                PRLPeriodTransactions.RESET;
                PRLPeriodTransactions.SETRANGE(PRLPeriodTransactions."Employee Code","HRM-Employee (D)"."No.");
                PRLPeriodTransactions.SETRANGE(PRLPeriodTransactions."Transaction Code",'INT001');
                PRLPeriodTransactions.SETRANGE(PRLPeriodTransactions."Payroll Period",datefilter);
                IF PRLPeriodTransactions.FIND('-') THEN BEGIN
                LoanInt:=PRLPeriodTransactions.Amount;
                  END;
                
                //Xmas Savings
                PRLPeriodTransactions.RESET;
                PRLPeriodTransactions.SETRANGE(PRLPeriodTransactions."Employee Code","HRM-Employee (D)"."No.");
                PRLPeriodTransactions.SETRANGE(PRLPeriodTransactions."Transaction Code",'XMA001');
                PRLPeriodTransactions.SETRANGE(PRLPeriodTransactions."Payroll Period",datefilter);
                IF PRLPeriodTransactions.FIND('-') THEN BEGIN
                XmasSav:=PRLPeriodTransactions.Amount;
                  END;
                
                //Papo & Upesi
                PRLPeriodTransactions.RESET;
                PRLPeriodTransactions.SETRANGE(PRLPeriodTransactions."Employee Code","HRM-Employee (D)"."No.");
                PRLPeriodTransactions.SETRANGE(PRLPeriodTransactions."Transaction Code",'PAP001');
                PRLPeriodTransactions.SETRANGE(PRLPeriodTransactions."Payroll Period",datefilter);
                IF PRLPeriodTransactions.FIND('-') THEN BEGIN
                PapoUpesi:=PRLPeriodTransactions.Amount;
                  END;
                
                */
                
                Gtoto:=CurrGross;//+PRLEmployerDeductions.Amount;
                if Gtoto=0 then CurrReport.Skip else seq:=seq+1;

            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(DateFil;datefilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Date Filter';
                    TableRelation = "PRL-Payroll Periods"."Date Opened" where ("Payroll Code"=filter('13THSLIP'|'13THSLIPS'));
                }
                field(NoOfInstalments;NoOfInstalments)
                {
                    ApplicationArea = Basic;
                    Caption = 'Instalments';
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
        PRLPayrollPeriods.SetRange(PRLPayrollPeriods.Closed,false);
        if PRLPayrollPeriods.Find('-') then begin
            datefilter:=PRLPayrollPeriods."Date Openned";
          NoOfInstalments:=PRLPayrollPeriods."Current Instalment";
          end;

        if CompanyInformation.Get() then
          CompanyInformation.CalcFields(CompanyInformation.Picture);
        Clear(Gtoto);
        Clear("Tot-SaccoSh");
        Clear("Tot-SaccoLoanRep");
        Clear("Tot-LoanInt");
        Clear("Tot-XmasSav");
        Clear("Tot-PapoUpesi");
        Clear(seq);
    end;

    trigger OnPreReport()
    begin
        if datefilter=0D then Error('Specify the Period Date');
        //"PRL-Period Transactions".SETFILTER("PRL-Period Transactions"."Payroll Period",'=%1',datefilter)
    end;

    var
        datefilter: Date;
        PRLPayrollPeriods: Record UnknownRecord99250;
        CompanyInformation: Record "Company Information";
        PRLPeriodTransactions: Record UnknownRecord99252;
        PRLEmployerDeductions: Record UnknownRecord99253;
        Gtoto: Decimal;
        PRLTransactionCodes: Record UnknownRecord61082;
        SaccoSh: Decimal;
        SaccoLoanRep: Decimal;
        LoanInt: Decimal;
        XmasSav: Decimal;
        PapoUpesi: Decimal;
        "Tot-SaccoSh": Decimal;
        "Tot-SaccoLoanRep": Decimal;
        "Tot-LoanInt": Decimal;
        "Tot-XmasSav": Decimal;
        "Tot-PapoUpesi": Decimal;
        HelbAm: Decimal;
        seq: Integer;
        NSSFAmount: Decimal;
        CurrGross: Decimal;
        NoOfInstalments: Integer;
}

