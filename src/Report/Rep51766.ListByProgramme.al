#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51766 "List By Programme"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/List By Programme.rdlc';

    dataset
    {
        dataitem(UnknownTable61532;UnknownTable61532)
        {
            column(ReportForNavId_1; 1)
            {
            }
            column(Title1;'STUDENT LIST BY PROGRAMME,  '+Format(Semesters))
            {
            }
            column(pic;CompanyInfo.Picture)
            {
            }
            column("Count";cou)
            {
            }
            column(Gender;Format(Cust.Gender))
            {
            }
            column(No;Cust."No.")
            {
            }
            column(Name;Cust.Name)
            {
            }
            column(stdType;courseRegst."Student Type")
            {
            }
            column(Phone_No;Cust."Phone No.")
            {
            }
            column(stage;"ACA-Course Registration".Stage)
            {
            }
            column(RegDate;"ACA-Course Registration"."Registration Date")
            {
            }
            column(BottomLabel;'')
            {
            }
            column(regStatus;regStatus)
            {
            }
            column(Progcode;Progcode)
            {
            }
            column(setType;"ACA-Course Registration"."Settlement Type")
            {
            }

            trigger OnAfterGetRecord()
            begin
                // if "Course Registration".Semester<>Semesters then "Course Registration"."Academic Year"
                Clear(Progcode);
                prog1.Reset;
                prog1.SetRange(prog1.Code,"ACA-Course Registration".Programme);
                if prog1.Find('-') then begin
                  Progcode:=prog1.Code+': '+prog1.Description;
                end;


                   Clear(regStatus);
                  customers1.Reset;
                 customers1.SetRange(customers1."No.","ACA-Course Registration"."Student No.");
                 if customers1.Find('-') then begin
                  regStatus:=Format(customers1.Status);
                 end;
                bal:=0;
                stud.Reset;
                stud.SetRange(stud."No.","ACA-Course Registration"."Student No.");
                if stud.Find('-') then begin
                stud.CalcFields(stud."Balance (LCY)");
                bal:=stud."Balance (LCY)";
                end;


                            Info.Reset;
                if Info.Find('-') then
                  Info.CalcFields(Picture);

                Display:=true;
                Disp:=true;
                //IF "Course Registration".Stage='Y1S1' THEN Display:=FALSE;
                if "ACA-Course Registration".Stage=' ' then Disp:=false;


                sems.Reset;
                sems.SetRange(sems."Current Semester", true);
                if sems.Find('-') then
                  begin
                  sFound:=true;
                  end;

                acadYear.Reset;
                acadYear.SetRange(acadYear.Current,true);
                if acadYear.Find('-') then begin
                sFound:=true;
                end;

                Cust.Reset;
                Cust.SetRange(Cust."No.","ACA-Course Registration"."Student No.");
                if Cust.Find('-') then
                begin
                sFound:=true;
                GEND:='';
                if Cust.Gender=0 then begin
                GEND:='MALE';
                TotalMale:=TotalMale+1;
                end else
                if Cust.Gender=1 then begin
                 GEND:='FEMALE';
                 TotalFEMale:=TotalFEMale+1;
                end;
                end;

                courseRegst.Reset;
                courseRegst.SetRange(courseRegst."Reg. Transacton ID","ACA-Course Registration"."Reg. Transacton ID");
                //IF StudType<>StudType::" " THEN
                //courseRegst.SETRANGE(courseRegst."Student Type",StudType);
                if acaYear<>'' then
                courseRegst.SetRange(courseRegst."Academic Year",Format(acaYear));
                if Semesters<>'' then
                courseRegst.SetRange(courseRegst.Semester,Format(Semesters));
                //IF stages=stages::"New Students" THEN
                //courseRegst.SETFILTER(courseRegst.Stage,'=Y1S1')
                //ELSE IF stages=stages::"Continuing Students" THEN
                //courseRegst.SETFILTER(courseRegst.Stage,'<>Y1S1');
                //IF campCode<>'' THEN
                //courseRegst.SETRANGE(courseRegst."Campus Code",FORMAT(campCode));
                //IF Genders<>Genders::"BOTH GENDER" THEN
                //IF Genders=Genders::Male THEN
                //courseRegst.SETRANGE(courseRegst.Gender,courseRegst.Gender::Male)
                //ELSE IF Genders=Genders::Female THEN
                //courseRegst.SETRANGE(courseRegst.Gender,courseRegst.Gender::Female);

                if  courseRegst.Find('-')=false  then
                Disp:=false;



                if ((Display=true) and (Disp=true)) then begin
                cou:=cou+1;
                //CurrReport.SHOWOUTPUT(TRUE);
                end
                else begin
                CurrReport.Skip;
                end;
            end;

            trigger OnPreDataItem()
            begin
                SetCurrentkey("Settlement Type","Student No.")
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

    trigger OnPostReport()
    begin
           if Info.Get() then begin
            Info."Last Semester Filter":=Semesters;
            Info.Modify;

           end;
    end;

    trigger OnPreReport()
    begin

         // IF acaYear='' THEN ERROR('Please Specify the Academic Year.');
          if Semesters='' then Error('Please Specify the Semester.');
           cou:=0;

        constLine:='==================================================================================================';
        Clear(TotalFEMale);
        Clear(TotalMale);

         CompanyInfo.Reset;
         if CompanyInfo.Find('-') then begin
         CompanyInfo.CalcFields(Picture);
         end;
    end;

    var
        cust3: Record Customer;
        customers1: Record Customer;
        regStatus: Code[50];
        TotalMale: Integer;
        TotalFEMale: Integer;
        campCode: Code[10];
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
        StudType: Option " ","Full Time","Part Time","Distance Learning","School Based";
        CourseReg: Record UnknownRecord61532;
        Info: Record "Company Information";
        CompanyInfo: Record "Company Information";
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
        stages: Option "New Students","Continuing Students",All;
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
        Progcode: Text[250];
        prog1: Record UnknownRecord61511;
}

