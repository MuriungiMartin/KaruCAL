#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51307 "SPECIAL HELB LOAN"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/SPECIAL HELB LOAN.rdlc';

    dataset
    {
        dataitem("G/L Entry";"G/L Entry")
        {
            DataItemTableView = sorting("Bal. Account No.") where("G/L Account No."=filter('300020'|'200012'),"Document No."=filter('*HELB*'),Reversed=const(false),"Bal. Account Type"=const(Customer),"Bal. Account No."=filter(<>''));
            RequestFilterFields = "Posting Date","Bal. Account No.","Document No.";
            column(ReportForNavId_7069; 7069)
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
            column(G_L_Entry__Posting_Date_;"Posting Date")
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
            column(G_L_Entry__Document_No__;"Document No.")
            {
            }
            column(G_L_Entry_Amount_Control1102756000;Amount)
            {
            }
            column(SPECIAL_STUDENTS_HELB_LOANCaption;SPECIAL_STUDENTS_HELB_LOANCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Posting_DateCaption;Posting_DateCaptionLbl)
            {
            }
            column(G_L_Entry_DescriptionCaption;FieldCaption(Description))
            {
            }
            column(Student_NoCaption;Student_NoCaptionLbl)
            {
            }
            column(G_L_Entry_AmountCaption;FieldCaption(Amount))
            {
            }
            column(G_L_Entry__Document_No__Caption;FieldCaption("Document No."))
            {
            }
            column(TotalCaption;TotalCaptionLbl)
            {
            }
            column(G_L_Entry_Entry_No_;"Entry No.")
            {
            }

            trigger OnAfterGetRecord()
            begin
                //RONO TO CATER FOR EDS STUDENTS
                startno:=CopyStr("G/L Entry"."Bal. Account No.",1,3);
                
                if startno='EDS' then begin
                   studstr:=CopyStr("G/L Entry"."Bal. Account No.",5,5);
                   StudNo:=Format(studstr);
                   if StudNo<'03000' then CurrReport.Skip;
                end
                else begin
                   studstr:=CopyStr("G/L Entry"."Bal. Account No.",4,5);
                   StudNo:=Format(studstr);
                   if StudNo<'03000' then CurrReport.Skip;
                
                end;
                //RONO
                /*
                     studstr:=COPYSTR("G/L Entry"."Bal. Account No.",4,5);
                   StudNo:=FORMAT(studstr);
                   IF StudNo<'03000' THEN CurrReport.SKIP;
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
        StudNo: Code[10];
        studstr: Code[20];
        startno: Code[10];
        SPECIAL_STUDENTS_HELB_LOANCaptionLbl: label 'SPECIAL STUDENTS HELB LOAN';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Posting_DateCaptionLbl: label 'Posting Date';
        Student_NoCaptionLbl: label 'Student No';
        TotalCaptionLbl: label 'Total';
}

