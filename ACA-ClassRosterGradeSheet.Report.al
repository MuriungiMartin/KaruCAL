#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51799 "ACA-Class Roster Grade Sheet"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/ACA-Class Roster Grade Sheet.rdlc';

    dataset
    {
        dataitem(UnknownTable61517;UnknownTable61517)
        {
            DataItemTableView = sorting(Code,"Programme Code","Stage Code","Entry No") order(ascending);
            PrintOnlyIfDetail = true;
            column(ReportForNavId_1000000021; 1000000021)
            {
            }
            dataitem(UnknownTable61549;UnknownTable61549)
            {
                DataItemLink = Programme=field("Programme Code"),Unit=field(Code);
                RequestFilterFields = Programme,Stage,Unit,"Student No.";
                column(ReportForNavId_1000000000; 1000000000)
                {
                }
                column(Lect;"ACA-Student Units".Lecturer)
                {
                }
                column(UName;"ACA-Student Units"."Unit Description")
                {
                }
                column(UCode;"ACA-Student Units".Unit)
                {
                }
                column(acadY;acadyear)
                {
                }
                column(semz;Sems)
                {
                }
                column(CHours;"ACA-Student Units"."Credit Hours")
                {
                }
                column(Dept;Dept)
                {
                }
                column(PName;PName)
                {
                }
                column(sCount;SCount)
                {
                }
                column(sNo;"ACA-Student Units"."Student No.")
                {
                }
                column(sName;"ACA-Student Units"."Student Name")
                {
                }
                column(ASS1;"ACA-Student Units"."CAT-1")
                {
                }
                column(ASS2;"ACA-Student Units"."CAT-2")
                {
                }
                column(CAT1;"ACA-Student Units"."CAT-1")
                {
                }
                column(CAT2;"ACA-Student Units"."CAT-2")
                {
                }
                column(TTCATS;"ACA-Student Units"."CAT-1"+"ACA-Student Units"."CAT-2")
                {
                }
                column(TTExam;"ACA-Student Units"."EXAMs Marks")
                {
                }
                column(TTCATS_Exam;"ACA-Student Units"."EXAMs Marks"+"ACA-Student Units"."CAT-1"+"ACA-Student Units"."CAT-2")
                {
                }
                column(Grade;"ACA-Student Units".Grade)
                {
                }
                column(Remarks;"ACA-Student Units".Remarks)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    Clear(PName);
                    Clear(FDesc);
                    Clear(Dept);
                    SCount:=SCount+1;
                    if Prog.Get("ACA-Student Units".Programme) then begin
                    PName:=Prog.Description;
                    if FacultyR.Get(Prog.Faculty) then
                    FDesc:=FacultyR.Description;

                    DValue.Reset;
                    DValue.SetRange(DValue.Code,Prog.Department);
                    if DValue.Find('-') then
                    Dept:=DValue.Name;

                    end;

                    // Pick the Units Names Here
                    if not headerDone_1 then begin
                    Clear(Column_H);
                    Clear(TColumn_V);
                    Clear(uColumn_V);
                    Clear(i);
                       studentsUnits.Reset;
                       studentsUnits.SetRange(studentsUnits."Student No.","ACA-Student Units"."Student No.");
                       studentsUnits.SetRange(studentsUnits.Semester,Sems);
                       //studentsUnits.SETRANGE(studentsUnits."Academic Year",acadyear);
                       studentsUnits.SetRange(studentsUnits.Unit,"ACA-Student Units".Unit);
                       if studentsUnits.Find('-') then begin
                         repeat
                          begin
                             Clear(UnitHeaderSet_1);
                             counts:=0;
                            repeat
                            begin
                            counts:=counts+1;
                            if Column_H[counts]=studentsUnits.Unit then UnitHeaderSet_1:=true;
                            end;
                            until counts=ArrayLen(Column_H);
                            i:=i+1;
                            if UnitHeaderSet_1=false then begin
                              Column_H[i]:=studentsUnits.Unit;

                    // Lecturer Name Here
                    lectUnits.Reset;
                    lectUnits.SetRange(lectUnits.Programme,"ACA-Student Units".Programme);
                    lectUnits.SetRange(lectUnits.Unit,"ACA-Student Units".Unit);
                    if lectUnits.Find('-') then begin
                      uColumn_V[i]:=lectUnits.Lecturer;
                      if uColumn_V[i]<>'' then begin
                        if employee.Get(uColumn_V[i]) then begin
                        uColumn_V[i]:='';
                          if employee."First Name"<>'' then uColumn_V[i]:=employee."First Name";
                          if uColumn_V[i]<>'' then begin
                            if employee."Middle Name"<>'' then uColumn_V[i]:=uColumn_V[i]+' '+employee."Middle Name";
                            end
                          else begin if employee."Middle Name"<>'' then  uColumn_V[i]:=employee."Middle Name"; end;

                          if uColumn_V[i]<>'' then  begin
                            if employee."Last Name"<>'' then uColumn_V[i]:=uColumn_V[i]+' '+employee."Last Name";
                            end
                          else begin if employee."Last Name"<>'' then  uColumn_V[i]:=employee."Last Name";   end;

                        end;
                      end;
                    end;
                              // Calculate the UnitMean and MeanGrade Here
                            //  Tcolumn_V[i]:=ROUND(Tcolumn_V[i],0.01,'=');
                            //  ucolumn_V[i]:=GetGrade(totalMarks,"Course Registration".Programme);
                            end;
                          end;
                         until studentsUnits.Next = 0;
                       end;
                    end; // Not headerDone
                end;

                trigger OnPreDataItem()
                begin
                       // "ACA-Student Units".SETRANGE("ACA-Student Units"."Academic Year",acadyear);
                        "ACA-Student Units".SetRange("ACA-Student Units".Semester,Sems);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                 Clear(SCount)
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
        //IF acadyear='' THEN ERROR('Specify the Academic Year on the Options Tab.');
        if Sems ='' then Error('Specify the Semester on the Options Tab.');
    end;

    var
        headerDone_1: Boolean;
        UnitHeaderSet_1: Boolean;
        employee: Record UnknownRecord61188;
        lectUnits: Record UnknownRecord61541;
        Column_H: array [300] of Text[100];
        Column_V: array [300] of Text[30];
        TColumn_V: array [300] of Text;
        uColumn_V: array [300] of Text[30];
        sColumn_V: array [300] of Text[30];
        totalMarks: Decimal;
        totStudents: Integer;
        stdUnits: Record UnknownRecord61549;
        counts: Integer;
        headerDone: Boolean;
        UnitHeaderSet: Boolean;
        sName: Text[200];
        cummAverage: Decimal;
        SemAverage: Decimal;
        semGrade: Code[2];
        semGPA2: Decimal;
        creg2: Record UnknownRecord61532;
        PastSemPoints: Decimal;
        PastSemHours: Decimal;
        CummGPA2: Decimal;
        intK: Integer;
        studentsUnits: Record UnknownRecord61549;
        scores: array [50] of Code[20];
        headerPrinted: Boolean;
        COUTZS: Integer;
        acadyear: Code[20];
        Sems: Code[20];
        cummGPA: Decimal;
        SemGPA: Decimal;
        Cust: Record Customer;
        Charges: Record UnknownRecord61515;
        ColumnH: array [300] of Text[100];
        ColumnV: array [300] of Text[30];
        i: Integer;
        TColumnV: array [300] of Decimal;
        SCount: Integer;
        UnitsR: Record UnknownRecord61517;
        uColumnV: array [300] of Text[30];
        sColumnV: array [300] of Text[30];
        Prog: Record UnknownRecord61511;
        Stages: Record UnknownRecord61516;
        RFound: Boolean;
        UDesc: Text[200];
        Units: Record UnknownRecord61517;
        Result: Decimal;
        Grade: Text[150];
        Remarks: Text[150];
        Gradings: Record UnknownRecord61599;
        Gradings2: Record UnknownRecord61599;
        TotalScore: Decimal;
        LastGrade: Code[20];
        LastScore: Decimal;
        ExitDo: Boolean;
        Desc: Text[200];
        OScore: Decimal;
        OUnits: Integer;
        MeanScore: Decimal;
        MeanGrade: Code[20];
        LastRemark: Text[200];
        CCat: Text[30];
        TScore: Decimal;
        RUnits: Decimal;
        SkipCount: Integer;
        MissingM: Boolean;
        DValue: Record "Dimension Value";
        FacultyR: Record UnknownRecord61649;
        FDesc: Text[200];
        Dept: Text[200];
        PName: Text[200];
        SDesc: Text[200];
        Comb: Text[200];
        ProgOptions: Record UnknownRecord61554;
        DMarks: Boolean;
        DSummary: Boolean;
        USkip: Boolean;
        CReg: Record UnknownRecord61532;
        UTaken: Integer;
        UPassed: Integer;
        UFailed: Integer;
        MCourse: Boolean;
        ExportToExcel: Boolean;
        constLine: Text[250];
        semesterDesc: Record UnknownRecord61654;
}

