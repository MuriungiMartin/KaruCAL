#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 99257 "13thSlips Summary Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/13thSlips Summary Report.rdlc';

    dataset
    {
        dataitem(UnknownTable99200;UnknownTable99200)
        {
            DataItemTableView = sorting("Employee Code","Payroll Period","Current Instalment") order(ascending);
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Employee Code";
            column(ReportForNavId_6207; 6207)
            {
            }
            column(COMPANYNAME;ControlInfo.Name)
            {
            }
            column(CompanyInfo_Picture;CompanyInfo.Picture)
            {
            }
            column(HR_Employee_No_;emp1."No.")
            {
            }
            column(empNo;objEmp."No.")
            {
            }
            column(DWorked;"PRl 13thSlip DaysComp"."Days Worked")
            {
            }
            column(PMonth;"PRl 13thSlip DaysComp"."Period Month")
            {
            }
            column(PYear;"PRl 13thSlip DaysComp"."Period Year")
            {
            }
            column(DRate;"PRl 13thSlip DaysComp"."Daily Rate")
            {
            }
            column(strEmpName;strEmpName)
            {
            }
            column(PeriodName;PeriodName)
            {
            }
            column(AcNo;objEmp."Bank Account Number")
            {
            }
            dataitem(UnknownTable99252;UnknownTable99252)
            {
                DataItemLink = "Employee Code"=field("Employee Code"),"Payroll Period"=field("Payroll Period"),"Current Instalment"=field("Current Instalment");
                DataItemTableView = where("Group Text"=filter(<>TAXATION));
                column(ReportForNavId_1000000006; 1000000006)
                {
                }
                column(TransCode;"PRL-13thSlip Period Trans."."Transaction Code")
                {
                }
                column(TransName;"PRL-13thSlip Period Trans."."Transaction Name")
                {
                }
                column(TransAmount;"PRL-13thSlip Period Trans.".Amount)
                {
                }
                column(GrpOrder;"PRL-13thSlip Period Trans."."Group Order")
                {
                }
                column(SubGOrder;"PRL-13thSlip Period Trans."."Sub Group Order")
                {
                }
                column(DeptName;Dimm.Name)
                {
                }
                column(DeptCode;Dimm.Code)
                {
                }
            }

            trigger OnAfterGetRecord()
            begin


                objPeriod.Reset;
                objPeriod.SetRange("Date Openned",SelectedPeriod);
                objPeriod.SetRange("Current Instalment",InstalmentNo);
                if objPeriod.Find('-') then begin
                end;

                emp1.Reset;
                emp1.SetRange(emp1."No.","PRl 13thSlip DaysComp"."Employee Code");
                if emp1.Find('-') then begin
                end;
                objEmp.Reset;
                objEmp.SetRange(objEmp."No.","PRl 13thSlip DaysComp"."Employee Code");
                if objEmp.Find('-') then
                begin
                if  objEmp."Department Code" <> ''  then begin
                    Dimm.Reset;
                    Dimm.SetRange(Dimm."Dimension Code",'COST CENTERS');
                    Dimm.SetRange(Dimm.Code,objEmp."Department Code");
                    if Dimm.Find('-') then begin
                     dept:=Dimm.Name;
                    end;
                end;
                   //strEmpName:='['+objEmp."No."+'] '+objEmp."Last Name"+' '+objEmp."First Name"+' '+objEmp."Middle Name";
                   strEmpName:=objEmp."Last Name"+' '+objEmp."First Name"+' '+objEmp."Middle Name";


                //Get the staff banks in the payslip -
                //***************************************************
                  strBankno:=objEmp."Main Bank";
                  strBranchno:=objEmp."Branch Bank";
                  bankStruct.SetRange(bankStruct."Bank Code",strBankno);
                  bankStruct.SetRange(bankStruct."Branch Code",strBranchno);
                  if bankStruct.Find('-') then
                    begin
                      //strAccountNo:=objEmp."Bank Account Number";
                    //  strBank:=bankStruct."Bank Name";
                     // strBranch:=bankStruct."Branch Name";
                    end;
                //*************************************************************************************************

                end;



                  strEmpCode:=objEmp."No.";
            end;

            trigger OnPreDataItem()
            begin
                SelectedPeriod:=PeriodFilter;


                PeriodTrans.Reset;
                PeriodTrans.SetRange(PeriodTrans."Employee Code","PRl 13thSlip DaysComp"."Employee Code");
                PeriodTrans.SetRange(PeriodTrans."Payroll Period",SelectedPeriod);
                PeriodTrans.SetRange("Current Instalment",InstalmentNo);
                if not PeriodTrans.Find('-') then
                  begin
                    end;
                 //CurrReport.SKIP;




                "PRl 13thSlip DaysComp".SetFilter("PRl 13thSlip DaysComp"."Payroll Period",'=%1',PeriodFilter);

                "PRl 13thSlip DaysComp".SetFilter("PRl 13thSlip DaysComp"."Current Instalment",'=%1',InstalmentNo);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(periodfilter;PeriodFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Period Filter';
                    TableRelation = "PRL-13thSlip Payroll Periods"."Date Openned";
                }
                field(InstalmentNo;InstalmentNo)
                {
                    ApplicationArea = Basic;
                    Caption = 'Instalment';
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
        objPeriod.SetRange(objPeriod.Closed,false);
        //objPeriod.SETRANGE("Payroll Code",'%1|%2','13thSlip','13thSlipS');
        if objPeriod.Find('-') then begin
          InstalmentNo:=objPeriod."Current Instalment";
        PeriodFilter:=objPeriod."Date Openned";
          PeriodName:=objPeriod."Period Name"+' ('+(Format(objPeriod."Current Instalment"))+(Format(objPeriod."Period Instalment Prefix"))+' Instalment)';
          end;
    end;

    trigger OnPreReport()
    begin



        if CompanyInfo.Get() then
        CompanyInfo.CalcFields(CompanyInfo.Picture);
        if PeriodFilter=0D then Error('You must specify the period filter');
    end;

    var
        emp1: Record UnknownRecord61188;
        Addr: array [2,10] of Text[250];
        intInfo: Integer;
        PeriodTrans: Record UnknownRecord99252;
        objEmp: Record UnknownRecord61118;
        strEmpName: Text[250];
        strGrpText: Text[100];
        PeriodName: Text[50];
        PeriodFilter: Date;
        SelectedPeriod: Date;
        objPeriod: Record UnknownRecord99250;
        dtDOE: Date;
        strEmpCode: Text[50];
        ControlInfo: Record UnknownRecord61119;
        dept: Text[100];
        bankStruct: Record UnknownRecord61077;
        emploadva: Record UnknownRecord99252;
        strBankno: Text[50];
        strBranchno: Text[50];
        CompanyInfo: Record "Company Information";
        objOcx: Codeunit "prPayrollProcessing 13thSlip";
        Dimm: Record "Dimension Value";
        Employee_CaptionLbl: label 'Employee:';
        EmptyStringCaptionLbl: label '..................................................';
        Department_CaptionLbl: label 'Department:';
        Period_CaptionLbl: label 'Period:';
        P_I_N_No_CaptionLbl: label '.............EMPLOYEE DETAIL..........';
        Employee_Caption_Control1102755158Lbl: label 'Employee:';
        Department_Caption_Control1102755159Lbl: label 'Department:';
        Period_Caption_Control1102755163Lbl: label 'Period:';
        P_I_N_No_Caption_Control1102755165Lbl: label 'P.I.N No:';
        EmptyStringCaption_Control1102755166Lbl: label '..................................................';
        BALANCECaptionLbl: label 'BALANCE';
        AMOUNTCaptionLbl: label 'AMOUNT';
        AMOUNTCaption_Control1102755320Lbl: label 'AMOUNT';
        BALANCECaption_Control1102755321Lbl: label 'BALANCE';
        InstalmentNo: Integer;
        AccNo: Code[20];
}

