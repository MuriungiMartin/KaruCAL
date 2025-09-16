#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51543 "Cash Summary 2"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Cash Summary 2.rdlc';

    dataset
    {
        dataitem("Dimension Value";"Dimension Value")
        {
            DataItemTableView = sorting("Dimension Code",Code) where("Dimension Code"=const('CAMPUS'));
            RequestFilterFields = "Dimension Code","Code";
            column(ReportForNavId_6363; 6363)
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
            column(Dimension_Value_Code;Code)
            {
            }
            column(Dimension_Value_Name;Name)
            {
            }
            column(Dimension_Value_Code_Control1102758010;Code)
            {
            }
            column(Dimension_Value_Name_Control1102758014;Name)
            {
            }
            column(NoRegd;NoRegd)
            {
            }
            column(NoBilled;NoBilled)
            {
            }
            column(NoPaid;NoPaid)
            {
            }
            column(AmntBilled;AmntBilled)
            {
            }
            column(AmntPaid;AmntPaid)
            {
            }
            column(Dimension_Value_Name_Control1102758019;Name)
            {
            }
            column(Dimension_Value_Code_Control1102758020;Code)
            {
            }
            column(TNoRegd;TNoRegd)
            {
            }
            column(TNoBilled;TNoBilled)
            {
            }
            column(TNoPaid;TNoPaid)
            {
            }
            column(TAmntBilled;TAmntBilled)
            {
            }
            column(TAmntPaid;TAmntPaid)
            {
            }
            column(GNoRegd;GNoRegd)
            {
            }
            column(GNoBilled;GNoBilled)
            {
            }
            column(GNoPaid;GNoPaid)
            {
            }
            column(GAmntBilled;GAmntBilled)
            {
            }
            column(GAmntPaid;GAmntPaid)
            {
            }
            column(GAmntPaid_Control1102758029;GAmntPaid)
            {
            }
            column(Unreferenced;Unreferenced)
            {
            }
            column(PaidNotRegd;PaidNotRegd)
            {
            }
            column(PaidNotRegd___GAmntPaid___Unreferenced_CashAmnt;PaidNotRegd + GAmntPaid + Unreferenced+CashAmnt)
            {
            }
            column(CashAmnt;CashAmnt)
            {
            }
            column(ExecPaid;ExecPaid)
            {
            }
            column(ExecPaid_Control1102760006;ExecPaid)
            {
            }
            column(ExecBilled;ExecBilled)
            {
            }
            column(Cash_Summary_ReportCaption;Cash_Summary_ReportCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(No__RegdCaption;No__RegdCaptionLbl)
            {
            }
            column(No__BilledCaption;No__BilledCaptionLbl)
            {
            }
            column(No__PaidCaption;No__PaidCaptionLbl)
            {
            }
            column(Billed_AmntCaption;Billed_AmntCaptionLbl)
            {
            }
            column(Paid_AmntCaption;Paid_AmntCaptionLbl)
            {
            }
            column(Registered_and_Paid_Caption;Registered_and_Paid_CaptionLbl)
            {
            }
            column(Unreferenced_Amount_Caption;Unreferenced_Amount_CaptionLbl)
            {
            }
            column(Paid_Not_Registered_Caption;Paid_Not_Registered_CaptionLbl)
            {
            }
            column(Total_Amount_Caption;Total_Amount_CaptionLbl)
            {
            }
            column(Cash_Collections_Caption;Cash_Collections_CaptionLbl)
            {
            }
            column(Executive_Collections_Caption;Executive_Collections_CaptionLbl)
            {
            }
            column(Executive_ProgrammeCaption;Executive_ProgrammeCaptionLbl)
            {
            }
            column(Amount_Billed_Caption;Amount_Billed_CaptionLbl)
            {
            }
            column(Amount_Paid_Caption;Amount_Paid_CaptionLbl)
            {
            }
            column(Dimension_Value_Dimension_Code;"Dimension Code")
            {
            }

            trigger OnAfterGetRecord()
            begin
                NoRegd:=0;
                NoBilled:=0;
                NoPaid:=0;
                AmntBilled:=0;
                AmntPaid:=0;
                Programme.Reset;
                Programme.SetFilter(Programme."School Code","Dimension Value".Code);
                if Programme.Find('-') then
                 begin
                 repeat
                  Course.Reset;
                  Course.SetRange(Course.Programme,Programme.Code);
                  Course.SetFilter(Course."Registration Date",Format(BeginDate) + '..' + Format(EndDate));
                  //Course.SETRANGE(Course.Posted,TRUE);
                  if Course.Find('-') then
                   begin
                    repeat
                     NoRegd:=NoRegd + 1;
                     TNoRegd:=TNoRegd +1;
                     GNoRegd:=GNoRegd +1;
                    until Course.Next=0;
                   end;

                   Course.Reset;
                   Course.SetFilter(Course.Programme,Programme.Code);
                   Course.SetRange(Course.Posted,true);
                   Course.SetFilter(Course."Date Filter",Format(BeginDate) +'..' +Format(EndDate));
                   if Course.Find('-') then
                    begin
                     repeat
                      Course.CalcFields(Course."Total Billed");

                      if Course."Total Billed">0 then
                        begin
                         NoBilled:=NoBilled + 1;
                         TNoBilled:=TNoBilled +1;
                         GNoBilled:=GNoBilled +1;
                        end;

                      AmntBilled:=AmntBilled + Course."Total Billed";
                      TAmntBilled:=TAmntBilled + Course."Total Billed";
                      GAmntBilled:=GAmntBilled + Course."Total Billed";
                     until Course.Next=0;
                    end;

                   Course.Reset;
                   Course.SetFilter(Course.Programme,Programme.Code);
                   Course.SetRange(Course.Posted,true);
                   if Course.Find('-') then
                    begin
                     repeat
                      Course.CalcFields(Course."Total Paid");
                      if Course."Total Paid">0 then
                       begin
                        AmntPaid:=AmntPaid + Course."Total Paid";
                        NoPaid:=NoPaid + 1;
                        TNoPaid:=TNoPaid + 1;
                        GNoPaid :=GNoPaid +1;
                        TAmntPaid :=TAmntPaid + Course."Total Paid";
                        GAmntPaid:=GAmntPaid + Course."Total Paid";
                       end;
                     until Course.Next=0;
                    end;
                  until Programme.Next=0;
                 end;
            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo(Code);
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
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        NoRegd: Integer;
        NoBilled: Integer;
        NoPaid: Integer;
        AmntPaid: Decimal;
        AmntBilled: Decimal;
        Programme: Record UnknownRecord61511;
        Course: Record UnknownRecord61532;
        BeginDate: Date;
        EndDate: Date;
        TNoRegd: Integer;
        TNoBilled: Integer;
        TNoPaid: Integer;
        TAmntBilled: Decimal;
        TAmntPaid: Decimal;
        GNoRegd: Integer;
        GNoBilled: Integer;
        GNoPaid: Integer;
        GAmntBilled: Decimal;
        GAmntPaid: Decimal;
        Unreferenced: Decimal;
        PaidNotRegd: Decimal;
        Account: Record "G/L Account";
        Bank: Record "Bank Account";
        BankLedg: Record "Bank Account Ledger Entry";
        AccLedgEntry: Record "G/L Entry";
        CashAmnt: Decimal;
        ExecPaid: Decimal;
        ExecBilled: Decimal;
        Cash_Summary_ReportCaptionLbl: label 'Cash Summary Report';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        No__RegdCaptionLbl: label 'No. Regd';
        No__BilledCaptionLbl: label 'No. Billed';
        No__PaidCaptionLbl: label 'No. Paid';
        Billed_AmntCaptionLbl: label 'Billed Amnt';
        Paid_AmntCaptionLbl: label 'Paid Amnt';
        Registered_and_Paid_CaptionLbl: label 'Registered and Paid:';
        Unreferenced_Amount_CaptionLbl: label 'Unreferenced Amount:';
        Paid_Not_Registered_CaptionLbl: label 'Paid Not Registered:';
        Total_Amount_CaptionLbl: label 'Total Amount:';
        Cash_Collections_CaptionLbl: label 'Cash Collections:';
        Executive_Collections_CaptionLbl: label 'Executive Collections:';
        Executive_ProgrammeCaptionLbl: label 'Executive Programme';
        Amount_Billed_CaptionLbl: label 'Amount Billed:';
        Amount_Paid_CaptionLbl: label 'Amount Paid:';
}

