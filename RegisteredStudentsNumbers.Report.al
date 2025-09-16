#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51690 "Registered Students Numbers"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Registered Students Numbers.rdlc';

    dataset
    {
        dataitem(UnknownTable61516;UnknownTable61516)
        {
            CalcFields = "Student Registered";
            DataItemTableView = sorting("Programme Code",Code);
            RequestFilterFields = "Semester Filter";
            column(ReportForNavId_3691; 3691)
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
            column(Programme_Stages__Programme_Code_;"Programme Code")
            {
            }
            column(Programme_Stages_Code;Code)
            {
            }
            column(Programme_Stages__Student_Registered_;"Student Registered")
            {
            }
            column(Hesabu;Hesabu)
            {
            }
            column(Programme_Stages_Paid;Paid)
            {
            }
            column(Kaitet;Kaitet)
            {
            }
            column(Programme_Stages_Paid_Control1000000013;Paid)
            {
            }
            column(Programme_StagesCaption;Programme_StagesCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Programme_Stages__Programme_Code_Caption;FieldCaption("Programme Code"))
            {
            }
            column(Programme_Stages_CodeCaption;FieldCaption(Code))
            {
            }
            column(Programme_Stages__Student_Registered_Caption;FieldCaption("Student Registered"))
            {
            }
            column(No_Caption;No_CaptionLbl)
            {
            }
            column(PaidCaption;PaidCaptionLbl)
            {
            }
            column(TotalCaption;TotalCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                 Hesabu:=Hesabu+1;
                Kaitet:=Kaitet+"ACA-Programme Stages"."Student Registered";
                Paid:=Paid+"ACA-Programme Stages".Paid;
            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("Programme Code");
                Hesabu:=0;
                Kaitet:=0;
                Paid:=0;
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
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        Hesabu: Integer;
        Kaitet: Integer;
        Paid: Integer;
        Programme_StagesCaptionLbl: label 'Programme Stages';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        No_CaptionLbl: label 'No.';
        PaidCaptionLbl: label 'Paid';
        TotalCaptionLbl: label 'Total';
}

