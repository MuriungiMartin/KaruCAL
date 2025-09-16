#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51229 "Cash Receipt"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Cash Receipt.rdlc';

    dataset
    {
        dataitem(UnknownTable61157;UnknownTable61157)
        {
            DataItemTableView = sorting("Doc No");
            RequestFilterFields = "Doc No";
            column(ReportForNavId_3303; 3303)
            {
            }
            column(Cash_Sale_Header_Date;Date)
            {
            }
            column(Company_Name;Company.Name)
            {
            }
            column(Dept;Dept)
            {
            }
            column(Cash_Sale_Header__Doc_No_;"Doc No")
            {
            }
            column(Cash_Sale_Header__Customer_Name_;"Customer Name")
            {
            }
            column(Cash_Sale_Header__Customer_No_;"Customer No")
            {
            }
            column(Cash_Sale_Header__Report_Status_;"Report Status")
            {
            }
            column(CODECaption;CODECaptionLbl)
            {
            }
            column(INCOME_ITEMCaption;INCOME_ITEMCaptionLbl)
            {
            }
            column(KSHSCaption;KSHSCaptionLbl)
            {
            }
            column(DATECaption;DATECaptionLbl)
            {
            }
            column(P_O_BOX_15653_00503_622Caption;P_O_BOX_15653_00503_622CaptionLbl)
            {
            }
            column(NameCaption;NameCaptionLbl)
            {
            }
            column(CASH_RECEIPT_NO_Caption;CASH_RECEIPT_NO_CaptionLbl)
            {
            }
            column(RECEIVED_From__Reg_PF_No_Caption;RECEIVED_From__Reg_PF_No_CaptionLbl)
            {
            }
            dataitem(UnknownTable61158;UnknownTable61158)
            {
                DataItemLink = No=field("Doc No");
                column(ReportForNavId_7967; 7967)
                {
                }
                column(Cash_Sale_Line_Code;Code)
                {
                }
                column(Cash_Sale_Line_Description;Description)
                {
                }
                column(Cash_Sale_Line__Total_Amount_;"Total Amount")
                {
                }
                column(Cash_Sale_Line__Total_Amount__Control1000000013;"Total Amount")
                {
                }
                column(Word_Text2_1_;Word_Text2[1])
                {
                }
                column(TOTAL_AMOUNTCaption;TOTAL_AMOUNTCaptionLbl)
                {
                }
                column(In_WordsCaption;In_WordsCaptionLbl)
                {
                }
                column(Cash_Sale_Line_Line_No;"Line No")
                {
                }
                column(Cash_Sale_Line_No;No)
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
        Dimmensions: Record "Dimension Value";
        Dept: Text[100];
        CheckReport: Report Check;
        Word_Text2: array [2] of Text[200];
        Company: Record "Company Information";
        CODECaptionLbl: label 'CODE';
        INCOME_ITEMCaptionLbl: label 'INCOME ITEM';
        KSHSCaptionLbl: label 'KSHS';
        DATECaptionLbl: label 'DATE';
        P_O_BOX_15653_00503_622CaptionLbl: label 'P.O BOX 232-10103. Tel: 020 2046895 / 0722814900';
        NameCaptionLbl: label 'Name';
        CASH_RECEIPT_NO_CaptionLbl: label 'CASH RECEIPT NO.';
        RECEIVED_From__Reg_PF_No_CaptionLbl: label 'RECEIVED From: Reg/PF No.';
        TOTAL_AMOUNTCaptionLbl: label 'TOTAL AMOUNT';
        In_WordsCaptionLbl: label 'In Words';
}

