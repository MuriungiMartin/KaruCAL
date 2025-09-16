#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51339 "Official Admission Letter -SSP"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Official Admission Letter -SSP.rdlc';

    dataset
    {
        dataitem("Application Form Header";UnknownTable61358)
        {
            column(ReportForNavId_1102755000; 1102755000)
            {
            }
            column(ApplicationNo_ApplicationFormHeader;"Application Form Header"."Application No.")
            {
            }
            column(Date_ApplicationFormHeader;"Application Form Header".Date)
            {
            }
            column(ApplicationDate_ApplicationFormHeader;"Application Form Header".Date)
            {
            }
            column(Surname_ApplicationFormHeader;"Application Form Header".Surname)
            {
            }
            column(OtherNames_ApplicationFormHeader;"Application Form Header"."Other Names")
            {
            }
            column(DateOfBirth_ApplicationFormHeader;"Application Form Header"."Date Of Birth")
            {
            }
            column(Gender_ApplicationFormHeader;"Application Form Header".Gender)
            {
            }
            column(MaritalStatus_ApplicationFormHeader;"Application Form Header"."Marital Status")
            {
            }
            column(Nationality_ApplicationFormHeader;"Application Form Header".Nationality)
            {
            }
            column(CountryofOrigin_ApplicationFormHeader;"Application Form Header"."Country of Origin")
            {
            }
            column(address;"Application Form Header"."Address for Correspondence1")
            {
            }
            column(adresscode;"Application Form Header"."Address for Correspondence2")
            {
            }
            column(addresstown;"Application Form Header"."Address for Correspondence3")
            {
            }
            column(TelephoneNo1_ApplicationFormHeader;"Application Form Header"."Telephone No. 1")
            {
            }
            column(TelephoneNo2_ApplicationFormHeader;"Application Form Header"."Telephone No. 2")
            {
            }
            column(Degree;"Application Form Header"."First Degree Choice")
            {
            }
            column(School;"Application Form Header".School1)
            {
            }
            column(SecondDegreeChoice_ApplicationFormHeader;"Application Form Header"."Second Degree Choice")
            {
            }
            column(Faculty2_ApplicationFormHeader;"Application Form Header"."School 2")
            {
            }
            column(DateofReceipt_ApplicationFormHeader;"Application Form Header"."Date of Receipt")
            {
            }
            column(UserID_ApplicationFormHeader;"Application Form Header"."User ID")
            {
            }
            column(County_ApplicationFormHeader;"Application Form Header".County)
            {
            }
            column(FormerSchoolCode_ApplicationFormHeader;"Application Form Header"."Former School Code")
            {
            }
            column(DateofAdmission_ApplicationFormHeader;"Application Form Header"."Date of Admission")
            {
            }
            column(DateofCompletion_ApplicationFormHeader;"Application Form Header"."Date of Completion")
            {
            }
            column(YearofExamination_ApplicationFormHeader;"Application Form Header"."Year of Examination")
            {
            }
            column(ExaminationBody_ApplicationFormHeader;"Application Form Header"."Examination Body")
            {
            }
            column(MeanGradeAcquired_ApplicationFormHeader;"Application Form Header"."Mean Grade Acquired")
            {
            }
            column(PointsAcquired_ApplicationFormHeader;"Application Form Header"."Points Acquired")
            {
            }
            column(PrincipalPasses_ApplicationFormHeader;"Application Form Header"."Principal Passes")
            {
            }
            column(SubsidiaryPasses_ApplicationFormHeader;"Application Form Header"."Subsidiary Passes")
            {
            }
            column(Examination_ApplicationFormHeader;"Application Form Header".Examination)
            {
            }
            column(ApplicationFormReceiptNo_ApplicationFormHeader;"Application Form Header"."Application Form Receipt No.")
            {
            }
            column(IndexNumber_ApplicationFormHeader;"Application Form Header"."Index Number")
            {
            }
            column(NoSeries_ApplicationFormHeader;"Application Form Header"."No. Series")
            {
            }
            column(HODUserID_ApplicationFormHeader;"Application Form Header"."HOD User ID")
            {
            }
            column(HODDate_ApplicationFormHeader;"Application Form Header"."HOD Date")
            {
            }
            column(HODTime_ApplicationFormHeader;"Application Form Header"."HOD Time")
            {
            }
            column(HODRecommendations_ApplicationFormHeader;"Application Form Header"."HOD Recommendations")
            {
            }
            column(DeanUserID_ApplicationFormHeader;"Application Form Header"."Dean User ID")
            {
            }
            column(DeanDate_ApplicationFormHeader;"Application Form Header"."Dean Date")
            {
            }
            column(DeanTime_ApplicationFormHeader;"Application Form Header"."Dean Time")
            {
            }
            column(DeanRecommendations_ApplicationFormHeader;"Application Form Header"."Dean Recommendations")
            {
            }
            column(Status_ApplicationFormHeader;"Application Form Header".Status)
            {
            }
            column(Select_ApplicationFormHeader;"Application Form Header".Select)
            {
            }
            column(BatchNo_ApplicationFormHeader;"Application Form Header"."Batch No.")
            {
            }
            column(BatchDate_ApplicationFormHeader;"Application Form Header"."Batch Date")
            {
            }
            column(BatchTime_ApplicationFormHeader;"Application Form Header"."Batch Time")
            {
            }
            column(AdmissionBoardRecommendation_ApplicationFormHeader;"Application Form Header"."Admission Board Recommendation")
            {
            }
            column(AdmissionBoardDate_ApplicationFormHeader;"Application Form Header"."Admission Board Date")
            {
            }
            column(AdmissionBoardTime_ApplicationFormHeader;"Application Form Header"."Admission Board Time")
            {
            }
            column(AdmittedDegree;"Application Form Header"."Admitted Degree")
            {
            }
            column(AdmittedDepartment_ApplicationFormHeader;"Application Form Header"."Admitted Department")
            {
            }
            column(DeferredUntil_ApplicationFormHeader;"Application Form Header"."Deferred Until")
            {
            }
            column(DateOfMeeting_ApplicationFormHeader;"Application Form Header"."Date Of Meeting")
            {
            }
            column(DateOfReceiptSlip_ApplicationFormHeader;"Application Form Header"."Date Of Receipt Slip")
            {
            }
            column(ReceiptSlipNo_ApplicationFormHeader;"Application Form Header"."Receipt Slip No.")
            {
            }
            column(AcademicYear_ApplicationFormHeader;"Application Form Header"."Academic Year")
            {
            }
            column(AdmissionNo_ApplicationFormHeader;"Application Form Header"."Admission No")
            {
            }
            column(AdmittedToStage_ApplicationFormHeader;"Application Form Header"."Admitted To Stage")
            {
            }
            column(AdmittedSemester_ApplicationFormHeader;"Application Form Header"."Admitted Semester")
            {
            }
            column(Stage;"Application Form Header"."First Choice Stage")
            {
            }
            column(FirstChoiceSemester_ApplicationFormHeader;"Application Form Header"."First Choice Semester")
            {
            }
            column(SecondChoiceStage_ApplicationFormHeader;"Application Form Header"."Second Choice Stage")
            {
            }
            column(SecondChoiceSemester_ApplicationFormHeader;"Application Form Header"."Second Choice Semester")
            {
            }
            column(IntakeCode_ApplicationFormHeader;"Application Form Header"."Intake Code")
            {
            }
            column(SettlementType_ApplicationFormHeader;"Application Form Header"."Settlement Type")
            {
            }
            column(IDNumber_ApplicationFormHeader;"Application Form Header"."ID Number")
            {
            }
            column(DateSentforApproval_ApplicationFormHeader;"Application Form Header"."Date Sent for Approval")
            {
            }
            column(IssuedDate_ApplicationFormHeader;"Application Form Header"."Issued Date")
            {
            }
            column(PostGraduate_ApplicationFormHeader;"Application Form Header"."Post Graduate")
            {
            }
            column(Email_ApplicationFormHeader;"Application Form Header".Email)
            {
            }
            column(Campus_ApplicationFormHeader;"Application Form Header".Campus)
            {
            }
            column(AdmissableStatus_ApplicationFormHeader;"Application Form Header"."Admissable Status")
            {
            }
            column(ModeofStudy_ApplicationFormHeader;"Application Form Header"."Mode of Study")
            {
            }
            column(EnquiryNo_ApplicationFormHeader;"Application Form Header"."Enquiry No")
            {
            }
            column(TelephoneNumber_ApplicationFormHeader;"Application Form Header"."Telephone No. 1")
            {
            }
            column(ResponsibilityCenter_ApplicationFormHeader;"Application Form Header"."Responsibility Center")
            {
            }
            column(salutation;"Application Form Header".Salutation)
            {
            }
            column(CompName;CompName)
            {
            }
            column(RepDate;ReportDate)
            {
            }
            column(FNames;FullNames)
            {
            }
            column(ProgName;ProgName)
            {
            }
            column(DateStr;DateStr)
            {
            }
            column(Faculty;FacultyName)
            {
            }
            column(StageName;StageName)
            {
            }
            dataitem("New Student Charges";UnknownTable61543)
            {
                DataItemLink = "Programme Code"=field("Admitted Degree");
                column(ReportForNavId_1000000000; 1000000000)
                {
                }
                column(Code_NewStudentCharges;"New Student Charges".Code)
                {
                }
                column(Description_NewStudentCharges;"New Student Charges".Description)
                {
                }
                column(Amount_NewStudentCharges;"New Student Charges".Amount)
                {
                }
            }

            trigger OnAfterGetRecord()
            var
                TTTT: Text[30];
            begin
                   CompName:=COMPANYNAME;
                   FullNames:="Application Form Header".Surname+' '+"Application Form Header"."Other Names";
                   ProgName:='';
                   if Prog.Get("Application Form Header"."First Degree Choice") then begin
                   ProgName:=Prog.Description;
                    FacultyName:='';
                    FacRec.Reset;
                    FacRec.SetRange(FacRec.Code,Prog."School Code");
                    if FacRec.Find('-') then
                    FacultyName:=FacRec.Name;
                   end;

                   if IntakeRec.Get("Application Form Header"."Intake Code") then begin
                    IntakeRec.TestField(IntakeRec."Reporting Date");
                    ReportDate:= Format(IntakeRec."Reporting Date",0,'<Day> <Month Text>') +' '+Format(Date2dmy(IntakeRec."Reporting Date",3));
                   end;
                   DateStr:= Format(Today,0,'<Day> <Month Text>') +' '+Format(Date2dmy(Today,3));


                    StageRec.Reset;
                    StageRec.SetRange(StageRec."Programme Code","Application Form Header"."Admitted Degree");
                    StageRec.SetRange(StageRec.Code,"Application Form Header"."Admitted To Stage");
                    if StageRec.Find('-') then
                    StageName:=CopyStr(StageRec.Description,1,7);
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
        StageName: Text[100];
        CompName: Code[100];
        ReportDate: Text;
        FullNames: Text[100];
        ProgName: Code[100];
        Prog: Record UnknownRecord61511;
        IntakeRec: Record UnknownRecord61383;
        ComenceDate: Date;
        DateStr: Text[50];
        FacultyName: Text[100];
        FacRec: Record "Dimension Value";
        StudHostel: Record "ACA-Students Hostel Rooms";
        RoomNo: Code[20];
        HostelRec: Record "ACA-Hostel Card";
        HostelName: Text[50];
        StageRec: Record UnknownRecord61516;
}

