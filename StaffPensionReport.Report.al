#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51099 "Staff Pension Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Staff Pension Report.rdlc';

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

            trigger OnAfterGetRecord()
            begin
                PeriodTrans.Reset;
                PeriodTrans.SetRange(PeriodTrans."Employee Code","PRL-Period Transactions"."Employee Code");
                PeriodTrans.SetRange(PeriodTrans."Payroll Period",SelectedPeriod);
                PeriodTrans.SetRange(PeriodTrans."Transaction Code",'690');
                if not PeriodTrans.Find('-') then CurrReport.Skip;

                Clear(EmployeeName);
                Clear(BasicPay);
                Clear(SelfContrib);
                Clear(CompanyContrib);
                Clear(CummContrib);
                Clear(TransAmount);
                Clear(Transcode);
                Clear(TransIndx);
                Clear(Gross);
                Clear(Hsy1);
                Clear(hsl2);

                objEmp.Reset;
                objEmp.SetRange(objEmp."No.","PRL-Period Transactions"."Employee Code");
                if objEmp.Find('-') then
                  EmployeeName:=objEmp."First Name"+' '+objEmp."Middle Name"+' '+objEmp."Last Name";
                Gender:=objEmp.Gender;
                if objEmp."Date Of Birth"<>0D then
                Dates:=objEmp."Date Of Birth";

                if "PRL-Period Transactions"."Transaction Code"='BPAY' then begin
                  TransAmount:="PRL-Period Transactions".Amount;
                  Transcode:='BASIC';
                  TransIndx:=1;
                  end else if  "PRL-Period Transactions"."Transaction Code"='690' then begin
                  TransAmount:="PRL-Period Transactions".Amount;
                  Transcode:='PENSION SELF';
                  TransIndx:=2;
                  end else if  "PRL-Period Transactions"."Transaction Code"='NPAY' then begin
                //Cipmpute Sompany contribution
                    PeriodTrans.Reset;
                PeriodTrans.SetRange(PeriodTrans."Employee Code","PRL-Period Transactions"."Employee Code");
                PeriodTrans.SetRange(PeriodTrans."Payroll Period",SelectedPeriod);
                PeriodTrans.SetRange(PeriodTrans."Transaction Code",'690');
                if PeriodTrans.Find('-') then begin
                  TransAmount:=(PeriodTrans.Amount*2);
                  Transcode:='COMP. CONTRIB.';
                  TransIndx:=3;
                  end;

                  end else if  "PRL-Period Transactions"."Transaction Code"='GPAY' then begin
                    //Get the Basic pay
                BasicPay:=0;
                PeriodTrans.Reset;
                PeriodTrans.SetRange(PeriodTrans."Employee Code","Employee Code");
                PeriodTrans.SetRange(PeriodTrans."Payroll Period",SelectedPeriod);
                PeriodTrans.SetFilter(PeriodTrans."Transaction Code",'BPAY');
                if PeriodTrans.Find('-') then
                    begin
                       BasicPay:=PeriodTrans.Amount;
                    end;
                    // SelfCont
                    SelfContrib:=0;
                PeriodTrans.Reset;
                PeriodTrans.SetRange(PeriodTrans."Employee Code","Employee Code");
                PeriodTrans.SetRange(PeriodTrans."Payroll Period",SelectedPeriod);
                PeriodTrans.SetRange(PeriodTrans."Transaction Code",'690');
                if PeriodTrans.Find('-') then
                    begin
                       SelfContrib:=PeriodTrans.Amount;
                    end;

                  TransAmount:=((SelfContrib*2)+SelfContrib);
                  Transcode:='CUMM. CONT.';
                  TransIndx:=4;
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
        Transcode: Code[20];
        TransIndx: Integer;
        datefilter: Date;
        Hsy1: Decimal;
        hsl2: Decimal;
        Gross: Decimal;
}

