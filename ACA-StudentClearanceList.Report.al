#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 69001 "ACA-Student Clearance List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/ACA-Student Clearance List.rdlc';

    dataset
    {
        dataitem(Customer;Customer)
        {
            RequestFilterFields = "Clearance Status","Clearance Initiated Date","Clearance Semester","Clearance Academic Year";
            column(ReportForNavId_1000000000; 1000000000)
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
            column(Gender;Format(Customer.Gender))
            {
            }
            column(No;Customer."No.")
            {
            }
            column(Name;Customer.Name)
            {
            }
            column(stdType;courseRegst."Student Type")
            {
            }
            column(Phone_No;Customer."Phone No.")
            {
            }
            column(regStatus;regStatus)
            {
            }
            column(Progcode;Programmes.Description)
            {
            }
            column(CustFilters;Customer.GetFilters)
            {
            }
            column(ClearStatus;Customer."Clearance Status")
            {
            }
            column(ClearInitiateDate;Customer."Clearance Initiated Date")
            {
            }

            trigger OnAfterGetRecord()
            begin
                CourseReg.Reset;
                CourseReg.SetRange("Student No.",Customer."No.");
                if CourseReg.Find('-') then begin
                    Programmes.Reset;
                  Programmes.SetRange(Code,CourseReg.Programme);
                  if Programmes.Find('-') then;
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
        //  IF Semesters='' THEN ERROR('Please Specify the Semester.');
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

