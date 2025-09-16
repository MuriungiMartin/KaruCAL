#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51653 "Receipt - Student-TEST1"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Receipt - Student-TEST1.rdlc';

    dataset
    {
        dataitem(UnknownTable61539;UnknownTable61539)
        {
            DataItemTableView = sorting("Transaction ID","Student No.",Date) order(ascending);
            RequestFilterFields = "Receipt No";
            column(ReportForNavId_9528; 9528)
            {
            }
            column(Receipt_Items__Receipt_Items___Receipt_No_;"ACA-Receipt Items"."Receipt No")
            {
            }
            column(Names;Names)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(Receipt_Items_Amount;Amount)
            {
            }
            column(Receipt_Items__Student_No__;"Student No.")
            {
            }
            column(Cust_Balance;Cust.Balance)
            {
            }
            column(Receipt_Items_Code;Code)
            {
            }
            column(Receipt_Items_Description;Description)
            {
            }
            column(Receipt_Items_Amount_Control1000000014;Amount)
            {
            }
            column(DATE_TIMECaption;DATE_TIMECaptionLbl)
            {
            }
            column(The_name_of_the_programmeCaption;The_name_of_the_programmeCaptionLbl)
            {
            }
            column(semester_NameCaption;semester_NameCaptionLbl)
            {
            }
            column(Account_StatementCaption;Account_StatementCaptionLbl)
            {
            }
            column(DataItem1000000015;Thank_you_for_training_with_KCA_Please_keep_your_latest_receipt_safely_you_may_be_asked_to_produce_it_before_proceeding_to_yoLbl)
            {
            }
            column(Receipt_Items_Uniq_No_2;"Uniq No 2")
            {
            }
            column(Receipt_Items_Transaction_ID;"Transaction ID")
            {
            }

            trigger OnAfterGetRecord()
            begin
                Cust.Reset;
                if  Cust.Get("ACA-Receipt Items"."Student No.") then begin
                Cust.CalcFields(Cust.Balance);
                Names :=Cust.Name;
                end;
                /*
                RecItems.RESET;
                RecItems.SETRANGE(RecItems."Receipt No",Receipt."Receipt No.");
                IF RecItems.FIND('-') THEN BEGIN
                REPEAT
                pCode:=RecItems.Code;
                PDescription:=RecItems.Description;
                pAmount:=RecItems.Amount;
                UNTIL RecItems.NEXT=0;
                END;
                 */

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
        pCode: Code[20];
        PDescription: Text[50];
        pAmount: Decimal;
        DATE_TIMECaptionLbl: label 'DATE/TIME';
        The_name_of_the_programmeCaptionLbl: label 'The name of the programme';
        semester_NameCaptionLbl: label 'semester Name';
        Account_StatementCaptionLbl: label 'Account Statement';
        Thank_you_for_training_with_KCA_Please_keep_your_latest_receipt_safely_you_may_be_asked_to_produce_it_before_proceeding_to_yoLbl: label 'Thank you for training with KCA.Please keep your latest receipt safely,you may be asked to produce it before proceeding to your class';
}

