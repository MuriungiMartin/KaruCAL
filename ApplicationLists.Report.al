#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51560 "Application Lists"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Application Lists.rdlc';

    dataset
    {
        dataitem(UnknownTable61348;UnknownTable61348)
        {
            DataItemTableView = sorting("Enquiry No.");
            RequestFilterFields = Programme,Status,"Registrar Approved";
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
            column(Enquiry_Header__Passport_National_ID_Number_;"Passport/National ID Number")
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
            column(Enquiry_Header__Registrar_Approved_;"Registrar Approved")
            {
            }
            column(RCount;RCount)
            {
            }
            column(Aplication_ListCaption;Aplication_ListCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Application_No_Caption;Application_No_CaptionLbl)
            {
            }
            column(Enquiry_Header__Enquiry_Date_Caption;FieldCaption("Enquiry Date"))
            {
            }
            column(Enquiry_Header__Name_Surname_First__Caption;FieldCaption("Name(Surname First)"))
            {
            }
            column(ID_NumberCaption;ID_NumberCaptionLbl)
            {
            }
            column(Enquiry_Header_ProgrammeCaption;FieldCaption(Programme))
            {
            }
            column(Enquiry_Header__Programme_Stage_Caption;FieldCaption("Programme Stage"))
            {
            }
            column(Semester_IntakeCaption;Semester_IntakeCaptionLbl)
            {
            }
            column(Enquiry_Header_StatusCaption;FieldCaption(Status))
            {
            }
            column(Enquiry_Header__Registrar_Approved_Caption;FieldCaption("Registrar Approved"))
            {
            }
            column(Student_CountsCaption;Student_CountsCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                RCount:=RCount+1;
            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("Enquiry No.");
                RCount:=0;
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
        RCount: Integer;
        Aplication_ListCaptionLbl: label 'Aplication List';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Application_No_CaptionLbl: label 'Application No.';
        ID_NumberCaptionLbl: label 'ID Number';
        Semester_IntakeCaptionLbl: label 'Semester/Intake';
        Student_CountsCaptionLbl: label 'Student Counts';
}

