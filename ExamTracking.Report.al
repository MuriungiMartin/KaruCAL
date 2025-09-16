#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51582 "Exam Tracking"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Exam Tracking.rdlc';

    dataset
    {
        dataitem(UnknownTable61517;UnknownTable61517)
        {
            DataItemTableView = sorting("Programme Code","Stage Code",Code,"Programme Option");
            RequestFilterFields = "Programme Code","Stage Code","Exam Status";
            column(ReportForNavId_2955; 2955)
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
            column(Units_Subjects__Programme_Code_;"Programme Code")
            {
            }
            column(Units_Subjects__Stage_Code_;"Stage Code")
            {
            }
            column(Units_Subjects_Code;Code)
            {
            }
            column(Units_Subjects_Desription;Desription)
            {
            }
            column(Units_Subjects__Exam_Status_;"Exam Status")
            {
            }
            column(Units_Subjects__Printed_Copies_;"Printed Copies")
            {
            }
            column(Units_Subjects__Issued_Copies_;"Issued Copies")
            {
            }
            column(Units_Subjects__Returned_Copies_;"Returned Copies")
            {
            }
            column(Units_Subjects__Exam_Remarks_;"Exam Remarks")
            {
            }
            column(Exam_TrackingCaption;Exam_TrackingCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Units_Subjects__Programme_Code_Caption;FieldCaption("Programme Code"))
            {
            }
            column(Units_Subjects__Stage_Code_Caption;FieldCaption("Stage Code"))
            {
            }
            column(Units_Subjects_CodeCaption;FieldCaption(Code))
            {
            }
            column(Units_Subjects_DesriptionCaption;FieldCaption(Desription))
            {
            }
            column(Units_Subjects__Exam_Status_Caption;FieldCaption("Exam Status"))
            {
            }
            column(Units_Subjects__Printed_Copies_Caption;FieldCaption("Printed Copies"))
            {
            }
            column(Units_Subjects__Issued_Copies_Caption;FieldCaption("Issued Copies"))
            {
            }
            column(Units_Subjects__Returned_Copies_Caption;FieldCaption("Returned Copies"))
            {
            }
            column(Units_Subjects__Exam_Remarks_Caption;FieldCaption("Exam Remarks"))
            {
            }
            column(Units_Subjects_Entry_No;"Entry No")
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
        Exam_TrackingCaptionLbl: label 'Exam Tracking';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

