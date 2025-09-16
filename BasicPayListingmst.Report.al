#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51752 "Basic Pay Listing mst"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Basic Pay Listing mst.rdlc';

    dataset
    {
        dataitem(UnknownTable61118;UnknownTable61118)
        {
            DataItemTableView = sorting("No.") where(Status=const(Normal));
            column(ReportForNavId_8631; 8631)
            {
            }
            column(GETFILTERS;GetFilters)
            {
            }
            column(USERID;UserId)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(cHeader_1_;cHeader[1])
            {
            }
            column(cHeader_2_;cHeader[2])
            {
            }
            column(CompanyInfo_Picture;CompanyInfo.Picture)
            {
            }
            column(strEmpName;strEmpName)
            {
            }
            column(HR_Employee__HR_Employee___No__;"HRM-Employee (D)"."No.")
            {
            }
            column(cValue_1_;cValue[1])
            {
            }
            column(cValue_2_;cValue[2])
            {
            }
            column(cValue_2__Control1102755065;cValue[2])
            {
            }
            column(cValue_1__Control1102755066;cValue[1])
            {
            }
            column(RCount;RCount)
            {
            }
            column(Employee_NameCaption;Employee_NameCaptionLbl)
            {
            }
            column(Employee_CodeCaption;Employee_CodeCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Basic_Pay___Gross_Pay_ScheduleCaption;Basic_Pay___Gross_Pay_ScheduleCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                strEmpName:="Last Name"+' '+"First Name"+' '+"Middle Name";

                i:=1;
                repeat
                i:=i+1;
                cValue[i]:=0;
                until i = 6;

                Trans.Reset;
                Trans.SetFilter(Trans."Transaction Code",'BPAY|GPAY|NPAY');
                //Trans.SETFILTER(Trans."Current Month Filter","HRM-Employee (D)".GETFILTER("Current Month Filter"));
                //Trans.SETFILTER(Trans."Employee Code Filter","HRM-Employee (D)"."No.");
                if Trans.Find('-') then begin
                repeat
                //Trans.CALCFIELDS("Curr. Amount");
                //Basic Pay
                cHeader[1]:='Basic Pay';
                if Trans."Transaction Code" = 'BPAY' then begin
                //cValue[1]:=Trans."Curr. Amount";
                end;

                //Housing
                cHeader[2]:='Gross Pay';
                if Trans."Transaction Code" = 'GPAY' then begin
                //cValue[2]:=cValue[2]+Trans."Curr. Amount";
                end;

                //Transport
                cHeader[3]:='Net Pay';
                if Trans."Transaction Code" = 'NPAY' then begin
                //cValue[3]:=cValue[3]+Trans."Curr. Amount";
                end;


                until Trans.Next = 0;

                end;


                if (cValue[2] = 0) then
                CurrReport.Skip;

                RCount:=RCount+1;
            end;

            trigger OnPreDataItem()
            begin
                if "HRM-Employee (D)".GetFilter("HRM-Employee (D)"."Current Month Filter") = '' then
                Error('You must specify current Period filter.');

                CurrReport.CreateTotals(cValue[1],cValue[2],cValue[3],cValue[4],cValue[5],cValue[6],cValue[7],cValue[8],cValue[9],cValue[10]);
                CurrReport.CreateTotals(cValue[11],cValue[12],cValue[13],cValue[14],cValue[15],cValue[16],cValue[17]);
                CurrReport.CreateTotals(cValue[18],cValue[19],cValue[20]);

                //IF VitalInfo.GET('') THEN
                //NISTFRate:=VitalInfo."NISTF % of Basic Pay";

                if CompanyInfo.Get() then
                CompanyInfo.CalcFields(CompanyInfo.Picture);
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        strEmpName: Text[100];
        cHeader: array [200] of Text[200];
        cValue: array [200] of Decimal;
        Trans: Record UnknownRecord61082;
        ColNo: Integer;
        i: Integer;
        RCount: Integer;
        VitalInfo: Record UnknownRecord61104;
        NISTFRate: Decimal;
        SalaryGrades: Record UnknownRecord61120;
        CompanyInfo: Record "Company Information";
        Employee_NameCaptionLbl: label 'Employee Name';
        Employee_CodeCaptionLbl: label 'Employee Code';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Basic_Pay___Gross_Pay_ScheduleCaptionLbl: label 'Basic Pay & Gross Pay Schedule';
}

