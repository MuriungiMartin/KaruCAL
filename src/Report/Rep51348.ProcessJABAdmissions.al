#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51348 "Process JAB Admissions"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(KUCCPSIMports;UnknownTable70082)
        {
            column(ReportForNavId_2111; 2111)
            {
            }

            trigger OnAfterGetRecord()
            var
                strNames: Text[100];
            begin
                /*This function processes the JAB admission and takes them to the Applications list*/
                
                      SettlementType.Get(KUCCPSIMports."Settlement Type");
                      Applications.Init;
                Applications."Application No.":=KUCCPSIMports.Index;
                Applications.Date:=Today;
                //SplitNames(Names,Applications.Surname,Applications."Other Names");
                Applications.Surname:=KUCCPSIMports.Names;
                Applications."Application Date":=Today;
                Applications.Gender:=KUCCPSIMports.Gender-1;
                Applications."Marital Status":=Applications."marital status"::Single;
                Applications.Nationality:='KENYAN';
                
                Applications."Address for Correspondence1":=KUCCPSIMports.Box;
                Applications."Address for Correspondence2":=KUCCPSIMports.Codes;
                Applications."Address for Correspondence3":=KUCCPSIMports.Town;
                Applications."Telephone No. 1":=KUCCPSIMports.Phone;
                Applications."Telephone No. 2":=KUCCPSIMports."Alt. Phone";
                Applications.Email:=KUCCPSIMports.Email;
                Applications."Emergency Email":=KUCCPSIMports."Slt Mail";
                Applications."Country of Origin":='KENYA';
                Applications."First Degree Choice":=KUCCPSIMports.Prog;
                Applications."Date of Receipt":=Today;
                Applications."User ID":=UserId;
                Applications."Date of Admission":=Today;
                Applications."Application Form Receipt No.":='';
                Applications."Index Number":=KUCCPSIMports.Index;
                Applications.Status:=Applications.Status::"Provisional Admission";
                Applications."Admission Board Recommendation":='Admitted Through '+KUCCPSIMports."Settlement Type";
                Applications."Admission Board Date":=Today;
                Applications."Admission Board Time":=Time;
                Applications."Admitted Degree":=KUCCPSIMports.Prog;
                Applications."Date Of Meeting":=Today;
                Applications."Date Of Receipt Slip":=Today;
                Applications."Receipt Slip No.":='';
                Applications."Academic Year":=KUCCPSIMports."Academic Year";
                Applications."Admission No":=KUCCPSIMports.Admin;
                Applications."Admitted To Stage":='Y1S1';
                Applications."Admitted Semester":=semester;
                Applications."First Choice Stage":='Y1S1';
                Applications."First Choice Semester":=semester;
                Applications."Intake Code":=Intake;
                Applications."Settlement Type":=KUCCPSIMports."Settlement Type";
                Applications."ID Number":=KUCCPSIMports."ID Number/BirthCert";
                Applications."Date Sent for Approval":=Today;
                Applications."Issued Date":=Today;
                Applications.Campus:='MAIN';
                Applications."Admissable Status":='QUALIFY';
                Applications."Mode of Study":='FULL TIME';
                Applications."Responsibility Center":='MAIN';
                Applications."First Choice Qualify":=true;
                Applications."Programme Level":=Applications."programme level"::Undergraduate;
                Applications."Admission Comments":='Admitted through the '+KUCCPSIMports."Settlement Type";
                Applications."Knew College Thru":=KUCCPSIMports."Settlement Type";
                Applications."First Choice Category":=Applications."first choice category"::Undergraduate;
                Applications."Date Of Birth":=KUCCPSIMports."Date of Birth";
                Applications.County:=KUCCPSIMports.County;
                Applications.Phone:=KUCCPSIMports.Phone;
                Applications."Alt. Phone":= KUCCPSIMports."Alt. Phone";
                Applications.Box:= KUCCPSIMports.Box;
                Applications.Town:= KUCCPSIMports.Town;
                Applications."NHIF No":= KUCCPSIMports."NHIF No";
                Applications.Location:= KUCCPSIMports.Location;
                Applications."Name of Chief":= KUCCPSIMports."Name of Chief";
                Applications."Sub-County":= KUCCPSIMports."Sub-County";
                Applications.Constituency:= KUCCPSIMports.Constituency;
                Applications."OLevel School":= KUCCPSIMports."OLevel School";
                Applications."OLevel Year Completed":= KUCCPSIMports."OLevel Year Completed";
                Applications."Documents Verification Remarks":='OK';
                Applications."Documents Verified":=false;
                Applications."Medical Verified":=true;
                if Applications.Insert then;
                KUCCPSIMports.Processed:=true;
                KUCCPSIMports.Modify;

            end;

            trigger OnPreDataItem()
            begin
                //LastFieldNo := FIELDNO("Line No.");
                if Year='' then Error('Please specify the academic year');
                if Intake='' then Error('Please specify the intake code');
                if semester='' then Error('Please specify the Semester');
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(Year;Year)
                {
                    ApplicationArea = Basic;
                    Caption = 'Academic Year';
                    Lookup = true;
                    TableRelation = "ACA-Academic Year".Code;
                }
                field(Intake;Intake)
                {
                    ApplicationArea = Basic;
                    Caption = 'Intake';
                    TableRelation = "ACA-Intake".Code;
                }
                field(semester;semester)
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

    trigger OnInitReport()
    begin
        acadYears.Reset;
        acadYears.SetRange(acadYears.Current,true);
        sems.Reset;
        sems.SetRange(sems."Current Semester",true);
        Intakes.Reset;
        Intakes.SetRange(Intakes.Current,true);
        if acadYears.Find('-') then Year:=acadYears.Code;
        if sems.Find('-') then semester:=sems.Code;
        if Intakes.Find('-') then Intake:=Intakes.Code;

        CompanyInformation.Reset;
        if CompanyInformation.Find('-') then begin
          end;
    end;

    trigger OnPostReport()
    begin
        Message('Processed Successfully');
    end;

    trigger OnPreReport()
    begin
        if Year='' then
          begin
            Error('Academic Year Missing');
          end;
    end;

    var
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        AdminSetup: Record UnknownRecord61371;
        AdminCode: Code[20];
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Applications: Record UnknownRecord61358;
        Year: Code[20];
        LineNo: Integer;
        SettlementType: Record UnknownRecord61522;
        Intake: Code[20];
        semester: Code[20];
        Processed_JAB_AdmissionsCaptionLbl: label 'Processed JAB Admissions';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        acadYears: Record UnknownRecord61382;
        Intakes: Record UnknownRecord61383;
        sems: Record UnknownRecord61692;
        CompanyInformation: Record "Company Information";
        SirNamez: Code[100];
        OtherNamez: Code[100];
}

