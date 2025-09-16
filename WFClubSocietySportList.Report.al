#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51407 "WF Club/Society/Sport List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/WF ClubSocietySport List.rdlc';

    dataset
    {
        dataitem(UnknownTable61448;UnknownTable61448)
        {
            DataItemTableView = sorting(Type,Code);
            RequestFilterFields = Type;
            column(ReportForNavId_9499; 9499)
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
            column(WF_Club_Society_Sport_Type;Type)
            {
            }
            column(WF_Club_Society_Sport_Code;Code)
            {
            }
            column(WF_Club_Society_Sport_Description;Description)
            {
            }
            column(Student_WelfareCaption;Student_WelfareCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(TypeCaption;TypeCaptionLbl)
            {
            }
            column(WF_Club_Society_Sport_CodeCaption;FieldCaption(Code))
            {
            }
            column(WF_Club_Society_Sport_DescriptionCaption;FieldCaption(Description))
            {
            }

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo(Type);
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
        Student_WelfareCaptionLbl: label 'Student Welfare';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        TypeCaptionLbl: label 'Type';
}

