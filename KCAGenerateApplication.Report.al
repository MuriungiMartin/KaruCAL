#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51601 "KCA Generate Application"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/KCA Generate Application.rdlc';

    dataset
    {
        dataitem(UnknownTable61538;UnknownTable61538)
        {
            DataItemTableView = sorting("Receipt No.");
            RequestFilterFields = "Receipt No.",Date;
            column(ReportForNavId_5672; 5672)
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
            column(Receipt__Receipt_No__;"Receipt No.")
            {
            }
            column(Receipt__Student_No__;"Student No.")
            {
            }
            column(Receipt__Student_Name_;"Student Name")
            {
            }
            column(Receipt_Amount;Amount)
            {
            }
            column(Receipt__Amount_Applied_;"Amount Applied")
            {
            }
            column(ReceiptCaption;ReceiptCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Receipt__Receipt_No__Caption;FieldCaption("Receipt No."))
            {
            }
            column(Receipt__Student_No__Caption;FieldCaption("Student No."))
            {
            }
            column(Receipt__Student_Name_Caption;FieldCaption("Student Name"))
            {
            }
            column(Receipt_AmountCaption;FieldCaption(Amount))
            {
            }
            column(Receipt__Amount_Applied_Caption;FieldCaption("Amount Applied"))
            {
            }

            trigger OnAfterGetRecord()
            begin
                "ACA-Receipt".CalcFields("ACA-Receipt"."Amount Applied");
                if "ACA-Receipt".Amount > "ACA-Receipt"."Amount Applied" then begin
                AmApply:="ACA-Receipt".Amount - "ACA-Receipt"."Amount Applied";

                StudCharges.Reset;
                StudCharges.SetRange(StudCharges."Student No.","ACA-Receipt"."Student No.");
                StudCharges.SetRange(StudCharges."Recovered First",true);
                StudCharges.SetRange(StudCharges."Fully Paid",false);
                if StudCharges.Find('-') then begin
                repeat
                StudCharges.CalcFields(StudCharges."Total Paid");
                ChargeDesc:=StudCharges.Description;
                TotalPaid:=StudCharges."Total Paid";
                if StudCharges."Total Paid" < StudCharges.Amount then begin
                if AmApply > 0 then begin
                if AmApply > (StudCharges.Amount - StudCharges."Total Paid") then
                AppliedAmount:=(StudCharges.Amount - StudCharges."Total Paid")
                else
                AppliedAmount:=AmApply;

                if StudCharges."Total Paid" > 0 then begin
                RItem.Reset;
                RItem.SetRange(RItem."Receipt No","ACA-Receipt"."Receipt No.");
                RItem.SetRange(RItem."Transaction ID",StudCharges."Transacton ID");
                if RItem.Find('-') then begin
                RItem.Amount:=RItem.Amount+AppliedAmount;
                RItem."Student No.":=StudCharges."Student No.";
                RItem.Modify;

                AmApply:=AmApply-AppliedAmount;
                end else begin
                UniqNo:=UniqNo+1;
                ReceiptItems.Init;
                ReceiptItems."Receipt No":="ACA-Receipt"."Receipt No.";
                ReceiptItems.Code:=StudCharges.Code;
                ReceiptItems.Description:=StudCharges.Description;
                ReceiptItems.Amount:=AppliedAmount;
                ReceiptItems."Transaction ID":=StudCharges."Transacton ID";
                ReceiptItems."Student No.":=StudCharges."Student No.";
                ReceiptItems."Uniq No 2":=UniqNo;
                ReceiptItems.Date:="ACA-Receipt".Date;
                ReceiptItems.Programme:=StudCharges.Programme;
                ReceiptItems.Stage:=StudCharges.Stage;
                ReceiptItems.Unit:=StudCharges.Unit;
                ReceiptItems.Semester:=StudCharges.Semester;
                ReceiptItems.Insert;
                AmApply:=AmApply-AppliedAmount;
                end;

                end else begin
                UniqNo:=UniqNo+1;
                ReceiptItems.Init;
                ReceiptItems."Receipt No":="ACA-Receipt"."Receipt No.";
                ReceiptItems.Code:=StudCharges.Code;
                ReceiptItems.Description:=StudCharges.Description;
                ReceiptItems.Amount:=AppliedAmount;
                ReceiptItems."Transaction ID":=StudCharges."Transacton ID";
                ReceiptItems."Student No.":=StudCharges."Student No.";
                ReceiptItems."Uniq No 2":=UniqNo;
                ReceiptItems.Date:="ACA-Receipt".Date;
                ReceiptItems.Programme:=StudCharges.Programme;
                ReceiptItems.Stage:=StudCharges.Stage;
                ReceiptItems.Unit:=StudCharges.Unit;
                ReceiptItems.Semester:=StudCharges.Semester;
                ReceiptItems.Insert;
                AmApply:=AmApply-AppliedAmount;
                end;

                end;
                end;
                until StudCharges.Next = 0;
                end;

                //Rest of trans
                if AmApply > 0 then begin
                StudCharges.Reset;
                StudCharges.SetRange(StudCharges."Student No.","ACA-Receipt"."Student No.");
                StudCharges.SetRange(StudCharges."Recovered First",false);
                StudCharges.SetRange(StudCharges."Fully Paid",false);
                if StudCharges.Find('-') then begin
                repeat
                StudCharges.CalcFields(StudCharges."Total Paid");
                if StudCharges."Total Paid" < StudCharges.Amount then begin
                if AmApply > 0 then begin
                if AmApply > (StudCharges.Amount - StudCharges."Total Paid") then
                AppliedAmount:=(StudCharges.Amount - StudCharges."Total Paid")
                else
                AppliedAmount:=AmApply;

                if StudCharges."Total Paid" > 0 then begin
                RItem.Reset;
                RItem.SetRange(RItem."Receipt No","ACA-Receipt"."Receipt No.");
                RItem.SetRange(RItem."Transaction ID",StudCharges."Transacton ID");
                if RItem.Find('-') then begin
                RItem.Amount:=RItem.Amount+AppliedAmount;
                RItem.Modify;

                AmApply:=AmApply-AppliedAmount;
                end else begin
                UniqNo:=UniqNo+1;
                ReceiptItems.Init;
                ReceiptItems."Receipt No":="ACA-Receipt"."Receipt No.";
                ReceiptItems.Code:=StudCharges.Code;
                ReceiptItems.Description:=StudCharges.Description;
                ReceiptItems.Amount:=AppliedAmount;
                ReceiptItems."Transaction ID":=StudCharges."Transacton ID";
                ReceiptItems."Student No.":=StudCharges."Student No.";
                ReceiptItems."Uniq No 2":=UniqNo;
                ReceiptItems.Date:="ACA-Receipt".Date;
                ReceiptItems.Programme:=StudCharges.Programme;
                ReceiptItems.Stage:=StudCharges.Stage;
                ReceiptItems.Unit:=StudCharges.Unit;
                ReceiptItems.Semester:=StudCharges.Semester;
                ReceiptItems.Insert;

                AmApply:=AmApply-AppliedAmount;

                end;

                end else begin
                UniqNo:=UniqNo+1;
                ReceiptItems.Init;
                ReceiptItems."Receipt No":="ACA-Receipt"."Receipt No.";
                ReceiptItems.Code:=StudCharges.Code;
                ReceiptItems.Description:=StudCharges.Description;
                ReceiptItems.Amount:=AppliedAmount;
                ReceiptItems."Transaction ID":=StudCharges."Transacton ID";
                ReceiptItems."Student No.":=StudCharges."Student No.";
                ReceiptItems."Uniq No 2":=UniqNo;
                ReceiptItems.Date:="ACA-Receipt".Date;
                ReceiptItems.Programme:=StudCharges.Programme;
                ReceiptItems.Stage:=StudCharges.Stage;
                ReceiptItems.Unit:=StudCharges.Unit;
                ReceiptItems.Semester:=StudCharges.Semester;
                ReceiptItems.Insert;

                AmApply:=AmApply-AppliedAmount;
                end;

                end;
                end;
                until StudCharges.Next = 0;
                end;
                end;
                //end rest

                if AmApply > 0 then begin
                UniqNo:=UniqNo+1;
                ReceiptItems.Init;
                ReceiptItems."Receipt No":="ACA-Receipt"."Receipt No.";
                ReceiptItems.Code:='OP';
                ReceiptItems.Description:='Over Payment';
                ReceiptItems.Amount:=AmApply;
                ReceiptItems.Date:="ACA-Receipt".Date;
                ReceiptItems."Transaction ID":='';
                ReceiptItems."Student No.":="ACA-Receipt"."Student No.";
                ReceiptItems."Uniq No 2":=UniqNo;
                ReceiptItems.Insert;

                end;
                end;
            end;

            trigger OnPreDataItem()
            begin
                UniqNo:=75000;
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
        StudCharges: Record UnknownRecord61535;
        AmApply: Decimal;
        ReceiptItems: Record UnknownRecord61539;
        AppliedAmount: Decimal;
        RItem: Record UnknownRecord61539;
        UniqNo: Integer;
        ChargeDesc: Text[200];
        TotalPaid: Decimal;
        ReceiptCaptionLbl: label 'Receipt';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

