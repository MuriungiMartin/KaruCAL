#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 66627 "Reasons for Incomplete"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Reasons for Incomplete.rdlc';

    dataset
    {
        dataitem(StudentsClassification;UnknownTable66630)
        {
            CalcFields = "Status Students Count";
            DataItemTableView = where("Final Classification Pass"=filter(No),"Final Classification"=filter(<>""));
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Graduation Academic Year","School Code",Programme;
            column(ReportForNavId_2; 2)
            {
            }
            column(Filtersz;StudentsClassification.GetFilters)
            {
            }
            column(ClassCode;StudentsClassification."Final Classification")
            {
            }
            column(GradAcademicYear;StudentsClassification."Graduation Academic Year")
            {
            }
            column(ProgCode;StudentsClassification.Programme)
            {
            }
            column(PassStatus;StudentsClassification."Final Classification Pass")
            {
            }
            column(PassStatusOrder;StudentsClassification."Final Classification Order")
            {
            }
            column(ClassOrders;StudentsClassification."Final Classification Order")
            {
            }
            column(ClassOrder;StudentsClassification."Final Classification Order")
            {
            }
            column(YearOfStudy;StudentsClassification."Year of Study")
            {
            }
            column(PassOrder;StudentsClassification."Final Classification Order")
            {
            }
            column(Pics;CompInf.Picture)
            {
            }
            column(Compname;UpperCase(CompInf.Name))
            {
            }
            column(StatusOrderCompiled;StatusOrder)
            {
            }
            column(statusCompiled;statusCompiled)
            {
            }
            column(StatusCode;StudentsClassification."Final Classification")
            {
            }
            column(StatusDesc;ACAResultsStatus.Description)
            {
            }
            column(SummaryPageCaption;ACAResultsStatus."Summary Page Caption")
            {
            }
            column(StatusOrder;StudentsClassification."Final Classification Order")
            {
            }
            column(StatCodes;ACAResultsStatus.Code)
            {
            }
            column(ApprovalsClaimer;'Approved by the board of the Examiners of the  '+FacDesc+' at a meeting held on:')
            {
            }
            column(ProgName;progName)
            {
            }
            column(facCode;facCode)
            {
            }
            column(FacDesc;FacDesc)
            {
            }
            column(YoS;StudentsClassification."Year of Study")
            {
            }
            column(AcadYear;StudentsClassification."Graduation Academic Year")
            {
            }
            column(YearOfStudyText;YearOfStudyText)
            {
            }
            column(NextYear;NextYear)
            {
            }
            column(SaltedExamStatusDesc;'In the year '+StudentsClassification."Graduation Academic Year"+' '+SaltedExamStatusDesc)
            {
            }
            column(SaltedExamStatus;SaltedExamStatus)
            {
            }
            column(YoSTexed;YoS)
            {
            }
            column(ExamStatus;StudentsClassification."Final Classification")
            {
            }
            column(Names;Cust.Name)
            {
            }
            column(StudNo;StudentsClassification."Student Number")
            {
            }
            column(Required;StudentsClassification."Required Stage Units")
            {
            }
            column(Attained;StudentsClassification."Attained Stage Units")
            {
            }
            dataitem(NotGradReason;UnknownTable66633)
            {
                DataItemLink = "Student No."=field("Student Number"),"Graduation Academic Year"=field("Graduation Academic Year");
                column(ReportForNavId_28; 28)
                {
                }
                column(ResonCode;NotGradReason."Reason Code")
                {
                }
                column(ReasonDetails;NotGradReason."Reason Details")
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                Clear(NextYear);
                Clear(YearOfStudyText);
                Clear(YoS);
                YoS:=GetYearofStudyText(StudentsClassification."Year of Study");
                YearOfStudyText:=YoS;
                  Clear(IsaForthYear);
                  IsaForthYear:=true;
                  Clear(statusCompiled);
                 // IsaForthYear:=ACACourseRegistration741."Is Final Year Student";
                 // IF ((ACACourseRegistration741.Stage='Y4S1') OR (ACACourseRegistration741.Stage='Y4S2')) THEN
                 //   IsaForthYear:=TRUE;
                // // CLEAR(StatusOrder);
                // // IF StudentsClassification."Final Classification Pass" = FALSE THEN BEGIN
                // // statusCompiled:='INCOMPLETE RESULTS LIST';
                // //  StatusOrder:=2;
                // //  END
                // // ELSE IF ClassHeader."Pass Status"<>'' THEN BEGIN
                // // statusCompiled:='CLASSIFICATION LIST';
                // //  StatusOrder:=1;
                // //  END;

                Clear(progName);
                Prog.Reset;
                Prog.SetRange(Code,StudentsClassification.Programme);
                if Prog.Find('-') then begin
                  progName:=Prog.Description;
                  end;

                //Get the Department
                Clear(FacDesc);
                Clear(facCode);
                FacDesc:=StudentsClassification."School Name";
                  facCode:=StudentsClassification."School Code";


                Clear(SaltedExamStatus);
                Clear(SaltedExamStatusDesc);
                SaltedExamStatus:=ACAResultsStatus.Code+facCode+Prog.Code+
                Format(StudentsClassification."Year of Study")+
                StudentsClassification."Graduation Academic Year";
                Clear(NoOfStudents);
                Clear(NoOfStudentsDecimal);

                ACAResultsStatus.Reset;

                ACAResultsStatus.SetRange(Code,'PASS');
                //SaltedExamStatusDesc:=ClassHeader.Msg1;
                Clear(NoOfStudentInText);
                StudentsClassification.CalcFields("Status Students Count");
                NoOfStudents:=StudentsClassification."Status Students Count";
                if NoOfStudents<>0 then NoOfStudentInText:=ConvertDecimalToText.InitiateConvertion(NoOfStudents);
                if ACAResultsStatus.Find('-') then begin
                if ACAResultsStatus."Include Class Variable 1" then SaltedExamStatusDesc:=SaltedExamStatusDesc+' '+NoOfStudentInText+' ('+Format(NoOfStudents)+') '+ACAResultsStatus."Classification Msg2";
                if  ACAResultsStatus."Include Class Variable 2" then SaltedExamStatusDesc:=SaltedExamStatusDesc +' '+FacDesc+' '+ACAResultsStatus."Classification Msg3";+' '+progName+' '+Prog."Exam Category";
                if ACAResultsStatus."Include Class Variable 3" then SaltedExamStatusDesc:=SaltedExamStatusDesc+' '+ACAResultsStatus."Classification Msg4";
                //IF ACAResultsStatus."Include Class Variable 4" THEN SaltedExamStatusDesc:=SaltedExamStatusDesc+' '+progName+' '+ClassHeader.Msg5;
                // IF ACAResultsStatus."Include Class Variable 5" THEN SaltedExamStatusDesc:=SaltedExamStatusDesc;//+' '+NextYear;
                // IF ACAResultsStatus."Include Class Variable 6" THEN SaltedExamStatusDesc:=SaltedExamStatusDesc+' '+ClassHeader.Msg6;
                SaltedExamStatusDesc:= SaltedExamStatusDesc+' '+ACAResultsStatus."Final Year Comment";
                end;

                 Cust.Reset;
                 Cust.SetRange("No.",StudentsClassification."Student Number");
                 if Cust.Find('-') then;
            end;

            trigger OnPreDataItem()
            begin
                //ClassHeader.SETFILTER("User ID",USERID);
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

    trigger OnInitReport()
    begin
        CompInf.Get();
        //CompInf.CALCFIELDS(CompInf.Picture);
    end;

    trigger OnPreReport()
    var
        ACAGraduationReportPicker: Record UnknownRecord66610;
        GradAcdYear: Code[1024];
        YearOfStudy: Option " ","1","2","3","4","5","6","7";
        ProgFilters: Code[1024];
        ACACourseRegistration: Record UnknownRecord66630;
        ITmCourseReg: Record UnknownRecord66630;
        ACAProgramme: Record UnknownRecord61511;
        ACAProgrammeStages: Record UnknownRecord61516;
        YoSComputed: Integer;
        ACAClassificationHeader: Record UnknownRecord66612;
        ACAClassificationDetails: Record UnknownRecord66613;
        ACAClassificationDetails2: Record UnknownRecord66613;
        ACAClassGradRubrics: Record UnknownRecord78011;
        SpecialReason: Text[150];
        failExists: Boolean;
        StatusOrder: Integer;
        statusCompiled: Code[50];
        NotSpecialNotSuppSpecial: Boolean;
        isSpecialOnly: Boolean;
        IsSpecialAndSupp: Boolean;
        IsaForthYear: Boolean;
        IsSpecialUnit: Boolean;
        SpecialUnitReg1: Boolean;
        SpecialUnitReg: Boolean;
        ACASenateReportCounts: Record UnknownRecord77720;
        NoOfStudentInText: Text[250];
        ConvertDecimalToText: Codeunit "Convert Decimal To Text";
        PercentageFailedCaption: Text[100];
        NumberOfCoursesFailedCaption: Text[100];
        PercentageFailedValue: Decimal;
        NoOfCausesFailedValue: Integer;
        NoOfStudentsDecimal: Text;
        ACAStudentUnits: Record UnknownRecord66632;
        CountedRecs: Integer;
        UnitCodes: array [30] of Text[50];
        UnitDescs: array [30] of Text[150];
        UnitCodeLabel: Text;
        UnitDescriptionLabel: Text;
        NoOfStudents: Integer;
        StudUnits: Record UnknownRecord66632;
        ExamsDone: Integer;
        FailCount: Integer;
        Cust: Record Customer;
        Semesters: Record UnknownRecord61692;
        Dimensions: Record "Dimension Value";
        Prog: Record UnknownRecord61511;
        FacDesc: Code[100];
        Depts: Record "Dimension Value";
        Stages: Record UnknownRecord61516;
        StudentsL: Text[250];
        N: Integer;
        Grd: Code[20];
        Marks: Decimal;
        Dimensions2: Record "Dimension Value";
        ResultsStatus: Record UnknownRecord78011;
        ResultsStatus3: Record UnknownRecord78011;
        UnitsRec: Record UnknownRecord61517;
        UnitsDesc: Text[100];
        UnitsHeader: Text[50];
        FailsDesc: Text[200];
        Nx: Integer;
        RegNo: Code[20];
        Names: Text[100];
        Ucount: Integer;
        RegNox: Code[20];
        Namesx: Text[100];
        Nxx: Text[30];
        SemYear: Code[20];
        ShowSem: Boolean;
        SemDesc: Code[100];
        CREG2: Record UnknownRecord66630;
        ExamsProcessing: Codeunit "Exams Processing1";
        CompInf: Record "Company Information";
        YearDesc: Text[30];
        MaxYear: Code[20];
        MaxSem: Code[20];
        CummScore: Decimal;
        CurrScore: Decimal;
        mDate: Date;
        IntakeRec: Record UnknownRecord61383;
        IntakeDesc: Text[100];
        SemFilter: Text[100];
        StageFilter: Text[100];
        MinYear: Code[20];
        MinSem: Code[20];
        StatusNarrations: Text[1000];
        NextYear: Code[20];
        facCode: Code[20];
        progName: Code[150];
        ACAResultsStatus: Record UnknownRecord78011;
        Msg1: Text[250];
        Msg2: Text[250];
        Msg3: Text[250];
        Msg4: Text[250];
        Msg5: Text[250];
        Msg6: Text[250];
        YearOfStudyText: Text[30];
        SaltedExamStatus: Code[1024];
        SaltedExamStatusDesc: Text;
        ACASenateReportStatusBuff: Record UnknownRecord77718 temporary;
        CurrNo: Integer;
        YoS: Code[20];
        CReg33: Record UnknownRecord66630;
        CReg: Record UnknownRecord66630;
        yosInt: Integer;
        ACAUnitsSubjects: Record UnknownRecord61517;
        incounts: Integer;
    begin
        if StudentsClassification.GetFilter("Graduation Academic Year")='' then Error('Missing Academic years Filter');
        if StudentsClassification.GetFilter("School Code")='' then Error('Missing Faculty');
        // //
        // // ACAClassificationHeader.RESET;
        // // ACAClassificationHeader.SETRANGE("User ID",USERID);
        // // IF ACAClassificationHeader.FIND('-') THEN ACAClassificationHeader.DELETEALL;
        // //
        // // ACAClassificationDetails.RESET;
        // // ACAClassificationDetails.SETRANGE("User ID",USERID);
        // // IF ACAClassificationDetails.FIND('-') THEN ACAClassificationDetails.DELETEALL;
        // //
        // // Prog.RESET;
        // // Prog.SETRANGE("School Code",ClassHeader.GETFILTER(Faculty));
        // // IF Prog.FIND('-') THEN BEGIN
        // //  REPEAT
        // //    BEGIN
        // //    CLEAR(yosInt);
        // //    CLEAR(YoSComputed);
        // //  ACAProgrammeStages.RESET;
        // //  ACAProgrammeStages.SETRANGE("Programme Code",Prog.Code);
        // //  ACAProgrammeStages.SETRANGE("Final Stage",TRUE);
        // //  IF ACAProgrammeStages.FIND('-') THEN BEGIN
        // //      IF ((COPYSTR(ACAProgrammeStages.Code,2,1)) IN ['1','2','3','4','5','6','7']) THEN BEGIN
        // //        IF EVALUATE(YoSComputed,COPYSTR(ACAProgrammeStages.Code,2,1)) THEN BEGIN
        // // // Truth
        // // ACAClassGradRubrics.RESET;
        // // IF ACAClassGradRubrics.FIND('-') THEN BEGIN
        // //    REPEAT
        // //        BEGIN
        // //          ACAClassificationHeader.INIT;
        // //          ACAClassificationHeader."User ID":=USERID;
        // //          ACAClassificationHeader."Graduation Academic Year":=ClassHeader.GETFILTER("Graduation Academic Year");
        // //          ACAClassificationHeader."Classification Code":=ACAClassGradRubrics.Code;
        // //          ACAClassificationHeader."Classification Order":=ACAClassGradRubrics."Order No";
        // //          ACAClassificationHeader."Programme Code":=Prog.Code;
        // //          ACAClassificationHeader.Faculty:=ClassHeader.GETFILTER(Faculty);
        // //          IF ACAClassGradRubrics.Code='INCOMPLETE' THEN BEGIN
        // //          ACAClassificationHeader."Pass Status":='INCOMPLETE';
        // //          ACAClassificationHeader."Pass Status Order":=2;
        // //          END ELSE BEGIN
        // //          ACAClassificationHeader."Pass Status":='PASS';
        // //          ACAClassificationHeader."Pass Status Order":=1;
        // //          END;
        // //          ACAClassificationHeader."Year of Study":=YoSComputed;
        // //          ACAClassificationHeader."Year of Study Text":=GetYearofStudyText(YoSComputed);
        // //          ACAClassificationHeader.Msg1:=ACAClassGradRubrics."Classification Msg1";
        // //          ACAClassificationHeader.Msg2:=ACAClassGradRubrics."Classification Msg2";
        // //          ACAClassificationHeader.Msg3:=ACAClassGradRubrics."Classification Msg3";
        // //          ACAClassificationHeader.Msg4:=ACAClassGradRubrics."Classification Msg4";
        // //          ACAClassificationHeader.Msg5:=ACAClassGradRubrics."Classification Msg5";
        // //          ACAClassificationHeader.Msg6:=ACAClassGradRubrics."Classification Msg6";
        // //          ACAClassificationHeader."Final Year Comment":=ACAClassGradRubrics."Final Year Comment";
        // //         IF  ACAClassificationHeader.INSERT THEN;
        // //        END;
        // //      UNTIL ACAClassGradRubrics.NEXT=0;
        // //  END;
        // // CLEAR(ITmCourseReg);
        // // ITmCourseReg.RESET;
        // // ITmCourseReg.SETRANGE(Programme,Prog.Code);
        // // ITmCourseReg.SETRANGE("Graduation Academic Year",ClassHeader.GETFILTER("Graduation Academic Year"));
        // // IF ITmCourseReg.FIND('-') THEN  BEGIN
        // // //// Update Graduation Parameters
        // // REPEAT
        // //  BEGIN
        // // //////////////////..........................................................................
        // //
        // // ACAClassificationHeader.RESET;
        // // ACAClassificationHeader.SETRANGE("User ID",USERID);
        // // ACAClassificationHeader.SETRANGE("Programme Code",Prog.Code);
        // // ACAClassificationHeader.SETRANGE("Graduation Academic Year",ClassHeader.GETFILTER("Graduation Academic Year"));
        // // ACAClassificationHeader.SETRANGE("Classification Code",ITmCourseReg."Final Classification");
        // // IF ACAClassificationHeader.FIND('-') THEN;
        // // IF Cust.GET(ITmCourseReg."Student Number") THEN;
        // //
        // // ACAClassificationDetails.RESET;
        // // ACAClassificationDetails.SETRANGE("User ID",USERID);
        // // ACAClassificationDetails.SETRANGE("Programme Code",ITmCourseReg.Programme);
        // // ACAClassificationDetails.SETRANGE("Graduation Academic Year",ITmCourseReg."Graduation Academic Year");
        // // ACAClassificationDetails.SETRANGE("Student No.",ITmCourseReg."Student Number");
        // // IF NOT ACAClassificationDetails.FIND('-') THEN BEGIN
        // //
        // //          ACAClassificationDetails.INIT;
        // //          ACAClassificationDetails."User ID":=USERID;
        // //          ACAClassificationDetails."Graduation Academic Year":=ITmCourseReg."Graduation Academic Year";
        // //          ACAClassificationDetails."Classification Code":=ITmCourseReg."Final Classification";
        // //          ACAClassificationDetails."Programme Code":=ITmCourseReg.Programme;
        // //          ACAClassificationDetails.Faculty:=ClassHeader.GETFILTER(Faculty);
        // //          ACAClassificationDetails."Student No.":=ITmCourseReg."Student Number";
        // //       //   ACAClassificationDetails.
        // //          ACAClassificationDetails."Student Name":=Cust.Name;
        // //          IF ITmCourseReg."Final Classification"='INCOMPLETE' THEN BEGIN
        // //          ACAClassificationDetails."Pass Status":='INCOMPLETE';
        // //          END ELSE BEGIN
        // //          ACAClassificationDetails."Pass Status":='PASS';
        // //          END;
        // //          ACAClassificationDetails."Year of Study":=ITmCourseReg."Year of Study";
        // //          ACAClassificationDetails."Class Order":=ACAClassificationHeader."Classification Order";
        // //          IF ACAClassificationDetails."Classification Code"<>'' THEN ACAClassificationDetails.INSERT;
        // //  END ELSE BEGIN
        // //          ACAClassificationDetails."Classification Code":=ITmCourseReg."Final Classification";
        // //          IF ITmCourseReg."Final Classification"='INCOMPLETE' THEN BEGIN
        // //          ACAClassificationDetails."Pass Status":='INCOMPLETE';
        // //          END ELSE BEGIN
        // //          ACAClassificationDetails."Pass Status":='PASS';
        // //          END;
        // //          ACAClassificationDetails."Student Name":=Cust.Name;
        // //          ACAClassificationDetails."Year of Study":=ITmCourseReg."Year of Study";
        // //          ACAClassificationDetails."Class Order":=ACAClassificationHeader."Classification Order";
        // //          ACAClassificationDetails.MODIFY;
        // //    END;
        // //    END;
        // //    UNTIL ITmCourseReg.NEXT=0;
        // // END;
        // //      END;
        // //    END;
        // //  END;
        // //  END;
        // //  UNTIL Prog.NEXT=0;
        // //  END;
    end;

    var
        ACACourseRegistration741: Record UnknownRecord66631;
        SpecialReason: Text[150];
        failExists: Boolean;
        StatusOrder: Integer;
        statusCompiled: Code[50];
        NotSpecialNotSuppSpecial: Boolean;
        isSpecialOnly: Boolean;
        IsSpecialAndSupp: Boolean;
        IsaForthYear: Boolean;
        IsSpecialUnit: Boolean;
        SpecialUnitReg1: Boolean;
        SpecialUnitReg: Boolean;
        ACASenateReportCounts: Record UnknownRecord77720;
        NoOfStudentInText: Text[250];
        ConvertDecimalToText: Codeunit "Convert Decimal To Text";
        PercentageFailedCaption: Text[100];
        NumberOfCoursesFailedCaption: Text[100];
        PercentageFailedValue: Decimal;
        NoOfCausesFailedValue: Integer;
        NoOfStudentsDecimal: Text;
        CountedRecs: Integer;
        UnitCodes: array [30] of Text[50];
        UnitDescs: array [30] of Text[150];
        UnitCodeLabel: Text;
        UnitDescriptionLabel: Text;
        NoOfStudents: Integer;
        StudUnits: Record UnknownRecord66632;
        ExamsDone: Integer;
        FailCount: Integer;
        Cust: Record Customer;
        Semesters: Record UnknownRecord61692;
        Dimensions: Record "Dimension Value";
        Prog: Record UnknownRecord61511;
        FacDesc: Code[100];
        Depts: Record "Dimension Value";
        Stages: Record UnknownRecord61516;
        StudentsL: Text[250];
        N: Integer;
        Grd: Code[20];
        Marks: Decimal;
        Dimensions2: Record "Dimension Value";
        UnitsRec: Record UnknownRecord61517;
        UnitsDesc: Text[100];
        UnitsHeader: Text[50];
        FailsDesc: Text[200];
        Nx: Integer;
        RegNo: Code[20];
        Names: Text[100];
        Ucount: Integer;
        RegNox: Code[20];
        Namesx: Text[100];
        Nxx: Text[30];
        SemYear: Code[20];
        ShowSem: Boolean;
        SemDesc: Code[100];
        ExamsProcessing: Codeunit "Exams Processing1";
        CompInf: Record "Company Information";
        YearDesc: Text[30];
        MaxYear: Code[20];
        MaxSem: Code[20];
        CummScore: Decimal;
        CurrScore: Decimal;
        mDate: Date;
        IntakeRec: Record UnknownRecord61383;
        IntakeDesc: Text[100];
        SemFilter: Text[100];
        StageFilter: Text[100];
        MinYear: Code[20];
        MinSem: Code[20];
        StatusNarrations: Text[1000];
        NextYear: Code[20];
        facCode: Code[20];
        progName: Code[150];
        ACAResultsStatus: Record UnknownRecord78011;
        YearOfStudyText: Text[30];
        SaltedExamStatus: Code[1024];
        SaltedExamStatusDesc: Text;
        ACASenateReportStatusBuff: Record UnknownRecord77718 temporary;
        CurrNo: Integer;
        YoS: Code[20];
        yosInt: Integer;
        ACAUnitsSubjects: Record UnknownRecord61517;
        ReoderElement: Code[10];

    local procedure GetYearofStudyText(Yos: Integer) YosText: Text[150]
    begin
        Clear(YosText);
        if Yos=1 then YosText:='FIRST';
        if Yos=2 then YosText:='SECOND';
        if Yos=3 then YosText:='THIRD';
        if Yos=4 then YosText:='FORTH';
        if Yos=5 then YosText:='FIFTH';
        if Yos=6 then YosText:='SIXTH';
        if Yos=7 then YosText:='SEVENTH';
    end;

    local procedure FormatNames(CommonName: Text[250]) NewName: Text[250]
    var
        NamesSmall: Text[250];
        FirsName: Text[250];
        SpaceCount: Integer;
        SpaceFound: Boolean;
        Counts: Integer;
        Strlegnth: Integer;
        OtherNames: Text[250];
    begin
        Clear(NamesSmall);
        Clear(FirsName);
        Clear(SpaceCount);
        Clear(SpaceFound);
        Clear(OtherNames);
        if StrLen(CommonName)>100 then  CommonName:=CopyStr(CommonName,1,100);
        Strlegnth:=StrLen(CommonName);
        if StrLen(CommonName)>4 then begin
          NamesSmall:=Lowercase(CommonName);
          repeat
            begin
              SpaceCount+=1;
              if ((CopyStr(NamesSmall,SpaceCount,1)='') or (CopyStr(NamesSmall,SpaceCount,1)=' ') or (CopyStr(NamesSmall,SpaceCount,1)=',')) then SpaceFound:=true;
              if not SpaceFound then begin
                FirsName:=FirsName+UpperCase(CopyStr(NamesSmall,SpaceCount,1));
                end else  begin
                  if StrLen(OtherNames)<150 then begin
                if ((CopyStr(NamesSmall,SpaceCount,1)='') or (CopyStr(NamesSmall,SpaceCount,1)=' ') or (CopyStr(NamesSmall,SpaceCount,1)=',')) then begin
                  OtherNames:=OtherNames+' ';
                SpaceCount+=1;
                  OtherNames:=OtherNames+UpperCase(CopyStr(NamesSmall,SpaceCount,1));
                  end else begin
                  OtherNames:=OtherNames+CopyStr(NamesSmall,SpaceCount,1);
                    end;

                end;
                end;
            end;
              until ((SpaceCount=Strlegnth))
          end;
          Clear(NewName);
        NewName:=FirsName+','+OtherNames;
    end;
}

