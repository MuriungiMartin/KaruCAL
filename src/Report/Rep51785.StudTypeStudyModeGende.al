#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51785 "Stud Type, Study Mode & Gende"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Stud Type, Study Mode & Gende.rdlc';

    dataset
    {
        dataitem(UnknownTable61511;UnknownTable61511)
        {
            column(ReportForNavId_1; 1)
            {
            }
            column(pic;Info.Picture)
            {
            }
            column(Title1;'STUDENT POPULATION BY PROGRAMME, STUDENT TYPE, STUDY MODE AND GENDER AS AT '+Format(Today,0,4)+ ', '+Semesters)
            {
            }
            column(ProgDesc;"ACA-Programme".Code+': '+"ACA-Programme".Description)
            {
            }
            column(SSPMaleFull;PSSPMaleFull)
            {
            }
            column(SSPFemaleFull;PSSPFemaleFull)
            {
            }
            column(SSPTotalFull;PSSPTotalFull)
            {
            }
            column(SSPMalePart;PSSPMalePart)
            {
            }
            column(SSPFemalePart;PSSPFemalePart)
            {
            }
            column(SSPTotalPart;PSSPTotalPart)
            {
            }
            column(GOKMaleFull;KUCCPSMaleFull)
            {
            }
            column(GOKFemaleFull;KUCCPSFemaleFull)
            {
            }
            column(GOKTotalFull;KUCCPSTotalFull)
            {
            }
            column(GOKMalePart;KUCCPSMalePart)
            {
            }
            column(GOKFemalePart;KUCCPSFemalePart)
            {
            }
            column(GOKTotalPart;KUCCPSTotalPart)
            {
            }
            column(ProgMaleTotal;ProgMaleTotal)
            {
            }
            column(ProgFemaleTotal;ProgFemaleTotal)
            {
            }
            column(ProgGrandTotal;ProgGrandTotal)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Clear(PSSPMaleFull);
                Clear(PSSPFemaleFull);
                Clear(PSSPTotalFull);
                Clear(PSSPMalePart);
                Clear(PSSPFemalePart);
                Clear(PSSPTotalPart);
                Clear(KUCCPSMaleFull);
                Clear(KUCCPSFemaleFull);
                Clear(KUCCPSTotalFull);
                Clear(KUCCPSMalePart);
                Clear(KUCCPSFemalePart);
                Clear(KUCCPSTotalPart);
                Clear(ProgMaleTotal);
                Clear(ProgFemaleTotal);
                Clear(ProgGrandTotal);
                Clear(studnumber);
                CourseReg.Reset;
                CourseReg.SetRange(CourseReg.Programme,"ACA-Programme".Code);
                if acaYear<>'' then
                  CourseReg.SetRange(CourseReg."Academic Year",acaYear);
                if Semesters<>'' then
                  CourseReg.SetRange(CourseReg.Semester,Semesters);
                if CourseReg.Find('-') then
                begin
                repeat
                  begin
                  CourseReg.CalcFields(CourseReg.Gender);
                    if ((CourseReg.Gender = CourseReg.Gender::Male) and (CourseReg."Settlement Type"='PSSP') and
                    (CourseReg."Student Type"=CourseReg."student type"::"Full Time")) then begin
                    PSSPMaleFull:=PSSPMaleFull+1;
                    PSSPTotalFull:=PSSPTotalFull+1;
                    ProgMaleTotal:=ProgMaleTotal+1;
                    end;

                    if ((CourseReg.Gender = CourseReg.Gender::Female) and (CourseReg."Settlement Type"='PSSP') and
                    (CourseReg."Student Type"=CourseReg."student type"::"Full Time")) then begin
                    PSSPFemaleFull:=PSSPFemaleFull+1;
                    PSSPTotalFull:=PSSPTotalFull+1;
                    ProgFemaleTotal:=ProgFemaleTotal+1;
                    end;

                    if ((CourseReg.Gender = CourseReg.Gender::Male) and (CourseReg."Settlement Type"='PSSP') and
                    (CourseReg."Student Type"=CourseReg."student type"::"School-Based")) then begin
                    PSSPMalePart:=PSSPMalePart+1;
                    PSSPTotalPart:=PSSPTotalPart+1;
                    ProgMaleTotal:=ProgMaleTotal+1;
                    end;

                    if ((CourseReg.Gender = CourseReg.Gender::Female) and (CourseReg."Settlement Type"='PSSP') and
                    (CourseReg."Student Type"=CourseReg."student type"::"School-Based")) then begin
                    PSSPFemalePart:=PSSPFemalePart+1;
                    PSSPTotalPart:=PSSPTotalPart+1;
                    ProgFemaleTotal:=ProgFemaleTotal+1;
                    end;


                    if ((CourseReg.Gender = CourseReg.Gender::Male) and (CourseReg."Settlement Type"='KUCCPS') and
                    (CourseReg."Student Type"=CourseReg."student type"::"Full Time")) then begin
                    KUCCPSMaleFull:=KUCCPSMaleFull+1;
                    KUCCPSTotalFull:=KUCCPSTotalFull+1;
                    ProgMaleTotal:=ProgMaleTotal+1;
                    end;

                    if ((CourseReg.Gender = CourseReg.Gender::Female) and (CourseReg."Settlement Type"='KUCCPS') and
                    (CourseReg."Student Type"=CourseReg."student type"::"Full Time")) then begin
                    KUCCPSFemaleFull:=KUCCPSFemaleFull+1;
                    KUCCPSTotalFull:=KUCCPSTotalFull+1;
                    ProgFemaleTotal:=ProgFemaleTotal+1;
                    end;

                    if ((CourseReg.Gender = CourseReg.Gender::Male) and (CourseReg."Settlement Type"='KUCCPS') and
                    (CourseReg."Student Type"=CourseReg."student type"::"School-Based")) then begin
                    KUCCPSMalePart:=KUCCPSMalePart+1;
                    KUCCPSTotalPart:=KUCCPSTotalPart+1;
                    ProgMaleTotal:=ProgMaleTotal+1;
                    end;

                    if ((CourseReg.Gender = CourseReg.Gender::Female) and (CourseReg."Settlement Type"='KUCCPS') and
                    (CourseReg."Student Type"=CourseReg."student type"::"School-Based")) then begin
                    KUCCPSFemalePart:=KUCCPSFemalePart+1;
                    KUCCPSTotalPart:=KUCCPSTotalPart+1;
                    ProgFemaleTotal:=ProgFemaleTotal+1;
                    end;
                    //  studnumber:=CourseReg.COUNT;
                  ProgGrandTotal:=ProgGrandTotal+1;

                  end;
                until CourseReg.Next =0;
                end;

                //IF CourseReg.FIND('-') THEN BEGIN
                //  studnumber:=CourseReg.COUNT;
                //  ProgGrandTotal:=studnumber;
                //END;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(AcadYear;acaYear)
                {
                    ApplicationArea = Basic;
                    Caption = 'Academic Year:';
                    TableRelation = "ACA-Academic Year".Code;
                }
                field(Semz;Semesters)
                {
                    ApplicationArea = Basic;
                    Caption = 'Semester:';
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

          if acaYear='' then Error('Please Specify the Academic Year.');
          if Semesters='' then Error('Please Specify the Semester.');
           cou:=0;
           Clear(overaltotal);

         Info.Reset;
         if Info.Find('-') then begin
         Info.CalcFields(Picture);
         end;
    end;

    var
        overaltotal: Integer;
        studnumber: Integer;
        strgs: Code[20];
        progys: Code[20];
        intk: Code[20];
        TotalMale: Integer;
        TotalFEMale: Integer;
        campCode: Code[20];
        Genders: Option "BOTH GENDER",Male,Female;
        Names: Text[250];
        Cust: Record Customer;
        Prog: Text[250];
        Stage: Text[250];
        Unit: Text[250];
        Sem: Text[250];
        Programmes: Record UnknownRecord61511;
        ProgStage: Record UnknownRecord61516;
        "Unit/Subjects": Record UnknownRecord61517;
        Semeters: Record UnknownRecord61518;
        Hesabu: Integer;
        StudFilter: Code[10];
        StudType: Option " ",Boarder,Dayscholar,"Distance Learning","School Based";
        CourseReg: Record UnknownRecord61532;
        Info: Record "Company Information";
        sems: Record UnknownRecord61518;
        acadYear: Record UnknownRecord61382;
        sFound: Boolean;
        GEND: Text[30];
        Display: Boolean;
        Disp: Boolean;
        cou: Integer;
        acaYear: Code[50];
        Semesters: Code[50];
        courseRegst: Record UnknownRecord61532;
        stages: Option " ","New Students","Continuing Students","All Stages";
        bal: Decimal;
        stud: Record Customer;
        constLine: Text[250];
        Text000: label 'Period: %1';
        Text001: label 'NORMINAL ROLE';
        Text002: label 'NORMINAL ROLE';
        Text003: label 'Reg. No.';
        Text004: label 'Phone No.';
        Text005: label 'Company Name';
        Text006: label 'Report No.';
        Text007: label 'Report Name';
        Text008: label 'User ID';
        Text009: label 'Date';
        Text010: label 'G/L Filter';
        Text011: label 'Period Filter';
        Text012: label 'Gender';
        Text013: label 'Mode of Study';
        Text014: label 'Total Amount';
        Text015: label 'Name';
        Text016: label 'Reg. Date';
        Text017: label 'Stage';
        Text020: label 'ACAD. YEAR';
        Text021: label 'STAGE';
        Text022: label 'STUD. TYPE';
        Text023: label 'SEMESTER';
        Text024: label '--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------';
        PSSPMaleFull: Integer;
        PSSPFemaleFull: Integer;
        PSSPTotalFull: Integer;
        PSSPMalePart: Integer;
        PSSPFemalePart: Integer;
        PSSPTotalPart: Integer;
        KUCCPSMaleFull: Integer;
        KUCCPSFemaleFull: Integer;
        KUCCPSTotalFull: Integer;
        KUCCPSMalePart: Integer;
        KUCCPSFemalePart: Integer;
        KUCCPSTotalPart: Integer;
        ProgMaleTotal: Integer;
        ProgFemaleTotal: Integer;
        ProgGrandTotal: Integer;
}

