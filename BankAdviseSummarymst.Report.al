#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51756 "Bank Advise Summary mst"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Bank Advise Summary mst.rdlc';

    dataset
    {
        dataitem(UnknownTable61077;UnknownTable61077)
        {
            DataItemTableView = sorting("Bank Code","Branch Code");
            column(ReportForNavId_4233; 4233)
            {
            }
            column(GETFILTERS_;GetFilters )
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
            column(CompanyInfo_Picture;CompanyInfo.Picture)
            {
            }
            column(NetAmount;NetAmount)
            {
            }
            column(RCount;RCount)
            {
            }
            column(prBank_Structure__Branch_Name_;"Branch Name")
            {
            }
            column(prBank_Structure__Bank_Name_;"Bank Name")
            {
            }
            column(TCount;TCount)
            {
            }
            column(NetAmount_Control1102755006;NetAmount)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Bank_Advice_SummaryCaption;Bank_Advice_SummaryCaptionLbl)
            {
            }
            column(Bank_NameCaption;Bank_NameCaptionLbl)
            {
            }
            column(Bank_BranchCaption;Bank_BranchCaptionLbl)
            {
            }
            column(No__Of_EmployeesCaption;No__Of_EmployeesCaptionLbl)
            {
            }
            column(Net_AmountCaption;Net_AmountCaptionLbl)
            {
            }
            column(Signature___DateCaption;Signature___DateCaptionLbl)
            {
            }
            column(NameCaption;NameCaptionLbl)
            {
            }
            column(EmptyStringCaption;EmptyStringCaptionLbl)
            {
            }
            column(EmptyStringCaption_Control1102755017;EmptyStringCaption_Control1102755017Lbl)
            {
            }
            column(Signature___DateCaption_Control1102755018;Signature___DateCaption_Control1102755018Lbl)
            {
            }
            column(NameCaption_Control1102755019;NameCaption_Control1102755019Lbl)
            {
            }
            column(EmptyStringCaption_Control1102755020;EmptyStringCaption_Control1102755020Lbl)
            {
            }
            column(EmptyStringCaption_Control1102755028;EmptyStringCaption_Control1102755028Lbl)
            {
            }
            column(NameCaption_Control1102755029;NameCaption_Control1102755029Lbl)
            {
            }
            column(Signature___DateCaption_Control1102755030;Signature___DateCaption_Control1102755030Lbl)
            {
            }
            column(EmptyStringCaption_Control1102755031;EmptyStringCaption_Control1102755031Lbl)
            {
            }
            column(EmptyStringCaption_Control1102755032;EmptyStringCaption_Control1102755032Lbl)
            {
            }
            column(Prepared_by_Caption;Prepared_by_CaptionLbl)
            {
            }
            column(Authorised_by_Caption;Authorised_by_CaptionLbl)
            {
            }
            column(Approved_by_Caption;Approved_by_CaptionLbl)
            {
            }
            column(prBank_Structure_Bank_Code;"Bank Code")
            {
            }
            column(prBank_Structure_Branch_Code;"Branch Code")
            {
            }

            trigger OnAfterGetRecord()
            begin
                RCount:=0;
                TCount:=0;
                NetAmount:=0;

                Employee.Reset;
                Employee.SetRange(Employee."Main Bank","prBank Structure"."Bank Code");
                //Employee.SETRANGE(Employee."Branch Bank","prBank Structure"."Branch Code");
                Employee.SetFilter("Current Month Filter","prBank Structure".GetFilter("prBank Structure"."Current Month Filter"));
                Employee.SetFilter("Location/Division Code","prBank Structure".GetFilter("prBank Structure"."Location/Division Filter"));
                Employee.SetFilter("Department Code","prBank Structure".GetFilter("prBank Structure"."Department Filter"));
                Employee.SetFilter("Employee Classification","prBank Structure".GetFilter("prBank Structure"."Employee Classification"));

                //Employee.SETFILTER("Cost Center Code","prBank Structure".GETFILTER("prBank Structure"."Cost Centre Filter"));
                //Employee.SETFILTER("Salary Grade","prBank Structure".GETFILTER("prBank Structure"."Salary Grade Filter"));
                //Employee.SETFILTER("Salary Notch/Step","prBank Structure".GETFILTER("prBank Structure"."Salary Notch Filter"));
                if Employee.Find('-') then begin
                repeat
                Employee.CalcFields(Employee."Net Pay");
                if Employee."Net Pay" > 0 then begin
                RCount:=RCount+1;
                TCount:=TCount+1;
                NetAmount:=NetAmount+Employee."Net Pay";
                end;
                until Employee.Next = 0;
                end;
            end;

            trigger OnPreDataItem()
            begin
                if "prBank Structure".GetFilter("Current Month Filter") = '' then
                Error('You must specify current Period filter.');

                CurrReport.CreateTotals(NetAmount);

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
        EmployeeName: Text[200];
        bankStruct: Record UnknownRecord61077;
        bankAcc: Text[50];
        BranchBankNM: Text[100];
        mainBankNM: Text[100];
        RCount: Integer;
        NetAmount: Decimal;
        Employee: Record UnknownRecord61118;
        TCount: Integer;
        CompanyInfo: Record "Company Information";
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Bank_Advice_SummaryCaptionLbl: label 'Bank Advice Summary';
        Bank_NameCaptionLbl: label 'Bank Name';
        Bank_BranchCaptionLbl: label 'Bank Branch';
        No__Of_EmployeesCaptionLbl: label 'No. Of Employees';
        Net_AmountCaptionLbl: label 'Net Amount';
        Signature___DateCaptionLbl: label 'Signature & Date';
        NameCaptionLbl: label 'Name';
        EmptyStringCaptionLbl: label '......................................................................................................................................................';
        EmptyStringCaption_Control1102755017Lbl: label '......................................................................................................................................................';
        Signature___DateCaption_Control1102755018Lbl: label 'Signature & Date';
        NameCaption_Control1102755019Lbl: label 'Name';
        EmptyStringCaption_Control1102755020Lbl: label '......................................................................................................................................................';
        EmptyStringCaption_Control1102755028Lbl: label '......................................................................................................................................................';
        NameCaption_Control1102755029Lbl: label 'Name';
        Signature___DateCaption_Control1102755030Lbl: label 'Signature & Date';
        EmptyStringCaption_Control1102755031Lbl: label '......................................................................................................................................................';
        EmptyStringCaption_Control1102755032Lbl: label '......................................................................................................................................................';
        Prepared_by_CaptionLbl: label 'Prepared by:';
        Authorised_by_CaptionLbl: label 'Authorised by:';
        Approved_by_CaptionLbl: label 'Approved by:';
}

