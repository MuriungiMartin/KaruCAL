#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51498 "Charges - Receipted Detailed"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Charges - Receipted Detailed.rdlc';

    dataset
    {
        dataitem(UnknownTable61515;UnknownTable61515)
        {
            DataItemTableView = sorting(Code);
            RequestFilterFields = "Code","Date Filter";
            column(ReportForNavId_9183; 9183)
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
            column(Charge__Date_Filter_;"Date Filter")
            {
            }
            column(Charge_Code;Code)
            {
            }
            column(Charge_Description;Description)
            {
            }
            column(Charge__G_L_Account_;"G/L Account")
            {
            }
            column(Charge__Total_Income_;"Total Income")
            {
            }
            column(Charge__Total_Income__Control1000000010;"Total Income")
            {
            }
            column(Charges___Amount_ReceiptedCaption;Charges___Amount_ReceiptedCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Charge__Date_Filter_Caption;FieldCaption("Date Filter"))
            {
            }
            column(Receipt_Items_AmountCaption;"ACA-Receipt Items".FieldCaption(Amount))
            {
            }
            column(Student_NameCaption;Student_NameCaptionLbl)
            {
            }
            column(Student_No_Caption;Student_No_CaptionLbl)
            {
            }
            column(Receipt_Items__Receipt_No_Caption;"ACA-Receipt Items".FieldCaption("Receipt No"))
            {
            }
            column(Charge_CodeCaption;FieldCaption(Code))
            {
            }
            column(Charge_DescriptionCaption;FieldCaption(Description))
            {
            }
            column(Charge__G_L_Account_Caption;FieldCaption("G/L Account"))
            {
            }
            column(Charge__Total_Income_Caption;FieldCaption("Total Income"))
            {
            }
            dataitem(UnknownTable61539;UnknownTable61539)
            {
                DataItemLink = Code=field(Code);
                column(ReportForNavId_9528; 9528)
                {
                }
                column(Name;Name)
                {
                }
                column(Receipt_Items_Amount;Amount)
                {
                }
                column(StudentNo;StudentNo)
                {
                }
                column(Receipt_Items__Receipt_No_;"Receipt No")
                {
                }
                column(Receipt_Items_Uniq_No_2;"Uniq No 2")
                {
                }
                column(Receipt_Items_Transaction_ID;"Transaction ID")
                {
                }
                column(Receipt_Items_Description;Description)
                {
                }
                column(Receipt_Items_Code;Code)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if Rcpt.Get("ACA-Receipt Items"."Receipt No") then begin
                    StudentNo:=Rcpt."Student No.";
                    Name:=Rcpt."Student Name"
                    end else begin
                    Name:='';
                    StudentNo:='';
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    "ACA-Receipt Items".SetFilter("ACA-Receipt Items".Date,"ACA-Charge".GetFilter("ACA-Charge"."Date Filter"));
                end;
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
        Rcpt: Record UnknownRecord61538;
        Name: Text[250];
        StudentNo: Code[20];
        Charges___Amount_ReceiptedCaptionLbl: label 'Charges - Amount Receipted';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Student_NameCaptionLbl: label 'Student Name';
        Student_No_CaptionLbl: label 'Student No.';
}

