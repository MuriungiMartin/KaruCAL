#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51367 "Process Jab Students"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Process Jab Students.rdlc';

    dataset
    {
        dataitem(UnknownTable61372;UnknownTable61372)
        {
            DataItemTableView = sorting("Admission No.");
            RequestFilterFields = "Admission No.";
            column(ReportForNavId_3773; 3773)
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
            column(Admission_Form_Header__Admission_No__;"Admission No.")
            {
            }
            column(Admission_Form_Header__Academic_Year_;"Academic Year")
            {
            }
            column(Admission_Form_Header_Surname;Surname)
            {
            }
            column(Admission_Form_Header__Other_Names_;"Other Names")
            {
            }
            column(Admission_Form_HeaderCaption;Admission_Form_HeaderCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Admission_Form_Header__Admission_No__Caption;FieldCaption("Admission No."))
            {
            }
            column(Admission_Form_Header__Academic_Year_Caption;FieldCaption("Academic Year"))
            {
            }
            column(Admission_Form_Header_SurnameCaption;FieldCaption(Surname))
            {
            }
            column(Admission_Form_Header__Other_Names_Caption;FieldCaption("Other Names"))
            {
            }

            trigger OnAfterGetRecord()
            begin
                taketoreg();
                Status:=Status::"Doc. Verification";
                Modify;
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
        FacultyName: Text[30];
        DegreeName: Text[200];
        AgeText: Text[100];
        NationalityName: Text[30];
        ReligionName: Text[30];
        FormerSchoolName: Text[30];
        HasValue: Boolean;
        Cust: Record Customer;
        CourseRegistration: Record UnknownRecord61532;
        StudentKin: Record UnknownRecord61528;
        AdminKin: Record UnknownRecord61373;
        StudentGuardian: Record UnknownRecord61530;
        admissioinheader: Record UnknownRecord61372;
        Admission_Form_HeaderCaptionLbl: label 'Admission Form Header';
        CurrReport_PAGENOCaptionLbl: label 'Page';


    procedure taketoreg()
    begin
           begin
                Cust.Init;
                Cust."No.":="ACA-Adm. Form Header"."Admission No.";
                Cust.Name:=CopyStr("ACA-Adm. Form Header".Surname + ' ' + "ACA-Adm. Form Header"."Other Names",1,30);
                Cust."Search Name":=UpperCase(CopyStr("ACA-Adm. Form Header".Surname + ' ' + "ACA-Adm. Form Header"."Other Names",1,30))
        ;
                Cust.Address:="ACA-Adm. Form Header"."Correspondence Address 1";
                Cust."Address 2":=CopyStr("ACA-Adm. Form Header"."Correspondence Address 2",1,30);
                Cust."Phone No.":="ACA-Adm. Form Header"."Telephone No. 1" + ',' + "ACA-Adm. Form Header"."Telephone No. 2";
                Cust."Telex No.":="ACA-Adm. Form Header"."Fax No.";
                Cust."E-Mail":="ACA-Adm. Form Header"."E-Mail";
                Cust.Gender:="ACA-Adm. Form Header".Gender;
                Cust."Date Of Birth":="ACA-Adm. Form Header"."Date Of Birth";
                Cust."Date Registered":=Today;
                Cust."Customer Type":=Cust."customer type"::Student;
                Cust."Application No." :="ACA-Adm. Form Header"."Admission No.";
                Cust."Marital Status":="ACA-Adm. Form Header"."Marital Status";
                Cust.Citizenship:=Format("ACA-Adm. Form Header".Nationality);
                Cust.Religion:=Format("ACA-Adm. Form Header".Religion);
        
                Cust."Customer Posting Group":='STUDENT';
                Cust.Validate(Cust."Customer Posting Group");
                Cust.Insert();
        
        
                //insert the course registration details
                    CourseRegistration.Reset;
                    CourseRegistration.Init;
                       CourseRegistration."Reg. Transacton ID":='';
                       CourseRegistration.Validate(CourseRegistration."Reg. Transacton ID");
                       CourseRegistration."Student No.":="ACA-Adm. Form Header"."Admission No.";
                       CourseRegistration.Programme:="ACA-Adm. Form Header"."Degree Admitted To";
                       CourseRegistration.Semester:="ACA-Adm. Form Header"."Semester Admitted To";
                       CourseRegistration.Stage:="ACA-Adm. Form Header"."Stage Admitted To";
                       CourseRegistration."Student Type":=CourseRegistration."student type"::"Full Time";
                       CourseRegistration."Registration Date":=Today;
                       //CourseRegistration."Settlement Type":="Admission Form Header"."Settlement Type";
                       //CourseRegistration.VALIDATE(CourseRegistration."Settlement Type");
                    CourseRegistration.Insert;
        
                    CourseRegistration.Reset;
                    CourseRegistration.SetRange(CourseRegistration."Student No.","ACA-Adm. Form Header"."Admission No.");
                    if CourseRegistration.Find('+') then begin
                    CourseRegistration."Registration Date":=Today;
                    CourseRegistration.Validate(CourseRegistration."Registration Date");
                    //CourseRegistration."Settlement Type":="Admission Form Header"."Settlement Type";
                    //CourseRegistration.VALIDATE(CourseRegistration."Settlement Type");
                    CourseRegistration.Modify;
        
        
                  end;
        
               /*
                //insert the details related to the next of kin of the student into the database
                    AdminKin.RESET;
                    AdminKin.SETRANGE(AdminKin."Admission No.","Admission No.");
                    IF AdminKin.FIND('-') THEN
                        BEGIN
                            REPEAT
                                StudentKin.RESET;
                                StudentKin.INIT;
                                    StudentKin."Student No":="Admission No.";
                                    StudentKin.Relationship:=AdminKin.Relationship;
                                    StudentKin.SurName:=AdminKin."Full Name";
                                    //StudentKin."Other Names":=EnrollmentNextofKin."Other Names";
                                    //StudentKin."ID No/Passport No":=EnrollmentNextofKin."ID No/Passport No";
                                    //StudentKin."Date Of Birth":=EnrollmentNextofKin."Date Of Birth";
                                    //StudentKin.Occupation:=EnrollmentNextofKin.Occupation;
                                    StudentKin."Office Tel No":=AdminKin."Telephone No. 1";
                                    StudentKin."Home Tel No":=AdminKin."Telephone No. 2";
                                    //StudentKin.Remarks:=EnrollmentNextofKin.Remarks;
                                StudentKin.INSERT;
                            UNTIL AdminKin.NEXT=0;
                        END;
        
                //insert the details in relation to the guardian/sponsor into the database in relation to the current student
                IF "Mother Alive Or Dead"="Mother Alive Or Dead"::Alive THEN
                        BEGIN
                         IF "Mother Full Name"<>'' THEN BEGIN
                          StudentGuardian.RESET;
                          StudentGuardian.INIT;
                          StudentGuardian."Student No.":="Admission No.";
                          StudentGuardian.Names:="Mother Full Name";
                          StudentGuardian.INSERT;
                          END;
                        END;
                IF "Father Alive Or Dead"="Father Alive Or Dead"::Alive THEN
                        BEGIN
                        IF "Father Full Name"<>'' THEN BEGIN
                          StudentGuardian.RESET;
                          StudentGuardian.INIT;
                          StudentGuardian."Student No.":="Admission No.";
                          StudentGuardian.Names:="Father Full Name";
                          StudentGuardian.INSERT;
                          END;
                        END;
                IF "Guardian Full Name"<>'' THEN
                        BEGIN
                        IF "Guardian Full Name"<>'' THEN BEGIN
                          StudentGuardian.RESET;
                          StudentGuardian.INIT;
                          StudentGuardian."Student No.":="Admission No.";
                          StudentGuardian.Names:="Guardian Full Name";
                          StudentGuardian.INSERT;
                          END;
                        END;
        
        {
        
                //insert the details in relation to the student history as detailed in the application
                    EnrollmentEducationHistory.RESET;
                    EnrollmentEducationHistory.SETRANGE(EnrollmentEducationHistory."Enquiry No.",Enrollment."Enquiry No.");
                    IF EnrollmentEducationHistory.FIND('-') THEN
                        BEGIN
                            REPEAT
                                EducationHistory.RESET;
                                EducationHistory.INIT;
                                    EducationHistory."Student No.":=Rec."No.";
                                    EducationHistory.From:=EnrollmentEducationHistory.From;
                                    EducationHistory."To":=EnrollmentEducationHistory."To";
                                    EducationHistory.Qualifications:=EnrollmentEducationHistory.Qualifications;
                                    EducationHistory.Instituition:=EnrollmentEducationHistory.Instituition;
                                    EducationHistory.Remarks:=EnrollmentEducationHistory.Remarks;
                                    EducationHistory."Aggregate Result/Award":=EnrollmentEducationHistory."Aggregate Result/Award";
                                EducationHistory.INSERT;
                            UNTIL EnrollmentEducationHistory.NEXT=0;
                        END;
                //update the status of the application
                    Enrollment."Registration No":=Rec."No.";
                    Enrollment.Status:=Enrollment.Status::Admitted;
                    Enrollment.MODIFY;
        
         }*/
        end;

    end;
}

