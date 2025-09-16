#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51386 "HMS Appointments Listing"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HMS Appointments Listing.rdlc';

    dataset
    {
        dataitem(UnknownTable61403;UnknownTable61403)
        {
            DataItemTableView = sorting("Appointment No.");
            RequestFilterFields = "Appointment No.","Appointment Date","Appointment Time","Patient Type";
            column(ReportForNavId_8549; 8549)
            {
            }
            column(DATE_PRINTED____FORMAT_TODAY_0_4_;'DATE PRINTED:' +Format(Today,0,4))
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(HMS_Appointment_Form_Header__Appointment_No__;"Appointment No.")
            {
            }
            column(HMS_Appointment_Form_Header__Appointment_Date_;"Appointment Date")
            {
            }
            column(HMS_Appointment_Form_Header__Appointment_Type_;"Appointment Type")
            {
            }
            column(HMS_Appointment_Form_Header_Doctor;Doctor)
            {
            }
            column(HMS_Appointment_Form_Header__Patient_Type_;"Patient Type")
            {
            }
            column(UPPERCASE_FORMAT_Status__;UpperCase(Format(Status)))
            {
            }
            column(PatientName;PatientName)
            {
            }
            column(PFNo;PFNo)
            {
            }
            column(HMS_Appointment_Form_Header__Appointment_Time_;"Appointment Time")
            {
            }
            column(TOTAL_APPOINTMENTS_LISTED_____FORMAT__HMS_Appointment_Form_Header__COUNT_;'TOTAL APPOINTMENTS LISTED:' + Format("HMS-Appointment Form Header".Count))
            {
            }
            column(PRINTED_BY____USERID;'PRINTED BY:' +UserId)
            {
            }
            column(University_HEALTH_SERVICESCaption;University_HEALTH_SERVICESCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(APPOINTMENTS_LISTINGCaption;APPOINTMENTS_LISTINGCaptionLbl)
            {
            }
            column(No_Caption;No_CaptionLbl)
            {
            }
            column(DateCaption;DateCaptionLbl)
            {
            }
            column(TypeCaption;TypeCaptionLbl)
            {
            }
            column(HMS_Appointment_Form_Header_DoctorCaption;FieldCaption(Doctor))
            {
            }
            column(HMS_Appointment_Form_Header__Patient_Type_Caption;FieldCaption("Patient Type"))
            {
            }
            column(StatusCaption;StatusCaptionLbl)
            {
            }
            column(Patient_NameCaption;Patient_NameCaptionLbl)
            {
            }
            column(PF_No_Caption;PF_No_CaptionLbl)
            {
            }
            column(TimeCaption;TimeCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Patient.Reset;
                PFNo:='';
                PatientName:='';
                if Patient.Get("Patient No.") then
                  begin
                    PatientName:=Patient.Surname + ' ' + Patient."Middle Name" + ' ' +Patient."Last Name";
                    if Patient."Patient Type"=Patient."patient type"::Others then
                      begin
                        PFNo:=Patient."Student No.";
                      end
                    else if Patient."Patient Type"=Patient."patient type"::Student then
                      begin
                        PFNo:=Patient."Employee No."
                      end
                    else if Patient."Patient Type"=Patient."patient type"::Employee then
                      begin
                        PFNo:=Patient."Employee No.";
                      end
                    else if Patient."Patient Type"=Patient."patient type"::" " then
                      begin
                        PFNo:=Patient."Patient No.";
                      end
                    else
                      begin
                        PFNo:=Patient."Patient No.";
                      end;
                  end;
            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("Appointment No.");
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
        PFNo: Code[20];
        PatientName: Text[200];
        University_HEALTH_SERVICESCaptionLbl: label 'University HEALTH SERVICES';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        APPOINTMENTS_LISTINGCaptionLbl: label 'APPOINTMENTS LISTING';
        No_CaptionLbl: label 'No.';
        DateCaptionLbl: label 'Date';
        TypeCaptionLbl: label 'Type';
        StatusCaptionLbl: label 'Status';
        Patient_NameCaptionLbl: label 'Patient Name';
        PF_No_CaptionLbl: label 'PF No.';
        TimeCaptionLbl: label 'Time';
}

