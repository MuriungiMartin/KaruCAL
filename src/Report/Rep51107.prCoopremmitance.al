#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51107 "prCoop remmitance"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/prCoop remmitance.rdlc';

    dataset
    {
        dataitem(UnknownTable61105;UnknownTable61105)
        {
            DataItemTableView = sorting("Employee Code");
            RequestFilterFields = "Period Filter","Employee Code";
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
            column(SACCO_REMITTANCE_;'SACCO REMITTANCE')
            {
            }
            column(CompanyInfo_Picture;CompanyInfo.Picture)
            {
            }
            column(DenomArray_1_9_;DenomArray[1,9])
            {
            }
            column(DenomArray_1_8_;DenomArray[1,8])
            {
            }
            column(DenomArray_1_7_;DenomArray[1,7])
            {
            }
            column(DenomArray_1_6_;DenomArray[1,6])
            {
            }
            column(DenomArray_1_5_;DenomArray[1,5])
            {
            }
            column(DenomArray_1_4_;DenomArray[1,4])
            {
            }
            column(DenomArray_1_3_;DenomArray[1,3])
            {
            }
            column(DenomArray_1_2_;DenomArray[1,2])
            {
            }
            column(DenomArray_1_1_;DenomArray[1,1])
            {
            }
            column(DenomArray_1_10_;DenomArray[1,10])
            {
            }
            column(DenomArray_1_11_;DenomArray[1,11])
            {
            }
            column(DenomArray_1_12_;DenomArray[1,12])
            {
            }
            column(prSalary_Card__Employee_Code_;"Employee Code")
            {
            }
            column(strEmpName;strEmpName)
            {
            }
            column(AmountArray_1_2_;AmountArray[1,2])
            {
            }
            column(AmountArray_1_1_;AmountArray[1,1])
            {
            }
            column(AmountArray_1_3_;AmountArray[1,3])
            {
            }
            column(AmountArray_1_4_;AmountArray[1,4])
            {
            }
            column(AmountArray_1_5_;AmountArray[1,5])
            {
            }
            column(AmountArray_1_6_;AmountArray[1,6])
            {
            }
            column(AmountArray_1_7_;AmountArray[1,7])
            {
            }
            column(LineTotal;LineTotal)
            {
            }
            column(AmountArray_1_8_;AmountArray[1,8])
            {
            }
            column(AmountArray_1_9_;AmountArray[1,9])
            {
            }
            column(AmountArray_1_10_;AmountArray[1,10])
            {
            }
            column(AmountArray_1_11_;AmountArray[1,11])
            {
            }
            column(AmountArray_1_12_;AmountArray[1,12])
            {
            }
            column(Totals1;Totals1)
            {
            }
            column(Totals2;Totals2)
            {
            }
            column(Totals3;Totals3)
            {
            }
            column(Totals4;Totals4)
            {
            }
            column(Totals5;Totals5)
            {
            }
            column(Totals6;Totals6)
            {
            }
            column(Totals7;Totals7)
            {
            }
            column(Totals8;Totals8)
            {
            }
            column(Totals9;Totals9)
            {
            }
            column(Totals10;Totals10)
            {
            }
            column(Totals11;Totals11)
            {
            }
            column(Totals12;Totals12)
            {
            }
            column(Totals1_Totals2_Totals3_Totals4_Totals5_Totals6_Totals7_Totals8_Totals9_Totals10_Totals11;Totals1+Totals2+Totals3+Totals4+Totals5+Totals6+Totals7+Totals8+Totals9+Totals10+Totals11)
            {
            }
            column(User_Name_Caption;User_Name_CaptionLbl)
            {
            }
            column(Print_Date_Caption;Print_Date_CaptionLbl)
            {
            }
            column(Period_Caption;Period_CaptionLbl)
            {
            }
            column(Page_No_Caption;Page_No_CaptionLbl)
            {
            }
            column(TotalsCaption;TotalsCaptionLbl)
            {
            }
            column(NameCaption;NameCaptionLbl)
            {
            }
            column(Payroll_NoCaption;Payroll_NoCaptionLbl)
            {
            }
            column(Prepared_by_______________________________________Date_________________Caption;Prepared_by_______________________________________Date_________________CaptionLbl)
            {
            }
            column(Checked_by________________________________________Date_________________Caption;Checked_by________________________________________Date_________________CaptionLbl)
            {
            }
            column(Authorized_by____________________________________Date_________________Caption;Authorized_by____________________________________Date_________________CaptionLbl)
            {
            }
            column(Approved_by______________________________________Date_________________Caption;Approved_by______________________________________Date_________________CaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                //Initialise the variables********************************************************
                CoopLoan :=0;
                LineTotal:=0;

                //**** Get the employee name *******************************************************************
                strEmpName:='';

                objEmp.Reset;
                objEmp.SetRange(objEmp."No.","Employee Code");
                if objEmp.Find('-') then;
                 begin
                   strEmpName:=objEmp."First Name"+' '+objEmp."Middle Name"+' '+objEmp."Last Name";
                   CoopNo:=objEmp."Co-Operative No";
                 end;

                //**** COOPERATIVE REMMITANCE *****************************************************************

                CoopLoan:=0;
                PeriodTrans.Reset;
                transcode.Reset;

                Index:=0;
                 transcode.SetRange(transcode."IsCoop/LnRep",true);
                 if transcode.Find('-') then begin
                    repeat
                      PeriodTrans.SetRange(PeriodTrans."Employee Code","PRL-Salary Card"."Employee Code");
                      PeriodTrans.SetRange(PeriodTrans."Payroll Period",SelectedPeriod);
                      PeriodTrans.SetRange(PeriodTrans."Transaction Code",transcode."Transaction Code");
                      if PeriodTrans.Find('-') then
                       begin
                       CoopLoan:= 0;
                       CoopLoan:= CoopLoan+Abs(PeriodTrans.Amount);
                           //Add Interest
                              PeriodTrans.SetRange(PeriodTrans."Employee Code","PRL-Salary Card"."Employee Code");
                              PeriodTrans.SetRange(PeriodTrans."Payroll Period",SelectedPeriod);
                              IntCode:='';
                              IntCode:=transcode."Transaction Code"+'-INT';
                              PeriodTrans.SetRange(PeriodTrans."Transaction Code",IntCode);
                              if PeriodTrans.Find('-') then
                                CoopLoan:= CoopLoan+Abs(PeriodTrans.Amount);
                           //
                        Index:=Index+1;
                        DenomArray[1][Index]:=PeriodTrans."Transaction Name";
                        AmountArray[1][Index]:=Abs(CoopLoan);


                           if Index=1 then  begin
                             DptTotals1:= DptTotals1+Abs(CoopLoan);
                             Totals1:=Totals1+Abs(CoopLoan);
                             LineTotal:= LineTotal+Abs(CoopLoan);
                             TotalPayable:=TotalPayable+LineTotal;
                           end;
                           if Index=2 then  begin
                             DptTotals2:= DptTotals2+Abs(CoopLoan);
                             Totals2:=Totals2+Abs(CoopLoan);
                             LineTotal:= LineTotal+Abs(CoopLoan);
                             TotalPayable:=TotalPayable+LineTotal;
                           end;
                           if Index=3 then begin
                             DptTotals3:= DptTotals3+Abs(CoopLoan);
                             Totals3:=Totals3+Abs(CoopLoan);
                             LineTotal:= LineTotal+Abs(CoopLoan);
                             TotalPayable:=TotalPayable+LineTotal;
                           end;
                           if Index=4 then begin
                             DptTotals4:= DptTotals4+Abs(CoopLoan);
                             Totals4:=Totals4+Abs(CoopLoan);
                             LineTotal:= LineTotal+Abs(CoopLoan);
                             TotalPayable:=TotalPayable+LineTotal;
                           end;
                           if Index=5 then begin
                             DptTotals5:= DptTotals5+Abs(CoopLoan);
                             Totals5:=Totals5+Abs(CoopLoan);
                             LineTotal:= LineTotal+Abs(CoopLoan);
                             TotalPayable:=TotalPayable+LineTotal;
                           end;
                           if Index=6 then begin
                             DptTotals6:= DptTotals6+Abs(CoopLoan);
                             Totals6:=Totals6+Abs(CoopLoan);
                             LineTotal:= LineTotal+Abs(CoopLoan);
                             TotalPayable:=TotalPayable+LineTotal;
                           end;
                           if Index=7 then  begin
                             DptTotals7:= DptTotals7+Abs(CoopLoan);
                             Totals7:=Totals7+Abs(CoopLoan);
                             LineTotal:= LineTotal+Abs(CoopLoan);
                             TotalPayable:=TotalPayable+LineTotal;
                           end;
                           if Index=8 then begin
                             DptTotals8:= DptTotals8+Abs(CoopLoan);
                             Totals8:=Totals8+Abs(CoopLoan);
                             LineTotal:= LineTotal+Abs(CoopLoan);
                             TotalPayable:=TotalPayable+LineTotal;
                           end;
                           if Index=9 then  begin
                            DptTotals9:= DptTotals9+Abs(CoopLoan);
                             Totals9:=Totals9+Abs(CoopLoan);
                             LineTotal:= LineTotal+Abs(CoopLoan);
                             TotalPayable:=TotalPayable+LineTotal;
                           end;
                           if Index=10 then  begin
                            DptTotals10:= DptTotals10+Abs(CoopLoan);
                             Totals10:=Totals10+Abs(CoopLoan);
                             LineTotal:= LineTotal+Abs(CoopLoan);
                             TotalPayable:=TotalPayable+LineTotal;
                           end;
                           if Index=11 then  begin
                            DptTotals11:= DptTotals11+Abs(CoopLoan);
                             Totals11:=Totals11+Abs(CoopLoan);
                             LineTotal:= LineTotal+Abs(CoopLoan);
                             TotalPayable:=TotalPayable+LineTotal;
                           end;
                           if Index=12 then  begin
                            DptTotals12:= DptTotals12+Abs(CoopLoan);
                             Totals12:=Totals12+Abs(CoopLoan);
                             LineTotal:= LineTotal+Abs(CoopLoan);
                             TotalPayable:=TotalPayable+LineTotal;
                           end;
                       end
                        else begin
                        Index:=Index+1;
                        Clear(AmountArray[1][Index]);
                        DenomArray[1][Index]:=transcode."Transaction Name";
                        end;

                    until transcode.Next=0;

                 end;

                 if (CoopLoan=0)then
                     CurrReport.Skip;

                   COUNTER:=COUNTER+1;

                //End COOPERATIVE REMMITANCE
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

    trigger OnPreReport()
    begin
        PeriodFilter:="PRL-Salary Card".GetFilter("Period Filter");
        if PeriodFilter='' then Error('You must specify the period filter');

        SelectedPeriod:="PRL-Salary Card".GetRangeMin("Period Filter");
        objPeriod.Reset;
        if objPeriod.Get(SelectedPeriod) then PeriodName:=objPeriod."Period Name";

        //IF strOrganisation='' THEN ERROR('You must specify the instituion in the (options) tab');


        if CompanyInfo.Get() then
        CompanyInfo.CalcFields(CompanyInfo.Picture);
    end;

    var
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        TotalFor: label 'Total for ';
        strEmpName: Text[30];
        strOrganisation: Text[30];
        objEmp: Record UnknownRecord61118;
        objOrg: Record UnknownRecord61111;
        objPeriod: Record UnknownRecord61081;
        SelectedPeriod: Date;
        PeriodName: Text[30];
        PeriodTrans: Record UnknownRecord61092;
        empTotal: Decimal;
        totempTotal: Decimal;
        GrandTotal: Decimal;
        PeriodFilter: Text[30];
        LineTotal: Decimal;
        totLineTotal: Decimal;
        CoopNo: Text[50];
        transcode: Record UnknownRecord61082;
        Index: Integer;
        DenomArray: array [3,12] of Text[50];
        AmountArray: array [3,12] of Decimal;
        Totals1: Decimal;
        Totals2: Decimal;
        Totals3: Decimal;
        Totals4: Decimal;
        Totals5: Decimal;
        Totals6: Decimal;
        Totals7: Decimal;
        Totals8: Decimal;
        Totals9: Decimal;
        Totals10: Decimal;
        Totals11: Decimal;
        Totals12: Decimal;
        DptTotals1: Decimal;
        DptTotals2: Decimal;
        DptTotals3: Decimal;
        DptTotals4: Decimal;
        DptTotals5: Decimal;
        DptTotals6: Decimal;
        DptTotals7: Decimal;
        DptTotals8: Decimal;
        DptTotals9: Decimal;
        DptTotals10: Decimal;
        DptTotals11: Decimal;
        DptTotals12: Decimal;
        CoopLoan: Decimal;
        COUNTER: Integer;
        CompanyInfo: Record "Company Information";
        TotalPayable: Decimal;
        IntCode: Code[20];
        User_Name_CaptionLbl: label 'User Name:';
        Print_Date_CaptionLbl: label 'Print Date:';
        Period_CaptionLbl: label 'Period:';
        Page_No_CaptionLbl: label 'Page No:';
        TotalsCaptionLbl: label 'Totals';
        NameCaptionLbl: label 'Name';
        Payroll_NoCaptionLbl: label 'Payroll No';
        Prepared_by_______________________________________Date_________________CaptionLbl: label 'Prepared by……………………………………………………..                 Date……………………………………………';
        Checked_by________________________________________Date_________________CaptionLbl: label 'Checked by…………………………………………………..                   Date……………………………………………';
        Authorized_by____________________________________Date_________________CaptionLbl: label 'Authorized by……………………………………………………..              Date……………………………………………';
        Approved_by______________________________________Date_________________CaptionLbl: label 'Approved by……………………………………………………..                Date……………………………………………';
}

