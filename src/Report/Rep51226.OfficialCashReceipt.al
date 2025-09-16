#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51226 "Official Cash Receipt"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Official Cash Receipt.rdlc';

    dataset
    {
        dataitem(UnknownTable61134;UnknownTable61134)
        {
            DataItemTableView = sorting(No);
            RequestFilterFields = No;
            column(ReportForNavId_3752; 3752)
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(Payments_No;No)
            {
            }
            column(Payments__Account_No__;"Account No.")
            {
            }
            column(AccName;AccName)
            {
            }
            column(Payments__Cheque_No_;"Cheque No")
            {
            }
            column(Private_Bag__MASENO__Tel_057_351620_622Caption;Private_Bag__MASENO__Tel_057_351620_622CaptionLbl)
            {
            }
            column(Official_Receipt_No_Caption;Official_Receipt_No_CaptionLbl)
            {
            }
            column(RECEIVED_From__P_F_No_Caption;RECEIVED_From__P_F_No_CaptionLbl)
            {
            }
            column(NameCaption;NameCaptionLbl)
            {
            }
            column(Cheque_NoCaption;Cheque_NoCaptionLbl)
            {
            }
            column(REVENUE___INCOME_ITEMCaption;REVENUE___INCOME_ITEMCaptionLbl)
            {
            }
            column(KSHSCaption;KSHSCaptionLbl)
            {
            }
            column(CODECaption;CODECaptionLbl)
            {
            }
            dataitem(UnknownTable61126;UnknownTable61126)
            {
                DataItemLink = No=field(No);
                column(ReportForNavId_3307; 3307)
                {
                }
                column(Imprest_Details__Account_Name_;"Account Name")
                {
                }
                column(Imprest_Details_Balance;Balance)
                {
                }
                column(Payments__Account_No___Control1000000015;"FIN-Payments"."Account No.")
                {
                }
                column(Imprest_Details_Balance_Control1000000004;Balance)
                {
                }
                column(Word_Text_1_;Word_Text[1])
                {
                }
                column(TOTAL_AMOUNTCaption;TOTAL_AMOUNTCaptionLbl)
                {
                }
                column(Sum_Of_Kshs_in_WordCaption;Sum_Of_Kshs_in_WordCaptionLbl)
                {
                }
                column(With_ThanksCaption;With_ThanksCaptionLbl)
                {
                }
                column(Signature______________________________________________________Caption;Signature______________________________________________________CaptionLbl)
                {
                }
                column(For_KARATINA_UNIVERSITYCaption;For_KARATINA_UNIVERSITYCaptionLbl)
                {
                }
                column(Imprest_Details_No;No)
                {
                }
                column(Imprest_Details_Account_No_;"Account No:")
                {
                }
                column(Imprest_Details_Line_No;"Line No")
                {
                }
            }
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
        CheckReport: Report Check;
        Word_Text: array [2] of Text[30];
        AccName: Code[10];
        GL: Record "Gen. Journal Line";
        Private_Bag__MASENO__Tel_057_351620_622CaptionLbl: label 'Private Bag, MASENO. Tel 057-351620/622';
        Official_Receipt_No_CaptionLbl: label 'Official Receipt No.';
        RECEIVED_From__P_F_No_CaptionLbl: label 'RECEIVED From: P/F No.';
        NameCaptionLbl: label 'Name';
        Cheque_NoCaptionLbl: label 'Cheque No';
        REVENUE___INCOME_ITEMCaptionLbl: label 'REVENUE / INCOME ITEM';
        KSHSCaptionLbl: label 'KSHS';
        CODECaptionLbl: label 'CODE';
        TOTAL_AMOUNTCaptionLbl: label 'TOTAL AMOUNT';
        Sum_Of_Kshs_in_WordCaptionLbl: label 'Sum Of Kshs in Word';
        With_ThanksCaptionLbl: label 'With Thanks';
        Signature______________________________________________________CaptionLbl: label 'Signature......................................................';
        For_KARATINA_UNIVERSITYCaptionLbl: label 'For KARATINA UNIVERSITY';
}

