#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51406 "Disciplinary Actions Student"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Disciplinary Actions Student.rdlc';

    dataset
    {
        dataitem(UnknownTable61298;UnknownTable61298)
        {
            DataItemTableView = sorting(Code);
            column(ReportForNavId_2971; 2971)
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
            column(Disciplinary_Actions_Code;Code)
            {
            }
            column(Disciplinary_Actions_Description;Description)
            {
            }
            column(Disciplinary_Actions_Terminate;Terminate)
            {
            }
            column(Disciplinary_Actions_Comments;Comments)
            {
            }
            column(Disciplinary_ActionsCaption;Disciplinary_ActionsCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Disciplinary_Actions_CodeCaption;FieldCaption(Code))
            {
            }
            column(Disciplinary_Actions_DescriptionCaption;FieldCaption(Description))
            {
            }
            column(Disciplinary_Actions_TerminateCaption;FieldCaption(Terminate))
            {
            }
            column(Disciplinary_Actions_CommentsCaption;FieldCaption(Comments))
            {
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
        Disciplinary_ActionsCaptionLbl: label 'Disciplinary Actions';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

