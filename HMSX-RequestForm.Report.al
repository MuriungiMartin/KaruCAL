#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51383 "HMS X-Request Form"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HMS X-Request Form.rdlc';

    dataset
    {
        dataitem(UnknownTable61407;UnknownTable61407)
        {
            DataItemTableView = sorting("Treatment No.");
            RequestFilterFields = "Treatment No.";
            column(ReportForNavId_3701; 3701)
            {
            }
            column(UPPERCASE_COMPANYNAME_;UpperCase(COMPANYNAME))
            {
            }
            column(UPPERCASE_Company__Post_Code__;UpperCase(Company."Post Code"))
            {
            }
            column(TEL____Company__Phone_No___________Company__Phone_No__2_;'TEL:' +Company."Phone No." + '/' + Company."Phone No. 2")
            {
            }
            column(UPPERCASE_Company_City_;UpperCase(Company.City))
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(HMS_Treatment_Form_Header__Treatment_No__;"Treatment No.")
            {
            }
            column(Age;Age)
            {
            }
            column(Sex______Gender;'Sex: ' + Gender)
            {
            }
            column(Name_of_Patient______UPPERCASE_PatientName_;'Name of Patient: ' + UpperCase(PatientName))
            {
            }
            column(PF_NO______PFNo;'PF/NO: ' + PFNo)
            {
            }
            column(Department___;'Department: ')
            {
            }
            column(HMS_Treatment_Form_Header__Treatment_Remarks_;"Treatment Remarks")
            {
            }
            column(Doctors_Name______DoctorName;'Doctors Name: ' + DoctorName)
            {
            }
            column(University_HEALTH_SERVICESCaption;University_HEALTH_SERVICESCaptionLbl)
            {
            }
            column(Date_Caption;Date_CaptionLbl)
            {
            }
            column(X_RAY_REQUEST_FORMCaption;X_RAY_REQUEST_FORMCaptionLbl)
            {
            }
            column(Our_Ref_Caption;Our_Ref_CaptionLbl)
            {
            }
            column(DataItem1102760012;To___________________________________________________________________________________________________________________________Lbl)
            {
            }
            column(EmptyStringCaption;EmptyStringCaptionLbl)
            {
            }
            column(EmptyStringCaption_Control1102760014;EmptyStringCaption_Control1102760014Lbl)
            {
            }
            column(EmptyStringCaption_Control1102760015;EmptyStringCaption_Control1102760015Lbl)
            {
            }
            column(EmptyStringCaption_Control1102760016;EmptyStringCaption_Control1102760016Lbl)
            {
            }
            column(EmptyStringCaption_Control1102760017;EmptyStringCaption_Control1102760017Lbl)
            {
            }
            column(EmptyStringCaption_Control1102760018;EmptyStringCaption_Control1102760018Lbl)
            {
            }
            column(EmptyStringCaption_Control1102760022;EmptyStringCaption_Control1102760022Lbl)
            {
            }
            column(EmptyStringCaption_Control1102760023;EmptyStringCaption_Control1102760023Lbl)
            {
            }
            column(Clinical_Notes_Caption;Clinical_Notes_CaptionLbl)
            {
            }
            column(InvestigationsCaption;InvestigationsCaptionLbl)
            {
            }
            column(Sign_Caption;Sign_CaptionLbl)
            {
            }
            column(EmptyStringCaption_Control1102760029;EmptyStringCaption_Control1102760029Lbl)
            {
            }
            column(EmptyStringCaption_Control1102760030;EmptyStringCaption_Control1102760030Lbl)
            {
            }
            column(Radiologist_Report_Caption;Radiologist_Report_CaptionLbl)
            {
            }
            column(EmptyStringCaption_Control1102760035;EmptyStringCaption_Control1102760035Lbl)
            {
            }
            column(EmptyStringCaption_Control1102760036;EmptyStringCaption_Control1102760036Lbl)
            {
            }
            column(EmptyStringCaption_Control1102760037;EmptyStringCaption_Control1102760037Lbl)
            {
            }
            column(EmptyStringCaption_Control1102760038;EmptyStringCaption_Control1102760038Lbl)
            {
            }
            column(EmptyStringCaption_Control1102760039;EmptyStringCaption_Control1102760039Lbl)
            {
            }
            column(Sign_Caption_Control1102760040;Sign_Caption_Control1102760040Lbl)
            {
            }
            column(Date_Caption_Control1102760041;Date_Caption_Control1102760041Lbl)
            {
            }
            column(EmptyStringCaption_Control1102760042;EmptyStringCaption_Control1102760042Lbl)
            {
            }
            column(EmptyStringCaption_Control1102760043;EmptyStringCaption_Control1102760043Lbl)
            {
            }
            dataitem(UnknownTable61411;UnknownTable61411)
            {
                DataItemLink = "Treatment No."=field("Treatment No.");
                column(ReportForNavId_7659; 7659)
                {
                }
                column(HMS_Treatment_Form_Radiology__Radiology_Type_Name_;"Radiology Type Name")
                {
                }
                column(HMS_Treatment_Form_Radiology__Radiology_Remarks_;"Radiology Remarks")
                {
                }
                column(HMS_Treatment_Form_Radiology_Treatment_No_;"Treatment No.")
                {
                }
                column(HMS_Treatment_Form_Radiology_Radiology_Type_Code;"Radiology Type Code")
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                Patient.Reset;
                PatientName:='';
                Age:='';
                Gender:='';

                if Patient.Get("Patient No.") then
                  begin
                    PatientName:=Patient.Surname + ' ' + Patient."Middle Name" +' ' +Patient."Last Name";
                    Gender:=Format(Patient.Gender);
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
                    if Patient."Date Of Birth"=0D then
                      begin
                        Age:='Age:';
                      end
                    else
                      begin
                        Age:=HRDates.DetermineAge(Patient."Date Of Birth",Today);
                      end;
                  end;

                DoctorName:='';
                Doctor.Reset;
                if Doctor.Get("HMS-Treatment Form Header"."Doctor ID") then
                  begin
                    Doctor.CalcFields(Doctor."Doctor's Name");
                    DoctorName:=Doctor."Doctor's Name";
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

    trigger OnPreReport()
    begin
        Company.Reset;
        Company.Get();
    end;

    var
        Company: Record "Company Information";
        Patient: Record UnknownRecord61402;
        Age: Text[100];
        Gender: Text[100];
        HRDates: Codeunit "HR Dates";
        PatientName: Text[100];
        PFNo: Code[20];
        Department: Text[100];
        Doctor: Record UnknownRecord61387;
        DoctorName: Text[100];
        University_HEALTH_SERVICESCaptionLbl: label 'University HEALTH SERVICES';
        Date_CaptionLbl: label 'Date:';
        X_RAY_REQUEST_FORMCaptionLbl: label 'X-RAY REQUEST FORM';
        Our_Ref_CaptionLbl: label 'Our Ref:';
        To___________________________________________________________________________________________________________________________Lbl: label 'To:...............................................................................................................................';
        EmptyStringCaptionLbl: label '...............................................................................................................................';
        EmptyStringCaption_Control1102760014Lbl: label '...............................................................................................................................';
        EmptyStringCaption_Control1102760015Lbl: label '...............................................................................................................................';
        EmptyStringCaption_Control1102760016Lbl: label '__________________________________________________________________________________________________________________';
        EmptyStringCaption_Control1102760017Lbl: label '__________________________________________________________________________________________________________________';
        EmptyStringCaption_Control1102760018Lbl: label '__________________________________________________________________________________________________________________';
        EmptyStringCaption_Control1102760022Lbl: label '__________________________________________________________________________________________________________________';
        EmptyStringCaption_Control1102760023Lbl: label '__________________________________________________________________________________________________________________';
        Clinical_Notes_CaptionLbl: label 'Clinical Notes:';
        InvestigationsCaptionLbl: label 'Investigations';
        Sign_CaptionLbl: label 'Sign:';
        EmptyStringCaption_Control1102760029Lbl: label '__________________________________________________________________________________________________________________';
        EmptyStringCaption_Control1102760030Lbl: label '__________________________________________________________________________________________________________________';
        Radiologist_Report_CaptionLbl: label 'Radiologist Report:';
        EmptyStringCaption_Control1102760035Lbl: label '............................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................';
        EmptyStringCaption_Control1102760036Lbl: label '............................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................';
        EmptyStringCaption_Control1102760037Lbl: label '............................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................';
        EmptyStringCaption_Control1102760038Lbl: label '............................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................';
        EmptyStringCaption_Control1102760039Lbl: label '............................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................';
        Sign_Caption_Control1102760040Lbl: label 'Sign:';
        Date_Caption_Control1102760041Lbl: label 'Date:';
        EmptyStringCaption_Control1102760042Lbl: label '............................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................';
        EmptyStringCaption_Control1102760043Lbl: label '............................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................';
}

