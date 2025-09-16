#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 66628 "ACA-Classification Incomplete"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/ACA-Classification Incomplete.rdlc';

    dataset
    {
        dataitem(ExamCoregcs;UnknownTable66631)
        {
            CalcFields = "Is Pass";
            DataItemTableView = where(Graduating=filter(No));
            RequestFilterFields = Programme,"Graduation Academic Year","Year of Study";
            column(ReportForNavId_2901; 2901)
            {
            }
            column(Seqs;ClassificationIncompSerial.Serial)
            {
            }
            column(ProgDesc;ACAProgrammeOptions.Desription)
            {
            }
            column(RubricDesc;ACAResultsStatus.Description)
            {
            }
            column(RegNo;RegNo)
            {
            }
            column(Names;Names)
            {
            }
            column(Compname;UpperCase(CompInf.Name))
            {
            }
            column(Pics;CompInf.Picture)
            {
            }
            column(StatusCode;ExamCoregcs.Classification)
            {
            }
            column(StatusDesc;ExamCoregcs.Classification)
            {
            }
            column(SummaryPageCaption;ACAResultsStatus."Summary Page Caption")
            {
            }
            column(StatusOrder;ACAResultsStatus."Order No")
            {
            }
            column(StatCodes;ExamCoregcs.Classification)
            {
            }
            column(ApprovalsClaimer;'Approved by the board of the Examiners of the  '+ExamCoregcs."School Name"+' at a meeting held on:')
            {
            }
            column(StudNo;ExamCoregcs."Student Number")
            {
            }
            column(Progs;ExamCoregcs.Programme)
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
            column(YoS;ExamCoregcs."Year of Study")
            {
            }
            column(AcadYear;ExamCoregcs."Graduation Academic Year")
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
            column(YoA;ExamCoregcs."Admission Academic Year")
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
            column(FinalTexts;FinalTexts)
            {
            }
            column(Messages1;Msg1)
            {
            }
            column(Messages2;Msg2)
            {
            }
            column(Messages3;Msg3)
            {
            }
            column(Messages4;Msg4)
            {
            }
            column(Messages5;Msg5)
            {
            }
            column(Messages6;Msg6)
            {
            }
            column(RubricCounts;ExamCoregcs."Program Grad. List Count")
            {
            }
            column(RubNumberText;RubNumberText)
            {
            }
            column(YearText2;YearText2)
            {
            }
            column(ProgClassCount;ExamCoregcs."Program Grad. List Count")
            {
            }
            column(PageTitle;ACAResultsStatus."Class Title Page Caption")
            {
            }
            dataitem(ClassUnits;UnknownTable66632)
            {
                DataItemLink = "Student No."=field("Student Number"),Programme=field(Programme),"Graduation Academic Year"=field("Graduation Academic Year");
                DataItemTableView = where(Pass=filter(No));
                column(ReportForNavId_1000000015; 1000000015)
                {
                }
                column(UnitCCode;ClassUnits."Unit Code")
                {
                }
                column(UnitDesc;ClassUnits."Unit Description")
                {
                }
                column(Scored;ROUND(ClassUnits."Total Score Decimal",0.01,'='))
                {
                }
                column(Grade;ClassUnits.Grade)
                {
                }
                column(GradeRemarks;ClassUnits."Grade Remark")
                {
                }

                trigger OnAfterGetRecord()
                begin
                     if ((ClassUnits."CAT Score" = '') and (ClassUnits."Exam Score" = '')) then begin
                      ClassUnits."Grade Remark":='Missing Exam & CAT';
                      end else if ((ClassUnits."CAT Score" = '') and (ClassUnits."Exam Score" <> '')) then begin
                      ClassUnits."Grade Remark":='Missing CAT Marks';
                      end else if ((ClassUnits."CAT Score" <> '') and (ClassUnits."Exam Score" = '')) then begin
                      ClassUnits."Grade Remark":='Missing Exam Marks';
                      end else if ((ClassUnits."CAT Score" <> '') and (ClassUnits."Exam Score" <> '')) then begin
                      ClassUnits."Grade Remark":='Failed Course';
                      end;
                end;
            }

            trigger OnAfterGetRecord()
            begin

                Clear(SpecialUnitReg);
                Clear(NextYear);
                Clear(YearOfStudyText);
                Clear(YoS);

                    Clear(YoSText);
                    if ExamCoregcs."Year of Study"=1 then YoSText:='FIRST';
                    if ExamCoregcs."Year of Study"=2 then YoSText:='SECOND';
                    if ExamCoregcs."Year of Study"=3 then YoSText:='THIRD';
                    if ExamCoregcs."Year of Study"=4 then YoSText:='FOURTH';
                    if ExamCoregcs."Year of Study"=5 then YoSText:='FIFTH';
                    if ExamCoregcs."Year of Study"=6 then YoSText:='SIXTH';
                    if ExamCoregcs."Year of Study"=7 then YoSText:='SEVENTH';
                YearText2:=YoSText;
                  Clear(IsaForthYear);
                  if ExamCoregcs."Year of Study"=ExamCoregcs."Final Year of Study" then
                    IsaForthYear:=true;
                ACASenateReportsHeader.Reset;
                ACASenateReportsHeader.SetRange("Academic Year",ExamCoregcs."Graduation Academic Year");
                ACASenateReportsHeader.SetRange("Programme Code",ExamCoregcs.Programme);
                ACASenateReportsHeader.SetRange("Classification Code",ExamCoregcs.Classification);
                ACASenateReportsHeader.SetRange("Year of Study",ExamCoregcs."Year of Study");

                if ACASenateReportsHeader.Find('-') then;
                  ExamCoregcs.CalcFields("Program Grad. List Count");
                  RubNumberText:=ConvertDecimalToText.InitiateConvertion(ExamCoregcs."Program Grad. List Count");

                Clear(progName);
                Prog.Reset;
                Prog.SetRange(Code,ExamCoregcs.Programme);
                if Prog.Find('-') then begin
                  progName:=Prog.Description;
                  end;
                  Clear(Msg1);
                  Clear(Msg2);
                  Clear(Msg3);
                  Clear(Msg4);
                  Clear(Msg5);
                  Clear(Msg6);

                Clear(FacDesc);
                Clear(facCode);
                FacDesc:='';
                Prog.Reset;
                Prog.SetRange(Code,ExamCoregcs.Programme);
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


                  if Cust.Get(ExamCoregcs."Student Number") then;
                  Names:=Cust.Name;
                  RegNo:=ExamCoregcs."Student Number";
                  Clear(UnitCodeLabel);
                  Clear(UnitDescriptionLabel);
                  Clear(PercentageFailedCaption);
                  Clear(NumberOfCoursesFailedCaption);
                  Clear(PercentageFailedValue);
                  Clear(NoOfCausesFailedValue);
                ACAResultsStatus.Reset;
                ACAResultsStatus.SetRange(Code,ExamCoregcs.Classification);
                if ACAResultsStatus.Find('-') then begin
                  if ACAResultsStatus."Include Failed Units Headers" then begin
                    UnitCodeLabel:='Course Code';
                    UnitDescriptionLabel:='Course Title';
                      ExamCoregcs.CalcFields("Failed Units","Total Units");
                    if ExamCoregcs."Failed Units">0 then begin

                      end;
                    end;
                    end;
                  Msg1:=ACAResultsStatus."Classification Msg1";
                  Msg2:=ACAResultsStatus."Classification Msg2";
                  Msg3:=ACAResultsStatus."Classification Msg3";
                  Msg4:=ACAResultsStatus."Classification Msg4";
                  if  IsaForthYear then
                    if ACAResultsStatus."Final Year Comment"='' then IsaForthYear:=false;
                  Msg5:=ACAResultsStatus."Classification Msg5";
                  Msg6:=ACAResultsStatus."Classification Msg6";
                Clear(SaltedExamStatus);
                Clear(SaltedExamStatusDesc);
                SaltedExamStatus:=ACAResultsStatus.Code+facCode+Prog.Code+
                Format(ExamCoregcs."Year of Study")+
                ExamCoregcs."Graduation Academic Year";
                Clear(NoOfStudents);
                Clear(NoOfStudentsDecimal);
                CReg.Reset;
                CReg.SetRange(Classification,ExamCoregcs.Classification);
                CReg.SetRange("Academic Year",ExamCoregcs."Graduation Academic Year");
                CReg.SetRange(Programme,ExamCoregcs.Programme);
                CReg.SetRange("Year of Study",ExamCoregcs."Year of Study");
                CReg.SetFilter("Total Units",'>%1',0);
                if CReg.Find('-') then begin
                  //---------------------------------------------------------
                  ACASenateReportCounts.Reset;
                ACASenateReportCounts.SetRange("Prog. Code",ExamCoregcs.Programme);
                ACASenateReportCounts.SetRange(StatusCode,ExamCoregcs.Classification);
                ACASenateReportCounts.SetRange("Academic Year",ExamCoregcs."Graduation Academic Year");
                ACASenateReportCounts.SetRange(YoS,ExamCoregcs."Year of Study");
                if  ACASenateReportCounts.Find('-') then begin
                  NoOfStudentsDecimal:=Format(ROUND(((ACASenateReportCounts.Count)),1,'>'));
                  if Evaluate(NoOfStudents,NoOfStudentsDecimal) then;
                  end;
                  end;
                  Clear(CurrNo);
                ACASenateReportStatusBuff.Reset;
                ACASenateReportStatusBuff.SetRange("Prog. Code",ExamCoregcs.Programme);
                ACASenateReportStatusBuff.SetRange(StatusCode,ExamCoregcs.Classification);
                ACASenateReportStatusBuff.SetRange("Academic Year",ExamCoregcs."Graduation Academic Year");
                ACASenateReportStatusBuff.SetRange(YoS,ExamCoregcs."Year of Study");
                ACASenateReportStatusBuff.SetRange("Student No.",ExamCoregcs."Student Number");
                if not ACASenateReportStatusBuff.Find('-') then begin
                    ACASenateReportStatusBuff.Init;
                    ACASenateReportStatusBuff."Prog. Code":=ExamCoregcs.Programme;
                    ACASenateReportStatusBuff."Student No.":=ExamCoregcs."Student Number";
                    ACASenateReportStatusBuff.Counts:=1;
                    ACASenateReportStatusBuff.StatusCode:=ExamCoregcs.Classification;
                    ACASenateReportStatusBuff.YoS:=ExamCoregcs."Year of Study";
                    ACASenateReportStatusBuff."Academic Year":=ExamCoregcs."Graduation Academic Year";
                    ACASenateReportStatusBuff.Insert;
                    end;
                ACASenateReportStatusBuff.Reset;
                ACASenateReportStatusBuff.SetRange("Prog. Code",ExamCoregcs.Programme);
                ACASenateReportStatusBuff.SetRange(StatusCode,ExamCoregcs.Classification);
                ACASenateReportStatusBuff.SetRange("Academic Year",ExamCoregcs."Graduation Academic Year");
                ACASenateReportStatusBuff.SetRange(YoS,ExamCoregcs."Year of Study");
                if  ACASenateReportStatusBuff.Find('-') then   CurrNo:=ACASenateReportStatusBuff.Count;

                ResultsStatus3.Reset;
                ResultsStatus3.SetRange(Code,ExamCoregcs.Classification);
                Clear(SpecialUnitReg1);

                 Clear(isSpecialOnly);
                 Clear(IsSpecialAndSupp);
                 if (ExamCoregcs.Classification='SPECIAL') then begin isSpecialOnly:=true;
                 SpecialUnitReg1:=isSpecialOnly;
                 end;


                ACAResultsStatusez.Reset;
                ACAResultsStatusez.SetRange(Code,ExamCoregcs.Classification);
                if ACAResultsStatusez.Find('-') then begin

                  end;

                  Clear(ClassificationIncompSerial);
                  ClassificationIncompSerial.Reset;
                  ClassificationIncompSerial.SetRange("Student Number",ExamCoregcs."Student Number");
                  if ClassificationIncompSerial.Find('-') then;
            end;

            trigger OnPreDataItem()
            begin
                Clear(yosInt);
                if Evaluate(yosInt,ExamCoregcs.GetFilter("Year of Study")) then;
                CReg.Reset;
                CReg.SetRange("Graduation Academic Year",ExamCoregcs.GetFilter("Graduation Academic Year"));
                CReg.SetRange(Programme,ExamCoregcs.GetFilter(Programme));
                CReg.SetRange("Year of Study",yosInt);
                CReg.SetRange(Graduating,false);
                if ExamCoregcs.GetFilter("Programme Option") <>'' then
                CReg.SetFilter("Programme Option",ExamCoregcs.GetFilter("Programme Option"));
                ACAProgrammeOptions.Reset;
                ACAProgrammeOptions.SetRange(Code,ExamCoregcs.GetFilter("Programme Option"));
                ACAProgrammeOptions.SetRange("Programme Code",ExamCoregcs.GetFilter(Programme));
                if ACAProgrammeOptions.Find('-') then;
                if CReg.Find('-') then begin
                  Clear(ClassificationIncompSerial);
                  ClassificationIncompSerial.Reset;
                if ClassificationIncompSerial.Find('-') then ClassificationIncompSerial.DeleteAll;
                  repeat
                    begin
                    ClassificationIncompSerial.Init;
                    ClassificationIncompSerial."Student Number":=CReg."Student Number";
                    if ClassificationIncompSerial.Insert then;
                  end;
                  until CReg.Next=0;
                  end;
                  Clear(sequence);
                  Clear(ClassificationIncompSerial);
                  ClassificationIncompSerial.Reset;
                  if ClassificationIncompSerial.Find('-') then begin
                    repeat
                      begin
                      sequence+=1;
                      ClassificationIncompSerial.Serial :=sequence;
                      ClassificationIncompSerial.Modify;
                      end;
                      until ClassificationIncompSerial.Next = 0;
                    end;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

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
    begin
        if ExamCoregcs.GetFilter("Year of Study")='' then Error('Specify Year of Study');
        if ExamCoregcs.GetFilter(Programme)='' then Error('Specify Programme');
        if ExamCoregcs.GetFilter("Graduation Academic Year")='' then Error('Specify Academic Year');
    end;

    var
        ACAProgrammeOptions: Record UnknownRecord61554;
        ACAResultsStatusez: Record UnknownRecord78011;
        YoSText: Text[1024];
        ACASenateReportsHeader: Record UnknownRecord66654;
        FinalTexts: Text[1024];
        YearText2: Text[1024];
        RubNumberText: Text[1024];
        NotSpecialNotSuppSpecial: Boolean;
        isSpecialOnly: Boolean;
        IsSpecialAndSupp: Boolean;
        IsaForthYear: Boolean;
        IsSpecialUnit: Boolean;
        SpecialUnitReg1: Boolean;
        SpecialUnitReg: Boolean;
        ACASenateReportCounts: Record UnknownRecord77741;
        NoOfStudentInText: Text[250];
        ConvertDecimalToText: Codeunit "Convert Decimal To Text";
        PercentageFailedCaption: Text[100];
        NumberOfCoursesFailedCaption: Text[100];
        PercentageFailedValue: Decimal;
        NoOfCausesFailedValue: Integer;
        NoOfStudentsDecimal: Text;
        ACAStudentUnits: Record UnknownRecord66650;
        CountedRecs: Integer;
        UnitCodes: array [30] of Text[50];
        UnitDescs: array [30] of Text[150];
        UnitCodeLabel: Text;
        UnitDescriptionLabel: Text;
        NoOfStudents: Integer;
        StudUnits: Record UnknownRecord66650;
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
        CREG2: Record UnknownRecord66651;
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
        ACASenateReportStatusBuff: Record UnknownRecord77740 temporary;
        CurrNo: Integer;
        YoS: Code[20];
        CReg33: Record UnknownRecord66631;
        CReg: Record UnknownRecord66631;
        yosInt: Integer;
        ClassificationIncompSerial: Record UnknownRecord66636 temporary;
        sequence: Integer;
}

