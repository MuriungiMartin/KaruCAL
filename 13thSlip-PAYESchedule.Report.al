#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 99272 "13thSlip - PAYE Schedule"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/13thSlip - PAYE Schedule.rdlc';

    dataset
    {
        dataitem(UnknownTable99252;UnknownTable99252)
        {
            DataItemTableView = where("Transaction Code"=filter(PAYE));
            PrintOnlyIfDetail = true;
            column(ReportForNavId_1000000000; 1000000000)
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
            dataitem(UnknownTable61118;UnknownTable61118)
            {
                DataItemLink = "No."=field("Employee Code");
                column(ReportForNavId_1000000009; 1000000009)
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
                column(PinNo;"HRM-Employee (D)"."PIN Number")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    PRLEmployerDeductions.Reset;
                    PRLEmployerDeductions.SetRange(PRLEmployerDeductions."Employee Code","HRM-Employee (D)"."No.");
                    PRLEmployerDeductions.SetRange(PRLEmployerDeductions."Transaction Code",'PAYE');
                    PRLEmployerDeductions.SetRange(PRLEmployerDeductions."Payroll Period",datefilter);
                    PRLEmployerDeductions.SetRange("Current Instalment",NoofInstalments);
                    if PRLEmployerDeductions.Find('-') then begin
                      end;

                    PRLPeriodTransactions.Reset;
                    PRLPeriodTransactions.SetRange(PRLPeriodTransactions."Employee Code","HRM-Employee (D)"."No.");
                    PRLPeriodTransactions.SetRange(PRLPeriodTransactions."Transaction Code",'PAYE');
                    PRLPeriodTransactions.SetRange(PRLPeriodTransactions."Payroll Period",datefilter);
                    PRLEmployerDeductions.SetRange("Current Instalment",NoofInstalments);
                    if PRLPeriodTransactions.Find('-') then begin
                      end else CurrReport.Skip;

                    Gtoto:=PRLPeriodTransactions.Amount;//+PRLEmployerDeductions.Amount;
                end;
            }

            trigger OnPreDataItem()
            begin
                if datefilter=0D then Error('Specify the Period Date');
                Clear(Gtoto);
                "PRL-13thSlip Period Trans.".SetFilter("PRL-13thSlip Period Trans."."Payroll Period",'=%1',datefilter);

                "PRL-13thSlip Period Trans.".SetFilter("PRL-13thSlip Period Trans."."Current Instalment",'=%1',NoofInstalments);
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
                    TableRelation = "PRL-13thSlip Payroll Periods"."Date Openned";
                }
                field(NoofInstalments;NoofInstalments)
                {
                    ApplicationArea = Basic;
                    Caption = 'NoOfInstalments';
                    TableRelation = "PRL-13thSlip Payroll Periods"."Current Instalment";
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
        objPeriod.SetRange(objPeriod.Closed,false);
        if objPeriod.Find('-') then begin
        datefilter:=objPeriod."Date Openned";
          NoofInstalments:=objPeriod."Current Instalment";
          PeriodName:=objPeriod."Period Name";
          end;
        if CompanyInformation.Get() then
          CompanyInformation.CalcFields(CompanyInformation.Picture);
    end;

    var
        datefilter: Date;
        PRLPayrollPeriods: Record UnknownRecord99250;
        CompanyInformation: Record "Company Information";
        PRLPeriodTransactions: Record UnknownRecord99252;
        PRLEmployerDeductions: Record UnknownRecord99253;
        Gtoto: Decimal;
        PRLTransactionCodes: Record UnknownRecord61082;
        PeriodName: Code[30];
        objPeriod: Record UnknownRecord99250;
        NoofInstalments: Integer;
}

