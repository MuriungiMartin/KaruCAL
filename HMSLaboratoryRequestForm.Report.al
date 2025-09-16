#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51380 "HMS Laboratory Request Form"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HMS Laboratory Request Form.rdlc';

    dataset
    {
        dataitem(UnknownTable61407;UnknownTable61407)
        {
            DataItemTableView = sorting("Treatment No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Treatment No.";
            column(ReportForNavId_3701; 3701)
            {
            }
            column(FORMAT__Treatment_Date__0_4_;Format("Treatment Date",0,4))
            {
            }
            column(HMS_Treatment_Form_Header__Patient_No__;"Patient No.")
            {
            }
            column(UPPERCASE_COMPANYNAME_;UpperCase(COMPANYNAME))
            {
            }
            column(Patient_Surname_________Patient__Middle_Name__________Patient__Last_Name_;Patient.Surname + ' ' + Patient."Middle Name" + ' ' + Patient."Last Name")
            {
            }
            column(AgeText;AgeText)
            {
            }
            column(Gender;Gender)
            {
            }
            column(HMS_Treatment_Form_Header__Treatment_Remarks_;"Treatment Remarks")
            {
            }
            column(LabNo;LabNo)
            {
            }
            column(DoctorName;DoctorName)
            {
            }
            column(University_HEALTH_SERVICESCaption;University_HEALTH_SERVICESCaptionLbl)
            {
            }
            column(LABORATORY_REQUEST_FORMCaption;LABORATORY_REQUEST_FORMCaptionLbl)
            {
            }
            column(Name_Caption;Name_CaptionLbl)
            {
            }
            column(Department_Caption;Department_CaptionLbl)
            {
            }
            column(Age_Caption;Age_CaptionLbl)
            {
            }
            column(Gender_Caption;Gender_CaptionLbl)
            {
            }
            column(Date_Caption;Date_CaptionLbl)
            {
            }
            column(PF_No__Caption;PF_No__CaptionLbl)
            {
            }
            column(Clinical_NotesCaption;Clinical_NotesCaptionLbl)
            {
            }
            column(DescriptionCaption;DescriptionCaptionLbl)
            {
            }
            column(CodeCaption;CodeCaptionLbl)
            {
            }
            column(Date_DueCaption;Date_DueCaptionLbl)
            {
            }
            column(RemarksCaption;RemarksCaptionLbl)
            {
            }
            column(Request_No__Caption;Request_No__CaptionLbl)
            {
            }
            column(Doctor_s_NameCaption;Doctor_s_NameCaptionLbl)
            {
            }
            column(HMS_Treatment_Form_Header_Treatment_No_;"Treatment No.")
            {
            }
            dataitem(UnknownTable61410;UnknownTable61410)
            {
                DataItemLink = "Treatment No."=field("Treatment No.");
                column(ReportForNavId_2412; 2412)
                {
                }
                column(HMS_Treatment_Form_Laboratory__Laboratory_Test_Package_Code_;"Laboratory Test Package Code")
                {
                }
                column(HMS_Treatment_Form_Laboratory__Laboratory_Test_Package_Name_;"Laboratory Test Package Name")
                {
                }
                column(HMS_Treatment_Form_Laboratory__Date_Due_;"Date Due")
                {
                }
                column(HMS_Treatment_Form_Laboratory_Results;Results)
                {
                }
                column(HMS_Treatment_Form_Laboratory_Treatment_No_;"Treatment No.")
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                Patient.Reset;
                PatientName:='';
                if Patient.Get("Patient No.") then
                  begin
                    PatientName:=Patient.Surname +' ' + Patient."Middle Name" + ' ' + Patient."Last Name";
                    AgeText:=HRDates.DetermineAge(Patient."Date Of Birth",Today);
                    Gender:=Format(Patient.Gender);
                  end;
                Doctor.Reset;
                if Doctor.Get("Doctor ID") then
                  begin
                    Doctor.CalcFields(Doctor."Doctor's Name");
                    DoctorName:=Doctor."Doctor's Name";
                  end;
                /*Get the laboratory request number from the laboratory table*/
                Lab.Reset;
                Lab.SetRange(Lab."Link Type",'TREATMENT');
                Lab.SetRange(Lab."Link No.","Treatment No.");
                if Lab.Find('-') then begin LabNo:=Lab."Laboratory No." end;

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
        Patient: Record UnknownRecord61402;
        AgeText: Text[100];
        HRDates: Codeunit "HR Dates";
        PatientName: Text[100];
        Gender: Text[30];
        Doctor: Record UnknownRecord61387;
        DoctorName: Text[100];
        Lab: Record UnknownRecord61416;
        LabNo: Code[20];
        University_HEALTH_SERVICESCaptionLbl: label 'University HEALTH SERVICES';
        LABORATORY_REQUEST_FORMCaptionLbl: label 'LABORATORY REQUEST FORM';
        Name_CaptionLbl: label 'Name:';
        Department_CaptionLbl: label 'Department:';
        Age_CaptionLbl: label 'Age:';
        Gender_CaptionLbl: label 'Gender:';
        Date_CaptionLbl: label 'Date:';
        PF_No__CaptionLbl: label 'PF/No.:';
        Clinical_NotesCaptionLbl: label 'Clinical Notes';
        DescriptionCaptionLbl: label 'Description';
        CodeCaptionLbl: label 'Code';
        Date_DueCaptionLbl: label 'Date Due';
        RemarksCaptionLbl: label 'Remarks';
        Request_No__CaptionLbl: label 'Request No.:';
        Doctor_s_NameCaptionLbl: label 'Doctor''s Name';
}

