#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51774 "Examination Cards"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Examination Cards.rdlc';

    dataset
    {
        dataitem(UnknownTable61532;UnknownTable61532)
        {
            DataItemTableView = where(Reversed=const(No));
            RequestFilterFields = "Student No.",Programme,Stage,Semester,"Register for";
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
                IncludeCaption = true;
            }
            column(sName;txtNames)
            {
            }
            column(pName;PName)
            {
            }
            column(Addr_1_1_;Addr[1][1])
            {
            }
            column(Addr_1_5_;Addr[1][5])
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
            column(Addr_2_5_;Addr[2][5])
            {
            }
            column(Addr_2_3_;Addr[2][3])
            {
            }
            column(YearOfStudy;YearOfStudy)
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
            column(UnitsTaken_CourseRegistration;"ACA-Course Registration"."Units Taken")
            {
            }
            column(Name2;col2Names)
            {
            }
            column(Name1;col1Names)
            {
            }
            column(StudNo2;col2StudNo)
            {
            }
            column(StudNo1;col1StudNo)
            {
            }
            column(TakenUnits1;txUnits1)
            {
            }
            column(TakenUnits2;txUnits2)
            {
            }
            column(ProgName1;col1Programme)
            {
            }
            column(ProgName2;col2Programme)
            {
            }
            column(U1;u1[1])
            {
            }
            column(U2;u2[1])
            {
            }
            column(StudUnitsCode;StudUnitsCode)
            {
            }
            dataitem(UnknownTable61549;UnknownTable61549)
            {
                DataItemLink = "Student No."=field("Student No."),Semester=field(Semester),Stage=field(Stage),"Register for"=field("Register for");
                column(ReportForNavId_35; 35)
                {
                }
                column(Unit_StudentUnits;"ACA-Student Units".Unit)
                {
                }

                trigger OnAfterGetRecord()
                begin
                     StudUnitsCode:=StudUnitsCode+"ACA-Student Units".Unit+',';
                end;
            }

            trigger OnAfterGetRecord()
            begin
                 acadyear:="ACA-Course Registration"."Academic Year";
                 Sems:="ACA-Course Registration".Semester;
                 Clear(SchoolName);
                 Clear(u1[1]);
                 Clear(u2[1]);
                 StudUnitsCode:='';

                 if Prog.Get("ACA-Course Registration".Programme) then begin
                 PName:=Prog.Description;
                  dimVal.Reset;
                  dimVal.SetRange(dimVal."Dimension Code",'SCHOOL');
                  dimVal.SetRange(dimVal.Code,Prog."School Code");
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


                j:=j+1;

                if recCustomer.Get("ACA-Course Registration"."Student No.") then
                begin
                  txtNames:=UpperCase(recCustomer.Name);
                  recCustomer.CalcFields(recCustomer."Balance (LCY)");
                  bal:=recCustomer."Balance (LCY)";
                  bal:=0;
                end;

                if (bal>0) then begin
                CurrReport.Skip;
                end;

                if (bal>0)and(j<studCount) then
                begin
                  CurrReport.Skip;
                end
                else
                begin

                i:=i+1;

                col2StudNo:='';
                col2Programme:='';
                col2Faculty:='';
                col2Names:='';
                col2Bal:=0;
                studStageSem2:='';

                recProgramme.SetRange(recProgramme.Code,"ACA-Course Registration".Programme);
                if recProgramme.Find('-') then
                begin
                  txtProgramme:=recProgramme.Description;
                  FacultyCode:=recProgramme.Faculty;
                end;

                recFaculty.SetRange(recFaculty.Code,FacultyCode);
                if recFaculty.Find('-') then
                  txtFaculty:=recFaculty.Name;

                if i MOD 2=1 then
                begin
                  if j=studCount then
                  begin
                    col1StudNo:="ACA-Course Registration"."Student No.";
                    col1Programme:=txtProgramme;
                    col1Faculty:=txtFaculty;
                    col1Names:=txtNames;
                    col1Bal:=bal;
                    txUnits1:="ACA-Course Registration"."Units Taken";
                    studStageSem:='Stage: '+"ACA-Course Registration".Stage+'  Semester: '+"ACA-Course Registration".Semester;

                    for k:=1 to 10 do begin
                    u1[k]:='';
                    end;

                    k:=1;
                    StudUnits.Reset;
                    StudUnits.SetRange(StudUnits.Programme,"ACA-Course Registration".Programme);
                    StudUnits.SetRange(StudUnits.Stage,"ACA-Course Registration".Stage);
                    StudUnits.SetRange(StudUnits.Semester,"ACA-Course Registration".Semester);
                    StudUnits.SetRange(StudUnits."Student No.",col1StudNo);
                    if StudUnits.Find('-') then begin
                    repeat
                    if k<11 then begin
                    StudUnits.CalcFields(StudUnits."Unit Description");
                    u1[1]:=u1[1]+StudUnits.Unit+',';
                    k:=k+1;
                    end;
                    until StudUnits.Next=0;
                    end;

                  end
                  else
                  begin
                    col1StudNo:="ACA-Course Registration"."Student No.";
                    col1Programme:=txtProgramme;
                    col1Faculty:=txtFaculty;
                    col1Names:=txtNames;
                    col1Bal:=bal;
                    txUnits1:="ACA-Course Registration"."Units Taken";
                    studStageSem:='Stage: '+"ACA-Course Registration".Stage+'  Semester: '+"ACA-Course Registration".Semester;
                    k:=1;
                    StudUnits.Reset;
                    StudUnits.SetRange(StudUnits.Programme,"ACA-Course Registration".Programme);
                    StudUnits.SetRange(StudUnits.Stage,"ACA-Course Registration".Stage);
                    StudUnits.SetRange(StudUnits.Semester,"ACA-Course Registration".Semester);
                    StudUnits.SetRange(StudUnits."Student No.",col1StudNo);
                    if StudUnits.Find('-') then begin
                    repeat
                    if k<11 then begin
                    StudUnits.CalcFields(StudUnits."Unit Description");
                    u1[1]:=u1[1]+StudUnits.Unit+',';
                    k:=k+1;
                    end;
                    until StudUnits.Next=0;
                    end;

                    CurrReport.Skip;
                  end;
                end
                else
                begin
                if bal<=0 then
                begin

                  col2StudNo:="ACA-Course Registration"."Student No.";
                  col2Programme:=txtProgramme;
                  col2Faculty:=txtFaculty;
                  col2Names:=txtNames;
                  col2Bal:=bal;
                  txUnits2:="ACA-Course Registration"."Units Taken";
                  studStageSem2:='Stage: '+"ACA-Course Registration".Stage+'  Semester: '+"ACA-Course Registration".Semester;
                    for k:=1 to 10 do begin
                    u2[k]:='';
                    end;

                    k:=1;
                    StudUnits.Reset;
                    StudUnits.SetRange(StudUnits.Programme,"ACA-Course Registration".Programme);
                    StudUnits.SetRange(StudUnits.Stage,"ACA-Course Registration".Stage);
                    StudUnits.SetRange(StudUnits.Semester,"ACA-Course Registration".Semester);
                    StudUnits.SetRange(StudUnits."Student No.",col2StudNo);
                    if StudUnits.Find('-') then begin
                    repeat
                    if k<11 then begin
                    StudUnits.CalcFields(StudUnits."Unit Description");
                    u2[1]:=u2[1]+StudUnits.Unit+',';
                    k:=k+1;
                    end;
                    until StudUnits.Next=0;
                    end;

                end;
                end;
                end;
            end;

            trigger OnPostDataItem()
            begin
                 // ExamProcess.UpdateCourseReg("Course Registration"."Student No.","Course Registration".Programme,"Course Registration".Stage,"Course Registration".Semester);
            end;

            trigger OnPreDataItem()
            begin

                studCount:="ACA-Course Registration".Count;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
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
           // IF acadyear='' THEN ERROR('Please specify the academic year.');
          //  IF Sems='' THEN ERROR('Please specify the Semester.');

        controlInfo.Reset;
        if controlInfo.Find('-') then
        controlInfo.CalcFields(Picture);
    end;

    var
        col1StudNo: Code[20];
        col1Programme: Text[100];
        col1Faculty: Text[100];
        col1Names: Text[50];
        col1Bal: Decimal;
        col2StudNo: Code[20];
        col2Programme: Text[100];
        col2Faculty: Text[100];
        col2Names: Text[50];
        col2Bal: Decimal;
        i: Integer;
        j: Integer;
        studCount: Integer;
        recProgramme: Record UnknownRecord61511;
        txtProgramme: Text[100];
        recFaculty: Record "Dimension Value";
        txtFaculty: Text[100];
        FacultyCode: Code[20];
        txtNames: Text[50];
        recCustomer: Record Customer;
        bal: Decimal;
        studStageSem: Code[50];
        studStageSem2: Code[50];
        u1: array [20] of Text[100];
        StudUnits: Record UnknownRecord61549;
        k: Integer;
        u2: array [20] of Text[100];
        controlInfo: Record "Company Information";
        acadyear: Code[50];
        Sems: Text[50];
        SchoolName: Text[50];
        Prog: Record UnknownRecord61511;
        PName: Text[100];
        dimVal: Record "Dimension Value";
        YearOfStudy: Text[100];
        ProgrammeStages: Record UnknownRecord61516;
        Addr: array [2,6] of Integer;
        txUnits1: Integer;
        txUnits2: Integer;
        StudUnitsCode: Text[1000];
}

