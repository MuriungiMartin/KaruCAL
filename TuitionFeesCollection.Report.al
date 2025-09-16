#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51319 "Tuition Fees Collection"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Tuition Fees Collection.rdlc';

    dataset
    {
        dataitem("G/L Account";"G/L Account")
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Date Filter";
            column(ReportForNavId_6710; 6710)
            {
            }
            column(G_L_Account_No_;"No.")
            {
            }
            dataitem("G/L Entry";"G/L Entry")
            {
                DataItemLink = "G/L Account No."=field("No.");
                DataItemTableView = sorting("G/L Account No.","Posting Date","Document No.") order(ascending) where("G/L Account No."=const('200012'),"Document No."=filter('TR*'),Description=filter('Fees for *'),Amount=filter(<0));
                column(ReportForNavId_7069; 7069)
                {
                }
                column(COMPANYNAME;COMPANYNAME)
                {
                }
                column(FORMAT_TODAY_0_4_;Format(Today,0,4))
                {
                }
                column(USERID;UserId)
                {
                }
                column(CurrReport_PAGENO;CurrReport.PageNo)
                {
                }
                column(G_L_Entry__Posting_Date_;"Posting Date")
                {
                }
                column(G_L_Entry__Document_No__;"Document No.")
                {
                }
                column(G_L_Entry_Description;Description)
                {
                }
                column(G_L_Entry__Bal__Account_No__;"Bal. Account No.")
                {
                }
                column(G_L_Entry_Amount;Amount)
                {
                }
                column(G_L_Entry_Amount_Control1102760000;Amount)
                {
                }
                column(Tuition_Fees_CollectionsCaption;Tuition_Fees_CollectionsCaptionLbl)
                {
                }
                column(DescriptionCaption;DescriptionCaptionLbl)
                {
                }
                column(Student_No_Caption;Student_No_CaptionLbl)
                {
                }
                column(Posting_DateCaption;Posting_DateCaptionLbl)
                {
                }
                column(Receipt_NoCaption;Receipt_NoCaptionLbl)
                {
                }
                column(AmountCaption;AmountCaptionLbl)
                {
                }
                column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
                {
                }
                column(Total_AmountCaption;Total_AmountCaptionLbl)
                {
                }
                column(G_L_Entry_Entry_No_;"Entry No.")
                {
                }
                column(G_L_Entry_G_L_Account_No_;"G/L Account No.")
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
        Tuition_Fees_CollectionsCaptionLbl: label 'Tuition Fees Collections';
        DescriptionCaptionLbl: label 'Description';
        Student_No_CaptionLbl: label 'Student No.';
        Posting_DateCaptionLbl: label 'Posting Date';
        Receipt_NoCaptionLbl: label 'Receipt No';
        AmountCaptionLbl: label 'Amount';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Total_AmountCaptionLbl: label 'Total Amount';
}

