#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51780 "Pop. By Prog./Gender/Settl."
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Pop. By Prog.GenderSettl..rdlc';

    dataset
    {
        dataitem(UnknownTable61511;UnknownTable61511)
        {
            RequestFilterFields = "Stage Filter","Semester Filter","Date Filter";
            column(ReportForNavId_1; 1)
            {
            }
            column(pic;Info.Picture)
            {
            }
            column(Title1;'STUDENT POPULATION BY PROGRAMME - '+Semesters)
            {
            }
            column(progCode;"ACA-Programme".Code)
            {
            }
            column(ProgDesc;"ACA-Programme".Description)
            {
            }
            column(StudNo;"ACA-Programme"."Student Registered")
            {
            }
            column(stageFilter;GetFilter("ACA-Programme"."Stage Filter"))
            {
            }
            column(datefilter;GetFilter("ACA-Programme"."Date Filter"))
            {
            }
            column(totMale;"ACA-Programme"."Male Count")
            {
            }
            column(TotFemale;"ACA-Programme"."Female Count")
            {
            }
            column(totJabFemale;"ACA-Programme"."Total JAB Female")
            {
            }
            column(TotJabMale;"ACA-Programme"."Total JAB Male")
            {
            }
            column(TotSSPFemale;"ACA-Programme"."Total SSP Female")
            {
            }
            column(TotSSPMale;"ACA-Programme"."Total SSP Male")
            {
            }
            column(TotJab;"ACA-Programme"."Admissions JAB")
            {
            }
            column(TotSSP;"ACA-Programme"."Admissions SSP")
            {
            }

            trigger OnAfterGetRecord()
            begin
                 CalcFields("ACA-Programme"."Student Registered","ACA-Programme"."Admissions SSP","ACA-Programme"."Admissions JAB","ACA-Programme"."Tuition Fees",
                 "ACA-Programme"."Total SSP Male","ACA-Programme"."Total SSP Female","ACA-Programme"."Total JAB Male","ACA-Programme"."Total JAB Female");
                
                
                Clear(studnumber);
                //"Course Registration".CALCFIELDS("Course Registration".Gender);
                /*
                CourseReg.RESET;
                CourseReg.SETRANGE(CourseReg.Programme,Programme.Code);
                IF CourseReg.FIND('-') THEN
                BEGIN
                IF Genders=1 THEN BEGIN
                  CourseReg.SETRANGE(CourseReg.Gender,CourseReg.Gender::Male);
                END;
                
                IF Genders=2 THEN BEGIN
                 CourseReg.SETRANGE(CourseReg.Gender,CourseReg.Gender::Female);
                END;
                
                IF campCode<>'' THEN BEGIN
                  CourseReg.SETRANGE(CourseReg."Campus Code",campCode);
                END;
                
                END;
                
                //IF intk<>'' THEN BEGIN
                //  CourseReg.SETRANGE(CourseReg.Intake,intk);
                //END;
                
                
                IF acaYear<>'' THEN
                  CourseReg.SETRANGE(CourseReg."Academic Year",acaYear);
                IF Semesters<>'' THEN
                  CourseReg.SETRANGE(CourseReg.Semester,Semesters);
                
                IF CourseReg.FIND('-') THEN BEGIN
                  studnumber:=CourseReg.COUNT;
                  overaltotal:=overaltotal+CourseReg.COUNT;
                END;
                */
                studnumber:="ACA-Programme"."Student Registered";
                
                if studnumber=0 then CurrReport.Skip;

            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
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

    trigger OnInitReport()
    begin
           if Info.Get() then Semesters:=Info."Last Semester Filter";
    end;

    trigger OnPreReport()
    begin

         // IF acaYear='' THEN ERROR('Please Specify the Academic Year.');
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
}

