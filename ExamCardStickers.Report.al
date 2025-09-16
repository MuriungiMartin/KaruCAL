#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51775 "Exam Card Stickers"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Exam Card Stickers.rdlc';

    dataset
    {
        dataitem(UnknownTable61532;UnknownTable61532)
        {
            RequestFilterFields = "Student No.",Programme,Stage,Semester;
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(StudNo;"ACA-Course Registration"."Student No.")
            {
            }
            column(Prog;"ACA-Course Registration".Programme)
            {
            }
            column(Sem;"ACA-Course Registration".Semester)
            {
            }
            column(Stag;"ACA-Course Registration".Stage)
            {
            }
            column(CumSc;"ACA-Course Registration"."Cumm Score")
            {
            }
            column(CurrSem;"ACA-Course Registration"."Current Cumm Score")
            {
            }
            column(sName;sName)
            {
            }
            column(pName;pName)
            {
            }
            column(Addr_1_1_;Addr[1][1])
            {
            }
            column(Addr_1_2_;Addr[1][2])
            {
            }
            column(Addr_1_3_;Addr[1][3])
            {
            }
            column(Addr_2_1_;Addr[2][1])
            {
            }
            column(Addr_2_2_;Addr[2][2])
            {
            }
            column(Addr_2_3_;Addr[2][3])
            {
            }
            column(Addr_3_1_;Addr[3][1])
            {
            }
            column(Addr_3_2_;Addr[3][2])
            {
            }
            column(Addr_3_3_;Addr[3][3])
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
            column(acadyear;acadyear)
            {
            }
            column(Sems;Sems)
            {
            }
            column(From100Legend;'A (70% - 100%)        - Excellent         B (60% - 69%)      - Good       C (50% - 59%)     -Satisfactory ')
            {
            }
            column(From40Legend;'D (40% - 49%)                - Fair                 E (39% and Below)   - Fail')
            {
            }
            column(PassMarkLegend;'NOTE:   Pass mark is 40%')
            {
            }
            column(DoubleLine;'===============================================================================')
            {
            }
            column(Recomm;'Recommendation:')
            {
            }
            column(singleLine;'===============================================================================')
            {
            }
            column(signedSignature;'Signed......................................................')
            {
            }
            column(codDept;'(COD, '+SchoolName+')')
            {
            }
            column(dateSigned;'Date:.......................................................')
            {
            }
            column(RegAcadLabel;'Registrar, Academic Affairs')
            {
            }
            column(Pictures;controlInfo.Picture)
            {
            }
            column(ColumnNo;ColumnNo)
            {
            }
            column(visible1;visible1)
            {
            }

            trigger OnAfterGetRecord()
            begin
                 // ExamProcess.UpdateCourseReg("Course Registration"."Student No.","Course Registration".Programme,"Course Registration".Stage,"Course Registration".Semester);
                 visible1:=false;
                  if "ACA-Course Registration"."Academic Year"<> acadyear then
                 CurrReport.Skip;
                 if "ACA-Course Registration".Semester<>Sems then
                 CurrReport.Skip;
                 Clear(SchoolName);
                 if prog.Get("ACA-Course Registration".Programme) then begin
                 pName:=prog.Description;
                  dimVal.Reset;
                  dimVal.SetRange(dimVal."Dimension Code",'SCHOOL');
                  dimVal.SetRange(dimVal.Code,prog."School Code");
                  if dimVal.Find('-') then begin
                   SchoolName:=dimVal.Name;
                  end;
                  end;
                
                Clear(YearOfStudy);
                ProgrammeStages.Reset;
                ProgrammeStages.SetRange(ProgrammeStages."Programme Code","ACA-Course Registration".Programme);
                ProgrammeStages.SetRange(ProgrammeStages.Code,"ACA-Course Registration".Stage);
                if ProgrammeStages.Find('-') then
                YearOfStudy:= ProgrammeStages.Description;
                
                
                Clear(sName);
                Clear(YearOfAdmi);
                cust.Reset;
                cust.SetRange(cust."No.","ACA-Course Registration"."Student No.");
                if cust.Find('-') then begin
                   sName:=cust.Name;
                   YearOfAdmi:=cust."Class Code";
                end;
                
                
                RecordNo := RecordNo + 1;
                ColumnNo := ColumnNo + 1;
                
                Addr[ColumnNo][1] := Format("ACA-Course Registration"."Student No.");
                if Customer.Get("ACA-Course Registration"."Student No.") then Addr[ColumnNo][2] := Format(Customer.Name);
                Addr[ColumnNo][3] := Format(pName);
                Addr[ColumnNo][4] := Format("ACA-Course Registration".Stage);
                
                
                /*Addr[ColumnNo][2] := FORMAT(Name);
                Addr[ColumnNo][3] := FORMAT(Customer."Meal Card Valid From");
                Addr[ColumnNo][4] := FORMAT(Customer."Meal Card Valid To");*/
                
                
                
                CompressArray(Addr[ColumnNo]);
                
                if RecordNo = NoOfRecords then begin
                  for i := ColumnNo + 1 to NoOfColumns do
                    Clear(Addr[i]);
                  ColumnNo := 0;
                end else begin
                  if ColumnNo = NoOfColumns then
                    ColumnNo := 0;
                end;
                
                if ((ColumnNo=1) or (ColumnNo=2)) then CurrReport.Skip

            end;

            trigger OnPostDataItem()
            begin
                 // ExamProcess.UpdateCourseReg("Course Registration"."Student No.","Course Registration".Programme,"Course Registration".Stage,"Course Registration".Semester);
            end;

            trigger OnPreDataItem()
            begin
                NoOfRecords := Count;
                NoOfColumns := 3;
                visible1:=false;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(acadYears;acadyear)
                {
                    ApplicationArea = Basic;
                    Caption = 'Academic Year';
                    TableRelation = "ACA-Academic Year".Code;
                }
                field(semsz;Sems)
                {
                    ApplicationArea = Basic;
                    Caption = 'Semester';
                    TableRelation = "ACA-Semesters".Code;
                }
            }
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
            if acadyear='' then Error('Please specify the academic year.');
            if Sems='' then Error('Please specify the Semester.');

        controlInfo.Reset;
        if controlInfo.Find('-') then
        controlInfo.CalcFields(Picture);
    end;

    var
        ProgrammeStages: Record UnknownRecord61516;
        pName: Text[250];
        units_Subjects: Record UnknownRecord61517;
        YearOfStudy: Code[50];
        YearOfAdmi: Code[50];
        SchoolName: Text[250];
        ExamProcess: Codeunit "Exams Processing";
        EResults: Record UnknownRecord61548;
        UnitsR: Record UnknownRecord61517;
        "Units/Subj": Record UnknownRecord61517;
        Sem: Record UnknownRecord61692;
        StudUnits: Record UnknownRecord61549;
        stduntz: Record UnknownRecord61549;
        TotalCatMarks: Decimal;
        TotalCatContributions: Decimal;
        TotalMainExamContributions: Decimal;
        TotalExamMark: Decimal;
        FinalExamMark: Decimal;
        FinalCATMarks: Decimal;
        Gradez: Code[10];
        TotalMarks: Decimal;
        Gradings: Record UnknownRecord61599;
        LastGrade: Code[20];
        LastScore: Decimal;
        ExitDo: Boolean;
        Gradings2: Record UnknownRecord61599;
        Gradeaqq2: Code[10];
        TotMarks: Decimal;
        sName: Code[250];
        cust: Record Customer;
        acadyear: Code[20];
        Sems: Code[20];
        prog: Record UnknownRecord61511;
        dimVal: Record "Dimension Value";
        Addr: array [3,4] of Text[250];
        NoOfRecords: Integer;
        RecordNo: Integer;
        NoOfColumns: Integer;
        ColumnNo: Integer;
        i: Integer;
        controlInfo: Record "Company Information";
        Customer: Record Customer;
        visible1: Boolean;
}

