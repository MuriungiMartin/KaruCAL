#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51410 "WF Award List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/WF Award List.rdlc';

    dataset
    {
        dataitem(UnknownTable61451;UnknownTable61451)
        {
            DataItemTableView = sorting(Type,Code);
            RequestFilterFields = Type;
            column(ReportForNavId_1933; 1933)
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
            column(WF_Award_Type;Type)
            {
            }
            column(WF_Award_Code;Code)
            {
            }
            column(WF_Award_Description;Description)
            {
            }
            column(Award_ListCaption;Award_ListCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(TypeCaption;TypeCaptionLbl)
            {
            }
            column(WF_Award_CodeCaption;FieldCaption(Code))
            {
            }
            column(WF_Award_DescriptionCaption;FieldCaption(Description))
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
        Award_ListCaptionLbl: label 'Award List';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        TypeCaptionLbl: label 'Type';
}

