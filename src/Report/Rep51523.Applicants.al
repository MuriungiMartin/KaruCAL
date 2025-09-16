#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51523 Applicants
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Applicants.rdlc';

    dataset
    {
        dataitem(UnknownTable61348;UnknownTable61348)
        {
            DataItemTableView = sorting("Enquiry No.");
            RequestFilterFields = "Enquiry No.";
            column(ReportForNavId_8879; 8879)
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
            column(Enquiry_Header__Enquiry_No__;"Enquiry No.")
            {
            }
            column(Enquiry_Header__Enquiry_Date_;"Enquiry Date")
            {
            }
            column(Enquiry_Header__Name_Surname_First__;"Name(Surname First)")
            {
            }
            column(Enquiry_Header_Programme;Programme)
            {
            }
            column(Enquiry_Header__Programme_Stage_;"Programme Stage")
            {
            }
            column(Enquiry_Header_Semester;Semester)
            {
            }
            column(Enquiry_Header_Status;Status)
            {
            }
            column(KSPS_Enquiry_HeaderCaption;KSPS_Enquiry_HeaderCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Enquiry_Header__Enquiry_No__Caption;FieldCaption("Enquiry No."))
            {
            }
            column(Enquiry_Header__Enquiry_Date_Caption;FieldCaption("Enquiry Date"))
            {
            }
            column(Enquiry_Header__Name_Surname_First__Caption;FieldCaption("Name(Surname First)"))
            {
            }
            column(Enquiry_Header_ProgrammeCaption;FieldCaption(Programme))
            {
            }
            column(Enquiry_Header__Programme_Stage_Caption;FieldCaption("Programme Stage"))
            {
            }
            column(Enquiry_Header_SemesterCaption;FieldCaption(Semester))
            {
            }
            column(Enquiry_Header_StatusCaption;FieldCaption(Status))
            {
            }

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("Enquiry No.");
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
        KSPS_Enquiry_HeaderCaptionLbl: label 'KSPS Enquiry Header';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

