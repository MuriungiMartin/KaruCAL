#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51194 "House Levy Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/House Levy Report.rdlc';

    dataset
    {
        dataitem(UnknownTable61092;UnknownTable61092)
        {
            DataItemTableView = where("Transaction Code"=filter(BPAY|GPAY|NPAY|690));
            RequestFilterFields = "Employee Code";
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
            column(Companyinfo_Picture;Companyinfo.Picture)
            {
            }
            column(TransAmount;TransAmount)
            {
            }
            column(Transcode;Transcode)
            {
            }
            column(Id;objEmp."ID Number")
            {
            }
            column(KraPin;objEmp."PIN Number")
            {
            }
            column(TransIndx;TransIndx)
            {
            }
            column(EmployeeName;EmployeeName)
            {
            }
            column(Gender;Format(objEmp.Gender))
            {
            }
            column(Date;Dates)
            {
            }
            column(empcode;"PRL-Period Transactions"."Employee Code")
            {
            }
            column(SelectedPeriod;SelectedPeriod)
            {
            }
            column(IDNoS;objEmp."ID Number")
            {
            }
            column(PinNumber;objEmp."PIN Number")
            {
            }
            column(GrossPay;Gpay)
            {
            }
            column(HouseLevy;HousingLevy)
            {
            }

            trigger OnAfterGetRecord()
            begin
                /*PeriodTrans.RESET;
                PeriodTrans.SETRANGE(PeriodTrans."Employee Code","PRL-Period Transactions"."Employee Code");
                PeriodTrans.SETRANGE(PeriodTrans."Payroll Period",SelectedPeriod);
                PeriodTrans.SETRANGE(PeriodTrans."Transaction Code",'996');
                IF NOT PeriodTrans.FIND('-') THEN CurrReport.SKIP;
                
                CLEAR(EmployeeName);
                CLEAR(BasicPay);
                CLEAR(SelfContrib);
                CLEAR(CompanyContrib);
                CLEAR(CummContrib);
                CLEAR(HousingLevy);
                CLEAR(TransAmount);
                CLEAR(Transcode);
                CLEAR(TransIndx);
                
                objEmp.RESET;
                objEmp.SETRANGE(objEmp."No.","PRL-Period Transactions"."Employee Code");
                objEmp.SETRANGE(objEmp.Status,objEmp.Status::Normal);
                IF objEmp.FIND('-') THEN
                  EmployeeName:=objEmp."First Name"+' '+objEmp."Middle Name"+' '+objEmp."Last Name";
                 PeriodTrans2.RESET;
                PeriodTrans2.SETRANGE(PeriodTrans2."Employee Code","PRL-Period Transactions"."Employee Code");
                PeriodTrans2.SETRANGE(PeriodTrans2."Payroll Period",SelectedPeriod);
                PeriodTrans2.SETRANGE(PeriodTrans2."Transaction Code",'996');
                IF PeriodTrans2.FIND('-') THEN BEGIN
                  TransAmount:=PeriodTrans2.Amount;
                 // TransAmount:=HousingLevy;
                  Transcode:='HOUSING LEVY EMPOYER';
                  TransIndx:=3;
                
                IF "PRL-Period Transactions"."Transaction Code"='GPAY' THEN BEGIN
                  TransAmount:="PRL-Period Transactions".Amount;
                  Transcode:='GROSS';
                  TransIndx:=1;
                
                
                END ELSE IF  "PRL-Period Transactions"."Transaction Code"='NPAY' THEN BEGIN
                    PeriodTrans.RESET;
                PeriodTrans.SETRANGE(PeriodTrans."Employee Code","PRL-Period Transactions"."Employee Code");
                PeriodTrans.SETRANGE(PeriodTrans."Payroll Period",SelectedPeriod);
                PeriodTrans.SETRANGE(PeriodTrans."Transaction Code",'996');
                IF PeriodTrans.FIND('-') THEN BEGIN
                  TransAmount:=PeriodTrans.Amount;
                  Transcode:='HOUSING  LEVY EMPOYEE';
                  TransIndx:=2;
                
                
                
                
                
                END;
                
                END;
                END;*/
                PeriodTrans.Reset;
                PeriodTrans.SetRange(PeriodTrans."Employee Code","PRL-Period Transactions"."Employee Code");
                PeriodTrans.SetRange(PeriodTrans."Payroll Period",SelectedPeriod);
                PeriodTrans.SetRange(PeriodTrans."Transaction Code",'996');
                if not PeriodTrans.Find('-') then CurrReport.Skip;
                
                Clear(EmployeeName);
                Clear(BasicPay);
                Clear(SelfContrib);
                Clear(CompanyContrib);
                Clear(CummContrib);
                Clear(HousingLevy);
                Clear(TransAmount);
                Clear(Transcode);
                Clear(TransIndx);
                Clear(Gross);
                
                objEmp.Reset;
                objEmp.SetRange(objEmp."No.","PRL-Period Transactions"."Employee Code");
                objEmp.SetRange(objEmp.Status,objEmp.Status::Normal);
                if objEmp.Find('-') then
                  EmployeeName:=objEmp."First Name"+' '+objEmp."Middle Name"+' '+objEmp."Last Name";
                 PeriodTrans2.Reset;
                PeriodTrans2.SetRange(PeriodTrans2."Employee Code","PRL-Period Transactions"."Employee Code");
                PeriodTrans2.SetRange(PeriodTrans2."Payroll Period",SelectedPeriod);
                PeriodTrans2.SetRange(PeriodTrans2."Transaction Code",'996');
                if PeriodTrans2.Find('-') then begin
                HousingLevy:=PeriodTrans2.Amount;
                end;
                PeriodTrans2.Reset;
                PeriodTrans2.SetRange(PeriodTrans2."Employee Code","PRL-Period Transactions"."Employee Code");
                PeriodTrans2.SetRange(PeriodTrans2."Payroll Period",SelectedPeriod);
                PeriodTrans2.SetRange(PeriodTrans2."Transaction Code",'GPAY');
                if PeriodTrans2.Find('-') then begin
                Gross:=PeriodTrans2.Amount;
                end;
                  objTransCode.Reset;
                  objTransCode.SetFilter(objTransCode."Hsl Excluded",'%1',true);
                  if objTransCode.Find('-') then begin
                  PeriodTrans2.Reset;
                  PeriodTrans2.SetRange(PeriodTrans2."Employee Code","PRL-Period Transactions"."Employee Code");
                  PeriodTrans2.SetRange(PeriodTrans2."Payroll Period",SelectedPeriod);
                  PeriodTrans2.SetRange(PeriodTrans2."Transaction Code",objTransCode."Transaction Code");
                  if PeriodTrans2.Find('-') then begin
                  PeriodTrans2.CalcSums(Amount);
                  ExcludedAmount:=PeriodTrans2.Amount;
                  end;
                  HslGross:=Gross-ExcludedAmount;
                
                  end;

            end;

            trigger OnPreDataItem()
            begin
                "PRL-Period Transactions".SetFilter("PRL-Period Transactions"."Payroll Period",'=%1',SelectedPeriod);
                if "PRL-Period Transactions".Find('-') then begin
                  end;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(PerFilter;SelectedPeriod)
                {
                    ApplicationArea = Basic;
                    Caption = 'Period Filter';
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
        objPeriod.Reset;
        objPeriod.SetRange(Closed,false);
        if objPeriod.Find('+') then begin
          SelectedPeriod:=objPeriod."Date Opened";
          end;
    end;

    trigger OnPreReport()
    begin

        if SelectedPeriod=0D then Error('You must specify the period filter');

        objPeriod.Reset;
        if objPeriod.Get(SelectedPeriod) then PeriodName:=objPeriod."Period Name";

        if Companyinfo.Get() then
        Companyinfo.CalcFields(Companyinfo.Picture);
    end;

    var
        PeriodTrans: Record UnknownRecord61092;
        BasicPay: Decimal;
        SelfContrib: Decimal;
        CompanyContrib: Decimal;
        CummContrib: Decimal;
        EmployeeName: Text[50];
        objEmp: Record UnknownRecord61118;
        objPeriod: Record UnknownRecord61081;
        SelectedPeriod: Date;
        PeriodName: Text[30];
        objTransCode: Record UnknownRecord61082;
        Companyinfo: Record "Company Information";
        Employee_Employer_Pension_ContributionCaptionLbl: label 'Employee/Employer Pension Contribution';
        Self_Contribution_CaptionLbl: label 'Self Contribution:';
        Company_Contrib_CaptionLbl: label 'Company Contrib:';
        Cumm_Contribution_CaptionLbl: label 'Cumm Contribution:';
        Basic_Pay_CaptionLbl: label 'Basic Pay:';
        User_Name_CaptionLbl: label 'User Name:';
        Print_Date_CaptionLbl: label 'Print Date:';
        Period_CaptionLbl: label 'Period:';
        Page_No_CaptionLbl: label 'Page No:';
        Prepared_by_______________________________________Date_________________CaptionLbl: label 'Prepared by……………………………………………………..                 Date……………………………………………';
        Checked_by________________________________________Date_________________CaptionLbl: label 'Checked by…………………………………………………..                   Date……………………………………………';
        Authorized_by____________________________________Date_________________CaptionLbl: label 'Authorized by……………………………………………………..              Date……………………………………………';
        Approved_by______________________________________Date_________________CaptionLbl: label 'Approved by……………………………………………………..                Date……………………………………………';
        Totals_CaptionLbl: label 'Totals:';
        compCont: Decimal;
        salArreas: Decimal;
        Dates: Date;
        Gender: Option;
        TransAmount: Decimal;
        Transcode: Code[30];
        TransIndx: Integer;
        datefilter: Date;
        Gpay: Decimal;
        HousingLevy: Decimal;
        PeriodTrans2: Record UnknownRecord61092;
        ExcludedAmount: Decimal;
        Gross: Decimal;
        HslGross: Decimal;
}

