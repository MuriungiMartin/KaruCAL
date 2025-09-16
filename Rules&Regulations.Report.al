#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51433 "Rules & Regulations"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Rules & Regulations.rdlc';

    dataset
    {
        dataitem(UnknownTable61287;UnknownTable61287)
        {
            DataItemTableView = sorting(Code);
            RequestFilterFields = "Code";
            column(ReportForNavId_4540; 4540)
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
            column(Rules___Regulations_Code;Code)
            {
            }
            column(Rules___Regulations_Date;Date)
            {
            }
            column(Rules___Regulations__Rules___Regulations_;"Rules & Regulations")
            {
            }
            column(Rules___Regulations_Attachement;Attachement)
            {
            }
            column(Rules___Regulations_Remarks;Remarks)
            {
            }
            column(Rules___RegulationsCaption;Rules___RegulationsCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Rules___Regulations_CodeCaption;FieldCaption(Code))
            {
            }
            column(Rules___Regulations_DateCaption;FieldCaption(Date))
            {
            }
            column(Rules___Regulations__Rules___Regulations_Caption;FieldCaption("Rules & Regulations"))
            {
            }
            column(Rules___Regulations_AttachementCaption;FieldCaption(Attachement))
            {
            }
            column(Rules___Regulations_RemarksCaption;FieldCaption(Remarks))
            {
            }

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo(Code);
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
        Rules___RegulationsCaptionLbl: label 'Rules & Regulations';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

