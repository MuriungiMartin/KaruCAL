#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51763 "Bank Payment Schedule-cash mst"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Bank Payment Schedule-cash mst.rdlc';

    dataset
    {
        dataitem(UnknownTable61118;UnknownTable61118)
        {
            DataItemTableView = sorting("Department Code") where("Bank Account Number"=filter(""),Status=filter(<>Resigned));
            RequestFilterFields = "Current Month Filter","Location/Division Code","Department Code","Cost Center Code","Salary Grade","Salary Notch/Step","Employee Classification","Bank Account Number";
            column(ReportForNavId_8631; 8631)
            {
            }
            column(BranchBankNM;BranchBankNM)
            {
            }
            column(EmployeeName;EmployeeName)
            {
            }
            column(HR_Employee__HR_Employee___Net_Pay_;"HR-Employee"."Net Pay")
            {
            }
            column(bankAcc;bankAcc)
            {
            }
            column(mainBankNM;mainBankNM)
            {
            }
            column(HR_Employee__HR_Employee___No__;"HR-Employee"."No.")
            {
            }
            column(HR_Employee__Account_Type_;"Account Type")
            {
            }
            column(HR_Employee__HR_Employee___Net_Pay__Control1102755001;"HR-Employee"."Net Pay")
            {
            }
            column(RCount;RCount)
            {
            }
            column(Prepared_by_Caption;Prepared_by_CaptionLbl)
            {
            }
            column(NameCaption;NameCaptionLbl)
            {
            }
            column(EmptyStringCaption;EmptyStringCaptionLbl)
            {
            }
            column(EmptyStringCaption_Control1102755035;EmptyStringCaption_Control1102755035Lbl)
            {
            }
            column(Authorised_by_Caption;Authorised_by_CaptionLbl)
            {
            }
            column(NameCaption_Control1102755037;NameCaption_Control1102755037Lbl)
            {
            }
            column(EmptyStringCaption_Control1102755038;EmptyStringCaption_Control1102755038Lbl)
            {
            }
            column(Approved_by_Caption;Approved_by_CaptionLbl)
            {
            }
            column(NameCaption_Control1102755040;NameCaption_Control1102755040Lbl)
            {
            }
            column(Signature___DateCaption;Signature___DateCaptionLbl)
            {
            }
            column(EmptyStringCaption_Control1102755042;EmptyStringCaption_Control1102755042Lbl)
            {
            }
            column(Signature___DateCaption_Control1102755043;Signature___DateCaption_Control1102755043Lbl)
            {
            }
            column(EmptyStringCaption_Control1102755044;EmptyStringCaption_Control1102755044Lbl)
            {
            }
            column(Signature___DateCaption_Control1102755045;Signature___DateCaption_Control1102755045Lbl)
            {
            }
            column(EmptyStringCaption_Control1102755046;EmptyStringCaption_Control1102755046Lbl)
            {
            }
            column(HR_Employee_Main_Bank;"Main Bank")
            {
            }
            column(HR_Employee_Branch_Bank;"Branch Bank")
            {
            }
            column(DepartmentCode_HREmployee;"Location/Division Code")
            {
            }
            column(GETFILTERS__________HR_Employee__GETFILTERS;GetFilters + ' ' + "HR-Employee".GetFilters)
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
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Bank_Payment_ScheduleCaption;Bank_Payment_ScheduleCaptionLbl)
            {
            }
            column(Net_AmountCaption;Net_AmountCaptionLbl)
            {
            }
            column(Account_No_Caption;Account_No_CaptionLbl)
            {
            }
            column(Bank_BranchCaption;Bank_BranchCaptionLbl)
            {
            }
            column(Employee_BankCaption;Employee_BankCaptionLbl)
            {
            }
            column(Employee_NameCaption;Employee_NameCaptionLbl)
            {
            }
            column(BankCaption;BankCaptionLbl)
            {
            }
            column(BranchCaption;BranchCaptionLbl)
            {
            }
            column(No_Caption;No_CaptionLbl)
            {
            }
            column(HR_Employee__Account_Type_Caption;"HR-Employee".FieldCaption("Account Type"))
            {
            }

            trigger OnAfterGetRecord()
            begin
                  EmployeeName:="First Name"+' '+"Middle Name"+' '+"Last Name";
                  bankAcc:="Bank Account Number";
                  bankStruct.Reset;
                  bankStruct.SetRange(bankStruct."Bank Code","Main Bank");
                 // bankStruct.SETRANGE(bankStruct."Branch Code","Branch Bank");
                  if bankStruct.Find('-') then
                  begin
                     mainBankNM:=bankStruct."Bank Name";
                   BranchBankNM:=bankStruct."Branch Name";
                  end;

                if "HR-Employee"."Net Pay" = 0 then
                CurrReport.Skip;

                if PrintToExcel then begin
                if HeaderCreated = false then begin
                MakeExcelDataHeader;
                HeaderCreated := true;
                end;
                end;

                if PrintToExcel then
                  MakeExcelDataBody;

                GrandTotal:=GrandTotal+"HR-Employee"."Net Pay";

                RCount:=RCount+1;
            end;

            trigger OnPreDataItem()
            begin
                //"HR-Employee"."Current Month Filter" := DateFilter;
                //IF "HR-Employee"."Current Month Filter"=0D THEN
                if "HR-Employee".GetFilter("HR-Employee"."Current Month Filter") = '' then
                Error('You must specify current Period filter.');
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        if PrintToExcel then
          MakeExcelTotalBody;

        if PrintToExcel then
          CreateExcelbook;
    end;

    var
        EmployeeName: Text[200];
        bankStruct: Record UnknownRecord61077;
        bankAcc: Text[50];
        BranchBankNM: Text[100];
        mainBankNM: Text[100];
        RCount: Integer;
        PrintToExcel: Boolean;
        ExcelBuf: Record "Excel Buffer" temporary;
        HeaderCreated: Boolean;
        GrandTotal: Decimal;
        CompanyInfo: Record "Company Information";
        AccountType: Text[30];
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Bank_Payment_ScheduleCaptionLbl: label 'Cash Payment Schedule';
        Net_AmountCaptionLbl: label 'Net Amount';
        Account_No_CaptionLbl: label 'Account No.';
        Bank_BranchCaptionLbl: label 'Bank Branch';
        Employee_BankCaptionLbl: label 'Employee Bank';
        Employee_NameCaptionLbl: label 'Employee Name';
        BankCaptionLbl: label 'Bank';
        BranchCaptionLbl: label 'Branch';
        No_CaptionLbl: label 'No:';
        Prepared_by_CaptionLbl: label 'Prepared by:';
        NameCaptionLbl: label 'Name';
        EmptyStringCaptionLbl: label '......................................................................................................................................................';
        EmptyStringCaption_Control1102755035Lbl: label '......................................................................................................................................................';
        Authorised_by_CaptionLbl: label 'Authorised by:';
        NameCaption_Control1102755037Lbl: label 'Name';
        EmptyStringCaption_Control1102755038Lbl: label '......................................................................................................................................................';
        Approved_by_CaptionLbl: label 'Approved by:';
        NameCaption_Control1102755040Lbl: label 'Name';
        Signature___DateCaptionLbl: label 'Signature & Date';
        EmptyStringCaption_Control1102755042Lbl: label '......................................................................................................................................................';
        Signature___DateCaption_Control1102755043Lbl: label 'Signature & Date';
        EmptyStringCaption_Control1102755044Lbl: label '......................................................................................................................................................';
        Signature___DateCaption_Control1102755045Lbl: label 'Signature & Date';
        EmptyStringCaption_Control1102755046Lbl: label '......................................................................................................................................................';
        DateFilter: Date;

    local procedure MakeExcelDataHeader()
    begin
        /*
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Employee Code',FALSE,'',TRUE,FALSE,TRUE,'@');
        ExcelBuf.AddColumn('Names',FALSE,'',TRUE,FALSE,TRUE,'');
        ExcelBuf.AddColumn('Employee Bank',FALSE,'',TRUE,FALSE,TRUE,'');
        ExcelBuf.AddColumn('Employee Branch',FALSE,'',TRUE,FALSE,TRUE,'');
        ExcelBuf.AddColumn('Account Type',FALSE,'',TRUE,FALSE,TRUE,'@');
        ExcelBuf.AddColumn('Account No.',FALSE,'',TRUE,FALSE,TRUE,'@');
        ExcelBuf.AddColumn('Net Amount',FALSE,'',TRUE,FALSE,TRUE,'');
        */

    end;


    procedure MakeExcelDataBody()
    begin
        /*
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(("HR-Employee"."No."),FALSE,'',FALSE,FALSE,FALSE,'@');
        ExcelBuf.AddColumn(EmployeeName,FALSE,'',FALSE,FALSE,FALSE,'');
        ExcelBuf.AddColumn(mainBankNM,FALSE,'',FALSE,FALSE,FALSE,'');
        ExcelBuf.AddColumn(BranchBankNM,FALSE,'',FALSE,FALSE,FALSE,'');
        ExcelBuf.AddColumn(FORMAT("HR-Employee"."Account Type"),FALSE,'',FALSE,FALSE,FALSE,'@');
        ExcelBuf.AddColumn(bankAcc,FALSE,'',FALSE,FALSE,FALSE,'@');
        ExcelBuf.AddColumn("HR-Employee"."Net Pay",FALSE,'',FALSE,FALSE,FALSE,'');
        */

    end;


    procedure CreateExcelbook()
    begin
        /*
        ExcelBuf.CreateBook;
        ExcelBuf.CreateSheet('Bank Payment Schedule','Bank Payment Schedule',COMPANYNAME,USERID);
        ExcelBuf.GiveUserControl;
        ERROR('');
        */

    end;


    procedure MakeExcelTotalBody()
    begin
        /*
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'@');
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'');
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'');
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'');
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'@');
        ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'@');
        ExcelBuf.AddColumn(GrandTotal,FALSE,'',FALSE,FALSE,FALSE,'');
        */

    end;
}

