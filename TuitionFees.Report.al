#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51318 "Tuition Fees"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Tuition Fees.rdlc';

    dataset
    {
        dataitem(UnknownTable61532;UnknownTable61532)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Student No.",Programme;
            column(ReportForNavId_2901; 2901)
            {
            }
            column(USERID;UserId)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(Total;Total)
            {
            }
            column(AmountCaption;AmountCaptionLbl)
            {
            }
            column(Receipt_NoCaption;Receipt_NoCaptionLbl)
            {
            }
            column(Posting_DateCaption;Posting_DateCaptionLbl)
            {
            }
            column(DescriptionCaption;DescriptionCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Student_No_Caption;Student_No_CaptionLbl)
            {
            }
            column(Tuition_Fees_CollectionsCaption;Tuition_Fees_CollectionsCaptionLbl)
            {
            }
            column(TotalCaption;TotalCaptionLbl)
            {
            }
            column(Course_Registration_Reg__Transacton_ID;"Reg. Transacton ID")
            {
            }
            column(Course_Registration_Student_No_;"Student No.")
            {
            }
            column(Course_Registration_Programme;Programme)
            {
            }
            column(Course_Registration_Semester;Semester)
            {
            }
            column(Course_Registration_Register_for;"Register for")
            {
            }
            column(Course_Registration_Stage;Stage)
            {
            }
            column(Course_Registration_Unit;Unit)
            {
            }
            column(Course_Registration_Student_Type;"Student Type")
            {
            }
            column(Course_Registration_Entry_No_;"Entry No.")
            {
            }
            dataitem("G/L Entry";"G/L Entry")
            {
                DataItemLink = "Bal. Account No."=field("Student No.");
                DataItemTableView = where("G/L Account No."=const('200012'),"Document No."=filter('TR*'),Description=filter('Fees for *'),Amount=filter(<0));
                column(ReportForNavId_7069; 7069)
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
                column(G_L_Entry_Entry_No_;"Entry No.")
                {
                }
            }

            trigger OnPreDataItem()
            begin
                  Total:=0;
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
        Total: Decimal;
        AmountCaptionLbl: label 'Amount';
        Receipt_NoCaptionLbl: label 'Receipt No';
        Posting_DateCaptionLbl: label 'Posting Date';
        DescriptionCaptionLbl: label 'Description';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Student_No_CaptionLbl: label 'Student No.';
        Tuition_Fees_CollectionsCaptionLbl: label 'Tuition Fees Collections';
        TotalCaptionLbl: label 'Total';
}

