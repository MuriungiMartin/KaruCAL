#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51144 "pr Bank Schedule"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/pr Bank Schedule.rdlc';

    dataset
    {
        dataitem(UnknownTable61077;UnknownTable61077)
        {
            DataItemTableView = sorting("Bank Code","Branch Code");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Bank Code","Branch Code","Period Filter";
            column(ReportForNavId_4233; 4233)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(USERID;UserId)
            {
            }
            column(prBank_Structure__Bank_Name_;"Bank Name")
            {
            }
            column(prBank_Structure__Branch_Name_;"Branch Name")
            {
            }
            column(prBank_Structure__prBank_Structure___KBA_Branch_Code_;"PRL-Bank Structure"."KBA Branch Code")
            {
            }
            column(GrantTotal;GrantTotal)
            {
            }
            column(Bank_ScheduleCaption;Bank_ScheduleCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(prBank_Structure__Bank_Name_Caption;FieldCaption("Bank Name"))
            {
            }
            column(prBank_Structure__Branch_Name_Caption;FieldCaption("Branch Name"))
            {
            }
            column(KBA_Branch_CodeCaption;KBA_Branch_CodeCaptionLbl)
            {
            }
            column(Period_TotalCaption;Period_TotalCaptionLbl)
            {
            }
            column(prBank_Structure_Bank_Code;"Bank Code")
            {
            }
            column(prBank_Structure_Branch_Code;"Branch Code")
            {
            }
            column(MainBank;"HRM-Employee (D)"."Main Bank")
            {
            }
            column(BranchBank;"HRM-Employee (D)"."Branch Bank")
            {
            }
            column(periodLabel;"PRL-Bank Structure".GetFilter("PRL-Bank Structure"."Period Filter"))
            {
            }
            column(period;period)
            {
            }
            column(perName;payper."Period Name")
            {
            }
            dataitem(UnknownTable61118;UnknownTable61118)
            {
                DataItemLink = "Branch Bank"=field("Branch Code"),"Main Bank"=field("Bank Code");
                DataItemTableView = where("Basic Pay"=filter(<>0));
                column(ReportForNavId_8631; 8631)
                {
                }
                column(HR_Employee__No__;"No.")
                {
                }
                column(HR_Employee___First_Name_______HR_Employee___Middle_Name_______HR_Employee___Last_Name_;"HRM-Employee (D)"."First Name"+' '+"HRM-Employee (D)"."Middle Name"+' '+"HRM-Employee (D)"."Last Name")
                {
                }
                column(HR_Employee__Bank_Account_Number_;"Bank Account Number")
                {
                }
                column(NPay;NPay)
                {
                }
                column(TNpay;TNpay)
                {
                }
                column(HR_Employee__No__Caption;FieldCaption("No."))
                {
                }
                column(Full_NamesCaption;Full_NamesCaptionLbl)
                {
                }
                column(HR_Employee__Bank_Account_Number_Caption;FieldCaption("Bank Account Number"))
                {
                }
                column(Net_PayCaption;Net_PayCaptionLbl)
                {
                }
                column(TotalCaption;TotalCaptionLbl)
                {
                }
                column(HR_Employee_Branch_Bank;"Branch Bank")
                {
                }
                column(HR_Employee_Main_Bank;"Main Bank")
                {
                }
                column(KBA_Code;"PRL-Bank Structure"."Bank Code"+"PRL-Bank Structure"."Branch Code")
                {
                }

                trigger OnAfterGetRecord()
                begin
                      PeriodTRans.Reset;
                      PeriodTRans.SetRange(PeriodTRans."Employee Code","HRM-Employee (D)"."No.");
                      PeriodTRans.SetRange(PeriodTRans."Transaction Code",'NPAY');
                      PeriodTRans.SetFilter(PeriodTRans."Payroll Period",'=%1',period);
                      if PeriodTRans.Find('-') then begin
                        Clear(NPay);
                        NPay:=PeriodTRans.Amount;
                      end;


                    TNpay:=TNpay+NPay;
                    GrantTotal:=GrantTotal+NPay;
                end;

                trigger OnPreDataItem()
                begin
                     PeriodTRans.Reset;
                      PeriodTRans.SetFilter(PeriodTRans."Employee Code","HRM-Employee (D)"."No.");
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(PerFilter;period)
                {
                    ApplicationArea = Basic;
                    Caption = 'Pay Period';
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
        //objPeriod.RESET;
        //objPeriod.SETRANGE(objPeriod.Closed,FALSE);
        //IF objPeriod.FIND('-') THEN;
        //period:=objPeriod."Date Opened";
    end;

    trigger OnPreReport()
    begin
        if period=0D then Error('Error!\Specify the period.');

        payper.Reset;
        payper.SetRange(payper."Date Opened",period);
        if payper.Find('-') then begin
        end;
    end;

    var
        PeriodTRans: Record UnknownRecord61092;
        NPay: Decimal;
        TNpay: Decimal;
        GrantTotal: Decimal;
        Bank_ScheduleCaptionLbl: label 'Bank Schedule';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        KBA_Branch_CodeCaptionLbl: label 'KBA Branch Code';
        Period_TotalCaptionLbl: label 'Period Total';
        Full_NamesCaptionLbl: label 'Full Names';
        Net_PayCaptionLbl: label 'Net Pay';
        TotalCaptionLbl: label 'Total';
        period: Date;
        payper: Record UnknownRecord61081;
        objPeriod: Record UnknownRecord61081;
        emplName: Text;
        empCode: Code[20];
}

