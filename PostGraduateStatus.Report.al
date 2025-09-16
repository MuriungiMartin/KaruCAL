#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51323 "Post Graduate Status"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Post Graduate Status.rdlc';

    dataset
    {
        dataitem(UnknownTable61593;UnknownTable61593)
        {
            DataItemTableView = sorting("Student No");
            RequestFilterFields = "Student No";
            column(ReportForNavId_6437; 6437)
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
            column(Post_Grad_Change_History__Student_No_;"Student No")
            {
            }
            column(Post_Grad_Change_History__Programme_Code_;"Programme Code")
            {
            }
            column(Post_Grad_Change_History_Code;Code)
            {
            }
            column(Post_Grad_Change_History_Status;Status)
            {
            }
            column(Post_Grad_Change_History_Date;Date)
            {
            }
            column(Post_Grad_Change_History__Status_Type_;"Status Type")
            {
            }
            column(Post_Graduate_Change_HistoryCaption;Post_Graduate_Change_HistoryCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Post_Grad_Change_History_CodeCaption;FieldCaption(Code))
            {
            }
            column(Post_Grad_Change_History_StatusCaption;FieldCaption(Status))
            {
            }
            column(Post_Grad_Change_History_DateCaption;FieldCaption(Date))
            {
            }
            column(Post_Grad_Change_History__Status_Type_Caption;FieldCaption("Status Type"))
            {
            }
            column(Post_Grad_Change_History__Student_No_Caption;FieldCaption("Student No"))
            {
            }
            column(Post_Grad_Change_History__Programme_Code_Caption;FieldCaption("Programme Code"))
            {
            }
            column(Post_Grad_Change_History_Line_No;"Line No")
            {
            }

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("Student No");
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
        Post_Graduate_Change_HistoryCaptionLbl: label 'Post Graduate Change History';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

