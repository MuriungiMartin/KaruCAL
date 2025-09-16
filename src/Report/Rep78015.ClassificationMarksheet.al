#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 78015 "Classification Marksheet"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Classification Marksheet.rdlc';

    dataset
    {
        dataitem(UnknownTable61532;UnknownTable61532)
        {
            DataItemTableView = sorting("Year of Admission","Student No.") order(ascending) where("Is Final Year Student"=filter(Yes),Reversed=filter(No),Status=filter(Registration|Current|Deceased),"Final Clasification"=filter(<>""));
            RequestFilterFields = Faculty,Programme,"Graduation Academic Year";
            column(ReportForNavId_2901; 2901)
            {
            }
            column(seq;seq)
            {
            }
            column(RegNo;RegNo)
            {
            }
            column(Names;Names)
            {
            }
            column(ProgOptionDescriptio;ProgOptions.Desription)
            {
            }
            column(ProgramOptionCode;ProgOptions.Code)
            {
            }
            column(facCode;facCode)
            {
            }
            column(FacDesc;FacDesc)
            {
            }
            column(GradAcadYear;"ACA-Course Registration"."Graduation Academic Year")
            {
            }
            column(YearlyReqUnits;"ACA-Course Registration"."Yearly Grad. Req. Units")
            {
            }
            column(WeightedInits;"ACA-Course Registration"."Yearly Grad. Weighted Units")
            {
            }
            column(TotalReqUnits;"ACA-Course Registration"."Final  Grad. Req. Units")
            {
            }
            column(WTDTotal;"ACA-Course Registration"."Final Grad. Weighted Units")
            {
            }
            column(WTDAve;"ACA-Course Registration"."Final Grad. W.Average")
            {
            }
            column(FinClassification;"ACA-Course Registration"."Final Clasification")
            {
            }
            column(Compname;UpperCase(CompInf.Name))
            {
            }
            column(Pics;CompInf.Picture)
            {
            }
            column(StatusOrderCompiled;StatusOrder)
            {
            }
            column(statusCompiled;statusCompiled)
            {
            }
            column(StatusCode;ResultsStatus3.Code)
            {
            }
            column(StatusDesc;ResultsStatus.Description)
            {
            }
            column(SummaryPageCaption;ACAResultsStatus."Summary Page Caption")
            {
            }
            column(StatusOrder;ACAResultsStatus."Order No")
            {
            }
            column(StatCodes;ACAResultsStatus.Code)
            {
            }
            column(ApprovalsClaimer;'Approved by the board of the Examiners of the  '+FacDesc+' at a meeting held on:')
            {
            }
            column(RegTrans;"ACA-Course Registration"."Reg. Transacton ID")
            {
            }
            column(StudNo;"ACA-Course Registration"."Student No.")
            {
            }
            column(Progs;"ACA-Course Registration".Programme)
            {
            }
            column(ProgName;progName)
            {
            }
            column(Sems;"ACA-Course Registration".Semester)
            {
            }
            column(RegFor;"ACA-Course Registration"."Register for")
            {
            }
            column(CourseStage;"ACA-Course Registration".Stage)
            {
            }
            column(Units;"ACA-Course Registration".Unit)
            {
            }
            column(StudType;"ACA-Course Registration"."Student Type")
            {
            }
            column(EntryNo;"ACA-Course Registration"."Entry No.")
            {
            }
            column(CampusCode;"ACA-Course Registration"."Campus Code")
            {
            }
            column(ExamStatus;"ACA-Course Registration"."Exam Status")
            {
            }
            column(FailedUnits;"ACA-Course Registration"."Failed Unit")
            {
            }
            column(YoS;"ACA-Course Registration"."Year Of Study")
            {
            }
            column(GraduationGroup;"ACA-Course Registration"."Graduation Group")
            {
            }
            column(ProgOption;"ACA-Course Registration"."Program Option (Flow)")
            {
            }
            column(YearOfStudyText;YearOfStudyText)
            {
            }
            column(NextYear;NextYear)
            {
            }
            column(SaltedExamStatusDesc;SaltedExamStatusDesc)
            {
            }
            column(SaltedExamStatus;SaltedExamStatus)
            {
            }
            column(counts;CurrNo)
            {
            }
            column(YoSTexed;YoS)
            {
            }
            column(UnitCodeLabel;UnitCodeLabel)
            {
            }
            column(UnitDescriptionLabel;UnitDescriptionLabel)
            {
            }
            column(PercentageFailedCaption;PercentageFailedCaption)
            {
            }
            column(NumberOfCoursesFailedCaption;NumberOfCoursesFailedCaption)
            {
            }
            column(PercentageFailedValue;PercentageFailedValue)
            {
            }
            column(NoOfCausesFailedValue;NoOfCausesFailedValue)
            {
            }
            column(YoA;"ACA-Course Registration"."Year of Admission")
            {
            }
            column(SpecialUnitReg;SpecialUnitReg1)
            {
            }
            column(IsSpecialAndSupp;IsSpecialAndSupp)
            {
            }
            column(IsSpecialOnly;isSpecialOnly)
            {
            }
            column(NotSpecialNotSuppSpecial;NotSpecialNotSuppSpecial)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Clear(seq);
                Clear(SpecialUnitReg);
                "ACA-Course Registration".CalcFields("ACA-Course Registration"."Special Exam Exists","ACA-Course Registration"."Program Option (Flow)");
                ProgOptions.Reset;
                ProgOptions.SetRange("Programme Code","ACA-Course Registration".Programme);
                ProgOptions.SetRange(Code,"ACA-Course Registration"."Program Option (Flow)");
                if ProgOptions.Find('-') then;
                "ACA-Course Registration".CalcFields("ACA-Course Registration"."Supp. Yearly Passed Units","ACA-Course Registration"."Supp. Yearly Failed Units");
                "ACA-Course Registration".CalcFields("ACA-Course Registration"."Supp. Yearly Total Units Taken","ACA-Course Registration"."Is Final Year Student");
                Clear(NextYear);
                Clear(YearOfStudyText);
                Clear(YoS);
                if "ACA-Course Registration"."Year Of Study"<>0 then begin
                  if "ACA-Course Registration"."Year Of Study"=1 then begin
                    YearOfStudyText:='First Year (1)';
                    YoS:='FIRST';
                    if "ACA-Course Registration"."Yearly Failed Units"=0 then NextYear:='SECOND'
                     else NextYear:='FIRST';
                  end else if "ACA-Course Registration"."Year Of Study"=2 then begin
                    YearOfStudyText:='Second Year (2)';
                    YoS:='SECOND';
                    if "ACA-Course Registration"."Yearly Failed Units"=0 then NextYear:='THIRD'
                     else NextYear:='THIRD';
                  end else if "ACA-Course Registration"."Year Of Study"=3 then begin
                    YearOfStudyText:='Third Year (3)';
                    YoS:='THIRD';
                    if "ACA-Course Registration"."Yearly Failed Units"=0 then NextYear:='FOURTH'
                     else NextYear:='THIRD';
                  end else if "ACA-Course Registration"."Year Of Study"=4 then begin
                    YearOfStudyText:='Fourth Year (4)';
                    YoS:='FOURTH';
                   NextYear:='FOUR';
                    end;
                  end;

                  Clear(IsaForthYear);
                  Clear(statusCompiled);
                  IsaForthYear:="ACA-Course Registration"."Is Final Year Student";
                 Clear(StatusOrder);
                if "ACA-Course Registration"."Final Clasification"='INCOMPLETE' then begin
                statusCompiled:='INCOMPLETE RESULTS LIST';
                  StatusOrder:=2;
                  end
                else if "ACA-Course Registration"."Final Clasification"<>'' then begin
                statusCompiled:='CLASSIFICATION LIST';
                  StatusOrder:=1;
                  end;


                  Clear(Msg1);
                  Clear(Msg2);
                  Clear(Msg3);
                  Clear(Msg4);
                  Clear(Msg5);
                  Clear(Msg6);

                //Get the Department
                Clear(seq);
                Clear(progName);
                Prog.Reset;
                Prog.SetRange(Code,"ACA-Course Registration".Programme);
                if Prog.Find('-') then begin
                  progName:=Prog.Description;
                  end;
                Clear(FacDesc);
                Clear(facCode);
                FacDesc:='';
                Prog.Reset;
                Prog.SetRange(Code,"ACA-Course Registration".Programme);
                Prog.SetFilter("School Code",'<>%1','');
                if Prog.Find('-') then begin
                Dimensions2.Reset;
                Dimensions2.SetRange("Dimension Code",'SCHOOL');
                Dimensions2.SetRange(Code,Prog."School Code");
                if Dimensions2.Find('-') then begin
                  FacDesc:=Dimensions2.Name;
                  facCode:=Dimensions2.Code;
                  end;
                end;



                  if Cust.Get("ACA-Course Registration"."Student No.") then;
                  Names:=Cust.Name;
                  RegNo:="ACA-Course Registration"."Student No.";
                ///////////////////////////////////////////////////////////////////Gjenerate Series
                    "ACA-Course Registration".CalcFields("ACA-Course Registration"."Program Option (Flow)");
                    Clear(seq);
                     ClassificationSheetCounts.Reset;
                  ClassificationSheetCounts.SetRange("Grad. Academic Year","ACA-Course Registration"."Graduation Academic Year");
                  ClassificationSheetCounts.SetRange("Graduation Group","ACA-Course Registration"."Graduation Group");
                  ClassificationSheetCounts.SetRange("Programme Code","ACA-Course Registration".Programme);
                  ClassificationSheetCounts.SetRange("Programme Option","ACA-Course Registration"."Program Option (Flow)");
                  if ClassificationSheetCounts.Find('-') then
                  seq:=ClassificationSheetCounts.Count;


                  ClassificationSheetCounts.Reset;
                  ClassificationSheetCounts.SetRange("Grad. Academic Year","ACA-Course Registration"."Graduation Academic Year");
                  ClassificationSheetCounts.SetRange("Graduation Group","ACA-Course Registration"."Graduation Group");
                  ClassificationSheetCounts.SetRange("Programme Code","ACA-Course Registration".Programme);
                  ClassificationSheetCounts.SetRange("Programme Option","ACA-Course Registration"."Program Option (Flow)");
                  ClassificationSheetCounts.SetRange("Student No.","ACA-Course Registration"."Student No.");
                  if not (ClassificationSheetCounts.Find('-')) then begin
                      seq:=seq+1;
                    ClassificationSheetCounts.Init;
                    ClassificationSheetCounts."Grad. Academic Year":="ACA-Course Registration"."Graduation Academic Year";
                    ClassificationSheetCounts."Graduation Group":="ACA-Course Registration"."Graduation Group";
                    ClassificationSheetCounts."Programme Code":="ACA-Course Registration".Programme;
                    ClassificationSheetCounts."Programme Option":="ACA-Course Registration"."Program Option (Flow)";
                    ClassificationSheetCounts."Student No.":="ACA-Course Registration"."Student No.";
                    ClassificationSheetCounts.Counts:=seq;
                    ClassificationSheetCounts.Insert;
                  end;
                ////////////////////////////////////////////////////////////////////////////// End pof Series Generation

                  ClassificationSheetCounts.Reset;
                  ClassificationSheetCounts.SetRange("Grad. Academic Year","ACA-Course Registration"."Graduation Academic Year");
                  ClassificationSheetCounts.SetRange("Graduation Group","ACA-Course Registration"."Graduation Group");
                  ClassificationSheetCounts.SetRange("Programme Code","ACA-Course Registration".Programme);
                  ClassificationSheetCounts.SetRange("Programme Option","ACA-Course Registration"."Program Option (Flow)");
                  ClassificationSheetCounts.SetRange("Student No.","ACA-Course Registration"."Student No.");
                  if ClassificationSheetCounts.Find('-') then begin
                    seq:=ClassificationSheetCounts.Counts;
                    end;
            end;

            trigger OnPreDataItem()
            begin

                if "ACA-Course Registration".GetFilter("ACA-Course Registration".Semester)<>'' then Error('Semester Filters are not allowed.');
                if "ACA-Course Registration".GetFilter("ACA-Course Registration".Stage)<>'' then Error('Stage Filters are not allowed.');
                if "ACA-Course Registration".GetFilter("ACA-Course Registration"."Graduation Academic Year")='' then Error('Specify Graduation Academic Year');
                Clear(yosInt);
                Clear(statusCompiled);


                if Evaluate(yosInt,"ACA-Course Registration".GetFilter("Year Of Study")) then;
                CReg.Reset;
                CReg.SetRange("Graduation Academic Year","ACA-Course Registration".GetFilter("Graduation Academic Year"));
                CReg.SetRange(Programme,"ACA-Course Registration".GetFilter(Programme));
                CReg.SetFilter(Reversed,'%1',false);
                CReg.SetFilter("Final Clasification",'<>%1','');
                CReg.SetFilter("Is Final Year Student",'%1',true);
                CReg.SetFilter(Status,'%1|%2|%3',CReg.Status::Current,CReg.Status::Deceased,CReg.Status::Registration);
                if CReg.Find('-') then begin
                  CReg.SetCurrentkey("Student No.");
                     ClassificationSheetCounts.Reset;
                  ClassificationSheetCounts.SetRange("Grad. Academic Year","ACA-Course Registration".GetFilter("Graduation Academic Year"));
                  ClassificationSheetCounts.SetRange("Programme Code","ACA-Course Registration".GetFilter(Programme));
                  if ClassificationSheetCounts.Find('-') then ClassificationSheetCounts.DeleteAll;
                    repeat
                    begin
                  end;
                  until CReg.Next=0;
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

    trigger OnInitReport()
    begin
        CompInf.Get();
        CompInf.CalcFields(CompInf.Picture);
    end;

    var
        ClassificationSheetCounts: Record UnknownRecord78006;
        seq: Integer;
        ProgOptions: Record UnknownRecord61554;
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
        ACAStudentUnits: Record UnknownRecord61549;
        CountedRecs: Integer;
        UnitCodes: array [30] of Text[50];
        UnitDescs: array [30] of Text[150];
        UnitCodeLabel: Text;
        UnitDescriptionLabel: Text;
        NoOfStudents: Integer;
        StudUnits: Record UnknownRecord61549;
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
        CREG2: Record UnknownRecord61532;
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
        CReg33: Record UnknownRecord61532;
        CReg: Record UnknownRecord61532;
        yosInt: Integer;
}

