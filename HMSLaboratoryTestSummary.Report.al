#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51389 "HMS Laboratory Test Summary"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HMS Laboratory Test Summary.rdlc';

    dataset
    {
        dataitem(UnknownTable61416;UnknownTable61416)
        {
            DataItemTableView = sorting("Laboratory No.");
            RequestFilterFields = "Laboratory No.";
            column(ReportForNavId_7278; 7278)
            {
            }
            column(Date_Printed______FORMAT_TODAY_0_4_;'Date Printed: ' + Format(Today,0,4))
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(Printed_By______USERID;'Printed By: ' + UserId)
            {
            }
            column(HMS_Laboratory_Form_Header__Laboratory_No__;"Laboratory No.")
            {
            }
            column(HMS_Laboratory_Form_Header__Laboratory_Date_;"Laboratory Date")
            {
            }
            column(PFNo;PFNo)
            {
            }
            column(HMS_Laboratory_Form_Header__Supervisor_ID_;"Supervisor ID")
            {
            }
            column(HMS_Laboratory_Form_Header_Status;Status)
            {
            }
            column(HMS_Laboratory_Form_Header__Patient_Type_;"Patient Type")
            {
            }
            column(PatientName;PatientName)
            {
            }
            column(Number_of_Laboratory_Tests_Listed______FORMAT__HMS_Laboratory_Form_Header__COUNT_;'Number of Laboratory Tests Listed: ' + Format("HMS-Laboratory Form Header".Count))
            {
            }
            column(University_HEALTH_SERVICESCaption;University_HEALTH_SERVICESCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(LABORATORY_TESTS_LISTINGCaption;LABORATORY_TESTS_LISTINGCaptionLbl)
            {
            }
            column(No_Caption;No_CaptionLbl)
            {
            }
            column(DateCaption;DateCaptionLbl)
            {
            }
            column(PF_No_Caption;PF_No_CaptionLbl)
            {
            }
            column(ResponsibleCaption;ResponsibleCaptionLbl)
            {
            }
            column(HMS_Laboratory_Form_Header_StatusCaption;FieldCaption(Status))
            {
            }
            column(HMS_Laboratory_Form_Header__Patient_Type_Caption;FieldCaption("Patient Type"))
            {
            }
            column(Patient_nameCaption;Patient_nameCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Patient.Reset;
                PatientName:='';
                PFNo:='';
                if Patient.Get("Patient No.") then
                  begin
                    PatientName:=Patient.Surname + ' ' +Patient."Middle Name" +' ' +Patient."Last Name";
                    if Patient."Patient Type"=Patient."patient type"::Others then
                      begin
                        PFNo:=Patient."Student No.";
                      end
                    else if Patient."Patient Type"=Patient."patient type"::" " then
                      begin
                        PFNo:=Patient."Patient No.";
                      end
                    else
                      begin
                        PFNo:=Patient."Employee No.";
                      end;
                  end
            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("Laboratory No.");
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
        Patient: Record UnknownRecord61402;
        PatientName: Text[200];
        PFNo: Code[20];
        University_HEALTH_SERVICESCaptionLbl: label 'University HEALTH SERVICES';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        LABORATORY_TESTS_LISTINGCaptionLbl: label 'LABORATORY TESTS LISTING';
        No_CaptionLbl: label 'No.';
        DateCaptionLbl: label 'Date';
        PF_No_CaptionLbl: label 'PF/No.';
        ResponsibleCaptionLbl: label 'Responsible';
        Patient_nameCaptionLbl: label 'Patient name';
}

