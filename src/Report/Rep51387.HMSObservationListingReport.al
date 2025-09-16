#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51387 "HMS Observation Listing Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HMS Observation Listing Report.rdlc';

    dataset
    {
        dataitem(UnknownTable61404;UnknownTable61404)
        {
            DataItemTableView = sorting("Observation No.");
            RequestFilterFields = "Observation No.";
            column(ReportForNavId_8630; 8630)
            {
            }
            column(DATE_PRINTED_____UPPERCASE_FORMAT_TODAY_0_4__;'DATE PRINTED:' + UpperCase(Format(Today,0,4)))
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(PRINTED_BY____USERID;'PRINTED BY:' +UserId)
            {
            }
            column(HMS_Observation_Form_Header__Observation_No__;"Observation No.")
            {
            }
            column(HMS_Observation_Form_Header__Observation_Date_;"Observation Date")
            {
            }
            column(HMS_Observation_Form_Header__Observation_Time_;"Observation Time")
            {
            }
            column(HMS_Observation_Form_Header__Observation_Remarks_;"Observation Remarks")
            {
            }
            column(HMS_Observation_Form_Header_Closed;Closed)
            {
            }
            column(PFNo;PFNo)
            {
            }
            column(PatientName;PatientName)
            {
            }
            column(OBSERVATIONS_LISTED_____FORMAT__HMS_Observation_Form_Header__COUNT_;'OBSERVATIONS LISTED: ' +Format("HMS-Observation Form Header".Count))
            {
            }
            column(University_HEALTH_SERVICESCaption;University_HEALTH_SERVICESCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(No_Caption;No_CaptionLbl)
            {
            }
            column(DateCaption;DateCaptionLbl)
            {
            }
            column(TimeCaption;TimeCaptionLbl)
            {
            }
            column(RemarksCaption;RemarksCaptionLbl)
            {
            }
            column(HMS_Observation_Form_Header_ClosedCaption;FieldCaption(Closed))
            {
            }
            column(PF_No_Caption;PF_No_CaptionLbl)
            {
            }
            column(Patient_nameCaption;Patient_nameCaptionLbl)
            {
            }
            column(OBSERVATION_LISTING_REPORTCaption;OBSERVATION_LISTING_REPORTCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Patient.Reset;
                PatientName:='';
                PFNo:='';
                if Patient.Get("Patient No.") then
                  begin
                    PatientName:=Patient.Surname + ' '  + Patient."Middle Name" +' ' +Patient."Last Name";
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
                  end;
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
        PFNo: Code[20];
        PatientName: Text[100];
        Patient: Record UnknownRecord61402;
        University_HEALTH_SERVICESCaptionLbl: label 'University HEALTH SERVICES';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        No_CaptionLbl: label 'No.';
        DateCaptionLbl: label 'Date';
        TimeCaptionLbl: label 'Time';
        RemarksCaptionLbl: label 'Remarks';
        PF_No_CaptionLbl: label 'PF No.';
        Patient_nameCaptionLbl: label 'Patient name';
        OBSERVATION_LISTING_REPORTCaptionLbl: label 'OBSERVATION LISTING REPORT';
}

