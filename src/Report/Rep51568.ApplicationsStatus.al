#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51568 "Applications Status"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Applications Status.rdlc';

    dataset
    {
        dataitem(UnknownTable61348;UnknownTable61348)
        {
            DataItemTableView = sorting(Programme,"Registrar Approved");
            RequestFilterFields = Programme,"Registrar Approved";
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
            column(Enquiry_Header_Programme;Programme)
            {
            }
            column(Enquiry_Header__Registrar_Approved_;"Registrar Approved")
            {
            }
            column(Enquiry_Header_Semester;Semester)
            {
            }
            column(Enquiry_Header_Status;Status)
            {
            }
            column(Enquiry_Header__Programme_Stage_;"Programme Stage")
            {
            }
            column(Enquiry_Header_Programme_Control1102760014;Programme)
            {
            }
            column(Enquiry_Header__Passport_National_ID_Number_;"Passport/National ID Number")
            {
            }
            column(Enquiry_Header__Name_Surname_First__;"Name(Surname First)")
            {
            }
            column(Enquiry_Header__Enquiry_Date_;"Enquiry Date")
            {
            }
            column(Enquiry_Header__Enquiry_No__;"Enquiry No.")
            {
            }
            column(Enquiry_HeaderCaption;Enquiry_HeaderCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Enquiry_Header_ProgrammeCaption;FieldCaption(Programme))
            {
            }
            column(Enquiry_Header__Registrar_Approved_Caption;FieldCaption("Registrar Approved"))
            {
            }
            column(NamesCaption;NamesCaptionLbl)
            {
            }
            column(ID_NumberCaption;ID_NumberCaptionLbl)
            {
            }
            column(ProgrammeCaption;ProgrammeCaptionLbl)
            {
            }
            column(StageCaption;StageCaptionLbl)
            {
            }
            column(Semester_IntakeCaption;Semester_IntakeCaptionLbl)
            {
            }
            column(StatusCaption;StatusCaptionLbl)
            {
            }
            column(Application_DateCaption;Application_DateCaptionLbl)
            {
            }
            column(Application_No_Caption;Application_No_CaptionLbl)
            {
            }

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("Registrar Approved");
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
        Enquiry_HeaderCaptionLbl: label 'Enquiry Header';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        NamesCaptionLbl: label 'Names';
        ID_NumberCaptionLbl: label 'ID Number';
        ProgrammeCaptionLbl: label 'Programme';
        StageCaptionLbl: label 'Stage';
        Semester_IntakeCaptionLbl: label 'Semester/Intake';
        StatusCaptionLbl: label 'Status';
        Application_DateCaptionLbl: label 'Application Date';
        Application_No_CaptionLbl: label 'Application No.';
}

