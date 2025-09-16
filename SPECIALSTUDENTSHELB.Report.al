#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51306 "SPECIAL STUDENTS HELB"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/SPECIAL STUDENTS HELB.rdlc';

    dataset
    {
        dataitem("Cust. Ledger Entry";"Cust. Ledger Entry")
        {
            DataItemTableView = sorting("Entry No.") where("Document No."=filter('HELB*'));
            RequestFilterFields = "Document No.","Posting Date","Customer No.",Description;
            column(ReportForNavId_8503; 8503)
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
            column(Cust__Ledger_Entry__Posting_Date_;"Posting Date")
            {
            }
            column(Cust__Ledger_Entry__Customer_No__;"Customer No.")
            {
            }
            column(Cust__Ledger_Entry_Description;Description)
            {
            }
            column(Cust__Ledger_Entry_Amount;Amount)
            {
            }
            column(Cust__Ledger_Entry__Document_No__;"Document No.")
            {
            }
            column(ABS_Amount_;Abs(Amount))
            {
            }
            column(JAB_STUDENTS_HELB_LOANCaption;JAB_STUDENTS_HELB_LOANCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Cust__Ledger_Entry__Posting_Date_Caption;FieldCaption("Posting Date"))
            {
            }
            column(Cust__Ledger_Entry__Customer_No__Caption;FieldCaption("Customer No."))
            {
            }
            column(Cust__Ledger_Entry_DescriptionCaption;FieldCaption(Description))
            {
            }
            column(Cust__Ledger_Entry_AmountCaption;FieldCaption(Amount))
            {
            }
            column(Cust__Ledger_Entry__Document_No__Caption;FieldCaption("Document No."))
            {
            }
            column(TOTALCaption;TOTALCaptionLbl)
            {
            }
            column(Cust__Ledger_Entry_Entry_No_;"Entry No.")
            {
            }

            trigger OnAfterGetRecord()
            begin
                //RONO   TO CATER FOR EDS STUDENTS
                startno:=CopyStr("Cust. Ledger Entry"."Customer No.",1,3);
                
                if startno='EDS' then begin
                   StudStr:=CopyStr("Cust. Ledger Entry"."Customer No.",5,5);
                   StudNo:=Format(StudStr);
                   if StudNo>'03000' then CurrReport.Skip;
                end
                else begin
                   StudStr:=CopyStr("Cust. Ledger Entry"."Customer No.",4,5);
                   StudNo:=Format(StudStr);
                   if StudNo>'03000' then CurrReport.Skip;
                
                end;
                //RONO
                
                
                  /*
                
                   StudStr:=COPYSTR("Cust. Ledger Entry"."Customer No.",4,5);
                   StudNo:=FORMAT(StudStr);
                   IF StudNo>'03000' THEN CurrReport.SKIP;
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
        StudNo: Code[20];
        StudStr: Text[30];
        startno: Code[10];
        JAB_STUDENTS_HELB_LOANCaptionLbl: label 'JAB STUDENTS HELB LOAN';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        TOTALCaptionLbl: label 'TOTAL';
}

