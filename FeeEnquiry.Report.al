#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51538 "Fee Enquiry"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Fee Enquiry.rdlc';

    dataset
    {
        dataitem(UnknownTable61588;UnknownTable61588)
        {
            DataItemTableView = sorting("Proforma No.");
            RequestFilterFields = "Proforma No.";
            column(ReportForNavId_2693; 2693)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(USERID;UserId)
            {
            }
            column(Proforma__Programme_Description_;"Programme Description")
            {
            }
            column(Proforma__Student_Type_;"Student Type")
            {
            }
            column(Proforma__Settlement_Type_;"Settlement Type")
            {
            }
            column(FEE_ENQUIRYCaption;FEE_ENQUIRYCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(KARATINA_UNIVERSITYCaption;KARATINA_UNIVERSITYCaptionLbl)
            {
            }
            column(P_O_Box_Private_Bag__Maseno___KenyaCaption;P_O_Box_Private_Bag__Maseno___KenyaCaptionLbl)
            {
            }
            column(Tel___254_2__750255_8___Fax___254_2__750260___E_Mail__enquiries_maseno_ac_ke___Website__www_masano_ac_ke_Caption;Tel___254_2__750255_8___Fax___254_2__750260___E_Mail__enquiries_maseno_ac_ke___Website__www_masano_ac_ke_CaptionLbl)
            {
            }
            column(Proforma_Lines_AmountCaption;"ACA-Proforma Lines".FieldCaption(Amount))
            {
            }
            column(Proforma_Lines_DescriptionCaption;"ACA-Proforma Lines".FieldCaption(Description))
            {
            }
            column(Proforma_Lines_CodeCaption;"ACA-Proforma Lines".FieldCaption(Code))
            {
            }
            column(Proforma_Lines_StageCaption;"ACA-Proforma Lines".FieldCaption(Stage))
            {
            }
            column(Proforma_Lines_QuantityCaption;"ACA-Proforma Lines".FieldCaption(Quantity))
            {
            }
            column(Proforma_Proforma_No_;"Proforma No.")
            {
            }
            dataitem(UnknownTable61589;UnknownTable61589)
            {
                DataItemLink = "Reg. Transacton ID"=field("Proforma No.");
                column(ReportForNavId_3135; 3135)
                {
                }
                column(Proforma_Lines_Code;Code)
                {
                }
                column(Proforma_Lines_Description;Description)
                {
                }
                column(Proforma_Lines_Amount;Amount)
                {
                }
                column(Proforma_Lines_Stage;Stage)
                {
                }
                column(Proforma_Lines_Quantity;Quantity)
                {
                }
                column(Proforma_Lines_Amount_Control1102760031;Amount)
                {
                }
                column(Total_Caption;Total_CaptionLbl)
                {
                }
                column(Proforma_Lines_Transacton_ID;"Transacton ID")
                {
                }
                column(Proforma_Lines_Student_No_;"Student No.")
                {
                }
                column(Proforma_Lines_Reg__Transacton_ID;"Reg. Transacton ID")
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
        FEE_ENQUIRYCaptionLbl: label 'FEE ENQUIRY';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        KARATINA_UNIVERSITYCaptionLbl: label 'KARATINA UNIVERSITY';
        P_O_Box_Private_Bag__Maseno___KenyaCaptionLbl: label 'P.O Box 232-10103 KARATINA - Kenya';
        Tel___254_2__750255_8___Fax___254_2__750260___E_Mail__enquiries_maseno_ac_ke___Website__www_masano_ac_ke_CaptionLbl: label 'Tel: (254 2) 750255-8 | Fax: (254 2) 750260 | E-Mail: enquiries@kilimambogoUniversity,co.ke | Website: www.karu.ac.ke ';
        Total_CaptionLbl: label 'Total:';
}

