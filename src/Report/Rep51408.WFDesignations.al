#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51408 "WF Designations"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/WF Designations.rdlc';

    dataset
    {
        dataitem(UnknownTable61449;UnknownTable61449)
        {
            DataItemTableView = sorting(Type,Code);
            RequestFilterFields = Type;
            column(ReportForNavId_8323; 8323)
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
            column(WF_Designation_Type;Type)
            {
            }
            column(WF_Designation_Code;Code)
            {
            }
            column(WF_Designation_Description;Description)
            {
            }
            column(WF_Designation__Single_Position_;"Single Position")
            {
            }
            column(WF_DesignationCaption;WF_DesignationCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(TypeCaption;TypeCaptionLbl)
            {
            }
            column(WF_Designation_CodeCaption;FieldCaption(Code))
            {
            }
            column(WF_Designation_DescriptionCaption;FieldCaption(Description))
            {
            }
            column(WF_Designation__Single_Position_Caption;FieldCaption("Single Position"))
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
        WF_DesignationCaptionLbl: label 'WF Designation';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        TypeCaptionLbl: label 'Type';
}

