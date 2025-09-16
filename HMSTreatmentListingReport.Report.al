#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51388 "HMS Treatment Listing Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HMS Treatment Listing Report.rdlc';

    dataset
    {
        dataitem(UnknownTable61407;UnknownTable61407)
        {
            DataItemTableView = sorting("Treatment No.");
            RequestFilterFields = "Treatment No.","Doctor ID";
            column(ReportForNavId_3701; 3701)
            {
            }
            column(Date_Printed_____FORMAT_TODAY_0_4_;'Date Printed: ' +Format(Today,0,4))
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
            column(HMS_Treatment_Form_Header__Treatment_No__;"Treatment No.")
            {
            }
            column(HMS_Treatment_Form_Header__Treatment_Type_;"Treatment Type")
            {
            }
            column(HMS_Treatment_Form_Header__Treatment_Date_;"Treatment Date")
            {
            }
            column(HMS_Treatment_Form_Header__Doctor_ID_;"Doctor ID")
            {
            }
            column(PFNo;PFNo)
            {
            }
            column(HMS_Treatment_Form_Header_Status;Status)
            {
            }
            column(HMS_Treatment_Form_Header__Treatment_Location_;"Treatment Location")
            {
            }
            column(HMS_Treatment_Form_Header__Patient_Type_;"Patient Type")
            {
            }
            column(PatientName;PatientName)
            {
            }
            column(Number_of_Treatment_s__Listed______FORMAT__HMS_Treatment_Form_Header__COUNT_;'Number of Treatment(s) Listed: ' + Format("HMS-Treatment Form Header".Count))
            {
            }
            column(University_HEALTH_SERVICESCaption;University_HEALTH_SERVICESCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(TREATMENT_LISTING_REPORTCaption;TREATMENT_LISTING_REPORTCaptionLbl)
            {
            }
            column(No_Caption;No_CaptionLbl)
            {
            }
            column(TypeCaption;TypeCaptionLbl)
            {
            }
            column(DateCaption;DateCaptionLbl)
            {
            }
            column(HMS_Treatment_Form_Header__Doctor_ID_Caption;FieldCaption("Doctor ID"))
            {
            }
            column(PF_No_Caption;PF_No_CaptionLbl)
            {
            }
            column(HMS_Treatment_Form_Header_StatusCaption;FieldCaption(Status))
            {
            }
            column(Patient_Loc_Caption;Patient_Loc_CaptionLbl)
            {
            }
            column(Pat__TypeCaption;Pat__TypeCaptionLbl)
            {
            }
            column(Patient_nameCaption;Patient_nameCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Patient.Reset;
                PFNo:='';
                PatientName:='';
                if Patient.Get("Patient No.") then
                  begin
                    PatientName:=Patient.Surname + ' ' + Patient."Middle Name" + Patient."Last Name";
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

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("Treatment No.");
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
        TREATMENT_LISTING_REPORTCaptionLbl: label 'TREATMENT LISTING REPORT';
        No_CaptionLbl: label 'No.';
        TypeCaptionLbl: label 'Type';
        DateCaptionLbl: label 'Date';
        PF_No_CaptionLbl: label 'PF No.';
        Patient_Loc_CaptionLbl: label 'Patient Loc.';
        Pat__TypeCaptionLbl: label 'Pat. Type';
        Patient_nameCaptionLbl: label 'Patient name';
}

