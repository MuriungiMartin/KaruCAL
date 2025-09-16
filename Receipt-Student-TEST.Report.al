#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51652 "Receipt - Student-TEST"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Receipt - Student-TEST.rdlc';

    dataset
    {
        dataitem(UnknownTable61538;UnknownTable61538)
        {
            DataItemTableView = sorting("Receipt No.");
            RequestFilterFields = "Receipt No.";
            column(ReportForNavId_5672; 5672)
            {
            }
            column(Receipt__Receipt_No__;"Receipt No.")
            {
            }
            column(Names;Names)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(Receipt_Amount;Amount)
            {
            }
            column(Receipt__Student_No__;"Student No.")
            {
            }
            column(Cust_Balance__Amount_Applied_;Cust.Balance+"Amount Applied")
            {
            }
            column(PDescription1;PDescription1)
            {
            }
            column(pAmount1;pAmount1)
            {
            }
            column(pCode1;pCode1)
            {
            }
            column(Receipt__Amount_Applied_;"Amount Applied")
            {
            }
            column(Cust_Balance;Cust.Balance)
            {
            }
            column(RegCourse;RegCourse)
            {
            }
            column(pCode2;pCode2)
            {
            }
            column(pCode3;pCode3)
            {
            }
            column(pCode4;pCode4)
            {
            }
            column(PDescription2;PDescription2)
            {
            }
            column(PDescription3;PDescription3)
            {
            }
            column(PDescription4;PDescription4)
            {
            }
            column(pAmount2;pAmount2)
            {
            }
            column(pAmount3;pAmount3)
            {
            }
            column(pAmount4;pAmount4)
            {
            }
            column(pCode5;pCode5)
            {
            }
            column(pCode6;pCode6)
            {
            }
            column(pCode7;pCode7)
            {
            }
            column(PDescription5;PDescription5)
            {
            }
            column(PDescription6;PDescription6)
            {
            }
            column(PDescription7;PDescription7)
            {
            }
            column(pAmount5;pAmount5)
            {
            }
            column(pAmount6;pAmount6)
            {
            }
            column(pAmount7;pAmount7)
            {
            }
            column(Receipt__Receipt_No__Caption;FieldCaption("Receipt No."))
            {
            }
            column(DATE_TIMECaption;DATE_TIMECaptionLbl)
            {
            }
            column(DataItem1000000015;Thank_you_for_training_with_KCA_Please_keep_your_latest_receipt_safely_you_may_be_asked_to_produce_it_before_proceeding_to_yoLbl)
            {
            }
            column(Received_FromCaption;Received_FromCaptionLbl)
            {
            }
            column(Reg__No_Caption;Reg__No_CaptionLbl)
            {
            }
            column(Class_SessionCaption;Class_SessionCaptionLbl)
            {
            }
            column(being_payment_forCaption;being_payment_forCaptionLbl)
            {
            }
            column(Amount_PayableCaption;Amount_PayableCaptionLbl)
            {
            }
            column(Total_PaidCaption;Total_PaidCaptionLbl)
            {
            }
            column(Outstanding_BalanceCaption;Outstanding_BalanceCaptionLbl)
            {
            }
            column(Course_RegisteredCaption;Course_RegisteredCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Hesabu:=0;
                tAmount:=0;
                Cust.Reset;
                if  Cust.Get("ACA-Receipt"."Student No.") then begin
                Cust.CalcFields(Cust.Balance);
                Names :=Cust.Name;
                end;
                CourseReg.Reset;
                CourseReg.SetRange(CourseReg."Student No.","ACA-Receipt"."Student No.");
                if CourseReg.Find('-') then
                RegCourse:=CourseReg.Programme;
                RecItems.Reset;
                RecItems.SetRange(RecItems."Receipt No","ACA-Receipt"."Receipt No.");
                if RecItems.Find('-') then begin
                Hesabu:=1;
                repeat
                if Hesabu=1 then begin
                pCode1:=RecItems.Code;
                PDescription1:=RecItems.Description;
                pAmount1:=RecItems.Amount;
                end;
                if Hesabu=2 then begin
                pCode2:=RecItems.Code;
                PDescription2:=RecItems.Description;
                pAmount2:=RecItems.Amount;
                end;
                if Hesabu=3 then begin
                pCode3:=RecItems.Code;
                PDescription3:=RecItems.Description;
                pAmount3:=RecItems.Amount;
                end;
                if Hesabu=4 then begin
                pCode4:=RecItems.Code;
                PDescription4:=RecItems.Description;
                pAmount4:=RecItems.Amount;
                end;
                Hesabu:=Hesabu+1;
                until RecItems.Next=0;
                end;
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
        Cust: Record Customer;
        Names: Text[200];
        RecItems: Record UnknownRecord61539;
        pCode1: Code[20];
        PDescription1: Text[50];
        pAmount1: Decimal;
        tAmount: Decimal;
        RegCourse: Text[50];
        CourseReg: Record UnknownRecord61532;
        pAmount2: Decimal;
        pCode2: Code[20];
        pCode3: Code[20];
        pCode4: Code[20];
        PDescription2: Text[50];
        PDescription3: Text[50];
        PDescription4: Text[50];
        pAmount3: Decimal;
        pAmount4: Decimal;
        Hesabu: Integer;
        pAmount5: Decimal;
        pAmount6: Decimal;
        pAmount7: Decimal;
        pCode5: Code[20];
        pCode6: Code[20];
        pCode7: Code[20];
        PDescription5: Text[50];
        PDescription6: Text[50];
        PDescription7: Text[50];
        DATE_TIMECaptionLbl: label 'DATE/TIME';
        Thank_you_for_training_with_KCA_Please_keep_your_latest_receipt_safely_you_may_be_asked_to_produce_it_before_proceeding_to_yoLbl: label 'Thank you for training with KCA.Please keep your latest receipt safely,you may be asked to produce it before proceeding to your class';
        Received_FromCaptionLbl: label 'Received From';
        Reg__No_CaptionLbl: label 'Reg. No.';
        Class_SessionCaptionLbl: label 'Class Session';
        being_payment_forCaptionLbl: label 'being payment for';
        Amount_PayableCaptionLbl: label 'Amount Payable';
        Total_PaidCaptionLbl: label 'Total Paid';
        Outstanding_BalanceCaptionLbl: label 'Outstanding Balance';
        Course_RegisteredCaptionLbl: label 'Course Registered';
}

