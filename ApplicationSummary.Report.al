#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51350 "Application Summary"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Application Summary.rdlc';

    dataset
    {
        dataitem(UnknownTable61358;UnknownTable61358)
        {
            DataItemTableView = sorting("Application No.");
            RequestFilterFields = "Application No.";
            column(ReportForNavId_2953; 2953)
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(SUMMARY_LIST_FOR_SPECIAL_ADMISSION_______Application_Form_Header___Academic_Year_______;'SUMMARY LIST FOR SPECIAL ADMISSION (' + "ACA-Applic. Form Header"."Academic Year" + ')')
            {
            }
            column(Surname________Other_Names_;Surname +' ' +"Other Names")
            {
            }
            column(Application_Form_Header__Address_for_Correspondence1_;"Address for Correspondence1")
            {
            }
            column(Application_Form_Header__Address_for_Correspondence2_;"Address for Correspondence2")
            {
            }
            column(Application_Form_Header__Address_for_Correspondence3_;"Address for Correspondence3")
            {
            }
            column(Application_Form_Header__Mean_Grade_Acquired_;"Mean Grade Acquired")
            {
            }
            column(Application_Form_Header__HOD_Recommendations_;"HOD Recommendations")
            {
            }
            column(Application_Form_Header__Dean_Recommendations_;"Dean Recommendations")
            {
            }
            column(CourseName;CourseName)
            {
            }
            column(Qualifications;Qualifications)
            {
            }
            column(IntC;IntC)
            {
            }
            column(NAMECaption;NAMECaptionLbl)
            {
            }
            column(ADDRESSCaption;ADDRESSCaptionLbl)
            {
            }
            column(QUALIFICATIONCaption;QUALIFICATIONCaptionLbl)
            {
            }
            column(MEAN_GRADECaption;MEAN_GRADECaptionLbl)
            {
            }
            column(COURSE_REQUIREDCaption;COURSE_REQUIREDCaptionLbl)
            {
            }
            column(REMARKS_FROM_DEANS_HODCaption;REMARKS_FROM_DEANS_HODCaptionLbl)
            {
            }
            column(CONFIRMED_BY_Caption;CONFIRMED_BY_CaptionLbl)
            {
            }
            column(APPROVED_BY_Caption;APPROVED_BY_CaptionLbl)
            {
            }
            column(DATE_Caption;DATE_CaptionLbl)
            {
            }
            column(DATE_Caption_Control1102760039;DATE_Caption_Control1102760039Lbl)
            {
            }
            column(EmptyStringCaption;EmptyStringCaptionLbl)
            {
            }
            column(EmptyStringCaption_Control1102760041;EmptyStringCaption_Control1102760041Lbl)
            {
            }
            column(EmptyStringCaption_Control1102760042;EmptyStringCaption_Control1102760042Lbl)
            {
            }
            column(EmptyStringCaption_Control1102760043;EmptyStringCaption_Control1102760043Lbl)
            {
            }
            column(DEPUTY_REGISTRAR__ACADEMIC_AFFAIRSCaption;DEPUTY_REGISTRAR__ACADEMIC_AFFAIRSCaptionLbl)
            {
            }
            column(CHAIRMAN__DEANS_COMMITTEECaption;CHAIRMAN__DEANS_COMMITTEECaptionLbl)
            {
            }
            column(APPROVED_BY_Caption_Control1102760001;APPROVED_BY_Caption_Control1102760001Lbl)
            {
            }
            column(EmptyStringCaption_Control1102760004;EmptyStringCaption_Control1102760004Lbl)
            {
            }
            column(CHAIRMAN__SENATECaption;CHAIRMAN__SENATECaptionLbl)
            {
            }
            column(DATE_Caption_Control1102760048;DATE_Caption_Control1102760048Lbl)
            {
            }
            column(EmptyStringCaption_Control1102760049;EmptyStringCaption_Control1102760049Lbl)
            {
            }
            column(Application_Form_Header_Application_No_;"Application No.")
            {
            }

            trigger OnAfterGetRecord()
            begin
                /*Get the name of the course from the database*/
                IntC:=IntC +1;
                Programme.Reset;
                if Programme.Get("ACA-Applic. Form Header"."First Degree Choice") then
                  begin
                    CourseName:=Programme.Description;
                  end;
                /*Get the qualifications from the database*/
                
                Qualifications:='';
                
                AppSubject.Reset;
                AppSubject.SetRange(AppSubject."Application No.","ACA-Applic. Form Header"."Application No.");
                if AppSubject.Find('-') then
                  begin
                    repeat
                      Qualifications:=Qualifications + AppSubject."Subject Code" +'  ' + AppSubject.Grade + '' +';';
                    until AppSubject.Next=0;
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
        CourseName: Text[100];
        Qualifications: Text[200];
        IntC: Integer;
        Programme: Record UnknownRecord61511;
        AppSubject: Record UnknownRecord61362;
        NAMECaptionLbl: label 'NAME';
        ADDRESSCaptionLbl: label 'ADDRESS';
        QUALIFICATIONCaptionLbl: label 'QUALIFICATION';
        MEAN_GRADECaptionLbl: label 'MEAN GRADE';
        COURSE_REQUIREDCaptionLbl: label 'COURSE REQUIRED';
        REMARKS_FROM_DEANS_HODCaptionLbl: label 'REMARKS FROM DEANS/HOD';
        CONFIRMED_BY_CaptionLbl: label 'CONFIRMED BY:';
        APPROVED_BY_CaptionLbl: label 'APPROVED BY:';
        DATE_CaptionLbl: label 'DATE:';
        DATE_Caption_Control1102760039Lbl: label 'DATE:';
        EmptyStringCaptionLbl: label '__________________________________________________________________________________________________________________________________';
        EmptyStringCaption_Control1102760041Lbl: label '__________________________________________________________________________________________________________________________________';
        EmptyStringCaption_Control1102760042Lbl: label '__________________________________________________________________________________________________________________________________';
        EmptyStringCaption_Control1102760043Lbl: label '__________________________________________________________________________________________________________________________________';
        DEPUTY_REGISTRAR__ACADEMIC_AFFAIRSCaptionLbl: label 'DEPUTY REGISTRAR, ACADEMIC AFFAIRS';
        CHAIRMAN__DEANS_COMMITTEECaptionLbl: label 'CHAIRMAN, DEANS COMMITTEE';
        APPROVED_BY_Caption_Control1102760001Lbl: label 'APPROVED BY:';
        EmptyStringCaption_Control1102760004Lbl: label '__________________________________________________________________________________________________________________________________';
        CHAIRMAN__SENATECaptionLbl: label 'CHAIRMAN, SENATE';
        DATE_Caption_Control1102760048Lbl: label 'DATE:';
        EmptyStringCaption_Control1102760049Lbl: label '__________________________________________________________________________________________________________________________________';
}

