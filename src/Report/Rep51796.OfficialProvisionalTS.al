#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51796 "Official Provisional TS"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Official Provisional TS.rdlc';
    Caption = 'Provisional College Transcript';

    dataset
    {
        dataitem(CourseRegs;UnknownTable66651)
        {
            CalcFields = Grade,"Override Remarks",Remarks;
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Student Number",Programme,"School Code","Academic Year","Year of Study";
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(CoName;'Tom Mboya University College')
            {
            }
            column(addresses;CompanyInformation.Address+','+CompanyInformation."Address 2"+' '+CompanyInformation.City)
            {
            }
            column(phones;CompanyInformation."Phone No."+','+CompanyInformation."Phone No. 2")
            {
            }
            column(Mails;CompanyInformation."E-Mail"+'/'+CompanyInformation."Home Page")
            {
            }
            column(Pic;CompanyInformation.Picture)
            {
            }
            column(StudNo;CourseRegs."Student Number")
            {
            }
            column(Prog;CourseRegs.Programme)
            {
            }
            column(Sem;'')
            {
            }
            column(Stag;'')
            {
            }
            column(CumSc;'')
            {
            }
            column(CurrSem;'')
            {
            }
            column(GradedGrade;CourseRegs.Grade)
            {
            }
            column(remsz;remsz)
            {
            }
            column(YoS;CourseRegs."Year of Study")
            {
            }
            column(TotalYearlyMarks;CourseRegs."Total Marks")
            {
            }
            column(YearlyAverage;CourseRegs."Normal Average")
            {
            }
            column(YearlyGrade;GetGrade(CourseRegs."Normal Average",CourseRegs.Programme))
            {
            }
            column(YearlyFailed;CourseRegs."Failed Courses")
            {
            }
            column(YearlyTotalUnits;CourseRegs."Total Courses")
            {
            }
            column(CummulativeAverage;CourseRegs."Weighted Average")
            {
            }
            column(CurrAverage;CourseRegs."Normal Average")
            {
            }
            column(YearlyRemarks;TransCriptRemarks)
            {
            }
            column(AcadYear;CourseRegs."Academic Year")
            {
            }
            column(sName;CourseRegs."Student Name")
            {
            }
            column(pName;UpperCase(pName))
            {
            }
            column(GRADDATE;GRADDATE)
            {
            }
            column(YearOfStudy;YearOfStudy)
            {
            }
            column(YearOfAdmi;YearOfAdmi)
            {
            }
            column(SchoolName;SchoolName)
            {
            }
            column(acadyearz;acadyear)
            {
            }
            column(signedSignature;dimVal.Signature)
            {
            }
            column(TranscriptSignatory;dimVal."HOD Names")
            {
            }
            column(TransCriptTitle;dimVal.Titles)
            {
            }
            column(FacultyName;CourseRegs."School Name")
            {
            }
            column(codSchool;'COD, '+SchoolName)
            {
            }
            column(codDept;'COD,'+DeptName)
            {
            }
            column(PassRemark;PassRemark)
            {
            }
            column(RegAcadLabel;'Registrar, Academic Affairs')
            {
            }
            column(Cat1;Cat1)
            {
            }
            column(Cat2;Cat2)
            {
            }
            column(Cat3;Cat3)
            {
            }
            column(LegendRange11;LegendRange1[1])
            {
            }
            column(LegendGrade11;LegendGrade1[1])
            {
            }
            column(LegendDesc11;LegendDesc1[1])
            {
            }
            column(LegendRange12;LegendRange1[2])
            {
            }
            column(LegendGrade12;LegendGrade1[2])
            {
            }
            column(LegendDesc12;LegendDesc1[2])
            {
            }
            column(LegendRange13;LegendRange1[3])
            {
            }
            column(LegendGrade13;LegendGrade1[3])
            {
            }
            column(LegendDesc13;LegendDesc1[3])
            {
            }
            column(LegendRange14;LegendRange1[4])
            {
            }
            column(LegendGrade14;LegendGrade1[4])
            {
            }
            column(LegendDesc14;LegendDesc1[4])
            {
            }
            column(LegendRange15;LegendRange1[5])
            {
            }
            column(LegendGrade15;LegendGrade1[5])
            {
            }
            column(LegendDesc15;LegendDesc1[5])
            {
            }
            column(LegendRange16;LegendRange1[6])
            {
            }
            column(LegendGrade16;LegendGrade1[6])
            {
            }
            column(LegendDesc16;LegendDesc1[6])
            {
            }
            column(LegendRange21;LegendRange2[1])
            {
            }
            column(LegendGrade21;LegendGrade2[1])
            {
            }
            column(LegendDesc21;LegendDesc2[1])
            {
            }
            column(LegendRange22;LegendRange2[2])
            {
            }
            column(LegendGrade22;LegendGrade2[2])
            {
            }
            column(LegendDesc22;LegendDesc2[2])
            {
            }
            column(LegendRange23;LegendRange2[3])
            {
            }
            column(LegendGrade23;LegendGrade2[3])
            {
            }
            column(LegendDes23;LegendDesc2[3])
            {
            }
            column(LegendRange24;LegendRange2[4])
            {
            }
            column(LegendGrade24;LegendGrade2[4])
            {
            }
            column(LegendDesc24;LegendDesc2[4])
            {
            }
            column(LegendRange25;LegendRange2[5])
            {
            }
            column(LegendGrade25;LegendGrade2[5])
            {
            }
            column(LegendDesc25;LegendDesc2[5])
            {
            }
            column(LegendRange26;LegendRange2[6])
            {
            }
            column(LegendGrade26;LegendGrade2[6])
            {
            }
            column(LegendDesc26;LegendDesc2[6])
            {
            }
            column(LegendRange31;LegendRange3[1])
            {
            }
            column(LegendGrade31;LegendGrade3[1])
            {
            }
            column(LegendDesc31;LegendDesc3[1])
            {
            }
            column(LegendRange32;LegendRange3[2])
            {
            }
            column(LegendGrade32;LegendGrade3[2])
            {
            }
            column(LegendDesc32;LegendDesc3[2])
            {
            }
            column(LegendRange33;LegendRange3[3])
            {
            }
            column(LegendGrade33;LegendGrade3[3])
            {
            }
            column(LegendDesc33;LegendDesc3[3])
            {
            }
            column(LegendRange34;LegendRange3[4])
            {
            }
            column(LegendGrade34;LegendGrade3[4])
            {
            }
            column(LegendDesc34;LegendDesc3[4])
            {
            }
            column(LegendRange35;LegendRange3[5])
            {
            }
            column(LegendGrade35;LegendGrade3[5])
            {
            }
            column(LegendDesc35;LegendDesc3[5])
            {
            }
            column(LegendRange36;LegendRange3[6])
            {
            }
            column(LegendGrade36;LegendGrade3[6])
            {
            }
            column(LegendDesc36;LegendDesc3[6])
            {
            }
            dataitem(StudUnitsss;UnknownTable66650)
            {
                DataItemLink = "Student No."=field("Student Number"),Programme=field(Programme),"Year of Study"=field("Year of Study"),"Academic Year"=field("Academic Year");
                column(ReportForNavId_1000000005; 1000000005)
                {
                }
                column(Unit;StudUnitsss."Unit Code")
                {
                }
                column(Desc;StudUnitsss."Unit Description")
                {
                }
                column(CreditHours;StudUnitsss."Credit Hours")
                {
                }
                column(Score;StudUnitsss."Total Score")
                {
                }
                column(Final;StudUnitsss."Total Score")
                {
                }
                column(Grade;StudUnitsss.Grade)
                {
                }
                column(Status;StudUnitsss."Grade Comment")
                {
                }
                dataitem(ExamGraddingSetup;UnknownTable61599)
                {
                    DataItemLink = Category=field("Exam Category"),Grade=field(Grade);
                    column(ReportForNavId_32; 32)
                    {
                    }
                    column(ExamCat;ExamGraddingSetup.Category)
                    {
                    }
                    column(CatGrade;ExamGraddingSetup.Grade)
                    {
                    }
                    column(CatGradeDesc;ExamGraddingSetup.Description)
                    {
                    }
                    column(CatRange;ExamGraddingSetup.Range)
                    {
                    }
                }

                trigger OnAfterGetRecord()
                var
                    ProgCategory: Code[20];
                    ACAExamGraddingSetup: Record UnknownRecord61599;
                begin
                end;
            }

            trigger OnAfterGetRecord()
            begin

                Clear(LegendDesc3);
                Clear(LegendGrade3);
                Clear(LegendRange3);

                Clear(LegendDesc1);
                Clear(LegendGrade1);
                Clear(LegendRange1);

                Clear(LegendDesc2);
                Clear(LegendGrade2);
                Clear(LegendRange2);

                Clear(Countings);
                Clear(Countings2);
                Clear(Countings3);
                 Clear(SchoolName);
                 prog.Reset;
                 prog.SetRange(Code,CourseRegs.Programme);
                 if prog.Find('-') then;
                 pName:=prog.Description;
                 ProvisionalTranscriptComment.Reset;
                 ProvisionalTranscriptComment.SetRange(Code,CourseRegs."Final Classification");
                 ProvisionalTranscriptComment.SetRange("Special Programme Class",prog."Special Programme Class");
                 ProvisionalTranscriptComment.SetRange("Exam Category",prog."Exam Category");
                 if ProvisionalTranscriptComment.Find('-') then;
                 Clear(remsz);
                 if CourseRegs."Year of Study"=1 then
                   remsz:=ProvisionalTranscriptComment."1st Year Trans. Comments"
                 else if  CourseRegs."Year of Study"=2 then
                   remsz:=ProvisionalTranscriptComment."2nd Year  Trans. Comments"
                 else if  CourseRegs."Year of Study"=3 then
                   remsz:=ProvisionalTranscriptComment."3rd Year  Trans. Comments"
                 else if  CourseRegs."Year of Study"=4 then
                   remsz:=ProvisionalTranscriptComment."4th Year  Trans. Comments"
                 else if  CourseRegs."Year of Study"=5 then
                   remsz:=ProvisionalTranscriptComment."5th Year  Trans. Comments"
                 else if  CourseRegs."Year of Study"=6 then
                   remsz:=ProvisionalTranscriptComment."6th Year  Trans. Comments";

                  begin
                   prog.TestField("Exam Category");
                    ACAExamGraddingSetup.Reset;
                   ACAExamGraddingSetup.SetRange(Category,prog."Exam Category");
                   if ACAExamGraddingSetup.SetCurrentkey(Grade) then;
                                   if ACAExamGraddingSetup.Find('-') then begin
                                     if ((Cat1='') and (Cat2='') and (Cat3='')) then Cat1:=prog."Exam Category"
                                     else if ((Cat1<>'') and (Cat1<>prog."Exam Category") and (Cat2='')) then Cat2 :=prog."Exam Category"
                                     else if ((Cat1<>'')  and (Cat2<>'') and (Cat1<>prog."Exam Category") and (Cat2<>prog."Exam Category") and (Cat3='')) then Cat3 :=prog."Exam Category";
                                     repeat
                                       begin
                                       if ((Cat2='') and (Cat3='') and (Cat1<>'')) then begin
                                     Countings +=1;
                                     LegendDesc1[Countings]:=ACAExamGraddingSetup.Description;
                                     LegendGrade1[Countings]:=ACAExamGraddingSetup.Grade;
                                     LegendRange1[Countings]:=ACAExamGraddingSetup.Range;
                                     end else if ((Cat2<>'') and (Cat3='') and (Cat1<>'')) then begin
                                     Countings2 +=1;
                                     LegendDesc1[Countings2]:=ACAExamGraddingSetup.Description;
                                     LegendGrade1[Countings2]:=ACAExamGraddingSetup.Grade;
                                     LegendRange1[Countings2]:=ACAExamGraddingSetup.Range;
                                     end else if ((Cat2<>'') and (Cat3<>'') and (Cat1<>'')) then begin
                                     Countings3 +=1;
                                     LegendDesc1[Countings3]:=ACAExamGraddingSetup.Description;
                                     LegendGrade1[Countings3]:=ACAExamGraddingSetup.Grade;
                                     LegendRange1[Countings3]:=ACAExamGraddingSetup.Range;
                                     end;
                                     end;
                                     until ACAExamGraddingSetup.Next=0;
                                     end;
                 pName:=prog.Description;
                  dimVal.Reset;
                  dimVal.SetRange(dimVal."Dimension Code",'FACULTY');
                  dimVal.SetRange(dimVal.Code,prog."School Code");
                  if dimVal.Find('-') then begin
                   SchoolName:=dimVal.Name;
                  end;
                  end;
                  ///////////////////////////////////////

                  dimVal.Reset;
                  dimVal.SetRange(dimVal."Dimension Code",'Department');
                  dimVal.SetRange(dimVal.Code,prog."Department Code");
                  if dimVal.Find('-') then begin
                   DeptName:=dimVal.Name;
                   // dimVal.CALCFIELDS(Signature);
                  end;

                Clear(YearOfStudy);

                YearOfStudy:=Format(CourseRegs."Year of Study");


                Clear(sName);
                Clear(YearOfAdmi);
                Clear(GRADDATE);
                cust.Reset;
                cust.SetRange(cust."No.",CourseRegs."Student Number");
                if cust.Find('-') then begin
                end;
                   sName:=CourseRegs."Student Name";

                CourseReg12.Reset;
                CourseReg12.SetRange(Programme,CourseRegs.Programme);
                CourseReg12.SetRange("Student No.",CourseRegs."Student Number");
                if CourseReg12.Find('-') then begin
                  //IF CourseReg12."Registration Date"<>0D THEN BEGIN
                  Sem.Reset;
                  Sem.SetRange(Code,CourseReg12.Semester);
                  if Sem.Find('-') then
                    begin
                      if Sem.From<>0D then begin
                        ACAProgCatTranscriptComm.Reset;
                        ACAProgCatTranscriptComm.SetRange("Exam Catogory",prog."Exam Category");
                        if ACAProgCatTranscriptComm.Find('-') then
                    GRADDATE:=Format(Date2dmy((CalcDate(Format(ACAProgCatTranscriptComm.Count)+'Y',Sem.From)),3));
                    YearOfAdmi:=Sem.From;
                    end;
                    end;
                end;



                Clear(TransCriptRemarks);
                acadyear:=CourseRegs."Academic Year";
                ACAResultsStatus.Reset;
                ACAResultsStatus.SetRange(Code,CourseRegs.Classification);
                ACAResultsStatus.SetRange("Academic Year",acadyear);
                if ACAResultsStatus.Find('-') then begin
                    if CourseRegs."Year of Study"=CourseRegs."Final Year of Study" then begin
                    TransCriptRemarks:=ACAResultsStatus."Final Year Comment";
                    // Its a finalist
                    end else begin
                    TransCriptRemarks:=ACAResultsStatus."Transcript Remarks";
                    end;
                  end;
                  if ((CourseRegs."Override Remarks") and (CourseRegs.Remarks<>'')) then
                    remsz:=CourseRegs.Remarks;
            end;

            trigger OnPostDataItem()
            begin
                 // ExamProcess.UpdateCourseReg("Course Registration"."Student No.","Course Registration".Programme,"Course Registration".Stage,"Course Registration".Semester);
            end;

            trigger OnPreDataItem()
            begin
                Clear(Cat1);
                Clear(Cat2);
                Clear(Cat3);
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
        CompanyInformation.Reset;
        if CompanyInformation.Find('-') then begin
          CompanyInformation.CalcFields(Picture);
          end;
    end;

    var
        remsz: Text[250];
        ProvisionalTranscriptComment: Record UnknownRecord88852;
        ACAProgCatTranscriptComm: Record UnknownRecord78020;
        TransCriptRemarks: Text[250];
        CourseReg12: Record UnknownRecord61532;
        GRADDATE: Code[30];
        pName: Text[250];
        YearOfStudy: Code[10];
        YearOfAdmi: Date;
        SchoolName: Text[250];
        Sem: Record UnknownRecord61692;
        TotalCatMarks: Decimal;
        TotalCatContributions: Decimal;
        TotalMainExamContributions: Decimal;
        TotalExamMark: Decimal;
        FinalExamMark: Decimal;
        FinalCATMarks: Decimal;
        Gradez: Code[10];
        TotalMarks: Decimal;
        LastGrade: Code[20];
        LastScore: Decimal;
        ExitDo: Boolean;
        Gradeaqq2: Code[10];
        TotMarks: Decimal;
        sName: Code[250];
        cust: Record Customer;
        acadyear: Code[20];
        Sems: Code[20];
        prog: Record UnknownRecord61511;
        dimVal: Record "Dimension Value";
        PassRemark: Text[200];
        SemRec: Record UnknownRecord61692;
        DeptName: Text[100];
        i: Integer;
        GLabel: array [10] of Text[200];
        GLabel2: array [10] of Text[200];
        Passmark: Decimal;
        CompanyInformation: Record "Company Information";
        UnitsCount: Integer;
        UnitsFailedCount: Integer;
        TotalMarksCounted: Decimal;
        AverageMarks: Decimal;
        AvrgGrade: Code[1];
        AvrgRemarks: Code[250];
        YearofStudyView: Option " ","1st","2nd","3rd","4th","5th","6th";
        SemesterLoader: Integer;
        ProgramLoader: Integer;
        LegendRange1: array [50] of Code[20];
        LegendGrade1: array [50] of Code[2];
        LegendDesc1: array [50] of Code[50];
        LegendRange2: array [50] of Code[20];
        LegendGrade2: array [50] of Code[2];
        LegendDesc2: array [50] of Code[50];
        LegendRange3: array [50] of Code[20];
        LegendGrade3: array [50] of Code[2];
        LegendDesc3: array [50] of Code[50];
        ACAExamGraddingSetup: Record UnknownRecord61599;
        Cat1: Code[20];
        Cat2: Code[20];
        Cat3: Code[20];
        Countings: Integer;
        Countings2: Integer;
        Countings3: Integer;
        ACAResultsStatus: Record UnknownRecord61739;


    procedure GetGrade(EXAMMark: Decimal;Proga: Code[20]) xGrade: Text[100]
    var
        UnitsRR: Record UnknownRecord61517;
        ProgrammeRec: Record UnknownRecord61511;
        LastGrade: Code[20];
        LastRemark: Code[20];
        ExitDo: Boolean;
        LastScore: Decimal;
        Gradings: Record UnknownRecord61599;
        Gradings2: Record UnknownRecord61599;
        GradeCategory: Code[20];
        GLabel: array [6] of Code[20];
        i: Integer;
        GLabel2: array [6] of Code[100];
        FStatus: Boolean;
        Grd: Code[80];
        Grade: Code[20];
        Marks: Decimal;
    begin
         Clear(Marks);
        Marks:=EXAMMark;
        GradeCategory:='';
        ProgrammeRec.Reset;
        if ProgrammeRec.Get(Proga) then
        GradeCategory:=ProgrammeRec."Exam Category";
        if GradeCategory='' then  GradeCategory:='DEFAULT';
        xGrade:='';

        Gradings.Reset;
        Gradings.SetRange(Gradings.Category,GradeCategory);
        Gradings.SetFilter(Gradings."Lower Limit",'<%1|=%2',Marks,Marks);
        Gradings.SetFilter(Gradings."Upper Limit",'>%1|=%2',Marks,Marks);
        if Gradings.Find('-') then begin
        xGrade:=Gradings.Grade;
        end;
    end;
}

