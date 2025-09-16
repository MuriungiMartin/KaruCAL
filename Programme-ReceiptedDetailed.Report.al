#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51499 "Programme - Receipted Detailed"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Programme - Receipted Detailed.rdlc';

    dataset
    {
        dataitem(UnknownTable61511;UnknownTable61511)
        {
            DataItemTableView = sorting(Code);
            RequestFilterFields = "Code","Semester Filter","School Code","Date Filter",Status;
            column(ReportForNavId_1410; 1410)
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
            column(Programme_Code;Code)
            {
            }
            column(Programme_Description;Description)
            {
            }
            column(Programme__Total_Income__Rcpt__;"Total Income (Rcpt)")
            {
            }
            column(Programme__Total_Income__Rcpt___Control1000000010;"Total Income (Rcpt)")
            {
            }
            column(Programme_Receipted_Income_Caption;Programme_Receipted_Income_CaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(AmountCaption;AmountCaptionLbl)
            {
            }
            column(Student_NameCaption;Student_NameCaptionLbl)
            {
            }
            column(Student_No_Caption;Student_No_CaptionLbl)
            {
            }
            column(Receipt_No_Caption;Receipt_No_CaptionLbl)
            {
            }
            column(Programme_CodeCaption;FieldCaption(Code))
            {
            }
            column(Programme_DescriptionCaption;FieldCaption(Description))
            {
            }
            column(Programme__Total_Income__Rcpt__Caption;FieldCaption("Total Income (Rcpt)"))
            {
            }
            column(Programme_Date_Filter;"Date Filter")
            {
            }
            dataitem(UnknownTable61539;UnknownTable61539)
            {
                DataItemLink = Programme=field(Code),Date=field("Date Filter");
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
                column(Receipt_Items_Programme;Programme)
                {
                }
                column(Receipt_Items_Date;Date)
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
                    //"Receipt Items".SETFILTER("Receipt Items".Date,Programme.GETFILTER(Programme."Date Filter"));
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
        Programme_Receipted_Income_CaptionLbl: label 'Programme Receipted Income ';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        AmountCaptionLbl: label 'Amount';
        Student_NameCaptionLbl: label 'Student Name';
        Student_No_CaptionLbl: label 'Student No.';
        Receipt_No_CaptionLbl: label 'Receipt No.';
}

